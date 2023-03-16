/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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
package com.helger.phive.peppol.mock;

import static org.junit.Assert.assertTrue;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.engine.mock.MockFile;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.peppol.PeppolValidation;
import com.helger.phive.peppol.PeppolValidation3_14_0;
import com.helger.phive.peppol.PeppolValidation3_15_0;
import com.helger.phive.peppol.PeppolValidationAUNZ;
import com.helger.phive.peppol.PeppolValidationDirectory;
import com.helger.phive.peppol.PeppolValidationReporting;
import com.helger.phive.peppol.PeppolValidationSG;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    PeppolValidation.initStandard (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <MockFile> getAllTestFiles ()
  {
    final ICommonsList <MockFile> ret = new CommonsArrayList <> ();
    for (final VESID aESID : new VESID [] { /* AU_NZ */
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_107,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_107,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_107,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_107,

                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_108,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_108,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_108,
                                            PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_108,

                                            /* Singapore */
                                            PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102,
                                            PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102,

                                            PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103,
                                            PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103,

                                            /* OpenPeppol */
                                            PeppolValidation3_14_0.VID_OPENPEPPOL_INVOICE_UBL_V3,
                                            PeppolValidation3_14_0.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                            PeppolValidation3_14_0.VID_OPENPEPPOL_INVOICE_CII_V3,
                                            PeppolValidation3_14_0.VID_OPENPEPPOL_ORDER_V3,
                                            PeppolValidation3_14_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                            PeppolValidation3_14_0.VID_OPENPEPPOL_CATALOGUE_V3,
                                            PeppolValidation3_14_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                            PeppolValidation3_14_0.VID_OPENPEPPOL_MLR_V3,
                                            PeppolValidation3_14_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                            PeppolValidation3_14_0.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                            PeppolValidation3_14_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                            PeppolValidation3_14_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,

                                            PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_UBL_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_CII_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_CATALOGUE_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_MLR_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                            PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,

                                            /* Directory */
                                            PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V1,
                                            PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V2,
                                            PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V3,

                                            /* Reporting */
                                            PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V100RC2,
                                            PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V100,

                                            PeppolValidationReporting.VID_OPENPEPPOL_TSR_V100,
                                            PeppolValidationReporting.VID_OPENPEPPOL_TSR_V101, })
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

    final String sTestFiles = "src/test/resources/test-files/";

    // AUNZ 1.0.7
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_107))
    {
      final String sBase = sTestFiles + "aunz-peppol/1.0.7/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "AU Invoice.xml"),
                                      new FileSystemResource (sBase + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sBase + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sBase + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sBase + "NZ No Allowances.xml"),
                                      new FileSystemResource (sBase + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_107))
    {
      final String sBase = sTestFiles + "aunz-peppol/1.0.7/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_107))
    {
      final String sBase = sTestFiles + "aunz-peppol/1.0.7/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "AU Self Billing.xml"),
                                      new FileSystemResource (sBase + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_107))
    {
      final String sBase = sTestFiles + "aunz-peppol/1.0.7/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.8
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_108))
    {
      final String sBase = sTestFiles + "aunz-peppol/1.0.8/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "AU Invoice.xml"),
                                      new FileSystemResource (sBase + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sBase + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sBase + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sBase + "NZ No Allowances.xml"),
                                      new FileSystemResource (sBase + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_108))
    {
      final String sBase = sTestFiles + "aunz-peppol/1.0.8/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_108))
    {
      final String sBase = sTestFiles + "aunz-peppol/1.0.8/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "AU Self Billing.xml"),
                                      new FileSystemResource (sBase + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_108))
    {
      final String sBase = sTestFiles + "aunz-peppol/1.0.8/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "NZ Self Billed Credit note.xml"));
    }

    // SG 1.0.2
    if (aVESID.equals (PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102))
    {
      final String sBase = sTestFiles + "sg-peppol/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "Singapore invoice valid 1.xml"));
    }

    if (aVESID.equals (PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102))
      return new CommonsArrayList <> ();

    // SG 1.0.3
    if (aVESID.equals (PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103))
    {
      final String sBase = sTestFiles + "sg-peppol/1.0.3/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "Singapore invoice valid 1.xml"),
                                      new FileSystemResource (sBase + "Singapore invoice valid 1 - NG tax code.xml"));
    }

    if (aVESID.equals (PeppolValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103))
      return new CommonsArrayList <> ();

    // 3.14.0
    {
      final String sBase = sTestFiles + "openpeppol/3.14.0/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_INVOICE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sBase + "billing/base-example.xml"),
                                        new FileSystemResource (sBase + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sBase + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sBase + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sBase + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sBase + "billing/vat-category-Z.xml"),
                                        // Original file is broken
                                        new FileSystemResource (sBase + "billing/GR-base-example-correct.xml"),
                                        // Original file is broken
                                        // new FileSystemResource (sBase +
                                        // "billing/GR-base-example-TaxRepresentative.xml"),
                                        new FileSystemResource (sBase + "billing/Norwegian-example-1.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_INVOICE_CII_V3))
        return new CommonsArrayList <> ();
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Order_Example.xml"),
                                        new FileSystemResource (sBase + "Order use cases/UC1_Order.xml"),
                                        new FileSystemResource (sBase + "Order use cases/UC2_Order.xml"),
                                        new FileSystemResource (sBase + "Order use cases/UC3_Order.xml"),
                                        new FileSystemResource (sBase + "Order use cases/UC4_Order.xml"),
                                        new FileSystemResource (sBase + "Order use cases/UC5_Order.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "DespatchAdvice_Example.xml"),
                                        new FileSystemResource (sBase +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase1.xml"),
                                        new FileSystemResource (sBase +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase2.xml"),
                                        new FileSystemResource (sBase +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase3.xml"),
                                        new FileSystemResource (sBase +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase4.xml"),
                                        new FileSystemResource (sBase +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase5.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderResponse_Example.xml"),
                                        new FileSystemResource (sBase +
                                                                "Order-response use cases/UC1_Order_response.xml"),
                                        new FileSystemResource (sBase +
                                                                "Order-response use cases/UC2_Order_response.xml"),
                                        new FileSystemResource (sBase +
                                                                "Order-response use cases/UC3_Order_response.xml"),
                                        new FileSystemResource (sBase +
                                                                "Order-response use cases/UC4_Order_response.xml"),
                                        new FileSystemResource (sBase +
                                                                "Order-response use cases/UC5_Order_response.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderAgreement_Example.xml"));

      final String sBase2 = sBase + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "InvoiceResponse_Example.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc001-Invoice in process.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002a-Additional reference data.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002b-In process but postponed.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc003-Invoice is accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004a-Invoice is rejected.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004b-Rejected requesting reissue.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc004c-Rejected requesting replacement.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc005-Invoice is conditionally accepted.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc006a-Under query missing information.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006b-Missing PO.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006c-Wrong detail partial credit.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc007-Payment has been initiated.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc008-Invoice is accepted by third party.xml"));
    }

    // 3.15.0
    {
      final String sBase = sTestFiles + "openpeppol/3.15.0/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sBase + "billing/base-example.xml"),
                                        new FileSystemResource (sBase + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sBase + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sBase + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sBase + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sBase + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_CII_V3))
        return new CommonsArrayList <> ();
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Order_Example.xml"),
                                        new FileSystemResource (sBase + "Order use cases/UC1_Order.xml"),
                                        new FileSystemResource (sBase + "Order use cases/UC2_Order.xml"),
                                        new FileSystemResource (sBase + "Order use cases/UC3_Order.xml"),
                                        new FileSystemResource (sBase + "Order use cases/UC4_Order.xml"),
                                        new FileSystemResource (sBase + "Order use cases/UC5_Order.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "DespatchAdvice_Example.xml"),
                                        new FileSystemResource (sBase +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase1.xml"),
                                        new FileSystemResource (sBase +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase2.xml"),
                                        new FileSystemResource (sBase +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase3.xml"),
                                        new FileSystemResource (sBase +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase4.xml"),
                                        new FileSystemResource (sBase +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase5.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderResponse_Example.xml"),
                                        new FileSystemResource (sBase +
                                                                "Order-response use cases/UC1_Order_response.xml"),
                                        new FileSystemResource (sBase +
                                                                "Order-response use cases/UC2_Order_response.xml"),
                                        new FileSystemResource (sBase +
                                                                "Order-response use cases/UC3_Order_response.xml"),
                                        new FileSystemResource (sBase +
                                                                "Order-response use cases/UC4_Order_response.xml"),
                                        new FileSystemResource (sBase +
                                                                "Order-response use cases/UC5_Order_response.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "OrderAgreement_Example.xml"));

      final String sBase2 = sBase + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sBase + "InvoiceResponse_Example.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc001-Invoice in process.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002a-Additional reference data.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc002b-In process but postponed.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc003-Invoice is accepted.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004a-Invoice is rejected.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc004b-Rejected requesting reissue.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc004c-Rejected requesting replacement.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc005-Invoice is conditionally accepted.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc006a-Under query missing information.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006b-Missing PO.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc006c-Wrong detail partial credit.xml"),
                                        new FileSystemResource (sBase2 + "T111-uc007-Payment has been initiated.xml"),
                                        new FileSystemResource (sBase2 +
                                                                "T111-uc008-Invoice is accepted by third party.xml"));
    }

    /* Peppol Directory BusinessCard */
    if (aVESID.equals (PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V1))
    {
      final String sBase = sTestFiles + "business-card/v1/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "bc-0088-5033466000005.xml"),
                                      new FileSystemResource (sBase + "bc-9915-leckma.xml"),
                                      new FileSystemResource (sBase + "business-card-example-spec-v1.xml"),
                                      new FileSystemResource (sBase + "business-card-test1.xml"));
    }

    if (aVESID.equals (PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V2))
    {
      final String sBase = sTestFiles + "business-card/v2/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "bc-0088-5033466000005.xml"),
                                      new FileSystemResource (sBase + "bc-9915-leckma.xml"),
                                      new FileSystemResource (sBase + "business-card-example-spec-v2.xml"),
                                      new FileSystemResource (sBase + "business-card-test1.xml"),
                                      new FileSystemResource (sBase + "nemhandel.xml"));
    }

    if (aVESID.equals (PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V3))
    {
      final String sBase = sTestFiles + "business-card/v3/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "bc-0088-5033466000005.xml"),
                                      new FileSystemResource (sBase + "bc1.xml"),
                                      new FileSystemResource (sBase + "bc-9915-leckma.xml"),
                                      new FileSystemResource (sBase + "bc-9930-de811152493.xml"),
                                      new FileSystemResource (sBase + "business-card-cctf-103.xml"),
                                      new FileSystemResource (sBase + "business-card-example-spec-v3.xml"),
                                      new FileSystemResource (sBase + "business-card-test1.xml"),
                                      new FileSystemResource (sBase + "business-card-test2.xml"));
    }

    /* Peppol Reporting */
    // EUSR
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V100RC2))
    {
      final String sBase = sTestFiles + "reporting/eusr/1.0.0-RC2/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sBase + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sBase + "end-user-statistics-reporting-minimal.xml"));
    }
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V100))
    {
      final String sBase = sTestFiles + "reporting/eusr/1.0.0/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sBase + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sBase + "end-user-statistics-reporting-minimal.xml"));
    }

    // TSR
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_TSR_V100))
    {
      final String sBase = sTestFiles + "reporting/tsr/1.0.0/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "transaction-statistics-2.xml"),
                                      new FileSystemResource (sBase + "transaction-statistics-minimal.xml"));
    }
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_TSR_V101))
    {
      final String sBase = sTestFiles + "reporting/tsr/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sBase + "transaction-statistics-2.xml"),
                                      new FileSystemResource (sBase + "transaction-statistics-minimal.xml"));
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
