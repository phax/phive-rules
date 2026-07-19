/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.peppol.PeppolValidation;
import com.helger.phive.peppol.PeppolValidation2025_05;
import com.helger.phive.peppol.PeppolValidation2025_11;
import com.helger.phive.peppol.PeppolValidation2026_03;
import com.helger.phive.peppol.PeppolValidation2026_05;
import com.helger.phive.peppol.PeppolValidationBisAUNZ;
import com.helger.phive.peppol.PeppolValidationBisSG;
import com.helger.phive.peppol.PeppolValidationDirectory;
import com.helger.phive.peppol.PeppolValidationMLS;
import com.helger.phive.peppol.PeppolValidationReporting;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    EN16931Validation.initEN16931 (VES_REGISTRY);
    PeppolValidation.initStandard (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aVESID : new DVRCoordinate [] { /* BIS AU_NZ */
                                                             PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_11,
                                                             PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_11,
                                                             PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_11,
                                                             PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_11,

                                                             PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_12,
                                                             PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_12,
                                                             PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_12,
                                                             PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_12,

                                                             /* BIS Singapore */
                                                             PeppolValidationBisSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_7,
                                                             PeppolValidationBisSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_7,

                                                             PeppolValidationBisSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_12,
                                                             PeppolValidationBisSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_12,

                                                             PeppolValidationBisSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2024_12,
                                                             PeppolValidationBisSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2024_12,

                                                             PeppolValidationBisSG.VID_PEPPOL_SG_ORDER_BALANCE_1_0,

                                                             /* OpenPeppol BIS */
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_INVOICE_UBL_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                                             // PeppolValidation2025_05.VID_OPENPEPPOL_INVOICE_CII_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_CATALOGUE_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_MLR_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_CHANGE_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_CANCELLATION_V3,
                                                             PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3,

                                                             PeppolValidation2025_11.VID_OPENPEPPOL_INVOICE_UBL_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                                             // PeppolValidation2025_11.VID_OPENPEPPOL_INVOICE_CII_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_ORDER_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_CATALOGUE_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_MLR_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_ORDER_CHANGE_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_ORDER_CANCELLATION_V3,
                                                             PeppolValidation2025_11.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3,

                                                             PeppolValidation2026_03.VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3,
                                                             PeppolValidation2026_03.VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3,

                                                             PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_UBL_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_CATALOGUE_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_MLR_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_CHANGE_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_CANCELLATION_V3,
                                                             PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3,

                                                             /*
                                                              * OpenPeppol Directory
                                                              */
                                                             PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V1,
                                                             PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V2,
                                                             PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V3,

                                                             // OpenPeppol MLS
                                                             PeppolValidationMLS.VID_OPENPEPPOL_MLS_V100,

                                                             /*
                                                              * OpenPeppol Reporting
                                                              */
                                                             PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V114,
                                                             PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V115,

                                                             PeppolValidationReporting.VID_OPENPEPPOL_TSR_V104,
                                                             PeppolValidationReporting.VID_OPENPEPPOL_TSR_V105,

    })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aVESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aVESID));
      }
    return ret;
  }

  @NonNull
  @ReturnsMutableCopy
  private static ICommonsList <@NonNull FileSystemResource> _getAll (@NonNull final String sPrefix,
                                                                     @NonNull final String @NonNull... aFilenames)
  {
    final String sPrefix0 = "src/test/resources/external/test-files/";
    final ICommonsList <FileSystemResource> ret = new CommonsArrayList <> (aFilenames.length);
    for (final String s : aFilenames)
      ret.add (new FileSystemResource (sPrefix0 + sPrefix + s));
    return ret;
  }

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@NonNull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    // AUNZ 1.0.11
    if (aVESID.equals (PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_11))
    {
      return _getAll ("aunz-peppol/1.0.11/",
                      "AU Freight - Document Level.xml",
                      "AU Freight - Line Item.xml",
                      "AU Freight Only - Line Item.xml",
                      "AU GST Only.xml",
                      "AU GST Only - Prepaid.xml",
                      "AU Invoice.xml",
                      "AU Invoice Energy Bill Example_1.xml",
                      "AU Invoice Energy Bill Example_2.xml",
                      "AU Invoice Energy Bill Example_3_negative_inv.xml",
                      "NZ Allowance On Invoice Line.xml",
                      "NZ Invoice Level Allowance.xml",
                      "NZ Invoice Level Charge.xml",
                      "NZ No Allowances.xml",
                      "NZ Prepaid Amount.xml");
    }
    if (aVESID.equals (PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_11))
    {
      return _getAll ("aunz-peppol/1.0.11/", "AU Credit_note.xml", "NZ Credit note.xml");
    }
    if (aVESID.equals (PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_11))
    {
      return _getAll ("aunz-peppol/1.0.11/", "AU Self Billing.xml", "NZ Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_11))
    {
      return _getAll ("aunz-peppol/1.0.11/", "NZ Self Billed Credit note.xml");
    }

    // AUNZ 1.0.12
    if (aVESID.equals (PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_12))
    {
      return _getAll ("aunz-peppol/1.0.12/",
                      "AU Freight - Document Level.xml",
                      "AU Freight - Line Item.xml",
                      "AU Freight Only - Line Item.xml",
                      "AU GST Only.xml",
                      "AU GST Only - Prepaid.xml",
                      "AU Invoice.xml",
                      "AU Invoice Energy Bill Example_1.xml",
                      "AU Invoice Energy Bill Example_2.xml",
                      "AU Invoice Energy Bill Example_3_negative_inv.xml",
                      "NZ Allowance On Invoice Line.xml",
                      "NZ Invoice Level Allowance.xml",
                      "NZ Invoice Level Charge.xml",
                      "NZ Prepaid Amount.xml");
    }
    if (aVESID.equals (PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_12))
    {
      return _getAll ("aunz-peppol/1.0.12/", "AU Credit_note.xml", "NZ Credit note.xml");
    }
    if (aVESID.equals (PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_12))
    {
      return _getAll ("aunz-peppol/1.0.12/", "AU Self Billing.xml", "NZ Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_12))
    {
      return _getAll ("aunz-peppol/1.0.12/", "NZ Self Billed Credit note.xml");
    }

    // SG 2023.07
    if (aVESID.equals (PeppolValidationBisSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_7))
    {
      return _getAll ("sg-peppol/2023.7/",
                      "SG INV example 02 - full valid invoice 1.xml",
                      "SG INV example 03 - Allowances and Charges.xml",
                      "SG INV example 04 - none GST registered.xml",
                      "SG INV example 05 - AGD compliant with II and PO reference.xml",
                      "SG INV example 06 - Foreign currency.xml",
                      "SG INV example 07 - Foreign buyer.xml",
                      "SG INV example 08 - Factored invoice.xml",
                      "SG INV example 09 - Zero rated GST.xml",
                      "SG INV example 10 - Prepayment.xml",
                      "SG INV example 11 - Decimals.xml",
                      "SG INV example 12 - SG bank transfer.xml",
                      "SG INV example 13 - SG GIRO.xml",
                      "SG INV example 14 - PayNow.xml",
                      "SG INV example 15 - Credit card.xml",
                      "SG INV example 16 - GST in SGD.xml"
      /*
       * , "SG INV example 16b - GST in SGD With Several Errors.xml")
       */);
    }
    if (aVESID.equals (PeppolValidationBisSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_7))
    {
      return _getAll ("sg-peppol/2023.7/", "SG CN example 01 - Credit Note.xml");
    }

    // SG 2023.12
    if (aVESID.equals (PeppolValidationBisSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_12))
    {
      return _getAll ("sg-peppol/2023.12/",
                      "SG INV example 02 - full valid invoice 1.xml",
                      "SG INV example 03 - Allowances and Charges.xml",
                      "SG INV example 04 - none GST registered.xml",
                      "SG INV example 05 - AGD compliant with II and PO reference.xml",
                      "SG INV example 06 - Foreign currency.xml",
                      "SG INV example 07 - Foreign buyer.xml",
                      "SG INV example 08 - Factored invoice.xml",
                      "SG INV example 09 - Zero rated GST.xml",
                      "SG INV example 10 - Prepayment.xml",
                      "SG INV example 11 - Decimals.xml",
                      "SG INV example 12 - SG bank transfer.xml",
                      "SG INV example 13 - SG GIRO.xml",
                      "SG INV example 14 - PayNow.xml",
                      "SG INV example 15 - Credit card.xml",
                      "SG INV example 16 - GST in SGD.xml"
      /*
       * , "SG INV example 16b - GST in SGD With Several Errors.xml")
       */);
    }
    if (aVESID.equals (PeppolValidationBisSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_12))
    {
      return _getAll ("sg-peppol/2023.12/", "SG CN example 01 - Credit Note.xml");
    }

    // SG 2024.12
    if (aVESID.equals (PeppolValidationBisSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2024_12))
    {
      return _getAll ("sg-peppol/2024.12/",
                      "SG INV example 02 - full valid invoice 1.xml",
                      "SG INV example 03 - Allowances and Charges.xml",
                      "SG INV example 04 - none GST registered.xml",
                      "SG INV example 05 - AGD compliant with II and PO reference.xml",
                      "SG INV example 06 - Foreign currency.xml",
                      "SG INV example 07 - Foreign buyer.xml",
                      "SG INV example 08 - Factored invoice.xml",
                      "SG INV example 09 - Zero rated GST.xml",
                      "SG INV example 10 - Prepayment.xml",
                      "SG INV example 11 - Decimals.xml",
                      "SG INV example 12 - SG bank transfer.xml",
                      "SG INV example 13 - SG GIRO.xml",
                      "SG INV example 14 - PayNow.xml",
                      "SG INV example 15 - Credit card.xml",
                      "SG INV example 16 - GST in SGD.xml"
      /*
       * , "SG INV example 16b - GST in SGD With Several Errors.xml")
       */);
    }
    if (aVESID.equals (PeppolValidationBisSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2024_12))
    {
      return _getAll ("sg-peppol/2024.12/", "SG CN example 01 - Credit Note.xml");
    }

    // SG OB 1.0
    if (aVESID.equals (PeppolValidationBisSG.VID_PEPPOL_SG_ORDER_BALANCE_1_0))
    {
      return _getAll ("sg-peppol/ob-1.0/", "Order_balance_finalized.xml", "Order_balance_MAX.xml", "Order_balance.xml");
    }

    // 2025-05
    {

      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_INVOICE_UBL_V3))
        return _getAll ("openpeppol/2025.5/",
                        "billing/Allowance-example.xml",
                        "billing/base-example.xml",
                        "billing/base-example-de.xml",
                        "billing/base-negative-inv-correction.xml",
                        "billing/vat-category-E.xml",
                        "billing/vat-category-O.xml",
                        "billing/Vat-category-S.xml",
                        "billing/vat-category-Z.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3))
        return _getAll ("openpeppol/2025.5/", "billing/base-creditnote-correction.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_V3))
        return _getAll ("openpeppol/2025.5/",
                        "Order_Example.xml",
                        "Order use cases/UC1_Order.xml",
                        "Order use cases/UC2_Order.xml",
                        "Order use cases/UC3_Order.xml",
                        "Order use cases/UC4_Order.xml",
                        "Order use cases/UC5_Order.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return _getAll ("openpeppol/2025.5/",
                        "DespatchAdvice_Example.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase1.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase2.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase3.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase4.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase5.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_CATALOGUE_V3))
        return _getAll ("openpeppol/2025.5/", "Catalogue_Example.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return _getAll ("openpeppol/2025.5/", "CatalogueResponse_Example.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_MLR_V3))
        return _getAll ("openpeppol/2025.5/", "MessageLevelResponse_Example.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return _getAll ("openpeppol/2025.5/",
                        "OrderResponse_Example.xml",
                        "Order-response use cases/UC1_Order_response.xml",
                        "Order-response use cases/UC2_Order_response.xml",
                        "Order-response use cases/UC3_Order_response.xml",
                        "Order-response use cases/UC4_Order_response.xml",
                        "Order-response use cases/UC5_Order_response.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return _getAll ("openpeppol/2025.5/", "PunchOut_Example.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return _getAll ("openpeppol/2025.5/", "OrderAgreement_Example.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return _getAll ("openpeppol/2025.5/",
                        "InvoiceResponse_Example.xml",
                        "Invoice reponse use cases/T111-uc001-Invoice in process.xml",
                        "Invoice reponse use cases/T111-uc002a-Additional reference data.xml",
                        "Invoice reponse use cases/T111-uc002b-In process but postponed.xml",
                        "Invoice reponse use cases/T111-uc003-Invoice is accepted.xml",
                        "Invoice reponse use cases/T111-uc004a-Invoice is rejected.xml",
                        "Invoice reponse use cases/T111-uc004b-Rejected requesting reissue.xml",
                        "Invoice reponse use cases/T111-uc004c-Rejected requesting replacement.xml",
                        "Invoice reponse use cases/T111-uc005-Invoice is conditionally accepted.xml",
                        "Invoice reponse use cases/T111-uc006a-Under query missing information.xml",
                        "Invoice reponse use cases/T111-uc006b-Missing PO.xml",
                        "Invoice reponse use cases/T111-uc006c-Wrong detail partial credit.xml",
                        "Invoice reponse use cases/T111-uc007-Payment has been initiated.xml",
                        "Invoice reponse use cases/T111-uc008-Invoice is accepted by third party.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_CHANGE_V3))
        return _getAll ("openpeppol/2025.5/", "OrderChange_Example.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_CANCELLATION_V3))
        return _getAll ("openpeppol/2025.5/", "OrderCancellation_Example.xml");
      if (aVESID.equals (PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3))
        return _getAll ("openpeppol/2025.5/", "OrderResponseAdvanced_Example.xml");
    }

    // 2025-11
    {

      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_INVOICE_UBL_V3))
        return _getAll ("openpeppol/2025.11/",
                        "billing/Allowance-example.xml",
                        "billing/base-example.xml",
                        "billing/base-negative-inv-correction.xml",
                        "billing/vat-category-E.xml",
                        "billing/vat-category-O.xml",
                        "billing/Vat-category-S.xml",
                        "billing/vat-category-Z.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3))
        return _getAll ("openpeppol/2025.11/", "billing/base-creditnote-correction.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_ORDER_V3))
        return _getAll ("openpeppol/2025.11/",
                        "Order_Example.xml",
                        "Order use cases/UC1_Order.xml",
                        "Order use cases/UC2_Order.xml",
                        "Order use cases/UC3_Order.xml",
                        "Order use cases/UC4_Order.xml",
                        "Order use cases/UC5_Order.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return _getAll ("openpeppol/2025.11/",
                        "DespatchAdvice_Example.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase1.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase2.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase3.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase4.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase5.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_CATALOGUE_V3))
        return _getAll ("openpeppol/2025.11/", "Catalogue_Example.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return _getAll ("openpeppol/2025.11/", "CatalogueResponse_Example.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_MLR_V3))
        return _getAll ("openpeppol/2025.11/", "MessageLevelResponse_Example.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return _getAll ("openpeppol/2025.11/",
                        "OrderResponse_Example.xml",
                        "Order-response use cases/UC1_Order_response.xml",
                        "Order-response use cases/UC2_Order_response.xml",
                        "Order-response use cases/UC3_Order_response.xml",
                        "Order-response use cases/UC4_Order_response.xml",
                        "Order-response use cases/UC5_Order_response.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return _getAll ("openpeppol/2025.11/", "PunchOut_Example.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return _getAll ("openpeppol/2025.11/", "OrderAgreement_Example.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return _getAll ("openpeppol/2025.11/",
                        "InvoiceResponse_Example.xml",
                        "Invoice reponse use cases/T111-uc001-Invoice in process.xml",
                        "Invoice reponse use cases/T111-uc002a-Additional reference data.xml",
                        "Invoice reponse use cases/T111-uc002b-In process but postponed.xml",
                        "Invoice reponse use cases/T111-uc003-Invoice is accepted.xml",
                        "Invoice reponse use cases/T111-uc004a-Invoice is rejected.xml",
                        "Invoice reponse use cases/T111-uc004b-Rejected requesting reissue.xml",
                        "Invoice reponse use cases/T111-uc004c-Rejected requesting replacement.xml",
                        "Invoice reponse use cases/T111-uc005-Invoice is conditionally accepted.xml",
                        "Invoice reponse use cases/T111-uc006a-Under query missing information.xml",
                        "Invoice reponse use cases/T111-uc006b-Missing PO.xml",
                        "Invoice reponse use cases/T111-uc006c-Wrong detail partial credit.xml",
                        "Invoice reponse use cases/T111-uc007-Payment has been initiated.xml",
                        "Invoice reponse use cases/T111-uc008-Invoice is accepted by third party.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_ORDER_CHANGE_V3))
        return _getAll ("openpeppol/2025.11/", "OrderChange_Example.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_ORDER_CANCELLATION_V3))
        return _getAll ("openpeppol/2025.11/", "OrderCancellation_Example.xml");
      if (aVESID.equals (PeppolValidation2025_11.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3))
        return _getAll ("openpeppol/2025.11/", "OrderResponseAdvanced_Example.xml");
    }

    // 2026-03
    {
      if (aVESID.equals (PeppolValidation2026_03.VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3))
        return _getAll ("openpeppol/2026.3/",
                        "SB-Allowance-example.xml",
                        "SB-base-example.xml",
                        "SB-base-negative-inv-correction.xml",
                        "SB-sales-order-example.xml",
                        "SB-vat-category-E.xml",
                        "SB-vat-category-O.xml",
                        "SB-Vat-category-S.xml",
                        "SB-vat-category-Z.xml");
      if (aVESID.equals (PeppolValidation2026_03.VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3))
        return _getAll ("openpeppol/2026.3/", "SB-base-creditnote-correction.xml");
    }

    // 2026-05
    {
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_UBL_V3))
        return _getAll ("openpeppol/2026.5/",
                        "billing/Allowance-example.xml",
                        "billing/base-example.xml",
                        "billing/base-example_profile02.xml",
                        "billing/base-negative-inv-correction.xml",
                        "billing/vat-category-E.xml",
                        "billing/vat-category-O.xml",
                        "billing/Vat-category-S.xml",
                        "billing/vat-category-Z.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3))
        return _getAll ("openpeppol/2026.5/", "billing/base-creditnote-correction.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3))
        return _getAll ("openpeppol/2026.5/",
                        "SB-Allowance-example.xml",
                        "SB-base-example.xml",
                        "SB-base-negative-inv-correction.xml",
                        "SB-sales-order-example.xml",
                        "SB-vat-category-E.xml",
                        "SB-vat-category-O.xml",
                        "SB-Vat-category-S.xml",
                        "SB-vat-category-Z.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3))
        return _getAll ("openpeppol/2026.5/", "SB-base-creditnote-correction.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_V3))
        return _getAll ("openpeppol/2026.5/",
                        "Order_Example.xml",
                        "Order use cases/UC1_Order.xml",
                        "Order use cases/UC2_Order.xml",
                        "Order use cases/UC3_Order.xml",
                        "Order use cases/UC4_Order.xml",
                        "Order use cases/UC5_Order.xml",
                        "Order use cases/UC6_Order.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return _getAll ("openpeppol/2026.5/",
                        "DespatchAdvice_Example.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase1.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase2.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase3.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase4.xml",
                        "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase5.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_CATALOGUE_V3))
        return _getAll ("openpeppol/2026.5/",
                        "Catalogue_Example.xml",
                        "Cataloge wo response use cases/catalogue-wo-response-use-case-1.xml",
                        "Cataloge wo response use cases/catalogue-wo-response-use-case-2.xml",
                        "Cataloge wo response use cases/catalogue-wo-response-use-case-3.xml",
                        "Cataloge wo response use cases/catalogue-wo-response-use-case-4.xml",
                        "Cataloge wo response use cases/catalogue-wo-response-use-case-5.xml",
                        "Cataloge wo response use cases/catalogue-wo-response-use-case-6.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return _getAll ("openpeppol/2026.5/", "CatalogueResponse_Example.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_MLR_V3))
        return _getAll ("openpeppol/2026.5/", "MessageLevelResponse_Example.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return _getAll ("openpeppol/2026.5/",
                        "OrderResponse_Example.xml",
                        "Order-response use cases/UC1_Order_response.xml",
                        "Order-response use cases/UC2_Order_response.xml",
                        "Order-response use cases/UC3_Order_response.xml",
                        "Order-response use cases/UC4_Order_response.xml",
                        "Order-response use cases/UC5_Order_response.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return _getAll ("openpeppol/2026.5/", "PunchOut_Example.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return _getAll ("openpeppol/2026.5/", "OrderAgreement_Example.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return _getAll ("openpeppol/2026.5/",
                        "InvoiceResponse_Example.xml",
                        "Invoice reponse use cases/T111-uc001-Invoice in process.xml",
                        "Invoice reponse use cases/T111-uc002a-Additional reference data.xml",
                        "Invoice reponse use cases/T111-uc002b-In process but postponed.xml",
                        "Invoice reponse use cases/T111-uc003-Invoice is accepted.xml",
                        "Invoice reponse use cases/T111-uc004a-Invoice is rejected.xml",
                        "Invoice reponse use cases/T111-uc004b-Rejected requesting reissue.xml",
                        "Invoice reponse use cases/T111-uc004c-Rejected requesting replacement.xml",
                        "Invoice reponse use cases/T111-uc005-Invoice is conditionally accepted.xml",
                        "Invoice reponse use cases/T111-uc006a-Under query missing information.xml",
                        "Invoice reponse use cases/T111-uc006b-Missing PO.xml",
                        "Invoice reponse use cases/T111-uc006c-Wrong detail partial credit.xml",
                        "Invoice reponse use cases/T111-uc007-Payment has been initiated.xml",
                        "Invoice reponse use cases/T111-uc008-Invoice is accepted by third party.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_CHANGE_V3))
        return _getAll ("openpeppol/2026.5/", "OrderChange_Example.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_CANCELLATION_V3))
        return _getAll ("openpeppol/2026.5/", "OrderCancellation_Example.xml");
      if (aVESID.equals (PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3))
        return _getAll ("openpeppol/2026.5/", "OrderResponseAdvanced_Example.xml");
    }

    /* Peppol Directory BusinessCard */
    if (aVESID.equals (PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V1))
    {
      return _getAll ("business-card/v1/",
                      "bc-0088-5033466000005.xml",
                      "bc-9915-leckma.xml",
                      "business-card-example-spec-v1.xml",
                      "business-card-test1.xml");
    }
    if (aVESID.equals (PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V2))
    {
      return _getAll ("business-card/v2/",
                      "bc-0088-5033466000005.xml",
                      "bc-9915-leckma.xml",
                      "business-card-example-spec-v2.xml",
                      "business-card-test1.xml",
                      "nemhandel.xml");
    }
    if (aVESID.equals (PeppolValidationDirectory.VID_OPENPEPPOL_BUSINESS_CARD_V3))
    {
      return _getAll ("business-card/v3/",
                      "bc-0088-5033466000005.xml",
                      "bc1.xml",
                      "bc-9915-leckma.xml",
                      "bc-9930-de811152493.xml",
                      "business-card-cctf-103.xml",
                      "business-card-example-spec-v3.xml",
                      "business-card-test1.xml",
                      "business-card-test2.xml");
    }

    // Peppol MLS
    if (aVESID.equals (PeppolValidationMLS.VID_OPENPEPPOL_MLS_V100))
    {
      return _getAll ("mls/1.0.0/",
                      "MessageLevelStatus_Example_AB.xml",
                      "MessageLevelStatus_Example_AB2.xml",
                      "MessageLevelStatus_Example_AB3.xml",
                      "MessageLevelStatus_Example_AP.xml",
                      "MessageLevelStatus_Example_RE.xml",
                      "MessageLevelStatus_Example_RE2.xml",
                      "MessageLevelStatus_Example_RE3.xml",
                      "MessageLevelStatus_Example_RE4.xml");
    }

    /* Peppol Reporting */
    // EUSR
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V114))
    {
      return _getAll ("reporting/eusr/1.1.4/",
                      "end-user-statistics-reporting-1.xml",
                      "end-user-statistics-reporting-2.xml",
                      "end-user-statistics-reporting-empty.xml",
                      "end-user-statistics-reporting-minimal.xml",
                      "eusr-generated-1.xml",
                      "eusr-good-template.xml");
    }
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_EUSR_V115))
    {
      return _getAll ("reporting/eusr/1.1.5/",
                      "end-user-statistics-reporting-1.xml",
                      "end-user-statistics-reporting-2.xml",
                      "end-user-statistics-reporting-empty.xml",
                      "end-user-statistics-reporting-minimal.xml",
                      "eusr-generated-1.xml",
                      "eusr-good-template.xml");
    }

    // TSR
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_TSR_V104))
    {
      return _getAll ("reporting/tsr/1.0.4/",
                      "transaction-statistics-2.xml",
                      "transaction-statistics-3.xml",
                      "transaction-statistics-4.xml",
                      "transaction-statistics-minimal.xml");
    }
    if (aVESID.equals (PeppolValidationReporting.VID_OPENPEPPOL_TSR_V105))
    {
      return _getAll ("reporting/tsr/1.0.5/",
                      "transaction-statistics-2.xml",
                      "transaction-statistics-3.xml",
                      "transaction-statistics-4.xml",
                      "transaction-statistics-minimal.xml");
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
