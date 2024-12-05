/*
 * Copyright (C) 2024 Philip Helger (www.helger.com)
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
package com.helger.phive.zugferd;

import javax.annotation.Nonnull;

import com.helger.commons.annotation.Nonempty;

/**
 * Contains a list of all Zugferd profiles.
 *
 * @author Philip Helger
 */
public enum EZugferdProfile
{
  MINIMUM ("minimum", "minimum", "MINIMUM", "MINIMUM"),
  BASIC_WL ("basicwl", "basicwl", "BASICWL", "BASIC WL"),
  BASIC ("basic", "basic", "BASIC", "BASIC"),
  EN16931 ("en16931", "en16931", "EN16931", "EN 16931"),
  EXTENDED ("extended", "extended", "EXTENDED", "EXTENDED");

  private final String m_sArtifactID;
  private final String m_sFolderName;
  private final String m_sFilenameSuffix;
  private final String m_sDisplayName;

  EZugferdProfile (@Nonnull @Nonempty final String sArtifactID,
                   @Nonnull @Nonempty final String sFolderName,
                   @Nonnull @Nonempty final String sFilenameSuffix,
                   @Nonnull @Nonempty final String sDisplayName)
  {
    m_sArtifactID = sArtifactID;
    m_sFolderName = sFolderName;
    m_sFilenameSuffix = sFilenameSuffix;
    m_sDisplayName = sDisplayName;
  }

  @Nonnull
  @Nonempty
  public String getArtifactID ()
  {
    return m_sArtifactID;
  }

  @Nonnull
  @Nonempty
  public String getFolderName ()
  {
    return m_sFolderName;
  }

  @Nonnull
  @Nonempty
  public String getFilenameSuffix ()
  {
    return m_sFilenameSuffix;
  }

  @Nonnull
  @Nonempty
  public String getDisplayName ()
  {
    return m_sDisplayName;
  }
}
