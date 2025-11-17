/*
 * Copyright (C) 2021-2025 Philip Helger (www.helger.com)
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
package com.helger.phive.ksef.mock;

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
import com.helger.phive.ksef.KSeFValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    KSeFValidation.initKSeF (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aESID : new DVRCoordinate [] { KSeFValidation.KSEF_1,
                                                            KSeFValidation.KSEF_2,
                                                            KSeFValidation.KSEF_3 })
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
    ValueEnforcer.notNull (aVESID, "DVRCoordinate");

    final String sBasePath = "src/test/resources/external/test-files/";
    if (aVESID.equals (KSeFValidation.KSEF_1))
    {
      return new CommonsArrayList <> (new String [] { "Przykêad 1.xml",
                                                      "Przykêad 2.xml",
                                                      "Przykêad 3.xml",
                                                      "Przykêad 4.xml",
                                                      "Przykêad 5.xml",
                                                      "Przykêad 6.xml",
                                                      "Przykêad 7.xml",
                                                      "Przykêad 8.xml",
                                                      "Przykêad 9.xml",
                                                      "Przykêad 10.xml",
                                                      "Przykêad 11.xml",
                                                      "Przykêad 12.xml",
                                                      "Przykêad 13.xml",
                                                      "Przykêad 14.xml",
                                                      "Przykêad 15.xml",
                                                      "Przykêad 16.xml",
                                                      "Przykêad 17.xml",
                                                      "Przykêad 18.xml",
                                                      "Przykêad 19.xml",
                                                      "Przykêad 20.xml",
                                                      "Przykêad 21.xml" },
                                      x -> new FileSystemResource (sBasePath + "fa1/" + x));
    }
    if (aVESID.equals (KSeFValidation.KSEF_2))
    {
      return new CommonsArrayList <> (new String [] { "FA_2_Przykêad_1.xml",
                                                      "FA_2_Przykêad_2.xml",
                                                      "FA_2_Przykêad_3.xml",
                                                      "FA_2_Przykêad_4.xml",
                                                      "FA_2_Przykêad_5.xml",
                                                      "FA_2_Przykêad_6.xml",
                                                      "FA_2_Przykêad_7.xml",
                                                      "FA_2_Przykêad_8.xml",
                                                      "FA_2_Przykêad_9.xml",
                                                      "FA_2_Przykêad_10.xml",
                                                      "FA_2_Przykêad_11.xml",
                                                      "FA_2_Przykêad_12.xml",
                                                      "FA_2_Przykêad_13.xml",
                                                      "Fa_2_Przykêad_14.xml",
                                                      "FA_2_Przykêad_15.xml",
                                                      "FA_2_Przykêad_16.xml",
                                                      "Fa_2_Przykêad_17.xml",
                                                      "Fa_2_Przykêad_18.xml",
                                                      "Fa_2_Przykêad_19.xml",
                                                      "Fa_2_Przykêad_20.xml",
                                                      "FA_2_Przykêad_21.xml" },
                                      x -> new FileSystemResource (sBasePath + "fa2/" + x));
    }
    if (aVESID.equals (KSeFValidation.KSEF_3))
    {
      return new CommonsArrayList <> (new String [] { "FA_3_Przykład_1.xml",
                                                      "FA_3_Przykład_2.xml",
                                                      "FA_3_Przykład_3.xml",
                                                      "FA_3_Przykład_4.xml",
                                                      "FA_3_Przykład_5.xml",
                                                      "FA_3_Przykład_6.xml",
                                                      "FA_3_Przykład_7.xml",
                                                      "FA_3_Przykład_8.xml",
                                                      "FA_3_Przykład_9.xml",
                                                      "FA_3_Przykład_10.xml",
                                                      "FA_3_Przykład_11.xml",
                                                      "FA_3_Przykład_12.xml",
                                                      "FA_3_Przykład_13.xml",
                                                      "Fa_3_Przykład_14.xml",
                                                      "FA_3_Przykład_15.xml",
                                                      "FA_3_Przykład_16.xml",
                                                      "Fa_3_Przykład_17.xml",
                                                      "Fa_3_Przykład_18.xml",
                                                      "Fa_3_Przykład_19.xml",
                                                      "Fa_3_Przykład_20.xml",
                                                      "FA_3_Przykład_21.xml",
                                                      "FA_3_Przykład_22.xml",
                                                      "FA_3_Przykład_23.xml",
                                                      "FA_3_Przykład_24.xml",
                                                      "FA_3_Przykład_25.xml" },
                                      x -> new FileSystemResource (sBasePath + "fa3/" + x));
    }

    throw new IllegalArgumentException ("Invalid DVRCoordinate: " + aVESID);
  }
}
