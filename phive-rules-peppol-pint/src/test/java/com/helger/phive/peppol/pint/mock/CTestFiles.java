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
package com.helger.phive.peppol.pint.mock;

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
import com.helger.phive.peppol.pint.PeppolPintValidation;
import com.helger.phive.peppol.pint.PeppolValidationPintAE;
import com.helger.phive.peppol.pint.PeppolValidationPintAUNZ;
import com.helger.phive.peppol.pint.PeppolValidationPintEU;
import com.helger.phive.peppol.pint.PeppolValidationPintJP;
import com.helger.phive.peppol.pint.PeppolValidationPintJP_NTR;
import com.helger.phive.peppol.pint.PeppolValidationPintJP_SB;
import com.helger.phive.peppol.pint.PeppolValidationPintMY;
import com.helger.phive.peppol.pint.PeppolValidationPintOM;
import com.helger.phive.peppol.pint.PeppolValidationPintSG;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Test helper for the OpenPeppol PINT validation rules: holds a registry with all PINT validation
 * execution sets and maps each of them to its good-case test files.
 *
 * @author Philip Helger
 */
@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    PeppolPintValidation.initPeppolPint (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aVESID : new DVRCoordinate [] {
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

                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_INVOICE_2026_05,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2026_05,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2026_05,
                                                             PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2026_05,

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

                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_1_3,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_1_3,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_1_3,
                                                             PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_3,

                                                             /* PINT EU */
                                                             PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_INVOICE_2025_10,
                                                             PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_CREDIT_NOTE_2025_10,
                                                             PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_INVOICE_2025_11,
                                                             PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_CREDIT_NOTE_2025_11,
                                                             PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_INVOICE_2026_6,
                                                             PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_CREDIT_NOTE_2026_6,

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
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_3,
                                                             PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_3,

                                                             /* PINT Japan NTR */
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_0_1,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_0_1,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_1_0,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_1_0,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_1_1,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_1_1,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_1_2,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_1_2,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_1_3,
                                                             PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_1_3,

                                                             /* PINT Japan Self Billing */
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_0_1,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_0_1,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_1_0,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_1_0,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_1_1,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_1_1,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_1_2,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_1_2,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_1_3,
                                                             PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_1_3,

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

                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_3_1,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_3_1,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_3_1,
                                                             PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_3_1,

                                                             /* PINT Oman */
                                                             PeppolValidationPintOM.VID_OPENPEPPOL_OM_PINT_INVOICE_1_0_0,
                                                             PeppolValidationPintOM.VID_OPENPEPPOL_OM_PINT_CREDIT_NOTE_1_0_0,
                                                             PeppolValidationPintOM.VID_OPENPEPPOL_OM_PINT_SB_INVOICE_1_0_0,
                                                             PeppolValidationPintOM.VID_OPENPEPPOL_OM_PINT_SB_CREDIT_NOTE_1_0_0,

                                                             /* PINT Singapore */
                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_1_0,
                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_1_0,

                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_2_0,
                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_2_0,

                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_3_0,
                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_3_0,

                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_4_0,
                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_4_0,

                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_4_1,
                                                             PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_4_1, })
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

    // 2026.5
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_INVOICE_2026_05))
    {
      return _getAll ("pint-ae/2026.5/billing/inv/",
                      "Commercial invoice.xml",
                      // "Continuous.supplies.xml",
                      // "Deemed.supply.-.predefined.endpoint.xml",
                      // "Disclosed.agent.billing.xml",
                      "Exports.xml",
                      // "Exports.-.predefined.endpoint.xml",
                      "Margin scheme.xml",
                      // "Standard.invoice.-.Extensive.xml",
                      "Standard invoice Mandatory fields.xml",
                      "Standard tax invoice.xml",
                      // "Standard.tax.invoice.-.predefined.endpoint.xml",
                      "Summary tax invoice.xml",
                      "Supply involving free trade zone.xml",
                      "Supply through e-commerce.xml",
                      "Supply under Reverse charge mechanism.xml",
                      "Zero rated supplies.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2026_05))
    {
      return _getAll ("pint-ae/2026.5/billing/cn/",
                      "Disclosed agent billing tax credit note.xml",
                      "Standard tax credit Note.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2026_05))
    {
      return _getAll ("pint-ae/2026.5/selfbilling/inv/", "Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationPintAE.VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2026_05))
    {
      return _getAll ("pint-ae/2026.5/selfbilling/cn/", "Self billing tax credit note.xml");
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

    // 1.1.3
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_1_3))
    {
      return _getAll ("pint-aunz/1.1.3/billing/",
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
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_1_3))
    {
      return _getAll ("pint-aunz/1.1.3/billing/", "AU Credit note.xml", "NZ Credit note.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_1_3))
    {
      return _getAll ("pint-aunz/1.1.3/selfbilling/",
                      "AUNZ Self Billing.xml",
                      "AU Self Billing - Negative Invoice.xml",
                      "NZ Self Billing.xml");
    }
    if (aVESID.equals (PeppolValidationPintAUNZ.VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_3))
    {
      return _getAll ("pint-aunz/1.1.3/selfbilling/",
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

    // 2026.6 (aka 1.1.1)
    if (aVESID.equals (PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_INVOICE_2026_6))
    {
      return _getAll ("pint-eu/1.1.1/",
                      "Allowance-example.xml",
                      "base-example.xml",
                      "base-negative-inv-correction.xml",
                      "sales-order-example.xml",
                      "vat-category-E.xml",
                      "vat-category-O.xml",
                      "Vat-category-S.xml",
                      "vat-category-Z.xml");
    }
    if (aVESID.equals (PeppolValidationPintEU.VID_OPENPEPPOL_EU_PINT_CREDIT_NOTE_2026_6))
    {
      return _getAll ("pint-eu/1.1.1/", "base-creditnote-correction.xml");
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

    // 1.1.3
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_3))
    {
      return _getAll ("pint-jp/1.1.3/",
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
    if (aVESID.equals (PeppolValidationPintJP.VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_3))
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

    // 1.1.3
    if (aVESID.equals (PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_INVOICE_1_1_3))
    {
      return _getAll ("pint-jp-ntr/1.1.3/",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example1-minimum.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example2-SumInv1.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example3-SumInv2.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example4-AllowanceCharge.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example5-CorrInv.xml",
                      "JP BIS Invoice for Non-tax Registered Businesses UBL Example-Return.Quan.ItPr.xml");
    }
    if (aVESID.equals (PeppolValidationPintJP_NTR.VID_OPENPEPPOL_JP_PINT_NTR_CREDIT_NOTE_1_1_3))
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

    // 1.1.3
    if (aVESID.equals (PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_1_3) ||
        aVESID.equals (PeppolValidationPintJP_SB.VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_1_3))
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

    // 1.3.1
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_3_1))
    {
      return _getAll ("pint-my/1.3.1/billing/",
                      "CompleteSample_LHDN.xml",
                      "Invoice-Sample-HVG_1.3.0.xml",
                      "Invoice-Sample-LVG_1.3.0.xml",
                      "Invoice-Sample-SA_1.3.0.xml",
                      "Invoice-Sample-SE_1.3.0.xml",
                      "Invoice-Sample-TTX_1.3.0.xml");
    }
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_3_1))
    {
      return _getAll ("pint-my/1.3.1/billing/",
                      "CompleteSample_LHDN-CreditNote.xml",
                      "CreditNote-Sample-HVG_1.3.0.xml",
                      "CreditNote-Sample-LVG_1.3.0.xml",
                      "CreditNote-Sample-SA_1.3.0.xml",
                      "CreditNote-Sample-SE_1.3.0.xml",
                      "CreditNote-Sample-TTX_1.3.0.xml");
    }
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_3_1))
    {
      return _getAll ("pint-my/1.3.1/selfbilling/",
                      "SB_Invoice-Sample-HVG_1.3.0.xml",
                      "SB_Invoice-Sample-LVG_1.3.0.xml",
                      "SB_Invoice-Sample-SA_1.3.0.xml",
                      "SB_Invoice-Sample-SE_1.3.0.xml",
                      "SB_Invoice-Sample-TTX_1.3.0.xml",
                      "SB-CompleteSample_LHDN.xml");
    }
    if (aVESID.equals (PeppolValidationPintMY.VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_3_1))
    {
      return _getAll ("pint-my/1.3.1/selfbilling/",
                      "SB_CreditNote-Sample-HVG_1.3.0.xml",
                      "SB_CreditNote-Sample-LVG_1.3.0.xml",
                      "SB_CreditNote-Sample-SA_1.3.0.xml",
                      "SB_CreditNote-Sample-SE_1.3.0.xml",
                      "SB_CreditNote-Sample-TTX_1.3.0.xml",
                      "SB-CompleteSample_LHDN-CreditNote.xml");
    }

    /* PINT Oman */
    // 1.0.0
    if (aVESID.equals (PeppolValidationPintOM.VID_OPENPEPPOL_OM_PINT_INVOICE_1_0_0))
    {
      return _getAll ("pint-om/1.0.0/billing/inv/",
                      "CommercialInvoice.xml",
                      "ContinuousSupplies-2.xml",
                      "ContinuousSupply.xml",
                      "DebitNote.xml",
                      "DeemedSupply-2.xml",
                      "DeemedSupply.xml",
                      "E-Commerce-Apparel.xml",
                      "E-Commerce-DigitalSubscription.xml",
                      "E-Commerce.xml",
                      "Export.xml",
                      "Exports-2.xml",
                      "FullInvoice-Mixed-Categories.xml",
                      "FullInvoice.xml",
                      "FullInvoiceCategory-E.xml",
                      // "GoodsImport-PharmaMixed.xml" — sample has invalid UBL 2.1 element order
                      // (cac:DeliveryTerms after cac:Shipment)
                      "GoodsImport-Vehicle.xml",
                      "GoodsImport.xml",
                      "ImportRCM-Royalties.xml",
                      "ImportRCM-Software.xml",
                      "ImportRCM.xml",
                      "MarginScheme.xml",
                      "Prepayment-Final-Net.xml",
                      "Prepayment-Hotel.xml",
                      "Prepayment.xml",
                      "ProfitMargin.xml",
                      "SimplifiedTaxInvoice.xml",
                      "SpecialZone-SEZAD.xml",
                      "SpecialZone-SHRFZ.xml",
                      "SpecialZone.xml",
                      "Summary-Construction.xml",
                      "Summary-Utilities.xml",
                      "Summary.xml",
                      "ThirdParty-Marketplace.xml",
                      "ThirdParty-Recovery.xml",
                      "ThirdParty.xml");
    }
    if (aVESID.equals (PeppolValidationPintOM.VID_OPENPEPPOL_OM_PINT_CREDIT_NOTE_1_0_0))
    {
      return _getAll ("pint-om/1.0.0/billing/cn/", "StandardCN.xml");
    }
    if (aVESID.equals (PeppolValidationPintOM.VID_OPENPEPPOL_OM_PINT_SB_INVOICE_1_0_0))
    {
      return _getAll ("pint-om/1.0.0/selfbilling/inv/",
                      "ProfitMarginSelfInvoice-Antiques.xml",
                      "ProfitMarginSelfInvoice.xml",
                      "Self-Billing.xml",
                      "SelfBilledInvoice.xml");
    }
    if (aVESID.equals (PeppolValidationPintOM.VID_OPENPEPPOL_OM_PINT_SB_CREDIT_NOTE_1_0_0))
    {
      return _getAll ("pint-om/1.0.0/selfbilling/cn/", "Self-BillingCN.xml");
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

    // 1.4.1
    if (aVESID.equals (PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_4_1))
    {
      return _getAll ("pint-sg/1.4.1/",
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
    if (aVESID.equals (PeppolValidationPintSG.VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_4_1))
    {
      return _getAll ("pint-sg/1.4.1/", "PINT-SG CN example 01 - Credit Note.xml");
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
