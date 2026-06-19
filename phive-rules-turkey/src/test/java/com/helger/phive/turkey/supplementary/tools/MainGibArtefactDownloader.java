/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
 * philip[at]helger[dot]com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.helger.phive.turkey.supplementary.tools;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.jspecify.annotations.NonNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.datetime.helper.PDTFactory;

/**
 * Tool that fetches the GİB e-Fatura legislation index page, downloads every artefact (PDF / ZIP /
 * RAR) it links to, stores them in <code>phive-rules-turkey/docs/</code>, and writes a
 * <code>latest-release.md</code> summary that includes the most recent date found in
 * <code>e-FaturaPaketi/schematron/History.txt</code>.
 * <p>
 * Two ways to run:
 * <ul>
 * <li>Standalone: invoke {@link #main(String[])} from an IDE while the <em>working directory</em>
 * is the <code>phive-rules-turkey</code> module (so the relative path <code>docs/</code>
 * resolves).</li>
 * <li>Via Maven (opt-in): <code>mvn -pl phive-rules-turkey test -Dtest=GibArtefactDownloader
 * -Dgib.download=true -DfailIfNoTests=false</code>. Some test is skipped unless the system property
 * <code>gib.download=true</code> is set.</li>
 * </ul>
 * The tool is intentionally test-scoped so it does not ship in the artefact JAR and does not
 * require network access during normal test runs.
 *
 * @author Philip Helger
 */
public final class MainGibArtefactDownloader
{
  /** Per-artefact download outcome recorded for the summary. */
  private static final record Result (String filename,
                                      String url,
                                      int statusCode,
                                      long sizeBytes,
                                      String lastModified,
                                      String action)
  {}

  private static final Logger LOGGER = LoggerFactory.getLogger (MainGibArtefactDownloader.class);
  private static final String PAGE_URL = "https://ebelge.gib.gov.tr/efaturamevzuat.html";

  /** Matches every <code>href="/dosyalar/...pdf|zip|rar"</code> in the index page. */
  private static final Pattern LINK_RE = Pattern.compile ("href\\s*=\\s*\"(/dosyalar/[^\"]+\\.(?:pdf|zip|rar))\"",
                                                          Pattern.CASE_INSENSITIVE);

  /** Matches a YYYYMMDD line in <code>schematron/History.txt</code>. */
  private static final Pattern HISTORY_DATE_RE = Pattern.compile ("^(20\\d{6})\\s*$", Pattern.MULTILINE);

  // Public no-arg constructor required for JUnit. Use main() or runIfRequested() — there is no
  // useful instance state.
  public MainGibArtefactDownloader ()
  {}

  /**
   * Run the downloader. Working directory must be the <code>phive-rules-turkey</code> module
   * (because <code>docs/</code> is resolved relatively).
   *
   * @param args
   *        Commandline args
   * @throws Exception
   *         in case of error
   */
  public static void main (final String [] args) throws Exception
  {
    _runUpdate ();
  }

  private static void _runUpdate () throws Exception
  {
    final Path aDocs = Paths.get ("docs").toAbsolutePath ().normalize ();
    if (!Files.isDirectory (aDocs))
      throw new IllegalStateException ("docs/ folder not found at " +
                                       aDocs +
                                       " — run this tool from the phive-rules-turkey module directory.");

    final HttpClient aHttp = HttpClient.newBuilder ()
                                       .followRedirects (HttpClient.Redirect.NORMAL)
                                       .connectTimeout (Duration.ofSeconds (30))
                                       .build ();

    LOGGER.info ("Fetching " + PAGE_URL);
    final HttpResponse <String> aPage = aHttp.send (HttpRequest.newBuilder (URI.create (PAGE_URL)).GET ().build (),
                                                    HttpResponse.BodyHandlers.ofString (StandardCharsets.UTF_8));
    if (aPage.statusCode () != 200)
      throw new IllegalStateException ("HTTP " + aPage.statusCode () + " for " + PAGE_URL);

    // Deduplicate links across the whole page (some files appear twice in the HTML)
    final SortedSet <String> aPaths = new TreeSet <> ();
    final Matcher m = LINK_RE.matcher (aPage.body ());
    while (m.find ())
      aPaths.add (m.group (1));

    LOGGER.info ("Found " + aPaths.size () + " artefact link(s).");

    final List <Result> aResults = new ArrayList <> ();
    for (final String sPath : aPaths)
      aResults.add (_downloadOne (aHttp, sPath, aDocs));

    // Latest schematron release date (parsed from inside the zip — avoids re-extracting the
    // archive to disk).
    final String sLatestDate = _readLatestReleaseDate (aDocs.resolve ("e-FaturaPaketi.zip"));
    LOGGER.info ("Latest schematron release date: " + sLatestDate);

    _writeReleaseSummary (aDocs.resolve ("latest-release.md"), sLatestDate, aResults);
    LOGGER.info ("Wrote " + aDocs.resolve ("latest-release.md"));
  }

  private static Result _downloadOne (final HttpClient aHttp, final String sPath, final Path aDocs) throws Exception
  {
    // URI(scheme, host, path, fragment) percent-encodes spaces and other illegal chars in the path
    // — necessary because a few links in the GİB page contain literal spaces and parens.
    final URI aURI = new URI ("https", "ebelge.gib.gov.tr", sPath, null);
    final String sFilename = sPath.substring (sPath.lastIndexOf ('/') + 1);
    final Path aTarget = aDocs.resolve (sFilename);

    // HEAD first — gets size and Last-Modified without pulling the body. Cheap detection of stale
    // links and silent updates.
    final HttpResponse <Void> aHead = aHttp.send (HttpRequest.newBuilder (aURI)
                                                             .method ("HEAD", HttpRequest.BodyPublishers.noBody ())
                                                             .build (), HttpResponse.BodyHandlers.discarding ());

    if (aHead.statusCode () < 200 || aHead.statusCode () >= 300)
    {
      LOGGER.info ("  GONE       " + sFilename + "  (HTTP " + aHead.statusCode () + ")");
      return new Result (sFilename, aURI.toString (), aHead.statusCode (), 0, "", "GONE");
    }

    final long nRemoteSize = aHead.headers ().firstValueAsLong ("Content-Length").orElse (-1);
    final String sLastModified = aHead.headers ().firstValue ("Last-Modified").orElse ("");

    String sAction;
    if (!Files.exists (aTarget))
      sAction = "NEW";
    else
      if (Files.size (aTarget) != nRemoteSize)
        sAction = "UPDATED";
      else
        sAction = "UP-TO-DATE";

    if (!"UP-TO-DATE".equals (sAction))
    {
      final HttpResponse <Path> aDownload = aHttp.send (HttpRequest.newBuilder (aURI).GET ().build (),
                                                        HttpResponse.BodyHandlers.ofFile (aTarget));
      if (aDownload.statusCode () != 200)
        sAction = "FAILED-" + aDownload.statusCode ();
    }

    LOGGER.info ("  [" + sAction + "] " + sFilename + "  (" + nRemoteSize + " bytes)");
    return new Result (sFilename, aURI.toString (), aHead.statusCode (), nRemoteSize, sLastModified, sAction);
  }

  /**
   * Reads <code>schematron/History.txt</code> directly from <code>e-FaturaPaketi.zip</code>, scans
   * for <code>YYYYMMDD</code> headings and returns the largest one (lexicographic order works for
   * 8-digit dates). Returns a placeholder string if the zip or entry is not present.
   */
  @NonNull
  private static String _readLatestReleaseDate (final Path aZipPath) throws IOException
  {
    if (!Files.exists (aZipPath))
      return "(e-FaturaPaketi.zip not present)";

    // The zip stores filenames in CP437 (legacy zip default) — Java's UTF-8 default barfs on the
    // Turkish non-ASCII entry names with "Zip invalid CEN header". Forcing CP437 reads them.
    try (final ZipFile aZip = new ZipFile (aZipPath.toFile (), Charset.forName ("CP437")))
    {
      ZipEntry aEntry = null;
      for (final Enumeration <? extends ZipEntry> e = aZip.entries (); e.hasMoreElements ();)
      {
        final ZipEntry ze = e.nextElement ();
        if (ze.getName ().endsWith ("schematron/History.txt"))
        {
          aEntry = ze;
          break;
        }
      }
      if (aEntry == null)
        return "(History.txt not found inside zip)";

      // History.txt is CP1254 (Turkish) — but we only scan for ASCII digit lines, so any
      // ASCII-superset works. UTF-8 with replacement still matches the YYYYMMDD pattern fine.
      try (final InputStream aIS = aZip.getInputStream (aEntry))
      {
        final String sText = new String (aIS.readAllBytes (), Charset.forName ("windows-1254"));
        String sLatest = "";
        final Matcher mDate = HISTORY_DATE_RE.matcher (sText);
        while (mDate.find ())
          if (mDate.group (1).compareTo (sLatest) > 0)
            sLatest = mDate.group (1);
        return sLatest.isEmpty () ? "(no YYYYMMDD entries found)" : sLatest;
      }
    }
  }

  private static void _writeReleaseSummary (final Path aTarget, final String sLatestDate, final List <Result> aResults)
                                                                                                                        throws IOException
  {
    final StringBuilder aSB = new StringBuilder ();
    aSB.append ("# GİB e-Fatura — latest release snapshot\n\n");
    aSB.append ("Generated automatically by `GibArtefactDownloader` (test-scoped tool in phive-rules-turkey).\n\n");
    aSB.append ("- Source page: <").append (PAGE_URL).append (">\n");
    aSB.append ("- Snapshot taken: ").append (PDTFactory.getCurrentOffsetDateTime ()).append ("\n");
    aSB.append ("- Latest Schematron release (from `e-FaturaPaketi/schematron/History.txt`): **")
       .append (sLatestDate)
       .append ("**\n\n");

    int nNew = 0;
    int nUpd = 0;
    int nSame = 0;
    int nGone = 0;
    for (final Result r : aResults)
    {
      switch (r.action)
      {
        case "NEW":
          nNew++;
          break;
        case "UPDATED":
          nUpd++;
          break;
        case "UP-TO-DATE":
          nSame++;
          break;
        case "GONE":
          nGone++;
          break;
        default:
          break;
      }
    }
    aSB.append ("Summary: ")
       .append (nNew)
       .append (" new, ")
       .append (nUpd)
       .append (" updated, ")
       .append (nSame)
       .append (" up-to-date, ")
       .append (nGone)
       .append (" gone (404 on server).\n\n");

    aSB.append ("## Artefacts (").append (aResults.size ()).append (")\n\n");
    aSB.append ("| Status | Filename | Status code | Size (bytes) | Last-Modified |\n");
    aSB.append ("|---|---|---|---:|---|\n");
    for (final Result r : aResults)
      aSB.append ("| ")
         .append (r.action)
         .append (" | [")
         .append (r.filename)
         .append ("](")
         .append (r.url)
         .append (") | ")
         .append (Integer.toString (r.statusCode))
         .append (" | ")
         .append (r.sizeBytes < 0 ? "?" : Long.toString (r.sizeBytes))
         .append (" | ")
         .append (r.lastModified.isEmpty () ? "—" : r.lastModified)
         .append (" |\n");

    Files.writeString (aTarget, aSB.toString (), StandardCharsets.UTF_8);
  }
}
