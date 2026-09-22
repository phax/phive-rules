/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.phive.ciusdk.mock;

import static org.junit.Assert.assertTrue;

import org.jspecify.annotations.NonNull;

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
import com.helger.phive.ciusdk.CIUS_DKValidation;
import com.helger.phive.peppol.PeppolValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    // Must be before CIUS-DK, because the CIUS-DK rules build on the Peppol BIS Billing rules
    PeppolValidation.initStandard (VES_REGISTRY);
    CIUS_DKValidation.init (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aESID : new DVRCoordinate [] { CIUS_DKValidation.VID_CIUS_DK_UBL_CREDITNOTE_1170,
                                                            CIUS_DKValidation.VID_CIUS_DK_UBL_INVOICE_1170 })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aESID));
      }
    return ret;
  }

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@NonNull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    final String sPrefix = "/external/test-files/";

    // 1.17.0
    if (aVESID.equals (CIUS_DKValidation.VID_CIUS_DK_UBL_CREDITNOTE_1170))
    {
      return new CommonsArrayList <> (new String [] { "BIS3_CreditNote_Example_DK_Supplier_Master.xml",
                                                      "BIS3_CreditNote_Example_DK_Supplier_Minor.xml",
                                                      "base-creditnote-correction.xml" },
                                      x -> new ClassPathResource (sPrefix + "1.17.0/" + x));
    }
    if (aVESID.equals (CIUS_DKValidation.VID_CIUS_DK_UBL_INVOICE_1170))
    {
      return new CommonsArrayList <> (new String [] { "Allowance-example.xml",
                                                      "BIS3_Invoice_Example_DK_Supplier_Master.xml",
                                                      "BIS3_Invoice_Example_DK_Supplier_Minor.xml",
                                                      "BIS3_Invoice_Example_NO_Supplier_Minor.xml",
                                                      "BIS3_NegativInvoice_Example_NegativeLine.xml",
                                                      "BIS3_NegativInvoice_Example_NegativeLine_InclAC.xml",
                                                      "BIS3_NegativInvoice_Example_PrePayment.xml",
                                                      "Vat-category-S.xml",
                                                      "base-example.xml",
                                                      "base-negative-inv-correction.xml",
                                                      "sales-order-example.xml",
                                                      "vat-category-E.xml",
                                                      "vat-category-O.xml",
                                                      "vat-category-Z.xml" },
                                      x -> new ClassPathResource (sPrefix + "1.17.0/" + x));
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
