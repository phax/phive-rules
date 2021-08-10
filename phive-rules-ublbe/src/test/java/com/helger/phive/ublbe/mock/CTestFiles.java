/**
 * Copyright (C) 2018-2021 Philip Helger (www.helger.com)
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
package com.helger.phive.ublbe.mock;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.collection.impl.ICommonsMap;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.engine.mock.MockFile;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.peppol.legacy.PeppolLegacyValidation;
import com.helger.phive.ublbe.UBLBEValidation;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    // Peppol is a prerequisite
    PeppolLegacyValidation.init (VES_REGISTRY);
    UBLBEValidation.initUBLBE (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <MockFile> getAllTestFiles ()
  {
    final ICommonsList <MockFile> ret = new CommonsArrayList <> ();
    for (final VESID aESID : new VESID [] { UBLBEValidation.VID_EFFF_INVOICE,
                                            UBLBEValidation.VID_EFFF_CREDIT_NOTE,
                                            UBLBEValidation.VID_UBL_BE_INVOICE_100,
                                            UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_100,
                                            UBLBEValidation.VID_UBL_BE_INVOICE_110,
                                            UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_110,
                                            UBLBEValidation.VID_UBL_BE_INVOICE_120,
                                            UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_120,
                                            UBLBEValidation.VID_UBL_BE_INVOICE_123,
                                            UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_123,
                                            UBLBEValidation.VID_UBL_BE_INVOICE_125,
                                            UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_125,
                                            UBLBEValidation.VID_UBL_BE_INVOICE_126,
                                            UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_126,
                                            UBLBEValidation.VID_UBL_BE_INVOICE_127,
                                            UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_127,
                                            UBLBEValidation.VID_UBL_BE_INVOICE_128,
                                            UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_128 })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aESID))
        ret.add (MockFile.createGoodCase (aRes, aESID));

    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final VESID aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    final ICommonsMap <VESID, ICommonsList <IReadableResource>> aMap = new CommonsHashMap <> ();
    final String sPathPrefix = "/test-files/";
    {
      final String sPath = sPathPrefix + "3.0.0/";
      aMap.put (UBLBEValidation.VID_EFFF_INVOICE,
                new CommonsArrayList <> (new ClassPathResource (sPath + "efff_BE0827405743_V01-15000001-1.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001.xml")));

      aMap.put (UBLBEValidation.VID_EFFF_CREDIT_NOTE,
                new CommonsArrayList <> (new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000002.xml")));
    }
    // 1.0.0
    {
      final String sPath = sPathPrefix + "en16931/v1/";
      aMap.put (UBLBEValidation.VID_UBL_BE_INVOICE_100,
                new CommonsArrayList <> (new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000003.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000004.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000005.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000006.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000007.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000008.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000009.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000010.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000012.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000013.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000015.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000016.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000017.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000018.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000019.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000020.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000021.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000022.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000023.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000025.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000026.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000027.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000028.xml")));

      aMap.put (UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_100,
                new CommonsArrayList <> (new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000002.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000024.xml")));
    }
    // 1.1.0
    {
      final String sPath = sPathPrefix + "en16931/v1.1/";
      aMap.put (UBLBEValidation.VID_UBL_BE_INVOICE_110,
                new CommonsArrayList <> (new ClassPathResource (sPath +
                                                                "UBLBE_BE0000000196_V01-15000001 - DocumentStatusCode Converted.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001 - Temporary.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001 Full.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000003.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000004.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000005.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000006.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000007.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000008.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000009.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000010.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000012.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000013.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000015.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000016.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000017.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000018.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000019.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000020.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000021.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000022.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000023.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000025.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000026.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000027.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000028.xml")));

      aMap.put (UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_110,
                new CommonsArrayList <> (new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000002.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000024.xml")));
    }
    // 1.2.0
    {
      final String sPath = sPathPrefix + "en16931/v1.2/";
      aMap.put (UBLBEValidation.VID_UBL_BE_INVOICE_120,
                new CommonsArrayList <> (new ClassPathResource (sPath +
                                                                "UBLBE_BE0000000196_V01-15000001 - DocumentStatusCode Converted.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001 - Temporary.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001 Full.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000003.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000004.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000005.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000006.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000007.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000008.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000009.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000010.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000012.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000013.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000015.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000016.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000017.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000018.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000019.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000020.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000021.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000022.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000023.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000025.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000026.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000027.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000028.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000029.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000030.xml")));

      aMap.put (UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_120,
                new CommonsArrayList <> (new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000002.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000024.xml")));
    }
    // 1.2.3
    {
      final String sPath = sPathPrefix + "en16931/v1.2.3/";
      aMap.put (UBLBEValidation.VID_UBL_BE_INVOICE_123,
                new CommonsArrayList <> (new ClassPathResource (sPath +
                                                                "UBLBE_BE0000000196_V01-15000001 - DocumentStatusCode Converted.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001 Full.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000003.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000004.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000005.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000006.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000007.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000008.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000009.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000010.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000012.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000013.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000015.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000016.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000017.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000018.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000019.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000020.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000021.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000022.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000023.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000025.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000026.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000027.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000028.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000029.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000030.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000031.xml")));

      aMap.put (UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_123,
                new CommonsArrayList <> (new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000002.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000024.xml")));
    }

    // 1.2.5
    {
      final String sPath = sPathPrefix + "en16931/v1.2.5/";
      aMap.put (UBLBEValidation.VID_UBL_BE_INVOICE_125,
                new CommonsArrayList <> (new ClassPathResource (sPath +
                                                                "UBLBE_BE0000000196_V01-15000001 - DocumentStatusCode Converted.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001 Full.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000003.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000004.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000005.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000006.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000007.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000008.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000009.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000010.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000012.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000013.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000015.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000016.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000017.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000018.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000019.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000020.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000021.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000022.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000023.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000025.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000026.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000027.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000028.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000029.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000030.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000031.xml")));

      aMap.put (UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_125,
                new CommonsArrayList <> (new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000002.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000024.xml")));
    }

    // 1.2.6
    {
      final String sPath = sPathPrefix + "en16931/v1.2.6/";
      aMap.put (UBLBEValidation.VID_UBL_BE_INVOICE_126,
                new CommonsArrayList <> (new ClassPathResource (sPath +
                                                                "UBLBE_BE0000000196_V01-15000001 - DocumentStatusCode Converted.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001 Full.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000003.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000004.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000005.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000006.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000008.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000009.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000010.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000012.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000013.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000016.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000017.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000018.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000019.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000020.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000021.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000022.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000023.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000025.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000026.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000027.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000028.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000029.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000030.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000031.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000032.xml")));

      aMap.put (UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_126,
                new CommonsArrayList <> (new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000002.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000024.xml")));
    }

    // 1.2.7
    {
      final String sPath = sPathPrefix + "en16931/v1.2.7/";
      aMap.put (UBLBEValidation.VID_UBL_BE_INVOICE_127,
                new CommonsArrayList <> (new ClassPathResource (sPath +
                                                                "UBLBE_BE0000000196_V01-15000001 - DocumentStatusCode Converted.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001 Full.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000003.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000004.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000005.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000006.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000008.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000009.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000010.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000012.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000013.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000016.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000017.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000018.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000019.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000020.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000021.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000022.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000023.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000025.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000026.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000027.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000028.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000029.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000030.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000031.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000032.xml")));

      aMap.put (UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_127,
                new CommonsArrayList <> (new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000002.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000024.xml")));
    }

    // 1.2.8
    {
      final String sPath = sPathPrefix + "en16931/v1.2.8/";
      aMap.put (UBLBEValidation.VID_UBL_BE_INVOICE_128,
                new CommonsArrayList <> (new ClassPathResource (sPath +
                                                                "UBLBE_BE0000000196_V01-15000001 - DocumentStatusCode Converted.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001 Full.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000001.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000003.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000004.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000005.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000006.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000008.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000009.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000010.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000012.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000013.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000016.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000017.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000018.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000019.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000020.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000021.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000022.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000023.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000025.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000026.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000027.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000028.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000029.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000030.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000031.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000032.xml")));

      aMap.put (UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_128,
                new CommonsArrayList <> (new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000002.xml"),
                                         new ClassPathResource (sPath + "UBLBE_BE0000000196_V01-15000024.xml")));
    }

    final ICommonsList <IReadableResource> ret = aMap.get (aVESID);
    if (ret != null)
      return ret;

    // TODO work around
    if (aVESID.equals (UBLBEValidation.VID_UBL_BE_INVOICE_110) || aVESID.equals (UBLBEValidation.VID_UBL_BE_CREDIT_NOTE_110))
      return new CommonsArrayList <> ();

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
