/**
 * Copyright (C) 2019-2021 Philip Helger (www.helger.com)
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
    for (final VESID aESID : new VESID [] { XRechnungValidation.VID_XRECHNUNG_CII_201,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_201,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_201,

                                            XRechnungValidation.VID_XRECHNUNG_CII_200,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_200,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_200,

                                            XRechnungValidation.VID_XRECHNUNG_CII_122,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_122,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_122,

                                            XRechnungValidation.VID_XRECHNUNG_CII_121,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_121,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_121,

                                            XRechnungValidation.VID_XRECHNUNG_CII_120,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_120,
                                            XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_120 })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aESID))
        ret.add (MockFile.createGoodCase (aRes, aESID));

    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final VESID aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    final ICommonsList <IReadableResource> ret = new CommonsArrayList <> ();
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
        else
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
              else
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
                    else
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
                                                                  "03.02a-INVOICE_ubl.xml",
                                                                  "github40.xml" })
                              ret.add (new ClassPathResource (sPrefix + s));
                          }
                          else
                            if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_CII_201))
                            {
                              final String sPrefix = "/test-files/2.0.1/cii/";
                              for (final String s : new String [] { "cii-br-de-1-test-316-identity.xml",
                                                                    // "cii-br-de-1-test-317-remove.xml",
                                                                    "cii-br-de-10-test-335-identity.xml",
                                                                    // "cii-br-de-10-test-336-remove.xml",
                                                                    "cii-br-de-11-test-286-identity.xml",
                                                                    // "cii-br-de-11-test-287-remove.xml",
                                                                    // "cii-br-de-13-invalid-test-bg-17-bg-18-311-identity.xml",
                                                                    "cii-br-de-13-test-bg-17-291-identity.xml",
                                                                    // "cii-br-de-13-test-bg-17-292-remove.xml",
                                                                    "cii-br-de-13-test-bg-18-302-identity.xml",
                                                                    // "cii-br-de-13-test-bg-18-303-remove.xml",
                                                                    "cii-br-de-14-test-322-identity.xml",
                                                                    // "cii-br-de-14-test-323-remove.xml",
                                                                    "cii-br-de-15-test-282-identity.xml",
                                                                    // "cii-br-de-15-test-283-remove.xml",
                                                                    "cii-br-de-15-test-284-identity.xml",
                                                                    // "cii-br-de-15-test-285-remove.xml",
                                                                    // "cii-br-de-16-negative-tests-br-95-br-151-328-code-Z.xml",
                                                                    // "cii-br-de-16-negative-tests-br-95-br-151-329-code-E.xml",
                                                                    // "cii-br-de-16-negative-tests-br-95-br-151-330-code-AE.xml",
                                                                    // "cii-br-de-16-negative-tests-br-95-br-151-331-code-K.xml",
                                                                    // "cii-br-de-16-negative-tests-br-95-br-151-332-code-G.xml",
                                                                    // "cii-br-de-16-negative-tests-br-95-br-151-333-code-L.xml",
                                                                    // "cii-br-de-16-negative-tests-br-95-br-151-334-code-M.xml",
                                                                    // "cii-br-de-16-tests-br-95-br-151-304-code-Z.xml",
                                                                    // "cii-br-de-16-tests-br-95-br-151-305-code-E.xml",
                                                                    // "cii-br-de-16-tests-br-95-br-151-306-code-AE.xml",
                                                                    // "cii-br-de-16-tests-br-95-br-151-307-code-K.xml",
                                                                    // "cii-br-de-16-tests-br-95-br-151-308-code-G.xml",
                                                                    // "cii-br-de-16-tests-br-95-br-151-309-code-L.xml",
                                                                    // "cii-br-de-16-tests-br-95-br-151-310-code-M.xml",
                                                                    // "cii-br-de-17-tests-339-code-326.xml",
                                                                    // "cii-br-de-17-tests-340-code-380.xml",
                                                                    // "cii-br-de-17-tests-341-code-384.xml",
                                                                    // "cii-br-de-17-tests-342-code-389.xml",
                                                                    // "cii-br-de-17-tests-343-code-381.xml",
                                                                    // "cii-br-de-17-tests-344-code-875.xml",
                                                                    // "cii-br-de-17-tests-345-code-876.xml",
                                                                    // "cii-br-de-17-tests-346-code-877.xml",
                                                                    // "cii-br-de-17-tests-347-code-383.xml",
                                                                    // "cii-br-de-17-tests-348-code-527.xml",
                                                                    "cii-br-de-18-freespace-test-281-identity.xml",
                                                                    // "cii-br-de-18-negative-test-280-identity.xml",
                                                                    // "cii-br-de-18-negative-test-skonto-290-identity.xml",
                                                                    // "cii-br-de-18-negative-test2-321-identity.xml",
                                                                    "cii-br-de-18-test-skonto-318-identity.xml",
                                                                    "cii-br-de-19-iban-tests-295-code-DE-75512108001245126199.xml",
                                                                    "cii-br-de-19-iban-tests-296-code-DE75-51-2108-00124512-6199.xml",
                                                                    "cii-br-de-19-iban-tests-297-code-AS28192373298.xml",
                                                                    "cii-br-de-19-iban-tests-298-code-DE90200400000625894000.xml",
                                                                    "cii-br-de-19-iban-tests-299-code-DE12345678912345678912.xml",
                                                                    "cii-br-de-19-iban-tests-300-code-GB29NWBK60161331926819.xml",
                                                                    "cii-br-de-19-iban-tests-301-empty.xml",
                                                                    "cii-br-de-2-test-314-identity.xml",
                                                                    // "cii-br-de-2-test-315-remove.xml",
                                                                    "cii-br-de-22-check-unique-file-name-test-uncefact-324-identity.xml",
                                                                    // "cii-br-de-22-check-unique-file-name-test-uncefact-325-code-01_15_Anhang_02.pdf.xml",
                                                                    "cii-br-de-3-test-288-identity.xml",
                                                                    // "cii-br-de-3-test-289-remove.xml",
                                                                    "cii-br-de-4-test-337-identity.xml",
                                                                    // "cii-br-de-4-test-338-remove.xml",
                                                                    "cii-br-de-5-test-293-identity.xml",
                                                                    // "cii-br-de-5-test-294-remove.xml",
                                                                    "cii-br-de-5-test2-326-identity.xml",
                                                                    // "cii-br-de-5-test2-327-remove.xml",
                                                                    "cii-br-de-6-test-276-identity.xml",
                                                                    // "cii-br-de-6-test-277-remove.xml",
                                                                    "cii-br-de-7-test-312-identity.xml",
                                                                    // "cii-br-de-7-test-313-remove.xml",
                                                                    "cii-br-de-8-test-278-identity.xml",
                                                                    // "cii-br-de-8-test-279-remove.xml",
                                                                    "cii-br-de-9-test-319-identity.xml",
                                  // "cii-br-de-9-test-320-remove.xml",
                              })
                                ret.add (new ClassPathResource (sPrefix + s));
                            }
                            else
                              if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_CREDITNOTE_201))
                              {
                                final String sPrefix = "/test-files/2.0.1/ubl-cn/";
                                for (final String s : new String [] { // "ubl-cn-br-de-1-test-245-identity.xml",
                                                                      // "ubl-cn-br-de-1-test-246-remove.xml",
                                                                      "ubl-cn-br-de-10-test-219-identity.xml",
                                                                      "ubl-cn-br-de-10-test-220-remove.xml",
                                                                      "ubl-cn-br-de-11-test-243-identity.xml",
                                                                      "ubl-cn-br-de-11-test-244-remove.xml",
                                                                      "ubl-cn-br-de-13-invalid-test-bg-17-bg-18-267-identity.xml",
                                                                      "ubl-cn-br-de-13-invalid-test-bg-17-bg-18-bg-19-209-identity.xml",
                                                                      "ubl-cn-br-de-13-invalid-test-bg-17-bg-19-208-identity.xml",
                                                                      "ubl-cn-br-de-13-invalid-test-bg-18-bg-19-268-identity.xml",
                                                                      "ubl-cn-br-de-13-test-bg-17-227-identity.xml",
                                                                      "ubl-cn-br-de-13-test-bg-17-228-remove.xml",
                                                                      "ubl-cn-br-de-13-test-bg-18-261-identity.xml",
                                                                      "ubl-cn-br-de-13-test-bg-18-262-remove.xml",
                                                                      "ubl-cn-br-de-13-test-bg-19-188-identity.xml",
                                                                      "ubl-cn-br-de-13-test-bg-19-189-remove.xml",
                                                                      "ubl-cn-br-de-14-test-190-identity.xml",
                                                                      "ubl-cn-br-de-14-test-191-remove.xml",
                                                                      "ubl-cn-br-de-15-test-221-identity.xml",
                                                                      "ubl-cn-br-de-15-test-222-remove.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-102-201-code-Z.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-102-202-code-E.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-102-203-code-AE.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-102-204-code-K.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-102-205-code-G.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-102-206-code-L.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-102-207-code-M.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-151-247-code-Z.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-151-248-code-E.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-151-249-code-AE.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-151-250-code-K.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-151-251-code-G.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-151-252-code-L.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-151-253-code-M.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-95-269-code-Z.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-95-270-code-E.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-95-271-code-AE.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-95-272-code-K.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-95-273-code-G.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-95-274-code-L.xml",
                                                                      "ubl-cn-br-de-16-negative-test-bt-95-275-code-M.xml",
                                                                      "ubl-cn-br-de-16-test-bt-102-254-code-Z.xml",
                                                                      "ubl-cn-br-de-16-test-bt-102-255-code-E.xml",
                                                                      "ubl-cn-br-de-16-test-bt-102-256-code-AE.xml",
                                                                      "ubl-cn-br-de-16-test-bt-102-257-code-K.xml",
                                                                      "ubl-cn-br-de-16-test-bt-102-258-code-G.xml",
                                                                      "ubl-cn-br-de-16-test-bt-102-259-code-L.xml",
                                                                      "ubl-cn-br-de-16-test-bt-102-260-code-M.xml",
                                                                      "ubl-cn-br-de-16-test-bt-151-212-code-Z.xml",
                                                                      "ubl-cn-br-de-16-test-bt-151-213-code-E.xml",
                                                                      "ubl-cn-br-de-16-test-bt-151-214-code-AE.xml",
                                                                      "ubl-cn-br-de-16-test-bt-151-215-code-K.xml",
                                                                      "ubl-cn-br-de-16-test-bt-151-216-code-G.xml",
                                                                      "ubl-cn-br-de-16-test-bt-151-217-code-L.xml",
                                                                      "ubl-cn-br-de-16-test-bt-151-218-code-M.xml",
                                                                      "ubl-cn-br-de-16-test-bt-95-194-code-Z.xml",
                                                                      "ubl-cn-br-de-16-test-bt-95-195-code-E.xml",
                                                                      "ubl-cn-br-de-16-test-bt-95-196-code-AE.xml",
                                                                      "ubl-cn-br-de-16-test-bt-95-197-code-K.xml",
                                                                      "ubl-cn-br-de-16-test-bt-95-198-code-G.xml",
                                                                      "ubl-cn-br-de-16-test-bt-95-199-code-L.xml",
                                                                      "ubl-cn-br-de-16-test-bt-95-200-code-M.xml",
                                                                      "ubl-cn-br-de-17-test-233-code-326.xml",
                                                                      "ubl-cn-br-de-17-test-234-code-380.xml",
                                                                      "ubl-cn-br-de-17-test-235-code-384.xml",
                                                                      "ubl-cn-br-de-17-test-236-code-389.xml",
                                                                      "ubl-cn-br-de-17-test-237-code-381.xml",
                                                                      "ubl-cn-br-de-17-test-238-code-875.xml",
                                                                      "ubl-cn-br-de-17-test-239-code-876.xml",
                                                                      "ubl-cn-br-de-17-test-240-code-877.xml",
                                                                      "ubl-cn-br-de-17-test-241-code-383.xml",
                                                                      "ubl-cn-br-de-17-test-242-code-527.xml",
                                                                      "ubl-cn-br-de-2-test-263-identity.xml",
                                                                      "ubl-cn-br-de-2-test-264-remove.xml",
                                                                      "ubl-cn-br-de-3-test-192-identity.xml",
                                                                      "ubl-cn-br-de-3-test-193-remove.xml",
                                                                      "ubl-cn-br-de-4-test-210-identity.xml",
                                                                      "ubl-cn-br-de-4-test-211-remove.xml",
                                                                      "ubl-cn-br-de-5-test-223-identity.xml",
                                                                      "ubl-cn-br-de-5-test-224-remove.xml",
                                                                      "ubl-cn-br-de-6-test-265-identity.xml",
                                                                      "ubl-cn-br-de-6-test-266-remove.xml",
                                                                      "ubl-cn-br-de-7-test-231-identity.xml",
                                                                      "ubl-cn-br-de-7-test-232-remove.xml",
                                                                      "ubl-cn-br-de-8-test-229-identity.xml",
                                                                      "ubl-cn-br-de-8-test-230-remove.xml",
                                                                      "ubl-cn-br-de-9-test-225-identity.xml",
                                                                      "ubl-cn-br-de-9-test-226-remove.xml" })
                                  if (false)
                                    ret.add (new ClassPathResource (sPrefix + s));
                              }
                              else
                                if (aVESID.equals (XRechnungValidation.VID_XRECHNUNG_UBL_INVOICE_201))
                                {
                                  final String sPrefix = "/test-files/2.0.0/ubl-inv/";
                                  for (final String s : new String [] { "ubl-inv-br-de-1-test-113-identity.xml",
                                                                        "ubl-inv-br-de-1-test-114-remove.xml",
                                                                        "ubl-inv-br-de-10-test-59-identity.xml",
                                                                        "ubl-inv-br-de-10-test-60-remove.xml",
                                                                        "ubl-inv-br-de-11-test-83-identity.xml",
                                                                        "ubl-inv-br-de-11-test-84-remove.xml",
                                                                        "ubl-inv-br-de-13-invalid-test-bg-17-bg-18-136-identity.xml",
                                                                        "ubl-inv-br-de-13-invalid-test-bg-17-bg-18-bg-19-112-identity.xml",
                                                                        "ubl-inv-br-de-13-invalid-test-bg-17-bg-19-10-identity.xml",
                                                                        "ubl-inv-br-de-13-invalid-test-bg-18-bg-19-3-identity.xml",
                                                                        "ubl-inv-br-de-13-test-bg-17-57-identity.xml",
                                                                        "ubl-inv-br-de-13-test-bg-17-58-remove.xml",
                                                                        "ubl-inv-br-de-13-test-bg-18-77-identity.xml",
                                                                        "ubl-inv-br-de-13-test-bg-18-78-remove.xml",
                                                                        "ubl-inv-br-de-13-test-bg-19-184-identity.xml",
                                                                        "ubl-inv-br-de-13-test-bg-19-185-remove.xml",
                                                                        "ubl-inv-br-de-14-test-134-identity.xml",
                                                                        "ubl-inv-br-de-14-test-135-remove.xml",
                                                                        "ubl-inv-br-de-15-test-146-identity.xml",
                                                                        "ubl-inv-br-de-15-test-147-remove.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-102-68-code-Z.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-102-69-code-E.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-102-70-code-AE.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-102-71-code-K.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-102-72-code-G.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-102-73-code-L.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-102-74-code-M.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-151-175-code-Z.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-151-176-code-E.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-151-177-code-AE.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-151-178-code-K.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-151-179-code-G.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-151-180-code-L.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-151-181-code-M.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-95-150-code-Z.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-95-151-code-E.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-95-152-code-AE.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-95-153-code-K.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-95-154-code-G.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-95-155-code-L.xml",
                                                                        "ubl-inv-br-de-16-negative-test-bt-95-156-code-M.xml",
                                                                        "ubl-inv-br-de-16-test-bt-102-61-code-Z.xml",
                                                                        "ubl-inv-br-de-16-test-bt-102-62-code-E.xml",
                                                                        "ubl-inv-br-de-16-test-bt-102-63-code-AE.xml",
                                                                        "ubl-inv-br-de-16-test-bt-102-64-code-K.xml",
                                                                        "ubl-inv-br-de-16-test-bt-102-65-code-G.xml",
                                                                        "ubl-inv-br-de-16-test-bt-102-66-code-L.xml",
                                                                        "ubl-inv-br-de-16-test-bt-102-67-code-M.xml",
                                                                        "ubl-inv-br-de-16-test-bt-151-16-code-Z.xml",
                                                                        "ubl-inv-br-de-16-test-bt-151-17-code-E.xml",
                                                                        "ubl-inv-br-de-16-test-bt-151-18-code-AE.xml",
                                                                        "ubl-inv-br-de-16-test-bt-151-19-code-K.xml",
                                                                        "ubl-inv-br-de-16-test-bt-151-20-code-G.xml",
                                                                        "ubl-inv-br-de-16-test-bt-151-21-code-L.xml",
                                                                        "ubl-inv-br-de-16-test-bt-151-22-code-M.xml",
                                                                        "ubl-inv-br-de-16-test-bt-95-46-code-Z.xml",
                                                                        "ubl-inv-br-de-16-test-bt-95-47-code-E.xml",
                                                                        "ubl-inv-br-de-16-test-bt-95-48-code-AE.xml",
                                                                        "ubl-inv-br-de-16-test-bt-95-49-code-K.xml",
                                                                        "ubl-inv-br-de-16-test-bt-95-50-code-G.xml",
                                                                        "ubl-inv-br-de-16-test-bt-95-51-code-L.xml",
                                                                        "ubl-inv-br-de-16-test-bt-95-52-code-M.xml",
                                                                        "ubl-inv-br-de-17-test-102-code-326.xml",
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
                                                                        "ubl-inv-br-de-18-negative-test-82-identity.xml",
                                                                        "ubl-inv-br-de-18-skonto-many-tests-86-identity.xml",
                                                                        "ubl-inv-br-de-18-test-23-identity.xml",
                                                                        "ubl-inv-br-de-18-wrong-skonto-basisbetrag-test-2-85-identity.xml",
                                                                        "ubl-inv-br-de-19-iban-tests-137-identity.xml",
                                                                        "ubl-inv-br-de-19-iban-tests-138-code-DE90200400000625899000.xml",
                                                                        "ubl-inv-br-de-19-iban-tests-139-code-AS28192373298.xml",
                                                                        "ubl-inv-br-de-19-iban-tests-140-code-DE90200400000625894000.xml",
                                                                        "ubl-inv-br-de-19-iban-tests-141-code-DE12345678912345678912.xml",
                                                                        "ubl-inv-br-de-19-iban-tests-142-code-DE90200400000625894000.xml",
                                                                        "ubl-inv-br-de-19-iban-tests-143-code-DE-75512108001245126199.xml",
                                                                        "ubl-inv-br-de-19-iban-tests-144-code-DE75-51-2108-00124512-6199.xml",
                                                                        "ubl-inv-br-de-19-iban-tests-145-code-GB29NWBK60161331926819.xml",
                                                                        "ubl-inv-br-de-2-test-186-identity.xml",
                                                                        "ubl-inv-br-de-2-test-187-remove.xml",
                                                                        "ubl-inv-br-de-20-paymentmeans-code59-test-53-identity.xml",
                                                                        "ubl-inv-br-de-20-paymentmeans-code59-test-54-code-urn_cen.eu_en16931_2017_compliant_urn_xoev-de_kosit_standard_xrechnung_2.0_conformant_urn_xoev-de_kosit_extension_xrechnung_2.0.xml",
                                                                        "ubl-inv-br-de-20-paymentmeans-code59-test-55-identity.xml",
                                                                        "ubl-inv-br-de-20-paymentmeans-code59-test-56-remove.xml",
                                                                        "ubl-inv-br-de-21-check-unique-file-name-test-100-identity.xml",
                                                                        "ubl-inv-br-de-21-check-unique-file-name-test-101-code-01_15_Anhang_02.pdf.xml",
                                                                        "ubl-inv-br-de-21-check-unique-file-name-test-99-identity.xml",
                                                                        "ubl-inv-br-de-21-extension_mime_code_test-87-identity.xml",
                                                                        "ubl-inv-br-de-21-extension_mime_code_test-88-code-invalid_customizationid.xml",
                                                                        "ubl-inv-br-de-21-extension_mime_code_test-89-empty.xml",
                                                                        "ubl-inv-br-de-21-extension_mime_code_test-90-remove.xml",
                                                                        "ubl-inv-br-de-21-extension_mime_code_test-91-code-application_xml.xml",
                                                                        "ubl-inv-br-de-21-extension_mime_code_test-92-code-application_pdf.xml",
                                                                        "ubl-inv-br-de-21-extension_mime_code_test-93-code-image_png.xml",
                                                                        "ubl-inv-br-de-21-extension_mime_code_test-94-code-image_jpeg.xml",
                                                                        "ubl-inv-br-de-21-extension_mime_code_test-95-code-text_csv.xml",
                                                                        "ubl-inv-br-de-21-extension_mime_code_test-96-code-application_vnd.openxmlformats-officedocument.spreadsheetml.sheet.xml",
                                                                        "ubl-inv-br-de-21-extension_mime_code_test-97-code-application_nonsense.xml",
                                                                        "ubl-inv-br-de-21-extension_mime_code_test-98-empty.xml",
                                                                        "ubl-inv-br-de-3-test-75-identity.xml",
                                                                        "ubl-inv-br-de-3-test-76-remove.xml",
                                                                        "ubl-inv-br-de-4-test-148-identity.xml",
                                                                        "ubl-inv-br-de-4-test-149-remove.xml",
                                                                        "ubl-inv-br-de-5-test-170-identity.xml",
                                                                        "ubl-inv-br-de-5-test-171-remove.xml",
                                                                        "ubl-inv-br-de-6-test-172-identity.xml",
                                                                        "ubl-inv-br-de-6-test-173-remove.xml",
                                                                        "ubl-inv-br-de-7-test-1-identity.xml",
                                                                        "ubl-inv-br-de-7-test-2-remove.xml",
                                                                        "ubl-inv-br-de-8-test-79-identity.xml",
                                                                        "ubl-inv-br-de-8-test-80-remove.xml",
                                                                        "ubl-inv-br-de-9-test-182-identity.xml",
                                                                        "ubl-inv-br-de-9-test-183-remove.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-11-identity.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-12-identity.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-13-code-22.00.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-14-code-2.00.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-15-code-12.34.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-157-identity.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-158-identity.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-159-code-333.79.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-160-code-190.20.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-161-code-51.25.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-162-code-95.22.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-163-code-382.25.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-164-code-99.74.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-165-code-333.50.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-166-identity.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-167-code-4321.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-168-code-600.xml",
                                                                        "ubl-inv-br-dex-02-check-correct-sums-sub-invoice-line-2-169-code-333.79.xml",
                                                                        "ubl-inv-br-dex-02-some-invoicelines-with-sub-174-identity.xml",
                                                                        "ubl-inv-br-dex-03-invalid-test-131-identity.xml",
                                                                        "ubl-inv-br-dex-03-invalid-test-132-identity.xml",
                                                                        "ubl-inv-br-dex-03-invalid-test-133-identity.xml",
                                                                        "ubl-inv-br-dex-03-test-4-identity.xml",
                                                                        "ubl-inv-br-dex-03-test-5-remove.xml",
                                                                        "ubl-inv-br-dex-03-test-6-identity.xml",
                                                                        "ubl-inv-br-dex-03-test-7-remove.xml",
                                                                        "ubl-inv-br-dex-03-test-8-identity.xml",
                                                                        "ubl-inv-br-dex-03-test-9-remove.xml",
                                                                        "ubl-inv-contact-tests-24-identity.xml",
                                                                        "ubl-inv-contact-tests-25-remove.xml",
                                                                        "ubl-inv-contact-tests-26-remove.xml",
                                                                        "ubl-inv-contact-tests-27-empty.xml",
                                                                        "ubl-inv-contact-tests-28-remove.xml",
                                                                        "ubl-inv-contact-tests-29-empty.xml",
                                                                        "ubl-inv-contact-tests-30-remove.xml",
                                                                        "ubl-inv-contact-tests-31-remove.xml",
                                                                        "ubl-inv-contact-tests-32-empty.xml",
                                                                        "ubl-inv-contact-tests-33-remove.xml",
                                                                        "ubl-inv-contact-tests-34-empty.xml",
                                                                        "ubl-inv-contact-tests-35-remove.xml",
                                                                        "ubl-inv-contact-tests-36-empty.xml",
                                                                        "ubl-inv-contact-tests-37-remove.xml",
                                                                        "ubl-inv-contact-tests-38-empty.xml",
                                                                        "ubl-inv-contact-tests-39-remove.xml",
                                                                        "ubl-inv-contact-tests-40-empty.xml",
                                                                        "ubl-inv-contact-tests-41-remove.xml",
                                                                        "ubl-inv-contact-tests-42-remove.xml",
                                                                        "ubl-inv-contact-tests-43-empty.xml",
                                                                        "ubl-inv-contact-tests-44-remove.xml",
                                                                        "ubl-inv-contact-tests-45-empty.xml",
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
                                                                        "ubl-inv-paymentmeans-test-128-remove.xml",
                                                                        "ubl-inv-paymentmeans-test-129-code-58.xml",
                                                                        "ubl-inv-paymentmeans-test-130-code-sdsfsadgfa.xml" })
                                    if (false)
                                      ret.add (new ClassPathResource (sPrefix + s));
                                }
                                else
                                  throw new IllegalArgumentException ("Invalid VESID: " + aVESID);

    return ret;
  }
}
