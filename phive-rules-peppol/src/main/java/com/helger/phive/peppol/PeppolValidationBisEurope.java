/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.Nonempty;
import com.helger.commons.datetime.PDTFactory;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Peppol BIS Europe validation configuration
 *
 * @author Philip Helger
 * @since 3.2.2
 */
@SuppressWarnings ("deprecation")
@Immutable
public final class PeppolValidationBisEurope
{
  private PeppolValidationBisEurope ()
  {}

  /**
   * @return The currently active version number, dependent on the current date.
   *         Never <code>null</code>.
   */
  @Nonnull
  @Nonempty
  public static String getVersionToUse ()
  {
    final LocalDate aNow = PDTFactory.getCurrentLocalDate ();
    if (aNow.isBefore (PeppolValidation2024_11.VALID_PER))
    {
      // Previous version
      return PeppolValidation2024_05.VERSION_STR;
    }
    // Latest version
    return PeppolValidation2024_11.VERSION_STR;
  }

  // @SuppressWarnings ("deprecation")
  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    PeppolValidation2024_05.init (aRegistry);
    PeppolValidation2024_11.init (aRegistry);
    PeppolValidation2025_03.init (aRegistry);
  }
}
