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
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesBuilder;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl22.UBL22Marshaller;

/**
 * EHF G3 Validation configuration 2023-02<br>
 * See https://anskaffelser.dev/postaward/g3/spec/current/release/2023-02-16/
 *
 * @author Philip Helger
 */
@Immutable
public final class EHFValidationG3_2023_02
{
  private static final String GROUP_ID = "no.ehf.g3";

  // 2023-02-16
  public static final DVRCoordinate VID_EHF_ADVANCED_ORDER_CANCELLATION_303 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                 "advanced-order-cancellation",
                                                                                                                 "3.0.3");
  public static final DVRCoordinate VID_EHF_ADVANCED_ORDER_CHANGE_303 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "advanced-order-change",
                                                                                                           "3.0.3");
  public static final DVRCoordinate VID_EHF_ADVANCED_ORDER_INITIATION_303 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                               "advanced-order-initiation",
                                                                                                               "3.0.3");
  public static final DVRCoordinate VID_EHF_ADVANCED_ORDER_RESPONSE_303 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                             "advanced-order-response",
                                                                                                             "3.0.3");

  public static final DVRCoordinate VID_EHF_CATALOGUE_303 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "catalogue",
                                                                                               "3.0.3");
  public static final DVRCoordinate VID_EHF_CATALOGUE_RESPONSE_303 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "catalogue-response",
                                                                                                        "3.0.3");

  public static final DVRCoordinate VID_EHF_DESPATCH_ADVICE_302 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "despatch-advice",
                                                                                                     "3.0.2");
  public static final DVRCoordinate VID_EHF_FORWARD_BILLING_INVOICE_303 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                             "forward-billing-invoice",
                                                                                                             "3.0.3");
  public static final DVRCoordinate VID_EHF_FORWARD_BILLING_CREDIT_NOTE_303 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                 "forward-billing-creditnote",
                                                                                                                 "3.0.3");

  public static final DVRCoordinate VID_EHF_ORDER_AGREEMENT_303 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "order-agreement",
                                                                                                     "3.0.3");

  public static final DVRCoordinate VID_EHF_ORDER_303 = PhiveRulesHelper.createCoordinate (GROUP_ID, "order", "3.0.3");
  public static final DVRCoordinate VID_EHF_ORDER_RESPONSE_303 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "order-response",
                                                                                                    "3.0.3");

  public static final DVRCoordinate VID_EHF_PAYMENT_REQUEST_302 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "payment-request",
                                                                                                     "3.0.2");

  public static final DVRCoordinate VID_EHF_PUNCH_OUT_303 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "punch-out",
                                                                                               "3.0.3");

  public static final DVRCoordinate VID_EHF_REMINDER_303 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "reminder",
                                                                                              "3.0.3");

  private EHFValidationG3_2023_02 ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return EHFValidationG3_2023_02.class.getClassLoader ();
  }

  /**
   * Register all standard EHF validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initEHF (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // 2020-03-23
    final String sXSLT = "/external/schematron/2023-02/xslt/";
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_ADVANCED_ORDER_CANCELLATION_303)
                     .displayNamePrefix ("EHF Advanced Order Cancellation ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllOrderCancellationXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "advanced-ordering-3.0/EHF-P09-3.0-ORDER-CANCELLATION.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_ADVANCED_ORDER_CHANGE_303)
                     .displayNamePrefix ("EHF Advanced Order Change ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllOrderChangeXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "advanced-ordering-3.0/EHF-P09-3.0-ORDER-CHANGE.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_ADVANCED_ORDER_INITIATION_303)
                     .displayNamePrefix ("EHF Advanced Order Initiation ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllOrderXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "advanced-ordering-3.0/EHF-P09-3.0-ORDER-INITIATION.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_ADVANCED_ORDER_RESPONSE_303)
                     .displayNamePrefix ("EHF Advanced Order Response ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "advanced-ordering-3.0/EHF-P09-3.0-ORDER-RESPONSE.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_CATALOGUE_303)
                     .displayNamePrefix ("EHF Catalogue ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllCatalogueXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "catalogue-3.0/EHF-CATALOGUE-3.0.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_CATALOGUE_RESPONSE_303)
                     .displayNamePrefix ("EHF Catalogue Response ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllApplicationResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "catalogue-3.0/EHF-CATALOGUE-RESPONSE-3.0.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_DESPATCH_ADVICE_302)
                     .displayNamePrefix ("EHF Despatch Advice ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllDespatchAdviceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "despatch-advice-3.0/EHF-DESPATCH-ADVICE-3.0.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_FORWARD_BILLING_INVOICE_303)
                     .displayNamePrefix ("EHF Forward Billing Invoice ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "forward-billing-3.0/FORWARD-BILLING-CEN-EN16931-UBL.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "forward-billing-3.0/FORWARD-BILLING-PEPPOL-EN16931-UBL.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_FORWARD_BILLING_CREDIT_NOTE_303)
                     .displayNamePrefix ("EHF Forward Billing Credit Note ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "forward-billing-3.0/FORWARD-BILLING-CEN-EN16931-UBL.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "forward-billing-3.0/FORWARD-BILLING-PEPPOL-EN16931-UBL.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_ORDER_AGREEMENT_303)
                     .displayNamePrefix ("EHF Order Agreement ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "order-agreement-3.0/EHF-ORDER-AGREEMENT-3.0.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_ORDER_303)
                     .displayNamePrefix ("EHF Order ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllOrderXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "ordering-3.0/EHF-ORDER-3.0.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_ORDER_RESPONSE_303)
                     .displayNamePrefix ("EHF Order Response ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "ordering-3.0/EHF-ORDER-RESPONSE-3.0.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_PAYMENT_REQUEST_302)
                     .displayNamePrefix ("EHF Payment Request ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "payment-request-3.0/EHF-P07-3.0-PAYMENT-REQUEST-3.0.xslt")))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_PUNCH_OUT_303)
                     .displayNamePrefix ("EHF Punch Out ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllCatalogueXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "punch-out-3.0/EHF-PUNCH-OUT-3.0.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EHF_REMINDER_303)
                     .displayNamePrefix ("EHF Reminder ")
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "reminder-3.0/REMINDER-CEN-EN16931-UBL.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "reminder-3.0/REMINDER-PEPPOL-EN16931-UBL.xslt",
                                                                                                  _getCL ())))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL22 (new ClassPathResource (sXSLT +
                                                                                                  "reminder-3.0/EHF-P06-3.0-REMINDER.xslt",
                                                                                                  _getCL ())))
                     .registerInto ();
  }
}
