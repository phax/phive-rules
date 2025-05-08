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
import com.helger.commons.io.file.FileOperationManager;
import com.helger.commons.io.file.FileSystemIterator;
import com.helger.commons.io.file.IFileFilter;
import com.helger.phive.zugferd.EZugferdProfile;

public final class MainExtractTestFiles233
{
  private static final Logger LOGGER = LoggerFactory.getLogger (MainExtractTestFiles233.class);

  public static void main (final String [] args)
  {
    // TODO edit the following 2 lines for a new version
    final File fBasePath = new File ("docs/2.3.3/ZF233_EN_01/Examples").getAbsoluteFile ();
    final File fTargetPath = new File ("src/test/resources/external/test-files/2.3.3").getAbsoluteFile ();

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
        // Find the XML files in the folder
        final ICommonsList <File> aXMLFiles = new CommonsArrayList <> (new FileSystemIterator (fExampleFolder).withFilter (IFileFilter.filenameEndsWith (".xml")));
        if (aXMLFiles.size () != 1)
          throw new IllegalStateException ("Expected exactly one XML file in " +
                                           fExampleFolder.getAbsolutePath () +
                                           " but found " +
                                           aXMLFiles.size ());

        final File fExample = aXMLFiles.getFirstOrNull ();
        if (!fExample.isFile ())
          throw new IllegalStateException ();
        // copy file
        FileOperationManager.INSTANCE.copyFile (fExample,
                                                new File (fTargetPath,
                                                          eProfile.getFolderName () +
                                                                       "/factur-x-" +
                                                                       nExampleIndex +
                                                                       ".xml"));
        nExampleIndex++;
        nExampleCount++;
      }
      nProfileIndex++;
    }
    LOGGER.info ("Finished copying " + nExampleCount + " examples");
  }
}
