/*
 * Copyright (C) 2024 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnegative;
import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.Nonempty;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.zugferd.EZugferdProfile;
import com.helger.phive.zugferd.ZugferdValidation;

@Immutable
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    ZugferdValidation.initZugferd (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aVESID : new DVRCoordinate [] { ZugferdValidation.VID_ZUGFERD_2_3_2_MINIMUM,
                                                             ZugferdValidation.VID_ZUGFERD_2_3_2_BASIC_WL,
                                                             ZugferdValidation.VID_ZUGFERD_2_3_2_BASIC,
                                                             ZugferdValidation.VID_ZUGFERD_2_3_2_EN16931,
                                                             ZugferdValidation.VID_ZUGFERD_2_3_2_EXTENDED })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aVESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aVESID));
      }
    return ret;
  }

  @Nonnull
  @Nonempty
  private static ICommonsList <? extends IReadableResource> _createList (@Nonnull final String sZugferdVersion,
                                                                         @Nonnegative final int nCount,
                                                                         @Nonnull final EZugferdProfile eProfile)
  {
    final ICommonsList <IReadableResource> ret = new CommonsArrayList <> (nCount);
    for (int i = 1; i <= nCount; ++i)
      ret.add (new ClassPathResource ("/external/test-files/" +
                                      sZugferdVersion +
                                      "/" +
                                      eProfile.getFolderName () +
                                      "/factur-x-" +
                                      i +
                                      ".xml"));
    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    {
      final String sVersion = "2.3.2";
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_2_MINIMUM))
        return _createList (sVersion, 2, EZugferdProfile.MINIMUM);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_2_BASIC_WL))
        return _createList (sVersion, 1, EZugferdProfile.BASIC_WL);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_2_BASIC))
        return _createList (sVersion, 3, EZugferdProfile.BASIC);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_2_EN16931))
        return _createList (sVersion, 22, EZugferdProfile.EN16931);
      if (aVESID.equals (ZugferdValidation.VID_ZUGFERD_2_3_2_EXTENDED))
        return _createList (sVersion, 6, EZugferdProfile.EXTENDED);
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
