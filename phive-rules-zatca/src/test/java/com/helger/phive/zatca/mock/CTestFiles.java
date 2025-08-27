/*
 * Copyright (C) 2025 Philip Helger (www.helger.com)
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
package com.helger.phive.zatca.mock;

import static org.junit.Assert.assertTrue;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.zatca.ZATCAValidation;

import jakarta.annotation.Nonnull;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    ZATCAValidation.initZATCA (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aESID : new DVRCoordinate [] { ZATCAValidation.VID_INVOICE_UBL_2_0_3,
                                                            ZATCAValidation.VID_INVOICE_UBL_2_3_8 })
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

    final String sPrefix0 = "/external/test-files/";

    // 2.0.3
    if (aVESID.equals (ZATCAValidation.VID_INVOICE_UBL_2_0_3))
    {
      return new CommonsArrayList <> ();
    }

    // 2.3.8
    if (aVESID.equals (ZATCAValidation.VID_INVOICE_UBL_2_3_8))
    {
      final String sPrefix = sPrefix0 + "2.3.8/";
      return new CommonsArrayList <> (new String [] { "Simplified/Credit/Credit Note of a Simplified Tax Invoice.xml",
                                                      "Simplified/Credit/Simplified_Credit_Note.xml",
                                                      "Simplified/Debit/Simplified_Debit_Note.xml",
                                                      "Simplified/Invoice/Nominal supply invoice.xml",
                                                      "Simplified/Invoice/Simplified_Invoice.xml",
                                                      "Simplified/Invoice/Simplified Tax Invoice with Zero Rated Item.xml",
                                                      "Standard/Credit/Standard_Credit_Note.xml",
                                                      "Standard/Debit/Standard_Debit_Note.xml",
                                                      "Standard/Invoice/Advance Payment adjustments.xml",
                                                      "Standard/Invoice/Advance Payment adjustments with foreign currency invoice.xml",
                                                      "Standard/Invoice/Advance Payment adjustments with rate change scenarios.xml",
                                                      "Standard/Invoice/Exempt Tax Invoice.xml",
                                                      "Standard/Invoice/Export invoice.xml",
                                                      "Standard/Invoice/Out of Scope Standard Tax Invoice.xml",
                                                      "Standard/Invoice/Self-billing invoice.xml",
                                                      "Standard/Invoice/Standard_Invoice.xml",
                                                      // "Standard/Invoice/Standard Invoice with
                                                      // Document Level Charge.xml",
                                                      "Standard/Invoice/Standard Invoice with Payable Rounding Adjustment.xml",
                                                      "Standard/Invoice/Summary Invoice.xml",
                                                      "Standard/Invoice/Third party billing.xml",

      }, x -> new ClassPathResource (sPrefix + x));
    }
    throw new IllegalStateException ("Unsupported VESID " + aVESID);
  }
}
