/*
 * Copyright (C) 2018-2025 Philip Helger (www.helger.com)
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
package com.helger.phive.ebinterface.mock;

import static org.junit.Assert.assertTrue;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.ebinterface.EbInterfaceValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    EbInterfaceValidation.initEbInterface (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aVESID : new DVRCoordinate [] { EbInterfaceValidation.VID_EBI_30,
                                                             EbInterfaceValidation.VID_EBI_302,
                                                             EbInterfaceValidation.VID_EBI_40,
                                                             EbInterfaceValidation.VID_EBI_41,
                                                             EbInterfaceValidation.VID_EBI_42,
                                                             EbInterfaceValidation.VID_EBI_43,
                                                             EbInterfaceValidation.VID_EBI_50,
                                                             EbInterfaceValidation.VID_EBI_60,
                                                             EbInterfaceValidation.VID_EBI_61 })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aVESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aVESID));
      }
    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    if (aVESID.equals (EbInterfaceValidation.VID_EBI_30))
      return EEbInterfaceTestFiles.V30.getTestResources ();
    if (aVESID.equals (EbInterfaceValidation.VID_EBI_302))
      return EEbInterfaceTestFiles.V302.getTestResources ();
    if (aVESID.equals (EbInterfaceValidation.VID_EBI_40))
      return EEbInterfaceTestFiles.V40.getTestResources ();
    if (aVESID.equals (EbInterfaceValidation.VID_EBI_41))
      return EEbInterfaceTestFiles.V41.getTestResources ();
    if (aVESID.equals (EbInterfaceValidation.VID_EBI_42))
      return EEbInterfaceTestFiles.V42.getTestResources ();
    if (aVESID.equals (EbInterfaceValidation.VID_EBI_43))
      return EEbInterfaceTestFiles.V43.getTestResources ();
    if (aVESID.equals (EbInterfaceValidation.VID_EBI_50))
      return EEbInterfaceTestFiles.V50.getTestResources ();
    if (aVESID.equals (EbInterfaceValidation.VID_EBI_60))
      return EEbInterfaceTestFiles.V60.getTestResources ();
    if (aVESID.equals (EbInterfaceValidation.VID_EBI_61))
      return EEbInterfaceTestFiles.V61.getTestResources ();

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
