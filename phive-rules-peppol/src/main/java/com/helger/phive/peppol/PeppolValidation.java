/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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
package com.helger.phive.peppol;

import java.time.LocalDate;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.annotation.Nonempty;
import com.helger.commons.datetime.PDTFactory;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Generic Peppol validation configuration
 *
 * @author Philip Helger
 */
@Immutable
@SuppressWarnings ("deprecation")
public final class PeppolValidation
{
  /**
   * @return The currently active version number, dependent on the current date.
   *         Never <code>null</code>.
   * @since 5.1.8
   */
  @Nonnull
  @Nonempty
  public static String getVersionToUse ()
  {
    final LocalDate aNow = PDTFactory.getCurrentLocalDate ();
    if (aNow.isBefore (PeppolValidation2024_05.VALID_PER))
    {
      // Previous version
      return PeppolValidation2023_11.VERSION_STR;
    }
    // Latest version
    return PeppolValidation2024_05.VERSION_STR;
  }

  private PeppolValidation ()
  {}

  /**
   * Register all standard Peppol validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initStandard (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    PeppolValidation2023_05.init (aRegistry);
    PeppolValidation2023_11.init (aRegistry);
    PeppolValidation2024_05.init (aRegistry);
    PeppolValidationBisAUNZ.init (aRegistry);
    PeppolValidationBisSG.init (aRegistry);
    PeppolValidationDirectory.init (aRegistry);
    PeppolValidationReporting.init (aRegistry);
    PeppolValidationPint.init (aRegistry);
    PeppolValidationPintAUNZ.init (aRegistry);
    PeppolValidationPintJP.init (aRegistry);
    PeppolValidationPintMY.init (aRegistry);
    PeppolValidationPintSG.init (aRegistry);
  }
}
