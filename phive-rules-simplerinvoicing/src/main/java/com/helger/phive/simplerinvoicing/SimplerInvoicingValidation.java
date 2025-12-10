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
package com.helger.phive.simplerinvoicing;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.cii.d16b.CCIID16B;
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
 * SimplerInvoicing validation configuration<br>
 * November 2022 release: will be in effect on February 6th, 2023
 *
 * @author Philip Helger
 */
@Immutable
public final class SimplerInvoicingValidation
{
  public static final String GROUP_ID = "org.simplerinvoicing";

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V10 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "1.0");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V11 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "1.1");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V12 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "1.2");
  @Deprecated
  public static final DVRCoordinate VID_SI_ORDER_V12 = PhiveRulesHelper.createCoordinate (GROUP_ID, "order", "1.2");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V123 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "invoice",
                                                                                             "1.2.3");
  @Deprecated
  public static final DVRCoordinate VID_SI_ORDER_V123 = PhiveRulesHelper.createCoordinate (GROUP_ID, "order", "1.2.3");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V124 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "invoice",
                                                                                             "1.2.4");
  @Deprecated
  public static final DVRCoordinate VID_SI_ORDER_V124 = PhiveRulesHelper.createCoordinate (GROUP_ID, "order", "1.2.4");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V20 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "2.0");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V20 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "creditnote",
                                                                                                "2.0");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V201 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "invoice",
                                                                                             "2.0.1");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V201 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "creditnote",
                                                                                                 "2.0.1");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V202 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "invoice",
                                                                                             "2.0.2");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V202 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "creditnote",
                                                                                                 "2.0.2");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V203 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "invoice",
                                                                                             "2.0.3");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V203 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "creditnote",
                                                                                                 "2.0.3");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V2031 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "invoice",
                                                                                              "2.0.3.1");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V2031 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "creditnote",
                                                                                                  "2.0.3.1");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V2032 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "invoice",
                                                                                              "2.0.3.2");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V2032 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "creditnote",
                                                                                                  "2.0.3.2");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V2033 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "invoice",
                                                                                              "2.0.3.3");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V2033 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "creditnote",
                                                                                                  "2.0.3.3");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V2034 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "invoice",
                                                                                              "2.0.3.4");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V2034 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "creditnote",
                                                                                                  "2.0.3.4");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V2035 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "invoice",
                                                                                              "2.0.3.5");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V2035 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "creditnote",
                                                                                                  "2.0.3.5");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V2036 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "invoice",
                                                                                              "2.0.3.6");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V2036 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "creditnote",
                                                                                                  "2.0.3.6");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V2037 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "invoice",
                                                                                              "2.0.3.7");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V2037 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "creditnote",
                                                                                                  "2.0.3.7");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V2038 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "invoice",
                                                                                              "2.0.3.8");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V2038 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "creditnote",
                                                                                                  "2.0.3.8");

  // In effect from August 27, 2024
  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V2039 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "invoice",
                                                                                              "2.0.3.9");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V2039 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "creditnote",
                                                                                                  "2.0.3.9");

  // In effect from February 17, 2025
  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_V2_0_3_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "invoice",
                                                                                                  "2.0.3.10");
  @Deprecated
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V2_0_3_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "creditnote",
                                                                                                      "2.0.3.10");

  // In effect from August 25, 2025
  public static final DVRCoordinate VID_SI_INVOICE_V2_0_3_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "invoice",
                                                                                                  "2.0.3.11");
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V2_0_3_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "creditnote",
                                                                                                      "2.0.3.11");

  // In effect as of February 23, 2026
  public static final DVRCoordinate VID_SI_INVOICE_V2_0_3_12 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "invoice",
                                                                                                  "2.0.3.12");
  public static final DVRCoordinate VID_SI_CREDIT_NOTE_V2_0_3_12 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "creditnote",
                                                                                                      "2.0.3.12");

  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "invoice20.g-account",
                                                                                                        "1.0");
  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V101 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "invoice20.g-account",
                                                                                                         "1.0.1");
  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V102 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "invoice20.g-account",
                                                                                                         "1.0.2");
  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V103 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "invoice20.g-account",
                                                                                                         "1.0.3");
  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V104 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "invoice20.g-account",
                                                                                                         "1.0.4");
  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V105 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "invoice20.g-account",
                                                                                                         "1.0.5");
  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V106 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "invoice20.g-account",
                                                                                                         "1.0.6");
  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V107 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "invoice20.g-account",
                                                                                                         "1.0.7");
  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V108 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "invoice20.g-account",
                                                                                                         "1.0.8");
  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V109 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "invoice20.g-account",
                                                                                                         "1.0.9");
  @Deprecated
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V1_0_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                            "invoice20.g-account",
                                                                                                            "1.0.10");
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V1_0_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                            "invoice20.g-account",
                                                                                                            "1.0.11");
  public static final DVRCoordinate VID_SI_INVOICE_20_GACCOUNT_V1_0_12 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                            "invoice20.g-account",
                                                                                                            "1.0.12");

  @Deprecated
  public static final DVRCoordinate VID_SI_NLCIUS_CII_V103 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "nlcius-cii",
                                                                                                "1.0.3");
  @Deprecated
  public static final DVRCoordinate VID_SI_NLCIUS_CII_V1031 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "nlcius-cii",
                                                                                                 "1.0.3.1");
  @Deprecated
  public static final DVRCoordinate VID_SI_NLCIUS_CII_V1032 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "nlcius-cii",
                                                                                                 "1.0.3.2");
  @Deprecated
  public static final DVRCoordinate VID_SI_NLCIUS_CII_V1033 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "nlcius-cii",
                                                                                                 "1.0.3.3");
  @Deprecated
  public static final DVRCoordinate VID_SI_NLCIUS_CII_V1034 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "nlcius-cii",
                                                                                                 "1.0.3.4");
  @Deprecated
  public static final DVRCoordinate VID_SI_NLCIUS_CII_V1035 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "nlcius-cii",
                                                                                                 "1.0.3.5");
  @Deprecated
  public static final DVRCoordinate VID_SI_NLCIUS_CII_V1036 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "nlcius-cii",
                                                                                                 "1.0.3.6");
  @Deprecated
  public static final DVRCoordinate VID_SI_NLCIUS_CII_V1037 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "nlcius-cii",
                                                                                                 "1.0.3.7");
  @Deprecated
  public static final DVRCoordinate VID_SI_NLCIUS_CII_V1038 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "nlcius-cii",
                                                                                                 "1.0.3.8");
  @Deprecated
  public static final DVRCoordinate VID_SI_NLCIUS_CII_V1039 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "nlcius-cii",
                                                                                                 "1.0.3.9");
  public static final DVRCoordinate VID_SI_NLCIUS_CII_V1_0_3_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "nlcius-cii",
                                                                                                     "1.0.3.11");
  public static final DVRCoordinate VID_SI_NLCIUS_CII_V1_0_3_12 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "nlcius-cii",
                                                                                                     "1.0.3.12");

  @NonNull
  private static ClassLoader _getCL ()
  {
    return SimplerInvoicingValidation.class.getClassLoader ();
  }

  private SimplerInvoicingValidation ()
  {}

  /**
   * Register all standard SimplerInvoicing validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initSimplerInvoicing (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String PATH_SI = "/external/schematron/simplerinvoicing/";

    // SimplerInvoicing is self-contained
    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;
    // 1.0
    {
      final ClassPathResource INVOICE_SI10 = new ClassPathResource (PATH_SI + "si-ubl-1.0.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V10,
                                                                             "Simplerinvoicing Invoice 1.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_SI10)));
    }

    // 1.1
    {
      final ClassPathResource INVOICE_SI11 = new ClassPathResource (PATH_SI + "si-ubl-1.1.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V11,
                                                                             "Simplerinvoicing Invoice 1.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_SI11)));
    }

    // 1.2
    {
      final ClassPathResource INVOICE_SI12 = new ClassPathResource (PATH_SI + "si-ubl-1.2.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V12,
                                                                             "Simplerinvoicing Invoice 1.2",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_SI12)));
      final ClassPathResource ORDER_SI12 = new ClassPathResource (PATH_SI + "si-ubl-1.2-purchaseorder.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_ORDER_V12,
                                                                             "Simplerinvoicing Order 1.2",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (ORDER_SI12)));
    }

    // 1.2.3
    {
      final ClassPathResource INVOICE_SI123 = new ClassPathResource (PATH_SI + "si-ubl-1.2.3.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V123,
                                                                             "Simplerinvoicing Invoice 1.2.3",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_SI123)));
      final ClassPathResource ORDER_SI123 = new ClassPathResource (PATH_SI + "si-ubl-1.2.3-purchaseorder.xslt",
                                                                   _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_ORDER_V123,
                                                                             "Simplerinvoicing Order 1.2.3",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (ORDER_SI123)));
    }

    // 1.2.4
    {
      final ClassPathResource INVOICE_SI124 = new ClassPathResource (PATH_SI + "si-ubl-1.2.4.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V124,
                                                                             "Simplerinvoicing Invoice 1.2.4",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_SI124)));
      final ClassPathResource ORDER_SI124 = new ClassPathResource (PATH_SI + "si-ubl-1.2.4-purchaseorder.xslt",
                                                                   _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_ORDER_V124,
                                                                             "Simplerinvoicing Order 1.2.4",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (ORDER_SI124)));
    }

    // 2.0
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V20,
                                                                             "Simplerinvoicing Invoice 2.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V20,
                                                                             "Simplerinvoicing Credit Note 2.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.1
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.1.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V201,
                                                                             "Simplerinvoicing Invoice 2.0.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V201,
                                                                             "Simplerinvoicing Credit Note 2.0.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.2
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.2.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V202,
                                                                             "Simplerinvoicing Invoice 2.0.2",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V202,
                                                                             "Simplerinvoicing Credit Note 2.0.2",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V203,
                                                                             "Simplerinvoicing Invoice 2.0.3",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V203,
                                                                             "Simplerinvoicing Credit Note 2.0.3",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3.1
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.1.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2031,
                                                                             "Simplerinvoicing Invoice 2.0.3.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2031,
                                                                             "Simplerinvoicing Credit Note 2.0.3.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3.2
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.2.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2032,
                                                                             "Simplerinvoicing Invoice 2.0.3.2",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2032,
                                                                             "Simplerinvoicing Credit Note 2.0.3.2",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3.3
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.3.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2033,
                                                                             "Simplerinvoicing Invoice 2.0.3.3",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2033,
                                                                             "Simplerinvoicing Credit Note 2.0.3.3",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3.4
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.4.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2034,
                                                                             "Simplerinvoicing Invoice 2.0.3.4",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2034,
                                                                             "Simplerinvoicing Credit Note 2.0.3.4",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3.5
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.5.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2035,
                                                                             "Simplerinvoicing Invoice 2.0.3.5",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2035,
                                                                             "Simplerinvoicing Credit Note 2.0.3.5",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3.6
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.6.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2036,
                                                                             "Simplerinvoicing Invoice 2.0.3.6",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2036,
                                                                             "Simplerinvoicing Credit Note 2.0.3.6",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3.7
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.7.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2037,
                                                                             "Simplerinvoicing Invoice 2.0.3.7",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2037,
                                                                             "Simplerinvoicing Credit Note 2.0.3.7",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3.8
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.8.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2038,
                                                                             "Simplerinvoicing Invoice 2.0.3.8",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2038,
                                                                             "Simplerinvoicing Credit Note 2.0.3.8",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3.9
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.9.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2039,
                                                                             "Simplerinvoicing Invoice 2.0.3.9",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2039,
                                                                             "Simplerinvoicing Credit Note 2.0.3.9",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3.10
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.10.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2_0_3_10,
                                                                             "Simplerinvoicing Invoice 2.0.3.10",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2_0_3_10,
                                                                             "Simplerinvoicing Credit Note 2.0.3.10",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3.11
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.11.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2_0_3_11,
                                                                             "Simplerinvoicing Invoice 2.0.3.11",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2_0_3_11,
                                                                             "Simplerinvoicing Credit Note 2.0.3.11",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0.3.12
    {
      final ClassPathResource aRes = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.12.xslt", _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2_0_3_12,
                                                                             "Simplerinvoicing Invoice 2.0.3.12",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2_0_3_12,
                                                                             "Simplerinvoicing Credit Note 2.0.3.12",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (aRes)));
    }

    // 2.0 G-Account 1.0
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V10,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.xslt",
                                                                                                                                        _getCL ()))));

    // 2.0 G-Account 1.0.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V101,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.1",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.1.xslt",
                                                                                                                                        _getCL ()))));

    // 2.0 G-Account 1.0.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V102,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.2",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.2.xslt",
                                                                                                                                        _getCL ()))));

    // 2.0 G-Account 1.0.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V103,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.3",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.3.xslt",
                                                                                                                                        _getCL ()))));

    // 2.0 G-Account 1.0.4
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V104,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.4",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.4.xslt",
                                                                                                                                        _getCL ()))));

    // 2.0 G-Account 1.0.5
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V105,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.5",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.5.xslt",
                                                                                                                                        _getCL ()))));

    // 2.0 G-Account 1.0.6
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V106,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.6",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.6.xslt",
                                                                                                                                        _getCL ()))));

    // 2.0 G-Account 1.0.7
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V107,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.7",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.7.xslt",
                                                                                                                                        _getCL ()))));

    // 2.0 G-Account 1.0.8
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V108,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.8",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.8.xslt",
                                                                                                                                        _getCL ()))));

    // 2.0 G-Account 1.0.9
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V109,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.9",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.9.xslt",
                                                                                                                                        _getCL ()))));

    // 2.0 G-Account 1.0.10
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V1_0_10,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.10",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.10.xslt",
                                                                                                                                        _getCL ()))));

    // 2.0 G-Account 1.0.11
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V1_0_11,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.11",
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.11.xslt",
                                                                                                                                        _getCL ()))));

    // 2.0 G-Account 1.0.12
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V1_0_12,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.12",
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (PATH_SI +
                                                                                                                                        "si-ubl-2.0-ext-gaccount-1.0.12.xslt",
                                                                                                                                        _getCL ()))));

    final String PATH_NL_CIUS = "/external/schematron/nlcius/";

    // NLCIUS 1.0.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V103,
                                                                           "NLCIUS-CII 1.0.3",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (PATH_NL_CIUS +
                                                                                                                                           "nlcius-cii-1.0.3.xslt",
                                                                                                                                           _getCL ()))));

    // NLCIUS 1.0.3.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1031,
                                                                           "NLCIUS-CII 1.0.3.1",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (PATH_NL_CIUS +
                                                                                                                                           "nlcius-cii-1.0.3.1.xslt",
                                                                                                                                           _getCL ()))));

    // NLCIUS 1.0.3.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1032,
                                                                           "NLCIUS-CII 1.0.3.2",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (PATH_NL_CIUS +
                                                                                                                                           "nlcius-cii-1.0.3.2.xslt",
                                                                                                                                           _getCL ()))));

    // NLCIUS 1.0.3.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1033,
                                                                           "NLCIUS-CII 1.0.3.3",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (PATH_NL_CIUS +
                                                                                                                                           "nlcius-cii-1.0.3.3.xslt",
                                                                                                                                           _getCL ()))));

    // NLCIUS 1.0.3.4
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1034,
                                                                           "NLCIUS-CII 1.0.3.4",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (PATH_NL_CIUS +
                                                                                                                                           "nlcius-cii-1.0.3.4.xslt",
                                                                                                                                           _getCL ()))));

    // NLCIUS 1.0.3.5
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1035,
                                                                           "NLCIUS-CII 1.0.3.5",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (PATH_NL_CIUS +
                                                                                                                                           "nlcius-cii-1.0.3.5.xslt",
                                                                                                                                           _getCL ()))));

    // NLCIUS 1.0.3.6
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1036,
                                                                           "NLCIUS-CII 1.0.3.6",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (PATH_NL_CIUS +
                                                                                                                                           "nlcius-cii-1.0.3.6.xslt",
                                                                                                                                           _getCL ()))));

    // NLCIUS 1.0.3.7
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1037,
                                                                           "NLCIUS-CII 1.0.3.7",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (PATH_NL_CIUS +
                                                                                                                                           "nlcius-cii-1.0.3.7.xslt",
                                                                                                                                           _getCL ()))));

    // NLCIUS 1.0.3.8
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1038,
                                                                           "NLCIUS-CII 1.0.3.8",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (PATH_NL_CIUS +
                                                                                                                                           "nlcius-cii-1.0.3.8.xslt",
                                                                                                                                           _getCL ()))));

    // NLCIUS 1.0.3.9
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1039,
                                                                           "NLCIUS-CII 1.0.3.9",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (PATH_NL_CIUS +
                                                                                                                                           "nlcius-cii-1.0.3.9.xslt",
                                                                                                                                           _getCL ()))));

    // NLCIUS 1.0.3.10 was buggy and is therefore not provided

    // NLCIUS 1.0.3.11
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1_0_3_11,
                                                                           "NLCIUS-CII 1.0.3.11",
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (PATH_NL_CIUS +
                                                                                                                                           "nlcius-cii-1.0.3.11.xslt",
                                                                                                                                           _getCL ()))));

    // NLCIUS 1.0.3.12
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1_0_3_12,
                                                                           "NLCIUS-CII 1.0.3.12",
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (PATH_NL_CIUS +
                                                                                                                                           "nlcius-cii-1.0.3.12.xslt",
                                                                                                                                           _getCL ()))));
  }
}
