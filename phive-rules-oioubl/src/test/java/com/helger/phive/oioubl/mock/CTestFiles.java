/*
 * Copyright (C) 2018-2024 Philip Helger (www.helger.com)
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
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.oioubl.OIOUBLLegacyValidation;
import com.helger.phive.oioubl.OIOUBLValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    OIOUBLValidation.initOIOUBL (VES_REGISTRY);
    OIOUBLLegacyValidation.initLegacyOIOUBL (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aESID : new DVRCoordinate [] { // Ancient 2.0.2
                                                            OIOUBLLegacyValidation.VID_OIOUBL_APPLICATION_RESPONSE,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_CATALOGUE,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_CATALOGUE_DELETION,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_CATALOGUE_REQUEST,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_CREDIT_NOTE,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_INVOICE,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_ORDER,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_ORDER_CANCELLATION,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_ORDER_CHANGE,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_ORDER_RESPONSE,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_REMINDER,
                                                            OIOUBLLegacyValidation.VID_OIOUBL_STATEMENT,

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
                                                            OIOUBLValidation.VID_OIOUBL_STATEMENT_1_12_3,
                                                            OIOUBLValidation.VID_OIOUBL_UTILITY_STATEMENT_1_12_3,

                                                            // 1.13.0
                                                            OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_INVOICE_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_REMINDER_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_STATEMENT_1_13_0,
                                                            OIOUBLValidation.VID_OIOUBL_UTILITY_STATEMENT_1_13_0,

                                                            // 1.13.2
                                                            OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_INVOICE_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_REMINDER_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_STATEMENT_1_13_2,
                                                            OIOUBLValidation.VID_OIOUBL_UTILITY_STATEMENT_1_13_2,

                                                            // 1.14.2
                                                            OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_INVOICE_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_REMINDER_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_STATEMENT_1_14_2,
                                                            OIOUBLValidation.VID_OIOUBL_UTILITY_STATEMENT_1_14_2 })
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

    final String sPrefix0 = "/external/test-files/";
    final ICommonsList <IReadableResource> ret = new CommonsArrayList <> ();

    // Ancient 2.0.2
    if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_APPLICATION_RESPONSE))
    {
      final String sPrefix = sPrefix0 + "2.0.2/";
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
      if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_CATALOGUE))
      {
        final String sPrefix = sPrefix0 + "2.0.2/";
        for (final String s : new String [] { // "CATEXE_01_01_00_Catalogue_v2p2.xml",
                                              // "CATEXE_02_02_07_Catalogue_v2p2.xml",
                                              "CATEXE_05_05_00_Catalogue_A_v2p2.xml",
                                              "CATEXE_05_05_00_Catalogue_B_v2p2.xml" })
          ret.add (new ClassPathResource (sPrefix + s));
      }
      else
        if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_CATALOGUE_DELETION))
        {
          final String sPrefix = sPrefix0 + "2.0.2/";
          for (final String s : new String [] { "CATEXE_06_06_00_CatalogueDeletion_v2p2.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }
        else
          if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE))
          {
            final String sPrefix = sPrefix0 + "2.0.2/";
            for (final String s : new String [] { "CATEXE_03_03_00_CatalogueItemSpecificationUpdate_v2p2.xml" })
              ret.add (new ClassPathResource (sPrefix + s));
          }
          else
            if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE))
            {
              final String sPrefix = sPrefix0 + "2.0.2/";
              for (final String s : new String [] { "CATEXE_04_04_00_CataloguePricingUpdate_v2p2.xml" })
                ret.add (new ClassPathResource (sPrefix + s));
            }
            else
              if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_CATALOGUE_REQUEST))
              {
                final String sPrefix = sPrefix0 + "2.0.2/";
                for (final String s : new String [] { "CATEXE_01_01_00_CatalogueRequest_v2p2.xml",
                                                      "CATEXE_02_02_07_CatalogueRequest_v2p2.xml",
                                                      "CATEXE_03_03_00_CatalogueRequest_v2p2.xml",
                                                      "CATEXE_05_05_00_CatalogueRequest_v2p2.xml" })
                  ret.add (new ClassPathResource (sPrefix + s));
              }
              else
                if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_CREDIT_NOTE))
                {
                  final String sPrefix = sPrefix0 + "2.0.2/";
                  for (final String s : new String [] { "BASPRO_03_01_06_CreditNote_v2p2.xml",
                      // "CreditNoteStor_v2p2.xml"
                  })
                    ret.add (new ClassPathResource (sPrefix + s));
                }
                else
                  if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_INVOICE))
                  {
                    final String sPrefix = sPrefix0 + "2.0.2/";
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
                    if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_ORDER))
                    {
                      final String sPrefix = sPrefix0 + "2.0.2/";
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
                      if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_ORDER_CANCELLATION))
                      {
                        final String sPrefix = sPrefix0 + "2.0.2/";
                        for (final String s : new String [] { "ADVORD_05_04_01_OrderCancellation_v2p2.xml",
                                                              "OrderCancellationStor_v2p2.xml" })
                          ret.add (new ClassPathResource (sPrefix + s));
                      }
                      else
                        if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_ORDER_CHANGE))
                        {
                          final String sPrefix = sPrefix0 + "2.0.2/";
                          for (final String s : new String [] { "ADVORD_01_01_00_OrderChange_v2p2.xml",
                                                                "ADVORD_02_02_00_OrderChange_v2p2.xml",
                                                                "ADVORD_04_04_00_OrderChange_v2p2.xml",
                                                                "OrderChangeStor_v2p2.xml" })
                            ret.add (new ClassPathResource (sPrefix + s));
                        }
                        else
                          if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_ORDER_RESPONSE))
                          {
                            final String sPrefix = sPrefix0 + "2.0.2/";
                            for (final String s : new String [] { "ADVORD_01_01_00_OrderResponse_v2p2.xml",
                                                                  "ADVORD_02_02_00_OrderResponse_v2p2.xml",
                                                                  "ADVORD_04_04_00_OrderResponse_v2p2.xml",
                                                                  "ADVORD_05_04_01_OrderResponse_v2p2.xml",
                                                                  // "COMPAY_01_01_00_OrderResponse_v2p2.xml",
                                                                  "OrderResponseStor_v2p2.xml" })
                              ret.add (new ClassPathResource (sPrefix + s));
                          }
                          else
                            if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE))
                            {
                              final String sPrefix = sPrefix0 + "2.0.2/";
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
                              if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_REMINDER))
                              {
                                final String sPrefix = sPrefix0 + "2.0.2/";
                                for (final String s : new String [] { "BASPRO_04_01_08_Reminder_v2p2.xml",
                                                                      "COMPAY_03_03_00_Reminder_v2p2.xml",
                                    // "ReminderStor_v2p2.xml",
                                })
                                  ret.add (new ClassPathResource (sPrefix + s));
                              }
                              else
                                if (aVESID.equals (OIOUBLLegacyValidation.VID_OIOUBL_STATEMENT))
                                {
                                  final String sPrefix = sPrefix0 + "2.0.2/";
                                  for (final String s : new String [] {
                                      // "StatementStor_v2p2.xml",
                                  })
                                    ret.add (new ClassPathResource (sPrefix + s));
                                }

    // 1.12.3
    // All of the test files are broken in regards to Saxon 11.x
    if (false)
      if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE_1_12_3))
      {
        final String sPrefix = sPrefix0 + "1.12.3/";
        for (final String s : new String [] { "OIOUBL_ApplicationResponse_v2p2.xml" })
          ret.add (new ClassPathResource (sPrefix + s));
      }
      else
        if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_1_12_3))
        {
          final String sPrefix = sPrefix0 + "1.12.3/";
          for (final String s : new String [] { "OIOUBL_Catalogue_v2p2.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }
        else
          if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION_1_12_3))
          {
            final String sPrefix = sPrefix0 + "1.12.3/";
            for (final String s : new String [] { "OIOUBL_CatalogueDeletion_v2p2.xml" })
              ret.add (new ClassPathResource (sPrefix + s));
          }
          else
            if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_12_3))
            {
              final String sPrefix = sPrefix0 + "1.12.3/";
              for (final String s : new String [] { "OIOUBL_CatalogueItemSpecificationUpdate_v2p2.xml" })
                ret.add (new ClassPathResource (sPrefix + s));
            }
            else
              if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_12_3))
              {
                final String sPrefix = sPrefix0 + "1.12.3/";
                for (final String s : new String [] { "OIOUBL_CataloguePricingUpdate_v2p2.xml" })
                  ret.add (new ClassPathResource (sPrefix + s));
              }
              else
                if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST_1_12_3))
                {
                  final String sPrefix = sPrefix0 + "1.12.3/";
                  for (final String s : new String [] { "OIOUBL_CatalogueRequest_v2p2.xml" })
                    ret.add (new ClassPathResource (sPrefix + s));
                }
                else
                  if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE_1_12_3))
                  {
                    final String sPrefix = sPrefix0 + "1.12.3/";
                    for (final String s : new String [] { "OIOUBL_CreditNote_v2p2.xml",
                                                          "OIOUBL_CreditNoteCertificate.xml" })
                      ret.add (new ClassPathResource (sPrefix + s));
                  }
                  else
                    if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_INVOICE_1_12_3))
                    {
                      final String sPrefix = sPrefix0 + "1.12.3/";
                      for (final String s : new String [] { "OIOUBL_Invoice_UBLExtensions_v2p2.xml",
                                                            "OIOUBL_Invoice_v2p2.xml",
                                                            "OIOUBL_InvoiceCerticate.xml" })
                        ret.add (new ClassPathResource (sPrefix + s));
                    }
                    else
                      if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_1_12_3))
                      {
                        final String sPrefix = sPrefix0 + "1.12.3/";
                        for (final String s : new String [] { "OIOUBL_Order_v2p2.xml" })
                          ret.add (new ClassPathResource (sPrefix + s));
                      }
                      else
                        if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION_1_12_3))
                        {
                          final String sPrefix = sPrefix0 + "1.12.3/";
                          for (final String s : new String [] { "OIOUBL_OrderCancellation_v2p2.xml" })
                            ret.add (new ClassPathResource (sPrefix + s));
                        }
                        else
                          if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE_1_12_3))
                          {
                            final String sPrefix = sPrefix0 + "1.12.3/";
                            for (final String s : new String [] { "OIOUBL_OrderChange_v2p2.xml" })
                              ret.add (new ClassPathResource (sPrefix + s));
                          }
                          else
                            if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_1_12_3))
                            {
                              final String sPrefix = sPrefix0 + "1.12.3/";
                              for (final String s : new String [] { "OIOUBL_OrderResponse_v2p2.xml" })
                                ret.add (new ClassPathResource (sPrefix + s));
                            }
                            else
                              if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_12_3))
                              {
                                final String sPrefix = sPrefix0 + "1.12.3/";
                                for (final String s : new String [] { "OIOUBL_OrderResponseSimple_v2p2.xml" })
                                  ret.add (new ClassPathResource (sPrefix + s));
                              }
                              else
                                if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_REMINDER_1_12_3))
                                {
                                  final String sPrefix = sPrefix0 + "1.12.3/";
                                  for (final String s : new String [] { "OIOUBL_Reminder_v2p2.xml" })
                                    ret.add (new ClassPathResource (sPrefix + s));
                                }
                                else
                                  if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_STATEMENT_1_12_3))
                                  {
                                    final String sPrefix = sPrefix0 + "1.12.3/";
                                    for (final String s : new String [] { "OIOUBL_Statement_v2p2.xml" })
                                      ret.add (new ClassPathResource (sPrefix + s));
                                  }
                                  else
                                    if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_UTILITY_STATEMENT_1_12_3))
                                    {
                                      final String sPrefix = sPrefix0 + "1.12.3/";
                                      for (final String s : new String [] { "OIOUBL_UtilityStatement_v2p2.xml" })
                                        ret.add (new ClassPathResource (sPrefix + s));
                                    }

    // 1.13.0
    {
      final String sPrefix = sPrefix0 + "1.13.0/";
      if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE_1_13_0))
      {
        for (final String s : new String [] { "OIOUBL_ApplicationResponse_v2p2.xml" })
          ret.add (new ClassPathResource (sPrefix + s));
      }
      else
        if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_1_13_0))
        {
          for (final String s : new String [] { "OIOUBL_Catalogue_v2p2.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }
        else
          if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION_1_13_0))
          {
            for (final String s : new String [] { "OIOUBL_CatalogueDeletion_v2p2.xml" })
              ret.add (new ClassPathResource (sPrefix + s));
          }
          else
            if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_0))
            {
              for (final String s : new String [] { "OIOUBL_CatalogueItemSpecificationUpdate_v2p2.xml" })
                ret.add (new ClassPathResource (sPrefix + s));
            }
            else
              if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_0))
              {
                for (final String s : new String [] { "OIOUBL_CataloguePricingUpdate_v2p2.xml" })
                  ret.add (new ClassPathResource (sPrefix + s));
              }
              else
                if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST_1_13_0))
                {
                  for (final String s : new String [] { "OIOUBL_CatalogueRequest_v2p2.xml" })
                    ret.add (new ClassPathResource (sPrefix + s));
                }
                else
                  if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE_1_13_0))
                  {
                    for (final String s : new String [] { "OIOUBL_CreditNote_v2p2.xml"
                        // broken
                        // , "OIOUBL_CreditNoteCertificate.xml"
                    })
                      ret.add (new ClassPathResource (sPrefix + s));
                  }
                  else
                    if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_INVOICE_1_13_0))
                    {
                      for (final String s : new String [] { "OIOUBL_Invoice_UBLExtensions_v2p2.xml",
                                                            "OIOUBL_Invoice_v2p2.xml",
                          // broken
                          // "OIOUBL_InvoiceCerticate.xml"
                      })
                        ret.add (new ClassPathResource (sPrefix + s));
                    }
                    else
                      if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_1_13_0))
                      {
                        for (final String s : new String [] { "OIOUBL_Order_v2p2.xml" })
                          ret.add (new ClassPathResource (sPrefix + s));
                      }
                      else
                        if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION_1_13_0))
                        {
                          for (final String s : new String [] { "OIOUBL_OrderCancellation_v2p2.xml" })
                            ret.add (new ClassPathResource (sPrefix + s));
                        }
                        else
                          if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE_1_13_0))
                          {
                            for (final String s : new String [] { "OIOUBL_OrderChange_v2p2.xml" })
                              ret.add (new ClassPathResource (sPrefix + s));
                          }
                          else
                            if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_1_13_0))
                            {
                              for (final String s : new String [] { "OIOUBL_OrderResponse_v2p2.xml" })
                                ret.add (new ClassPathResource (sPrefix + s));
                            }
                            else
                              if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_0))
                              {
                                for (final String s : new String [] { "OIOUBL_OrderResponseSimple_v2p2.xml" })
                                  ret.add (new ClassPathResource (sPrefix + s));
                              }
                              else
                                if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_REMINDER_1_13_0))
                                {
                                  for (final String s : new String [] { "OIOUBL_Reminder_v2p2.xml" })
                                    ret.add (new ClassPathResource (sPrefix + s));
                                }
                                else
                                  if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_STATEMENT_1_13_0))
                                  {
                                    for (final String s : new String [] { "OIOUBL_Statement_v2p2.xml" })
                                      ret.add (new ClassPathResource (sPrefix + s));
                                  }
                                  else
                                    if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_UTILITY_STATEMENT_1_13_0))
                                    {
                                      for (final String s : new String [] {
                                          // broken
                                          // "OIOUBL_UtilityStatement_v2p2.xml"

                                      })
                                        ret.add (new ClassPathResource (sPrefix + s));
                                    }
    }

    // 1.13.2
    {
      final String sPrefix = sPrefix0 + "1.13.2/";
      if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE_1_13_2))
      {
        for (final String s : new String [] { "OIOUBL_ApplicationResponse_v2p2.xml" })
          ret.add (new ClassPathResource (sPrefix + s));
      }
      else
        if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_1_13_2))
        {
          for (final String s : new String [] { "OIOUBL_Catalogue_v2p2.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }
        else
          if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION_1_13_2))
          {
            for (final String s : new String [] { "OIOUBL_CatalogueDeletion_v2p2.xml" })
              ret.add (new ClassPathResource (sPrefix + s));
          }
          else
            if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_2))
            {
              for (final String s : new String [] { "OIOUBL_CatalogueItemSpecificationUpdate_v2p2.xml" })
                ret.add (new ClassPathResource (sPrefix + s));
            }
            else
              if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_2))
              {
                for (final String s : new String [] { "OIOUBL_CataloguePricingUpdate_v2p2.xml" })
                  ret.add (new ClassPathResource (sPrefix + s));
              }
              else
                if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST_1_13_2))
                {
                  for (final String s : new String [] { "OIOUBL_CatalogueRequest_v2p2.xml" })
                    ret.add (new ClassPathResource (sPrefix + s));
                }
                else
                  if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE_1_13_2))
                  {
                    for (final String s : new String [] { "OIOUBL_CreditNote_v2p2.xml",
                        // broken
                        // "OIOUBL_CreditNoteCertificate.xml"
                    })
                      ret.add (new ClassPathResource (sPrefix + s));
                  }
                  else
                    if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_INVOICE_1_13_2))
                    {
                      for (final String s : new String [] { "OIOUBL_Invoice_UBLExtensions_v2p2.xml",
                                                            "OIOUBL_Invoice_v2p2.xml",
                          // broken
                          // "OIOUBL_InvoiceCerticate.xml"
                      })
                        ret.add (new ClassPathResource (sPrefix + s));
                    }
                    else
                      if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_1_13_2))
                      {
                        for (final String s : new String [] { "OIOUBL_Order_v2p2.xml" })
                          ret.add (new ClassPathResource (sPrefix + s));
                      }
                      else
                        if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION_1_13_2))
                        {
                          for (final String s : new String [] { "OIOUBL_OrderCancellation_v2p2.xml" })
                            ret.add (new ClassPathResource (sPrefix + s));
                        }
                        else
                          if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE_1_13_2))
                          {
                            for (final String s : new String [] { "OIOUBL_OrderChange_v2p2.xml" })
                              ret.add (new ClassPathResource (sPrefix + s));
                          }
                          else
                            if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_1_13_2))
                            {
                              for (final String s : new String [] { "OIOUBL_OrderResponse_v2p2.xml" })
                                ret.add (new ClassPathResource (sPrefix + s));
                            }
                            else
                              if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_2))
                              {
                                for (final String s : new String [] { "OIOUBL_OrderResponseSimple_v2p2.xml" })
                                  ret.add (new ClassPathResource (sPrefix + s));
                              }
                              else
                                if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_REMINDER_1_13_2))
                                {
                                  for (final String s : new String [] { "OIOUBL_Reminder_v2p2.xml" })
                                    ret.add (new ClassPathResource (sPrefix + s));
                                }
                                else
                                  if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_STATEMENT_1_13_2))
                                  {
                                    for (final String s : new String [] { "OIOUBL_Statement_v2p2.xml" })
                                      ret.add (new ClassPathResource (sPrefix + s));
                                  }
                                  else
                                    if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_UTILITY_STATEMENT_1_13_2))
                                    {
                                      for (final String s : new String [] {
                                          // broken
                                          // "OIOUBL_UtilityStatement_v2p2.xml"
                                      })
                                        ret.add (new ClassPathResource (sPrefix + s));
                                    }
    }

    // 1.14.2
    {
      final String sPrefix = sPrefix0 + "1.14.2/";
      if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE_1_14_2))
      {
        for (final String s : new String [] { "OIOUBL_ApplicationResponse_v2p2.xml" })
          ret.add (new ClassPathResource (sPrefix + s));
      }
      else
        if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_1_14_2))
        {
          for (final String s : new String [] { "OIOUBL_Catalogue_v2p2.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }
        else
          if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION_1_14_2))
          {
            for (final String s : new String [] { "OIOUBL_CatalogueDeletion_v2p2.xml" })
              ret.add (new ClassPathResource (sPrefix + s));
          }
          else
            if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_14_2))
            {
              for (final String s : new String [] { "OIOUBL_CatalogueItemSpecificationUpdate_v2p2.xml" })
                ret.add (new ClassPathResource (sPrefix + s));
            }
            else
              if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_14_2))
              {
                for (final String s : new String [] { "OIOUBL_CataloguePricingUpdate_v2p2.xml" })
                  ret.add (new ClassPathResource (sPrefix + s));
              }
              else
                if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST_1_14_2))
                {
                  for (final String s : new String [] { "OIOUBL_CatalogueRequest_v2p2.xml" })
                    ret.add (new ClassPathResource (sPrefix + s));
                }
                else
                  if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE_1_14_2))
                  {
                    for (final String s : new String [] { "OIOUBL_CreditNote_v2p2.xml",
                        // broken
                        // "OIOUBL_CreditNoteCertificate.xml"
                    })
                      ret.add (new ClassPathResource (sPrefix + s));
                  }
                  else
                    if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_INVOICE_1_14_2))
                    {
                      for (final String s : new String [] { "OIOUBL_Invoice_UBLExtensions_v2p2.xml",
                                                            "OIOUBL_Invoice_v2p2.xml",
                          // broken
                          // "OIOUBL_InvoiceCerticate.xml"
                      })
                        ret.add (new ClassPathResource (sPrefix + s));
                    }
                    else
                      if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_1_14_2))
                      {
                        for (final String s : new String [] { "OIOUBL_Order_v2p2.xml" })
                          ret.add (new ClassPathResource (sPrefix + s));
                      }
                      else
                        if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION_1_14_2))
                        {
                          for (final String s : new String [] { "OIOUBL_OrderCancellation_v2p2.xml" })
                            ret.add (new ClassPathResource (sPrefix + s));
                        }
                        else
                          if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE_1_14_2))
                          {
                            for (final String s : new String [] { "OIOUBL_OrderChange_v2p2.xml" })
                              ret.add (new ClassPathResource (sPrefix + s));
                          }
                          else
                            if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_1_14_2))
                            {
                              for (final String s : new String [] { "OIOUBL_OrderResponse_v2p2.xml" })
                                ret.add (new ClassPathResource (sPrefix + s));
                            }
                            else
                              if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_14_2))
                              {
                                for (final String s : new String [] { "OIOUBL_OrderResponseSimple_v2p2.xml" })
                                  ret.add (new ClassPathResource (sPrefix + s));
                              }
                              else
                                if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_REMINDER_1_14_2))
                                {
                                  for (final String s : new String [] { "OIOUBL_Reminder_v2p2.xml" })
                                    ret.add (new ClassPathResource (sPrefix + s));
                                }
                                else
                                  if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_STATEMENT_1_14_2))
                                  {
                                    for (final String s : new String [] { "OIOUBL_Statement_v2p2.xml" })
                                      ret.add (new ClassPathResource (sPrefix + s));
                                  }
                                  else
                                    if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_UTILITY_STATEMENT_1_14_2))
                                    {
                                      for (final String s : new String [] {
                                          // broken
                                          // "OIOUBL_UtilityStatement_v2p2.xml"
                                      })
                                        ret.add (new ClassPathResource (sPrefix + s));
                                    }
    }

    return ret;
  }
}
