/*
 * Copyright (C) 2019-2022 Philip Helger (www.helger.com)
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
package com.helger.phive.xrechnung.mock;

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
import com.helger.phive.xrechnung.XRechnungValidation;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    EN16931Validation.initEN16931 (VES_REGISTRY);
    XRechnungValidation.initXRechnung (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <MockFile> getAllTestFiles ()
  {
    final ICommonsList <MockFile> ret = new CommonsArrayList <> ();
    for (final VESID aESID : new VESID [] { XRechnungValidation.VID_XRECHNUNG_CII_220,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_220,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_220,

                                            XRechnungValidation.VID_XRECHNUNG_CII_120,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_120,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_120,

                                            XRechnungValidation.VID_XRECHNUNG_CII_121,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_121,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_121,

                                            XRechnungValidation.VID_XRECHNUNG_CII_122,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_122,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_122,

                                            XRechnungValidation.VID_XRECHNUNG_CII_200,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_200,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_200,

                                            XRechnungValidation.VID_XRECHNUNG_CII_201,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_201,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_201,

                                            XRechnungValidation.VID_XRECHNUNG_CII_211,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_211,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_211, })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (MockFile.createGoodCase (aRes, aESID));
      }
    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final VESID aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    final ICommonsList <IReadableResource> ret = new CommonsArrayList <> ();

    // 1.2.0
    if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_CII_120))
    {
      final String sPrefix = "/test-files/1.2.0/cii/";
      for (final String s : new String [] { "CII_business_example_01.xml",
                                            "CII_business_example_02.xml",
                                            "CII_example1.xml",
                                            "CII_example2.xml",
                                            "CII_example3.xml",
                                            "CII_example4.xml",
                                            "CII_example5.xml",
                                            "CII_example6.xml",
                                            // "CII_example7.xml",
                                            "CII_example8.xml",
                                            "CII_example9.xml" })
        ret.add (new ClassPathResource (sPrefix + s));
    }
    else
      if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_120))
      {
        // None atm
      }
      else
        if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_120))
        {
          final String sPrefix = "/test-files/1.2.0/ubl/";
          for (final String s : new String [] { "ubl-tc434-example1.xml",
                                                "ubl-tc434-example2.xml",
                                                "ubl-tc434-example3.xml",
                                                "ubl-tc434-example4.xml",
                                                "ubl-tc434-example5.xml",
                                                "ubl-tc434-example6.xml",
                                                // "ubl-tc434-example7.xml",
                                                "ubl-tc434-example8.xml",
                                                "ubl-tc434-example9.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }

    // 1.2.1
    if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_CII_121))
    {
      final String sPrefix = "/test-files/1.2.1/cii/";
      for (final String s : new String [] { "CII_business_example_01.xml",
                                            "CII_business_example_02.xml",
                                            "CII_example1.xml",
                                            "CII_example2.xml",
                                            "CII_example3.xml",
                                            "CII_example4.xml",
                                            "CII_example5.xml",
                                            "CII_example6.xml",
                                            // "CII_example7.xml",
                                            "CII_example8.xml",
                                            "CII_example9.xml" })
        ret.add (new ClassPathResource (sPrefix + s));
    }
    else
      if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_121))
      {
        // None atm
      }
      else
        if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_121))
        {
          final String sPrefix = "/test-files/1.2.1/ubl/";
          for (final String s : new String [] { "ubl-tc434-example1.xml",
                                                "ubl-tc434-example2.xml",
                                                "ubl-tc434-example3.xml",
                                                "ubl-tc434-example4.xml",
                                                "ubl-tc434-example5.xml",
                                                "ubl-tc434-example6.xml",
                                                // "ubl-tc434-example7.xml",
                                                "ubl-tc434-example8.xml",
                                                "ubl-tc434-example9.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }

    // 1.2.2
    if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_CII_122))
    {
      final String sPrefix = "/test-files/1.2.2/cii/";
      for (final String s : new String [] { "01.01a-INVOICE_uncefact.xml",
                                            "01.02a-INVOICE_uncefact.xml",
                                            "01.03a-INVOICE_uncefact.xml",
                                            "01.04a-INVOICE_uncefact.xml",
                                            "01.05a-INVOICE_uncefact.xml",
                                            "01.06a-INVOICE_uncefact.xml",
                                            "01.07a-INVOICE_uncefact.xml",
                                            "01.08a-INVOICE_uncefact.xml",
                                            "01.09a-INVOICE_uncefact.xml",
                                            "01.10a-INVOICE_uncefact.xml",
                                            "01.11a-INVOICE_uncefact.xml",
                                            "01.12a-INVOICE_uncefact.xml",
                                            "01.13a-INVOICE_uncefact.xml",
                                            "01.14a-INVOICE_uncefact.xml",
                                            "01.15a-INVOICE_uncefact.xml",
                                            "02.01a-INVOICE_uncefact.xml",
                                            "02.02a-INVOICE_uncefact.xml",
                                            "03.01a-INVOICE_uncefact.xml",
                                            "03.02a-INVOICE_uncefact.xml" })
        ret.add (new ClassPathResource (sPrefix + s));
    }
    else
      if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_122))
      {
        // None atm
      }
      else
        if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_122))
        {
          final String sPrefix = "/test-files/1.2.2/ubl/";
          for (final String s : new String [] { "01.01a-INVOICE_ubl.xml",
                                                "01.02a-INVOICE_ubl.xml",
                                                "01.03a-INVOICE_ubl.xml",
                                                "01.04a-INVOICE_ubl.xml",
                                                "01.05a-INVOICE_ubl.xml",
                                                "01.06a-INVOICE_ubl.xml",
                                                "01.07a-INVOICE_ubl.xml",
                                                "01.08a-INVOICE_ubl.xml",
                                                "01.09a-INVOICE_ubl.xml",
                                                "01.10a-INVOICE_ubl.xml",
                                                "01.11a-INVOICE_ubl.xml",
                                                "01.12a-INVOICE_ubl.xml",
                                                "01.13a-INVOICE_ubl.xml",
                                                "01.14a-INVOICE_ubl.xml",
                                                "01.15a-INVOICE_ubl.xml",
                                                "02.01a-INVOICE_ubl.xml",
                                                "02.02a-INVOICE_ubl.xml",
                                                "03.01a-INVOICE_ubl.xml",
                                                "03.02a-INVOICE_ubl.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }

    // 2.0.0
    if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_CII_200))
    {
      final String sPrefix = "/test-files/2.0.0/cii/";
      for (final String s : new String [] { "01.01a-INVOICE_uncefact.xml",
                                            "01.02a-INVOICE_uncefact.xml",
                                            "01.03a-INVOICE_uncefact.xml",
                                            "01.04a-INVOICE_uncefact.xml",
                                            "01.05a-INVOICE_uncefact.xml",
                                            "01.06a-INVOICE_uncefact.xml",
                                            "01.07a-INVOICE_uncefact.xml",
                                            "01.08a-INVOICE_uncefact.xml",
                                            "01.09a-INVOICE_uncefact.xml",
                                            "01.10a-INVOICE_uncefact.xml",
                                            "01.11a-INVOICE_uncefact.xml",
                                            "01.12a-INVOICE_uncefact.xml",
                                            "01.13a-INVOICE_uncefact.xml",
                                            "01.14a-INVOICE_uncefact.xml",
                                            "01.15a-INVOICE_uncefact.xml",
                                            "02.01a-INVOICE_uncefact.xml",
                                            "02.02a-INVOICE_uncefact.xml",
                                            "03.01a-INVOICE_uncefact.xml",
                                            "03.02a-INVOICE_uncefact.xml" })
        ret.add (new ClassPathResource (sPrefix + s));
    }
    else
      if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_200))
      {
        // None atm
      }
      else
        if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_200))
        {
          final String sPrefix = "/test-files/2.0.0/ubl/";
          for (final String s : new String [] { "00.04_all_fields_ubl.xml",
                                                "01.01a-INVOICE_ubl.xml",
                                                "01.02a-INVOICE_ubl.xml",
                                                "01.03a-INVOICE_ubl.xml",
                                                "01.04a-INVOICE_ubl.xml",
                                                "01.05a-INVOICE_ubl.xml",
                                                "01.06a-INVOICE_ubl.xml",
                                                "01.07a-INVOICE_ubl.xml",
                                                "01.08a-INVOICE_ubl.xml",
                                                "01.09a-INVOICE_ubl.xml",
                                                "01.10a-INVOICE_ubl.xml",
                                                "01.11a-INVOICE_ubl.xml",
                                                "01.12a-INVOICE_ubl.xml",
                                                "01.13a-INVOICE_ubl.xml",
                                                "01.14a-INVOICE_ubl.xml",
                                                "01.15a-INVOICE_ubl.xml",
                                                "02.01a-INVOICE_ubl.xml",
                                                "02.02a-INVOICE_ubl.xml",
                                                "03.01a-INVOICE_ubl.xml",
                                                "03.02a-INVOICE_ubl.xml",
                                                "github40.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }

    // 2.0.1
    if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_CII_201))
    {
      final String sPrefix = "/test-files/2.0.1/cii/";
      for (final String s : new String [] { "cii-br-de-10-test-335-identity.xml",
                                            "cii-br-de-11-test-286-identity.xml",
                                            "cii-br-de-13-test-bg-17-291-identity.xml",
                                            "cii-br-de-13-test-bg-18-302-identity.xml",
                                            "cii-br-de-14-test-322-identity.xml",
                                            "cii-br-de-15-test-282-identity.xml",
                                            "cii-br-de-15-test-284-identity.xml",
                                            "cii-br-de-18-freespace-test-281-identity.xml",
                                            "cii-br-de-18-test-skonto-318-identity.xml",
                                            "cii-br-de-19-iban-tests-295-code-DE-75512108001245126199.xml",
                                            "cii-br-de-19-iban-tests-296-code-DE75-51-2108-00124512-6199.xml",
                                            "cii-br-de-19-iban-tests-297-code-AS28192373298.xml",
                                            "cii-br-de-19-iban-tests-298-code-DE90200400000625894000.xml",
                                            "cii-br-de-19-iban-tests-299-code-DE12345678912345678912.xml",
                                            "cii-br-de-19-iban-tests-300-code-GB29NWBK60161331926819.xml",
                                            "cii-br-de-19-iban-tests-301-empty.xml",
                                            "cii-br-de-1-test-316-identity.xml",
                                            "cii-br-de-22-check-unique-file-name-test-uncefact-324-identity.xml",
                                            "cii-br-de-2-test-314-identity.xml",
                                            "cii-br-de-3-test-288-identity.xml",
                                            "cii-br-de-4-test-337-identity.xml",
                                            "cii-br-de-5-test2-326-identity.xml",
                                            "cii-br-de-5-test-293-identity.xml",
                                            "cii-br-de-6-test-276-identity.xml",
                                            "cii-br-de-7-test-312-identity.xml",
                                            "cii-br-de-8-test-278-identity.xml",
                                            "cii-br-de-9-test-319-identity.xml" })
        ret.add (new ClassPathResource (sPrefix + s));
    }
    else
      if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_201))
      {
        final String sPrefix = "/test-files/2.0.1/ubl-cn/";
        for (final String s : new String [] {})
          ret.add (new ClassPathResource (sPrefix + s));
      }
      else
        if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_201))
        {
          final String sPrefix = "/test-files/2.0.1/ubl-inv/";
          for (final String s : new String [] { "ubl-inv-br-de-17-test-102-code-326.xml",
                                                "ubl-inv-br-de-17-test-103-code-380.xml",
                                                "ubl-inv-br-de-17-test-104-code-384.xml",
                                                "ubl-inv-br-de-17-test-105-code-389.xml",
                                                "ubl-inv-br-de-17-test-106-code-381.xml",
                                                "ubl-inv-br-de-17-test-107-code-875.xml",
                                                "ubl-inv-br-de-17-test-108-code-876.xml",
                                                "ubl-inv-br-de-17-test-109-code-877.xml",
                                                "ubl-inv-br-de-17-test-110-code-383.xml",
                                                "ubl-inv-br-de-17-test-111-code-527.xml",
                                                "ubl-inv-br-de-18-freespace-test-81-identity.xml",
                                                "ubl-inv-br-de-18-skonto-many-tests-86-identity.xml",
                                                "ubl-inv-br-de-18-test-23-identity.xml",
                                                "ubl-inv-br-de-19-iban-tests-137-identity.xml",
                                                "ubl-inv-br-de-19-iban-tests-138-code-DE90200400000625899000.xml",
                                                "ubl-inv-br-de-19-iban-tests-139-code-AS28192373298.xml",
                                                "ubl-inv-br-de-19-iban-tests-140-code-DE90200400000625894000.xml",
                                                "ubl-inv-br-de-19-iban-tests-141-code-DE12345678912345678912.xml",
                                                "ubl-inv-br-de-19-iban-tests-142-code-DE90200400000625894000.xml",
                                                "ubl-inv-br-de-19-iban-tests-143-code-DE-75512108001245126199.xml",
                                                "ubl-inv-br-de-19-iban-tests-144-code-DE75-51-2108-00124512-6199.xml",
                                                "ubl-inv-br-de-19-iban-tests-145-code-GB29NWBK60161331926819.xml",
                                                "ubl-inv-br-de-20-paymentmeans-code59-test-56-remove.xml",
                                                "ubl-inv-br-de-21-check-unique-file-name-test-100-identity.xml",
                                                "ubl-inv-br-de-21-check-unique-file-name-test-99-identity.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-87-identity.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-90-remove.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-91-code-application_xml.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-92-code-application_pdf.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-93-code-image_png.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-94-code-image_jpeg.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-95-code-text_csv.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-96-code-application_vnd.openxmlformats-officedocument.spreadsheetml.sheet.xml",
                                                "ubl-inv-br-dex-02-some-invoicelines-with-sub-174-identity.xml",
                                                "ubl-inv-paymentmeans-test-115-identity.xml",
                                                "ubl-inv-paymentmeans-test-116-code-326.xml",
                                                "ubl-inv-paymentmeans-test-117-code-380.xml",
                                                "ubl-inv-paymentmeans-test-118-code-384.xml",
                                                "ubl-inv-paymentmeans-test-119-code-389.xml",
                                                "ubl-inv-paymentmeans-test-120-code-381.xml",
                                                "ubl-inv-paymentmeans-test-121-code-875.xml",
                                                "ubl-inv-paymentmeans-test-122-code-876.xml",
                                                "ubl-inv-paymentmeans-test-123-code-877.xml",
                                                "ubl-inv-paymentmeans-test-124-code-123.xml",
                                                "ubl-inv-paymentmeans-test-125-code-0.xml",
                                                "ubl-inv-paymentmeans-test-126-code-1000.xml",
                                                "ubl-inv-paymentmeans-test-127-identity.xml",
                                                "ubl-inv-paymentmeans-test-129-code-58.xml",
                                                "ubl-inv-paymentmeans-test-130-code-sdsfsadgfa.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }

    // 2.1.1
    if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_CII_211))
    {
      final String sPrefix = "/test-files/2.1.1/cii/";
      for (final String s : new String [] { "cii-br-de-1-test-356-identity.xml",
                                            "cii-br-de-10-test-386-identity.xml",
                                            "cii-br-de-11-test-322-identity.xml",
                                            "cii-br-de-14-test-364-identity.xml",
                                            "cii-br-de-15-test-316-identity.xml",
                                            "cii-br-de-15-test-318-identity.xml",
                                            "cii-br-de-17-tests-391-code-326.xml",
                                            "cii-br-de-17-tests-392-code-380.xml",
                                            "cii-br-de-17-tests-393-code-384.xml",
                                            "cii-br-de-17-tests-394-code-389.xml",
                                            "cii-br-de-17-tests-395-code-381.xml",
                                            "cii-br-de-17-tests-396-code-875.xml",
                                            "cii-br-de-17-tests-397-code-876.xml",
                                            "cii-br-de-17-tests-398-code-877.xml",
                                            "cii-br-de-17-tests-399-code-383.xml",
                                            "cii-br-de-17-tests-400-code-527.xml",
                                            "cii-br-de-18-freespace-test-315-identity.xml",
                                            "cii-br-de-18-test-skonto-358-identity.xml",
                                            "cii-br-de-19-iban-tests-333-code-DE-75512108001245126199.xml",
                                            "cii-br-de-19-iban-tests-334-code-DE75-51-2108-00124512-6199.xml",
                                            "cii-br-de-19-iban-tests-335-code-AS28192373298.xml",
                                            "cii-br-de-19-iban-tests-336-code-DE90200400000625894000.xml",
                                            "cii-br-de-19-iban-tests-337-code-DE12345678912345678912.xml",
                                            "cii-br-de-19-iban-tests-338-code-GB29NWBK60161331926819.xml",
                                            "cii-br-de-19-iban-tests-339-empty.xml",
                                            "cii-br-de-2-test-354-identity.xml",
                                            "cii-br-de-22-check-unique-file-name-test-uncefact-366-identity.xml",
                                            "cii-br-de-23-test-bg-17-411-code-30.xml",
                                            "cii-br-de-23-test-bg-17-412-code-58.xml",
                                            "cii-br-de-23-test-bg-17-413-identity.xml",
                                            "cii-br-de-24-test-bg-18-380-code-48.xml",
                                            "cii-br-de-24-test-bg-18-381-code-54.xml",
                                            "cii-br-de-24-test-bg-18-382-code-55.xml",
                                            "cii-br-de-24-test-bg-18-383-identity.xml",
                                            "cii-br-de-25-test-bg-19-404-identity.xml",
                                            "cii-br-de-25-test-bg-19-405-identity.xml",
                                            "cii-br-de-25-test-bg-19-406-identity.xml",
                                            "cii-br-de-25-test-bg-19-407-identity.xml",
                                            "cii-br-de-26-test-311-identity.xml",
                                            "cii-br-de-26-test-312-remove.xml",
                                            "cii-br-de-3-test-324-identity.xml",
                                            "cii-br-de-4-test-388-identity.xml",
                                            "cii-br-de-5-test-331-identity.xml",
                                            "cii-br-de-5-test2-368-identity.xml",
                                            "cii-br-de-6-test-306-identity.xml",
                                            "cii-br-de-7-test-352-identity.xml",
                                            "cii-br-de-8-test-309-identity.xml",
                                            "cii-br-de-9-test-359-identity.xml" })
        ret.add (new ClassPathResource (sPrefix + s));
    }
    else
      if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_211))
      {
        final String sPrefix = "/test-files/2.1.1/ubl-cn/";
        for (final String s : new String [] { "ubl-cn-br-de-1-test-269-identity.xml",
                                              "ubl-cn-br-de-10-test-239-identity.xml",
                                              "ubl-cn-br-de-11-test-267-identity.xml",
                                              "ubl-cn-br-de-14-test-210-identity.xml",
                                              "ubl-cn-br-de-15-test-242-identity.xml",
                                              "ubl-cn-br-de-17-test-257-code-326.xml",
                                              "ubl-cn-br-de-17-test-258-code-380.xml",
                                              "ubl-cn-br-de-17-test-259-code-384.xml",
                                              "ubl-cn-br-de-17-test-260-code-389.xml",
                                              "ubl-cn-br-de-17-test-261-code-381.xml",
                                              "ubl-cn-br-de-17-test-262-code-875.xml",
                                              "ubl-cn-br-de-17-test-263-code-876.xml",
                                              "ubl-cn-br-de-17-test-264-code-877.xml",
                                              "ubl-cn-br-de-17-test-265-code-383.xml",
                                              "ubl-cn-br-de-17-test-266-code-527.xml",
                                              "ubl-cn-br-de-2-test-290-identity.xml",
                                              "ubl-cn-br-de-23-test-bg-17-295-code-30.xml",
                                              "ubl-cn-br-de-23-test-bg-17-296-code-58.xml",
                                              "ubl-cn-br-de-23-test-bg-17-297-identity.xml",
                                              "ubl-cn-br-de-24-test-bg-18-271-code-48.xml",
                                              "ubl-cn-br-de-24-test-bg-18-272-code-54.xml",
                                              "ubl-cn-br-de-24-test-bg-18-273-code-55.xml",
                                              "ubl-cn-br-de-24-test-bg-18-274-identity.xml",
                                              "ubl-cn-br-de-25-test-bg-19-249-identity.xml",
                                              "ubl-cn-br-de-25-test-bg-19-250-identity.xml",
                                              "ubl-cn-br-de-3-test-212-identity.xml",
                                              "ubl-cn-br-de-4-test-228-identity.xml",
                                              "ubl-cn-br-de-5-test-244-identity.xml",
                                              "ubl-cn-br-de-6-test-293-identity.xml",
                                              "ubl-cn-br-de-7-test-255-identity.xml",
                                              "ubl-cn-br-de-8-test-253-identity.xml",
                                              "ubl-cn-br-de-9-test-247-identity.xml" })
          ret.add (new ClassPathResource (sPrefix + s));
      }
      else
        if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_211))
        {
          final String sPrefix = "/test-files/2.1.1/ubl-inv/";
          for (final String s : new String [] { "ubl-inv-br-de-1-test-131-identity.xml",
                                                "ubl-inv-br-de-10-test-65-identity.xml",
                                                "ubl-inv-br-de-11-test-95-identity.xml",
                                                "ubl-inv-br-de-14-test-154-identity.xml",
                                                "ubl-inv-br-de-15-test-166-identity.xml",
                                                "ubl-inv-br-de-17-test-121-code-326.xml",
                                                "ubl-inv-br-de-17-test-122-code-380.xml",
                                                "ubl-inv-br-de-17-test-123-code-384.xml",
                                                "ubl-inv-br-de-17-test-124-code-389.xml",
                                                "ubl-inv-br-de-17-test-125-code-381.xml",
                                                "ubl-inv-br-de-17-test-126-code-875.xml",
                                                "ubl-inv-br-de-17-test-127-code-876.xml",
                                                "ubl-inv-br-de-17-test-128-code-877.xml",
                                                "ubl-inv-br-de-17-test-129-code-383.xml",
                                                "ubl-inv-br-de-17-test-130-code-527.xml",
                                                "ubl-inv-br-de-18-freespace-test-92-identity.xml",
                                                "ubl-inv-br-de-18-skonto-many-tests-103-identity.xml",
                                                "ubl-inv-br-de-18-test-31-identity.xml",
                                                "ubl-inv-br-de-2-test-207-identity.xml",
                                                "ubl-inv-br-de-21-check-unique-file-name-test-118-identity.xml",
                                                "ubl-inv-br-de-21-check-unique-file-name-test-119-identity.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-104-identity.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-105-code-invalid_customizationid.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-107-remove.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-108-code-application_xml.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-109-code-application_pdf.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-110-code-image_png.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-111-code-image_jpeg.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-112-code-text_csv.xml",
                                                "ubl-inv-br-de-21-extension_mime_code_test-113-code-application_vnd.openxmlformats-officedocument.spreadsheetml.sheet.xml",
                                                "ubl-inv-br-de-23-test-bg-17-100-code-58.xml",
                                                "ubl-inv-br-de-23-test-bg-17-101-identity.xml",
                                                "ubl-inv-br-de-23-test-bg-17-99-code-30.xml",
                                                "ubl-inv-br-de-24-test-bg-18-84-code-48.xml",
                                                "ubl-inv-br-de-24-test-bg-18-85-code-54.xml",
                                                "ubl-inv-br-de-24-test-bg-18-86-code-55.xml",
                                                "ubl-inv-br-de-24-test-bg-18-87-identity.xml",
                                                "ubl-inv-br-de-25-test-bg-19-7-identity.xml",
                                                "ubl-inv-br-de-25-test-bg-19-8-identity.xml",
                                                "ubl-inv-br-de-26-test-93-identity.xml",
                                                "ubl-inv-br-de-3-test-82-identity.xml",
                                                "ubl-inv-br-de-4-test-168-identity.xml",
                                                "ubl-inv-br-de-5-test-191-identity.xml",
                                                "ubl-inv-br-de-6-test-193-identity.xml",
                                                "ubl-inv-br-de-7-test-1-identity.xml",
                                                "ubl-inv-br-de-8-test-89-identity.xml",
                                                "ubl-inv-br-de-9-test-203-identity.xml",
                                                "ubl-inv-br-dex-02-some-invoicelines-with-sub-195-identity.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }

    // 2.2.0
    if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_CII_220))
    {
      final String sPrefix = "/test-files/2.2.0/cii/";
      for (final String s : new String [] { "01.01a-INVOICE_uncefact.xml",
                                            "01.02a-INVOICE_uncefact.xml",
                                            "01.03a-INVOICE_uncefact.xml",
                                            "01.04a-INVOICE_uncefact.xml",
                                            "01.05a-INVOICE_uncefact.xml",
                                            "01.06a-INVOICE_uncefact.xml",
                                            "01.07a-INVOICE_uncefact.xml",
                                            "01.08a-INVOICE_uncefact.xml",
                                            "01.09a-INVOICE_uncefact.xml",
                                            "01.10a-INVOICE_uncefact.xml",
                                            "01.11a-INVOICE_uncefact.xml",
                                            "01.12a-INVOICE_uncefact.xml",
                                            "01.13a-INVOICE_uncefact.xml",
                                            "01.14a-INVOICE_uncefact.xml",
                                            "01.15a-INVOICE_uncefact.xml",
                                            "01.17a-INVOICE_uncefact.xml",
                                            "01.18a-INVOICE_uncefact.xml",
                                            "01.19a-INVOICE_uncefact.xml",
                                            "01.20a-INVOICE_uncefact.xml",
                                            "01.21a-INVOICE_uncefact.xml",
                                            "02.01a-INVOICE_uncefact.xml",
                                            "02.02a-INVOICE_uncefact.xml",
                                            "02.03a-INVOICE_uncefact.xml",
                                            "02.04a-INVOICE_uncefact.xml",
                                            "02.05a-INVOICE_uncefact.xml",
                                            "02.06a-INVOICE_uncefact.xml",
                                            "03.01a-INVOICE_uncefact.xml",
                                            "03.02a-INVOICE_uncefact.xml",
                                            "03.03a-INVOICE_uncefact.xml",
                                            "03.04a-INVOICE_uncefact.xml",
                                            "03.05a-INVOICE_uncefact.xml",
                                            "03.06a-INVOICE_uncefact.xml" })
        ret.add (new ClassPathResource (sPrefix + s));
    }
    else
      if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_220))
      {
        // None atm
      }
      else
        if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_220))
        {
          final String sPrefix = "/test-files/2.2.0/ubl-inv/";
          for (final String s : new String [] { "01.01a-INVOICE_ubl.xml",
                                                "01.02a-INVOICE_ubl.xml",
                                                "01.03a-INVOICE_ubl.xml",
                                                "01.04a-INVOICE_ubl.xml",
                                                "01.05a-INVOICE_ubl.xml",
                                                "01.06a-INVOICE_ubl.xml",
                                                "01.07a-INVOICE_ubl.xml",
                                                "01.08a-INVOICE_ubl.xml",
                                                "01.09a-INVOICE_ubl.xml",
                                                "01.10a-INVOICE_ubl.xml",
                                                "01.11a-INVOICE_ubl.xml",
                                                "01.12a-INVOICE_ubl.xml",
                                                "01.13a-INVOICE_ubl.xml",
                                                "01.14a-INVOICE_ubl.xml",
                                                "01.17a-INVOICE_ubl.xml",
                                                "01.18a-INVOICE_ubl.xml",
                                                "01.19a-INVOICE_ubl.xml",
                                                "01.20a-INVOICE_ubl.xml",
                                                "01.21a-INVOICE_ubl.xml",
                                                "02.01a-INVOICE_ubl.xml",
                                                "02.02a-INVOICE_ubl.xml",
                                                "03.01a-INVOICE_ubl.xml",
                                                "03.02a-INVOICE_ubl.xml",
                                                "03.06a-INVOICE_ubl.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }

    return ret;
  }
}
