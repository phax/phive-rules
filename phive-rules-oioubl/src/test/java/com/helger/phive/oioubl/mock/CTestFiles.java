/*
 * Copyright (C) 2018-2026 Philip Helger (www.helger.com)
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
import com.helger.phive.oioubl.OIOUBLValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    OIOUBLValidation.initOIOUBL (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aESID : new DVRCoordinate [] { // 1.17.2
                                                            OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_INVOICE_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_REMINDER_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_STATEMENT_1_17_2,
                                                            OIOUBLValidation.VID_OIOUBL_UTILITY_STATEMENT_1_17_2, })
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

    final String sPrefix0 = "/external/test-files/";
    final ICommonsList <IReadableResource> ret = new CommonsArrayList <> ();

    // 1.17.2
    {
      final String sPrefix = sPrefix0 + "1.17.2/";
      if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE_1_17_2))
      {
        for (final String s : new String [] { "OIOUBL_ApplicationResponse_v2p2.xml" })
          ret.add (new ClassPathResource (sPrefix + s));
      }
      else
        if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_1_17_2))
        {
          for (final String s : new String [] { "OIOUBL_Catalogue_v2p2.xml" })
            ret.add (new ClassPathResource (sPrefix + s));
        }
        else
          if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION_1_17_2))
          {
            for (final String s : new String [] { "OIOUBL_CatalogueDeletion_v2p2.xml" })
              ret.add (new ClassPathResource (sPrefix + s));
          }
          else
            if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_17_2))
            {
              for (final String s : new String [] { "OIOUBL_CatalogueItemSpecificationUpdate_v2p2.xml" })
                ret.add (new ClassPathResource (sPrefix + s));
            }
            else
              if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_17_2))
              {
                for (final String s : new String [] { "OIOUBL_CataloguePricingUpdate_v2p2.xml" })
                  ret.add (new ClassPathResource (sPrefix + s));
              }
              else
                if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST_1_17_2))
                {
                  for (final String s : new String [] { "OIOUBL_CatalogueRequest_v2p2.xml" })
                    ret.add (new ClassPathResource (sPrefix + s));
                }
                else
                  if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE_1_17_2))
                  {
                    for (final String s : new String [] { "OIOUBL_CreditNote_v2p2.xml",
                                                          // broken
                                                          "OIOUBL_CreditNoteCertificate.xml" })
                      ret.add (new ClassPathResource (sPrefix + s));
                  }
                  else
                    if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_INVOICE_1_17_2))
                    {
                      for (final String s : new String [] { "OIOUBL_Invoice_UBLExtensions_v2p2.xml",
                                                            "OIOUBL_Invoice_v2p2.xml",
                                                            // broken
                                                            "OIOUBL_InvoiceCerticate.xml" })
                        ret.add (new ClassPathResource (sPrefix + s));
                    }
                    else
                      if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_1_17_2))
                      {
                        for (final String s : new String [] { "OIOUBL_Order_v2p2.xml" })
                          ret.add (new ClassPathResource (sPrefix + s));
                      }
                      else
                        if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION_1_17_2))
                        {
                          for (final String s : new String [] { "OIOUBL_OrderCancellation_v2p2.xml" })
                            ret.add (new ClassPathResource (sPrefix + s));
                        }
                        else
                          if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE_1_17_2))
                          {
                            for (final String s : new String [] { "OIOUBL_OrderChange_v2p2.xml" })
                              ret.add (new ClassPathResource (sPrefix + s));
                          }
                          else
                            if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_1_17_2))
                            {
                              for (final String s : new String [] { "OIOUBL_OrderResponse_v2p2.xml" })
                                ret.add (new ClassPathResource (sPrefix + s));
                            }
                            else
                              if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_17_2))
                              {
                                for (final String s : new String [] { "OIOUBL_OrderResponseSimple_v2p2.xml" })
                                  ret.add (new ClassPathResource (sPrefix + s));
                              }
                              else
                                if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_REMINDER_1_17_2))
                                {
                                  for (final String s : new String [] { "OIOUBL_Reminder_v2p2.xml" })
                                    ret.add (new ClassPathResource (sPrefix + s));
                                }
                                else
                                  if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_STATEMENT_1_17_2))
                                  {
                                    for (final String s : new String [] { "OIOUBL_Statement_v2p2.xml" })
                                      ret.add (new ClassPathResource (sPrefix + s));
                                  }
                                  else
                                    if (aVESID.equals (OIOUBLValidation.VID_OIOUBL_UTILITY_STATEMENT_1_17_2))
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
