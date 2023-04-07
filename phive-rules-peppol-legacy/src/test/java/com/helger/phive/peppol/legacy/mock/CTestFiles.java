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
import com.helger.peppol.testfiles.official.OfficialTestFiles;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.engine.mock.MockFile;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.peppol.legacy.PeppolLegacyThirdpartyValidation;
import com.helger.phive.peppol.legacy.PeppolLegacyValidation;
import com.helger.phive.peppol.legacy.PeppolLegacyValidationAUNZ;
import com.helger.phive.peppol.legacy.PeppolLegacyValidationSG;
import com.helger.phive.peppol.legacy.PeppolValidation370;
import com.helger.phive.peppol.legacy.PeppolValidation381;
import com.helger.phive.peppol.legacy.PeppolValidation390;
import com.helger.phive.peppol.legacy.PeppolValidation391;
import com.helger.phive.peppol.legacy.PeppolValidation3_10_0;
import com.helger.phive.peppol.legacy.PeppolValidation3_10_1;
import com.helger.phive.peppol.legacy.PeppolValidation3_11_0;
import com.helger.phive.peppol.legacy.PeppolValidation3_11_1;
import com.helger.phive.peppol.legacy.PeppolValidation3_12_0;
import com.helger.phive.peppol.legacy.PeppolValidation3_13_0;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    PeppolLegacyValidation.init (VES_REGISTRY);
    PeppolLegacyThirdpartyValidation.init (VES_REGISTRY);
    PeppolLegacyValidationAUNZ.init (VES_REGISTRY);
    PeppolLegacyValidationSG.init (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <MockFile> getAllTestFiles ()
  {
    final ICommonsList <MockFile> ret = new CommonsArrayList <> ();
    for (final VESID aESID : new VESID [] { /* AU_NZ */
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_100,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_100,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_100,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_100,

                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_101,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_101,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_101,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_101,

                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_102,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_102,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_102,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_102,

                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_103,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_103,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_103,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_103,

                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_104,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_104,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_104,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_104,

                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_105,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_105,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_105,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_105,

                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_106,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_106,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_106,
                                            PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_106,

                                            /* Singapore */
                                            PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_100,
                                            PeppolLegacyValidationSG.VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_100,

                                            /* OpenPeppol */
                                            PeppolValidation370.VID_OPENPEPPOL_T19_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_T58_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_T01_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_T10_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_T14_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_T76_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_T16_V2,
                                            PeppolValidation370.VID_OPENPEPPOL_BIS3_UBL_INVOICE,
                                            PeppolValidation370.VID_OPENPEPPOL_BIS3_UBL_CREDIT_NOTE,

                                            PeppolValidation381.VID_OPENPEPPOL_INVOICE_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T01_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T16_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T19_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T58_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T71_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T76_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T77_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T110_V3,
                                            PeppolValidation381.VID_OPENPEPPOL_T111_V3,

                                            PeppolValidation390.VID_OPENPEPPOL_INVOICE_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T01_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T16_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T19_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T58_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T71_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T76_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T77_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T110_V3,
                                            PeppolValidation390.VID_OPENPEPPOL_T111_V3,

                                            PeppolValidation391.VID_OPENPEPPOL_INVOICE_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T01_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T16_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T19_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T58_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T71_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T76_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T77_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T110_V3,
                                            PeppolValidation391.VID_OPENPEPPOL_T111_V3,

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
                                            PeppolValidation3_13_0.VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3, })
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

    final String sPrefix0 = "src/test/resources/external/test-files/";

    // AUNZ 1.0.0
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_100))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.0/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_100))
    {
      return new CommonsArrayList <> ();
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_100))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.0/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_100))
    {
      return new CommonsArrayList <> ();
    }

    // AUNZ 1.0.1
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_101))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_101))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_101))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_101))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.1/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.2
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_102))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_102))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_102))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_102))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.2/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.3
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_103))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_103))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_103))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_103))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.3/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.4
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_104))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.4/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_104))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.4/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_104))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.4/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_104))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.4/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.5
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_105))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.5/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_105))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.5/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_105))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.5/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_105))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.5/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Self Billed Credit note.xml"));
    }

    // AUNZ 1.0.6
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_106))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.6/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Invoice.xml"),
                                      new FileSystemResource (sPrefix + "NZ Allowance On Invoice Line.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Allowance.xml"),
                                      new FileSystemResource (sPrefix + "NZ Invoice Level Charge.xml"),
                                      new FileSystemResource (sPrefix + "NZ No Allowances.xml"),
                                      new FileSystemResource (sPrefix + "NZ Prepaid Amount.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_106))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.6/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "NZ Credit note.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_106))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.6/";
      return new CommonsArrayList <> (new FileSystemResource (sPrefix + "AU Self Billing.xml"),
                                      new FileSystemResource (sPrefix + "NZ Self Billing.xml"));
    }
    if (aVESID.equals (PeppolLegacyValidationAUNZ.VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_106))
    {
      final String sPrefix = sPrefix0 + "aunz-peppol/1.0.6/";
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

    // 3.7.0
    {
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T19_V2))
        return OfficialTestFiles.getAllTestFilesCatalogue_01_T19 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T58_V2))
        return OfficialTestFiles.getAllTestFilesCatalogue_01_T58 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T01_V2))
        return OfficialTestFiles.getAllTestFilesOrder_03_T01 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T10_V2))
        return OfficialTestFiles.getAllTestFilesInvoice_04_T10 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T14_V2))
        return OfficialTestFiles.getAllTestFilesBilling_05_T14 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T76_V2))
        return OfficialTestFiles.getAllTestFilesOrdering_28_T76 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_T16_V2))
        return OfficialTestFiles.getAllTestFilesDespatchAdvice_30_T16 ();
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_BIS3_UBL_INVOICE))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix0 + "openpeppol/3.7.0/base-example.xml"),
                                        new FileSystemResource (sPrefix0 +
                                                                "openpeppol/3.7.0/base-negative-inv-correction.xml"));
      if (aVESID.equals (PeppolValidation370.VID_OPENPEPPOL_BIS3_UBL_CREDIT_NOTE))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix0 +
                                                                "openpeppol/3.7.0/base-creditnote-correction.xml"));
    }

    // 3.8.1
    {
      final String sPrefix = sPrefix0 + "openpeppol/3.8.1/";
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> ();
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> ();
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T01_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T16_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T19_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T58_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T71_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T76_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T77_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T110_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation381.VID_OPENPEPPOL_T111_V3))
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

    // 3.9.0
    {
      final String sPrefix = sPrefix0 + "openpeppol/3.9.0/";
      // https://github.com/OpenPeppol/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "base-example.xml"),
                                        new FileSystemResource (sPrefix + "base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T01_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T16_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T19_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T58_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T71_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T76_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T77_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T110_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation390.VID_OPENPEPPOL_T111_V3))
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

    // 3.9.1
    {
      final String sPrefix = sPrefix0 + "openpeppol/3.9.1/";
      // https://github.com/OpenPeppol/peppol-bis-invoice-3/tree/master/rules/examples
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_INVOICE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Allowance-example.xml"),
                                        new FileSystemResource (sPrefix + "base-example.xml"),
                                        new FileSystemResource (sPrefix + "base-negative-inv-correction.xml"),
                                        new FileSystemResource (sPrefix + "vat-category-O.xml"),
                                        new FileSystemResource (sPrefix + "Vat-category-S.xml"),
                                        new FileSystemResource (sPrefix + "vat-category-Z.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_CREDIT_NOTE_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "base-creditnote-correction.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T01_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Order_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T16_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "DespatchAdvice_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T19_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "Catalogue_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T58_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "CatalogueResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T71_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "MessageLevelResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T76_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderResponse_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T77_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "PunchOut_Example.xml"));
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T110_V3))
        return new CommonsArrayList <> (new FileSystemResource (sPrefix + "OrderAgreement_Example.xml"));

      final String sBase2 = sPrefix + "Invoice reponse use cases/";
      if (aVESID.equals (PeppolValidation391.VID_OPENPEPPOL_T111_V3))
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

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
