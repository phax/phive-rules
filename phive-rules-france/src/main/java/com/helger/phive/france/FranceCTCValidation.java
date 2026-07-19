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

import java.time.LocalTime;
import java.time.Month;
import java.time.OffsetDateTime;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.cii.d22b.CCIID22B;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.datetime.helper.PDTFactory;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.rules.api.PhiveRulesCIIHelper;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
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
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_FR_CTC_UBL_INV_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "ubl-invoice",
                                                                                                "0.1");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_FR_CTC_UBL_CN_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "ubl-creditnote",
                                                                                               "0.1");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_FR_CTC_CII_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", "0.1");

  // v1.2.0
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_FR_CTC_UBL_INV_1_2_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "ubl-invoice",
                                                                                                  "1.2.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_FR_CTC_UBL_CN_1_2_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 "1.2.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_FR_CTC_CII_1_2_0 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", "1.2.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_FR_CTC_CDAR_1_2_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cdar",
                                                                                               "1.2.0");

  // v1.3.0
  public static final DVRCoordinate VID_FR_CTC_UBL_INV_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "ubl-invoice",
                                                                                                  "1.3.0");
  public static final DVRCoordinate VID_FR_CTC_UBL_CN_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 "1.3.0");
  public static final DVRCoordinate VID_FR_CTC_CII_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", "1.3.0");
  public static final DVRCoordinate VID_FR_CTC_CDAR_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cdar",
                                                                                               "1.3.0");

  public static final DVRCoordinate VID_FR_EXTENDED_CTC_UBL_INV_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "extended-ubl-invoice",
                                                                                                           "1.3.0");
  public static final DVRCoordinate VID_FR_EXTENDED_CTC_UBL_CN_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "extended-ubl-creditnote",
                                                                                                          "1.3.0");
  public static final DVRCoordinate VID_FR_EXTENDED_CTC_CII_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "extended-cii",
                                                                                                       "1.3.0");

  // v1.3.1
  public static final DVRCoordinate VID_FR_CTC_UBL_INV_1_3_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "ubl-invoice",
                                                                                                  "1.3.1");
  public static final DVRCoordinate VID_FR_CTC_UBL_CN_1_3_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 "1.3.1");
  public static final DVRCoordinate VID_FR_CTC_CII_1_3_1 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", "1.3.1");
  public static final DVRCoordinate VID_FR_CTC_CDAR_1_3_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cdar",
                                                                                               "1.3.1");

  public static final DVRCoordinate VID_FR_EXTENDED_CTC_UBL_INV_1_3_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "extended-ubl-invoice",
                                                                                                           "1.3.1");
  public static final DVRCoordinate VID_FR_EXTENDED_CTC_UBL_CN_1_3_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "extended-ubl-creditnote",
                                                                                                          "1.3.1");
  public static final DVRCoordinate VID_FR_EXTENDED_CTC_CII_1_3_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "extended-cii",
                                                                                                       "1.3.1");

  // v1.4.0
  public static final DVRCoordinate VID_FR_CTC_UBL_INV_1_4_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "ubl-invoice",
                                                                                                  "1.4.0");
  public static final DVRCoordinate VID_FR_CTC_UBL_CN_1_4_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 "1.4.0");
  public static final DVRCoordinate VID_FR_CTC_CII_1_4_0 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", "1.4.0");
  public static final DVRCoordinate VID_FR_CTC_CDAR_1_4_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cdar",
                                                                                               "1.4.0");

  public static final DVRCoordinate VID_FR_EXTENDED_CTC_UBL_INV_1_4_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "extended-ubl-invoice",
                                                                                                           "1.4.0");
  public static final DVRCoordinate VID_FR_EXTENDED_CTC_UBL_CN_1_4_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "extended-ubl-creditnote",
                                                                                                          "1.4.0");
  public static final DVRCoordinate VID_FR_EXTENDED_CTC_CII_1_4_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "extended-cii",
                                                                                                       "1.4.0");

  private FranceCTCValidation ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return FranceCTCValidation.class.getClassLoader ();
  }

  /**
   * @return A list of all prerequisite validation execution set coordinates that must already be
   *         registered before {@link #initFranceCTC(IValidationExecutorSetRegistry)} is called.
   *         Shares the same data basis as the initialization method. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  @SuppressWarnings ("deprecation")
  public static ICommonsList <DVRCoordinate> getAllPrerequisites ()
  {
    return new CommonsArrayList <> (EN16931Validation.VID_UBL_INVOICE_1315,
                                    EN16931Validation.VID_UBL_CREDIT_NOTE_1315,
                                    EN16931Validation.VID_CII_1315,
                                    EN16931Validation.VID_UBL_INVOICE_1316,
                                    EN16931Validation.VID_UBL_CREDIT_NOTE_1316,
                                    EN16931Validation.VID_CII_1316);
  }

  /**
   * Register all standard France CTC validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  @SuppressWarnings ("deprecation")
  public static void initFranceCTC (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final IValidationExecutorSet <IValidationSourceXML> aVESCII_1_3_15 = PhiveRulesHelper.requireVESID (aRegistry,
                                                                                                        EN16931Validation.VID_CII_1315);
    final IValidationExecutorSet <IValidationSourceXML> aVESCN_1_3_15 = PhiveRulesHelper.requireVESID (aRegistry,
                                                                                                       EN16931Validation.VID_UBL_CREDIT_NOTE_1315);
    final IValidationExecutorSet <IValidationSourceXML> aVESInv_1_3_15 = PhiveRulesHelper.requireVESID (aRegistry,
                                                                                                        EN16931Validation.VID_UBL_INVOICE_1315);

    final IValidationExecutorSet <IValidationSourceXML> aVESCII_1_3_16 = PhiveRulesHelper.requireVESID (aRegistry,
                                                                                                        EN16931Validation.VID_CII_1316);
    final IValidationExecutorSet <IValidationSourceXML> aVESCN_1_3_16 = PhiveRulesHelper.requireVESID (aRegistry,
                                                                                                       EN16931Validation.VID_UBL_CREDIT_NOTE_1316);
    final IValidationExecutorSet <IValidationSourceXML> aVESInv_1_3_16 = PhiveRulesHelper.requireVESID (aRegistry,
                                                                                                        EN16931Validation.VID_UBL_INVOICE_1316);

    final String sPrefix = "/external/schematron/ctc/";

    // CTC 0.1
    {
      // No "valid from" date - the date this version comes into force is not provided in the FNFE
      // documentation
      final String sPrefix0 = sPrefix + "0.1/xslt/";
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_UBL_INV_0_1)
                   .displayNamePrefix ("France CTC UBL Invoice ")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20250731_BR-FR-Flux2-Schematron-UBL_V0.1.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_UBL_CN_0_1)
                   .displayNamePrefix ("France CTC UBL Credit Note ")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20250731_BR-FR-Flux2-Schematron-UBL_V0.1.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_CII_0_1)
                   .displayNamePrefix ("France CTC CII ")
                   .deprecated ()
                   .addXSD (CCIID22B.getXSDResourceCII ())
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20250731_BR-FR-Flux2-Schematron-CII_V0.1.xslt",
                                                                                                   _getCL ())))
                   .registerInto (aRegistry);
    }

    // CTC 1.2.0
    {
      // No "valid from" date - the date this version comes into force is not provided in the FNFE
      // documentation
      final String sPrefix0 = sPrefix + "1.2.0/xslt/";
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_UBL_INV_1_2_0)
                   .displayNamePrefix ("France CTC UBL Invoice ")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20251114_BR-FR-Flux2-Schematron-UBL_V1.2.0.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_UBL_CN_1_2_0)
                   .displayNamePrefix ("France CTC UBL Credit Note ")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20251114_BR-FR-Flux2-Schematron-UBL_V1.2.0.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_CII_1_2_0)
                   .displayNamePrefix ("France CTC CII ")
                   .deprecated ()
                   .addXSD (CCIID22B.getXSDResourceCII ())
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20251114_BR-FR-Flux2-Schematron-CII_V1.2.0.xslt",
                                                                                                   _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_CDAR_1_2_0)
                   .displayNamePrefix ("France CTC CDAR ")
                   .deprecated ()
                   .addXSD (CCIID22B.getXSDResourceCDAR ())
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20251114_BR-FR-CDV-Schematron-CDAR_V1.2.0.xslt",
                                                                                                   _getCL ())))
                   .registerInto (aRegistry);
    }

    // CTC 1.3.0
    {
      // No "valid from" date - the date this version comes into force is not provided in the FNFE
      // documentation
      final String sPrefix0 = sPrefix + "1.3.0/xslt/";

      // Base Invoice based on EN16931
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_UBL_INV_1_3_0)
                   .displayNamePrefix ("France CTC UBL Invoice ")
                   .deprecated ()
                   .basedOn (aVESInv_1_3_15)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260216_BR-FR-Flux2-Schematron-UBL_V1.3.0.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_UBL_CN_1_3_0)
                   .displayNamePrefix ("France CTC UBL Credit Note ")
                   .deprecated ()
                   .basedOn (aVESCN_1_3_15)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260216_BR-FR-Flux2-Schematron-UBL_V1.3.0.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_CII_1_3_0)
                   .displayNamePrefix ("France CTC CII ")
                   .deprecated ()
                   .basedOn (aVESCII_1_3_15)
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20260216_BR-FR-Flux2-Schematron-CII_V1.3.0.xslt",
                                                                                                   _getCL ())))
                   .registerInto (aRegistry);

      // Extended invoice based on special EN subset
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_EXTENDED_CTC_UBL_INV_1_3_0)
                   .displayNamePrefix ("France Extended CTC UBL Invoice ")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260216_EXTENDED-CTC-FR-UBL-V1.3.0.xslt",
                                                                                                _getCL ())))
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260216_BR-FR-Flux2-Schematron-UBL_V1.3.0.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_EXTENDED_CTC_UBL_CN_1_3_0)
                   .displayNamePrefix ("France Extended CTC UBL Credit Note ")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260216_EXTENDED-CTC-FR-UBL-V1.3.0.xslt",
                                                                                                _getCL ())))
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260216_BR-FR-Flux2-Schematron-UBL_V1.3.0.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_EXTENDED_CTC_CII_1_3_0)
                   .displayNamePrefix ("France Extended CTC CII ")
                   .deprecated ()
                   .addXSD (CCIID22B.getXSDResourceCII ())
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20260216_EXTENDED-CTC-FR-CII-V1.3.0.xslt",
                                                                                                   _getCL ())))
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20260216_BR-FR-Flux2-Schematron-CII_V1.3.0.xslt",
                                                                                                   _getCL ())))
                   .registerInto (aRegistry);

      // CDAR
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_CDAR_1_3_0)
                   .displayNamePrefix ("France CTC CDAR ")
                   .deprecated ()
                   .addXSD (CCIID22B.getXSDResourceCDAR ())
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20260216_BR-FR-CDV-Schematron-CDAR_V1.3.0.xslt",
                                                                                                   _getCL ())))
                   .registerInto (aRegistry);
    }

    // CTC 1.3.1
    {
      final String sPrefix0 = sPrefix + "1.3.1/xslt/";
      final OffsetDateTime aValidFrom = PDTFactory.createOffsetDate (2026, Month.JULY, 1).atTime (LocalTime.MIDNIGHT);

      // Base Invoice based on EN16931
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_UBL_INV_1_3_1)
                   .displayNamePrefix ("France CTC UBL Invoice ")
                   .notDeprecated ()
                   .basedOn (aVESInv_1_3_15)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260430_BR-FR-Flux2-Schematron-UBL_V1.3.1.xslt",
                                                                                                _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_UBL_CN_1_3_1)
                   .displayNamePrefix ("France CTC UBL Credit Note ")
                   .notDeprecated ()
                   .basedOn (aVESCN_1_3_15)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260430_BR-FR-Flux2-Schematron-UBL_V1.3.1.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_CII_1_3_1)
                   .displayNamePrefix ("France CTC CII ")
                   .notDeprecated ()
                   .basedOn (aVESCII_1_3_15)
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20260430_BR-FR-Flux2-Schematron-CII_V1.3.1.xslt",
                                                                                                   _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);

      // Extended invoice based on special EN subset
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_EXTENDED_CTC_UBL_INV_1_3_1)
                   .displayNamePrefix ("France Extended CTC UBL Invoice ")
                   .notDeprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260430_EXTENDED-CTC-FR-UBL-V1.3.1.xslt",
                                                                                                _getCL ())))
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260430_BR-FR-Flux2-Schematron-UBL_V1.3.1.xslt",
                                                                                                _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_EXTENDED_CTC_UBL_CN_1_3_1)
                   .displayNamePrefix ("France Extended CTC UBL Credit Note ")
                   .notDeprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260430_EXTENDED-CTC-FR-UBL-V1.3.1.xslt",
                                                                                                _getCL ())))
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260430_BR-FR-Flux2-Schematron-UBL_V1.3.1.xslt",
                                                                                                _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_EXTENDED_CTC_CII_1_3_1)
                   .displayNamePrefix ("France Extended CTC CII ")
                   .notDeprecated ()
                   .addXSD (CCIID22B.getXSDResourceCII ())
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20260430_EXTENDED-CTC-FR-CII-V1.3.1.xslt",
                                                                                                   _getCL ())))
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20260430_BR-FR-Flux2-Schematron-CII_V1.3.1.xslt",
                                                                                                   _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);

      // CDAR
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_CDAR_1_3_1)
                   .displayNamePrefix ("France CTC CDAR ")
                   .notDeprecated ()
                   .addXSD (CCIID22B.getXSDResourceCDAR ())
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20260430_BR-FR-CDV-Schematron-CDAR_V1.3.1.xslt",
                                                                                                   _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);
    }

    // CTC 1.4.0
    {
      final String sPrefix0 = sPrefix + "1.4.0/xslt/";
      final OffsetDateTime aValidFrom = PDTFactory.createOffsetDate (2026, Month.SEPTEMBER, 1)
                                                  .atTime (LocalTime.MIDNIGHT);

      // Base Invoice based on EN16931
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_UBL_INV_1_4_0)
                   .displayNamePrefix ("France CTC UBL Invoice ")
                   .notDeprecated ()
                   .basedOn (aVESInv_1_3_16)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260630_BR-FR-Flux2-Schematron-UBL_V1.4.0.xslt",
                                                                                                _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_UBL_CN_1_4_0)
                   .displayNamePrefix ("France CTC UBL Credit Note ")
                   .notDeprecated ()
                   .basedOn (aVESCN_1_3_16)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260630_BR-FR-Flux2-Schematron-UBL_V1.4.0.xslt",
                                                                                                _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_CII_1_4_0)
                   .displayNamePrefix ("France CTC CII ")
                   .notDeprecated ()
                   .basedOn (aVESCII_1_3_16)
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20260630_BR-FR-Flux2-Schematron-CII_V1.4.0.xslt",
                                                                                                   _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);

      // Extended invoice based on special EN subset
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_EXTENDED_CTC_UBL_INV_1_4_0)
                   .displayNamePrefix ("France Extended CTC UBL Invoice ")
                   .notDeprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260630_EXTENDED-CTC-FR-UBL-V1.4.0.xslt",
                                                                                                _getCL ())))
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260630_BR-FR-Flux2-Schematron-UBL_V1.4.0.xslt",
                                                                                                _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_EXTENDED_CTC_UBL_CN_1_4_0)
                   .displayNamePrefix ("France Extended CTC UBL Credit Note ")
                   .notDeprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260630_EXTENDED-CTC-FR-UBL-V1.4.0.xslt",
                                                                                                _getCL ())))
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix0 +
                                                                                                "20260630_BR-FR-Flux2-Schematron-UBL_V1.4.0.xslt",
                                                                                                _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_EXTENDED_CTC_CII_1_4_0)
                   .displayNamePrefix ("France Extended CTC CII ")
                   .notDeprecated ()
                   .addXSD (CCIID22B.getXSDResourceCII ())
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20260630_EXTENDED-CTC-FR-CII-V1.4.0.xslt",
                                                                                                   _getCL ())))
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20260630_BR-FR-Flux2-Schematron-CII_V1.4.0.xslt",
                                                                                                   _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);

      // CDAR
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_CTC_CDAR_1_4_0)
                   .displayNamePrefix ("France CTC CDAR ")
                   .notDeprecated ()
                   .addXSD (CCIID22B.getXSDResourceCDAR ())
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix0 +
                                                                                                   "20260630_BR-FR-CDV-Schematron-CDAR_V1.4.0.xslt",
                                                                                                   _getCL ())))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);
    }
  }
}
