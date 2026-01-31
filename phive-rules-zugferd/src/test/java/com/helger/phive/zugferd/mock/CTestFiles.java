/*
 * Copyright (C) 2024-2026 Philip Helger (www.helger.com)
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
package com.helger.phive.zugferd.mock;

import static org.junit.Assert.assertTrue;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.Nonempty;
import com.helger.annotation.Nonnegative;
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
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.zugferd.EZugferdProfile;
import com.helger.phive.zugferd.ZugferdValidation;

@Immutable
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    EN16931Validation.initEN16931 (VES_REGISTRY);
    ZugferdValidation.initZugferd (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @SuppressWarnings ("deprecation")
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aVESID : new DVRCoordinate [] { // 2.0.1
                                                             ZugferdValidation.VID_ZUGFERD_2_0_1_MINIMUM,
                                                             ZugferdValidation.VID_ZUGFERD_2_0_1_BASIC_WL,
                                                             ZugferdValidation.VID_ZUGFERD_2_0_1_BASIC,
                                                             ZugferdValidation.VID_ZUGFERD_2_0_1_EN16931,
                                                             ZugferdValidation.VID_ZUGFERD_2_0_1_EXTENDED,

                                                             // 2.1
                                                             ZugferdValidation.VID_ZUGFERD_2_1_MINIMUM,
                                                             ZugferdValidation.VID_ZUGFERD_2_1_BASIC_WL,
                                                             ZugferdValidation.VID_ZUGFERD_2_1_BASIC,
                                                             ZugferdValidation.VID_ZUGFERD_2_1_EN16931,
                                                             ZugferdValidation.VID_ZUGFERD_2_1_EXTENDED,

                                                             // 2.2
                                                             ZugferdValidation.VID_ZUGFERD_2_2_MINIMUM,
                                                             ZugferdValidation.VID_ZUGFERD_2_2_BASIC_WL,
                                                             ZugferdValidation.VID_ZUGFERD_2_2_BASIC,
                                                             ZugferdValidation.VID_ZUGFERD_2_2_EN16931,
                                                             ZugferdValidation.VID_ZUGFERD_2_2_EXTENDED,

                                                             // 2.3.2
                                                             ZugferdValidation.VID_ZUGFERD_2_3_2_MINIMUM,
                                                             ZugferdValidation.VID_ZUGFERD_2_3_2_BASIC_WL,
                                                             ZugferdValidation.VID_ZUGFERD_2_3_2_BASIC,
                                                             ZugferdValidation.VID_ZUGFERD_2_3_2_EN16931,
                                                             ZugferdValidation.VID_ZUGFERD_2_3_2_EXTENDED,

                                                             // 2.3.3
                                                             ZugferdValidation.VID_ZUGFERD_2_3_3_MINIMUM,
                                                             ZugferdValidation.VID_ZUGFERD_2_3_3_BASIC_WL,
                                                             ZugferdValidation.VID_ZUGFERD_2_3_3_BASIC,
                                                             ZugferdValidation.VID_ZUGFERD_2_3_3_EN16931,
                                                             ZugferdValidation.VID_ZUGFERD_2_3_3_EXTENDED,

                                                             // 2.4
                                                             ZugferdValidation.VID_ZUGFERD_2_4_MINIMUM,
                                                             ZugferdValidation.VID_ZUGFERD_2_4_BASIC_WL,
                                                             ZugferdValidation.VID_ZUGFERD_2_4_BASIC,
                                                             ZugferdValidation.VID_ZUGFERD_2_4_EN16931,
                                                             ZugferdValidation.VID_ZUGFERD_2_4_EXTENDED })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aVESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aVESID));
      }
    return ret;
  }

  @NonNull
  @Nonempty
  private static ICommonsList <? extends IReadableResource> _createList (@NonNull final String sZugferdVersion,
                                                                         @Nonnegative final int nCount,
                                                                         @NonNull final EZugferdProfile eProfile,
                                                                         @NonNull final String sFilenamePrefix)
  {
    final ICommonsList <IReadableResource> ret = new CommonsArrayList <> (nCount);
    for (int i = 1; i <= nCount; ++i)
      ret.add (new ClassPathResource ("/external/test-files/" +
                                      sZugferdVersion +
                                      "/" +
                                      eProfile.getFolderName () +
                                      "/" +
                                      sFilenamePrefix +
                                      "-" +
                                      i +
                                      ".xml"));
    return ret;
  }

  @NonNull
  @Nonempty
  private static ICommonsList <? extends IReadableResource> _createListFacturX (@NonNull final String sZugferdVersion,
                                                                                @Nonnegative final int nCount,
                                                                                @NonNull final EZugferdProfile eProfile)
  {
    return _createList (sZugferdVersion, nCount, eProfile, "factur-x");
  }

  @SuppressWarnings ("deprecation")
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@NonNull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    {
      final String sVersion = "2.0.1";
      final String sFilenamePrefix = "zugferd-invoice";
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_0_1_MINIMUM))
        return _createList (sVersion, 1, EZugferdProfile.MINIMUM, sFilenamePrefix);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_0_1_BASIC_WL))
        return _createList (sVersion, 0, EZugferdProfile.BASIC_WL, sFilenamePrefix);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_0_1_BASIC))
        return _createList (sVersion, 3, EZugferdProfile.BASIC, sFilenamePrefix);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_0_1_EN16931))
        return _createList (sVersion, 20, EZugferdProfile.EN16931, sFilenamePrefix);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_0_1_EXTENDED))
        return _createList (sVersion, 5, EZugferdProfile.EXTENDED, sFilenamePrefix);
    }

    {
      final String sVersion = "2.1";
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_1_MINIMUM))
        return _createListFacturX (sVersion, 2, EZugferdProfile.MINIMUM);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_1_BASIC_WL))
        return _createListFacturX (sVersion, 2, EZugferdProfile.BASIC_WL);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_1_BASIC))
        return _createListFacturX (sVersion, 3, EZugferdProfile.BASIC);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_1_EN16931))
        return _createListFacturX (sVersion, 26, EZugferdProfile.EN16931);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_1_EXTENDED))
        return _createListFacturX (sVersion, 5, EZugferdProfile.EXTENDED);
    }

    {
      final String sVersion = "2.2";
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_2_MINIMUM))
        return _createListFacturX (sVersion, 2, EZugferdProfile.MINIMUM);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_2_BASIC_WL))
        return _createListFacturX (sVersion, 1, EZugferdProfile.BASIC_WL);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_2_BASIC))
        return _createListFacturX (sVersion, 3, EZugferdProfile.BASIC);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_2_EN16931))
        return _createListFacturX (sVersion, 22, EZugferdProfile.EN16931);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_2_EXTENDED))
        return _createListFacturX (sVersion, 5, EZugferdProfile.EXTENDED);
    }

    {
      final String sVersion = "2.3.2";
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_2_MINIMUM))
        return _createListFacturX (sVersion, 2, EZugferdProfile.MINIMUM);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_2_BASIC_WL))
        return _createListFacturX (sVersion, 1, EZugferdProfile.BASIC_WL);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_2_BASIC))
        return _createListFacturX (sVersion, 3, EZugferdProfile.BASIC);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_2_EN16931))
        return _createListFacturX (sVersion, 22, EZugferdProfile.EN16931);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_2_EXTENDED))
        return _createListFacturX (sVersion, 6, EZugferdProfile.EXTENDED);
    }

    {
      final String sVersion = "2.3.3";
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_3_MINIMUM))
        return _createListFacturX (sVersion, 2, EZugferdProfile.MINIMUM);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_3_BASIC_WL))
        return _createListFacturX (sVersion, 2, EZugferdProfile.BASIC_WL);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_3_BASIC))
        return _createListFacturX (sVersion, 3, EZugferdProfile.BASIC);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_3_EN16931))
        return _createListFacturX (sVersion, 22, EZugferdProfile.EN16931);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_3_EXTENDED))
        return _createListFacturX (sVersion, 6, EZugferdProfile.EXTENDED);
    }

    {
      final String sVersion = "2.4";
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_4_MINIMUM))
        return _createListFacturX (sVersion, 2, EZugferdProfile.MINIMUM);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_4_BASIC_WL))
        return _createListFacturX (sVersion, 2, EZugferdProfile.BASIC_WL);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_4_BASIC))
        return _createListFacturX (sVersion, 3, EZugferdProfile.BASIC);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_4_EN16931))
        return _createListFacturX (sVersion, 25, EZugferdProfile.EN16931);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_4_EXTENDED))
        return _createListFacturX (sVersion, 18, EZugferdProfile.EXTENDED);
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
