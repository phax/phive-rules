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
package com.helger.phive.eracun;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.exception.InitializationException;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * HR eRacun validation configuration
 *
 * @author Philip Helger
 * @since 4.1.1
 */
@Immutable
public final class HReRacunValidation
{
  public static final String GROUP_ID = "hr.gov.porezna.eracun";

  // Version 1.0.0
  public static final DVRCoordinate VID_HR_ERACUN_UBL_CREDITNOTE_100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "1.0.0");
  public static final DVRCoordinate VID_HR_ERACUN_UBL_INVOICE_100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "1.0.0");

  // Version 1.0.1
  public static final DVRCoordinate VID_HR_ERACUN_UBL_CREDITNOTE_101 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "1.0.1");
  public static final DVRCoordinate VID_HR_ERACUN_UBL_INVOICE_101 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "1.0.1");

  private HReRacunValidation ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return HReRacunValidation.class.getClassLoader ();
  }

  /**
   * Register all standard HR eRacun validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = !bDeprecated;

    final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote_1_3_15 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_1315);
    final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice_1_3_15 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_1315);
    if (aVESUBLCreditNote_1_3_15 == null || aVESUBLInvoice_1_3_15 == null)
      throw new InitializationException ("The EN 16931 VES are missing. Make sure to call EN16931Validation.initEN16931 first.");

    // V1.0.0 referencing v1.3.15 of the EN rules
    {
      final ClassPathResource aXslt = new ClassPathResource ("/external/schematron/1.0.0/HR-CIUS-EXT-EN16931-UBL.xslt",
                                                             _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLCreditNote_1_3_15,
                                                                                    VID_HR_ERACUN_UBL_CREDITNOTE_100,
                                                                                    "HR eRacun Credit Note " +
                                                                                                                      VID_HR_ERACUN_UBL_CREDITNOTE_100.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLInvoice_1_3_15,
                                                                                    VID_HR_ERACUN_UBL_INVOICE_100,
                                                                                    "HR eRacun Invoice " +
                                                                                                                   VID_HR_ERACUN_UBL_INVOICE_100.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt)));
    }

    // V1.0.1 referencing v1.3.15 of the EN rules
    {
      final ClassPathResource aXslt = new ClassPathResource ("/external/schematron/1.0.1/HR-CIUS-EXT-EN16931-UBL.xslt",
                                                             _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLCreditNote_1_3_15,
                                                                                    VID_HR_ERACUN_UBL_CREDITNOTE_101,
                                                                                    "HR eRacun Credit Note " +
                                                                                                                      VID_HR_ERACUN_UBL_CREDITNOTE_101.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLInvoice_1_3_15,
                                                                                    VID_HR_ERACUN_UBL_INVOICE_101,
                                                                                    "HR eRacun Invoice " +
                                                                                                                   VID_HR_ERACUN_UBL_INVOICE_101.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt)));
    }
  }
}
