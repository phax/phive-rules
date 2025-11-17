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
package com.helger.phive.france.mock;

import static org.junit.Assert.assertTrue;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.cii.testfiles.CDARTestFiles;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.france.FranceCTCValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    FranceCTCValidation.initFranceCTC (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aVESID : new DVRCoordinate [] { FranceCTCValidation.VID_FR_CTC_UBL_INV_0_1,
                                                             FranceCTCValidation.VID_FR_CTC_UBL_CN_0_1,
                                                             FranceCTCValidation.VID_FR_CTC_CII_0_1,

                                                             FranceCTCValidation.VID_FR_CTC_UBL_INV_1_2_0,
                                                             FranceCTCValidation.VID_FR_CTC_UBL_CN_1_2_0,
                                                             FranceCTCValidation.VID_FR_CTC_CII_1_2_0,
                                                             FranceCTCValidation.VID_FR_CTC_CDAR_1_2_0 })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aVESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aVESID));
      }
    return ret;
  }

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@NonNull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "DVRCoordinate");

    @SuppressWarnings ("unused")
    final String sPrefix = "/external/test-files/";
    if (aVESID.equals (FranceCTCValidation.VID_FR_CTC_UBL_INV_0_1) ||
        aVESID.equals (FranceCTCValidation.VID_FR_CTC_UBL_CN_0_1) ||
        aVESID.equals (FranceCTCValidation.VID_FR_CTC_CII_0_1))
    {
      // No test files available
      return new CommonsArrayList <> ();
    }

    if (aVESID.equals (FranceCTCValidation.VID_FR_CTC_UBL_INV_1_2_0) ||
        aVESID.equals (FranceCTCValidation.VID_FR_CTC_UBL_CN_1_2_0) ||
        aVESID.equals (FranceCTCValidation.VID_FR_CTC_CII_1_2_0))
    {
      // No test files available
      return new CommonsArrayList <> ();
    }
    if (aVESID.equals (FranceCTCValidation.VID_FR_CTC_CDAR_1_2_0))
    {
      return new CommonsArrayList <> (CDARTestFiles.D22B_FILES, ClassPathResource::new);
    }

    throw new IllegalArgumentException ("Invalid DVRCoordinate: " + aVESID);
  }
}
