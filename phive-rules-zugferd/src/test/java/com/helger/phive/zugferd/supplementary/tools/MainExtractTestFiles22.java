/*
 * Copyright (C) 2024-2025 Philip Helger (www.helger.com)
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
package com.helger.phive.zugferd.supplementary.tools;

import java.io.File;
import java.io.IOException;
import java.util.Comparator;
import java.util.Map;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.Nonempty;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.file.FileSystemIterator;
import com.helger.io.file.IFileFilter;
import com.helger.io.file.SimpleFileIO;
import com.helger.phive.zugferd.EZugferdProfile;

import jakarta.annotation.Nonnull;
import jakarta.annotation.Nullable;

public final class MainExtractTestFiles22
{
  private static final Logger LOGGER = LoggerFactory.getLogger (MainExtractTestFiles22.class);

  @Nullable
  private static PDEmbeddedFile _getEmbeddedFile (@Nonnull final PDComplexFileSpecification aFileSpec)
  {
    // search for the first available alternative of the embedded file
    PDEmbeddedFile ret = null;
    if (aFileSpec != null)
    {
      ret = aFileSpec.getEmbeddedFileUnicode ();
      if (ret == null)
      {
        ret = aFileSpec.getEmbeddedFileDos ();
        if (ret == null)
        {
          ret = aFileSpec.getEmbeddedFileMac ();
          if (ret == null)
          {
            ret = aFileSpec.getEmbeddedFileUnix ();
            if (ret == null)
            {
              ret = aFileSpec.getEmbeddedFile ();
            }
          }
        }
      }
    }
    return ret;
  }

  @Nonnull
  private static byte [] _extractFacturX (@Nonnull final Map <String, PDComplexFileSpecification> aNames,
                                          @Nonnull @Nonempty final String sAttachmentFilename) throws IOException
  {
    final PDComplexFileSpecification aFileSpec = aNames.get (sAttachmentFilename);
    if (aFileSpec == null)
      throw new IllegalStateException ("Failed to find '" + sAttachmentFilename + "' in " + aNames.keySet ());

    final PDEmbeddedFile aEmbeddedFile = _getEmbeddedFile (aFileSpec);
    if (aEmbeddedFile == null)
      throw new IllegalStateException ("Failed to resolve embedded file");
    return aEmbeddedFile.toByteArray ();
  }

  @Nullable
  static byte [] extractAttachment (@Nonnull final File fExampleFile, @Nonnull @Nonempty final String sAttachmentFilename)
  {
    try (final PDDocument aPDDoc = Loader.loadPDF (fExampleFile))
    {
      // Global files
      final PDDocumentNameDictionary aNamesDictionary = new PDDocumentNameDictionary (aPDDoc.getDocumentCatalog ());
      final PDEmbeddedFilesNameTreeNode aEmbeddedFiles = aNamesDictionary.getEmbeddedFiles ();
      if (aEmbeddedFiles != null)
      {
        // Direct match?
        var aNames = aEmbeddedFiles.getNames ();
        if (aNames != null)
          return _extractFacturX (aNames, sAttachmentFilename);

        // Kids match?
        for (final var aNode : aEmbeddedFiles.getKids ())
        {
          aNames = aNode.getNames ();
          final byte [] ret = _extractFacturX (aNames, sAttachmentFilename);
          if (ret != null)
            return ret;
        }
      }
    }
    catch (final IOException ex)
    {
      LOGGER.error ("Failed to read PDF", ex);
    }
    return null;
  }

  @Nullable
  static byte [] extractFacturX (@Nonnull final File fExampleFile)
  {
    return extractAttachment (fExampleFile, "factur-x.xml");
  }

  public static void main (final String [] args)
  {
    final File fBasePath = new File ("docs/2.2/zugferd22en/DE/Examples").getAbsoluteFile ();
    final File fTargetPath = new File ("src/test/resources/external/test-files/2.2").getAbsoluteFile ();

    // For all profiles
    int nExampleCount = 0;
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      final ICommonsList <File> aSubDirs = new CommonsArrayList <> (new FileSystemIterator (fBasePath).withFilter (IFileFilter.directoryPublic ()));

      // Search by profile name (2.2)
      final String sSearchName = eProfile == EZugferdProfile.EN16931 ? "EN16931" : eProfile.getDisplayName ();
      final File fExamplesFolder = aSubDirs.findFirst (f -> f.getName ().equals (sSearchName));
      if (fExamplesFolder == null)
        throw new IllegalStateException (eProfile.name ());

      final ICommonsList <File> aExampleFiles = new CommonsArrayList <> (new FileSystemIterator (fExamplesFolder).withFilter (IFileFilter.filenameEndsWith (".pdf")));
      aExampleFiles.sort (Comparator.comparing (File::getName));

      LOGGER.info ("Scanning " + aExampleFiles.size () + " PDF files for " + eProfile.getDisplayName ());

      int nExampleIndex = 1;
      for (final File fExampleFile : aExampleFiles)
      {
        // Extract XML from PDF
        final byte [] aFacturX = extractFacturX (fExampleFile);
        if (aFacturX == null)
          throw new IllegalStateException ();

        // write file
        SimpleFileIO.writeFile (new File (fTargetPath,
                                          eProfile.getFolderName () + "/factur-x-" + nExampleIndex + ".xml"),
                                aFacturX);
        nExampleIndex++;
        nExampleCount++;
      }
    }
    LOGGER.info ("Finished copying " + nExampleCount + " examples");
  }
}
