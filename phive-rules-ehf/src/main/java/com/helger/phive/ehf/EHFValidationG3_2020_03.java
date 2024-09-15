/*
 * Copyright (C) 2018-2024 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl22.UBL22Marshaller;

/**
 * EHF G3 Validation configuration 2020-03. Use {@link EHFValidationG3_2023_02}
 * instead.
 *
 * @author Philip Helger
 */
@Immutable
@Deprecated
public final class EHFValidationG3_2020_03
{
  private static final String GROUP_ID = "no.ehf.g3";

  // 2020-03-23
  public static final DVRCoordinate VID_EHF_ADVANCED_ORDER_CANCELLATION_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                 "advanced-order-cancellation",
                                                                                                                 "3.0.0");
  public static final DVRCoordinate VID_EHF_ADVANCED_ORDER_CHANGE_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "advanced-order-change",
                                                                                                           "3.0.0");
  public static final DVRCoordinate VID_EHF_ADVANCED_ORDER_INITIATION_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                               "advanced-order-initiation",
                                                                                                               "3.0.0");
  public static final DVRCoordinate VID_EHF_ADVANCED_ORDER_RESPONSE_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                             "advanced-order-response",
                                                                                                             "3.0.0");
  public static final DVRCoordinate VID_EHF_CATALOGUE_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "catalogue",
                                                                                               "3.0.0");
  public static final DVRCoordinate VID_EHF_CATALOGUE_RESPONSE_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "catalogue-response",
                                                                                                        "3.0.0");
  public static final DVRCoordinate VID_EHF_DESPATCH_ADVICE_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "despatch-advice",
                                                                                                     "3.0.0");
  public static final DVRCoordinate VID_EHF_FORWARD_BILLING_INVOICE_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                             "forward-billing-invoice",
                                                                                                             "3.0.1");
  public static final DVRCoordinate VID_EHF_FORWARD_BILLING_CREDIT_NOTE_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                 "forward-billing-creditnote",
                                                                                                                 "3.0.1");
  public static final DVRCoordinate VID_EHF_ORDER_AGREEMENT_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "order-agreement",
                                                                                                     "3.0.0");
  public static final DVRCoordinate VID_EHF_ORDER_300 = PhiveRulesHelper.createCoordinate (GROUP_ID, "order", "3.0.0");
  public static final DVRCoordinate VID_EHF_ORDER_RESPONSE_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "order-response",
                                                                                                    "3.0.0");
  public static final DVRCoordinate VID_EHF_PAYMENT_REQUEST_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "payment-request",
                                                                                                     "3.0.0");
  public static final DVRCoordinate VID_EHF_PUNCH_OUT_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "punch-out",
                                                                                               "3.0.0");
  public static final DVRCoordinate VID_EHF_REMINDER_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "reminder",
                                                                                              "3.0.0");

  private EHFValidationG3_2020_03 ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return EHFValidationG3_2020_03.class.getClassLoader ();
  }

  /**
   * Register all standard EHF validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initEHF (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;

    // 2020-03-23
    final String sXSLT = "/external/schematron/2020-03/xslt/";
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ADVANCED_ORDER_CANCELLATION_300,
                                                                           "EHF Advanced Order Cancellation " +
                                                                                                                    VID_EHF_ADVANCED_ORDER_CANCELLATION_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllOrderCancellationXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "advanced-ordering-3.0/EHF-P09-3.0-ORDER-CANCELLATION.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ADVANCED_ORDER_CHANGE_300,
                                                                           "EHF Advanced Order Change " +
                                                                                                              VID_EHF_ADVANCED_ORDER_CHANGE_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllOrderChangeXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "advanced-ordering-3.0/EHF-P09-3.0-ORDER-CHANGE.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ADVANCED_ORDER_INITIATION_300,
                                                                           "EHF Advanced Order Initiation " +
                                                                                                                  VID_EHF_ADVANCED_ORDER_INITIATION_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllOrderXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "advanced-ordering-3.0/EHF-P09-3.0-ORDER-INITIATION.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ADVANCED_ORDER_RESPONSE_300,
                                                                           "EHF Advanced Order Response " +
                                                                                                                VID_EHF_ADVANCED_ORDER_RESPONSE_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllOrderResponseXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "advanced-ordering-3.0/EHF-P09-3.0-ORDER-RESPONSE.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_CATALOGUE_300,
                                                                           "EHF Catalogue " +
                                                                                                  VID_EHF_CATALOGUE_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllCatalogueXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "catalogue-3.0/EHF-CATALOGUE-3.0.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_CATALOGUE_RESPONSE_300,
                                                                           "EHF Catalogue Response " +
                                                                                                           VID_EHF_CATALOGUE_RESPONSE_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllApplicationResponseXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "catalogue-3.0/EHF-CATALOGUE-RESPONSE-3.0.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_DESPATCH_ADVICE_300,
                                                                           "EHF Despatch Advice " +
                                                                                                        VID_EHF_DESPATCH_ADVICE_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllDespatchAdviceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "despatch-advice-3.0/EHF-DESPATCH-ADVICE-3.0.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_FORWARD_BILLING_INVOICE_300,
                                                                           "EHF Forward Billing Invoice " +
                                                                                                                VID_EHF_FORWARD_BILLING_INVOICE_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "forward-billing-3.0/FORWARD-BILLING-CEN-EN16931-UBL.xslt",
                                                                                                                                        _getCL ())),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "forward-billing-3.0/FORWARD-BILLING-PEPPOL-EN16931-UBL.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_FORWARD_BILLING_CREDIT_NOTE_300,
                                                                           "EHF Forward Billing Credit Note " +
                                                                                                                    VID_EHF_FORWARD_BILLING_CREDIT_NOTE_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllCreditNoteXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "forward-billing-3.0/FORWARD-BILLING-CEN-EN16931-UBL.xslt",
                                                                                                                                        _getCL ())),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "forward-billing-3.0/FORWARD-BILLING-PEPPOL-EN16931-UBL.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ORDER_AGREEMENT_300,
                                                                           "EHF Order Agreement " +
                                                                                                        VID_EHF_ORDER_AGREEMENT_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllOrderResponseXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "order-agreement-3.0/EHF-ORDER-AGREEMENT-3.0.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ORDER_300,
                                                                           "EHF Order " +
                                                                                              VID_EHF_ORDER_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllOrderXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "ordering-3.0/EHF-ORDER-3.0.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ORDER_RESPONSE_300,
                                                                           "EHF Order Response " +
                                                                                                       VID_EHF_ORDER_RESPONSE_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllOrderResponseXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "ordering-3.0/EHF-ORDER-RESPONSE-3.0.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_PAYMENT_REQUEST_300,
                                                                           "EHF Payment Request " +
                                                                                                        VID_EHF_PAYMENT_REQUEST_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "payment-request-3.0/EHF-P07-3.0-PAYMENT-REQUEST-3.0.xslt"))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_PUNCH_OUT_300,
                                                                           "EHF Punch Out " +
                                                                                                  VID_EHF_PUNCH_OUT_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllCatalogueXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "punch-out-3.0/EHF-PUNCH-OUT-3.0.xslt",
                                                                                                                                        _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_REMINDER_300,
                                                                           "EHF Reminder " +
                                                                                                 VID_EHF_REMINDER_300.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "reminder-3.0/REMINDER-CEN-EN16931-UBL.xslt",
                                                                                                                                        _getCL ())),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "reminder-3.0/REMINDER-PEPPOL-EN16931-UBL.xslt",
                                                                                                                                        _getCL ())),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                                                        "reminder-3.0/EHF-P06-3.0-REMINDER.xslt",
                                                                                                                                        _getCL ()))));
  }
}
