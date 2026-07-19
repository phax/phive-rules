/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
package com.helger.phive.peppol.pint;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Convenience class to register all OpenPeppol PINT (Peppol International) validation execution sets
 * in a single call.
 *
 * @author Philip Helger
 * @since 4.4.0
 */
@Immutable
public final class PeppolPintValidation
{
  private PeppolPintValidation ()
  {}

  /**
   * Register all OpenPeppol PINT validation execution sets to the provided registry, in the proper
   * order.
   *
   * @param aRegistry
   *        The registry to add the artefacts to. May not be <code>null</code>.
   */
  public static void initPeppolPint (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // The generic PINT rules must be registered first, because the jurisdiction-specific rules are
    // based on them
    PeppolValidationPint.init (aRegistry);
    PeppolValidationPintAE.init (aRegistry);
    PeppolValidationPintAUNZ.init (aRegistry);
    PeppolValidationPintEU.init (aRegistry);
    PeppolValidationPintJP.init (aRegistry);
    PeppolValidationPintJP_NTR.init (aRegistry);
    PeppolValidationPintJP_SB.init (aRegistry);
    PeppolValidationPintMY.init (aRegistry);
    PeppolValidationPintOM.init (aRegistry);
    PeppolValidationPintSG.init (aRegistry);
  }
}
