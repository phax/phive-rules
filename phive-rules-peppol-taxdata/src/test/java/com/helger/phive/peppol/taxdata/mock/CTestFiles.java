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
package com.helger.phive.peppol.taxdata.mock;

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
import com.helger.phive.peppol.taxdata.PeppolValidationTaxData;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    PeppolValidationTaxData.init (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aVESID : new DVRCoordinate [] { /* Peppol TaxData */
                                                             PeppolValidationTaxData.VID_OPENPEPPOL_TDD_AE_1_0_0,
                                                             PeppolValidationTaxData.VID_OPENPEPPOL_TDD_AE_1_0_1,
                                                             PeppolValidationTaxData.VID_OPENPEPPOL_TDD_AE_1_0_2,
                                                             PeppolValidationTaxData.VID_OPENPEPPOL_TDD_AE_1_0_3,

                                                             PeppolValidationTaxData.VID_OPENPEPPOL_TDD_OM_1_0_0,

                                                             PeppolValidationTaxData.VID_OPENPEPPOL_TDD_SK_1_0_0,

                                                             PeppolValidationTaxData.VID_OPENPEPPOL_TDD_VIDA_1_0_0,
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
    // AE TDD 1.0.3
    if (aVESID.equals (PeppolValidationTaxData.VID_OPENPEPPOL_TDD_AE_1_0_3))
    {
      return _getAll ("tdd/ae/1.0.3/",
                      "commercial-invoice-tdd.xml",
                      "example-tds-no-repdoc.xml",
                      "example-tds-with-repdoc.xml",
                      "simple.xml",
                      "standard-invoice-tdd.xml",
                      "tax-currency.xml");
    }

    // OM TDD 1.0.0
    if (aVESID.equals (PeppolValidationTaxData.VID_OPENPEPPOL_TDD_OM_1_0_0))
    {
      return _getAll ("tdd/om/1.0.0/",
                      "commercial-invoice-tdd.xml",
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

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
