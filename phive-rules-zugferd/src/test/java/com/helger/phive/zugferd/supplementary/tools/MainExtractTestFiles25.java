/*
 * Copyright (C) 2024-2026 Philip Helger (www.helger.com)
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

import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.file.FileOperationManager;
import com.helger.io.file.FileSystemIterator;
import com.helger.io.file.IFileFilter;
import com.helger.phive.zugferd.EZugferdProfile;

public final class MainExtractTestFiles25
{
  private static final Logger LOGGER = LoggerFactory.getLogger (MainExtractTestFiles25.class);

  public static void main (final String [] args)
  {
    // TODO edit the following 2 lines for a new version
    final File fBasePath = new File ("docs/2.5/DE_extracted/Beispiele").getAbsoluteFile ();
    final File fTargetPath = new File ("src/test/resources/external/test-files/2.5").getAbsoluteFile ();

    // For all profiles
    int nProfileIndex = 0;
    int nExampleCount = 0;
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      // Find the example folder based on the profile index :-/
      final String sFolderNameStart = nProfileIndex + ". ";
      final File fExamplesFolder = new CommonsArrayList <> (new FileSystemIterator (fBasePath).withFilter (IFileFilter.directoryPublic ())).findFirst (f -> f.getName ()
                                                                                                                                                             .startsWith (sFolderNameStart));
      if (!fExamplesFolder.isDirectory ())
        throw new IllegalStateException ("Failed to find example folder for profile " + eProfile);

      final ICommonsList <File> aExampleFolders = new CommonsArrayList <> (new FileSystemIterator (fExamplesFolder).withFilter (IFileFilter.directoryPublic ()));
      aExampleFolders.sort (Comparator.comparing (File::getName));

      int nExampleIndex = 1;
      for (final File fExampleFolder : aExampleFolders)
      {
        // Find the XML files in the folder (excluding generated report XMLs)
        final ICommonsList <File> aXMLFiles = new CommonsArrayList <> (new FileSystemIterator (fExampleFolder).withFilter (IFileFilter.filenameEndsWith (".xml")));
        aXMLFiles.sort (Comparator.comparing (File::getName));
        for (final File fExample : aXMLFiles)
        {
          if (!fExample.isFile ())
            throw new IllegalStateException ();

          final String sName = fExample.getName ();
          if (sName.endsWith ("_fx_validation_report.xml") || sName.endsWith ("_analyzed-content.xml"))
          {
            // Skip generated report files
            continue;
          }

          // copy file
          final File fTarget = new File (fTargetPath,
                                         eProfile.getFolderName () + "/factur-x-" + nExampleIndex + ".xml");
          FileOperationManager.INSTANCE.deleteFileIfExisting (fTarget);
          FileOperationManager.INSTANCE.copyFile (fExample, fTarget);

          nExampleIndex++;
          nExampleCount++;
        }
      }
      nProfileIndex++;
    }
    LOGGER.info ("Finished copying " + nExampleCount + " examples");
  }
}
