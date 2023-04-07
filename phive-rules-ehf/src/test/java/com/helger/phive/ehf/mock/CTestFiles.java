/*
 * Copyright (C) 2018-2023 Philip Helger (www.helger.com)
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
package com.helger.phive.ehf.mock;

import static org.junit.Assert.assertTrue;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.ehf.EHFValidation;
import com.helger.phive.ehf.EHFValidationG2;
import com.helger.phive.ehf.EHFValidationG3;
import com.helger.phive.engine.mock.MockFile;
import com.helger.phive.engine.source.IValidationSourceXML;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    EHFValidation.initEHF (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <MockFile> getAllTestFiles ()
  {
    final ICommonsList <MockFile> ret = new CommonsArrayList <> ();
    for (final VESID aESID : new VESID [] { /* 2018-11 */
                                            EHFValidationG2.VID_EHF_CATALOGUE_1_0_13,
                                            EHFValidationG2.VID_EHF_CATALOGUE_RESPONSE_1_0_13,
                                            EHFValidationG2.VID_EHF_CREDITNOTE_2_0_15,
                                            EHFValidationG2.VID_EHF_DESPATCH_ADVICE_1_0_10,
                                            EHFValidationG2.VID_EHF_INVOICE_2_0_15,
                                            EHFValidationG2.VID_EHF_ORDER_1_0_11,
                                            EHFValidationG2.VID_EHF_ORDER_AGREEMENT_1_0_2,
                                            EHFValidationG2.VID_EHF_ORDER_RESPONSE_1_0_11,
                                            EHFValidationG2.VID_EHF_PUNCH_OUT_1_0_1,
                                            EHFValidationG2.VID_EHF_REMINDER_1_1_0,
                                            /* 2019-06 */
                                            EHFValidationG2.VID_EHF_CATALOGUE_1_0_14,
                                            EHFValidationG2.VID_EHF_CATALOGUE_RESPONSE_1_0_14,
                                            EHFValidationG2.VID_EHF_CREDITNOTE_2_0_16,
                                            EHFValidationG2.VID_EHF_DESPATCH_ADVICE_1_0_11,
                                            EHFValidationG2.VID_EHF_INVOICE_2_0_16,
                                            EHFValidationG2.VID_EHF_ORDER_1_0_12,
                                            EHFValidationG2.VID_EHF_ORDER_AGREEMENT_1_0_3,
                                            EHFValidationG2.VID_EHF_ORDER_RESPONSE_1_0_12,
                                            EHFValidationG2.VID_EHF_PUNCH_OUT_1_0_2,
                                            /* 2019-12 */
                                            EHFValidationG2.VID_EHF_CATALOGUE_1_0_15,
                                            EHFValidationG2.VID_EHF_CATALOGUE_RESPONSE_1_0_15,
                                            EHFValidationG2.VID_EHF_CREDITNOTE_2_0_17,
                                            EHFValidationG2.VID_EHF_DESPATCH_ADVICE_1_0_12,
                                            EHFValidationG2.VID_EHF_INVOICE_2_0_17,
                                            EHFValidationG2.VID_EHF_ORDER_1_0_13,
                                            EHFValidationG2.VID_EHF_ORDER_AGREEMENT_1_0_4,
                                            EHFValidationG2.VID_EHF_ORDER_RESPONSE_1_0_13,
                                            EHFValidationG2.VID_EHF_PUNCH_OUT_1_0_3,
                                            /* 2020-03 */
                                            EHFValidationG3.VID_EHF_ADVANCED_ORDER_CANCELLATION_300,
                                            EHFValidationG3.VID_EHF_ADVANCED_ORDER_CHANGE_300,
                                            EHFValidationG3.VID_EHF_ADVANCED_ORDER_INITIATION_300,
                                            EHFValidationG3.VID_EHF_ADVANCED_ORDER_RESPONSE_300,
                                            EHFValidationG3.VID_EHF_CATALOGUE_300,
                                            EHFValidationG3.VID_EHF_CATALOGUE_RESPONSE_300,
                                            EHFValidationG3.VID_EHF_DESPATCH_ADVICE_300,
                                            EHFValidationG3.VID_EHF_FORWARD_BILLING_INVOICE_300,
                                            EHFValidationG3.VID_EHF_FORWARD_BILLING_CREDIT_NOTE_300,
                                            EHFValidationG3.VID_EHF_ORDER_AGREEMENT_300,
                                            EHFValidationG3.VID_EHF_ORDER_300,
                                            EHFValidationG3.VID_EHF_ORDER_RESPONSE_300,
                                            EHFValidationG3.VID_EHF_PAYMENT_REQUEST_300,
                                            EHFValidationG3.VID_EHF_PUNCH_OUT_300,
                                            EHFValidationG3.VID_EHF_REMINDER_300 })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (MockFile.createGoodCase (aRes, aESID));
      }
    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final VESID aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    // 2018-11
    String sPath = "/external/test-files/2018-11/examples/";
    if (aVESID.equals (EHFValidationG2.VID_EHF_CATALOGUE_1_0_13))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T19 Example file EHF Catalogue.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_CATALOGUE_RESPONSE_1_0_13))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T58 Example file EHF Catalogue Response.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_CREDITNOTE_2_0_15))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T14 BII05 gyldig kreditnota.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_DESPATCH_ADVICE_1_0_10))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T16 Eksempel1.xml"),
                                      new ClassPathResource (sPath + "T16 Eksempel2.xml"),
                                      new ClassPathResource (sPath + "T16 Eksempel3.xml"),
                                      new ClassPathResource (sPath + "T16 Eksempel4.xml"),
                                      new ClassPathResource (sPath + "T16 Eksempel5.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_INVOICE_2_0_15))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T10 BII05 gyldig faktura.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_ORDER_1_0_11))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T01 Eksempelfil EHF Ordre.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_ORDER_AGREEMENT_1_0_2))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T110 ehf-oa-case-2.xml"),
                                      new ClassPathResource (sPath + "T110 ehf-oa-case1.xml"),
                                      new ClassPathResource (sPath + "T110 ehf-oa-case2-5.xml"),
                                      new ClassPathResource (sPath + "T110 ehf-oa-full.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_ORDER_RESPONSE_1_0_11))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T76 Eksempelfil EHF Ordrebekreftelse.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_PUNCH_OUT_1_0_1))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T77 ehf-po-case1-2.xml"),
                                      new ClassPathResource (sPath + "T77 ehf-po-case2.xml"),
                                      new ClassPathResource (sPath + "T77 ehf-po-full.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_REMINDER_1_1_0))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath +
                                                             "T17 biixy gyldig purring med alle elementer.xml"));
    }

    // 2019-06
    sPath = "/external/test-files/2019-06/examples/";
    if (aVESID.equals (EHFValidationG2.VID_EHF_CATALOGUE_1_0_14))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T19 Example file EHF Catalogue.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_CATALOGUE_RESPONSE_1_0_14))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T58 Example file EHF Catalogue Response.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_CREDITNOTE_2_0_16))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T14 BII05 gyldig kreditnota.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_DESPATCH_ADVICE_1_0_11))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T16 Eksempel1.xml"),
                                      new ClassPathResource (sPath + "T16 Eksempel2.xml"),
                                      new ClassPathResource (sPath + "T16 Eksempel3.xml"),
                                      new ClassPathResource (sPath + "T16 Eksempel4.xml"),
                                      new ClassPathResource (sPath + "T16 Eksempel5.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_INVOICE_2_0_16))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T10 BII05 gyldig faktura.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_ORDER_1_0_12))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T01 Eksempelfil EHF Ordre.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_ORDER_AGREEMENT_1_0_3))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T110 ehf-oa-case-2.xml"),
                                      new ClassPathResource (sPath + "T110 ehf-oa-case1.xml"),
                                      new ClassPathResource (sPath + "T110 ehf-oa-case2-5.xml"),
                                      new ClassPathResource (sPath + "T110 ehf-oa-full.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_ORDER_RESPONSE_1_0_12))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T76 Eksempelfil EHF Ordrebekreftelse.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_PUNCH_OUT_1_0_2))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T77 ehf-po-case1-2.xml"),
                                      new ClassPathResource (sPath + "T77 ehf-po-case2.xml"),
                                      new ClassPathResource (sPath + "T77 ehf-po-full.xml"));
    }

    // 2019-12
    sPath = "/external/test-files/2019-12/examples/";
    if (aVESID.equals (EHFValidationG2.VID_EHF_CATALOGUE_1_0_15))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T19 Example file EHF Catalogue.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_CATALOGUE_RESPONSE_1_0_15))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T58 Example file EHF Catalogue Response.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_CREDITNOTE_2_0_17))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T14 BII05 gyldig kreditnota.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_DESPATCH_ADVICE_1_0_12))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T16 Eksempel1.xml"),
                                      new ClassPathResource (sPath + "T16 Eksempel2.xml"),
                                      new ClassPathResource (sPath + "T16 Eksempel3.xml"),
                                      new ClassPathResource (sPath + "T16 Eksempel4.xml"),
                                      new ClassPathResource (sPath + "T16 Eksempel5.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_INVOICE_2_0_17))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T10 BII05 gyldig faktura.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_ORDER_1_0_13))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T01 Eksempelfil EHF Ordre.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_ORDER_AGREEMENT_1_0_4))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T110 ehf-oa-case-2.xml"),
                                      new ClassPathResource (sPath + "T110 ehf-oa-case1.xml"),
                                      new ClassPathResource (sPath + "T110 ehf-oa-case2-5.xml"),
                                      new ClassPathResource (sPath + "T110 ehf-oa-full.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_ORDER_RESPONSE_1_0_13))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T76 Eksempelfil EHF Ordrebekreftelse.xml"));
    }
    if (aVESID.equals (EHFValidationG2.VID_EHF_PUNCH_OUT_1_0_3))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "T77 ehf-po-case1-2.xml"),
                                      new ClassPathResource (sPath + "T77 ehf-po-case2.xml"),
                                      new ClassPathResource (sPath + "T77 ehf-po-full.xml"));
    }

    // 2020-03
    sPath = "/external/test-files/2020-03/examples/";
    if (aVESID.equals (EHFValidationG3.VID_EHF_ADVANCED_ORDER_CANCELLATION_300))
    {
      return new CommonsArrayList <> ();
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_ADVANCED_ORDER_CHANGE_300))
    {
      return new CommonsArrayList <> ();
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_ADVANCED_ORDER_INITIATION_300))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath +
                                                             "advanced-ordering-3.0/Advanced_Order_Example.xml"));
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_ADVANCED_ORDER_RESPONSE_300))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath +
                                                             "advanced-ordering-3.0/Advanced_OrderResponse_Example.xml"));
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_CATALOGUE_300))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "catalogue-3.0/Catalogue_Example.xml"));
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_CATALOGUE_RESPONSE_300))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "catalogue-3.0/CatalogueResponse_Example.xml"));
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_DESPATCH_ADVICE_300))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "despatch-advice-3.0/DespatchAdvice_Example.xml"));
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_FORWARD_BILLING_INVOICE_300))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath +
                                                             "forward-billing-3.0/forward-billing-nettleie-business.xml"),
                                      new ClassPathResource (sPath +
                                                             "forward-billing-3.0/forward-billing-nettleie-consumer.xml"));
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_FORWARD_BILLING_CREDIT_NOTE_300))
    {
      return new CommonsArrayList <> ();
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_ORDER_AGREEMENT_300))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "order-agreement-3.0/OrderAgreement_Example.xml"));
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_ORDER_300))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "ordering-3.0/Order_Example.xml"));
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_ORDER_RESPONSE_300))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "ordering-3.0/OrderResponse_Example.xml"));
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_PAYMENT_REQUEST_300))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath +
                                                             "payment-request-3.0/PaymentRequest-example-1.xml"),
                                      new ClassPathResource (sPath +
                                                             "payment-request-3.0/PaymentRequest-example-2.xml"));
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_PUNCH_OUT_300))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "punch-out-3.0/PunchOut_Example.xml"));
    }
    if (aVESID.equals (EHFValidationG3.VID_EHF_REMINDER_300))
    {
      return new CommonsArrayList <> (new ClassPathResource (sPath + "reminder-3.0/Reminder-Example.xml"));
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
