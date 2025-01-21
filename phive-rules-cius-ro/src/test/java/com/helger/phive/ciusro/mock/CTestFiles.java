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
package com.helger.phive.ciusro.mock;

import static org.junit.Assert.assertTrue;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.ciusro.CIUS_ROValidation;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    EN16931Validation.initEN16931 (VES_REGISTRY);
    CIUS_ROValidation.initCIUS_RO (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aESID : new DVRCoordinate [] { CIUS_ROValidation.VID_CIUS_RO_UBL_CREDITNOTE_103,
                                                            CIUS_ROValidation.VID_CIUS_RO_UBL_INVOICE_103,

                                                            CIUS_ROValidation.VID_CIUS_RO_UBL_CREDITNOTE_104,
                                                            CIUS_ROValidation.VID_CIUS_RO_UBL_INVOICE_104,

                                                            CIUS_ROValidation.VID_CIUS_RO_UBL_CREDITNOTE_108,
                                                            CIUS_ROValidation.VID_CIUS_RO_UBL_INVOICE_108,

                                                            CIUS_ROValidation.VID_CIUS_RO_UBL_CREDITNOTE_109,
                                                            CIUS_ROValidation.VID_CIUS_RO_UBL_INVOICE_109 })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aESID));
      }
    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    final String sPrefix = "/external/test-files/";

    if (aVESID.equals (CIUS_ROValidation.VID_CIUS_RO_UBL_CREDITNOTE_103))
    {
      return new CommonsArrayList <> (new String [] {}, x -> new ClassPathResource (sPrefix + "1.0.3/" + x));
    }
    if (aVESID.equals (CIUS_ROValidation.VID_CIUS_RO_UBL_INVOICE_103))
    {
      return new CommonsArrayList <> (new String [] { "ubl_b2g_example0.xml",
                                                      "ubl_b2g_example1.xml",
                                                      "ubl_b2g_example2.xml",
                                                      "ubl_b2g_example3.xml",
                                                      "ubl_b2g_example4.xml",
                                                      "ubl_b2g_example5.xml",
                                                      // too Buggy
                                                      // "ubl_b2g_example6.xml",
                                                      "ubl_b2g_example7.xml",
                                                      "ubl_b2g_example8.xml",
                                                      "ubl_b2g_example9.xml",
                                                      "ubl_b2g_example10.xml" },
                                      x -> new ClassPathResource (sPrefix + "1.0.3/" + x));
    }
    if (aVESID.equals (CIUS_ROValidation.VID_CIUS_RO_UBL_CREDITNOTE_104))
    {
      return new CommonsArrayList <> (new String [] {}, x -> new ClassPathResource (sPrefix + "1.0.4/" + x));
    }
    if (aVESID.equals (CIUS_ROValidation.VID_CIUS_RO_UBL_INVOICE_104))
    {
      return new CommonsArrayList <> (new String [] { "ubl_b2g_example0.xml",
                                                      "ubl_b2g_example1.xml",
                                                      "ubl_b2g_example2.xml",
                                                      "ubl_b2g_example3.xml",
                                                      "ubl_b2g_example4.xml",
                                                      "ubl_b2g_example5.xml",
                                                      // too Buggy
                                                      // "ubl_b2g_example6.xml",
                                                      "ubl_b2g_example7.xml",
                                                      "ubl_b2g_example8.xml",
                                                      "ubl_b2g_example9.xml",
                                                      "ubl_b2g_example10.xml" },
                                      x -> new ClassPathResource (sPrefix + "1.0.4/" + x));
    }
    if (aVESID.equals (CIUS_ROValidation.VID_CIUS_RO_UBL_CREDITNOTE_108))
    {
      return new CommonsArrayList <> (new String [] {}, x -> new ClassPathResource (sPrefix + "1.0.8/" + x));
    }
    if (aVESID.equals (CIUS_ROValidation.VID_CIUS_RO_UBL_INVOICE_108))
    {
      return new CommonsArrayList <> (new String [] { "ubl_b2g_example0.xml",
                                                      "ubl_b2g_example1.xml",
                                                      "ubl_b2g_example2.xml",
                                                      "ubl_b2g_example3.xml",
                                                      "ubl_b2g_example4.xml",
                                                      "ubl_b2g_example5.xml",
                                                      // too Buggy
                                                      // "ubl_b2g_example6.xml",
                                                      "ubl_b2g_example7.xml",
                                                      "ubl_b2g_example8.xml",
                                                      "ubl_b2g_example9.xml",
                                                      "ubl_b2g_example10.xml" },
                                      x -> new ClassPathResource (sPrefix + "1.0.8/" + x));
    }
    if (aVESID.equals (CIUS_ROValidation.VID_CIUS_RO_UBL_CREDITNOTE_109))
    {
      return new CommonsArrayList <> (new String [] {}, x -> new ClassPathResource (sPrefix + "1.0.9/" + x));
    }
    if (aVESID.equals (CIUS_ROValidation.VID_CIUS_RO_UBL_INVOICE_109))
    {
      return new CommonsArrayList <> (new String [] { "ubl_b2g_example0.xml",
                                                      "ubl_b2g_example1.xml",
                                                      "ubl_b2g_example2.xml",
                                                      "ubl_b2g_example3.xml",
                                                      "ubl_b2g_example4.xml",
                                                      "ubl_b2g_example5.xml",
                                                      // too Buggy
                                                      // "ubl_b2g_example6.xml",
                                                      "ubl_b2g_example7.xml",
                                                      "ubl_b2g_example8.xml",
                                                      "ubl_b2g_example9.xml",
                                                      "ubl_b2g_example10.xml" },
                                      x -> new ClassPathResource (sPrefix + "1.0.9/" + x));
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
