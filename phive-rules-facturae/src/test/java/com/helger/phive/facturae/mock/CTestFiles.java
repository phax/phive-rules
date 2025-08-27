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
package com.helger.phive.facturae.mock;

import static org.junit.Assert.assertTrue;

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
import com.helger.phive.facturae.FacturaeValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

import jakarta.annotation.Nonnull;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    FacturaeValidation.initFacturae (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aVESID : new DVRCoordinate [] { FacturaeValidation.VID_FACTURAE_300,
                                                            FacturaeValidation.VID_FACTURAE_310,
                                                            FacturaeValidation.VID_FACTURAE_320,
                                                            FacturaeValidation.VID_FACTURAE_321,
                                                            FacturaeValidation.VID_FACTURAE_322 })
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

    final String sPrefix = "/external/test-files/";

    if (aVESID.equals (FacturaeValidation.VID_FACTURAE_300))
    {
      return new CommonsArrayList <> (new String [] { "factura2_ejemplo30.xml", "Invoice30.xml" },
                                      x -> new ClassPathResource (sPrefix + "3.0/" + x));
    }
    if (aVESID.equals (FacturaeValidation.VID_FACTURAE_310))
    {
      return new CommonsArrayList <> (new String [] { "factura_ejemplo_31.xml", "Invoice31.xsig" },
                                      x -> new ClassPathResource (sPrefix + "3.1/" + x));
    }
    if (aVESID.equals (FacturaeValidation.VID_FACTURAE_320))
    {
      return new CommonsArrayList <> (new String [] { "Invoice32.xsig" },
                                      x -> new ClassPathResource (sPrefix + "3.2/" + x));
    }
    if (aVESID.equals (FacturaeValidation.VID_FACTURAE_321))
    {
      return new CommonsArrayList <> (new String [] { "Invoice321.xsig" },
                                      x -> new ClassPathResource (sPrefix + "3.2.1/" + x));
    }
    if (aVESID.equals (FacturaeValidation.VID_FACTURAE_322))
    {
      return new CommonsArrayList <> (new String [] {}, x -> new ClassPathResource (sPrefix + "3.2.2/" + x));
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
