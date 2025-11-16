/*
 * Copyright (C) 2020-2025 Philip Helger (www.helger.com)
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
package com.helger.phive.fatturapa.mock;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.Nonempty;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;

public enum FatturaPATestFiles
{
  V120 ("/external/test-files/120/good/",
        new String [] { "IT01234567890_FPA01.xml",
                        "IT01234567890_FPA02.xml",
                        "IT01234567890_FPA03.xml",
                        "IT01234567890_FPR01.xml",
                        "IT01234567890_FPR02.xml",
                        "IT01234567890_FPR03.xml" }),
  V121 ("/external/test-files/121/good/",
        new String [] { "IT01234567890_FPA01.xml",
                        "IT01234567890_FPA02.xml",
                        "IT01234567890_FPA03.xml",
                        "IT01234567890_FPR01.xml",
                        "IT01234567890_FPR02.xml",
                        "IT01234567890_FPR03.xml" }),
  V122 ("/external/test-files/122/good/",
        new String [] { "IT01234567890_FPA01.xml",
                        "IT01234567890_FPA02.xml",
                        "IT01234567890_FPA03.xml",
                        "IT01234567890_FPR01.xml",
                        "IT01234567890_FPR02.xml",
                        "IT01234567890_FPR03.xml" });

  private final ICommonsList <IReadableResource> m_aTestFiles = new CommonsArrayList <> ();

  FatturaPATestFiles (final String sBaseDir, final String [] aFiles)
  {
    for (final String sFile : aFiles)
      m_aTestFiles.add (new ClassPathResource (sBaseDir + sFile));
  }

  @NonNull
  @Nonempty
  @ReturnsMutableCopy
  public ICommonsList <IReadableResource> getTestResources ()
  {
    return m_aTestFiles.getClone ();
  }
}
