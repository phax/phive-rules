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
import com.helger.phive.peppol.PeppolValidation2025_03;
import com.helger.phive.peppol.PeppolValidation2025_05;
import com.helger.phive.peppol.PeppolValidation2025_11;
import com.helger.phive.peppol.PeppolValidation2026_03;
import com.helger.phive.peppol.PeppolValidationBisAUNZ;
import com.helger.phive.peppol.PeppolValidationBisSG;
import com.helger.phive.peppol.PeppolValidationDirectory;
import com.helger.phive.peppol.PeppolValidationMLS;
import com.helger.phive.peppol.PeppolValidationPintAE;
import com.helger.phive.peppol.PeppolValidationPintAUNZ;
import com.helger.phive.peppol.PeppolValidationPintEU;
import com.helger.phive.peppol.PeppolValidationPintJP;
import com.helger.phive.peppol.PeppolValidationPintJP_NTR;
import com.helger.phive.peppol.PeppolValidationPintJP_SB;
import com.helger.phive.peppol.PeppolValidationPintMY;
import com.helger.phive.peppol.PeppolValidationPintSG;
import com.helger.phive.peppol.PeppolValidationReporting;
import com.helger.phive.peppol.PeppolValidationTaxData;
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
                                                             PeppolValidation2025_03.VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3,
                                                             PeppolValidation2025_03.VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3,

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

                                                             /* Peppol TaxData */
                                                             PeppolValidationTaxData.VID_OPENPEPPOL_TDD_AE_1_0_0,
                                                             PeppolValidationTaxData.VID_OPENPEPPOL_TDD_AE_1_0_1,
                                                             PeppolValidationTaxData.VID_OPENPEPPOL_TDD_AE_1_0_2,

                                                             PeppolValidationTaxData.VID_OPENPEPPOL_TDD_SK_1_0_0,

                                                             PeppolValidationTaxData.VID_OPENPEPPOL_TDD_VIDA_1_0_0,

                                                             /* PINT AE */
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_INVOICE_0_9_0,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_0_9_0,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_INVOICE_0_9_0,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_0_9_0,

                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_INVOICE_2025_06,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_06,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_06,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_06,

                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_INVOICE_2025_07,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_07,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_07,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_07,

                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_INVOICE_2025_11,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_11,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_11,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_11,

                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_INVOICE_2026_03,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2026_03,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2026_03,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2026_03,

                                                             /* PINT A-NZ */
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_0_1,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_0_1,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_0_1,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_0_1,

                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_1_0,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_1_0,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_1_0,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_0,

                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_1_1,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_1_1,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_1_1,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_1,

                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_1_2,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_1_2,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_1_2,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_2,

                                                             /* PINT EU */
                                                             PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_INVOICE_2025_10,
                                                             PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_CREDIT_NOTE_2025_10,
                                                             PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_INVOICE_2025_11,
                                                             PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_CREDIT_NOTE_2025_11,

                                                             /* PINT Japan */
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_012,
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_012,
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_1_0_2,
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_0_2,
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_1_0_3,
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_0_3,
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_0,
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_0,
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_1,
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_1,
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_2,
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_2,

                                                             /* PINT Japan NTR */
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_0_1,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_0_1,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_1_0,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_1_0,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_1_1,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_1_1,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_1_2,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_1_2,

                                                             /* PINT Japan Self Billing */
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_0_1,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_0_1,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_1_0,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_1_0,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_1_1,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_1_1,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_1_2,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_1_2,

                                                             /* PINT Malaysia */
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_0_0,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_0_0,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_0_0,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_0_0,

                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_1_0,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_1_0,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_1_0,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_0,

                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_2_1,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_2_1,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_2_1,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_2_1,

                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_3_0,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_3_0,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_3_0,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_3_0,

                                                             /* PINT Singapore */
                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_1_0,
                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_1_0,

                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_2_0,
                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_2_0,

                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_3_0,
                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_3_0,

                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_4_0,
                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_4_0,

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

    // 2025-03
    {
      if (aVESID.equals (PeppolValidation2025_03.VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3))
        return _getAll ("openpeppol/2025.3/",
                        "SB-Allowance-example.xml",
                        "SB-base-example.xml",
                        "SB-base-negative-inv-correction.xml",
                        "SB-sales-order-example.xml",
                        "SB-vat-category-E.xml",
                        "SB-vat-category-O.xml",
                        "SB-Vat-category-S.xml",
                        "SB-vat-category-Z.xml");
      if (aVESID.equals (PeppolValidation2025_03.VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3))
        return _getAll ("openpeppol/2025.3/", "SB-base-creditnote-correction.xml");
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

    // AE TDD 1.0.0
    if (aVESID.equals (PeppolValidationTaxData.VID_OPENPEPPOL_TDD_AE_1_0_0))
    {
      return _getAll ("tdd/ae/1.0.0/",
                      "commercial-invoice-tdd.xml",
                      "simple.xml",
                      "standard-invoice-tdd.xml",
                      "tax-currency.xml");
    }

    // AE TDD 1.0.1
    if (aVESID.equals (PeppolValidationTaxData.VID_OPENPEPPOL_TDD_AE_1_0_1))
    {
      return _getAll ("tdd/ae/1.0.1/",
                      "commercial-invoice-tdd.xml",
                      "example-tds-no-repdoc.xml",
                      "example-tds-with-repdoc.xml",
                      "simple.xml",
                      "standard-invoice-tdd.xml",
                      "tax-currency.xml");
    }
    // AE TDD 1.0.2
    if (aVESID.equals (PeppolValidationTaxData.VID_OPENPEPPOL_TDD_AE_1_0_2))
    {
      return _getAll ("tdd/ae/1.0.2/",
                      "commercial-invoice-tdd.xml",
                      "example-tds-no-repdoc.xml",
                      "example-tds-with-repdoc.xml",
                      "simple.xml",
                      "standard-invoice-tdd.xml",
                      "tax-currency.xml");
    }

    // SK TDD 1.0.0
    if (aVESID.equals (PeppolValidationTaxData.VID_OPENPEPPOL_TDD_SK_1_0_0))
    {
      return _getAll ("tdd/sk/1.0.0/",
                      "Allowance-example.xml",
                      "base-creditnote-correction.xml",
                      "base-example.xml",
                      "base-negative-inv-correction.xml",
                      "vat-category-E.xml",
                      "vat-category-O.xml",
                      "Vat-category-S.xml",
                      "vat-category-Z.xml"
      // ,"WithoutTaxes-example.xml"
      );
    }

    // ViDA Pilot TDD 1.0.0
    if (aVESID.equals (PeppolValidationTaxData.VID_OPENPEPPOL_TDD_VIDA_1_0_0))
    {
      return _getAll ("tdd/vida/1.0.0/",
                      "Allowance-example.xml",
                      "base-creditnote-correction.xml",
                      "base-example.xml",
                      "base-negative-inv-correction.xml",
                      "SB-Allowance-example.xml",
                      "SB-base-creditnote-correction.xml",
                      "SB-base-example.xml",
                      "SB-base-negative-inv-correction.xml",
                      "SB-vat-category-E.xml",
                      "SB-vat-category-O.xml",
                      "SB-Vat-category-S.xml",
                      "SB-vat-category-Z.xml",
                      // "SB-WithoutTaxes-example.xml",
                      "vat-category-E.xml",
                      "vat-category-O.xml",
                      "Vat-category-S.xml",
                      "vat-category-Z.xml"
      // ,"WithoutTaxes-example.xml"
      );
    }

    /* PINT AE */
    // 0.9.0
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_INVOICE_0_9_0))
    {
      return _getAll ("pint-ae/0.9.0/billing/inv/",
                      "Commercial invoice.xml",
                      "Continuous supplies.xml",
                      "Deemed supply.xml",
                      "Disclosed agent billing.xml",
                      "Exports.xml",
                      "Margin scheme.xml",
                      "Standard invoice.xml",
                      "Standard invoice - Extensive.xml",
                      "Standard invoice Mandatory fields.xml",
                      "Standard tax invoice.xml",
                      "Summary tax invoice.xml",
                      "Supply involving free trade zone.xml",
                      "Supply through e-commerce.xml",
                      "Supply under Reverse charge mechanism.xml",
                      "Zero rated supplies.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_0_9_0))
    {
      return _getAll ("pint-ae/0.9.0/billing/cn/",
                      "Disclosed agent billing tax credit note.xml",
                      "Standard tax credit Note.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_INVOICE_0_9_0))
    {
      return _getAll ("pint-ae/0.9.0/selfbilling/inv/", "Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_0_9_0))
    {
      return _getAll ("pint-ae/0.9.0/selfbilling/cn/", "Self billing tax credit note.xml");
    }

    // 2025.6
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_INVOICE_2025_06))
    {
      return _getAll ("pint-ae/2025.6/billing/inv/",
                      "Commercial invoice.xml",
                      "Continuous supplies.xml",
                      "Deemed supply - predefined endpoint.xml",
                      "Disclosed agent billing.xml",
                      "Exports.xml",
                      "Exports - predefined endpoint.xml",
                      "Margin scheme.xml",
                      "Standard invoice - Extensive.xml",
                      "Standard invoice Mandatory fields.xml",
                      "Standard tax invoice.xml",
                      "Standard tax invoice - predefined endpoint.xml",
                      "Summary tax invoice.xml",
                      "Supply involving free trade zone.xml",
                      "Supply through e-commerce.xml",
                      "Supply under Reverse charge mechanism.xml",
                      "Zero rated supplies.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_06))
    {
      return _getAll ("pint-ae/2025.6/billing/cn/",
                      "Disclosed agent billing tax credit note.xml",
                      "Standard tax credit Note.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_06))
    {
      return _getAll ("pint-ae/2025.6/selfbilling/inv/", "Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_06))
    {
      return _getAll ("pint-ae/2025.6/selfbilling/cn/", "Self billing tax credit note.xml");
    }

    // 2025.7
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_INVOICE_2025_07))
    {
      return _getAll ("pint-ae/2025.7/billing/inv/",
                      "Commercial invoice.xml",
                      "Continuous supplies.xml",
                      "Deemed supply - predefined endpoint.xml",
                      "Disclosed agent billing.xml",
                      "Exports.xml",
                      "Exports - predefined endpoint.xml",
                      "Margin scheme.xml",
                      "Standard invoice - Extensive.xml",
                      "Standard invoice Mandatory fields.xml",
                      "Standard tax invoice.xml",
                      "Standard tax invoice - predefined endpoint.xml",
                      "Summary tax invoice.xml",
                      "Supply involving free trade zone.xml",
                      "Supply through e-commerce.xml",
                      "Supply under Reverse charge mechanism.xml",
                      "Zero rated supplies.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_07))
    {
      return _getAll ("pint-ae/2025.7/billing/cn/",
                      "Disclosed agent billing tax credit note.xml",
                      "Standard tax credit Note.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_07))
    {
      return _getAll ("pint-ae/2025.7/selfbilling/inv/", "Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_07))
    {
      return _getAll ("pint-ae/2025.7/selfbilling/cn/", "Self billing tax credit note.xml");
    }

    // 2025.11
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_INVOICE_2025_11))
    {
      return _getAll ("pint-ae/2025.11/billing/inv/",
                      "Commercial invoice.xml",
                      "Continuous supplies.xml",
                      "Deemed supply - predefined endpoint.xml",
                      "Disclosed agent billing.xml",
                      "Exports.xml",
                      "Exports - predefined endpoint.xml",
                      "Margin scheme.xml",
                      "Standard invoice - Extensive.xml",
                      "Standard invoice Mandatory fields.xml",
                      "Standard tax invoice.xml",
                      "Standard tax invoice - predefined endpoint.xml",
                      "Summary tax invoice.xml",
                      "Supply involving free trade zone.xml",
                      "Supply through e-commerce.xml",
                      "Supply under Reverse charge mechanism.xml",
                      "Zero rated supplies.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_11))
    {
      return _getAll ("pint-ae/2025.11/billing/cn/",
                      "Disclosed agent billing tax credit note.xml",
                      "Standard tax credit Note.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_11))
    {
      return _getAll ("pint-ae/2025.11/selfbilling/inv/", "Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_11))
    {
      return _getAll ("pint-ae/2025.11/selfbilling/cn/", "Self billing tax credit note.xml");
    }

    // 2026.3
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_INVOICE_2026_03))
    {
      return _getAll ("pint-ae/2026.3/billing/inv/",
                      "Commercial invoice.xml",
                      // "Continuous
                      // supplies.xml",
                      // "Deemed supply -
                      // predefined endpoint.xml",
                      // "Disclosed agent
                      // billing.xml",
                      "Exports.xml",
                      // "Exports - predefined
                      // endpoint.xml",
                      "Margin scheme.xml",
                      // "Standard invoice -
                      // Extensive.xml",
                      "Standard invoice Mandatory fields.xml",
                      "Standard tax invoice.xml",
                      // "Standard tax invoice -
                      // predefined endpoint.xml",
                      "Summary tax invoice.xml",
                      "Supply involving free trade zone.xml",
                      "Supply through e-commerce.xml",
                      "Supply under Reverse charge mechanism.xml",
                      "Zero rated supplies.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2026_03))
    {
      return _getAll ("pint-ae/2026.3/billing/cn/",
                      "Disclosed agent billing tax credit note.xml",
                      "Standard tax credit Note.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2026_03))
    {
      return _getAll ("pint-ae/2026.3/selfbilling/inv/", "Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2026_03))
    {
      return _getAll ("pint-ae/2026.3/selfbilling/cn/", "Self billing tax credit note.xml");
    }

    /* PINT AUNZ */
    // 1.0.1
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_0_1))
    {
      return _getAll ("pint-aunz/1.0.1/billing/",
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
                      "NZ Prepaid Amount.xml",
                      "PINT_AUNZ_invoice.xml",
                      "PINT_AUNZ_negative_invoice.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_0_1))
    {
      return _getAll ("pint-aunz/1.0.1/billing/", "AU Credit note.xml", "NZ Credit note.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_0_1))
    {
      return _getAll ("pint-aunz/1.0.1/selfbilling/",
                      "AUNZ Self Billing.xml",
                      "AU Self Billing - Negative Invoice.xml",
                      "NZ Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_0_1))
    {
      return _getAll ("pint-aunz/1.0.1/selfbilling/",
                      "AU Self Billed Credit Note.xml",
                      "NZ Self Billed Credit note.xml");
    }

    // 1.1.0
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_1_0))
    {
      return _getAll ("pint-aunz/1.1.0/billing/",
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
                      "NZ Prepaid Amount.xml",
                      "PINT_AUNZ_invoice.xml",
                      "PINT_AUNZ_negative_invoice.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_1_0))
    {
      return _getAll ("pint-aunz/1.1.0/billing/", "AU Credit note.xml", "NZ Credit note.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_1_0))
    {
      return _getAll ("pint-aunz/1.1.0/selfbilling/",
                      "AUNZ Self Billing.xml",
                      "AU Self Billing - Negative Invoice.xml",
                      "NZ Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_0))
    {
      return _getAll ("pint-aunz/1.1.0/selfbilling/",
                      "AU Self Billed Credit Note.xml",
                      "NZ Self Billed Credit note.xml");
    }

    // 1.1.1
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_1_1))
    {
      return _getAll ("pint-aunz/1.1.1/billing/",
                      "AU Freight - Document Level.xml",
                      "AU Freight - Line Item.xml",
                      "AU Freight Only - Line Item.xml",
                      "AU GST Only.xml",
                      "AU GST Only - Prepaid.xml",
                      "AU Invoice.xml",
                      "AU Invoice Annual Insurance.xml",
                      "AU Invoice Energy Bill Example_1.xml",
                      "AU Invoice Energy Bill Example_2.xml",
                      "AU Invoice Energy Bill Example_3_negative_inv.xml",
                      "NZ Allowance On Invoice Line.xml",
                      "NZ Invoice Level Allowance.xml",
                      "NZ Invoice Level Charge.xml",
                      "NZ No Allowances.xml",
                      "NZ Prepaid Amount.xml",
                      "PINT_AUNZ_invoice.xml",
                      "PINT_AUNZ_negative_invoice.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_1_1))
    {
      return _getAll ("pint-aunz/1.1.1/billing/", "AU Credit note.xml", "NZ Credit note.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_1_1))
    {
      return _getAll ("pint-aunz/1.1.1/selfbilling/",
                      "AUNZ Self Billing.xml",
                      "AU Self Billing - Negative Invoice.xml",
                      "NZ Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_1))
    {
      return _getAll ("pint-aunz/1.1.1/selfbilling/",
                      "AU Self Billed Credit Note.xml",
                      "NZ Self Billed Credit note.xml");
    }

    // 1.1.2
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_1_2))
    {
      return _getAll ("pint-aunz/1.1.2/billing/",
                      "AU Freight - Document Level.xml",
                      "AU Freight - Line Item.xml",
                      "AU Freight Only - Line Item.xml",
                      "AU GST Only.xml",
                      "AU GST Only - Prepaid.xml",
                      "AU Invoice.xml",
                      "AU Invoice Annual Insurance.xml",
                      "AU Invoice Energy Bill Example_1.xml",
                      "AU Invoice Energy Bill Example_2.xml",
                      "AU Invoice Energy Bill Example_3_negative_inv.xml",
                      "NZ Allowance On Invoice Line.xml",
                      "NZ Invoice Level Allowance.xml",
                      "NZ Invoice Level Charge.xml",
                      "NZ No Allowances.xml",
                      "NZ Prepaid Amount.xml",
                      "PINT_AUNZ_invoice.xml",
                      "PINT_AUNZ_negative_invoice.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_1_2))
    {
      return _getAll ("pint-aunz/1.1.2/billing/", "AU Credit note.xml", "NZ Credit note.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_1_2))
    {
      return _getAll ("pint-aunz/1.1.2/selfbilling/",
                      "AUNZ Self Billing.xml",
                      "AU Self Billing - Negative Invoice.xml",
                      "NZ Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_2))
    {
      return _getAll ("pint-aunz/1.1.2/selfbilling/",
                      "AU Self Billed Credit Note.xml",
                      "NZ Self Billed Credit note.xml");
    }

    /* PINT EU */
    // 1.0.0
    if (aVESID.equals (PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_INVOICE_2025_10))
    {
      return _getAll ("pint-eu/1.0.0/",
                      "Allowance-example.xml",
                      "base-example.xml",
                      "base-negative-inv-correction.xml",
                      "sales-order-example.xml",
                      "vat-category-E.xml",
                      "vat-category-O.xml",
                      "Vat-category-S.xml",
                      "vat-category-Z.xml");
    }
    if (aVESID.equals (PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_CREDIT_NOTE_2025_10))
    {
      return _getAll ("pint-eu/1.0.0/", "base-creditnote-correction.xml");
    }

    // 1.0.1
    if (aVESID.equals (PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_INVOICE_2025_11))
    {
      return _getAll ("pint-eu/1.0.1/",
                      "Allowance-example.xml",
                      "base-example.xml",
                      "base-negative-inv-correction.xml",
                      "sales-order-example.xml",
                      "vat-category-E.xml",
                      "vat-category-O.xml",
                      "Vat-category-S.xml",
                      "vat-category-Z.xml");
    }
    if (aVESID.equals (PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_CREDIT_NOTE_2025_11))
    {
      return _getAll ("pint-eu/1.0.1/", "base-creditnote-correction.xml");
    }

    /* Peppol JP */
    // 0.1.2
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_012))
    {
      return _getAll ("pint-jp/0.1.2/",
                      "Japan PINT Invoice UBL Example.xml",
                      "Japan PINT Invoice UBL Example1-minimum.xml",
                      "Japan PINT Invoice UBL Example2-TaxAcctCur.xml",
                      "Japan PINT Invoice UBL Example3-SumInv1.xml",
                      "Japan PINT Invoice UBL Example4-SumInv2.xml",
                      "Japan PINT Invoice UBL Example5-AllowanceCharge.xml",
                      "Japan PINT Invoice UBL Example6-CorrInv.xml",
                      "Japan PINT Invoice UBL Example7-Return.Quan.ItPr.xml",
                      "Japan PINT Invoice UBL Example9-SumInv1 and O.xml");
    }
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_012))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.0.2
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_1_0_2))
    {
      return _getAll ("pint-jp/1.0.2/",
                      "Japan PINT Invoice UBL Example.xml",
                      "Japan PINT Invoice UBL Example1-minimum.xml",
                      "Japan PINT Invoice UBL Example2-TaxAcctCur.xml",
                      "Japan PINT Invoice UBL Example3-SumInv1.xml",
                      "Japan PINT Invoice UBL Example4-SumInv2.xml",
                      "Japan PINT Invoice UBL Example5-AllowanceCharge.xml",
                      "Japan PINT Invoice UBL Example6-CorrInv.xml",
                      "Japan PINT Invoice UBL Example7-Return.Quan.ItPr.xml",
                      "Japan PINT Invoice UBL Example9-SumInv1 and O.xml");
    }
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_0_2))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.0.3
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_1_0_3))
    {
      return _getAll ("pint-jp/1.0.3/",
                      "Japan PINT Invoice UBL Example.xml",
                      "Japan PINT Invoice UBL Example1-minimum.xml",
                      "Japan PINT Invoice UBL Example2-TaxAcctCur.xml",
                      "Japan PINT Invoice UBL Example3-SumInv1.xml",
                      "Japan PINT Invoice UBL Example4-SumInv2.xml",
                      "Japan PINT Invoice UBL Example5-AllowanceCharge.xml",
                      "Japan PINT Invoice UBL Example6-CorrInv.xml",
                      "Japan PINT Invoice UBL Example7-Return.Quan.ItPr.xml",
                      "Japan PINT Invoice UBL Example9-SumInv1 and O.xml");
    }
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_0_3))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.1.0
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_0))
    {
      return _getAll ("pint-jp/1.1.0/",
                      "Japan PINT Invoice UBL Example.xml",
                      "Japan PINT Invoice UBL Example1-minimum.xml",
                      "Japan PINT Invoice UBL Example2-TaxAcctCur.xml",
                      "Japan PINT Invoice UBL Example3-SumInv1.xml",
                      "Japan PINT Invoice UBL Example4-SumInv2.xml",
                      "Japan PINT Invoice UBL Example5-AllowanceCharge.xml",
                      "Japan PINT Invoice UBL Example6-CorrInv.xml",
                      "Japan PINT Invoice UBL Example7-Return.Quan.ItPr.xml",
                      "Japan PINT Invoice UBL Example9-SumInv1 and O.xml");
    }
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_0))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.1.1
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_1))
    {
      return _getAll ("pint-jp/1.1.1/",
                      "Japan PINT Invoice UBL Example.xml",
                      "Japan PINT Invoice UBL Example1-minimum.xml",
                      "Japan PINT Invoice UBL Example2-TaxAcctCur.xml",
                      "Japan PINT Invoice UBL Example3-SumInv1.xml",
                      "Japan PINT Invoice UBL Example4-SumInv2.xml",
                      "Japan PINT Invoice UBL Example5-AllowanceCharge.xml",
                      "Japan PINT Invoice UBL Example6-CorrInv.xml",
                      "Japan PINT Invoice UBL Example7-Return.Quan.ItPr.xml",
                      "Japan PINT Invoice UBL Example9-SumInv1 and O.xml");
    }
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_1))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.1.2
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_2))
    {
      return _getAll ("pint-jp/1.1.2/",
                      "Japan PINT Invoice UBL Example.xml",
                      "Japan PINT Invoice UBL Example1-minimum.xml",
                      "Japan PINT Invoice UBL Example2-TaxAcctCur.xml",
                      "Japan PINT Invoice UBL Example3-SumInv1.xml",
                      "Japan PINT Invoice UBL Example4-SumInv2.xml",
                      "Japan PINT Invoice UBL Example5-AllowanceCharge.xml",
                      "Japan PINT Invoice UBL Example6-CorrInv.xml",
                      "Japan PINT Invoice UBL Example7-Return.Quan.ItPr.xml",
                      "Japan PINT Invoice UBL Example9-SumInv1 and O.xml");
    }
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_2))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    /* PINT Japan for non-tax registered Businesses */
    // 1.0.1
    if (aVESID.equals (PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_0_1))
    {
      return _getAll ("pint-jp-ntr/1.0.1/",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example1-minimum.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example2-SumInv1.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example3-SumInv2.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example4-AllowanceCharge.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example5-CorrInv.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example-Return.Quan.ItPr.xml");
    }
    if (aVESID.equals (PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_0_1))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.1.0
    if (aVESID.equals (PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_1_0))
    {
      return _getAll ("pint-jp-ntr/1.1.0/",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example1-minimum.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example2-SumInv1.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example3-SumInv2.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example4-AllowanceCharge.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example5-CorrInv.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example-Return.Quan.ItPr.xml");
    }
    if (aVESID.equals (PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_1_0))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.1.1
    if (aVESID.equals (PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_1_1))
    {
      return _getAll ("pint-jp-ntr/1.1.1/",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example1-minimum.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example2-SumInv1.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example3-SumInv2.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example4-AllowanceCharge.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example5-CorrInv.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example-Return.Quan.ItPr.xml");
    }
    if (aVESID.equals (PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_1_1))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.1.2
    if (aVESID.equals (PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_1_2))
    {
      return _getAll ("pint-jp-ntr/1.1.2/",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example1-minimum.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example2-SumInv1.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example3-SumInv2.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example4-AllowanceCharge.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example5-CorrInv.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example-Return.Quan.ItPr.xml");
    }
    if (aVESID.equals (PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_1_2))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    /* PINT Japan Self Billing */
    // 1.0.1
    if (aVESID.equals (PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_0_1) ||
        aVESID.equals (PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_0_1))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.1.0
    if (aVESID.equals (PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_1_0) ||
        aVESID.equals (PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_1_0))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.1.1
    if (aVESID.equals (PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_1_1) ||
        aVESID.equals (PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_1_1))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.1.2
    if (aVESID.equals (PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_1_2) ||
        aVESID.equals (PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_1_2))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    /* Peppol Malaysia */
    // 1.0.0
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_0_0))
    {
      return _getAll ("pint-my/1.0.0/invoice/",
                      "17022014MyPINT0.9Sample_MultiTaxRate.xml",
                      "17022024MyPINT0.9Sample_Common.xml");
    }
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_0_0) ||
        aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_0_0) ||
        aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_0_0))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.1.0
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_1_0))
    {
      return _getAll ("pint-my/1.1.0/inv/",
                      "17022014MyPINT0.9Sample_MultiTaxRate.xml",
                      "17022024MyPINT0.9Sample_Common.xml",
                      "MyPINT1.0.0Sample_Common.xml",
                      "SAMPLE_COMMON_INVOICES_V1.1.xml");
    }
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_1_0))
    {
      return _getAll ("pint-my/1.1.0/cn/", "MyPINTSample1.0.0_CreditNote.xml", "SAMPLE_COMMON_CREDITNOTE_V1.1.xml");
    }
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_1_0) ||
        aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_0))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.2.1
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_2_1))
    {
      return _getAll ("pint-my/1.2.1/inv/",
                      "17022014MyPINT0.9Sample_MultiTaxRate.xml",
                      "17022024MyPINT0.9Sample_Common.xml",
                      "MyPINT1.0.0Sample_Common.xml",
                      "SAMPLE_COMMON_INVOICES_V1.1.xml");
    }
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_2_1))
    {
      return _getAll ("pint-my/1.2.1/cn/", "MyPINTSample1.0.0_CreditNote.xml", "SAMPLE_COMMON_CREDITNOTE_V1.1.xml");
    }
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_2_1) ||
        aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_2_1))
    {
      // empty
      return new CommonsArrayList <> ();
    }

    // 1.3.0
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_3_0))
    {
      return _getAll ("pint-my/1.3.0/billing/",
                      "CompleteSample_LHDN.xml",
                      "Invoice-Sample-HVG_1.3.0.xml",
                      "Invoice-Sample-LVG_1.3.0.xml",
                      "Invoice-Sample-SA_1.3.0.xml",
                      "Invoice-Sample-SE_1.3.0.xml",
                      "Invoice-Sample-TTX_1.3.0.xml");
    }
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_3_0))
    {
      return _getAll ("pint-my/1.3.0/billing/",
                      "CompleteSample_LHDN-CreditNote.xml",
                      "CreditNote-Sample-HVG_1.3.0.xml",
                      "CreditNote-Sample-LVG_1.3.0.xml",
                      "CreditNote-Sample-SA_1.3.0.xml",
                      "CreditNote-Sample-SE_1.3.0.xml",
                      "CreditNote-Sample-TTX_1.3.0.xml");
    }
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_3_0))
    {
      return _getAll ("pint-my/1.3.0/selfbilling/",
                      "SB_Invoice-Sample-HVG_1.3.0.xml",
                      "SB_Invoice-Sample-LVG_1.3.0.xml",
                      "SB_Invoice-Sample-SA_1.3.0.xml",
                      "SB_Invoice-Sample-SE_1.3.0.xml",
                      "SB_Invoice-Sample-TTX_1.3.0.xml",
                      "SB-CompleteSample_LHDN.xml");
    }
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_3_0))
    {
      return _getAll ("pint-my/1.3.0/selfbilling/",
                      "SB_CreditNote-Sample-HVG_1.3.0.xml",
                      "SB_CreditNote-Sample-LVG_1.3.0.xml",
                      "SB_CreditNote-Sample-SA_1.3.0.xml",
                      "SB_CreditNote-Sample-SE_1.3.0.xml",
                      "SB_CreditNote-Sample-TTX_1.3.0.xml",
                      "SB-CompleteSample_LHDN-CreditNote.xml");
    }

    /* Peppol Singapore */
    // 1.1.0
    if (aVESID.equals (PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_1_0))
    {
      return _getAll ("pint-sg/1.1.0/",
                      "PINT-SG INV example 02 - full valid invoice 1.xml",
                      "PINT-SG INV example 03 - Allowances and Charges.xml",
                      "PINT-SG INV example 04 - none GST registered.xml",
                      "PINT-SG INV example 05 - AGD compliant with II and PO reference.xml",
                      "PINT-SG INV example 06 - Foreign currency.xml",
                      "PINT-SG INV example 07 - Foreign buyer.xml",
                      "PINT-SG INV example 08 - Factored invoice.xml",
                      "PINT-SG INV example 09 - Zero rated GST.xml",
                      "PINT-SG INV example 10 - Prepayment.xml",
                      "PINT-SG INV example 11 - Decimals.xml",
                      "PINT-SG INV example 12 - SG bank transfer.xml",
                      "PINT-SG INV example 13 - SG GIRO.xml",
                      "PINT-SG INV example 14 - PayNow.xml",
                      "PINT-SG INV example 15 - Credit card.xml",
                      "PINT-SG INV example 16 - GST in SGD.xml");
    }
    if (aVESID.equals (PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_1_0))
    {
      return _getAll ("pint-sg/1.1.0/", "PINT-SG CN example 01 - Credit Note.xml");
    }

    // 1.2.0
    if (aVESID.equals (PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_2_0))
    {
      return _getAll ("pint-sg/1.2.0/",
                      "PINT-SG INV example 02 - full valid invoice 1.xml",
                      "PINT-SG INV example 03 - Allowances and Charges.xml",
                      "PINT-SG INV example 04 - none GST registered.xml",
                      "PINT-SG INV example 05 - AGD compliant with II and PO reference.xml",
                      "PINT-SG INV example 06 - Foreign currency.xml",
                      "PINT-SG INV example 07 - Foreign buyer.xml",
                      "PINT-SG INV example 08 - Factored invoice.xml",
                      "PINT-SG INV example 09 - Zero rated GST.xml",
                      "PINT-SG INV example 10 - Prepayment.xml",
                      "PINT-SG INV example 11 - Decimals.xml",
                      "PINT-SG INV example 12 - SG bank transfer.xml",
                      "PINT-SG INV example 13 - SG GIRO.xml",
                      "PINT-SG INV example 14 - PayNow.xml",
                      "PINT-SG INV example 15 - Credit card.xml",
                      "PINT-SG INV example 16 - GST in SGD.xml");
    }
    if (aVESID.equals (PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_2_0))
    {
      return _getAll ("pint-sg/1.2.0/", "PINT-SG CN example 01 - Credit Note.xml");
    }

    // 1.3.0
    if (aVESID.equals (PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_3_0))
    {
      return _getAll ("pint-sg/1.3.0/",
                      "PINT-SG INV example 02 - full valid invoice 1.xml",
                      "PINT-SG INV example 03 - Allowances and Charges.xml",
                      "PINT-SG INV example 04 - none GST registered.xml",
                      "PINT-SG INV example 05 - AGD compliant with II and PO reference.xml",
                      "PINT-SG INV example 06 - Foreign currency.xml",
                      "PINT-SG INV example 07 - Foreign buyer.xml",
                      "PINT-SG INV example 08 - Factored invoice.xml",
                      "PINT-SG INV example 09 - Zero rated GST.xml",
                      "PINT-SG INV example 10 - Prepayment.xml",
                      "PINT-SG INV example 11 - Decimals.xml",
                      "PINT-SG INV example 12 - SG bank transfer.xml",
                      "PINT-SG INV example 13 - SG GIRO.xml",
                      "PINT-SG INV example 14 - PayNow.xml",
                      "PINT-SG INV example 15 - Credit card.xml",
                      "PINT-SG INV example 16 - GST in SGD.xml");
    }
    if (aVESID.equals (PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_3_0))
    {
      return _getAll ("pint-sg/1.3.0/", "PINT-SG CN example 01 - Credit Note.xml");
    }

    // 1.4.0
    if (aVESID.equals (PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_4_0))
    {
      return _getAll ("pint-sg/1.4.0/",
                      "PINT-SG INV example 02 - full valid invoice 1.xml",
                      "PINT-SG INV example 03 - Allowances and Charges.xml",
                      "PINT-SG INV example 04 - none GST registered.xml",
                      "PINT-SG INV example 05 - AGD compliant with II and PO reference.xml",
                      "PINT-SG INV example 06 - Foreign currency.xml",
                      "PINT-SG INV example 07 - Foreign buyer.xml",
                      "PINT-SG INV example 08 - Factored invoice.xml",
                      "PINT-SG INV example 09 - Zero rated GST.xml",
                      "PINT-SG INV example 10 - Prepayment.xml",
                      "PINT-SG INV example 11 - Decimals.xml",
                      "PINT-SG INV example 12 - SG bank transfer.xml",
                      "PINT-SG INV example 13 - SG GIRO.xml",
                      "PINT-SG INV example 14 - PayNow.xml",
                      "PINT-SG INV example 15 - Credit card.xml",
                      "PINT-SG INV example 16 - GST in SGD.xml");
    }
    if (aVESID.equals (PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_4_0))
    {
      return _getAll ("pint-sg/1.4.0/", "PINT-SG CN example 01 - Credit Note.xml");
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
