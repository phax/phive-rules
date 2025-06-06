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
import java.util.Comparator;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.file.FileSystemIterator;
import com.helger.commons.io.file.IFileFilter;
import com.helger.commons.io.file.SimpleFileIO;
import com.helger.phive.zugferd.EZugferdProfile;

public final class MainExtractTestFiles201
{
  private static final Logger LOGGER = LoggerFactory.getLogger (MainExtractTestFiles201.class);

  public static void main (final String [] args)
  {
    final File fBasePath = new File ("docs/2.0.1/zugferd201/ZUGFeRD201/Beispiele").getAbsoluteFile ();
    final File fTargetPath = new File ("src/test/resources/external/test-files/2.0.1").getAbsoluteFile ();

    // For all profiles
    int nExampleCount = 0;
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
      if (eProfile != EZugferdProfile.BASIC_WL)
      {
        final ICommonsList <File> aSubDirs = new CommonsArrayList <> (new FileSystemIterator (fBasePath).withFilter (IFileFilter.directoryPublic ()));

        // Search by profile name (2.1)
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
          final byte [] aFacturX = MainExtractTestFiles22.extractAttachment (fExampleFile, "zugferd-invoice.xml");
          if (aFacturX == null)
            throw new IllegalStateException ();

          // write file
          SimpleFileIO.writeFile (new File (fTargetPath,
                                            eProfile.getFolderName () + "/zugferd-invoice-" + nExampleIndex + ".xml"),
                                  aFacturX);
          nExampleIndex++;
          nExampleCount++;
        }
      }
    LOGGER.info ("Finished copying " + nExampleCount + " examples");
  }
}
