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
import com.helger.phive.oioubl.OIOUBLValidation;

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

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <MockFile> getAllTestFiles ()
  {
    final ICommonsList <MockFile> ret = new CommonsArrayList <> ();
    for (final VESID aESID : new VESID [] { OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE,
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
                                            OIOUBLValidation.VID_OIOUBL_STATEMENT })
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
    final String sBasePath = "/test-files/2.0.2/";
    // List created by MainAssignTestFilesToDocTypes
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_01_01_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_01_01_00_OrderChange_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_01_01_00_OrderResponse_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_02_02_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_02_02_00_OrderChange_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_02_02_00_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_02_02_00_OrderResponse_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_03_03_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_03_03_00_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_03_03_00_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_04_04_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_04_04_00_OrderChange_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_04_04_00_OrderResponse_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_04_04_00_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_05_04_01_OrderCancellation_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_05_04_01_OrderResponse_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_05_04_01_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_06_05_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ADVORD_06_05_00_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "ApplicationResponseStor_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_01_01_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_01_01_00_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_01_01_00_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_02_01_02_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_02_01_02_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_03_01_06_ApplicationResponse_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_03_01_06_CreditNote_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_03_01_06_Invoice_B_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_03_01_06_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_03_01_06_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_03_01_06_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_04_01_08_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_04_01_08_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_04_01_08_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_REMINDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "BASPRO_04_01_08_Reminder_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_01_01_00_ApplicationResponse_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_01_01_00_CatalogueRequest_v2p2.xml"));
    if (false)
      aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CATALOGUE, k -> new CommonsArrayList <> ())
          .add (new ClassPathResource (sBasePath + "CATEXE_01_01_00_Catalogue_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_02_02_07_ApplicationResponse_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_02_02_07_CatalogueRequest_v2p2.xml"));
    if (false)
      aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CATALOGUE, k -> new CommonsArrayList <> ())
          .add (new ClassPathResource (sBasePath + "CATEXE_02_02_07_Catalogue_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_03_03_00_CatalogueItemSpecificationUpdate_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_03_03_00_CatalogueRequest_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_04_04_00_ApplicationResponse_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CATALOGUE_PRICING_UPDATE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_04_04_00_CataloguePricingUpdate_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_05_05_00_ApplicationResponse_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CATALOGUE_REQUEST, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_05_05_00_CatalogueRequest_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CATALOGUE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_05_05_00_Catalogue_A_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CATALOGUE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_05_05_00_Catalogue_B_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CATALOGUE_DELETION, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "CATEXE_06_06_00_CatalogueDeletion_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_01_01_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_01_01_00_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_01_01_00_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_02_02_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_02_02_00_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_02_02_00_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_03_01_04_ApplicationResponse_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_03_01_04_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_03_01_04_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_03_01_04_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_APPLICATION_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_04_02_04_ApplicationResponse_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_04_02_04_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_04_02_04_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMDEL_04_02_04_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMORG_01_01_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMORG_01_01_00_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMORG_01_01_00_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMORG_02_02_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMORG_02_02_00_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMORG_02_02_00_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMORG_03_03_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMORG_03_03_00_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMORG_03_03_00_Order_v2p2.xml"));
    if (false)
      aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
          .add (new ClassPathResource (sBasePath + "COMPAY_01_01_00_Invoice_v2p2.xml"));
    if (false)
      aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE, k -> new CommonsArrayList <> ())
          .add (new ClassPathResource (sBasePath + "COMPAY_01_01_00_OrderResponse_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMPAY_03_03_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMPAY_03_03_00_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMPAY_03_03_00_Order_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_REMINDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMPAY_03_03_00_Reminder_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMPAY_04_04_00_Invoice_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMPAY_04_04_00_OrderResponseSimple_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "COMPAY_04_04_00_Order_v2p2.xml"));
    if (false)
      aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_CREDIT_NOTE, k -> new CommonsArrayList <> ())
          .add (new ClassPathResource (sBasePath + "CreditNoteStor_v2p2.xml"));
    if (false)
      aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_INVOICE, k -> new CommonsArrayList <> ())
          .add (new ClassPathResource (sBasePath + "InvoiceStor_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_CANCELLATION, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "OrderCancellationStor_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_CHANGE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "OrderChangeStor_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE_SIMPLE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "OrderResponseSimpleStor_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER_RESPONSE, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "OrderResponseStor_v2p2.xml"));
    aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_ORDER, k -> new CommonsArrayList <> ())
        .add (new ClassPathResource (sBasePath + "OrderStor_v2p2.xml"));
    if (false)
      aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_REMINDER, k -> new CommonsArrayList <> ())
          .add (new ClassPathResource (sBasePath + "ReminderStor_v2p2.xml"));
    if (false)
      aMap.computeIfAbsent (OIOUBLValidation.VID_OIOUBL_STATEMENT, k -> new CommonsArrayList <> ())
          .add (new ClassPathResource (sBasePath + "StatementStor_v2p2.xml"));

    final ICommonsList <IReadableResource> ret = aMap.get (aVESID);
    if (ret != null)
      return ret;

    // There is currently no valid test file for "Statement"
    if (true)
      return new CommonsArrayList <> ();

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
