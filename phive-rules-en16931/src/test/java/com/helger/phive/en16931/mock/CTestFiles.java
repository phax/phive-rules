/*
 * Copyright (C) 2017-2023 Philip Helger (www.helger.com)
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
package com.helger.phive.en16931.mock;

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
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.engine.mock.MockFile;
import com.helger.phive.engine.source.IValidationSourceXML;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    EN16931Validation.initEN16931 (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <MockFile> getAllTestFiles ()
  {
    final ICommonsList <MockFile> ret = new CommonsArrayList <> ();
    for (final VESID aVESID : new VESID [] { EN16931Validation.VID_CII_100,
                                             EN16931Validation.VID_CII_110,
                                             EN16931Validation.VID_CII_120,
                                             EN16931Validation.VID_CII_121,
                                             EN16931Validation.VID_CII_123,
                                             EN16931Validation.VID_CII_130,
                                             EN16931Validation.VID_CII_131,
                                             EN16931Validation.VID_CII_132,
                                             EN16931Validation.VID_CII_133,
                                             EN16931Validation.VID_CII_134,
                                             EN16931Validation.VID_CII_135,
                                             EN16931Validation.VID_CII_136,
                                             EN16931Validation.VID_CII_136A,
                                             EN16931Validation.VID_CII_137,
                                             EN16931Validation.VID_CII_138,
                                             EN16931Validation.VID_CII_139,
                                             EN16931Validation.VID_CII_1310,

                                             EN16931Validation.VID_UBL_INVOICE_100,
                                             EN16931Validation.VID_UBL_INVOICE_110,
                                             EN16931Validation.VID_UBL_INVOICE_120,
                                             EN16931Validation.VID_UBL_INVOICE_121,
                                             EN16931Validation.VID_UBL_INVOICE_123,
                                             EN16931Validation.VID_UBL_INVOICE_130,
                                             EN16931Validation.VID_UBL_CREDIT_NOTE_130,
                                             EN16931Validation.VID_UBL_INVOICE_131,
                                             EN16931Validation.VID_UBL_CREDIT_NOTE_131,
                                             EN16931Validation.VID_UBL_INVOICE_132,
                                             EN16931Validation.VID_UBL_CREDIT_NOTE_132,
                                             EN16931Validation.VID_UBL_INVOICE_133,
                                             EN16931Validation.VID_UBL_CREDIT_NOTE_133,
                                             EN16931Validation.VID_UBL_INVOICE_134,
                                             EN16931Validation.VID_UBL_CREDIT_NOTE_134,
                                             EN16931Validation.VID_UBL_INVOICE_135,
                                             EN16931Validation.VID_UBL_CREDIT_NOTE_135,
                                             EN16931Validation.VID_UBL_INVOICE_136,
                                             EN16931Validation.VID_UBL_CREDIT_NOTE_136,
                                             EN16931Validation.VID_UBL_INVOICE_136A,
                                             EN16931Validation.VID_UBL_CREDIT_NOTE_136A,
                                             EN16931Validation.VID_UBL_INVOICE_137,
                                             EN16931Validation.VID_UBL_CREDIT_NOTE_137,
                                             EN16931Validation.VID_UBL_INVOICE_138,
                                             EN16931Validation.VID_UBL_CREDIT_NOTE_138,
                                             EN16931Validation.VID_UBL_INVOICE_139,
                                             EN16931Validation.VID_UBL_CREDIT_NOTE_139,
                                             EN16931Validation.VID_UBL_INVOICE_1310,
                                             EN16931Validation.VID_UBL_CREDIT_NOTE_1310 })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aVESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (MockFile.createGoodCase (aRes, aVESID));
      }
    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final VESID aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    final String sPrefix0 = "/external/test-files/";
    if (aVESID.equals (EN16931Validation.VID_CII_100))
    {
      final String sPrefix = sPrefix0 + "1.0.0/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_01a.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_example1.xml",
                                                      "CII_example2.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example5.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_110))
    {
      final String sPrefix = sPrefix0 + "1.1.0/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_example1.xml",
                                                      "CII_example2.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example5.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_120))
    {
      final String sPrefix = sPrefix0 + "1.2.0/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_example1.xml",
                                                      "CII_example2.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example5.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_121))
    {
      final String sPrefix = sPrefix0 + "1.2.1/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_example1.xml",
                                                      "CII_example2.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example5.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_123))
    {
      final String sPrefix = sPrefix0 + "1.2.3/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_example1.xml",
                                                      "CII_example2.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example5.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_130))
    {
      final String sPrefix = sPrefix0 + "1.3.0/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_example1.xml",
                                                      "CII_example2.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example5.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_131))
    {
      final String sPrefix = sPrefix0 + "1.3.1/cii/";
      return new CommonsArrayList <> (new String [] { "CII_example1.xml",
                                                      "CII_example2.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example5.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_132))
    {
      final String sPrefix = sPrefix0 + "1.3.2/cii/";
      return new CommonsArrayList <> (new String [] { "CII_example1.xml",
                                                      "CII_example2.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example5.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_133))
    {
      final String sPrefix = sPrefix0 + "1.3.3/cii/";
      return new CommonsArrayList <> (new String [] { "CII_example1.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_134))
    {
      final String sPrefix = sPrefix0 + "1.3.4/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_example1.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_135))
    {
      final String sPrefix = sPrefix0 + "1.3.5/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_business_example_Z.xml",
                                                      "CII_example1.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml",
                                                      "XRechnung-O.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_136))
    {
      final String sPrefix = sPrefix0 + "1.3.6/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_business_example_Z.xml",
                                                      "CII_example1.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml",
                                                      "XRechnung-O.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_136A))
    {
      final String sPrefix = sPrefix0 + "1.3.6a/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_example1.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml",
                                                      "CII-BR-CO-10-RoundingIssue.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_137))
    {
      final String sPrefix = sPrefix0 + "1.3.7/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_business_example_Z.xml",
                                                      "CII_example1.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml",
                                                      "XRechnung-O.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_138))
    {
      final String sPrefix = sPrefix0 + "1.3.8/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_business_example_Z.xml",
                                                      "CII_example1.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml",
                                                      "XRechnung-O.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_139))
    {
      final String sPrefix = sPrefix0 + "1.3.9/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_business_example_Z.xml",
                                                      "CII_example1.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml",
                                                      "XRechnung-O.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_CII_1310))
    {
      final String sPrefix = sPrefix0 + "1.3.10/cii/";
      return new CommonsArrayList <> (new String [] { "CII_business_example_01.xml",
                                                      "CII_business_example_02.xml",
                                                      "CII_example1.xml",
                                                      "CII_example3.xml",
                                                      "CII_example4.xml",
                                                      "CII_example6.xml",
                                                      "CII_example7.xml",
                                                      "CII_example8.xml",
                                                      "CII_example9.xml",
                                                      "XRechnung-O.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }

    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_100))
    {
      final String sPrefix = sPrefix0 + "1.0.0/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_110))
    {
      final String sPrefix = sPrefix0 + "1.1.0/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_120))
    {
      final String sPrefix = sPrefix0 + "1.2.0/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_121))
    {
      final String sPrefix = sPrefix0 + "1.2.1/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_123))
    {
      final String sPrefix = sPrefix0 + "1.2.3/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_130))
    {
      final String sPrefix = sPrefix0 + "1.3.0/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml",
                                                      "ubl-tc434-example10.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_CREDIT_NOTE_130))
    {
      final String sPrefix = sPrefix0 + "1.3.0/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-creditnote1.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_131))
    {
      final String sPrefix = sPrefix0 + "1.3.1/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml",
                                                      "ubl-tc434-example10.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_CREDIT_NOTE_131))
    {
      final String sPrefix = sPrefix0 + "1.3.1/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-creditnote1.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_132))
    {
      final String sPrefix = sPrefix0 + "1.3.2/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml",
                                                      "ubl-tc434-example10.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_CREDIT_NOTE_132))
    {
      final String sPrefix = sPrefix0 + "1.3.2/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-creditnote1.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_133))
    {
      final String sPrefix = sPrefix0 + "1.3.3/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml",
                                                      "ubl-tc434-example10.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_CREDIT_NOTE_133))
    {
      final String sPrefix = sPrefix0 + "1.3.3/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-creditnote1.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_134))
    {
      final String sPrefix = sPrefix0 + "1.3.4/ubl/";
      return new CommonsArrayList <> (new String [] { "FT G2G_TD01 con Allegato, Bonifico e Split Payment.xml",
                                                      "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_CREDIT_NOTE_134))
    {
      final String sPrefix = sPrefix0 + "1.3.4/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-creditnote1.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_135))
    {
      final String sPrefix = sPrefix0 + "1.3.5/ubl/";
      return new CommonsArrayList <> (new String [] { "BIS3_Invoice_negativ.XML",
                                                      "BIS3_Invoice_positive.XML",
                                                      "FT G2G_TD01 con Allegato, Bonifico e Split Payment.xml",
                                                      "guide-example1.xml",
                                                      "guide-example2.xml",
                                                      "guide-example3.xml",
                                                      "issue116.xml",
                                                      "sample-discount-price.xml",
                                                      "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example10.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_CREDIT_NOTE_135))
    {
      final String sPrefix = sPrefix0 + "1.3.5/ubl/";
      return new CommonsArrayList <> (new String [] { "CreditNote-signal_schemeID_for_VAT.xml",
                                                      "ubl-tc434-creditnote1.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_136))
    {
      final String sPrefix = sPrefix0 + "1.3.6/ubl/";
      return new CommonsArrayList <> (new String [] { "BIS3_Invoice_negativ.XML",
                                                      "BIS3_Invoice_positive.XML",
                                                      "guide-example1.xml",
                                                      "guide-example2.xml",
                                                      "guide-example3.xml",
                                                      "issue116.xml",
                                                      "sample-discount-price.xml",
                                                      "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example10.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_CREDIT_NOTE_136))
    {
      final String sPrefix = sPrefix0 + "1.3.6/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-creditnote1.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_136A))
    {
      final String sPrefix = sPrefix0 + "1.3.6a/ubl/";
      return new CommonsArrayList <> (new String [] { "FT G2G_TD01 con Allegato, Bonifico e Split Payment.xml",
                                                      "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_CREDIT_NOTE_136A))
    {
      final String sPrefix = sPrefix0 + "1.3.6a/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-creditnote1.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_137))
    {
      final String sPrefix = sPrefix0 + "1.3.7/ubl/";
      return new CommonsArrayList <> (new String [] { "BIS3_Invoice_negativ.XML",
                                                      "BIS3_Invoice_positive.XML",
                                                      "guide-example1.xml",
                                                      "guide-example2.xml",
                                                      "guide-example3.xml",
                                                      "issue116.xml",
                                                      "sample-discount-price.xml",
                                                      "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example10.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_CREDIT_NOTE_137))
    {
      final String sPrefix = sPrefix0 + "1.3.7/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-creditnote1.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_138))
    {
      final String sPrefix = sPrefix0 + "1.3.8/ubl/";
      return new CommonsArrayList <> (new String [] { "BIS3_Invoice_negativ.XML",
                                                      "BIS3_Invoice_positive.XML",
                                                      "guide-example1.xml",
                                                      "guide-example2.xml",
                                                      "guide-example3.xml",
                                                      "issue116.xml",
                                                      "sample-discount-price.xml",
                                                      "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example10.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_CREDIT_NOTE_138))
    {
      final String sPrefix = sPrefix0 + "1.3.8/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-creditnote1.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_139))
    {
      final String sPrefix = sPrefix0 + "1.3.9/ubl/";
      return new CommonsArrayList <> (new String [] { "BIS3_Invoice_negativ.XML",
                                                      "BIS3_Invoice_positive.XML",
                                                      "guide-example1.xml",
                                                      "guide-example2.xml",
                                                      "guide-example3.xml",
                                                      "issue116.xml",
                                                      "sample-discount-price.xml",
                                                      "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example10.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_CREDIT_NOTE_139))
    {
      final String sPrefix = sPrefix0 + "1.3.9/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-creditnote1.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_INVOICE_1310))
    {
      final String sPrefix = sPrefix0 + "1.3.10/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-example1.xml",
                                                      "ubl-tc434-example2.xml",
                                                      "ubl-tc434-example3.xml",
                                                      "ubl-tc434-example4.xml",
                                                      "ubl-tc434-example5.xml",
                                                      "ubl-tc434-example6.xml",
                                                      "ubl-tc434-example7.xml",
                                                      "ubl-tc434-example8.xml",
                                                      "ubl-tc434-example9.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    if (aVESID.equals (EN16931Validation.VID_UBL_CREDIT_NOTE_1310))
    {
      final String sPrefix = sPrefix0 + "1.3.10/ubl/";
      return new CommonsArrayList <> (new String [] { "ubl-tc434-creditnote1.xml" },
                                      x -> new ClassPathResource (sPrefix + x));
    }
    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
