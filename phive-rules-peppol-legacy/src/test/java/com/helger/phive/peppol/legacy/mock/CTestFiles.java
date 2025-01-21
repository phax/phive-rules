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
package com.helger.phive.peppol.legacy.mock;

import static org.junit.Assert.assertTrue;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.FileSystemResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.peppol.legacy.PeppolLegacyValidationBisAUNZ;
import com.helger.phive.peppol.legacy.PeppolLegacyValidationBisEurope;
import com.helger.phive.peppol.legacy.PeppolLegacyValidationReporting;
import com.helger.phive.peppol.legacy.PeppolLegacyValidationSG;
import com.helger.phive.peppol.legacy.PeppolValidation2023_05;
import com.helger.phive.peppol.legacy.PeppolValidation2023_11;
import com.helger.phive.peppol.legacy.PeppolValidation3_10_0;
import com.helger.phive.peppol.legacy.PeppolValidation3_10_1;
import com.helger.phive.peppol.legacy.PeppolValidation3_11_0;
import com.helger.phive.peppol.legacy.PeppolValidation3_11_1;
import com.helger.phive.peppol.legacy.PeppolValidation3_12_0;
import com.helger.phive.peppol.legacy.PeppolValidation3_13_0;
import com.helger.phive.peppol.legacy.PeppolValidation3_14_0;
import com.helger.phive.peppol.legacy.PeppolValidation3_15_0;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    PeppolLegacyValidationBisEurope.init (VES_REGISTRY);
    PeppolLegacyValidationBisAUNZ.init (VES_REGISTRY);
    PeppolLegacyValidationSG.init (VES_REGISTRY);
    PeppolLegacyValidationReporting.init (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aESID : new DVRCoordinate [] { /* AU_NZ */
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_100,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_100,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_100,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_100,

                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_101,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_101,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_101,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_101,

                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_102,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_102,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_102,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_102,

                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_103,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_103,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_103,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_103,

                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_104,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_104,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_104,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_104,

                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_105,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_105,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_105,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_105,

                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_106,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_106,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_106,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_106,

                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_107,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_107,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_107,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_107,

                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_108,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_108,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_108,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_108,

                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_109,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_109,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_109,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_109,

                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_10,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_10,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_10,
                                                            PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_10,

                                                            /* Singapore */
                                                            PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_100,
                                                            PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_100,

                                                            PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102,
                                                            PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102,

                                                            PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103,
                                                            PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103,

                                                            /* OpenPeppol */
                                                            PeppolValidation3_10_0.VID_OPENPEPPOL_INVOICE_V3,
                                                            PeppolValidation3_10_0.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                                            PeppolValidation3_10_0.VID_OPENPEPPOL_ORDER_V3,
                                                            PeppolValidation3_10_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                            PeppolValidation3_10_0.VID_OPENPEPPOL_CATALOGUE_V3,
                                                            PeppolValidation3_10_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                            PeppolValidation3_10_0.VID_OPENPEPPOL_MLR_V3,
                                                            PeppolValidation3_10_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                            PeppolValidation3_10_0.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                            PeppolValidation3_10_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                            PeppolValidation3_10_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,

                                                            PeppolValidation3_10_1.VID_OPENPEPPOL_INVOICE_V3,
                                                            PeppolValidation3_10_1.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                                            PeppolValidation3_10_1.VID_OPENPEPPOL_ORDER_V3,
                                                            PeppolValidation3_10_1.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                            PeppolValidation3_10_1.VID_OPENPEPPOL_CATALOGUE_V3,
                                                            PeppolValidation3_10_1.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                            PeppolValidation3_10_1.VID_OPENPEPPOL_MLR_V3,
                                                            PeppolValidation3_10_1.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                            PeppolValidation3_10_1.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                            PeppolValidation3_10_1.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                            PeppolValidation3_10_1.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,

                                                            PeppolValidation3_11_0.VID_OPENPEPPOL_INVOICE_V3,
                                                            PeppolValidation3_11_0.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                                            PeppolValidation3_11_0.VID_OPENPEPPOL_ORDER_V3,
                                                            PeppolValidation3_11_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                            PeppolValidation3_11_0.VID_OPENPEPPOL_CATALOGUE_V3,
                                                            PeppolValidation3_11_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                            PeppolValidation3_11_0.VID_OPENPEPPOL_MLR_V3,
                                                            PeppolValidation3_11_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                            PeppolValidation3_11_0.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                            PeppolValidation3_11_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                            PeppolValidation3_11_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,

                                                            PeppolValidation3_11_1.VID_OPENPEPPOL_INVOICE_V3,
                                                            PeppolValidation3_11_1.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                                            PeppolValidation3_11_1.VID_OPENPEPPOL_ORDER_V3,
                                                            PeppolValidation3_11_1.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                            PeppolValidation3_11_1.VID_OPENPEPPOL_CATALOGUE_V3,
                                                            PeppolValidation3_11_1.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                            PeppolValidation3_11_1.VID_OPENPEPPOL_MLR_V3,
                                                            PeppolValidation3_11_1.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                            PeppolValidation3_11_1.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                            PeppolValidation3_11_1.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                            PeppolValidation3_11_1.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,

                                                            PeppolValidation3_12_0.VID_OPENPEPPOL_INVOICE_V3,
                                                            PeppolValidation3_12_0.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                                            PeppolValidation3_12_0.VID_OPENPEPPOL_ORDER_V3,
                                                            PeppolValidation3_12_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                            PeppolValidation3_12_0.VID_OPENPEPPOL_CATALOGUE_V3,
                                                            PeppolValidation3_12_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                            PeppolValidation3_12_0.VID_OPENPEPPOL_MLR_V3,
                                                            PeppolValidation3_12_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                            PeppolValidation3_12_0.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                            PeppolValidation3_12_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                            PeppolValidation3_12_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,

                                                            PeppolValidation3_13_0.VID_OPENPEPPOL_INVOICE_V3,
                                                            PeppolValidation3_13_0.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                                            PeppolValidation3_13_0.VID_OPENPEPPOL_ORDER_V3,
                                                            PeppolValidation3_13_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                            PeppolValidation3_13_0.VID_OPENPEPPOL_CATALOGUE_V3,
                                                            PeppolValidation3_13_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                            PeppolValidation3_13_0.VID_OPENPEPPOL_MLR_V3,
                                                            PeppolValidation3_13_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                            PeppolValidation3_13_0.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                            PeppolValidation3_13_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                            PeppolValidation3_13_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,

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

                                                            PeppolValidation2023_05.VID_OPENPEPPOL_INVOICE_UBL_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                                            // PeppolValidation2023_05.VID_OPENPEPPOL_INVOICE_CII_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_CATALOGUE_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_MLR_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_CHANGE_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_CANCELLATION_V3,
                                                            PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3,

                                                            PeppolValidation2023_11.VID_OPENPEPPOL_INVOICE_UBL_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                                            // PeppolValidation2023_11.VID_OPENPEPPOL_INVOICE_CII_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_ORDER_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_CATALOGUE_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_MLR_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_ORDER_CHANGE_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_ORDER_CANCELLATION_V3,
                                                            PeppolValidation2023_11.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3,

                                                            /* Reporting */
                                                            PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V100RC2,
                                                            PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V100,
                                                            PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V101,
                                                            PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V110,
                                                            PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V111,
                                                            PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V112,
                                                            PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V113,

                                                            PeppolLegacyValidationReporting.VID_OPENPEPPOL_TSR_V100,
                                                            PeppolLegacyValidationReporting.VID_OPENPEPPOL_TSR_V101,
                                                            PeppolLegacyValidationReporting.VID_OPENPEPPOL_TSR_V102,
                                                            PeppolLegacyValidationReporting.VID_OPENPEPPOL_TSR_V103,

    })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aESID));
      }
    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    final String sPrefix0 = "src/test/resources/external/test-files/";

    // AUNZ 1.0.0
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_100))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.0/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_100))
    {
      return new CommonsArrayList <> ();
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_100))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.0/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_100))
    {
      return new CommonsArrayList <> ();
    }

    // AUNZ 1.0.1
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_101))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_101))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_101))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_101))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.2
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_102))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_102))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_102))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_102))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.3
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_103))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_103))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_103))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_103))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.4
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_104))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.4/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_104))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.4/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_104))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.4/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_104))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.4/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.5
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_105))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.5/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_105))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.5/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_105))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.5/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_105))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.5/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.6
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_106))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.6/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_106))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.6/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_106))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.6/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_106))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.6/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.7
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_107))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.7/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_107))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.7/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_107))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.7/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_107))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.7/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.8
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_108))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.8/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_108))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.8/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_108))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.8/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_108))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.8/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.9
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_109))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.9/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_109))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.9/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_109))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.9/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_109))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.9/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.10
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_10))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.10/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_10))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.10/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_10))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.10/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationBisAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_10))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.10/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // SG 1.0.0
    if (aVESID.equals (PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_100))
    {
      final String sPrefix = sPrefix0 + "sg-peppol/1.0.0/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Singapore invoice valid 1.xml"));
    }

    if (aVESID.equals (PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_100))
      return new CommonsArrayList <> ();

    // SG 1.0.2
    if (aVESID.equals (PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102))
    {
      final String sPrefix = sPrefix0 + "sg-peppol/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Singapore invoice valid 1.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102))
      return new CommonsArrayList <> ();

    // SG 1.0.3
    if (aVESID.equals (PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103))
    {
      final String sPrefix = sPrefix0 + "sg-peppol/1.0.3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Singapore invoice valid 1.xml"),
                                      new FileSystemResource (sPrefix + "Singapore invoice valid 1 - NG tax code.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103))
      return new CommonsArrayList <> ();

    // 3.10.0
    {
      final String sPrefix = sPrefix0 + "openpeppol/3.10.0/";
      // https://github.com/OpenPeppol/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_10_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "InvoiceResponse_Example.xml"),
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

    // 3.10.1
    {
      final String sPrefix = sPrefix0 + "openpeppol/3.10.1/";
      // https://github.com/OpenPeppol/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_10_1.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "InvoiceResponse_Example.xml"),
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

    // 3.11.0
    {
      final String sPrefix = sPrefix0 + "openpeppol/3.11.0/";
      // https://github.com/OpenPeppol/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_11_0.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation3_11_0.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_11_0.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_0.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_0.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_0.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_11_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "InvoiceResponse_Example.xml"),
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

    // 3.11.1
    {
      final String sPrefix = sPrefix0 + "openpeppol/3.11.1/";
      // https://github.com/OpenPeppol/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_11_1.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation3_11_1.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_11_1.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_1.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_1.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_1.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_1.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_1.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_1.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_11_1.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_11_1.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "InvoiceResponse_Example.xml"),
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

    // 3.12.0
    {
      final String sPrefix = sPrefix0 + "openpeppol/3.12.0/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_12_0.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation3_12_0.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_12_0.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation3_12_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation3_12_0.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_12_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_12_0.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_12_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_12_0.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_12_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_12_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "InvoiceResponse_Example.xml"),
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

    // 3.13.0
    {
      final String sPrefix = sPrefix0 + "openpeppol/3.13.0/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_13_0.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example-IT.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation3_13_0.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_13_0.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation3_13_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation3_13_0.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_13_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_13_0.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_13_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_13_0.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_13_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_13_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "InvoiceResponse_Example.xml"),
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

    // 3.14.0
    {
      final String sPrefix = sPrefix0 + "openpeppol/3.14.0/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_INVOICE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-Z.xml"),
                                        // Original file is broken
                                        new FileSystemResource (sPrefix + "billing/GR-base-example-correct.xml"),
                                        // Original file is broken
                                        // new FileSystemResource (sPrefix +
                                        // "billing/GR-base-example-TaxRepresentative.xml"),
                                        new FileSystemResource (sPrefix + "billing/Norwegian-example-1.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_INVOICE_CII_V3))
        return new CommonsArrayList <> ();
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC1_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC2_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC3_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC4_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC5_Order.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase1.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase2.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase3.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase4.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase5.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC1_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC2_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC3_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC4_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC5_Order_response.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_14_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "InvoiceResponse_Example.xml"),
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
      final String sPrefix = sPrefix0 + "openpeppol/3.15.0/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_CII_V3))
        return new CommonsArrayList <> ();
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC1_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC2_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC3_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC4_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC5_Order.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase1.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase2.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase3.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase4.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase5.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC1_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC2_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC3_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC4_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC5_Order_response.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation3_15_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "InvoiceResponse_Example.xml"),
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

    // 2023-05
    {
      final String sPrefix = sPrefix0 + "openpeppol/2023.5/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_INVOICE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC1_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC2_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC3_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC4_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC5_Order.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase1.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase2.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase3.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase4.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase5.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC1_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC2_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC3_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC4_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC5_Order_response.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "InvoiceResponse_Example.xml"),
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

      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_CHANGE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderChange_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_CANCELLATION_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderCancellation_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_05.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponseAdvanced_Example.xml"));
    }

    // 2023-11
    {
      final String sPrefix = sPrefix0 + "openpeppol/2023.11/";
      // https://github.com/OpenPEPPOL/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_INVOICE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-example.xml"),
                                        new FileSystemResource (sPrefix + "billing/base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-E.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "billing/Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "billing/vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "billing/base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_ORDER_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC1_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC2_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC3_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC4_Order.xml"),
                                        new FileSystemResource (sPrefix + "Order use cases/UC5_Order.xml"));
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_DESPATCH_ADVICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase1.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase2.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase3.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase4.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Despatch Advice use cases/DespatchAdvice-BIS3_UseCase5.xml"));
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_CATALOGUE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_MLR_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_ORDER_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC1_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC2_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC3_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC4_Order_response.xml"),
                                        new FileSystemResource (sPrefix +
                                                                "Order-response use cases/UC5_Order_response.xml"));
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_PUNCH_OUT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_ORDER_AGREEMENT_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "InvoiceResponse_Example.xml"),
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

      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_ORDER_CHANGE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderChange_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_ORDER_CANCELLATION_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderCancellation_Example.xml"));
      if (aVESID.equals (PeppolValidation2023_11.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponseAdvanced_Example.xml"));
    }

    /* Peppol Reporting */
    // EUSR
    if (aVESID.equals (PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V100RC2))
    {
      final String sPrefix = sPrefix0 + "reporting/eusr/1.0.0-RC2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-minimal.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V100))
    {
      final String sPrefix = sPrefix0 + "reporting/eusr/1.0.0/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-minimal.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V101))
    {
      final String sPrefix = sPrefix0 + "reporting/eusr/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-2.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-minimal.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V110))
    {
      final String sPrefix = sPrefix0 + "reporting/eusr/1.1.0/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-2.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-minimal.xml"),
                                      new FileSystemResource (sPrefix + "eusr-generated-1.xml"),
                                      new FileSystemResource (sPrefix + "eusr-good-template.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V111))
    {
      final String sPrefix = sPrefix0 + "reporting/eusr/1.1.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-2.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-minimal.xml"),
                                      new FileSystemResource (sPrefix + "eusr-generated-1.xml"),
                                      new FileSystemResource (sPrefix + "eusr-good-template.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V112))
    {
      final String sPrefix = sPrefix0 + "reporting/eusr/1.1.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-2.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-minimal.xml"),
                                      new FileSystemResource (sPrefix + "eusr-generated-1.xml"),
                                      new FileSystemResource (sPrefix + "eusr-good-template.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationReporting.VID_OPENPEPPOL_EUSR_V113))
    {
      final String sPrefix = sPrefix0 + "reporting/eusr/1.1.3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "end-user-statistics-reporting-1.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-2.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-3.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-empty.xml"),
                                      new FileSystemResource (sPrefix + "end-user-statistics-reporting-minimal.xml"),
                                      new FileSystemResource (sPrefix + "eusr-generated-1.xml"),
                                      new FileSystemResource (sPrefix + "eusr-good-template.xml"));
    }

    // TSR
    if (aVESID.equals (PeppolLegacyValidationReporting.VID_OPENPEPPOL_TSR_V100))
    {
      final String sPrefix = sPrefix0 + "reporting/tsr/1.0.0/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "transaction-statistics-2.xml"),
                                      new FileSystemResource (sPrefix + "transaction-statistics-minimal.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationReporting.VID_OPENPEPPOL_TSR_V101))
    {
      final String sPrefix = sPrefix0 + "reporting/tsr/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "transaction-statistics-2.xml"),
                                      new FileSystemResource (sPrefix + "transaction-statistics-minimal.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationReporting.VID_OPENPEPPOL_TSR_V102))
    {
      final String sPrefix = sPrefix0 + "reporting/tsr/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "transaction-statistics-2.xml"),
                                      new FileSystemResource (sPrefix + "transaction-statistics-minimal.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationReporting.VID_OPENPEPPOL_TSR_V103))
    {
      final String sPrefix = sPrefix0 + "reporting/tsr/1.0.3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "transaction-statistics-2.xml"),
                                      new FileSystemResource (sPrefix + "transaction-statistics-minimal.xml"));
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
