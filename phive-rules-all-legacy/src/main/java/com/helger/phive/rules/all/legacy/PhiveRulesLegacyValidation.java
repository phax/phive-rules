/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.phive.rules.all.legacy;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.oioubl.OIOUBLLegacyValidation;
import com.helger.phive.peppol.legacy.PeppolLegacyValidationBisAUNZ;
import com.helger.phive.peppol.legacy.PeppolLegacyValidationBisEurope;
import com.helger.phive.peppol.legacy.PeppolLegacyValidationReporting;
import com.helger.phive.peppol.legacy.PeppolLegacyValidationSG;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Convenience class to register the validation execution sets of all legacy phive rules modules in
 * a single call. This is the legacy counterpart to
 * <code>PhiveRulesValidation.initPhiveRules</code>.
 * <p>
 * The legacy sets are based on the EN 16931 validation execution sets. Therefore EN 16931 is
 * registered as a prerequisite, but only if not already present in the registry. This allows this
 * initializer to be used both standalone and on a registry that was already populated via
 * {@code PhiveRulesValidation.initPhiveRules}. When combining both, register the current rules
 * first.
 *
 * @author Philip Helger
 */
@Immutable
public final class PhiveRulesLegacyValidation
{
  private PhiveRulesLegacyValidation ()
  {}

  /**
   * Register all legacy validation execution sets to the provided registry, in the proper order.
   *
   * @param aRegistry
   *        The registry to add the artefacts to. May not be <code>null</code>.
   */
  @SuppressWarnings ("deprecation")
  public static void initPhiveRulesLegacy (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // Prerequisite: the legacy OIOUBL 3.0.1 and legacy Peppol 2025-03 sets are based on the EN
    // 16931
    // VES. Only register EN 16931 if it is not already present (e.g. because
    // PhiveRulesValidation.initPhiveRules was called before on the same registry).
    if (aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_1313) == null)
      EN16931Validation.initEN16931 (aRegistry);

    // Legacy Peppol
    PeppolLegacyValidationBisEurope.init (aRegistry);
    PeppolLegacyValidationBisAUNZ.init (aRegistry);
    PeppolLegacyValidationSG.init (aRegistry);
    PeppolLegacyValidationReporting.init (aRegistry);

    // Legacy OIOUBL
    OIOUBLLegacyValidation.initLegacyOIOUBL (aRegistry);
  }
}
