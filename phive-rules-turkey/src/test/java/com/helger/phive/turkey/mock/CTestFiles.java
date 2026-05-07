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
package com.helger.phive.turkey.mock;

import static org.junit.Assert.assertTrue;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsSet;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.turkey.TurkeyEFaturaValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    TurkeyEFaturaValidation.initTurkeyEFatura (VES_REGISTRY);
  }

  private static final String PREFIX = "/external/test-files/1.2.1/";

  private CTestFiles ()
  {}

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aVESID : new DVRCoordinate [] { TurkeyEFaturaValidation.VID_TR_EFATURA_INVOICE_1_2_1,
                                                             TurkeyEFaturaValidation.VID_TR_EFATURA_APPRESP_1_2_1,
                                                             TurkeyEFaturaValidation.VID_TR_EFATURA_DESPATCH_1_2_1,
                                                             TurkeyEFaturaValidation.VID_TR_EFATURA_RECEIPT_1_2_1,
                                                             TurkeyEFaturaValidation.VID_TR_EFATURA_ZARF_1_2_1 })
    {
      for (final IReadableResource aRes : getAllMatchingTestFiles (aVESID))
      {
        assertTrue ("Not existing good test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aVESID));
      }
      for (final IReadableResource aRes : getAllBadTestFiles (aVESID))
      {
        assertTrue ("Not existing bad test file: " + aRes.getPath (), aRes.exists ());
        // Legacy GİB samples that no longer satisfy the current ruleset (cbc:ID regex, TCKN length,
        // multi-FirstName XPath, missing extension content, etc.). Kept so the test verifies the
        // rule pipeline flags the divergences.
        final ICommonsSet <String> aExpected = new CommonsHashSet <> ("rule-violation-from-legacy-sample");
        ret.add (new PhiveTestFile (aRes, aVESID, aExpected));
      }
    }
    return ret;
  }

  /**
   * Test files that are expected to validate cleanly (no error) for the given VES coordinate. Add
   * new positive samples here.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@NonNull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "DVRCoordinate");

    if (aVESID.equals (TurkeyEFaturaValidation.VID_TR_EFATURA_INVOICE_1_2_1))
    {
      return new CommonsArrayList <> (new String [] { "Good_TemelFatura.xml",
                                                      "TicariFaturaOrnegi.xml",
                                                      "SARJ.xml",
                                                      "SARJANLIK.xml",
                                                      "IDIS_Fatura.xml",
                                                      "YTB_Satıs_Efatura.xml",
                                                      "YTB_Iade_Efatura.xml",
                                                      "YTB_Istisna_Efatura.xml",
                                                      "YTB_Iade_Istısna_Efatura.xml",
                                                      "YTB_Tevkıfat_Efatura.xml",
                                                      "YTB_TevkıfatIade_Efatura.xml" },
                                      s -> new ClassPathResource (PREFIX + "invoice/" + s));
    }
    if (aVESID.equals (TurkeyEFaturaValidation.VID_TR_EFATURA_APPRESP_1_2_1))
    {
      return new CommonsArrayList <> (new String [] { "IHRACAT_GTB_UygulamaYaniti_KABUL.xml",
                                                      "IHRACAT_GTB_UygulamaYaniti_RED.xml",
                                                      "YOLCUBERABER_UygulamaYaniti.xml" },
                                      s -> new ClassPathResource (PREFIX + "applicationresponse/" + s));
    }
    if (aVESID.equals (TurkeyEFaturaValidation.VID_TR_EFATURA_DESPATCH_1_2_1))
    {
      return new CommonsArrayList <> (new String [] { "IDIS_Irsaliye.xml" },
                                      s -> new ClassPathResource (PREFIX + "despatchadvice/" + s));
    }
    if (aVESID.equals (TurkeyEFaturaValidation.VID_TR_EFATURA_RECEIPT_1_2_1))
    {
      return new CommonsArrayList <> (new String [] { "IrsaliyeYaniti-Ornek1.xml",
                                                      "IrsaliyeYaniti-Ornek2.xml",
                                                      "IrsaliyeYaniti-Ornek3.xml",
                                                      "IrsaliyeYaniti-Ornek4.xml" },
                                      s -> new ClassPathResource (PREFIX + "receiptadvice/" + s));
    }
    if (aVESID.equals (TurkeyEFaturaValidation.VID_TR_EFATURA_ZARF_1_2_1))
    {
      return new CommonsArrayList <> (new String [] { "Good_TemelFatura_Zarf.xml" },
                                      s -> new ClassPathResource (PREFIX + "zarf/" + s));
    }

    throw new IllegalArgumentException ("Invalid DVRCoordinate: " + aVESID);
  }

  /**
   * Test files that are expected to fail validation (at least one error) for the given VES
   * coordinate. These are legacy GİB samples that no longer satisfy the current ruleset; they are
   * kept so the test verifies the rule pipeline flags the divergences. Add new negative samples
   * here.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllBadTestFiles (@NonNull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "DVRCoordinate");

    if (aVESID.equals (TurkeyEFaturaValidation.VID_TR_EFATURA_INVOICE_1_2_1))
    {
      return new CommonsArrayList <> (new String [] { "TemelFaturaOrnegi.xml",
                                                      "IadeFaturasiOrnegi.xml",
                                                      "IHRACAT.xml",
                                                      "ISTISNA-1.xml",
                                                      "ISTISNA-2.xml",
                                                      "OTV.xml",
                                                      "OZELMATRAH.xml",
                                                      "TEVKIFAT.xml",
                                                      "YOLCUBERABER.xml",
                                                      "HASTANE.xml",
                                                      "HKS-Ornek1.xml",
                                                      "HKS-Ornek2.xml" },
                                      s -> new ClassPathResource (PREFIX + "invoice/" + s));
    }
    if (aVESID.equals (TurkeyEFaturaValidation.VID_TR_EFATURA_APPRESP_1_2_1))
    {
      return new CommonsArrayList <> (new String [] { "KabulUygulamaYanitiOrnegi.xml",
                                                      "RedUygulamaYanitiOrnegi.xml",
                                                      "IadeUygulamaYanitiOrnegi.xml" },
                                      s -> new ClassPathResource (PREFIX + "applicationresponse/" + s));
    }
    if (aVESID.equals (TurkeyEFaturaValidation.VID_TR_EFATURA_DESPATCH_1_2_1))
    {
      return new CommonsArrayList <> (new String [] { "Irsaliye-Ornek1.xml",
                                                      "Irsaliye-Ornek2.xml",
                                                      "Irsaliye-Ornek3.xml",
                                                      "Irsaliye-Matbudan.xml" },
                                      s -> new ClassPathResource (PREFIX + "despatchadvice/" + s));
    }
    if (aVESID.equals (TurkeyEFaturaValidation.VID_TR_EFATURA_RECEIPT_1_2_1))
    {
      return new CommonsArrayList <> ();
    }
    if (aVESID.equals (TurkeyEFaturaValidation.VID_TR_EFATURA_ZARF_1_2_1))
    {
      return new CommonsArrayList <> ();
    }

    throw new IllegalArgumentException ("Invalid DVRCoordinate: " + aVESID);
  }
}
