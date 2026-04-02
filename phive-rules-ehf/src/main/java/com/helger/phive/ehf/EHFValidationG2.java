/*
 * Copyright (C) 2018-2026 Philip Helger (www.helger.com)
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
package com.helger.phive.ehf;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;

/**
 * EHF G2 validation configuration
 *
 * @author Philip Helger
 */
@Immutable
@Deprecated (forRemoval = false)
public class EHFValidationG2
{
  private static final String GROUP_ID = "no.ehf";

  // 2018-11
  @Deprecated
  public static final DVRCoordinate VID_EHF_CATALOGUE_1_0_13 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "catalogue",
                                                                                                  "1.0.13");
  @Deprecated
  public static final DVRCoordinate VID_EHF_CATALOGUE_RESPONSE_1_0_13 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "catalogue-response",
                                                                                                           "1.0.13");
  @Deprecated
  public static final DVRCoordinate VID_EHF_CREDITNOTE_2_0_15 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "creditnote",
                                                                                                   "2.0.15");
  @Deprecated
  public static final DVRCoordinate VID_EHF_DESPATCH_ADVICE_1_0_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "despatch-advice",
                                                                                                        "1.0.10");
  @Deprecated
  public static final DVRCoordinate VID_EHF_INVOICE_2_0_15 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "invoice",
                                                                                                "2.0.15");
  @Deprecated
  public static final DVRCoordinate VID_EHF_ORDER_1_0_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "order",
                                                                                              "1.0.11");
  @Deprecated
  public static final DVRCoordinate VID_EHF_ORDER_AGREEMENT_1_0_2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "order-agreement",
                                                                                                       "1.0.2");
  @Deprecated
  public static final DVRCoordinate VID_EHF_ORDER_RESPONSE_1_0_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "order-response",
                                                                                                       "1.0.11");
  @Deprecated
  public static final DVRCoordinate VID_EHF_PUNCH_OUT_1_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "punch-out",
                                                                                                 "1.0.1");
  @Deprecated
  public static final DVRCoordinate VID_EHF_REMINDER_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "reminder",
                                                                                                "1.1.0");

  // 2019-06
  @Deprecated
  public static final DVRCoordinate VID_EHF_CATALOGUE_1_0_14 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "catalogue",
                                                                                                  "1.0.14");
  @Deprecated
  public static final DVRCoordinate VID_EHF_CATALOGUE_RESPONSE_1_0_14 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "catalogue-response",
                                                                                                           "1.0.14");
  @Deprecated
  public static final DVRCoordinate VID_EHF_CREDITNOTE_2_0_16 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "creditnote",
                                                                                                   "2.0.16");
  @Deprecated
  public static final DVRCoordinate VID_EHF_DESPATCH_ADVICE_1_0_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "despatch-advice",
                                                                                                        "1.0.11");
  @Deprecated
  public static final DVRCoordinate VID_EHF_INVOICE_2_0_16 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "invoice",
                                                                                                "2.0.16");
  @Deprecated
  public static final DVRCoordinate VID_EHF_ORDER_1_0_12 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "order",
                                                                                              "1.0.12");
  @Deprecated
  public static final DVRCoordinate VID_EHF_ORDER_AGREEMENT_1_0_3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "order-agreement",
                                                                                                       "1.0.3");
  @Deprecated
  public static final DVRCoordinate VID_EHF_ORDER_RESPONSE_1_0_12 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "order-response",
                                                                                                       "1.0.12");
  @Deprecated
  public static final DVRCoordinate VID_EHF_PUNCH_OUT_1_0_2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "punch-out",
                                                                                                 "1.0.2");
  // Reminder is unchanged 1.1.0

  // 2019-12
  @Deprecated
  public static final DVRCoordinate VID_EHF_CATALOGUE_1_0_15 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "catalogue",
                                                                                                  "1.0.15");
  @Deprecated
  public static final DVRCoordinate VID_EHF_CATALOGUE_RESPONSE_1_0_15 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "catalogue-response",
                                                                                                           "1.0.15");
  @Deprecated
  public static final DVRCoordinate VID_EHF_CREDITNOTE_2_0_17 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "creditnote",
                                                                                                   "2.0.17");
  @Deprecated
  public static final DVRCoordinate VID_EHF_DESPATCH_ADVICE_1_0_12 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "despatch-advice",
                                                                                                        "1.0.12");
  @Deprecated
  public static final DVRCoordinate VID_EHF_INVOICE_2_0_17 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "invoice",
                                                                                                "2.0.17");
  @Deprecated
  public static final DVRCoordinate VID_EHF_ORDER_1_0_13 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "order",
                                                                                              "1.0.13");
  @Deprecated
  public static final DVRCoordinate VID_EHF_ORDER_AGREEMENT_1_0_4 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "order-agreement",
                                                                                                       "1.0.4");
  @Deprecated
  public static final DVRCoordinate VID_EHF_ORDER_RESPONSE_1_0_13 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "order-response",
                                                                                                       "1.0.13");
  @Deprecated
  public static final DVRCoordinate VID_EHF_PUNCH_OUT_1_0_3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "punch-out",
                                                                                                 "1.0.3");
  // Reminder is unchanged 1.1.0

  @NonNull
  private static ClassLoader _getCL ()
  {
    return EHFValidationG2.class.getClassLoader ();
  }

  // 2018-11
  private static final String PATH_201811 = "/external/schematron/2018-11/xslt/";
  private static final IReadableResource EHF_COMMON_V1_0_4 = new ClassPathResource (PATH_201811 + "EHF-UBL-COMMON.xslt",
                                                                                    _getCL ());
  private static final IReadableResource EHF_CATALOGUE_V1_0_13 = new ClassPathResource (PATH_201811 +
                                                                                        "EHF-UBL-T19.xslt",
                                                                                        _getCL ());
  private static final IReadableResource EHF_CATALOGUE_RESPONSE_V1_0_13 = new ClassPathResource (PATH_201811 +
                                                                                                 "EHF-UBL-T58.xslt",
                                                                                                 _getCL ());
  private static final IReadableResource EHF_CREDITNOTE_V2_0_15 = new ClassPathResource (PATH_201811 +
                                                                                         "EHF-UBL-T14.xslt",
                                                                                         _getCL ());
  private static final IReadableResource EHF_DESPATCH_ADVICE_V1_0_10 = new ClassPathResource (PATH_201811 +
                                                                                              "EHF-UBL-T16.xslt",
                                                                                              _getCL ());
  private static final IReadableResource EHF_INVOICE_V2_0_15 = new ClassPathResource (PATH_201811 + "EHF-UBL-T10.xslt",
                                                                                      _getCL ());
  private static final IReadableResource EHF_ORDER_V1_0_11 = new ClassPathResource (PATH_201811 + "EHF-UBL-T01.xslt",
                                                                                    _getCL ());
  private static final IReadableResource EHF_ORDER_AGREEMENT_V1_0_2 = new ClassPathResource (PATH_201811 +
                                                                                             "EHF-UBL-T110.xslt",
                                                                                             _getCL ());
  private static final IReadableResource EHF_ORDER_RESPONSE_V1_0_11 = new ClassPathResource (PATH_201811 +
                                                                                             "EHF-UBL-T76.xslt",
                                                                                             _getCL ());
  private static final IReadableResource EHF_PUNCH_OUT_V1_0_1 = new ClassPathResource (PATH_201811 + "EHF-UBL-T77.xslt",
                                                                                       _getCL ());
  private static final IReadableResource EHF_REMINDER_V1_1_0 = new ClassPathResource (PATH_201811 + "EHF-UBL-T17.xslt",
                                                                                      _getCL ());

  // 2019-06
  private static final String PATH_201906 = "/external/schematron/2019-06/xslt/";
  // Has the same version but is different
  private static final IReadableResource EHF_COMMON_V1_0_4B = new ClassPathResource (PATH_201906 +
                                                                                     "EHF-UBL-COMMON.xslt",
                                                                                     _getCL ());
  private static final IReadableResource EHF_CATALOGUE_V1_0_14 = new ClassPathResource (PATH_201906 +
                                                                                        "EHF-UBL-T19.xslt",
                                                                                        _getCL ());
  private static final IReadableResource EHF_CATALOGUE_RESPONSE_V1_0_14 = new ClassPathResource (PATH_201906 +
                                                                                                 "EHF-UBL-T58.xslt",
                                                                                                 _getCL ());
  private static final IReadableResource EHF_CREDITNOTE_V2_0_16 = new ClassPathResource (PATH_201906 +
                                                                                         "EHF-UBL-T14.xslt",
                                                                                         _getCL ());
  private static final IReadableResource EHF_DESPATCH_ADVICE_V1_0_11 = new ClassPathResource (PATH_201906 +
                                                                                              "EHF-UBL-T16.xslt",
                                                                                              _getCL ());
  private static final IReadableResource EHF_INVOICE_V2_0_16 = new ClassPathResource (PATH_201906 + "EHF-UBL-T10.xslt",
                                                                                      _getCL ());
  private static final IReadableResource EHF_ORDER_V1_0_12 = new ClassPathResource (PATH_201906 + "EHF-UBL-T01.xslt",
                                                                                    _getCL ());
  private static final IReadableResource EHF_ORDER_AGREEMENT_V1_0_3 = new ClassPathResource (PATH_201906 +
                                                                                             "EHF-UBL-T110.xslt",
                                                                                             _getCL ());
  private static final IReadableResource EHF_ORDER_RESPONSE_V1_0_12 = new ClassPathResource (PATH_201906 +
                                                                                             "EHF-UBL-T76.xslt",
                                                                                             _getCL ());
  private static final IReadableResource EHF_PUNCH_OUT_V1_0_2 = new ClassPathResource (PATH_201906 + "EHF-UBL-T77.xslt",
                                                                                       _getCL ());

  // 2019-12
  private static final String PATH_201912 = "/external/schematron/2019-12/xslt/";
  private static final IReadableResource EHF_COMMON_V1_0_4C = new ClassPathResource (PATH_201912 +
                                                                                     "EHF-UBL-COMMON.xslt",
                                                                                     _getCL ());
  private static final IReadableResource EHF_CATALOGUE_V1_0_15 = new ClassPathResource (PATH_201912 +
                                                                                        "EHF-UBL-T19.xslt",
                                                                                        _getCL ());
  private static final IReadableResource EHF_CATALOGUE_RESPONSE_V1_0_15 = new ClassPathResource (PATH_201912 +
                                                                                                 "EHF-UBL-T58.xslt",
                                                                                                 _getCL ());
  private static final IReadableResource EHF_CREDITNOTE_V2_0_17 = new ClassPathResource (PATH_201912 +
                                                                                         "EHF-UBL-T14.xslt",
                                                                                         _getCL ());
  private static final IReadableResource EHF_DESPATCH_ADVICE_V1_0_12 = new ClassPathResource (PATH_201912 +
                                                                                              "EHF-UBL-T16.xslt",
                                                                                              _getCL ());
  private static final IReadableResource EHF_INVOICE_V2_0_17 = new ClassPathResource (PATH_201912 + "EHF-UBL-T10.xslt",
                                                                                      _getCL ());
  private static final IReadableResource EHF_ORDER_V1_0_13 = new ClassPathResource (PATH_201912 + "EHF-UBL-T01.xslt",
                                                                                    _getCL ());
  private static final IReadableResource EHF_ORDER_AGREEMENT_V1_0_4 = new ClassPathResource (PATH_201912 +
                                                                                             "EHF-UBL-T110.xslt",
                                                                                             _getCL ());
  private static final IReadableResource EHF_ORDER_RESPONSE_V1_0_13 = new ClassPathResource (PATH_201912 +
                                                                                             "EHF-UBL-T76.xslt",
                                                                                             _getCL ());
  private static final IReadableResource EHF_PUNCH_OUT_V1_0_3 = new ClassPathResource (PATH_201912 + "EHF-UBL-T77.xslt",
                                                                                       _getCL ());

  private EHFValidationG2 ()
  {}

  /**
   * Register all standard EHF validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  @Deprecated
  public static void initEHF (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // 2018-11
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_CATALOGUE_1_0_13)
                     .displayNamePrefix ("EHF Catalogue ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCatalogueXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "BIIRULES-UBL-T19.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "OPENPEPPOL-UBL-T19.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_CATALOGUE_V1_0_13))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_CATALOGUE_RESPONSE_1_0_13)
                     .displayNamePrefix ("EHF Catalogue Response ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "BIIRULES-UBL-T58.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "OPENPEPPOL-UBL-T58.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_CATALOGUE_RESPONSE_V1_0_13))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_CREDITNOTE_2_0_15)
                     .displayNamePrefix ("EHF Creditnote ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "BIIRULES-UBL-T14.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "OPENPEPPOL-UBL-T14.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_CREDITNOTE_V2_0_15))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_DESPATCH_ADVICE_1_0_10)
                     .displayNamePrefix ("EHF Despatch Advice ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllDespatchAdviceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "BIIRULES-UBL-T16.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "OPENPEPPOL-UBL-T16.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_DESPATCH_ADVICE_V1_0_10))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_INVOICE_2_0_15)
                     .displayNamePrefix ("EHF Invoice ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "BIIRULES-UBL-T10.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "OPENPEPPOL-UBL-T10.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_INVOICE_V2_0_15))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_ORDER_1_0_11)
                     .displayNamePrefix ("EHF Ordering ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "BIIRULES-UBL-T01.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "OPENPEPPOL-UBL-T01.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_ORDER_V1_0_11))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_ORDER_AGREEMENT_1_0_2)
                     .displayNamePrefix ("EHF Order Agreement ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "BIIRULES-UBL-T110.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "OPENPEPPOL-UBL-T110.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_ORDER_AGREEMENT_V1_0_2))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_ORDER_RESPONSE_1_0_11)
                     .displayNamePrefix ("EHF Order Response ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "BIIRULES-UBL-T76.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "OPENPEPPOL-UBL-T76.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_ORDER_RESPONSE_V1_0_11))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_PUNCH_OUT_1_0_1)
                     .displayNamePrefix ("EHF Punch Out ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCatalogueXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "BIIRULES-UBL-T77.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201811 +
                                                                                                  "OPENPEPPOL-UBL-T77.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_PUNCH_OUT_V1_0_1))
                     .registerInto (aRegistry);

    // Reminder is NOT in PEPPOL
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_REMINDER_1_1_0)
                     .displayNamePrefix ("EHF Reminder ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllReminderXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_REMINDER_V1_1_0))
                     .registerInto (aRegistry);

    // 2019-06
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_CATALOGUE_1_0_14)
                     .displayNamePrefix ("EHF Catalogue ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCatalogueXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "BIIRULES-UBL-T19.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "OPENPEPPOL-UBL-T19.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4B))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_CATALOGUE_V1_0_14))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_CATALOGUE_RESPONSE_1_0_14)
                     .displayNamePrefix ("EHF Catalogue Response ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "BIIRULES-UBL-T58.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "OPENPEPPOL-UBL-T58.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4B))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_CATALOGUE_RESPONSE_V1_0_14))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_CREDITNOTE_2_0_16)
                     .displayNamePrefix ("EHF Creditnote ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "BIIRULES-UBL-T14.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "OPENPEPPOL-UBL-T14.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4B))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_CREDITNOTE_V2_0_16))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_DESPATCH_ADVICE_1_0_11)
                     .displayNamePrefix ("EHF Despatch Advice ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllDespatchAdviceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "BIIRULES-UBL-T16.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "OPENPEPPOL-UBL-T16.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4B))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_DESPATCH_ADVICE_V1_0_11))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_INVOICE_2_0_16)
                     .displayNamePrefix ("EHF Invoice ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "BIIRULES-UBL-T10.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "OPENPEPPOL-UBL-T10.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4B))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_INVOICE_V2_0_16))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_ORDER_1_0_12)
                     .displayNamePrefix ("EHF Ordering ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "BIIRULES-UBL-T01.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "OPENPEPPOL-UBL-T01.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4B))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_ORDER_V1_0_12))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_ORDER_AGREEMENT_1_0_3)
                     .displayNamePrefix ("EHF Order Agreement ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "BIIRULES-UBL-T110.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "OPENPEPPOL-UBL-T110.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4B))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_ORDER_AGREEMENT_V1_0_3))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_ORDER_RESPONSE_1_0_12)
                     .displayNamePrefix ("EHF Order Response ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "BIIRULES-UBL-T76.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "OPENPEPPOL-UBL-T76.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4B))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_ORDER_RESPONSE_V1_0_12))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_PUNCH_OUT_1_0_2)
                     .displayNamePrefix ("EHF Punch Out ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCatalogueXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "BIIRULES-UBL-T77.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201906 +
                                                                                                  "OPENPEPPOL-UBL-T77.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4B))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_PUNCH_OUT_V1_0_2))
                     .registerInto (aRegistry);
    // Reminder is from 2018-11

    // 2019-12
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_CATALOGUE_1_0_15)
                     .displayNamePrefix ("EHF Catalogue ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCatalogueXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "BIIRULES-UBL-T19.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "OPENPEPPOL-UBL-T19.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4C))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_CATALOGUE_V1_0_15))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_CATALOGUE_RESPONSE_1_0_15)
                     .displayNamePrefix ("EHF Catalogue Response ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "BIIRULES-UBL-T58.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "OPENPEPPOL-UBL-T58.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4C))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_CATALOGUE_RESPONSE_V1_0_15))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_CREDITNOTE_2_0_17)
                     .displayNamePrefix ("EHF Creditnote ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "BIIRULES-UBL-T14.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "OPENPEPPOL-UBL-T14.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4C))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_CREDITNOTE_V2_0_17))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_DESPATCH_ADVICE_1_0_12)
                     .displayNamePrefix ("EHF Despatch Advice ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllDespatchAdviceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "BIIRULES-UBL-T16.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "OPENPEPPOL-UBL-T16.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4C))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_DESPATCH_ADVICE_V1_0_12))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_INVOICE_2_0_17)
                     .displayNamePrefix ("EHF Invoice ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "BIIRULES-UBL-T10.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "OPENPEPPOL-UBL-T10.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4C))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_INVOICE_V2_0_17))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_ORDER_1_0_13)
                     .displayNamePrefix ("EHF Ordering ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "BIIRULES-UBL-T01.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "OPENPEPPOL-UBL-T01.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4C))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_ORDER_V1_0_13))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_ORDER_AGREEMENT_1_0_4)
                     .displayNamePrefix ("EHF Order Agreement ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "BIIRULES-UBL-T110.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "OPENPEPPOL-UBL-T110.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4C))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_ORDER_AGREEMENT_V1_0_4))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_ORDER_RESPONSE_1_0_13)
                     .displayNamePrefix ("EHF Order Response ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "BIIRULES-UBL-T76.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "OPENPEPPOL-UBL-T76.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4C))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_ORDER_RESPONSE_V1_0_13))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_EHF_PUNCH_OUT_1_0_3)
                     .displayNamePrefix ("EHF Punch Out ")
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCatalogueXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "BIIRULES-UBL-T77.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_201912 +
                                                                                                  "OPENPEPPOL-UBL-T77.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_COMMON_V1_0_4C))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (EHF_PUNCH_OUT_V1_0_3))
                     .registerInto (aRegistry);
    // Reminder is from 2018-11
  }
}
