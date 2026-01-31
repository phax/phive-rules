/*
 * Copyright (C) 2025-2026 Philip Helger (www.helger.com)
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
import com.helger.cii.d22b.CCIID22B;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesCIIHelper;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;

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
  @Deprecated
  public static final DVRCoordinate VID_FR_CTC_UBL_INV_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "ubl-invoice",
                                                                                                "0.1");
  @Deprecated
  public static final DVRCoordinate VID_FR_CTC_UBL_CN_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "ubl-creditnote",
                                                                                               "0.1");
  @Deprecated
  public static final DVRCoordinate VID_FR_CTC_CII_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", "0.1");

  // v1.2.0
  public static final DVRCoordinate VID_FR_CTC_UBL_INV_1_2_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "ubl-invoice",
                                                                                                  "1.2.0");
  public static final DVRCoordinate VID_FR_CTC_UBL_CN_1_2_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 "1.2.0");
  public static final DVRCoordinate VID_FR_CTC_CII_1_2_0 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", "1.2.0");
  public static final DVRCoordinate VID_FR_CTC_CDAR_1_2_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cdar",
                                                                                               "1.2.0");

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

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = !bDeprecated;

    final String sPrefix = "/external/schematron/ctc/";

    // CTC 0.1
    {
      final String sPrefix0 = sPrefix + "0.1/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FR_CTC_UBL_INV_0_1,
                                                                             "France CTC Invoice " +
                                                                                                     VID_FR_CTC_UBL_INV_0_1.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                                                          "20250731_BR-FR-Flux2-Schematron-UBL_V0.1.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FR_CTC_UBL_CN_0_1,
                                                                             "France CTC Credit Note " +
                                                                                                    VID_FR_CTC_UBL_CN_0_1.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                                                          "20250731_BR-FR-Flux2-Schematron-UBL_V0.1.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FR_CTC_CII_0_1,
                                                                             "France CTC CII " +
                                                                                                 VID_FR_CTC_CII_0_1.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID22B.getXSDResourceCII ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                                                             "20250731_BR-FR-Flux2-Schematron-CII_V0.1.xslt",
                                                                                                                                             _getCL ()))));
    }

    // CTC 1.2.0
    {
      final String sPrefix0 = sPrefix + "1.2.0/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FR_CTC_UBL_INV_1_2_0,
                                                                             "France CTC Invoice " +
                                                                                                       VID_FR_CTC_UBL_INV_1_2_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                                                          "20251114_BR-FR-Flux2-Schematron-UBL_V1.2.0.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FR_CTC_UBL_CN_1_2_0,
                                                                             "France CTC Credit Note " +
                                                                                                      VID_FR_CTC_UBL_CN_1_2_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                                                          "20251114_BR-FR-Flux2-Schematron-UBL_V1.2.0.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FR_CTC_CII_1_2_0,
                                                                             "France CTC CII " +
                                                                                                   VID_FR_CTC_CII_1_2_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID22B.getXSDResourceCII ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                                                             "20251114_BR-FR-Flux2-Schematron-CII_V1.2.0.xslt",
                                                                                                                                             _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FR_CTC_CDAR_1_2_0,
                                                                             "France CTC CDAR " +
                                                                                                    VID_FR_CTC_CDAR_1_2_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID22B.getXSDResourceCDAR ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                                                             "20251114_BR-FR-CDV-Schematron-CDAR_V1.2.0.xslt",
                                                                                                                                             _getCL ()))));
    }
  }
}
