/*
 * Copyright (C) 2020-2023 Philip Helger (www.helger.com)
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
package com.helger.phive.finvoice.mock;

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
import com.helger.phive.engine.mock.MockFile;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.finvoice.FinvoiceValidation;

@Immutable
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    FinvoiceValidation.initFinvoice (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <MockFile> getAllTestFiles ()
  {
    final ICommonsList <MockFile> ret = new CommonsArrayList <> ();
    for (final VESID aESID : new VESID [] { FinvoiceValidation.VID_FINVOICE_13,
                                            FinvoiceValidation.VID_FINVOICE_20,
                                            FinvoiceValidation.VID_FINVOICE_201,
                                            FinvoiceValidation.VID_FINVOICE_30 })
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

    final String sPrefix = "/external/test-files/";

    if (aVESID.equals (FinvoiceValidation.VID_FINVOICE_13))
    {
      return new CommonsArrayList <> (new String [] { "example.xml", "sample.xml" },
                                      x -> new ClassPathResource (sPrefix + "1.3/" + x));
    }
    if (aVESID.equals (FinvoiceValidation.VID_FINVOICE_20))
    {
      return new CommonsArrayList <> (new String [] {}, x -> new ClassPathResource (sPrefix + "2.01/" + x));
    }
    if (aVESID.equals (FinvoiceValidation.VID_FINVOICE_201))
    {
      return new CommonsArrayList <> (new String [] { "finvoice_201_example.xml", "Finvoice 2.01 example.xml" },
                                      x -> new ClassPathResource (sPrefix + "2.01/" + x));
    }
    if (aVESID.equals (FinvoiceValidation.VID_FINVOICE_30))
    {
      return new CommonsArrayList <> (new String [] { "finvoice_30_example.xml",
                                                      "Verkkoyhtion_kulutuslaskuesimerkki_Ennakko_PaidAmount_20190405.xml",
                                                      "Verkkoyhtion_kulutuslaskuesimerkki_Vakiokorvaus_20190405.xml",
                                                      "Verkkoyhtiön_kulutuslaskuesimerkki_20190405.xml",
                                                      "Verkkoyhtiön_loppulaskuesimerkki_yritys_20190405.xml",
                                                      "Verkkoyhtiön_läpilaskutuksen_erillislaskuesimerkki_20190405.xml",
                                                      "Verkkoyhtiö_yrityslaskuesimerkki_20190405.xml",
                                                      "Verkkoyhtiö_yrityslaskuesimerkki_siirtyvä_veloitus_20190405.xml" },
                                      x -> new ClassPathResource (sPrefix + "3.0/" + x));
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
