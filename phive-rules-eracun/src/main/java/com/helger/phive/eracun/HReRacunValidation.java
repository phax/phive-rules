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
package com.helger.phive.eracun;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.exception.InitializationException;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.rules.api.PhiveRulesBuilder;
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
  @Deprecated
  public static final DVRCoordinate VID_HR_ERACUN_UBL_CREDITNOTE_100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "1.0.0");
  @Deprecated
  public static final DVRCoordinate VID_HR_ERACUN_UBL_INVOICE_100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "1.0.0");

  // Version 1.0.1
  @Deprecated
  public static final DVRCoordinate VID_HR_ERACUN_UBL_CREDITNOTE_101 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "1.0.1");
  @Deprecated
  public static final DVRCoordinate VID_HR_ERACUN_UBL_INVOICE_101 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "1.0.1");

  // Version 1.0.2
  public static final DVRCoordinate VID_HR_ERACUN_UBL_CREDITNOTE_102 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "1.0.2");
  public static final DVRCoordinate VID_HR_ERACUN_UBL_INVOICE_102 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "1.0.2");

  // Version 1.0.3
  public static final DVRCoordinate VID_HR_ERACUN_UBL_CREDITNOTE_103 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "1.0.3");
  public static final DVRCoordinate VID_HR_ERACUN_UBL_INVOICE_103 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "1.0.3");

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

    final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote_1_3_15 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_1315);
    final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice_1_3_15 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_1315);
    if (aVESUBLCreditNote_1_3_15 == null || aVESUBLInvoice_1_3_15 == null)
      throw new InitializationException ("The EN 16931 VES are missing. Make sure to call EN16931Validation.initEN16931 first.");

    // V1.0.0 referencing v1.3.15 of the EN rules
    {
      final ClassPathResource aXslt = new ClassPathResource ("/external/schematron/1.0.0/HR-CIUS-EXT-EN16931-UBL.xslt",
                                                             _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_HR_ERACUN_UBL_CREDITNOTE_100)
                       .displayNamePrefix ("HR eRacun Credit Note ")
                       .deprecated ()
                       .basedOn (aVESUBLCreditNote_1_3_15)
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_HR_ERACUN_UBL_INVOICE_100)
                       .displayNamePrefix ("HR eRacun Invoice ")
                       .deprecated ()
                       .basedOn (aVESUBLInvoice_1_3_15)
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt))
                       .registerInto ();
    }

    // V1.0.1 referencing v1.3.15 of the EN rules
    {
      final ClassPathResource aXslt = new ClassPathResource ("/external/schematron/1.0.1/HR-CIUS-EXT-EN16931-UBL.xslt",
                                                             _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_HR_ERACUN_UBL_CREDITNOTE_101)
                       .displayNamePrefix ("HR eRacun Credit Note ")
                       .deprecated ()
                       .basedOn (aVESUBLCreditNote_1_3_15)
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_HR_ERACUN_UBL_INVOICE_101)
                       .displayNamePrefix ("HR eRacun Invoice ")
                       .deprecated ()
                       .basedOn (aVESUBLInvoice_1_3_15)
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt))
                       .registerInto ();
    }

    // V1.0.2 referencing v1.3.15 of the EN rules
    {
      final ClassPathResource aXslt = new ClassPathResource ("/external/schematron/1.0.2/HR-CIUS-EXT-EN16931-UBL.xslt",
                                                             _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_HR_ERACUN_UBL_CREDITNOTE_102)
                       .displayNamePrefix ("HR eRacun Credit Note ")
                       .notDeprecated ()
                       .basedOn (aVESUBLCreditNote_1_3_15)
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_HR_ERACUN_UBL_INVOICE_102)
                       .displayNamePrefix ("HR eRacun Invoice ")
                       .notDeprecated ()
                       .basedOn (aVESUBLInvoice_1_3_15)
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt))
                       .registerInto ();
    }

    // V1.0.3 referencing v1.3.15 of the EN rules
    {
      final ClassPathResource aXslt = new ClassPathResource ("/external/schematron/1.0.3/HR-CIUS-EXT-EN16931-UBL.xslt",
                                                             _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_HR_ERACUN_UBL_CREDITNOTE_103)
                       .displayNamePrefix ("HR eRacun Credit Note ")
                       .notDeprecated ()
                       .basedOn (aVESUBLCreditNote_1_3_15)
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_HR_ERACUN_UBL_INVOICE_103)
                       .displayNamePrefix ("HR eRacun Invoice ")
                       .notDeprecated ()
                       .basedOn (aVESUBLInvoice_1_3_15)
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt))
                       .registerInto ();
    }
  }
}
