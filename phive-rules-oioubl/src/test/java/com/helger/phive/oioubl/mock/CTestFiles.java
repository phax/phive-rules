/*
 * Copyright (C) 2018-2022 Philip Helger (www.helger.com)
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
package com.helger.phive.oioubl.mock;

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
import com.helger.phive.engine.mock.MockFile;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.oioubl.OIOUBLValidation;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    OIOUBLValidation.initOIOUBL (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <MockFile> getAllTestFiles ()
  {
    final ICommonsList <MockFile> ret = new CommonsArrayList <> ();
    for (final VESID aESID : new VESID [] { // Ancient 2.0.2
                                            OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE,
                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE,
                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION,
                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE,
                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE,
                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST,
                                            OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE,
                                            OIOUBLValidation.VID_OIOUBL_INVOICE,
                                            OIOUBLValidation.VID_OIOUBL_ORDER,
                                            OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION,
                                            OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE,
                                            OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE,
                                            OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE,
                                            OIOUBLValidation.VID_OIOUBL_REMINDER,
                                            OIOUBLValidation.VID_OIOUBL_STATEMENT,

                                            // 1.12.3
                                            OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_INVOICE_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_ORDER_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_REMINDER_1_12_3,
                                            OIOUBLValidation.VID_OIOUBL_STATEMENT_1_12_3 })
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

    // Ancient 2.0.2
    if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE))
    {
      final String sPrefix = "/test-files/2.0.2/";
      for (final String s : new String [] { "ApplicationResponseStor_v2p2.xml",
                                            "BASPRO_03_01_06_ApplicationResponse_v2p2.xml",
                                            "CATEXE_01_01_00_ApplicationResponse_v2p2.xml",
                                            "CATEXE_02_02_07_ApplicationResponse_v2p2.xml",
                                            "CATEXE_04_04_00_ApplicationResponse_v2p2.xml",
                                            "CATEXE_05_05_00_ApplicationResponse_v2p2.xml",
                                            "COMDEL_03_01_04_ApplicationResponse_v2p2.xml",
                                            "COMDEL_04_02_04_ApplicationResponse_v2p2.xml" })
        ret.add (new ClassPathResource (sPrefix + s));
    }
    else
      if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE))
      {
        final String sPrefix = "/test-files/2.0.2/";
        for (final String s : new String [] { // "CATEXE_01_01_00_Catalogue_v2p2.xml",
                                              // "CATEXE_02_02_07_Catalogue_v2p2.xml",
                                              "CATEXE_05_05_00_Catalogue_A_v2p2.xml",
                                              "CATEXE_05_05_00_Catalogue_B_v2p2.xml" })
          ret.add (new ClassPathResource (sPrefix + s));
      }
      else
        if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION))
        {
          final String sPrefix = "/test-files/2.0.2/";
          for (final String s : new String [] { "CATEXE_06_06_00_CatalogueDeletion_v2p2.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }
        else
          if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE))
          {
            final String sPrefix = "/test-files/2.0.2/";
            for (final String s : new String [] { "CATEXE_03_03_00_CatalogueItemSpecificationUpdate_v2p2.xml" })
              ret.add (new ClassPathResource (sPrefix + s));
          }
          else
            if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE))
            {
              final String sPrefix = "/test-files/2.0.2/";
              for (final String s : new String [] { "CATEXE_04_04_00_CataloguePricingUpdate_v2p2.xml" })
                ret.add (new ClassPathResource (sPrefix + s));
            }
            else
              if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST))
              {
                final String sPrefix = "/test-files/2.0.2/";
                for (final String s : new String [] { "CATEXE_01_01_00_CatalogueRequest_v2p2.xml",
                                                      "CATEXE_02_02_07_CatalogueRequest_v2p2.xml",
                                                      "CATEXE_03_03_00_CatalogueRequest_v2p2.xml",
                                                      "CATEXE_05_05_00_CatalogueRequest_v2p2.xml" })
                  ret.add (new ClassPathResource (sPrefix + s));
              }
              else
                if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE))
                {
                  final String sPrefix = "/test-files/2.0.2/";
                  for (final String s : new String [] { "BASPRO_03_01_06_CreditNote_v2p2.xml",
                      // "CreditNoteStor_v2p2.xml"
                  })
                    ret.add (new ClassPathResource (sPrefix + s));
                }
                else
                  if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_INVOICE))
                  {
                    final String sPrefix = "/test-files/2.0.2/";
                    for (final String s : new String [] { "ADVORD_01_01_00_Invoice_v2p2.xml",
                                                          "ADVORD_02_02_00_Invoice_v2p2.xml",
                                                          "ADVORD_03_03_00_Invoice_v2p2.xml",
                                                          "ADVORD_04_04_00_Invoice_v2p2.xml",
                                                          "ADVORD_06_05_00_Invoice_v2p2.xml",
                                                          "BASPRO_01_01_00_Invoice_v2p2.xml",
                                                          "BASPRO_03_01_06_Invoice_B_v2p2.xml",
                                                          "BASPRO_03_01_06_Invoice_v2p2.xml",
                                                          "BASPRO_04_01_08_Invoice_v2p2.xml",
                                                          "COMDEL_01_01_00_Invoice_v2p2.xml",
                                                          "COMDEL_02_02_00_Invoice_v2p2.xml",
                                                          "COMDEL_03_01_04_Invoice_v2p2.xml",
                                                          "COMDEL_04_02_04_Invoice_v2p2.xml",
                                                          "COMORG_01_01_00_Invoice_v2p2.xml",
                                                          "COMORG_02_02_00_Invoice_v2p2.xml",
                                                          "COMORG_03_03_00_Invoice_v2p2.xml",
                                                          // "COMPAY_01_01_00_Invoice_v2p2.xml",
                                                          "COMPAY_03_03_00_Invoice_v2p2.xml",
                                                          "COMPAY_04_04_00_Invoice_v2p2.xml",
                        // "InvoiceStor_v2p2.xml",
                    })
                      ret.add (new ClassPathResource (sPrefix + s));
                  }
                  else
                    if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER))
                    {
                      final String sPrefix = "/test-files/2.0.2/";
                      for (final String s : new String [] { "ADVORD_03_03_00_Order_v2p2.xml",
                                                            "ADVORD_04_04_00_Order_v2p2.xml",
                                                            "ADVORD_05_04_01_Order_v2p2.xml",
                                                            "BASPRO_01_01_00_Order_v2p2.xml",
                                                            "BASPRO_02_01_02_Order_v2p2.xml",
                                                            "BASPRO_03_01_06_Order_v2p2.xml",
                                                            "BASPRO_04_01_08_Order_v2p2.xml",
                                                            "COMDEL_01_01_00_Order_v2p2.xml",
                                                            "COMDEL_02_02_00_Order_v2p2.xml",
                                                            "COMDEL_03_01_04_Order_v2p2.xml",
                                                            "COMDEL_04_02_04_Order_v2p2.xml",
                                                            "COMORG_01_01_00_Order_v2p2.xml",
                                                            "COMORG_02_02_00_Order_v2p2.xml",
                                                            "COMORG_03_03_00_Order_v2p2.xml",
                                                            "COMPAY_03_03_00_Order_v2p2.xml",
                                                            "COMPAY_04_04_00_Order_v2p2.xml",
                                                            "OrderStor_v2p2.xml" })
                        ret.add (new ClassPathResource (sPrefix + s));
                    }
                    else
                      if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION))
                      {
                        final String sPrefix = "/test-files/2.0.2/";
                        for (final String s : new String [] { "ADVORD_05_04_01_OrderCancellation_v2p2.xml",
                                                              "OrderCancellationStor_v2p2.xml" })
                          ret.add (new ClassPathResource (sPrefix + s));
                      }
                      else
                        if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE))
                        {
                          final String sPrefix = "/test-files/2.0.2/";
                          for (final String s : new String [] { "ADVORD_01_01_00_OrderChange_v2p2.xml",
                                                                "ADVORD_02_02_00_OrderChange_v2p2.xml",
                                                                "ADVORD_04_04_00_OrderChange_v2p2.xml",
                                                                "OrderChangeStor_v2p2.xml" })
                            ret.add (new ClassPathResource (sPrefix + s));
                        }
                        else
                          if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE))
                          {
                            final String sPrefix = "/test-files/2.0.2/";
                            for (final String s : new String [] { "ADVORD_01_01_00_OrderResponse_v2p2.xml",
                                                                  "ADVORD_02_02_00_OrderResponse_v2p2.xml",
                                                                  "ADVORD_04_04_00_OrderResponse_v2p2.xml",
                                                                  "ADVORD_05_04_01_OrderResponse_v2p2.xml",
                                                                  // "COMPAY_01_01_00_OrderResponse_v2p2.xml",
                                                                  "OrderResponseStor_v2p2.xml" })
                              ret.add (new ClassPathResource (sPrefix + s));
                          }
                          else
                            if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE))
                            {
                              final String sPrefix = "/test-files/2.0.2/";
                              for (final String s : new String [] { "ADVORD_02_02_00_OrderResponseSimple_v2p2.xml",
                                                                    "ADVORD_03_03_00_OrderResponseSimple_v2p2.xml",
                                                                    "ADVORD_06_05_00_OrderResponseSimple_v2p2.xml",
                                                                    "BASPRO_01_01_00_OrderResponseSimple_v2p2.xml",
                                                                    "BASPRO_02_01_02_OrderResponseSimple_v2p2.xml",
                                                                    "BASPRO_03_01_06_OrderResponseSimple_v2p2.xml",
                                                                    "BASPRO_04_01_08_OrderResponseSimple_v2p2.xml",
                                                                    "COMDEL_01_01_00_OrderResponseSimple_v2p2.xml",
                                                                    "COMDEL_02_02_00_OrderResponseSimple_v2p2.xml",
                                                                    "COMDEL_03_01_04_OrderResponseSimple_v2p2.xml",
                                                                    "COMDEL_04_02_04_OrderResponseSimple_v2p2.xml",
                                                                    "COMORG_01_01_00_OrderResponseSimple_v2p2.xml",
                                                                    "COMORG_02_02_00_OrderResponseSimple_v2p2.xml",
                                                                    "COMORG_03_03_00_OrderResponseSimple_v2p2.xml",
                                                                    "COMPAY_03_03_00_OrderResponseSimple_v2p2.xml",
                                                                    "COMPAY_04_04_00_OrderResponseSimple_v2p2.xml",
                                                                    "OrderResponseSimpleStor_v2p2.xml" })
                                ret.add (new ClassPathResource (sPrefix + s));
                            }
                            else
                              if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_REMINDER))
                              {
                                final String sPrefix = "/test-files/2.0.2/";
                                for (final String s : new String [] { "BASPRO_04_01_08_Reminder_v2p2.xml",
                                                                      "COMPAY_03_03_00_Reminder_v2p2.xml",
                                    // "ReminderStor_v2p2.xml",
                                })
                                  ret.add (new ClassPathResource (sPrefix + s));
                              }
                              else
                                if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_STATEMENT))
                                {
                                  final String sPrefix = "/test-files/2.0.2/";
                                  for (final String s : new String [] { 
                                      //  "StatementStor_v2p2.xml",
                                  })
                                    ret.add (new ClassPathResource (sPrefix + s));
                                }

    return ret;
  }
}
