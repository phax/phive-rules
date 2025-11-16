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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Generic Peppol validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidation
{
  /**
   * @return The currently active version number, dependent on the current date. Never
   *         <code>null</code>.
   * @deprecated Use the version from {@link PeppolValidationBisEurope}
   */
  @NonNull
  @Nonempty
  @Deprecated (forRemoval = true, since = "3.2.2")
  public static String getVersionToUse ()
  {
    return PeppolValidationBisEurope.getVersionToUse ();
  }

  private PeppolValidation ()
  {}

  /**
   * Register all standard Peppol validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initStandard (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    PeppolValidationBisEurope.init (aRegistry);
    PeppolValidationBisAUNZ.init (aRegistry);
    PeppolValidationBisSG.init (aRegistry);
    PeppolValidationDirectory.init (aRegistry);
    PeppolValidationMLS.init (aRegistry);
    PeppolValidationReporting.init (aRegistry);
    PeppolValidationPint.init (aRegistry);
    PeppolValidationPintAE.init (aRegistry);
    PeppolValidationPintAUNZ.init (aRegistry);
    PeppolValidationPintEU.init (aRegistry);
    PeppolValidationPintJP.init (aRegistry);
    PeppolValidationPintJP_NTR.init (aRegistry);
    PeppolValidationPintJP_SB.init (aRegistry);
    PeppolValidationPintMY.init (aRegistry);
    PeppolValidationPintSG.init (aRegistry);
  }
}
