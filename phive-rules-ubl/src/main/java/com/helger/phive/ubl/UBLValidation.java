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
package com.helger.phive.ubl;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.diver.api.version.VESID;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatus;
import com.helger.phive.xml.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl20.UBL20Marshaller;
import com.helger.ubl20.UBL20NamespaceContext;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.ubl22.UBL22Marshaller;
import com.helger.ubl22.UBL22NamespaceContext;
import com.helger.ubl23.UBL23Marshaller;
import com.helger.ubl23.UBL23NamespaceContext;
import com.helger.ubl24.UBL24Marshaller;
import com.helger.ubl24.UBL24NamespaceContext;

/**
 * Generic UBL validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class UBLValidation
{
  public static final String GROUP_ID = "org.oasis-open";
  public static final String VERSION_20 = "2.0";
  public static final String VERSION_21 = "2.1";
  public static final String VERSION_22 = "2.2";
  public static final String VERSION_23 = "2.3";
  public static final String VERSION_24 = "2.4-cds01";

  // UBL 2.0
  public static final VESID VID_UBL_20_APPLICATIONRESPONSE = new VESID (GROUP_ID, "applicationresponse", VERSION_20);
  public static final VESID VID_UBL_20_ATTACHEDDOCUMENT = new VESID (GROUP_ID, "attacheddocument", VERSION_20);
  public static final VESID VID_UBL_20_BILLOFLADING = new VESID (GROUP_ID, "billoflading", VERSION_20);
  public static final VESID VID_UBL_20_CATALOGUE = new VESID (GROUP_ID, "catalogue", VERSION_20);
  public static final VESID VID_UBL_20_CATALOGUEDELETION = new VESID (GROUP_ID, "cataloguedeletion", VERSION_20);
  public static final VESID VID_UBL_20_CATALOGUEITEMSPECIFICATIONUPDATE = new VESID (GROUP_ID,
                                                                                     "catalogueitemspecificationupdate",
                                                                                     VERSION_20);
  public static final VESID VID_UBL_20_CATALOGUEPRICINGUPDATE = new VESID (GROUP_ID,
                                                                           "cataloguepricingupdate",
                                                                           VERSION_20);
  public static final VESID VID_UBL_20_CATALOGUEREQUEST = new VESID (GROUP_ID, "cataloguerequest", VERSION_20);
  public static final VESID VID_UBL_20_CERTIFICATEOFORIGIN = new VESID (GROUP_ID, "certificateoforigin", VERSION_20);
  public static final VESID VID_UBL_20_CREDITNOTE = new VESID (GROUP_ID, "creditnote", VERSION_20);
  public static final VESID VID_UBL_20_DEBITNOTE = new VESID (GROUP_ID, "debitnote", VERSION_20);
  public static final VESID VID_UBL_20_DESPATCHADVICE = new VESID (GROUP_ID, "despatchadvice", VERSION_20);
  public static final VESID VID_UBL_20_FORWARDINGINSTRUCTIONS = new VESID (GROUP_ID,
                                                                           "forwardinginstructions",
                                                                           VERSION_20);
  public static final VESID VID_UBL_20_FREIGHTINVOICE = new VESID (GROUP_ID, "freightinvoice", VERSION_20);
  public static final VESID VID_UBL_20_INVOICE = new VESID (GROUP_ID, "invoice", VERSION_20);
  public static final VESID VID_UBL_20_ORDER = new VESID (GROUP_ID, "order", VERSION_20);
  public static final VESID VID_UBL_20_ORDERCANCELLATION = new VESID (GROUP_ID, "ordercancellation", VERSION_20);
  public static final VESID VID_UBL_20_ORDERCHANGE = new VESID (GROUP_ID, "orderchange", VERSION_20);
  public static final VESID VID_UBL_20_ORDERRESPONSE = new VESID (GROUP_ID, "orderresponse", VERSION_20);
  public static final VESID VID_UBL_20_ORDERRESPONSESIMPLE = new VESID (GROUP_ID, "orderresponsesimple", VERSION_20);
  public static final VESID VID_UBL_20_PACKINGLIST = new VESID (GROUP_ID, "packinglist", VERSION_20);
  public static final VESID VID_UBL_20_QUOTATION = new VESID (GROUP_ID, "quotation", VERSION_20);
  public static final VESID VID_UBL_20_RECEIPTADVICE = new VESID (GROUP_ID, "receiptadvice", VERSION_20);
  public static final VESID VID_UBL_20_REMINDER = new VESID (GROUP_ID, "reminder", VERSION_20);
  public static final VESID VID_UBL_20_REMITTANCEADVICE = new VESID (GROUP_ID, "remittanceadvice", VERSION_20);
  public static final VESID VID_UBL_20_REQUESTFORQUOTATION = new VESID (GROUP_ID, "requestforquotation", VERSION_20);
  public static final VESID VID_UBL_20_SELFBILLEDCREDITNOTE = new VESID (GROUP_ID, "selfbilledcreditnote", VERSION_20);
  public static final VESID VID_UBL_20_SELFBILLEDINVOICE = new VESID (GROUP_ID, "selfbilledinvoice", VERSION_20);
  public static final VESID VID_UBL_20_STATEMENT = new VESID (GROUP_ID, "statement", VERSION_20);
  public static final VESID VID_UBL_20_TRANSPORTATIONSTATUS = new VESID (GROUP_ID, "transportationstatus", VERSION_20);
  public static final VESID VID_UBL_20_WAYBILL = new VESID (GROUP_ID, "waybill", VERSION_20);

  // UBL 2.1
  public static final VESID VID_UBL_21_APPLICATIONRESPONSE = new VESID (GROUP_ID, "applicationresponse", VERSION_21);
  public static final VESID VID_UBL_21_ATTACHEDDOCUMENT = new VESID (GROUP_ID, "attacheddocument", VERSION_21);
  public static final VESID VID_UBL_21_AWARDEDNOTIFICATION = new VESID (GROUP_ID, "awardednotification", VERSION_21);
  public static final VESID VID_UBL_21_BILLOFLADING = new VESID (GROUP_ID, "billoflading", VERSION_21);
  public static final VESID VID_UBL_21_CALLFORTENDERS = new VESID (GROUP_ID, "callfortenders", VERSION_21);
  public static final VESID VID_UBL_21_CATALOGUE = new VESID (GROUP_ID, "catalogue", VERSION_21);
  public static final VESID VID_UBL_21_CATALOGUEDELETION = new VESID (GROUP_ID, "cataloguedeletion", VERSION_21);
  public static final VESID VID_UBL_21_CATALOGUEITEMSPECIFICATIONUPDATE = new VESID (GROUP_ID,
                                                                                     "catalogueitemspecificationupdate",
                                                                                     VERSION_21);
  public static final VESID VID_UBL_21_CATALOGUEPRICINGUPDATE = new VESID (GROUP_ID,
                                                                           "cataloguepricingupdate",
                                                                           VERSION_21);
  public static final VESID VID_UBL_21_CATALOGUEREQUEST = new VESID (GROUP_ID, "cataloguerequest", VERSION_21);
  public static final VESID VID_UBL_21_CERTIFICATEOFORIGIN = new VESID (GROUP_ID, "certificateoforigin", VERSION_21);
  public static final VESID VID_UBL_21_CONTRACTAWARDNOTICE = new VESID (GROUP_ID, "contractawardnotice", VERSION_21);
  public static final VESID VID_UBL_21_CONTRACTNOTICE = new VESID (GROUP_ID, "contractnotice", VERSION_21);
  public static final VESID VID_UBL_21_CREDITNOTE = new VESID (GROUP_ID, "creditnote", VERSION_21);
  public static final VESID VID_UBL_21_DEBITNOTE = new VESID (GROUP_ID, "debitnote", VERSION_21);
  public static final VESID VID_UBL_21_DESPATCHADVICE = new VESID (GROUP_ID, "despatchadvice", VERSION_21);
  public static final VESID VID_UBL_21_DOCUMENTSTATUS = new VESID (GROUP_ID, "documentstatus", VERSION_21);
  public static final VESID VID_UBL_21_DOCUMENTSTATUSREQUEST = new VESID (GROUP_ID,
                                                                          "documentstatusrequest",
                                                                          VERSION_21);
  public static final VESID VID_UBL_21_EXCEPTIONCRITERIA = new VESID (GROUP_ID, "exceptioncriteria", VERSION_21);
  public static final VESID VID_UBL_21_EXCEPTIONNOTIFICATION = new VESID (GROUP_ID,
                                                                          "exceptionnotification",
                                                                          VERSION_21);
  public static final VESID VID_UBL_21_FORECAST = new VESID (GROUP_ID, "forecast", VERSION_21);
  public static final VESID VID_UBL_21_FORECASTREVISION = new VESID (GROUP_ID, "forecastrevision", VERSION_21);
  public static final VESID VID_UBL_21_FORWARDINGINSTRUCTIONS = new VESID (GROUP_ID,
                                                                           "forwardinginstructions",
                                                                           VERSION_21);
  public static final VESID VID_UBL_21_FREIGHTINVOICE = new VESID (GROUP_ID, "freightinvoice", VERSION_21);
  public static final VESID VID_UBL_21_FULFILMENTCANCELLATION = new VESID (GROUP_ID,
                                                                           "fulfilmentcancellation",
                                                                           VERSION_21);
  public static final VESID VID_UBL_21_GOODSITEMITINERARY = new VESID (GROUP_ID, "goodsitemitinerary", VERSION_21);
  public static final VESID VID_UBL_21_GUARANTEECERTIFICATE = new VESID (GROUP_ID, "guaranteecertificate", VERSION_21);
  public static final VESID VID_UBL_21_INSTRUCTIONFORRETURNS = new VESID (GROUP_ID,
                                                                          "instructionforreturns",
                                                                          VERSION_21);
  public static final VESID VID_UBL_21_INVENTORYREPORT = new VESID (GROUP_ID, "inventoryreport", VERSION_21);
  public static final VESID VID_UBL_21_INVOICE = new VESID (GROUP_ID, "invoice", VERSION_21);
  public static final VESID VID_UBL_21_ITEMINFORMATIONREQUEST = new VESID (GROUP_ID,
                                                                           "iteminformationrequest",
                                                                           VERSION_21);
  public static final VESID VID_UBL_21_ORDER = new VESID (GROUP_ID, "order", VERSION_21);
  public static final VESID VID_UBL_21_ORDERCANCELLATION = new VESID (GROUP_ID, "ordercancellation", VERSION_21);
  public static final VESID VID_UBL_21_ORDERCHANGE = new VESID (GROUP_ID, "orderchange", VERSION_21);
  public static final VESID VID_UBL_21_ORDERRESPONSE = new VESID (GROUP_ID, "orderresponse", VERSION_21);
  public static final VESID VID_UBL_21_ORDERRESPONSESIMPLE = new VESID (GROUP_ID, "orderresponsesimple", VERSION_21);
  public static final VESID VID_UBL_21_PACKINGLIST = new VESID (GROUP_ID, "packinglist", VERSION_21);
  public static final VESID VID_UBL_21_PRIORINFORMATIONNOTICE = new VESID (GROUP_ID,
                                                                           "priorinformationnotice",
                                                                           VERSION_21);
  public static final VESID VID_UBL_21_PRODUCTACTIVITY = new VESID (GROUP_ID, "productactivity", VERSION_21);
  public static final VESID VID_UBL_21_QUOTATION = new VESID (GROUP_ID, "quotation", VERSION_21);
  public static final VESID VID_UBL_21_RECEIPTADVICE = new VESID (GROUP_ID, "receiptadvice", VERSION_21);
  public static final VESID VID_UBL_21_REMINDER = new VESID (GROUP_ID, "reminder", VERSION_21);
  public static final VESID VID_UBL_21_REMITTANCEADVICE = new VESID (GROUP_ID, "remittanceadvice", VERSION_21);
  public static final VESID VID_UBL_21_REQUESTFORQUOTATION = new VESID (GROUP_ID, "requestforquotation", VERSION_21);
  public static final VESID VID_UBL_21_RETAILEVENT = new VESID (GROUP_ID, "retailevent", VERSION_21);
  public static final VESID VID_UBL_21_SELFBILLEDCREDITNOTE = new VESID (GROUP_ID, "selfbilledcreditnote", VERSION_21);
  public static final VESID VID_UBL_21_SELFBILLEDINVOICE = new VESID (GROUP_ID, "selfbilledinvoice", VERSION_21);
  public static final VESID VID_UBL_21_STATEMENT = new VESID (GROUP_ID, "statement", VERSION_21);
  public static final VESID VID_UBL_21_STOCKAVAILABILITYREPORT = new VESID (GROUP_ID,
                                                                            "stockavailabilityreport",
                                                                            VERSION_21);
  public static final VESID VID_UBL_21_TENDER = new VESID (GROUP_ID, "tender", VERSION_21);
  public static final VESID VID_UBL_21_TENDERERQUALIFICATION = new VESID (GROUP_ID,
                                                                          "tendererqualification",
                                                                          VERSION_21);
  public static final VESID VID_UBL_21_TENDERERQUALIFICATIONRESPONSE = new VESID (GROUP_ID,
                                                                                  "tendererqualificationresponse",
                                                                                  VERSION_21);
  public static final VESID VID_UBL_21_TENDERRECEIPT = new VESID (GROUP_ID, "tenderreceipt", VERSION_21);
  public static final VESID VID_UBL_21_TRADEITEMLOCATIONPROFILE = new VESID (GROUP_ID,
                                                                             "tradeitemlocationprofile",
                                                                             VERSION_21);
  public static final VESID VID_UBL_21_TRANSPORTATIONSTATUS = new VESID (GROUP_ID, "transportationstatus", VERSION_21);
  public static final VESID VID_UBL_21_TRANSPORTATIONSTATUSREQUEST = new VESID (GROUP_ID,
                                                                                "transportationstatusrequest",
                                                                                VERSION_21);
  public static final VESID VID_UBL_21_TRANSPORTEXECUTIONPLAN = new VESID (GROUP_ID,
                                                                           "transportexecutionplan",
                                                                           VERSION_21);
  public static final VESID VID_UBL_21_TRANSPORTEXECUTIONPLANREQUEST = new VESID (GROUP_ID,
                                                                                  "transportexecutionplanrequest",
                                                                                  VERSION_21);
  public static final VESID VID_UBL_21_TRANSPORTPROGRESSSTATUS = new VESID (GROUP_ID,
                                                                            "transportprogressstatus",
                                                                            VERSION_21);
  public static final VESID VID_UBL_21_TRANSPORTPROGRESSSTATUSREQUEST = new VESID (GROUP_ID,
                                                                                   "transportprogressstatusrequest",
                                                                                   VERSION_21);
  public static final VESID VID_UBL_21_TRANSPORTSERVICEDESCRIPTION = new VESID (GROUP_ID,
                                                                                "transportservicedescription",
                                                                                VERSION_21);
  public static final VESID VID_UBL_21_TRANSPORTSERVICEDESCRIPTIONREQUEST = new VESID (GROUP_ID,
                                                                                       "transportservicedescriptionrequest",
                                                                                       VERSION_21);
  public static final VESID VID_UBL_21_UNAWARDEDNOTIFICATION = new VESID (GROUP_ID,
                                                                          "unawardednotification",
                                                                          VERSION_21);
  public static final VESID VID_UBL_21_UTILITYSTATEMENT = new VESID (GROUP_ID, "utilitystatement", VERSION_21);
  public static final VESID VID_UBL_21_WAYBILL = new VESID (GROUP_ID, "waybill", VERSION_21);

  // UBL 2.2
  public static final VESID VID_UBL_22_APPLICATIONRESPONSE = new VESID (GROUP_ID, "applicationresponse", VERSION_22);
  public static final VESID VID_UBL_22_ATTACHEDDOCUMENT = new VESID (GROUP_ID, "attacheddocument", VERSION_22);
  public static final VESID VID_UBL_22_AWARDEDNOTIFICATION = new VESID (GROUP_ID, "awardednotification", VERSION_22);
  public static final VESID VID_UBL_22_BILLOFLADING = new VESID (GROUP_ID, "billoflading", VERSION_22);
  public static final VESID VID_UBL_22_BUSINESSCARD = new VESID (GROUP_ID, "businesscard", VERSION_22);
  public static final VESID VID_UBL_22_CALLFORTENDERS = new VESID (GROUP_ID, "callfortenders", VERSION_22);
  public static final VESID VID_UBL_22_CATALOGUE = new VESID (GROUP_ID, "catalogue", VERSION_22);
  public static final VESID VID_UBL_22_CATALOGUEDELETION = new VESID (GROUP_ID, "cataloguedeletion", VERSION_22);
  public static final VESID VID_UBL_22_CATALOGUEITEMSPECIFICATIONUPDATE = new VESID (GROUP_ID,
                                                                                     "catalogueitemspecificationupdate",
                                                                                     VERSION_22);
  public static final VESID VID_UBL_22_CATALOGUEPRICINGUPDATE = new VESID (GROUP_ID,
                                                                           "cataloguepricingupdate",
                                                                           VERSION_22);
  public static final VESID VID_UBL_22_CATALOGUEREQUEST = new VESID (GROUP_ID, "cataloguerequest", VERSION_22);
  public static final VESID VID_UBL_22_CERTIFICATEOFORIGIN = new VESID (GROUP_ID, "certificateoforigin", VERSION_22);
  public static final VESID VID_UBL_22_CONTRACTAWARDNOTICE = new VESID (GROUP_ID, "contractawardnotice", VERSION_22);
  public static final VESID VID_UBL_22_CONTRACTNOTICE = new VESID (GROUP_ID, "contractnotice", VERSION_22);
  public static final VESID VID_UBL_22_CREDITNOTE = new VESID (GROUP_ID, "creditnote", VERSION_22);
  public static final VESID VID_UBL_22_DEBITNOTE = new VESID (GROUP_ID, "debitnote", VERSION_22);
  public static final VESID VID_UBL_22_DESPATCHADVICE = new VESID (GROUP_ID, "despatchadvice", VERSION_22);
  public static final VESID VID_UBL_22_DIGITALAGREEMENT = new VESID (GROUP_ID, "digitalagreement", VERSION_22);
  public static final VESID VID_UBL_22_DIGITALCAPABILITY = new VESID (GROUP_ID, "digitalcapability", VERSION_22);
  public static final VESID VID_UBL_22_DOCUMENTSTATUS = new VESID (GROUP_ID, "documentstatus", VERSION_22);
  public static final VESID VID_UBL_22_DOCUMENTSTATUSREQUEST = new VESID (GROUP_ID,
                                                                          "documentstatusrequest",
                                                                          VERSION_22);
  public static final VESID VID_UBL_22_ENQUIRY = new VESID (GROUP_ID, "enquiry", VERSION_22);
  public static final VESID VID_UBL_22_ENQUIRYRESPONSE = new VESID (GROUP_ID, "enquiryresponse", VERSION_22);
  public static final VESID VID_UBL_22_EXCEPTIONCRITERIA = new VESID (GROUP_ID, "exceptioncriteria", VERSION_22);
  public static final VESID VID_UBL_22_EXCEPTIONNOTIFICATION = new VESID (GROUP_ID,
                                                                          "exceptionnotification",
                                                                          VERSION_22);
  public static final VESID VID_UBL_22_EXPRESSIONOFINTERESTREQUEST = new VESID (GROUP_ID,
                                                                                "expressionofinterestrequest",
                                                                                VERSION_22);
  public static final VESID VID_UBL_22_EXPRESSIONOFINTERESTRESPONSE = new VESID (GROUP_ID,
                                                                                 "expressionofinterestresponse",
                                                                                 VERSION_22);
  public static final VESID VID_UBL_22_FORECAST = new VESID (GROUP_ID, "forecast", VERSION_22);
  public static final VESID VID_UBL_22_FORECASTREVISION = new VESID (GROUP_ID, "forecastrevision", VERSION_22);
  public static final VESID VID_UBL_22_FORWARDINGINSTRUCTIONS = new VESID (GROUP_ID,
                                                                           "forwardinginstructions",
                                                                           VERSION_22);
  public static final VESID VID_UBL_22_FREIGHTINVOICE = new VESID (GROUP_ID, "freightinvoice", VERSION_22);
  public static final VESID VID_UBL_22_FULFILMENTCANCELLATION = new VESID (GROUP_ID,
                                                                           "fulfilmentcancellation",
                                                                           VERSION_22);
  public static final VESID VID_UBL_22_GOODSITEMITINERARY = new VESID (GROUP_ID, "goodsitemitinerary", VERSION_22);
  public static final VESID VID_UBL_22_GUARANTEECERTIFICATE = new VESID (GROUP_ID, "guaranteecertificate", VERSION_22);
  public static final VESID VID_UBL_22_INSTRUCTIONFORRETURNS = new VESID (GROUP_ID,
                                                                          "instructionforreturns",
                                                                          VERSION_22);
  public static final VESID VID_UBL_22_INVENTORYREPORT = new VESID (GROUP_ID, "inventoryreport", VERSION_22);
  public static final VESID VID_UBL_22_INVOICE = new VESID (GROUP_ID, "invoice", VERSION_22);
  public static final VESID VID_UBL_22_ITEMINFORMATIONREQUEST = new VESID (GROUP_ID,
                                                                           "iteminformationrequest",
                                                                           VERSION_22);
  public static final VESID VID_UBL_22_ORDER = new VESID (GROUP_ID, "order", VERSION_22);
  public static final VESID VID_UBL_22_ORDERCANCELLATION = new VESID (GROUP_ID, "ordercancellation", VERSION_22);
  public static final VESID VID_UBL_22_ORDERCHANGE = new VESID (GROUP_ID, "orderchange", VERSION_22);
  public static final VESID VID_UBL_22_ORDERRESPONSE = new VESID (GROUP_ID, "orderresponse", VERSION_22);
  public static final VESID VID_UBL_22_ORDERRESPONSESIMPLE = new VESID (GROUP_ID, "orderresponsesimple", VERSION_22);
  public static final VESID VID_UBL_22_PACKINGLIST = new VESID (GROUP_ID, "packinglist", VERSION_22);
  public static final VESID VID_UBL_22_PRIORINFORMATIONNOTICE = new VESID (GROUP_ID,
                                                                           "priorinformationnotice",
                                                                           VERSION_22);
  public static final VESID VID_UBL_22_PRODUCTACTIVITY = new VESID (GROUP_ID, "productactivity", VERSION_22);
  public static final VESID VID_UBL_22_QUALIFICATIONAPPLICATIONREQUEST = new VESID (GROUP_ID,
                                                                                    "qualificationapplicationrequest",
                                                                                    VERSION_22);
  public static final VESID VID_UBL_22_QUALIFICATIONAPPLICATIONRESPONSE = new VESID (GROUP_ID,
                                                                                     "qualificationapplicationresponse",
                                                                                     VERSION_22);
  public static final VESID VID_UBL_22_QUOTATION = new VESID (GROUP_ID, "quotation", VERSION_22);
  public static final VESID VID_UBL_22_RECEIPTADVICE = new VESID (GROUP_ID, "receiptadvice", VERSION_22);
  public static final VESID VID_UBL_22_REMINDER = new VESID (GROUP_ID, "reminder", VERSION_22);
  public static final VESID VID_UBL_22_REMITTANCEADVICE = new VESID (GROUP_ID, "remittanceadvice", VERSION_22);
  public static final VESID VID_UBL_22_REQUESTFORQUOTATION = new VESID (GROUP_ID, "requestforquotation", VERSION_22);
  public static final VESID VID_UBL_22_RETAILEVENT = new VESID (GROUP_ID, "retailevent", VERSION_22);
  public static final VESID VID_UBL_22_SELFBILLEDCREDITNOTE = new VESID (GROUP_ID, "selfbilledcreditnote", VERSION_22);
  public static final VESID VID_UBL_22_SELFBILLEDINVOICE = new VESID (GROUP_ID, "selfbilledinvoice", VERSION_22);
  public static final VESID VID_UBL_22_STATEMENT = new VESID (GROUP_ID, "statement", VERSION_22);
  public static final VESID VID_UBL_22_STOCKAVAILABILITYREPORT = new VESID (GROUP_ID,
                                                                            "stockavailabilityreport",
                                                                            VERSION_22);
  public static final VESID VID_UBL_22_TENDER = new VESID (GROUP_ID, "tender", VERSION_22);
  public static final VESID VID_UBL_22_TENDERCONTRACT = new VESID (GROUP_ID, "tendercontract", VERSION_22);
  public static final VESID VID_UBL_22_TENDERERQUALIFICATION = new VESID (GROUP_ID,
                                                                          "tendererqualification",
                                                                          VERSION_22);
  public static final VESID VID_UBL_22_TENDERERQUALIFICATIONRESPONSE = new VESID (GROUP_ID,
                                                                                  "tendererqualificationresponse",
                                                                                  VERSION_22);
  public static final VESID VID_UBL_22_TENDERRECEIPT = new VESID (GROUP_ID, "tenderreceipt", VERSION_22);
  public static final VESID VID_UBL_22_TENDERSTATUS = new VESID (GROUP_ID, "tenderstatus", VERSION_22);
  public static final VESID VID_UBL_22_TENDERSTATUSREQUEST = new VESID (GROUP_ID, "tenderstatusrequest", VERSION_22);
  public static final VESID VID_UBL_22_TENDERWITHDRAWAL = new VESID (GROUP_ID, "tenderwithdrawal", VERSION_22);
  public static final VESID VID_UBL_22_TRADEITEMLOCATIONPROFILE = new VESID (GROUP_ID,
                                                                             "tradeitemlocationprofile",
                                                                             VERSION_22);
  public static final VESID VID_UBL_22_TRANSPORTATIONSTATUS = new VESID (GROUP_ID, "transportationstatus", VERSION_22);
  public static final VESID VID_UBL_22_TRANSPORTATIONSTATUSREQUEST = new VESID (GROUP_ID,
                                                                                "transportationstatusrequest",
                                                                                VERSION_22);
  public static final VESID VID_UBL_22_TRANSPORTEXECUTIONPLAN = new VESID (GROUP_ID,
                                                                           "transportexecutionplan",
                                                                           VERSION_22);
  public static final VESID VID_UBL_22_TRANSPORTEXECUTIONPLANREQUEST = new VESID (GROUP_ID,
                                                                                  "transportexecutionplanrequest",
                                                                                  VERSION_22);
  public static final VESID VID_UBL_22_TRANSPORTPROGRESSSTATUS = new VESID (GROUP_ID,
                                                                            "transportprogressstatus",
                                                                            VERSION_22);
  public static final VESID VID_UBL_22_TRANSPORTPROGRESSSTATUSREQUEST = new VESID (GROUP_ID,
                                                                                   "transportprogressstatusrequest",
                                                                                   VERSION_22);
  public static final VESID VID_UBL_22_TRANSPORTSERVICEDESCRIPTION = new VESID (GROUP_ID,
                                                                                "transportservicedescription",
                                                                                VERSION_22);
  public static final VESID VID_UBL_22_TRANSPORTSERVICEDESCRIPTIONREQUEST = new VESID (GROUP_ID,
                                                                                       "transportservicedescriptionrequest",
                                                                                       VERSION_22);
  public static final VESID VID_UBL_22_UNAWARDEDNOTIFICATION = new VESID (GROUP_ID,
                                                                          "unawardednotification",
                                                                          VERSION_22);
  public static final VESID VID_UBL_22_UNSUBSCRIBEFROMPROCEDUREREQUEST = new VESID (GROUP_ID,
                                                                                    "unsubscribefromprocedurerequest",
                                                                                    VERSION_22);
  public static final VESID VID_UBL_22_UNSUBSCRIBEFROMPROCEDURERESPONSE = new VESID (GROUP_ID,
                                                                                     "unsubscribefromprocedureresponse",
                                                                                     VERSION_22);
  public static final VESID VID_UBL_22_UTILITYSTATEMENT = new VESID (GROUP_ID, "utilitystatement", VERSION_22);
  public static final VESID VID_UBL_22_WAYBILL = new VESID (GROUP_ID, "waybill", VERSION_22);
  public static final VESID VID_UBL_22_WEIGHTSTATEMENT = new VESID (GROUP_ID, "weightstatement", VERSION_22);

  // UBL 2.3
  public static final VESID VID_UBL_23_APPLICATIONRESPONSE = new VESID (GROUP_ID, "applicationresponse", VERSION_23);
  public static final VESID VID_UBL_23_ATTACHEDDOCUMENT = new VESID (GROUP_ID, "attacheddocument", VERSION_23);
  public static final VESID VID_UBL_23_AWARDEDNOTIFICATION = new VESID (GROUP_ID, "awardednotification", VERSION_23);
  public static final VESID VID_UBL_23_BILLOFLADING = new VESID (GROUP_ID, "billoflading", VERSION_23);
  public static final VESID VID_UBL_23_BUSINESSCARD = new VESID (GROUP_ID, "businesscard", VERSION_23);
  public static final VESID VID_UBL_23_CALLFORTENDERS = new VESID (GROUP_ID, "callfortenders", VERSION_23);
  public static final VESID VID_UBL_23_CATALOGUE = new VESID (GROUP_ID, "catalogue", VERSION_23);
  public static final VESID VID_UBL_23_CATALOGUEDELETION = new VESID (GROUP_ID, "cataloguedeletion", VERSION_23);
  public static final VESID VID_UBL_23_CATALOGUEITEMSPECIFICATIONUPDATE = new VESID (GROUP_ID,
                                                                                     "catalogueitemspecificationupdate",
                                                                                     VERSION_23);
  public static final VESID VID_UBL_23_CATALOGUEPRICINGUPDATE = new VESID (GROUP_ID,
                                                                           "cataloguepricingupdate",
                                                                           VERSION_23);
  public static final VESID VID_UBL_23_CATALOGUEREQUEST = new VESID (GROUP_ID, "cataloguerequest", VERSION_23);
  public static final VESID VID_UBL_23_CERTIFICATEOFORIGIN = new VESID (GROUP_ID, "certificateoforigin", VERSION_23);
  public static final VESID VID_UBL_23_COMMONTRANSPORTATIONREPORT = new VESID (GROUP_ID,
                                                                               "commontransportationreport",
                                                                               VERSION_23);
  public static final VESID VID_UBL_23_CONTRACTAWARDNOTICE = new VESID (GROUP_ID, "contractawardnotice", VERSION_23);
  public static final VESID VID_UBL_23_CONTRACTNOTICE = new VESID (GROUP_ID, "contractnotice", VERSION_23);
  public static final VESID VID_UBL_23_CREDITNOTE = new VESID (GROUP_ID, "creditnote", VERSION_23);
  public static final VESID VID_UBL_23_DEBITNOTE = new VESID (GROUP_ID, "debitnote", VERSION_23);
  public static final VESID VID_UBL_23_DESPATCHADVICE = new VESID (GROUP_ID, "despatchadvice", VERSION_23);
  public static final VESID VID_UBL_23_DIGITALAGREEMENT = new VESID (GROUP_ID, "digitalagreement", VERSION_23);
  public static final VESID VID_UBL_23_DIGITALCAPABILITY = new VESID (GROUP_ID, "digitalcapability", VERSION_23);
  public static final VESID VID_UBL_23_DOCUMENTSTATUS = new VESID (GROUP_ID, "documentstatus", VERSION_23);
  public static final VESID VID_UBL_23_DOCUMENTSTATUSREQUEST = new VESID (GROUP_ID,
                                                                          "documentstatusrequest",
                                                                          VERSION_23);
  public static final VESID VID_UBL_23_ENQUIRY = new VESID (GROUP_ID, "enquiry", VERSION_23);
  public static final VESID VID_UBL_23_ENQUIRYRESPONSE = new VESID (GROUP_ID, "enquiryresponse", VERSION_23);
  public static final VESID VID_UBL_23_EXCEPTIONCRITERIA = new VESID (GROUP_ID, "exceptioncriteria", VERSION_23);
  public static final VESID VID_UBL_23_EXCEPTIONNOTIFICATION = new VESID (GROUP_ID,
                                                                          "exceptionnotification",
                                                                          VERSION_23);
  public static final VESID VID_UBL_23_EXPORTCUSTOMSDECLARATION = new VESID (GROUP_ID,
                                                                             "exportcustomsdeclaration",
                                                                             VERSION_23);
  public static final VESID VID_UBL_23_EXPRESSIONOFINTERESTREQUEST = new VESID (GROUP_ID,
                                                                                "expressionofinterestrequest",
                                                                                VERSION_23);
  public static final VESID VID_UBL_23_EXPRESSIONOFINTERESTRESPONSE = new VESID (GROUP_ID,
                                                                                 "expressionofinterestresponse",
                                                                                 VERSION_23);
  public static final VESID VID_UBL_23_FORECAST = new VESID (GROUP_ID, "forecast", VERSION_23);
  public static final VESID VID_UBL_23_FORECASTREVISION = new VESID (GROUP_ID, "forecastrevision", VERSION_23);
  public static final VESID VID_UBL_23_FORWARDINGINSTRUCTIONS = new VESID (GROUP_ID,
                                                                           "forwardinginstructions",
                                                                           VERSION_23);
  public static final VESID VID_UBL_23_FREIGHTINVOICE = new VESID (GROUP_ID, "freightinvoice", VERSION_23);
  public static final VESID VID_UBL_23_FULFILMENTCANCELLATION = new VESID (GROUP_ID,
                                                                           "fulfilmentcancellation",
                                                                           VERSION_23);
  public static final VESID VID_UBL_23_GOODSCERTIFICATE = new VESID (GROUP_ID, "goodscertificate", VERSION_23);
  public static final VESID VID_UBL_23_GOODSITEMITINERARY = new VESID (GROUP_ID, "goodsitemitinerary", VERSION_23);
  public static final VESID VID_UBL_23_GOODSITEMPASSPORT = new VESID (GROUP_ID, "goodsitempassport", VERSION_23);
  public static final VESID VID_UBL_23_GUARANTEECERTIFICATE = new VESID (GROUP_ID, "guaranteecertificate", VERSION_23);
  public static final VESID VID_UBL_23_IMPORTCUSTOMSDECLARATION = new VESID (GROUP_ID,
                                                                             "importcustomsdeclaration",
                                                                             VERSION_23);
  public static final VESID VID_UBL_23_INSTRUCTIONFORRETURNS = new VESID (GROUP_ID,
                                                                          "instructionforreturns",
                                                                          VERSION_23);
  public static final VESID VID_UBL_23_INVENTORYREPORT = new VESID (GROUP_ID, "inventoryreport", VERSION_23);
  public static final VESID VID_UBL_23_INVOICE = new VESID (GROUP_ID, "invoice", VERSION_23);
  public static final VESID VID_UBL_23_ITEMINFORMATIONREQUEST = new VESID (GROUP_ID,
                                                                           "iteminformationrequest",
                                                                           VERSION_23);
  public static final VESID VID_UBL_23_MANIFEST = new VESID (GROUP_ID, "manifest", VERSION_23);
  public static final VESID VID_UBL_23_ORDER = new VESID (GROUP_ID, "order", VERSION_23);
  public static final VESID VID_UBL_23_ORDERCANCELLATION = new VESID (GROUP_ID, "ordercancellation", VERSION_23);
  public static final VESID VID_UBL_23_ORDERCHANGE = new VESID (GROUP_ID, "orderchange", VERSION_23);
  public static final VESID VID_UBL_23_ORDERRESPONSE = new VESID (GROUP_ID, "orderresponse", VERSION_23);
  public static final VESID VID_UBL_23_ORDERRESPONSESIMPLE = new VESID (GROUP_ID, "orderresponsesimple", VERSION_23);
  public static final VESID VID_UBL_23_PACKINGLIST = new VESID (GROUP_ID, "packinglist", VERSION_23);
  public static final VESID VID_UBL_23_PRIORINFORMATIONNOTICE = new VESID (GROUP_ID,
                                                                           "priorinformationnotice",
                                                                           VERSION_23);
  public static final VESID VID_UBL_23_PRODUCTACTIVITY = new VESID (GROUP_ID, "productactivity", VERSION_23);
  public static final VESID VID_UBL_23_PROOFOFREEXPORTATION = new VESID (GROUP_ID, "proofofreexportation", VERSION_23);
  public static final VESID VID_UBL_23_PROOFOFREEXPORTATIONREMINDER = new VESID (GROUP_ID,
                                                                                 "proofofreexportationreminder",
                                                                                 VERSION_23);
  public static final VESID VID_UBL_23_PROOFOFREEXPORTATIONREQUEST = new VESID (GROUP_ID,
                                                                                "proofofreexportationrequest",
                                                                                VERSION_23);
  public static final VESID VID_UBL_23_QUALIFICATIONAPPLICATIONREQUEST = new VESID (GROUP_ID,
                                                                                    "qualificationapplicationrequest",
                                                                                    VERSION_23);
  public static final VESID VID_UBL_23_QUALIFICATIONAPPLICATIONRESPONSE = new VESID (GROUP_ID,
                                                                                     "qualificationapplicationresponse",
                                                                                     VERSION_23);
  public static final VESID VID_UBL_23_QUOTATION = new VESID (GROUP_ID, "quotation", VERSION_23);
  public static final VESID VID_UBL_23_RECEIPTADVICE = new VESID (GROUP_ID, "receiptadvice", VERSION_23);
  public static final VESID VID_UBL_23_REMINDER = new VESID (GROUP_ID, "reminder", VERSION_23);
  public static final VESID VID_UBL_23_REMITTANCEADVICE = new VESID (GROUP_ID, "remittanceadvice", VERSION_23);
  public static final VESID VID_UBL_23_REQUESTFORQUOTATION = new VESID (GROUP_ID, "requestforquotation", VERSION_23);
  public static final VESID VID_UBL_23_RETAILEVENT = new VESID (GROUP_ID, "retailevent", VERSION_23);
  public static final VESID VID_UBL_23_SELFBILLEDCREDITNOTE = new VESID (GROUP_ID, "selfbilledcreditnote", VERSION_23);
  public static final VESID VID_UBL_23_SELFBILLEDINVOICE = new VESID (GROUP_ID, "selfbilledinvoice", VERSION_23);
  public static final VESID VID_UBL_23_STATEMENT = new VESID (GROUP_ID, "statement", VERSION_23);
  public static final VESID VID_UBL_23_STOCKAVAILABILITYREPORT = new VESID (GROUP_ID,
                                                                            "stockavailabilityreport",
                                                                            VERSION_23);
  public static final VESID VID_UBL_23_TENDER = new VESID (GROUP_ID, "tender", VERSION_23);
  public static final VESID VID_UBL_23_TENDERCONTRACT = new VESID (GROUP_ID, "tendercontract", VERSION_23);
  public static final VESID VID_UBL_23_TENDERERQUALIFICATION = new VESID (GROUP_ID,
                                                                          "tendererqualification",
                                                                          VERSION_23);
  public static final VESID VID_UBL_23_TENDERERQUALIFICATIONRESPONSE = new VESID (GROUP_ID,
                                                                                  "tendererqualificationresponse",
                                                                                  VERSION_23);
  public static final VESID VID_UBL_23_TENDERRECEIPT = new VESID (GROUP_ID, "tenderreceipt", VERSION_23);
  public static final VESID VID_UBL_23_TENDERSTATUS = new VESID (GROUP_ID, "tenderstatus", VERSION_23);
  public static final VESID VID_UBL_23_TENDERSTATUSREQUEST = new VESID (GROUP_ID, "tenderstatusrequest", VERSION_23);
  public static final VESID VID_UBL_23_TENDERWITHDRAWAL = new VESID (GROUP_ID, "tenderwithdrawal", VERSION_23);
  public static final VESID VID_UBL_23_TRADEITEMLOCATIONPROFILE = new VESID (GROUP_ID,
                                                                             "tradeitemlocationprofile",
                                                                             VERSION_23);
  public static final VESID VID_UBL_23_TRANSITCUSTOMSDECLARATION = new VESID (GROUP_ID,
                                                                              "transitcustomsdeclaration",
                                                                              VERSION_23);
  public static final VESID VID_UBL_23_TRANSPORTATIONSTATUS = new VESID (GROUP_ID, "transportationstatus", VERSION_23);
  public static final VESID VID_UBL_23_TRANSPORTATIONSTATUSREQUEST = new VESID (GROUP_ID,
                                                                                "transportationstatusrequest",
                                                                                VERSION_23);
  public static final VESID VID_UBL_23_TRANSPORTEXECUTIONPLAN = new VESID (GROUP_ID,
                                                                           "transportexecutionplan",
                                                                           VERSION_23);
  public static final VESID VID_UBL_23_TRANSPORTEXECUTIONPLANREQUEST = new VESID (GROUP_ID,
                                                                                  "transportexecutionplanrequest",
                                                                                  VERSION_23);
  public static final VESID VID_UBL_23_TRANSPORTPROGRESSSTATUS = new VESID (GROUP_ID,
                                                                            "transportprogressstatus",
                                                                            VERSION_23);
  public static final VESID VID_UBL_23_TRANSPORTPROGRESSSTATUSREQUEST = new VESID (GROUP_ID,
                                                                                   "transportprogressstatusrequest",
                                                                                   VERSION_23);
  public static final VESID VID_UBL_23_TRANSPORTSERVICEDESCRIPTION = new VESID (GROUP_ID,
                                                                                "transportservicedescription",
                                                                                VERSION_23);
  public static final VESID VID_UBL_23_TRANSPORTSERVICEDESCRIPTIONREQUEST = new VESID (GROUP_ID,
                                                                                       "transportservicedescriptionrequest",
                                                                                       VERSION_23);
  public static final VESID VID_UBL_23_UNAWARDEDNOTIFICATION = new VESID (GROUP_ID,
                                                                          "unawardednotification",
                                                                          VERSION_23);
  public static final VESID VID_UBL_23_UNSUBSCRIBEFROMPROCEDUREREQUEST = new VESID (GROUP_ID,
                                                                                    "unsubscribefromprocedurerequest",
                                                                                    VERSION_23);
  public static final VESID VID_UBL_23_UNSUBSCRIBEFROMPROCEDURERESPONSE = new VESID (GROUP_ID,
                                                                                     "unsubscribefromprocedureresponse",
                                                                                     VERSION_23);
  public static final VESID VID_UBL_23_UTILITYSTATEMENT = new VESID (GROUP_ID, "utilitystatement", VERSION_23);
  public static final VESID VID_UBL_23_WAYBILL = new VESID (GROUP_ID, "waybill", VERSION_23);
  public static final VESID VID_UBL_23_WEIGHTSTATEMENT = new VESID (GROUP_ID, "weightstatement", VERSION_23);

  // UBL 2.4
  public static final VESID VID_UBL_24_APPLICATIONRESPONSE = new VESID (GROUP_ID, "applicationresponse", VERSION_24);
  public static final VESID VID_UBL_24_ATTACHEDDOCUMENT = new VESID (GROUP_ID, "attacheddocument", VERSION_24);
  public static final VESID VID_UBL_24_AWARDEDNOTIFICATION = new VESID (GROUP_ID, "awardednotification", VERSION_24);
  public static final VESID VID_UBL_24_BILLOFLADING = new VESID (GROUP_ID, "billoflading", VERSION_24);
  public static final VESID VID_UBL_24_BUSINESSCARD = new VESID (GROUP_ID, "businesscard", VERSION_24);
  public static final VESID VID_UBL_24_BUSINESSINFORMATION = new VESID (GROUP_ID, "businessinformation", VERSION_24);
  public static final VESID VID_UBL_24_CALLFORTENDERS = new VESID (GROUP_ID, "callfortenders", VERSION_24);
  public static final VESID VID_UBL_24_CATALOGUE = new VESID (GROUP_ID, "catalogue", VERSION_24);
  public static final VESID VID_UBL_24_CATALOGUEDELETION = new VESID (GROUP_ID, "cataloguedeletion", VERSION_24);
  public static final VESID VID_UBL_24_CATALOGUEITEMSPECIFICATIONUPDATE = new VESID (GROUP_ID,
                                                                                     "catalogueitemspecificationupdate",
                                                                                     VERSION_24);
  public static final VESID VID_UBL_24_CATALOGUEPRICINGUPDATE = new VESID (GROUP_ID,
                                                                           "cataloguepricingupdate",
                                                                           VERSION_24);
  public static final VESID VID_UBL_24_CATALOGUEREQUEST = new VESID (GROUP_ID, "cataloguerequest", VERSION_24);
  public static final VESID VID_UBL_24_CERTIFICATEOFORIGIN = new VESID (GROUP_ID, "certificateoforigin", VERSION_24);
  public static final VESID VID_UBL_24_COMMONTRANSPORTATIONREPORT = new VESID (GROUP_ID,
                                                                               "commontransportationreport",
                                                                               VERSION_24);
  public static final VESID VID_UBL_24_CONTRACTAWARDNOTICE = new VESID (GROUP_ID, "contractawardnotice", VERSION_24);
  public static final VESID VID_UBL_24_CONTRACTNOTICE = new VESID (GROUP_ID, "contractnotice", VERSION_24);
  public static final VESID VID_UBL_24_CREDITNOTE = new VESID (GROUP_ID, "creditnote", VERSION_24);
  public static final VESID VID_UBL_24_DEBITNOTE = new VESID (GROUP_ID, "debitnote", VERSION_24);
  public static final VESID VID_UBL_24_DESPATCHADVICE = new VESID (GROUP_ID, "despatchadvice", VERSION_24);
  public static final VESID VID_UBL_24_DIGITALAGREEMENT = new VESID (GROUP_ID, "digitalagreement", VERSION_24);
  public static final VESID VID_UBL_24_DIGITALCAPABILITY = new VESID (GROUP_ID, "digitalcapability", VERSION_24);
  public static final VESID VID_UBL_24_DOCUMENTSTATUS = new VESID (GROUP_ID, "documentstatus", VERSION_24);
  public static final VESID VID_UBL_24_DOCUMENTSTATUSREQUEST = new VESID (GROUP_ID,
                                                                          "documentstatusrequest",
                                                                          VERSION_24);
  public static final VESID VID_UBL_24_ENQUIRY = new VESID (GROUP_ID, "enquiry", VERSION_24);
  public static final VESID VID_UBL_24_ENQUIRYRESPONSE = new VESID (GROUP_ID, "enquiryresponse", VERSION_24);
  public static final VESID VID_UBL_24_EXCEPTIONCRITERIA = new VESID (GROUP_ID, "exceptioncriteria", VERSION_24);
  public static final VESID VID_UBL_24_EXCEPTIONNOTIFICATION = new VESID (GROUP_ID,
                                                                          "exceptionnotification",
                                                                          VERSION_24);
  public static final VESID VID_UBL_24_EXPORTCUSTOMSDECLARATION = new VESID (GROUP_ID,
                                                                             "exportcustomsdeclaration",
                                                                             VERSION_24);
  public static final VESID VID_UBL_24_EXPRESSIONOFINTERESTREQUEST = new VESID (GROUP_ID,
                                                                                "expressionofinterestrequest",
                                                                                VERSION_24);
  public static final VESID VID_UBL_24_EXPRESSIONOFINTERESTRESPONSE = new VESID (GROUP_ID,
                                                                                 "expressionofinterestresponse",
                                                                                 VERSION_24);
  public static final VESID VID_UBL_24_FORECAST = new VESID (GROUP_ID, "forecast", VERSION_24);
  public static final VESID VID_UBL_24_FORECASTREVISION = new VESID (GROUP_ID, "forecastrevision", VERSION_24);
  public static final VESID VID_UBL_24_FORWARDINGINSTRUCTIONS = new VESID (GROUP_ID,
                                                                           "forwardinginstructions",
                                                                           VERSION_24);
  public static final VESID VID_UBL_24_FREIGHTINVOICE = new VESID (GROUP_ID, "freightinvoice", VERSION_24);
  public static final VESID VID_UBL_24_FULFILMENTCANCELLATION = new VESID (GROUP_ID,
                                                                           "fulfilmentcancellation",
                                                                           VERSION_24);
  public static final VESID VID_UBL_24_GOODSCERTIFICATE = new VESID (GROUP_ID, "goodscertificate", VERSION_24);
  public static final VESID VID_UBL_24_GOODSITEMITINERARY = new VESID (GROUP_ID, "goodsitemitinerary", VERSION_24);
  public static final VESID VID_UBL_24_GOODSITEMPASSPORT = new VESID (GROUP_ID, "goodsitempassport", VERSION_24);
  public static final VESID VID_UBL_24_GUARANTEECERTIFICATE = new VESID (GROUP_ID, "guaranteecertificate", VERSION_24);
  public static final VESID VID_UBL_24_IMPORTCUSTOMSDECLARATION = new VESID (GROUP_ID,
                                                                             "importcustomsdeclaration",
                                                                             VERSION_24);
  public static final VESID VID_UBL_24_INSTRUCTIONFORRETURNS = new VESID (GROUP_ID,
                                                                          "instructionforreturns",
                                                                          VERSION_24);
  public static final VESID VID_UBL_24_INVENTORYREPORT = new VESID (GROUP_ID, "inventoryreport", VERSION_24);
  public static final VESID VID_UBL_24_INVOICE = new VESID (GROUP_ID, "invoice", VERSION_24);
  public static final VESID VID_UBL_24_ITEMINFORMATIONREQUEST = new VESID (GROUP_ID,
                                                                           "iteminformationrequest",
                                                                           VERSION_24);
  public static final VESID VID_UBL_24_MANIFEST = new VESID (GROUP_ID, "manifest", VERSION_24);
  public static final VESID VID_UBL_24_ORDER = new VESID (GROUP_ID, "order", VERSION_24);
  public static final VESID VID_UBL_24_ORDERCANCELLATION = new VESID (GROUP_ID, "ordercancellation", VERSION_24);
  public static final VESID VID_UBL_24_ORDERCHANGE = new VESID (GROUP_ID, "orderchange", VERSION_24);
  public static final VESID VID_UBL_24_ORDERRESPONSE = new VESID (GROUP_ID, "orderresponse", VERSION_24);
  public static final VESID VID_UBL_24_ORDERRESPONSESIMPLE = new VESID (GROUP_ID, "orderresponsesimple", VERSION_24);
  public static final VESID VID_UBL_24_PACKINGLIST = new VESID (GROUP_ID, "packinglist", VERSION_24);
  public static final VESID VID_UBL_24_PRIORINFORMATIONNOTICE = new VESID (GROUP_ID,
                                                                           "priorinformationnotice",
                                                                           VERSION_24);
  public static final VESID VID_UBL_24_PRODUCTACTIVITY = new VESID (GROUP_ID, "productactivity", VERSION_24);
  public static final VESID VID_UBL_24_PROOFOFREEXPORTATION = new VESID (GROUP_ID, "proofofreexportation", VERSION_24);
  public static final VESID VID_UBL_24_PROOFOFREEXPORTATIONREMINDER = new VESID (GROUP_ID,
                                                                                 "proofofreexportationreminder",
                                                                                 VERSION_24);
  public static final VESID VID_UBL_24_PROOFOFREEXPORTATIONREQUEST = new VESID (GROUP_ID,
                                                                                "proofofreexportationrequest",
                                                                                VERSION_24);
  public static final VESID VID_UBL_24_PURCHASERECEIPT = new VESID (GROUP_ID, "purchasereceipt", VERSION_24);
  public static final VESID VID_UBL_24_QUALIFICATIONAPPLICATIONREQUEST = new VESID (GROUP_ID,
                                                                                    "qualificationapplicationrequest",
                                                                                    VERSION_24);
  public static final VESID VID_UBL_24_QUALIFICATIONAPPLICATIONRESPONSE = new VESID (GROUP_ID,
                                                                                     "qualificationapplicationresponse",
                                                                                     VERSION_24);
  public static final VESID VID_UBL_24_QUOTATION = new VESID (GROUP_ID, "quotation", VERSION_24);
  public static final VESID VID_UBL_24_RECEIPTADVICE = new VESID (GROUP_ID, "receiptadvice", VERSION_24);
  public static final VESID VID_UBL_24_REMINDER = new VESID (GROUP_ID, "reminder", VERSION_24);
  public static final VESID VID_UBL_24_REMITTANCEADVICE = new VESID (GROUP_ID, "remittanceadvice", VERSION_24);
  public static final VESID VID_UBL_24_REQUESTFORQUOTATION = new VESID (GROUP_ID, "requestforquotation", VERSION_24);
  public static final VESID VID_UBL_24_RETAILEVENT = new VESID (GROUP_ID, "retailevent", VERSION_24);
  public static final VESID VID_UBL_24_SELFBILLEDCREDITNOTE = new VESID (GROUP_ID, "selfbilledcreditnote", VERSION_24);
  public static final VESID VID_UBL_24_SELFBILLEDINVOICE = new VESID (GROUP_ID, "selfbilledinvoice", VERSION_24);
  public static final VESID VID_UBL_24_STATEMENT = new VESID (GROUP_ID, "statement", VERSION_24);
  public static final VESID VID_UBL_24_STOCKAVAILABILITYREPORT = new VESID (GROUP_ID,
                                                                            "stockavailabilityreport",
                                                                            VERSION_24);
  public static final VESID VID_UBL_24_TENDER = new VESID (GROUP_ID, "tender", VERSION_24);
  public static final VESID VID_UBL_24_TENDERCONTRACT = new VESID (GROUP_ID, "tendercontract", VERSION_24);
  public static final VESID VID_UBL_24_TENDERERQUALIFICATION = new VESID (GROUP_ID,
                                                                          "tendererqualification",
                                                                          VERSION_24);
  public static final VESID VID_UBL_24_TENDERERQUALIFICATIONRESPONSE = new VESID (GROUP_ID,
                                                                                  "tendererqualificationresponse",
                                                                                  VERSION_24);
  public static final VESID VID_UBL_24_TENDERRECEIPT = new VESID (GROUP_ID, "tenderreceipt", VERSION_24);
  public static final VESID VID_UBL_24_TENDERSTATUS = new VESID (GROUP_ID, "tenderstatus", VERSION_24);
  public static final VESID VID_UBL_24_TENDERSTATUSREQUEST = new VESID (GROUP_ID, "tenderstatusrequest", VERSION_24);
  public static final VESID VID_UBL_24_TENDERWITHDRAWAL = new VESID (GROUP_ID, "tenderwithdrawal", VERSION_24);
  public static final VESID VID_UBL_24_TRADEITEMLOCATIONPROFILE = new VESID (GROUP_ID,
                                                                             "tradeitemlocationprofile",
                                                                             VERSION_24);
  public static final VESID VID_UBL_24_TRANSITCUSTOMSDECLARATION = new VESID (GROUP_ID,
                                                                              "transitcustomsdeclaration",
                                                                              VERSION_24);
  public static final VESID VID_UBL_24_TRANSPORTATIONSTATUS = new VESID (GROUP_ID, "transportationstatus", VERSION_24);
  public static final VESID VID_UBL_24_TRANSPORTATIONSTATUSREQUEST = new VESID (GROUP_ID,
                                                                                "transportationstatusrequest",
                                                                                VERSION_24);
  public static final VESID VID_UBL_24_TRANSPORTEXECUTIONPLAN = new VESID (GROUP_ID,
                                                                           "transportexecutionplan",
                                                                           VERSION_24);
  public static final VESID VID_UBL_24_TRANSPORTEXECUTIONPLANREQUEST = new VESID (GROUP_ID,
                                                                                  "transportexecutionplanrequest",
                                                                                  VERSION_24);
  public static final VESID VID_UBL_24_TRANSPORTPROGRESSSTATUS = new VESID (GROUP_ID,
                                                                            "transportprogressstatus",
                                                                            VERSION_24);
  public static final VESID VID_UBL_24_TRANSPORTPROGRESSSTATUSREQUEST = new VESID (GROUP_ID,
                                                                                   "transportprogressstatusrequest",
                                                                                   VERSION_24);
  public static final VESID VID_UBL_24_TRANSPORTSERVICEDESCRIPTION = new VESID (GROUP_ID,
                                                                                "transportservicedescription",
                                                                                VERSION_24);
  public static final VESID VID_UBL_24_TRANSPORTSERVICEDESCRIPTIONREQUEST = new VESID (GROUP_ID,
                                                                                       "transportservicedescriptionrequest",
                                                                                       VERSION_24);
  public static final VESID VID_UBL_24_UNAWARDEDNOTIFICATION = new VESID (GROUP_ID,
                                                                          "unawardednotification",
                                                                          VERSION_24);
  public static final VESID VID_UBL_24_UNSUBSCRIBEFROMPROCEDUREREQUEST = new VESID (GROUP_ID,
                                                                                    "unsubscribefromprocedurerequest",
                                                                                    VERSION_24);
  public static final VESID VID_UBL_24_UNSUBSCRIBEFROMPROCEDURERESPONSE = new VESID (GROUP_ID,
                                                                                     "unsubscribefromprocedureresponse",
                                                                                     VERSION_24);
  public static final VESID VID_UBL_24_UTILITYSTATEMENT = new VESID (GROUP_ID, "utilitystatement", VERSION_24);
  public static final VESID VID_UBL_24_WAYBILL = new VESID (GROUP_ID, "waybill", VERSION_24);
  public static final VESID VID_UBL_24_WEIGHTSTATEMENT = new VESID (GROUP_ID, "weightstatement", VERSION_24);

  private UBLValidation ()
  {}

  @Nonnull
  private static IValidationExecutorSetStatus _createStatus (final boolean bIsDeprecated)
  {
    return ValidationExecutorSetStatus.createDeprecatedNow (bIsDeprecated);
  }

  /**
   * Register all standard UBL validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   * @since 5.1.15
   */
  public static void initUBLAllVersions (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    initUBL20 (aRegistry);
    initUBL21 (aRegistry);
    initUBL22 (aRegistry);
    initUBL23 (aRegistry);
    initUBL24 (aRegistry);
  }

  /**
   * Register all standard UBL 2.0 validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initUBL20 (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL20NamespaceContext.getInstance ());

    final boolean bNotDeprecated = false;

    // No Schematrons here
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_APPLICATIONRESPONSE,
                                                                           "UBL Application Response " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllApplicationResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_ATTACHEDDOCUMENT,
                                                                           "UBL Attached Document " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllAttachedDocumentXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_BILLOFLADING,
                                                                           "UBL Bill Of Lading " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllBillOfLadingXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_CATALOGUE,
                                                                           "UBL Catalogue " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllCatalogueXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_CATALOGUEDELETION,
                                                                           "UBL Catalogue Deletion " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllCatalogueDeletionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_CATALOGUEITEMSPECIFICATIONUPDATE,
                                                                           "UBL Catalogue Item Specification Update " +
                                                                                                                        VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_CATALOGUEPRICINGUPDATE,
                                                                           "UBL Catalogue Pricing Update " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllCataloguePricingUpdateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_CATALOGUEREQUEST,
                                                                           "UBL Catalogue Request " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllCatalogueRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_CERTIFICATEOFORIGIN,
                                                                           "UBL Certificate Of Origin " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllCertificateOfOriginXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_CREDITNOTE,
                                                                           "UBL Credit Note " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllCreditNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_DEBITNOTE,
                                                                           "UBL Debit Note " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllDebitNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_DESPATCHADVICE,
                                                                           "UBL Despatch Advice " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllDespatchAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_FORWARDINGINSTRUCTIONS,
                                                                           "UBL Forwarding Instructions " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllForwardingInstructionsXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_FREIGHTINVOICE,
                                                                           "UBL Freight Invoice " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllFreightInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_INVOICE,
                                                                           "UBL Invoice " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_ORDER,
                                                                           "UBL Order " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllOrderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_ORDERCANCELLATION,
                                                                           "UBL Order Cancellation " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllOrderCancellationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_ORDERCHANGE,
                                                                           "UBL Order Change " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllOrderChangeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_ORDERRESPONSE,
                                                                           "UBL Order Response " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllOrderResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_ORDERRESPONSESIMPLE,
                                                                           "UBL Order Response Simple " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllOrderResponseSimpleXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_PACKINGLIST,
                                                                           "UBL Packing List " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllPackingListXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_QUOTATION,
                                                                           "UBL Quotation " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllQuotationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_RECEIPTADVICE,
                                                                           "UBL Receipt Advice " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllReceiptAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_REMINDER,
                                                                           "UBL Reminder " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllReminderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_REMITTANCEADVICE,
                                                                           "UBL Remittance Advice " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllRemittanceAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_REQUESTFORQUOTATION,
                                                                           "UBL Request For Quotation " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllRequestForQuotationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_SELFBILLEDCREDITNOTE,
                                                                           "UBL Self Billed Credit Note " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllSelfBilledCreditNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_SELFBILLEDINVOICE,
                                                                           "UBL Self Billed Invoice " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllSelfBilledInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_STATEMENT,
                                                                           "UBL Statement " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllStatementXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_TRANSPORTATIONSTATUS,
                                                                           "UBL Transportation Status " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllTransportationStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_20_WAYBILL,
                                                                           "UBL Waybill " + VERSION_20,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL20Marshaller.getAllWaybillXSDs ())));
  }

  /**
   * Register all standard UBL 2.1 validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initUBL21 (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL21NamespaceContext.getInstance ());

    final boolean bNotDeprecated = false;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_APPLICATIONRESPONSE,
                                                                           "UBL Application Response " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_ATTACHEDDOCUMENT,
                                                                           "UBL Attached Document " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllAttachedDocumentXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_AWARDEDNOTIFICATION,
                                                                           "UBL Awarded Notification " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllAwardedNotificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_BILLOFLADING,
                                                                           "UBL Bill Of Lading " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllBillOfLadingXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_CALLFORTENDERS,
                                                                           "UBL Call For Tenders " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCallForTendersXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_CATALOGUE,
                                                                           "UBL Catalogue " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_CATALOGUEDELETION,
                                                                           "UBL Catalogue Deletion " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueDeletionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_CATALOGUEITEMSPECIFICATIONUPDATE,
                                                                           "UBL Catalogue Item Specification Update " +
                                                                                                                        VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_CATALOGUEPRICINGUPDATE,
                                                                           "UBL Catalogue Pricing Update " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCataloguePricingUpdateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_CATALOGUEREQUEST,
                                                                           "UBL Catalogue Request " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_CERTIFICATEOFORIGIN,
                                                                           "UBL Certificate Of Origin " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCertificateOfOriginXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_CONTRACTAWARDNOTICE,
                                                                           "UBL Contract Award Notice " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllContractAwardNoticeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_CONTRACTNOTICE,
                                                                           "UBL Contract Notice " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllContractNoticeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_CREDITNOTE,
                                                                           "UBL Credit Note " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_DEBITNOTE,
                                                                           "UBL Debit Note " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllDebitNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_DESPATCHADVICE,
                                                                           "UBL Despatch Advice " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllDespatchAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_DOCUMENTSTATUS,
                                                                           "UBL Document Status " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllDocumentStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_DOCUMENTSTATUSREQUEST,
                                                                           "UBL Document Status Request " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllDocumentStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_EXCEPTIONCRITERIA,
                                                                           "UBL Exception Criteria " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllExceptionCriteriaXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_EXCEPTIONNOTIFICATION,
                                                                           "UBL Exception Notification " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllExceptionNotificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_FORECAST,
                                                                           "UBL Forecast " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllForecastXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_FORECASTREVISION,
                                                                           "UBL Forecast Revision " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllForecastRevisionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_FORWARDINGINSTRUCTIONS,
                                                                           "UBL Forwarding Instructions " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllForwardingInstructionsXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_FREIGHTINVOICE,
                                                                           "UBL Freight Invoice " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllFreightInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_FULFILMENTCANCELLATION,
                                                                           "UBL Fulfilment Cancellation " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllFulfilmentCancellationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_GOODSITEMITINERARY,
                                                                           "UBL Goods Item Itinerary " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllGoodsItemItineraryXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_GUARANTEECERTIFICATE,
                                                                           "UBL Guarantee Certificate " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllGuaranteeCertificateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_INSTRUCTIONFORRETURNS,
                                                                           "UBL Instruction For Returns " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInstructionForReturnsXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_INVENTORYREPORT,
                                                                           "UBL Inventory Report " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInventoryReportXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_INVOICE,
                                                                           "UBL Invoice " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_ITEMINFORMATIONREQUEST,
                                                                           "UBL Item Information Request " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllItemInformationRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_ORDER,
                                                                           "UBL Order " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_ORDERCANCELLATION,
                                                                           "UBL Order Cancellation " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderCancellationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_ORDERCHANGE,
                                                                           "UBL Order Change " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderChangeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_ORDERRESPONSE,
                                                                           "UBL Order Response " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_ORDERRESPONSESIMPLE,
                                                                           "UBL Order Response Simple " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseSimpleXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_PACKINGLIST,
                                                                           "UBL Packing List " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllPackingListXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_PRIORINFORMATIONNOTICE,
                                                                           "UBL Prior Information Notice " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllPriorInformationNoticeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_PRODUCTACTIVITY,
                                                                           "UBL Product Activity " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllProductActivityXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_QUOTATION,
                                                                           "UBL Quotation " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllQuotationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_RECEIPTADVICE,
                                                                           "UBL Receipt Advice " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllReceiptAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_REMINDER,
                                                                           "UBL Reminder " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllReminderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_REMITTANCEADVICE,
                                                                           "UBL Remittance Advice " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllRemittanceAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_REQUESTFORQUOTATION,
                                                                           "UBL Request For Quotation " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllRequestForQuotationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_RETAILEVENT,
                                                                           "UBL Retail Event " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllRetailEventXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_SELFBILLEDCREDITNOTE,
                                                                           "UBL Self Billed Credit Note " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllSelfBilledCreditNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_SELFBILLEDINVOICE,
                                                                           "UBL Self Billed Invoice " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllSelfBilledInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_STATEMENT,
                                                                           "UBL Statement " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllStatementXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_STOCKAVAILABILITYREPORT,
                                                                           "UBL Stock Availability Report " +
                                                                                                               VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllStockAvailabilityReportXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TENDER,
                                                                           "UBL Tender " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTenderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TENDERERQUALIFICATION,
                                                                           "UBL Tenderer Qualification " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTendererQualificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TENDERERQUALIFICATIONRESPONSE,
                                                                           "UBL Tenderer Qualification Response " +
                                                                                                                     VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTendererQualificationResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TENDERRECEIPT,
                                                                           "UBL Tender Receipt " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTenderReceiptXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TRADEITEMLOCATIONPROFILE,
                                                                           "UBL Trade Item Location Profile " +
                                                                                                                VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTradeItemLocationProfileXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TRANSPORTATIONSTATUS,
                                                                           "UBL Transportation Status " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTransportationStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TRANSPORTATIONSTATUSREQUEST,
                                                                           "UBL Transportation Status Request " +
                                                                                                                   VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTransportationStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TRANSPORTEXECUTIONPLAN,
                                                                           "UBL Transport Execution Plan " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTransportExecutionPlanXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TRANSPORTEXECUTIONPLANREQUEST,
                                                                           "UBL Transport Execution Plan Request " +
                                                                                                                     VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTransportExecutionPlanRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TRANSPORTPROGRESSSTATUS,
                                                                           "UBL Transport Progress Status " +
                                                                                                               VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTransportProgressStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TRANSPORTPROGRESSSTATUSREQUEST,
                                                                           "UBL Transport Progress Status Request " +
                                                                                                                      VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTransportProgressStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TRANSPORTSERVICEDESCRIPTION,
                                                                           "UBL Transport Service Description " +
                                                                                                                   VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTransportServiceDescriptionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_TRANSPORTSERVICEDESCRIPTIONREQUEST,
                                                                           "UBL Transport Service Description Request " +
                                                                                                                          VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllTransportServiceDescriptionRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_UNAWARDEDNOTIFICATION,
                                                                           "UBL Unawarded Notification " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllUnawardedNotificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_UTILITYSTATEMENT,
                                                                           "UBL Utility Statement " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllUtilityStatementXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_21_WAYBILL,
                                                                           "UBL Waybill " + VERSION_21,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllWaybillXSDs ())));
  }

  /**
   * Register all standard UBL 2.2 validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initUBL22 (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL22NamespaceContext.getInstance ());

    final boolean bNotDeprecated = false;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_APPLICATIONRESPONSE,
                                                                           "UBL Application Response " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllApplicationResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_ATTACHEDDOCUMENT,
                                                                           "UBL Attached Document " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllAttachedDocumentXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_AWARDEDNOTIFICATION,
                                                                           "UBL Awarded Notification " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllAwardedNotificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_BILLOFLADING,
                                                                           "UBL Bill Of Lading " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllBillOfLadingXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_BUSINESSCARD,
                                                                           "UBL Business Card " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllBusinessCardXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_CALLFORTENDERS,
                                                                           "UBL Call For Tenders " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllCallForTendersXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_CATALOGUE,
                                                                           "UBL Catalogue " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllCatalogueXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_CATALOGUEDELETION,
                                                                           "UBL Catalogue Deletion " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllCatalogueDeletionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_CATALOGUEITEMSPECIFICATIONUPDATE,
                                                                           "UBL Catalogue Item Specification Update " +
                                                                                                                        VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_CATALOGUEPRICINGUPDATE,
                                                                           "UBL Catalogue Pricing Update " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllCataloguePricingUpdateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_CATALOGUEREQUEST,
                                                                           "UBL Catalogue Request " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllCatalogueRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_CERTIFICATEOFORIGIN,
                                                                           "UBL Certificate Of Origin " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllCertificateOfOriginXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_CONTRACTAWARDNOTICE,
                                                                           "UBL Contract Award Notice " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllContractAwardNoticeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_CONTRACTNOTICE,
                                                                           "UBL Contract Notice " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllContractNoticeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_CREDITNOTE,
                                                                           "UBL Credit Note " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllCreditNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_DEBITNOTE,
                                                                           "UBL Debit Note " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllDebitNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_DESPATCHADVICE,
                                                                           "UBL Despatch Advice " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllDespatchAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_DIGITALAGREEMENT,
                                                                           "UBL Digital Agreement " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllDigitalAgreementXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_DIGITALCAPABILITY,
                                                                           "UBL Digital Capability " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllDigitalCapabilityXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_DOCUMENTSTATUS,
                                                                           "UBL Document Status " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllDocumentStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_DOCUMENTSTATUSREQUEST,
                                                                           "UBL Document Status Request " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllDocumentStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_ENQUIRY,
                                                                           "UBL Enquiry " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllEnquiryXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_ENQUIRYRESPONSE,
                                                                           "UBL Enquiry Response " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllEnquiryResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_EXCEPTIONCRITERIA,
                                                                           "UBL Exception Criteria " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllExceptionCriteriaXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_EXCEPTIONNOTIFICATION,
                                                                           "UBL Exception Notification " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllExceptionNotificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_EXPRESSIONOFINTERESTREQUEST,
                                                                           "UBL Expression Of Interest Request " +
                                                                                                                   VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllExpressionOfInterestRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_EXPRESSIONOFINTERESTRESPONSE,
                                                                           "UBL Expression Of Interest Response " +
                                                                                                                    VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllExpressionOfInterestResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_FORECAST,
                                                                           "UBL Forecast " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllForecastXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_FORECASTREVISION,
                                                                           "UBL Forecast Revision " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllForecastRevisionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_FORWARDINGINSTRUCTIONS,
                                                                           "UBL Forwarding Instructions " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllForwardingInstructionsXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_FREIGHTINVOICE,
                                                                           "UBL Freight Invoice " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllFreightInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_FULFILMENTCANCELLATION,
                                                                           "UBL Fulfilment Cancellation " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllFulfilmentCancellationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_GOODSITEMITINERARY,
                                                                           "UBL Goods Item Itinerary " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllGoodsItemItineraryXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_GUARANTEECERTIFICATE,
                                                                           "UBL Guarantee Certificate " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllGuaranteeCertificateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_INSTRUCTIONFORRETURNS,
                                                                           "UBL Instruction For Returns " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllInstructionForReturnsXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_INVENTORYREPORT,
                                                                           "UBL Inventory Report " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllInventoryReportXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_INVOICE,
                                                                           "UBL Invoice " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_ITEMINFORMATIONREQUEST,
                                                                           "UBL Item Information Request " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllItemInformationRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_ORDER,
                                                                           "UBL Order " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllOrderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_ORDERCANCELLATION,
                                                                           "UBL Order Cancellation " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllOrderCancellationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_ORDERCHANGE,
                                                                           "UBL Order Change " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllOrderChangeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_ORDERRESPONSE,
                                                                           "UBL Order Response " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllOrderResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_ORDERRESPONSESIMPLE,
                                                                           "UBL Order Response Simple " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllOrderResponseSimpleXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_PACKINGLIST,
                                                                           "UBL Packing List " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllPackingListXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_PRIORINFORMATIONNOTICE,
                                                                           "UBL Prior Information Notice " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllPriorInformationNoticeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_PRODUCTACTIVITY,
                                                                           "UBL Product Activity " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllProductActivityXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_QUALIFICATIONAPPLICATIONREQUEST,
                                                                           "UBL Qualification Application Request " +
                                                                                                                       VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllQualificationApplicationRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_QUALIFICATIONAPPLICATIONRESPONSE,
                                                                           "UBL Qualification Application Response " +
                                                                                                                        VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllQualificationApplicationResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_QUOTATION,
                                                                           "UBL Quotation " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllQuotationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_RECEIPTADVICE,
                                                                           "UBL Receipt Advice " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllReceiptAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_REMINDER,
                                                                           "UBL Reminder " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllReminderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_REMITTANCEADVICE,
                                                                           "UBL Remittance Advice " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllRemittanceAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_REQUESTFORQUOTATION,
                                                                           "UBL Request For Quotation " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllRequestForQuotationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_RETAILEVENT,
                                                                           "UBL Retail Event " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllRetailEventXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_SELFBILLEDCREDITNOTE,
                                                                           "UBL Self Billed Credit Note " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllSelfBilledCreditNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_SELFBILLEDINVOICE,
                                                                           "UBL Self Billed Invoice " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllSelfBilledInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_STATEMENT,
                                                                           "UBL Statement " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllStatementXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_STOCKAVAILABILITYREPORT,
                                                                           "UBL Stock Availability Report " +
                                                                                                               VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllStockAvailabilityReportXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TENDER,
                                                                           "UBL Tender " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTenderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TENDERCONTRACT,
                                                                           "UBL Tender Contract " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTenderContractXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TENDERERQUALIFICATION,
                                                                           "UBL Tenderer Qualification " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTendererQualificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TENDERERQUALIFICATIONRESPONSE,
                                                                           "UBL Tenderer Qualification Response " +
                                                                                                                     VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTendererQualificationResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TENDERRECEIPT,
                                                                           "UBL Tender Receipt " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTenderReceiptXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TENDERSTATUS,
                                                                           "UBL Tender Status " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTenderStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TENDERSTATUSREQUEST,
                                                                           "UBL Tender Status Request " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTenderStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TENDERWITHDRAWAL,
                                                                           "UBL Tender Withdrawal " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTenderWithdrawalXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TRADEITEMLOCATIONPROFILE,
                                                                           "UBL Trade Item Location Profile " +
                                                                                                                VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTradeItemLocationProfileXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TRANSPORTATIONSTATUS,
                                                                           "UBL Transportation Status " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTransportationStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TRANSPORTATIONSTATUSREQUEST,
                                                                           "UBL Transportation Status Request " +
                                                                                                                   VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTransportationStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TRANSPORTEXECUTIONPLAN,
                                                                           "UBL Transport Execution Plan " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTransportExecutionPlanXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TRANSPORTEXECUTIONPLANREQUEST,
                                                                           "UBL Transport Execution Plan Request " +
                                                                                                                     VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTransportExecutionPlanRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TRANSPORTPROGRESSSTATUS,
                                                                           "UBL Transport Progress Status " +
                                                                                                               VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTransportProgressStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TRANSPORTPROGRESSSTATUSREQUEST,
                                                                           "UBL Transport Progress Status Request " +
                                                                                                                      VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTransportProgressStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TRANSPORTSERVICEDESCRIPTION,
                                                                           "UBL Transport Service Description " +
                                                                                                                   VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTransportServiceDescriptionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_TRANSPORTSERVICEDESCRIPTIONREQUEST,
                                                                           "UBL Transport Service Description Request " +
                                                                                                                          VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllTransportServiceDescriptionRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_UNAWARDEDNOTIFICATION,
                                                                           "UBL Unawarded Notification " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllUnawardedNotificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_UNSUBSCRIBEFROMPROCEDUREREQUEST,
                                                                           "UBL Unsubscribe From Procedure Request " +
                                                                                                                       VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllUnsubscribeFromProcedureRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_UNSUBSCRIBEFROMPROCEDURERESPONSE,
                                                                           "UBL Unsubscribe From Procedure Response " +
                                                                                                                        VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllUnsubscribeFromProcedureResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_UTILITYSTATEMENT,
                                                                           "UBL Utility Statement " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllUtilityStatementXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_WAYBILL,
                                                                           "UBL Waybill " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllWaybillXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_22_WEIGHTSTATEMENT,
                                                                           "UBL Weight Statement " + VERSION_22,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL22Marshaller.getAllWeightStatementXSDs ())));
  }

  /**
   * Register all standard UBL 2.3 validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initUBL23 (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL23NamespaceContext.getInstance ());

    final boolean bNotDeprecated = false;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_APPLICATIONRESPONSE,
                                                                           "UBL Application Response " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllApplicationResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_ATTACHEDDOCUMENT,
                                                                           "UBL Attached Document " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllAttachedDocumentXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_AWARDEDNOTIFICATION,
                                                                           "UBL Awarded Notification " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllAwardedNotificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_BILLOFLADING,
                                                                           "UBL Bill Of Lading " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllBillOfLadingXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_BUSINESSCARD,
                                                                           "UBL Business Card " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllBusinessCardXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_CALLFORTENDERS,
                                                                           "UBL Call For Tenders " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllCallForTendersXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_CATALOGUE,
                                                                           "UBL Catalogue " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllCatalogueXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_CATALOGUEDELETION,
                                                                           "UBL Catalogue Deletion " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllCatalogueDeletionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_CATALOGUEITEMSPECIFICATIONUPDATE,
                                                                           "UBL Catalogue Item Specification Update " +
                                                                                                                        VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_CATALOGUEPRICINGUPDATE,
                                                                           "UBL Catalogue Pricing Update " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllCataloguePricingUpdateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_CATALOGUEREQUEST,
                                                                           "UBL Catalogue Request " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllCatalogueRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_CERTIFICATEOFORIGIN,
                                                                           "UBL Certificate Of Origin " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllCertificateOfOriginXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_COMMONTRANSPORTATIONREPORT,
                                                                           "UBL Common Transportation Report " +
                                                                                                                  VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllCommonTransportationReportXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_CONTRACTAWARDNOTICE,
                                                                           "UBL Contract Award Notice " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllContractAwardNoticeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_CONTRACTNOTICE,
                                                                           "UBL Contract Notice " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllContractNoticeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_CREDITNOTE,
                                                                           "UBL Credit Note " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllCreditNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_DEBITNOTE,
                                                                           "UBL Debit Note " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllDebitNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_DESPATCHADVICE,
                                                                           "UBL Despatch Advice " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllDespatchAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_DIGITALAGREEMENT,
                                                                           "UBL Digital Agreement " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllDigitalAgreementXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_DIGITALCAPABILITY,
                                                                           "UBL Digital Capability " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllDigitalCapabilityXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_DOCUMENTSTATUS,
                                                                           "UBL Document Status " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllDocumentStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_DOCUMENTSTATUSREQUEST,
                                                                           "UBL Document Status Request " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllDocumentStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_ENQUIRY,
                                                                           "UBL Enquiry " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllEnquiryXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_ENQUIRYRESPONSE,
                                                                           "UBL Enquiry Response " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllEnquiryResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_EXCEPTIONCRITERIA,
                                                                           "UBL Exception Criteria " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllExceptionCriteriaXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_EXCEPTIONNOTIFICATION,
                                                                           "UBL Exception Notification " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllExceptionNotificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_EXPORTCUSTOMSDECLARATION,
                                                                           "UBL Export Customs Declaration " +
                                                                                                                VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllExportCustomsDeclarationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_EXPRESSIONOFINTERESTREQUEST,
                                                                           "UBL Expression Of Interest Request " +
                                                                                                                   VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllExpressionOfInterestRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_EXPRESSIONOFINTERESTRESPONSE,
                                                                           "UBL Expression Of Interest Response " +
                                                                                                                    VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllExpressionOfInterestResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_FORECAST,
                                                                           "UBL Forecast " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllForecastXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_FORECASTREVISION,
                                                                           "UBL Forecast Revision " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllForecastRevisionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_FORWARDINGINSTRUCTIONS,
                                                                           "UBL Forwarding Instructions " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllForwardingInstructionsXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_FREIGHTINVOICE,
                                                                           "UBL Freight Invoice " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllFreightInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_FULFILMENTCANCELLATION,
                                                                           "UBL Fulfilment Cancellation " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllFulfilmentCancellationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_GOODSCERTIFICATE,
                                                                           "UBL Goods Certificate " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllGoodsCertificateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_GOODSITEMITINERARY,
                                                                           "UBL Goods Item Itinerary " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllGoodsItemItineraryXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_GOODSITEMPASSPORT,
                                                                           "UBL Goods Item Passport " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllGoodsItemPassportXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_GUARANTEECERTIFICATE,
                                                                           "UBL Guarantee Certificate " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllGuaranteeCertificateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_IMPORTCUSTOMSDECLARATION,
                                                                           "UBL Import Customs Declaration " +
                                                                                                                VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllImportCustomsDeclarationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_INSTRUCTIONFORRETURNS,
                                                                           "UBL Instruction For Returns " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllInstructionForReturnsXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_INVENTORYREPORT,
                                                                           "UBL Inventory Report " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllInventoryReportXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_INVOICE,
                                                                           "UBL Invoice " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_ITEMINFORMATIONREQUEST,
                                                                           "UBL Item Information Request " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllItemInformationRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_MANIFEST,
                                                                           "UBL Manifest " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllManifestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_ORDER,
                                                                           "UBL Order " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllOrderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_ORDERCANCELLATION,
                                                                           "UBL Order Cancellation " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllOrderCancellationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_ORDERCHANGE,
                                                                           "UBL Order Change " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllOrderChangeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_ORDERRESPONSE,
                                                                           "UBL Order Response " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllOrderResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_ORDERRESPONSESIMPLE,
                                                                           "UBL Order Response Simple " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllOrderResponseSimpleXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_PACKINGLIST,
                                                                           "UBL Packing List " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllPackingListXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_PRIORINFORMATIONNOTICE,
                                                                           "UBL Prior Information Notice " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllPriorInformationNoticeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_PRODUCTACTIVITY,
                                                                           "UBL Product Activity " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllProductActivityXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_PROOFOFREEXPORTATION,
                                                                           "UBL Proof Of Reexportation " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllProofOfReexportationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_PROOFOFREEXPORTATIONREMINDER,
                                                                           "UBL Proof Of Reexportation Reminder " +
                                                                                                                    VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllProofOfReexportationReminderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_PROOFOFREEXPORTATIONREQUEST,
                                                                           "UBL Proof Of Reexportation Request " +
                                                                                                                   VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllProofOfReexportationRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_QUALIFICATIONAPPLICATIONREQUEST,
                                                                           "UBL Qualification Application Request " +
                                                                                                                       VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllQualificationApplicationRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_QUALIFICATIONAPPLICATIONRESPONSE,
                                                                           "UBL Qualification Application Response " +
                                                                                                                        VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllQualificationApplicationResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_QUOTATION,
                                                                           "UBL Quotation " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllQuotationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_RECEIPTADVICE,
                                                                           "UBL Receipt Advice " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllReceiptAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_REMINDER,
                                                                           "UBL Reminder " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllReminderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_REMITTANCEADVICE,
                                                                           "UBL Remittance Advice " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllRemittanceAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_REQUESTFORQUOTATION,
                                                                           "UBL Request For Quotation " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllRequestForQuotationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_RETAILEVENT,
                                                                           "UBL Retail Event " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllRetailEventXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_SELFBILLEDCREDITNOTE,
                                                                           "UBL Self Billed Credit Note " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllSelfBilledCreditNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_SELFBILLEDINVOICE,
                                                                           "UBL Self Billed Invoice " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllSelfBilledInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_STATEMENT,
                                                                           "UBL Statement " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllStatementXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_STOCKAVAILABILITYREPORT,
                                                                           "UBL Stock Availability Report " +
                                                                                                               VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllStockAvailabilityReportXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TENDER,
                                                                           "UBL Tender " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTenderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TENDERCONTRACT,
                                                                           "UBL Tender Contract " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTenderContractXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TENDERERQUALIFICATION,
                                                                           "UBL Tenderer Qualification " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTendererQualificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TENDERERQUALIFICATIONRESPONSE,
                                                                           "UBL Tenderer Qualification Response " +
                                                                                                                     VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTendererQualificationResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TENDERRECEIPT,
                                                                           "UBL Tender Receipt " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTenderReceiptXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TENDERSTATUS,
                                                                           "UBL Tender Status " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTenderStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TENDERSTATUSREQUEST,
                                                                           "UBL Tender Status Request " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTenderStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TENDERWITHDRAWAL,
                                                                           "UBL Tender Withdrawal " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTenderWithdrawalXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TRADEITEMLOCATIONPROFILE,
                                                                           "UBL Trade Item Location Profile " +
                                                                                                                VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTradeItemLocationProfileXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TRANSITCUSTOMSDECLARATION,
                                                                           "UBL Transit Customs Declaration " +
                                                                                                                 VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTransitCustomsDeclarationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TRANSPORTATIONSTATUS,
                                                                           "UBL Transportation Status " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTransportationStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TRANSPORTATIONSTATUSREQUEST,
                                                                           "UBL Transportation Status Request " +
                                                                                                                   VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTransportationStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TRANSPORTEXECUTIONPLAN,
                                                                           "UBL Transport Execution Plan " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTransportExecutionPlanXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TRANSPORTEXECUTIONPLANREQUEST,
                                                                           "UBL Transport Execution Plan Request " +
                                                                                                                     VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTransportExecutionPlanRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TRANSPORTPROGRESSSTATUS,
                                                                           "UBL Transport Progress Status " +
                                                                                                               VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTransportProgressStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TRANSPORTPROGRESSSTATUSREQUEST,
                                                                           "UBL Transport Progress Status Request " +
                                                                                                                      VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTransportProgressStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TRANSPORTSERVICEDESCRIPTION,
                                                                           "UBL Transport Service Description " +
                                                                                                                   VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTransportServiceDescriptionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_TRANSPORTSERVICEDESCRIPTIONREQUEST,
                                                                           "UBL Transport Service Description Request " +
                                                                                                                          VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllTransportServiceDescriptionRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_UNAWARDEDNOTIFICATION,
                                                                           "UBL Unawarded Notification " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllUnawardedNotificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_UNSUBSCRIBEFROMPROCEDUREREQUEST,
                                                                           "UBL Unsubscribe From Procedure Request " +
                                                                                                                       VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllUnsubscribeFromProcedureRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_UNSUBSCRIBEFROMPROCEDURERESPONSE,
                                                                           "UBL Unsubscribe From Procedure Response " +
                                                                                                                        VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllUnsubscribeFromProcedureResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_UTILITYSTATEMENT,
                                                                           "UBL Utility Statement " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllUtilityStatementXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_WAYBILL,
                                                                           "UBL Waybill " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllWaybillXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_23_WEIGHTSTATEMENT,
                                                                           "UBL Weight Statement " + VERSION_23,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllWeightStatementXSDs ())));
  }

  /**
   * Register all standard UBL 2.4 validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initUBL24 (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL24NamespaceContext.getInstance ());

    final boolean bNotDeprecated = false;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_APPLICATIONRESPONSE,
                                                                           "UBL Application Response " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllApplicationResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_ATTACHEDDOCUMENT,
                                                                           "UBL Attached Document " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllAttachedDocumentXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_AWARDEDNOTIFICATION,
                                                                           "UBL Awarded Notification " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllAwardedNotificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_BILLOFLADING,
                                                                           "UBL Bill Of Lading " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllBillOfLadingXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_BUSINESSCARD,
                                                                           "UBL Business Card " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllBusinessCardXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_BUSINESSINFORMATION,
                                                                           "UBL Business Information " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllBusinessInformationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_CALLFORTENDERS,
                                                                           "UBL Call For Tenders " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllCallForTendersXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_CATALOGUE,
                                                                           "UBL Catalogue " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllCatalogueXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_CATALOGUEDELETION,
                                                                           "UBL Catalogue Deletion " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllCatalogueDeletionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_CATALOGUEITEMSPECIFICATIONUPDATE,
                                                                           "UBL Catalogue Item Specification Update " +
                                                                                                                        VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_CATALOGUEPRICINGUPDATE,
                                                                           "UBL Catalogue Pricing Update " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllCataloguePricingUpdateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_CATALOGUEREQUEST,
                                                                           "UBL Catalogue Request " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllCatalogueRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_CERTIFICATEOFORIGIN,
                                                                           "UBL Certificate Of Origin " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllCertificateOfOriginXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_COMMONTRANSPORTATIONREPORT,
                                                                           "UBL Common Transportation Report " +
                                                                                                                  VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllCommonTransportationReportXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_CONTRACTAWARDNOTICE,
                                                                           "UBL Contract Award Notice " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllContractAwardNoticeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_CONTRACTNOTICE,
                                                                           "UBL Contract Notice " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllContractNoticeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_CREDITNOTE,
                                                                           "UBL Credit Note " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllCreditNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_DEBITNOTE,
                                                                           "UBL Debit Note " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllDebitNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_DESPATCHADVICE,
                                                                           "UBL Despatch Advice " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllDespatchAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_DIGITALAGREEMENT,
                                                                           "UBL Digital Agreement " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllDigitalAgreementXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_DIGITALCAPABILITY,
                                                                           "UBL Digital Capability " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllDigitalCapabilityXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_DOCUMENTSTATUS,
                                                                           "UBL Document Status " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllDocumentStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_DOCUMENTSTATUSREQUEST,
                                                                           "UBL Document Status Request " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllDocumentStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_ENQUIRY,
                                                                           "UBL Enquiry " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllEnquiryXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_ENQUIRYRESPONSE,
                                                                           "UBL Enquiry Response " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllEnquiryResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_EXCEPTIONCRITERIA,
                                                                           "UBL Exception Criteria " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllExceptionCriteriaXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_EXCEPTIONNOTIFICATION,
                                                                           "UBL Exception Notification " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllExceptionNotificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_EXPORTCUSTOMSDECLARATION,
                                                                           "UBL Export Customs Declaration " +
                                                                                                                VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllExportCustomsDeclarationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_EXPRESSIONOFINTERESTREQUEST,
                                                                           "UBL Expression Of Interest Request " +
                                                                                                                   VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllExpressionOfInterestRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_EXPRESSIONOFINTERESTRESPONSE,
                                                                           "UBL Expression Of Interest Response " +
                                                                                                                    VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllExpressionOfInterestResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_FORECAST,
                                                                           "UBL Forecast " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllForecastXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_FORECASTREVISION,
                                                                           "UBL Forecast Revision " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllForecastRevisionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_FORWARDINGINSTRUCTIONS,
                                                                           "UBL Forwarding Instructions " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllForwardingInstructionsXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_FREIGHTINVOICE,
                                                                           "UBL Freight Invoice " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllFreightInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_FULFILMENTCANCELLATION,
                                                                           "UBL Fulfilment Cancellation " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllFulfilmentCancellationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_GOODSCERTIFICATE,
                                                                           "UBL Goods Certificate " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllGoodsCertificateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_GOODSITEMITINERARY,
                                                                           "UBL Goods Item Itinerary " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllGoodsItemItineraryXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_GOODSITEMPASSPORT,
                                                                           "UBL Goods Item Passport " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllGoodsItemPassportXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_GUARANTEECERTIFICATE,
                                                                           "UBL Guarantee Certificate " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllGuaranteeCertificateXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_IMPORTCUSTOMSDECLARATION,
                                                                           "UBL Import Customs Declaration " +
                                                                                                                VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllImportCustomsDeclarationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_INSTRUCTIONFORRETURNS,
                                                                           "UBL Instruction For Returns " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllInstructionForReturnsXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_INVENTORYREPORT,
                                                                           "UBL Inventory Report " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllInventoryReportXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_INVOICE,
                                                                           "UBL Invoice " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_ITEMINFORMATIONREQUEST,
                                                                           "UBL Item Information Request " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllItemInformationRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_MANIFEST,
                                                                           "UBL Manifest " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllManifestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_ORDER,
                                                                           "UBL Order " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllOrderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_ORDERCANCELLATION,
                                                                           "UBL Order Cancellation " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllOrderCancellationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_ORDERCHANGE,
                                                                           "UBL Order Change " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllOrderChangeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_ORDERRESPONSE,
                                                                           "UBL Order Response " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllOrderResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_ORDERRESPONSESIMPLE,
                                                                           "UBL Order Response Simple " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllOrderResponseSimpleXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_PACKINGLIST,
                                                                           "UBL Packing List " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllPackingListXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_PRIORINFORMATIONNOTICE,
                                                                           "UBL Prior Information Notice " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllPriorInformationNoticeXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_PRODUCTACTIVITY,
                                                                           "UBL Product Activity " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllProductActivityXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_PROOFOFREEXPORTATION,
                                                                           "UBL Proof Of Reexportation " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllProofOfReexportationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_PROOFOFREEXPORTATIONREMINDER,
                                                                           "UBL Proof Of Reexportation Reminder " +
                                                                                                                    VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllProofOfReexportationReminderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_PROOFOFREEXPORTATIONREQUEST,
                                                                           "UBL Proof Of Reexportation Request " +
                                                                                                                   VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllProofOfReexportationRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_PURCHASERECEIPT,
                                                                           "UBL Purchase Receipt " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllPurchaseReceiptXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_QUALIFICATIONAPPLICATIONREQUEST,
                                                                           "UBL Qualification Application Request " +
                                                                                                                       VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllQualificationApplicationRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_QUALIFICATIONAPPLICATIONRESPONSE,
                                                                           "UBL Qualification Application Response " +
                                                                                                                        VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllQualificationApplicationResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_QUOTATION,
                                                                           "UBL Quotation " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllQuotationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_RECEIPTADVICE,
                                                                           "UBL Receipt Advice " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllReceiptAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_REMINDER,
                                                                           "UBL Reminder " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllReminderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_REMITTANCEADVICE,
                                                                           "UBL Remittance Advice " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllRemittanceAdviceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_REQUESTFORQUOTATION,
                                                                           "UBL Request For Quotation " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllRequestForQuotationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_RETAILEVENT,
                                                                           "UBL Retail Event " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllRetailEventXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_SELFBILLEDCREDITNOTE,
                                                                           "UBL Self Billed Credit Note " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllSelfBilledCreditNoteXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_SELFBILLEDINVOICE,
                                                                           "UBL Self Billed Invoice " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllSelfBilledInvoiceXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_STATEMENT,
                                                                           "UBL Statement " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllStatementXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_STOCKAVAILABILITYREPORT,
                                                                           "UBL Stock Availability Report " +
                                                                                                               VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllStockAvailabilityReportXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TENDER,
                                                                           "UBL Tender " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTenderXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TENDERCONTRACT,
                                                                           "UBL Tender Contract " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTenderContractXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TENDERERQUALIFICATION,
                                                                           "UBL Tenderer Qualification " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTendererQualificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TENDERERQUALIFICATIONRESPONSE,
                                                                           "UBL Tenderer Qualification Response " +
                                                                                                                     VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTendererQualificationResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TENDERRECEIPT,
                                                                           "UBL Tender Receipt " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTenderReceiptXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TENDERSTATUS,
                                                                           "UBL Tender Status " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTenderStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TENDERSTATUSREQUEST,
                                                                           "UBL Tender Status Request " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTenderStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TENDERWITHDRAWAL,
                                                                           "UBL Tender Withdrawal " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTenderWithdrawalXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TRADEITEMLOCATIONPROFILE,
                                                                           "UBL Trade Item Location Profile " +
                                                                                                                VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTradeItemLocationProfileXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TRANSITCUSTOMSDECLARATION,
                                                                           "UBL Transit Customs Declaration " +
                                                                                                                 VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTransitCustomsDeclarationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TRANSPORTATIONSTATUS,
                                                                           "UBL Transportation Status " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTransportationStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TRANSPORTATIONSTATUSREQUEST,
                                                                           "UBL Transportation Status Request " +
                                                                                                                   VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTransportationStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TRANSPORTEXECUTIONPLAN,
                                                                           "UBL Transport Execution Plan " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTransportExecutionPlanXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TRANSPORTEXECUTIONPLANREQUEST,
                                                                           "UBL Transport Execution Plan Request " +
                                                                                                                     VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTransportExecutionPlanRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TRANSPORTPROGRESSSTATUS,
                                                                           "UBL Transport Progress Status " +
                                                                                                               VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTransportProgressStatusXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TRANSPORTPROGRESSSTATUSREQUEST,
                                                                           "UBL Transport Progress Status Request " +
                                                                                                                      VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTransportProgressStatusRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TRANSPORTSERVICEDESCRIPTION,
                                                                           "UBL Transport Service Description " +
                                                                                                                   VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTransportServiceDescriptionXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_TRANSPORTSERVICEDESCRIPTIONREQUEST,
                                                                           "UBL Transport Service Description Request " +
                                                                                                                          VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllTransportServiceDescriptionRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_UNAWARDEDNOTIFICATION,
                                                                           "UBL Unawarded Notification " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllUnawardedNotificationXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_UNSUBSCRIBEFROMPROCEDUREREQUEST,
                                                                           "UBL Unsubscribe From Procedure Request " +
                                                                                                                       VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllUnsubscribeFromProcedureRequestXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_UNSUBSCRIBEFROMPROCEDURERESPONSE,
                                                                           "UBL Unsubscribe From Procedure Response " +
                                                                                                                        VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllUnsubscribeFromProcedureResponseXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_UTILITYSTATEMENT,
                                                                           "UBL Utility Statement " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllUtilityStatementXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_WAYBILL,
                                                                           "UBL Waybill " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllWaybillXSDs ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_24_WEIGHTSTATEMENT,
                                                                           "UBL Weight Statement " + VERSION_24,
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL24Marshaller.getAllWeightStatementXSDs ())));
  }
}
