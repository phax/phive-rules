/*
 * Copyright (C) 2020-2025 Philip Helger (www.helger.com)
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
package com.helger.phive.svefaktura.mock;

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
import com.helger.phive.svefaktura.SvefakturaValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    SvefakturaValidation.initSvefaktura (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aESID : new DVRCoordinate [] { SvefakturaValidation.VID_SVEFAKTURA_10,
                                                            SvefakturaValidation.VID_OBJECT_ENVELOPE_10 })
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

    if (aVESID.equals (SvefakturaValidation.VID_SVEFAKTURA_10))
    {
      return new CommonsArrayList <> (new String [] { "svefaktura.xml",
                                                      "svefaktura bas.xml",
                                                      "svefaktura m ext ref.xml",
                                                      "svefaktura m koder.xml",
                                                      "svefaktura moms.xml" },
                                      x -> new ClassPathResource (sPrefix + "1.0/" + x));
    }
    if (aVESID.equals (SvefakturaValidation.VID_OBJECT_ENVELOPE_10))
    {
      return new CommonsArrayList <> (new String [] { "ObjectEnvelope.xml" },
                                      x -> new ClassPathResource (sPrefix + "1.0/" + x));
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
