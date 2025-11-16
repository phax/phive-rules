/*
 * Copyright (C) 2025 Philip Helger (www.helger.com)
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
package com.helger.phive.france;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesCIIHelper;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * France CTC validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class FranceCTCValidation
{
  public static final String GROUP_ID = "fr.ctc";

  // v0.1
  public static final DVRCoordinate VID_FR_CTC_UBL_INV_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "ubl-invoice",
                                                                                                "0.1");
  public static final DVRCoordinate VID_FR_CTC_UBL_CN_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "ubl-creditnote",
                                                                                               "0.1");
  public static final DVRCoordinate VID_FR_CTC_CII_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", "0.1");

  private FranceCTCValidation ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return FranceCTCValidation.class.getClassLoader ();
  }

  /**
   * Register all standard France CTC validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initFranceCTC (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bNotDeprecated = false;

    final String sPrefix = "/external/schematron/ctc/";

    // CTC 0.1
    {
      final String sPrefix0 = sPrefix + "0.1/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FR_CTC_UBL_INV_0_1,
                                                                             "France CTC Invoice " +
                                                                                                     VID_FR_CTC_UBL_INV_0_1.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                                                          "20250731_BR-FR-Flux2-Schematron-UBL_V0.1.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FR_CTC_UBL_CN_0_1,
                                                                             "France CTC Credit Note " +
                                                                                                    VID_FR_CTC_UBL_CN_0_1.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                                                          "20250731_BR-FR-Flux2-Schematron-UBL_V0.1.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FR_CTC_CII_0_1,
                                                                             "France CTC CII " +
                                                                                                 VID_FR_CTC_CII_0_1.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix0 +
                                                                                                                                             "20250731_BR-FR-Flux2-Schematron-CII_V0.1.xslt",
                                                                                                                                             _getCL ()))));
    }
  }
}
