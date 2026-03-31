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
package com.helger.phive.ubl;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesBuilder;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl20.UBL20Marshaller;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl22.UBL22Marshaller;
import com.helger.ubl23.UBL23Marshaller;
import com.helger.ubl24.UBL24Marshaller;

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
  public static final String VERSION_24 = "2.4";

  // UBL 2.0
  public static final DVRCoordinate VID_UBL_20_APPLICATIONRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "applicationresponse",
                                                                                                        VERSION_20);
  public static final DVRCoordinate VID_UBL_20_ATTACHEDDOCUMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "attacheddocument",
                                                                                                     VERSION_20);
  public static final DVRCoordinate VID_UBL_20_BILLOFLADING = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "billoflading",
                                                                                                 VERSION_20);
  public static final DVRCoordinate VID_UBL_20_CATALOGUE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "catalogue",
                                                                                              VERSION_20);
  public static final DVRCoordinate VID_UBL_20_CATALOGUEDELETION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "cataloguedeletion",
                                                                                                      VERSION_20);
  public static final DVRCoordinate VID_UBL_20_CATALOGUEITEMSPECIFICATIONUPDATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "catalogueitemspecificationupdate",
                                                                                                                     VERSION_20);
  public static final DVRCoordinate VID_UBL_20_CATALOGUEPRICINGUPDATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "cataloguepricingupdate",
                                                                                                           VERSION_20);
  public static final DVRCoordinate VID_UBL_20_CATALOGUEREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "cataloguerequest",
                                                                                                     VERSION_20);
  public static final DVRCoordinate VID_UBL_20_CERTIFICATEOFORIGIN = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "certificateoforigin",
                                                                                                        VERSION_20);
  public static final DVRCoordinate VID_UBL_20_CREDITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "creditnote",
                                                                                               VERSION_20);
  public static final DVRCoordinate VID_UBL_20_DEBITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "debitnote",
                                                                                              VERSION_20);
  public static final DVRCoordinate VID_UBL_20_DESPATCHADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "despatchadvice",
                                                                                                   VERSION_20);
  public static final DVRCoordinate VID_UBL_20_FORWARDINGINSTRUCTIONS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "forwardinginstructions",
                                                                                                           VERSION_20);
  public static final DVRCoordinate VID_UBL_20_FREIGHTINVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "freightinvoice",
                                                                                                   VERSION_20);
  public static final DVRCoordinate VID_UBL_20_INVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "invoice",
                                                                                            VERSION_20);
  public static final DVRCoordinate VID_UBL_20_ORDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                          "order",
                                                                                          VERSION_20);
  public static final DVRCoordinate VID_UBL_20_ORDERCANCELLATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "ordercancellation",
                                                                                                      VERSION_20);
  public static final DVRCoordinate VID_UBL_20_ORDERCHANGE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "orderchange",
                                                                                                VERSION_20);
  public static final DVRCoordinate VID_UBL_20_ORDERRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "orderresponse",
                                                                                                  VERSION_20);
  public static final DVRCoordinate VID_UBL_20_ORDERRESPONSESIMPLE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "orderresponsesimple",
                                                                                                        VERSION_20);
  public static final DVRCoordinate VID_UBL_20_PACKINGLIST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "packinglist",
                                                                                                VERSION_20);
  public static final DVRCoordinate VID_UBL_20_QUOTATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "quotation",
                                                                                              VERSION_20);
  public static final DVRCoordinate VID_UBL_20_RECEIPTADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "receiptadvice",
                                                                                                  VERSION_20);
  public static final DVRCoordinate VID_UBL_20_REMINDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "reminder",
                                                                                             VERSION_20);
  public static final DVRCoordinate VID_UBL_20_REMITTANCEADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "remittanceadvice",
                                                                                                     VERSION_20);
  public static final DVRCoordinate VID_UBL_20_REQUESTFORQUOTATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "requestforquotation",
                                                                                                        VERSION_20);
  public static final DVRCoordinate VID_UBL_20_SELFBILLEDCREDITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "selfbilledcreditnote",
                                                                                                         VERSION_20);
  public static final DVRCoordinate VID_UBL_20_SELFBILLEDINVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "selfbilledinvoice",
                                                                                                      VERSION_20);
  public static final DVRCoordinate VID_UBL_20_STATEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "statement",
                                                                                              VERSION_20);
  public static final DVRCoordinate VID_UBL_20_TRANSPORTATIONSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "transportationstatus",
                                                                                                         VERSION_20);
  public static final DVRCoordinate VID_UBL_20_WAYBILL = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "waybill",
                                                                                            VERSION_20);

  // UBL 2.1
  public static final DVRCoordinate VID_UBL_21_APPLICATIONRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "applicationresponse",
                                                                                                        VERSION_21);
  public static final DVRCoordinate VID_UBL_21_ATTACHEDDOCUMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "attacheddocument",
                                                                                                     VERSION_21);
  public static final DVRCoordinate VID_UBL_21_AWARDEDNOTIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "awardednotification",
                                                                                                        VERSION_21);
  public static final DVRCoordinate VID_UBL_21_BILLOFLADING = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "billoflading",
                                                                                                 VERSION_21);
  public static final DVRCoordinate VID_UBL_21_CALLFORTENDERS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "callfortenders",
                                                                                                   VERSION_21);
  public static final DVRCoordinate VID_UBL_21_CATALOGUE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "catalogue",
                                                                                              VERSION_21);
  public static final DVRCoordinate VID_UBL_21_CATALOGUEDELETION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "cataloguedeletion",
                                                                                                      VERSION_21);
  public static final DVRCoordinate VID_UBL_21_CATALOGUEITEMSPECIFICATIONUPDATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "catalogueitemspecificationupdate",
                                                                                                                     VERSION_21);
  public static final DVRCoordinate VID_UBL_21_CATALOGUEPRICINGUPDATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "cataloguepricingupdate",
                                                                                                           VERSION_21);
  public static final DVRCoordinate VID_UBL_21_CATALOGUEREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "cataloguerequest",
                                                                                                     VERSION_21);
  public static final DVRCoordinate VID_UBL_21_CERTIFICATEOFORIGIN = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "certificateoforigin",
                                                                                                        VERSION_21);
  public static final DVRCoordinate VID_UBL_21_CONTRACTAWARDNOTICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "contractawardnotice",
                                                                                                        VERSION_21);
  public static final DVRCoordinate VID_UBL_21_CONTRACTNOTICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "contractnotice",
                                                                                                   VERSION_21);
  public static final DVRCoordinate VID_UBL_21_CREDITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "creditnote",
                                                                                               VERSION_21);
  public static final DVRCoordinate VID_UBL_21_DEBITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "debitnote",
                                                                                              VERSION_21);
  public static final DVRCoordinate VID_UBL_21_DESPATCHADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "despatchadvice",
                                                                                                   VERSION_21);
  public static final DVRCoordinate VID_UBL_21_DOCUMENTSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "documentstatus",
                                                                                                   VERSION_21);
  public static final DVRCoordinate VID_UBL_21_DOCUMENTSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "documentstatusrequest",
                                                                                                          VERSION_21);
  public static final DVRCoordinate VID_UBL_21_EXCEPTIONCRITERIA = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "exceptioncriteria",
                                                                                                      VERSION_21);
  public static final DVRCoordinate VID_UBL_21_EXCEPTIONNOTIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "exceptionnotification",
                                                                                                          VERSION_21);
  public static final DVRCoordinate VID_UBL_21_FORECAST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "forecast",
                                                                                             VERSION_21);
  public static final DVRCoordinate VID_UBL_21_FORECASTREVISION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "forecastrevision",
                                                                                                     VERSION_21);
  public static final DVRCoordinate VID_UBL_21_FORWARDINGINSTRUCTIONS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "forwardinginstructions",
                                                                                                           VERSION_21);
  public static final DVRCoordinate VID_UBL_21_FREIGHTINVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "freightinvoice",
                                                                                                   VERSION_21);
  public static final DVRCoordinate VID_UBL_21_FULFILMENTCANCELLATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "fulfilmentcancellation",
                                                                                                           VERSION_21);
  public static final DVRCoordinate VID_UBL_21_GOODSITEMITINERARY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "goodsitemitinerary",
                                                                                                       VERSION_21);
  public static final DVRCoordinate VID_UBL_21_GUARANTEECERTIFICATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "guaranteecertificate",
                                                                                                         VERSION_21);
  public static final DVRCoordinate VID_UBL_21_INSTRUCTIONFORRETURNS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "instructionforreturns",
                                                                                                          VERSION_21);
  public static final DVRCoordinate VID_UBL_21_INVENTORYREPORT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "inventoryreport",
                                                                                                    VERSION_21);
  public static final DVRCoordinate VID_UBL_21_INVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "invoice",
                                                                                            VERSION_21);
  public static final DVRCoordinate VID_UBL_21_ITEMINFORMATIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "iteminformationrequest",
                                                                                                           VERSION_21);
  public static final DVRCoordinate VID_UBL_21_ORDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                          "order",
                                                                                          VERSION_21);
  public static final DVRCoordinate VID_UBL_21_ORDERCANCELLATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "ordercancellation",
                                                                                                      VERSION_21);
  public static final DVRCoordinate VID_UBL_21_ORDERCHANGE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "orderchange",
                                                                                                VERSION_21);
  public static final DVRCoordinate VID_UBL_21_ORDERRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "orderresponse",
                                                                                                  VERSION_21);
  public static final DVRCoordinate VID_UBL_21_ORDERRESPONSESIMPLE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "orderresponsesimple",
                                                                                                        VERSION_21);
  public static final DVRCoordinate VID_UBL_21_PACKINGLIST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "packinglist",
                                                                                                VERSION_21);
  public static final DVRCoordinate VID_UBL_21_PRIORINFORMATIONNOTICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "priorinformationnotice",
                                                                                                           VERSION_21);
  public static final DVRCoordinate VID_UBL_21_PRODUCTACTIVITY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "productactivity",
                                                                                                    VERSION_21);
  public static final DVRCoordinate VID_UBL_21_QUOTATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "quotation",
                                                                                              VERSION_21);
  public static final DVRCoordinate VID_UBL_21_RECEIPTADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "receiptadvice",
                                                                                                  VERSION_21);
  public static final DVRCoordinate VID_UBL_21_REMINDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "reminder",
                                                                                             VERSION_21);
  public static final DVRCoordinate VID_UBL_21_REMITTANCEADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "remittanceadvice",
                                                                                                     VERSION_21);
  public static final DVRCoordinate VID_UBL_21_REQUESTFORQUOTATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "requestforquotation",
                                                                                                        VERSION_21);
  public static final DVRCoordinate VID_UBL_21_RETAILEVENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "retailevent",
                                                                                                VERSION_21);
  public static final DVRCoordinate VID_UBL_21_SELFBILLEDCREDITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "selfbilledcreditnote",
                                                                                                         VERSION_21);
  public static final DVRCoordinate VID_UBL_21_SELFBILLEDINVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "selfbilledinvoice",
                                                                                                      VERSION_21);
  public static final DVRCoordinate VID_UBL_21_STATEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "statement",
                                                                                              VERSION_21);
  public static final DVRCoordinate VID_UBL_21_STOCKAVAILABILITYREPORT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                            "stockavailabilityreport",
                                                                                                            VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TENDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                           "tender",
                                                                                           VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TENDERERQUALIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "tendererqualification",
                                                                                                          VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TENDERERQUALIFICATIONRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "tendererqualificationresponse",
                                                                                                                  VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TENDERRECEIPT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "tenderreceipt",
                                                                                                  VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TRADEITEMLOCATIONPROFILE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                             "tradeitemlocationprofile",
                                                                                                             VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TRANSPORTATIONSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "transportationstatus",
                                                                                                         VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TRANSPORTATIONSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "transportationstatusrequest",
                                                                                                                VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TRANSPORTEXECUTIONPLAN = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "transportexecutionplan",
                                                                                                           VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TRANSPORTEXECUTIONPLANREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "transportexecutionplanrequest",
                                                                                                                  VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TRANSPORTPROGRESSSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                            "transportprogressstatus",
                                                                                                            VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TRANSPORTPROGRESSSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                   "transportprogressstatusrequest",
                                                                                                                   VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TRANSPORTSERVICEDESCRIPTION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "transportservicedescription",
                                                                                                                VERSION_21);
  public static final DVRCoordinate VID_UBL_21_TRANSPORTSERVICEDESCRIPTIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                       "transportservicedescriptionrequest",
                                                                                                                       VERSION_21);
  public static final DVRCoordinate VID_UBL_21_UNAWARDEDNOTIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "unawardednotification",
                                                                                                          VERSION_21);
  public static final DVRCoordinate VID_UBL_21_UTILITYSTATEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "utilitystatement",
                                                                                                     VERSION_21);
  public static final DVRCoordinate VID_UBL_21_WAYBILL = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "waybill",
                                                                                            VERSION_21);

  // UBL 2.2
  public static final DVRCoordinate VID_UBL_22_APPLICATIONRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "applicationresponse",
                                                                                                        VERSION_22);
  public static final DVRCoordinate VID_UBL_22_ATTACHEDDOCUMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "attacheddocument",
                                                                                                     VERSION_22);
  public static final DVRCoordinate VID_UBL_22_AWARDEDNOTIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "awardednotification",
                                                                                                        VERSION_22);
  public static final DVRCoordinate VID_UBL_22_BILLOFLADING = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "billoflading",
                                                                                                 VERSION_22);
  public static final DVRCoordinate VID_UBL_22_BUSINESSCARD = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "businesscard",
                                                                                                 VERSION_22);
  public static final DVRCoordinate VID_UBL_22_CALLFORTENDERS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "callfortenders",
                                                                                                   VERSION_22);
  public static final DVRCoordinate VID_UBL_22_CATALOGUE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "catalogue",
                                                                                              VERSION_22);
  public static final DVRCoordinate VID_UBL_22_CATALOGUEDELETION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "cataloguedeletion",
                                                                                                      VERSION_22);
  public static final DVRCoordinate VID_UBL_22_CATALOGUEITEMSPECIFICATIONUPDATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "catalogueitemspecificationupdate",
                                                                                                                     VERSION_22);
  public static final DVRCoordinate VID_UBL_22_CATALOGUEPRICINGUPDATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "cataloguepricingupdate",
                                                                                                           VERSION_22);
  public static final DVRCoordinate VID_UBL_22_CATALOGUEREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "cataloguerequest",
                                                                                                     VERSION_22);
  public static final DVRCoordinate VID_UBL_22_CERTIFICATEOFORIGIN = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "certificateoforigin",
                                                                                                        VERSION_22);
  public static final DVRCoordinate VID_UBL_22_CONTRACTAWARDNOTICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "contractawardnotice",
                                                                                                        VERSION_22);
  public static final DVRCoordinate VID_UBL_22_CONTRACTNOTICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "contractnotice",
                                                                                                   VERSION_22);
  public static final DVRCoordinate VID_UBL_22_CREDITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "creditnote",
                                                                                               VERSION_22);
  public static final DVRCoordinate VID_UBL_22_DEBITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "debitnote",
                                                                                              VERSION_22);
  public static final DVRCoordinate VID_UBL_22_DESPATCHADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "despatchadvice",
                                                                                                   VERSION_22);
  public static final DVRCoordinate VID_UBL_22_DIGITALAGREEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "digitalagreement",
                                                                                                     VERSION_22);
  public static final DVRCoordinate VID_UBL_22_DIGITALCAPABILITY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "digitalcapability",
                                                                                                      VERSION_22);
  public static final DVRCoordinate VID_UBL_22_DOCUMENTSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "documentstatus",
                                                                                                   VERSION_22);
  public static final DVRCoordinate VID_UBL_22_DOCUMENTSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "documentstatusrequest",
                                                                                                          VERSION_22);
  public static final DVRCoordinate VID_UBL_22_ENQUIRY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "enquiry",
                                                                                            VERSION_22);
  public static final DVRCoordinate VID_UBL_22_ENQUIRYRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "enquiryresponse",
                                                                                                    VERSION_22);
  public static final DVRCoordinate VID_UBL_22_EXCEPTIONCRITERIA = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "exceptioncriteria",
                                                                                                      VERSION_22);
  public static final DVRCoordinate VID_UBL_22_EXCEPTIONNOTIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "exceptionnotification",
                                                                                                          VERSION_22);
  public static final DVRCoordinate VID_UBL_22_EXPRESSIONOFINTERESTREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "expressionofinterestrequest",
                                                                                                                VERSION_22);
  public static final DVRCoordinate VID_UBL_22_EXPRESSIONOFINTERESTRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                 "expressionofinterestresponse",
                                                                                                                 VERSION_22);
  public static final DVRCoordinate VID_UBL_22_FORECAST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "forecast",
                                                                                             VERSION_22);
  public static final DVRCoordinate VID_UBL_22_FORECASTREVISION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "forecastrevision",
                                                                                                     VERSION_22);
  public static final DVRCoordinate VID_UBL_22_FORWARDINGINSTRUCTIONS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "forwardinginstructions",
                                                                                                           VERSION_22);
  public static final DVRCoordinate VID_UBL_22_FREIGHTINVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "freightinvoice",
                                                                                                   VERSION_22);
  public static final DVRCoordinate VID_UBL_22_FULFILMENTCANCELLATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "fulfilmentcancellation",
                                                                                                           VERSION_22);
  public static final DVRCoordinate VID_UBL_22_GOODSITEMITINERARY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "goodsitemitinerary",
                                                                                                       VERSION_22);
  public static final DVRCoordinate VID_UBL_22_GUARANTEECERTIFICATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "guaranteecertificate",
                                                                                                         VERSION_22);
  public static final DVRCoordinate VID_UBL_22_INSTRUCTIONFORRETURNS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "instructionforreturns",
                                                                                                          VERSION_22);
  public static final DVRCoordinate VID_UBL_22_INVENTORYREPORT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "inventoryreport",
                                                                                                    VERSION_22);
  public static final DVRCoordinate VID_UBL_22_INVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "invoice",
                                                                                            VERSION_22);
  public static final DVRCoordinate VID_UBL_22_ITEMINFORMATIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "iteminformationrequest",
                                                                                                           VERSION_22);
  public static final DVRCoordinate VID_UBL_22_ORDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                          "order",
                                                                                          VERSION_22);
  public static final DVRCoordinate VID_UBL_22_ORDERCANCELLATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "ordercancellation",
                                                                                                      VERSION_22);
  public static final DVRCoordinate VID_UBL_22_ORDERCHANGE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "orderchange",
                                                                                                VERSION_22);
  public static final DVRCoordinate VID_UBL_22_ORDERRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "orderresponse",
                                                                                                  VERSION_22);
  public static final DVRCoordinate VID_UBL_22_ORDERRESPONSESIMPLE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "orderresponsesimple",
                                                                                                        VERSION_22);
  public static final DVRCoordinate VID_UBL_22_PACKINGLIST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "packinglist",
                                                                                                VERSION_22);
  public static final DVRCoordinate VID_UBL_22_PRIORINFORMATIONNOTICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "priorinformationnotice",
                                                                                                           VERSION_22);
  public static final DVRCoordinate VID_UBL_22_PRODUCTACTIVITY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "productactivity",
                                                                                                    VERSION_22);
  public static final DVRCoordinate VID_UBL_22_QUALIFICATIONAPPLICATIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "qualificationapplicationrequest",
                                                                                                                    VERSION_22);
  public static final DVRCoordinate VID_UBL_22_QUALIFICATIONAPPLICATIONRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "qualificationapplicationresponse",
                                                                                                                     VERSION_22);
  public static final DVRCoordinate VID_UBL_22_QUOTATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "quotation",
                                                                                              VERSION_22);
  public static final DVRCoordinate VID_UBL_22_RECEIPTADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "receiptadvice",
                                                                                                  VERSION_22);
  public static final DVRCoordinate VID_UBL_22_REMINDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "reminder",
                                                                                             VERSION_22);
  public static final DVRCoordinate VID_UBL_22_REMITTANCEADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "remittanceadvice",
                                                                                                     VERSION_22);
  public static final DVRCoordinate VID_UBL_22_REQUESTFORQUOTATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "requestforquotation",
                                                                                                        VERSION_22);
  public static final DVRCoordinate VID_UBL_22_RETAILEVENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "retailevent",
                                                                                                VERSION_22);
  public static final DVRCoordinate VID_UBL_22_SELFBILLEDCREDITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "selfbilledcreditnote",
                                                                                                         VERSION_22);
  public static final DVRCoordinate VID_UBL_22_SELFBILLEDINVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "selfbilledinvoice",
                                                                                                      VERSION_22);
  public static final DVRCoordinate VID_UBL_22_STATEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "statement",
                                                                                              VERSION_22);
  public static final DVRCoordinate VID_UBL_22_STOCKAVAILABILITYREPORT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                            "stockavailabilityreport",
                                                                                                            VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TENDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                           "tender",
                                                                                           VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TENDERCONTRACT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "tendercontract",
                                                                                                   VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TENDERERQUALIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "tendererqualification",
                                                                                                          VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TENDERERQUALIFICATIONRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "tendererqualificationresponse",
                                                                                                                  VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TENDERRECEIPT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "tenderreceipt",
                                                                                                  VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TENDERSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "tenderstatus",
                                                                                                 VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TENDERSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "tenderstatusrequest",
                                                                                                        VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TENDERWITHDRAWAL = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "tenderwithdrawal",
                                                                                                     VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TRADEITEMLOCATIONPROFILE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                             "tradeitemlocationprofile",
                                                                                                             VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TRANSPORTATIONSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "transportationstatus",
                                                                                                         VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TRANSPORTATIONSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "transportationstatusrequest",
                                                                                                                VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TRANSPORTEXECUTIONPLAN = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "transportexecutionplan",
                                                                                                           VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TRANSPORTEXECUTIONPLANREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "transportexecutionplanrequest",
                                                                                                                  VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TRANSPORTPROGRESSSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                            "transportprogressstatus",
                                                                                                            VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TRANSPORTPROGRESSSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                   "transportprogressstatusrequest",
                                                                                                                   VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TRANSPORTSERVICEDESCRIPTION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "transportservicedescription",
                                                                                                                VERSION_22);
  public static final DVRCoordinate VID_UBL_22_TRANSPORTSERVICEDESCRIPTIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                       "transportservicedescriptionrequest",
                                                                                                                       VERSION_22);
  public static final DVRCoordinate VID_UBL_22_UNAWARDEDNOTIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "unawardednotification",
                                                                                                          VERSION_22);
  public static final DVRCoordinate VID_UBL_22_UNSUBSCRIBEFROMPROCEDUREREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "unsubscribefromprocedurerequest",
                                                                                                                    VERSION_22);
  public static final DVRCoordinate VID_UBL_22_UNSUBSCRIBEFROMPROCEDURERESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "unsubscribefromprocedureresponse",
                                                                                                                     VERSION_22);
  public static final DVRCoordinate VID_UBL_22_UTILITYSTATEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "utilitystatement",
                                                                                                     VERSION_22);
  public static final DVRCoordinate VID_UBL_22_WAYBILL = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "waybill",
                                                                                            VERSION_22);
  public static final DVRCoordinate VID_UBL_22_WEIGHTSTATEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "weightstatement",
                                                                                                    VERSION_22);

  // UBL 2.3
  public static final DVRCoordinate VID_UBL_23_APPLICATIONRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "applicationresponse",
                                                                                                        VERSION_23);
  public static final DVRCoordinate VID_UBL_23_ATTACHEDDOCUMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "attacheddocument",
                                                                                                     VERSION_23);
  public static final DVRCoordinate VID_UBL_23_AWARDEDNOTIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "awardednotification",
                                                                                                        VERSION_23);
  public static final DVRCoordinate VID_UBL_23_BILLOFLADING = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "billoflading",
                                                                                                 VERSION_23);
  public static final DVRCoordinate VID_UBL_23_BUSINESSCARD = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "businesscard",
                                                                                                 VERSION_23);
  public static final DVRCoordinate VID_UBL_23_CALLFORTENDERS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "callfortenders",
                                                                                                   VERSION_23);
  public static final DVRCoordinate VID_UBL_23_CATALOGUE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "catalogue",
                                                                                              VERSION_23);
  public static final DVRCoordinate VID_UBL_23_CATALOGUEDELETION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "cataloguedeletion",
                                                                                                      VERSION_23);
  public static final DVRCoordinate VID_UBL_23_CATALOGUEITEMSPECIFICATIONUPDATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "catalogueitemspecificationupdate",
                                                                                                                     VERSION_23);
  public static final DVRCoordinate VID_UBL_23_CATALOGUEPRICINGUPDATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "cataloguepricingupdate",
                                                                                                           VERSION_23);
  public static final DVRCoordinate VID_UBL_23_CATALOGUEREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "cataloguerequest",
                                                                                                     VERSION_23);
  public static final DVRCoordinate VID_UBL_23_CERTIFICATEOFORIGIN = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "certificateoforigin",
                                                                                                        VERSION_23);
  public static final DVRCoordinate VID_UBL_23_COMMONTRANSPORTATIONREPORT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                               "commontransportationreport",
                                                                                                               VERSION_23);
  public static final DVRCoordinate VID_UBL_23_CONTRACTAWARDNOTICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "contractawardnotice",
                                                                                                        VERSION_23);
  public static final DVRCoordinate VID_UBL_23_CONTRACTNOTICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "contractnotice",
                                                                                                   VERSION_23);
  public static final DVRCoordinate VID_UBL_23_CREDITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "creditnote",
                                                                                               VERSION_23);
  public static final DVRCoordinate VID_UBL_23_DEBITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "debitnote",
                                                                                              VERSION_23);
  public static final DVRCoordinate VID_UBL_23_DESPATCHADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "despatchadvice",
                                                                                                   VERSION_23);
  public static final DVRCoordinate VID_UBL_23_DIGITALAGREEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "digitalagreement",
                                                                                                     VERSION_23);
  public static final DVRCoordinate VID_UBL_23_DIGITALCAPABILITY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "digitalcapability",
                                                                                                      VERSION_23);
  public static final DVRCoordinate VID_UBL_23_DOCUMENTSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "documentstatus",
                                                                                                   VERSION_23);
  public static final DVRCoordinate VID_UBL_23_DOCUMENTSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "documentstatusrequest",
                                                                                                          VERSION_23);
  public static final DVRCoordinate VID_UBL_23_ENQUIRY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "enquiry",
                                                                                            VERSION_23);
  public static final DVRCoordinate VID_UBL_23_ENQUIRYRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "enquiryresponse",
                                                                                                    VERSION_23);
  public static final DVRCoordinate VID_UBL_23_EXCEPTIONCRITERIA = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "exceptioncriteria",
                                                                                                      VERSION_23);
  public static final DVRCoordinate VID_UBL_23_EXCEPTIONNOTIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "exceptionnotification",
                                                                                                          VERSION_23);
  public static final DVRCoordinate VID_UBL_23_EXPORTCUSTOMSDECLARATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                             "exportcustomsdeclaration",
                                                                                                             VERSION_23);
  public static final DVRCoordinate VID_UBL_23_EXPRESSIONOFINTERESTREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "expressionofinterestrequest",
                                                                                                                VERSION_23);
  public static final DVRCoordinate VID_UBL_23_EXPRESSIONOFINTERESTRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                 "expressionofinterestresponse",
                                                                                                                 VERSION_23);
  public static final DVRCoordinate VID_UBL_23_FORECAST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "forecast",
                                                                                             VERSION_23);
  public static final DVRCoordinate VID_UBL_23_FORECASTREVISION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "forecastrevision",
                                                                                                     VERSION_23);
  public static final DVRCoordinate VID_UBL_23_FORWARDINGINSTRUCTIONS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "forwardinginstructions",
                                                                                                           VERSION_23);
  public static final DVRCoordinate VID_UBL_23_FREIGHTINVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "freightinvoice",
                                                                                                   VERSION_23);
  public static final DVRCoordinate VID_UBL_23_FULFILMENTCANCELLATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "fulfilmentcancellation",
                                                                                                           VERSION_23);
  public static final DVRCoordinate VID_UBL_23_GOODSCERTIFICATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "goodscertificate",
                                                                                                     VERSION_23);
  public static final DVRCoordinate VID_UBL_23_GOODSITEMITINERARY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "goodsitemitinerary",
                                                                                                       VERSION_23);
  public static final DVRCoordinate VID_UBL_23_GOODSITEMPASSPORT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "goodsitempassport",
                                                                                                      VERSION_23);
  public static final DVRCoordinate VID_UBL_23_GUARANTEECERTIFICATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "guaranteecertificate",
                                                                                                         VERSION_23);
  public static final DVRCoordinate VID_UBL_23_IMPORTCUSTOMSDECLARATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                             "importcustomsdeclaration",
                                                                                                             VERSION_23);
  public static final DVRCoordinate VID_UBL_23_INSTRUCTIONFORRETURNS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "instructionforreturns",
                                                                                                          VERSION_23);
  public static final DVRCoordinate VID_UBL_23_INVENTORYREPORT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "inventoryreport",
                                                                                                    VERSION_23);
  public static final DVRCoordinate VID_UBL_23_INVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "invoice",
                                                                                            VERSION_23);
  public static final DVRCoordinate VID_UBL_23_ITEMINFORMATIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "iteminformationrequest",
                                                                                                           VERSION_23);
  public static final DVRCoordinate VID_UBL_23_MANIFEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "manifest",
                                                                                             VERSION_23);
  public static final DVRCoordinate VID_UBL_23_ORDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                          "order",
                                                                                          VERSION_23);
  public static final DVRCoordinate VID_UBL_23_ORDERCANCELLATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "ordercancellation",
                                                                                                      VERSION_23);
  public static final DVRCoordinate VID_UBL_23_ORDERCHANGE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "orderchange",
                                                                                                VERSION_23);
  public static final DVRCoordinate VID_UBL_23_ORDERRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "orderresponse",
                                                                                                  VERSION_23);
  public static final DVRCoordinate VID_UBL_23_ORDERRESPONSESIMPLE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "orderresponsesimple",
                                                                                                        VERSION_23);
  public static final DVRCoordinate VID_UBL_23_PACKINGLIST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "packinglist",
                                                                                                VERSION_23);
  public static final DVRCoordinate VID_UBL_23_PRIORINFORMATIONNOTICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "priorinformationnotice",
                                                                                                           VERSION_23);
  public static final DVRCoordinate VID_UBL_23_PRODUCTACTIVITY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "productactivity",
                                                                                                    VERSION_23);
  public static final DVRCoordinate VID_UBL_23_PROOFOFREEXPORTATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "proofofreexportation",
                                                                                                         VERSION_23);
  public static final DVRCoordinate VID_UBL_23_PROOFOFREEXPORTATIONREMINDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                 "proofofreexportationreminder",
                                                                                                                 VERSION_23);
  public static final DVRCoordinate VID_UBL_23_PROOFOFREEXPORTATIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "proofofreexportationrequest",
                                                                                                                VERSION_23);
  public static final DVRCoordinate VID_UBL_23_QUALIFICATIONAPPLICATIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "qualificationapplicationrequest",
                                                                                                                    VERSION_23);
  public static final DVRCoordinate VID_UBL_23_QUALIFICATIONAPPLICATIONRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "qualificationapplicationresponse",
                                                                                                                     VERSION_23);
  public static final DVRCoordinate VID_UBL_23_QUOTATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "quotation",
                                                                                              VERSION_23);
  public static final DVRCoordinate VID_UBL_23_RECEIPTADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "receiptadvice",
                                                                                                  VERSION_23);
  public static final DVRCoordinate VID_UBL_23_REMINDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "reminder",
                                                                                             VERSION_23);
  public static final DVRCoordinate VID_UBL_23_REMITTANCEADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "remittanceadvice",
                                                                                                     VERSION_23);
  public static final DVRCoordinate VID_UBL_23_REQUESTFORQUOTATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "requestforquotation",
                                                                                                        VERSION_23);
  public static final DVRCoordinate VID_UBL_23_RETAILEVENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "retailevent",
                                                                                                VERSION_23);
  public static final DVRCoordinate VID_UBL_23_SELFBILLEDCREDITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "selfbilledcreditnote",
                                                                                                         VERSION_23);
  public static final DVRCoordinate VID_UBL_23_SELFBILLEDINVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "selfbilledinvoice",
                                                                                                      VERSION_23);
  public static final DVRCoordinate VID_UBL_23_STATEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "statement",
                                                                                              VERSION_23);
  public static final DVRCoordinate VID_UBL_23_STOCKAVAILABILITYREPORT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                            "stockavailabilityreport",
                                                                                                            VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TENDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                           "tender",
                                                                                           VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TENDERCONTRACT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "tendercontract",
                                                                                                   VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TENDERERQUALIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "tendererqualification",
                                                                                                          VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TENDERERQUALIFICATIONRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "tendererqualificationresponse",
                                                                                                                  VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TENDERRECEIPT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "tenderreceipt",
                                                                                                  VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TENDERSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "tenderstatus",
                                                                                                 VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TENDERSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "tenderstatusrequest",
                                                                                                        VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TENDERWITHDRAWAL = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "tenderwithdrawal",
                                                                                                     VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TRADEITEMLOCATIONPROFILE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                             "tradeitemlocationprofile",
                                                                                                             VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TRANSITCUSTOMSDECLARATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                              "transitcustomsdeclaration",
                                                                                                              VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TRANSPORTATIONSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "transportationstatus",
                                                                                                         VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TRANSPORTATIONSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "transportationstatusrequest",
                                                                                                                VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TRANSPORTEXECUTIONPLAN = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "transportexecutionplan",
                                                                                                           VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TRANSPORTEXECUTIONPLANREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "transportexecutionplanrequest",
                                                                                                                  VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TRANSPORTPROGRESSSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                            "transportprogressstatus",
                                                                                                            VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TRANSPORTPROGRESSSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                   "transportprogressstatusrequest",
                                                                                                                   VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TRANSPORTSERVICEDESCRIPTION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "transportservicedescription",
                                                                                                                VERSION_23);
  public static final DVRCoordinate VID_UBL_23_TRANSPORTSERVICEDESCRIPTIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                       "transportservicedescriptionrequest",
                                                                                                                       VERSION_23);
  public static final DVRCoordinate VID_UBL_23_UNAWARDEDNOTIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "unawardednotification",
                                                                                                          VERSION_23);
  public static final DVRCoordinate VID_UBL_23_UNSUBSCRIBEFROMPROCEDUREREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "unsubscribefromprocedurerequest",
                                                                                                                    VERSION_23);
  public static final DVRCoordinate VID_UBL_23_UNSUBSCRIBEFROMPROCEDURERESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "unsubscribefromprocedureresponse",
                                                                                                                     VERSION_23);
  public static final DVRCoordinate VID_UBL_23_UTILITYSTATEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "utilitystatement",
                                                                                                     VERSION_23);
  public static final DVRCoordinate VID_UBL_23_WAYBILL = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "waybill",
                                                                                            VERSION_23);
  public static final DVRCoordinate VID_UBL_23_WEIGHTSTATEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "weightstatement",
                                                                                                    VERSION_23);

  // UBL 2.4
  public static final DVRCoordinate VID_UBL_24_APPLICATIONRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "applicationresponse",
                                                                                                        VERSION_24);
  public static final DVRCoordinate VID_UBL_24_ATTACHEDDOCUMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "attacheddocument",
                                                                                                     VERSION_24);
  public static final DVRCoordinate VID_UBL_24_AWARDEDNOTIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "awardednotification",
                                                                                                        VERSION_24);
  public static final DVRCoordinate VID_UBL_24_BILLOFLADING = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "billoflading",
                                                                                                 VERSION_24);
  public static final DVRCoordinate VID_UBL_24_BUSINESSCARD = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "businesscard",
                                                                                                 VERSION_24);
  public static final DVRCoordinate VID_UBL_24_BUSINESSINFORMATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "businessinformation",
                                                                                                        VERSION_24);
  public static final DVRCoordinate VID_UBL_24_CALLFORTENDERS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "callfortenders",
                                                                                                   VERSION_24);
  public static final DVRCoordinate VID_UBL_24_CATALOGUE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "catalogue",
                                                                                              VERSION_24);
  public static final DVRCoordinate VID_UBL_24_CATALOGUEDELETION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "cataloguedeletion",
                                                                                                      VERSION_24);
  public static final DVRCoordinate VID_UBL_24_CATALOGUEITEMSPECIFICATIONUPDATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "catalogueitemspecificationupdate",
                                                                                                                     VERSION_24);
  public static final DVRCoordinate VID_UBL_24_CATALOGUEPRICINGUPDATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "cataloguepricingupdate",
                                                                                                           VERSION_24);
  public static final DVRCoordinate VID_UBL_24_CATALOGUEREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "cataloguerequest",
                                                                                                     VERSION_24);
  public static final DVRCoordinate VID_UBL_24_CERTIFICATEOFORIGIN = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "certificateoforigin",
                                                                                                        VERSION_24);
  public static final DVRCoordinate VID_UBL_24_COMMONTRANSPORTATIONREPORT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                               "commontransportationreport",
                                                                                                               VERSION_24);
  public static final DVRCoordinate VID_UBL_24_CONTRACTAWARDNOTICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "contractawardnotice",
                                                                                                        VERSION_24);
  public static final DVRCoordinate VID_UBL_24_CONTRACTNOTICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "contractnotice",
                                                                                                   VERSION_24);
  public static final DVRCoordinate VID_UBL_24_CREDITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "creditnote",
                                                                                               VERSION_24);
  public static final DVRCoordinate VID_UBL_24_DEBITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "debitnote",
                                                                                              VERSION_24);
  public static final DVRCoordinate VID_UBL_24_DESPATCHADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "despatchadvice",
                                                                                                   VERSION_24);
  public static final DVRCoordinate VID_UBL_24_DIGITALAGREEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "digitalagreement",
                                                                                                     VERSION_24);
  public static final DVRCoordinate VID_UBL_24_DIGITALCAPABILITY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "digitalcapability",
                                                                                                      VERSION_24);
  public static final DVRCoordinate VID_UBL_24_DOCUMENTSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "documentstatus",
                                                                                                   VERSION_24);
  public static final DVRCoordinate VID_UBL_24_DOCUMENTSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "documentstatusrequest",
                                                                                                          VERSION_24);
  public static final DVRCoordinate VID_UBL_24_ENQUIRY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "enquiry",
                                                                                            VERSION_24);
  public static final DVRCoordinate VID_UBL_24_ENQUIRYRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "enquiryresponse",
                                                                                                    VERSION_24);
  public static final DVRCoordinate VID_UBL_24_EXCEPTIONCRITERIA = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "exceptioncriteria",
                                                                                                      VERSION_24);
  public static final DVRCoordinate VID_UBL_24_EXCEPTIONNOTIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "exceptionnotification",
                                                                                                          VERSION_24);
  public static final DVRCoordinate VID_UBL_24_EXPORTCUSTOMSDECLARATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                             "exportcustomsdeclaration",
                                                                                                             VERSION_24);
  public static final DVRCoordinate VID_UBL_24_EXPRESSIONOFINTERESTREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "expressionofinterestrequest",
                                                                                                                VERSION_24);
  public static final DVRCoordinate VID_UBL_24_EXPRESSIONOFINTERESTRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                 "expressionofinterestresponse",
                                                                                                                 VERSION_24);
  public static final DVRCoordinate VID_UBL_24_FORECAST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "forecast",
                                                                                             VERSION_24);
  public static final DVRCoordinate VID_UBL_24_FORECASTREVISION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "forecastrevision",
                                                                                                     VERSION_24);
  public static final DVRCoordinate VID_UBL_24_FORWARDINGINSTRUCTIONS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "forwardinginstructions",
                                                                                                           VERSION_24);
  public static final DVRCoordinate VID_UBL_24_FREIGHTINVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "freightinvoice",
                                                                                                   VERSION_24);
  public static final DVRCoordinate VID_UBL_24_FULFILMENTCANCELLATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "fulfilmentcancellation",
                                                                                                           VERSION_24);
  public static final DVRCoordinate VID_UBL_24_GOODSCERTIFICATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "goodscertificate",
                                                                                                     VERSION_24);
  public static final DVRCoordinate VID_UBL_24_GOODSITEMITINERARY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "goodsitemitinerary",
                                                                                                       VERSION_24);
  public static final DVRCoordinate VID_UBL_24_GOODSITEMPASSPORT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "goodsitempassport",
                                                                                                      VERSION_24);
  public static final DVRCoordinate VID_UBL_24_GUARANTEECERTIFICATE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "guaranteecertificate",
                                                                                                         VERSION_24);
  public static final DVRCoordinate VID_UBL_24_IMPORTCUSTOMSDECLARATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                             "importcustomsdeclaration",
                                                                                                             VERSION_24);
  public static final DVRCoordinate VID_UBL_24_INSTRUCTIONFORRETURNS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "instructionforreturns",
                                                                                                          VERSION_24);
  public static final DVRCoordinate VID_UBL_24_INVENTORYREPORT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "inventoryreport",
                                                                                                    VERSION_24);
  public static final DVRCoordinate VID_UBL_24_INVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "invoice",
                                                                                            VERSION_24);
  public static final DVRCoordinate VID_UBL_24_ITEMINFORMATIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "iteminformationrequest",
                                                                                                           VERSION_24);
  public static final DVRCoordinate VID_UBL_24_MANIFEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "manifest",
                                                                                             VERSION_24);
  public static final DVRCoordinate VID_UBL_24_ORDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                          "order",
                                                                                          VERSION_24);
  public static final DVRCoordinate VID_UBL_24_ORDERCANCELLATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "ordercancellation",
                                                                                                      VERSION_24);
  public static final DVRCoordinate VID_UBL_24_ORDERCHANGE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "orderchange",
                                                                                                VERSION_24);
  public static final DVRCoordinate VID_UBL_24_ORDERRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "orderresponse",
                                                                                                  VERSION_24);
  public static final DVRCoordinate VID_UBL_24_ORDERRESPONSESIMPLE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "orderresponsesimple",
                                                                                                        VERSION_24);
  public static final DVRCoordinate VID_UBL_24_PACKINGLIST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "packinglist",
                                                                                                VERSION_24);
  public static final DVRCoordinate VID_UBL_24_PRIORINFORMATIONNOTICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "priorinformationnotice",
                                                                                                           VERSION_24);
  public static final DVRCoordinate VID_UBL_24_PRODUCTACTIVITY = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "productactivity",
                                                                                                    VERSION_24);
  public static final DVRCoordinate VID_UBL_24_PROOFOFREEXPORTATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "proofofreexportation",
                                                                                                         VERSION_24);
  public static final DVRCoordinate VID_UBL_24_PROOFOFREEXPORTATIONREMINDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                 "proofofreexportationreminder",
                                                                                                                 VERSION_24);
  public static final DVRCoordinate VID_UBL_24_PROOFOFREEXPORTATIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "proofofreexportationrequest",
                                                                                                                VERSION_24);
  public static final DVRCoordinate VID_UBL_24_PURCHASERECEIPT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "purchasereceipt",
                                                                                                    VERSION_24);
  public static final DVRCoordinate VID_UBL_24_QUALIFICATIONAPPLICATIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "qualificationapplicationrequest",
                                                                                                                    VERSION_24);
  public static final DVRCoordinate VID_UBL_24_QUALIFICATIONAPPLICATIONRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "qualificationapplicationresponse",
                                                                                                                     VERSION_24);
  public static final DVRCoordinate VID_UBL_24_QUOTATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "quotation",
                                                                                              VERSION_24);
  public static final DVRCoordinate VID_UBL_24_RECEIPTADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "receiptadvice",
                                                                                                  VERSION_24);
  public static final DVRCoordinate VID_UBL_24_REMINDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "reminder",
                                                                                             VERSION_24);
  public static final DVRCoordinate VID_UBL_24_REMITTANCEADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "remittanceadvice",
                                                                                                     VERSION_24);
  public static final DVRCoordinate VID_UBL_24_REQUESTFORQUOTATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "requestforquotation",
                                                                                                        VERSION_24);
  public static final DVRCoordinate VID_UBL_24_RETAILEVENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "retailevent",
                                                                                                VERSION_24);
  public static final DVRCoordinate VID_UBL_24_SELFBILLEDCREDITNOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "selfbilledcreditnote",
                                                                                                         VERSION_24);
  public static final DVRCoordinate VID_UBL_24_SELFBILLEDINVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "selfbilledinvoice",
                                                                                                      VERSION_24);
  public static final DVRCoordinate VID_UBL_24_STATEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "statement",
                                                                                              VERSION_24);
  public static final DVRCoordinate VID_UBL_24_STOCKAVAILABILITYREPORT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                            "stockavailabilityreport",
                                                                                                            VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TENDER = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                           "tender",
                                                                                           VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TENDERCONTRACT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "tendercontract",
                                                                                                   VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TENDERERQUALIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "tendererqualification",
                                                                                                          VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TENDERERQUALIFICATIONRESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "tendererqualificationresponse",
                                                                                                                  VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TENDERRECEIPT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "tenderreceipt",
                                                                                                  VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TENDERSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "tenderstatus",
                                                                                                 VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TENDERSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "tenderstatusrequest",
                                                                                                        VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TENDERWITHDRAWAL = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "tenderwithdrawal",
                                                                                                     VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TRADEITEMLOCATIONPROFILE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                             "tradeitemlocationprofile",
                                                                                                             VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TRANSITCUSTOMSDECLARATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                              "transitcustomsdeclaration",
                                                                                                              VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TRANSPORTATIONSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "transportationstatus",
                                                                                                         VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TRANSPORTATIONSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "transportationstatusrequest",
                                                                                                                VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TRANSPORTEXECUTIONPLAN = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "transportexecutionplan",
                                                                                                           VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TRANSPORTEXECUTIONPLANREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "transportexecutionplanrequest",
                                                                                                                  VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TRANSPORTPROGRESSSTATUS = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                            "transportprogressstatus",
                                                                                                            VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TRANSPORTPROGRESSSTATUSREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                   "transportprogressstatusrequest",
                                                                                                                   VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TRANSPORTSERVICEDESCRIPTION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "transportservicedescription",
                                                                                                                VERSION_24);
  public static final DVRCoordinate VID_UBL_24_TRANSPORTSERVICEDESCRIPTIONREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                       "transportservicedescriptionrequest",
                                                                                                                       VERSION_24);
  public static final DVRCoordinate VID_UBL_24_UNAWARDEDNOTIFICATION = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "unawardednotification",
                                                                                                          VERSION_24);
  public static final DVRCoordinate VID_UBL_24_UNSUBSCRIBEFROMPROCEDUREREQUEST = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "unsubscribefromprocedurerequest",
                                                                                                                    VERSION_24);
  public static final DVRCoordinate VID_UBL_24_UNSUBSCRIBEFROMPROCEDURERESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "unsubscribefromprocedureresponse",
                                                                                                                     VERSION_24);
  public static final DVRCoordinate VID_UBL_24_UTILITYSTATEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "utilitystatement",
                                                                                                     VERSION_24);
  public static final DVRCoordinate VID_UBL_24_WAYBILL = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "waybill",
                                                                                            VERSION_24);
  public static final DVRCoordinate VID_UBL_24_WEIGHTSTATEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "weightstatement",
                                                                                                    VERSION_24);

  private UBLValidation ()
  {}

  /**
   * Register all standard UBL validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   * @since 5.1.15
   */
  public static void initUBLAllVersions (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    initUBL20 (aRegistry);
    initUBL21 (aRegistry);
    initUBL22 (aRegistry);
    initUBL23 (aRegistry);
    initUBL24 (aRegistry);
  }

  /**
   * Register all standard UBL 2.0 validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initUBL20 (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // No Schematrons here
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_APPLICATIONRESPONSE)
                     .displayName ("UBL Application Response " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllApplicationResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_ATTACHEDDOCUMENT)
                     .displayName ("UBL Attached Document " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllAttachedDocumentXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_BILLOFLADING)
                     .displayName ("UBL Bill Of Lading " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllBillOfLadingXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_CATALOGUE)
                     .displayName ("UBL Catalogue " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllCatalogueXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_CATALOGUEDELETION)
                     .displayName ("UBL Catalogue Deletion " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllCatalogueDeletionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_CATALOGUEITEMSPECIFICATIONUPDATE)
                     .displayName ("UBL Catalogue Item Specification Update " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_CATALOGUEPRICINGUPDATE)
                     .displayName ("UBL Catalogue Pricing Update " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllCataloguePricingUpdateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_CATALOGUEREQUEST)
                     .displayName ("UBL Catalogue Request " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllCatalogueRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_CERTIFICATEOFORIGIN)
                     .displayName ("UBL Certificate Of Origin " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllCertificateOfOriginXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_CREDITNOTE)
                     .displayName ("UBL Credit Note " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllCreditNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_DEBITNOTE)
                     .displayName ("UBL Debit Note " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllDebitNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_DESPATCHADVICE)
                     .displayName ("UBL Despatch Advice " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllDespatchAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_FORWARDINGINSTRUCTIONS)
                     .displayName ("UBL Forwarding Instructions " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllForwardingInstructionsXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_FREIGHTINVOICE)
                     .displayName ("UBL Freight Invoice " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllFreightInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_INVOICE)
                     .displayName ("UBL Invoice " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_ORDER)
                     .displayName ("UBL Order " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllOrderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_ORDERCANCELLATION)
                     .displayName ("UBL Order Cancellation " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllOrderCancellationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_ORDERCHANGE)
                     .displayName ("UBL Order Change " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllOrderChangeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_ORDERRESPONSE)
                     .displayName ("UBL Order Response " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllOrderResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_ORDERRESPONSESIMPLE)
                     .displayName ("UBL Order Response Simple " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllOrderResponseSimpleXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_PACKINGLIST)
                     .displayName ("UBL Packing List " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllPackingListXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_QUOTATION)
                     .displayName ("UBL Quotation " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllQuotationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_RECEIPTADVICE)
                     .displayName ("UBL Receipt Advice " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllReceiptAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_REMINDER)
                     .displayName ("UBL Reminder " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllReminderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_REMITTANCEADVICE)
                     .displayName ("UBL Remittance Advice " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllRemittanceAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_REQUESTFORQUOTATION)
                     .displayName ("UBL Request For Quotation " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllRequestForQuotationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_SELFBILLEDCREDITNOTE)
                     .displayName ("UBL Self Billed Credit Note " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllSelfBilledCreditNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_SELFBILLEDINVOICE)
                     .displayName ("UBL Self Billed Invoice " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllSelfBilledInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_STATEMENT)
                     .displayName ("UBL Statement " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllStatementXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_TRANSPORTATIONSTATUS)
                     .displayName ("UBL Transportation Status " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllTransportationStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_20_WAYBILL)
                     .displayName ("UBL Waybill " + VERSION_20)
                     .notDeprecated ()
                     .addXSD (UBL20Marshaller.getAllWaybillXSDs ())
                     .registerInto ();
  }

  /**
   * Register all standard UBL 2.1 validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initUBL21 (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_APPLICATIONRESPONSE)
                     .displayName ("UBL Application Response " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_ATTACHEDDOCUMENT)
                     .displayName ("UBL Attached Document " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllAttachedDocumentXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_AWARDEDNOTIFICATION)
                     .displayName ("UBL Awarded Notification " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllAwardedNotificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_BILLOFLADING)
                     .displayName ("UBL Bill Of Lading " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllBillOfLadingXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_CALLFORTENDERS)
                     .displayName ("UBL Call For Tenders " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllCallForTendersXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_CATALOGUE)
                     .displayName ("UBL Catalogue " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllCatalogueXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_CATALOGUEDELETION)
                     .displayName ("UBL Catalogue Deletion " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllCatalogueDeletionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_CATALOGUEITEMSPECIFICATIONUPDATE)
                     .displayName ("UBL Catalogue Item Specification Update " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_CATALOGUEPRICINGUPDATE)
                     .displayName ("UBL Catalogue Pricing Update " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllCataloguePricingUpdateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_CATALOGUEREQUEST)
                     .displayName ("UBL Catalogue Request " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllCatalogueRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_CERTIFICATEOFORIGIN)
                     .displayName ("UBL Certificate Of Origin " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllCertificateOfOriginXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_CONTRACTAWARDNOTICE)
                     .displayName ("UBL Contract Award Notice " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllContractAwardNoticeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_CONTRACTNOTICE)
                     .displayName ("UBL Contract Notice " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllContractNoticeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_CREDITNOTE)
                     .displayName ("UBL Credit Note " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_DEBITNOTE)
                     .displayName ("UBL Debit Note " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllDebitNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_DESPATCHADVICE)
                     .displayName ("UBL Despatch Advice " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllDespatchAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_DOCUMENTSTATUS)
                     .displayName ("UBL Document Status " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllDocumentStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_DOCUMENTSTATUSREQUEST)
                     .displayName ("UBL Document Status Request " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllDocumentStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_EXCEPTIONCRITERIA)
                     .displayName ("UBL Exception Criteria " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllExceptionCriteriaXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_EXCEPTIONNOTIFICATION)
                     .displayName ("UBL Exception Notification " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllExceptionNotificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_FORECAST)
                     .displayName ("UBL Forecast " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllForecastXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_FORECASTREVISION)
                     .displayName ("UBL Forecast Revision " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllForecastRevisionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_FORWARDINGINSTRUCTIONS)
                     .displayName ("UBL Forwarding Instructions " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllForwardingInstructionsXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_FREIGHTINVOICE)
                     .displayName ("UBL Freight Invoice " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllFreightInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_FULFILMENTCANCELLATION)
                     .displayName ("UBL Fulfilment Cancellation " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllFulfilmentCancellationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_GOODSITEMITINERARY)
                     .displayName ("UBL Goods Item Itinerary " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllGoodsItemItineraryXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_GUARANTEECERTIFICATE)
                     .displayName ("UBL Guarantee Certificate " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllGuaranteeCertificateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_INSTRUCTIONFORRETURNS)
                     .displayName ("UBL Instruction For Returns " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllInstructionForReturnsXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_INVENTORYREPORT)
                     .displayName ("UBL Inventory Report " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllInventoryReportXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_INVOICE)
                     .displayName ("UBL Invoice " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_ITEMINFORMATIONREQUEST)
                     .displayName ("UBL Item Information Request " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllItemInformationRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_ORDER)
                     .displayName ("UBL Order " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_ORDERCANCELLATION)
                     .displayName ("UBL Order Cancellation " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderCancellationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_ORDERCHANGE)
                     .displayName ("UBL Order Change " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderChangeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_ORDERRESPONSE)
                     .displayName ("UBL Order Response " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_ORDERRESPONSESIMPLE)
                     .displayName ("UBL Order Response Simple " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderResponseSimpleXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_PACKINGLIST)
                     .displayName ("UBL Packing List " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllPackingListXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_PRIORINFORMATIONNOTICE)
                     .displayName ("UBL Prior Information Notice " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllPriorInformationNoticeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_PRODUCTACTIVITY)
                     .displayName ("UBL Product Activity " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllProductActivityXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_QUOTATION)
                     .displayName ("UBL Quotation " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllQuotationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_RECEIPTADVICE)
                     .displayName ("UBL Receipt Advice " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllReceiptAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_REMINDER)
                     .displayName ("UBL Reminder " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllReminderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_REMITTANCEADVICE)
                     .displayName ("UBL Remittance Advice " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllRemittanceAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_REQUESTFORQUOTATION)
                     .displayName ("UBL Request For Quotation " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllRequestForQuotationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_RETAILEVENT)
                     .displayName ("UBL Retail Event " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllRetailEventXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_SELFBILLEDCREDITNOTE)
                     .displayName ("UBL Self Billed Credit Note " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllSelfBilledCreditNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_SELFBILLEDINVOICE)
                     .displayName ("UBL Self Billed Invoice " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllSelfBilledInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_STATEMENT)
                     .displayName ("UBL Statement " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllStatementXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_STOCKAVAILABILITYREPORT)
                     .displayName ("UBL Stock Availability Report " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllStockAvailabilityReportXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TENDER)
                     .displayName ("UBL Tender " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTenderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TENDERERQUALIFICATION)
                     .displayName ("UBL Tenderer Qualification " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTendererQualificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TENDERERQUALIFICATIONRESPONSE)
                     .displayName ("UBL Tenderer Qualification Response " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTendererQualificationResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TENDERRECEIPT)
                     .displayName ("UBL Tender Receipt " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTenderReceiptXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TRADEITEMLOCATIONPROFILE)
                     .displayName ("UBL Trade Item Location Profile " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTradeItemLocationProfileXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TRANSPORTATIONSTATUS)
                     .displayName ("UBL Transportation Status " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTransportationStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TRANSPORTATIONSTATUSREQUEST)
                     .displayName ("UBL Transportation Status Request " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTransportationStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TRANSPORTEXECUTIONPLAN)
                     .displayName ("UBL Transport Execution Plan " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTransportExecutionPlanXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TRANSPORTEXECUTIONPLANREQUEST)
                     .displayName ("UBL Transport Execution Plan Request " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTransportExecutionPlanRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TRANSPORTPROGRESSSTATUS)
                     .displayName ("UBL Transport Progress Status " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTransportProgressStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TRANSPORTPROGRESSSTATUSREQUEST)
                     .displayName ("UBL Transport Progress Status Request " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTransportProgressStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TRANSPORTSERVICEDESCRIPTION)
                     .displayName ("UBL Transport Service Description " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTransportServiceDescriptionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_TRANSPORTSERVICEDESCRIPTIONREQUEST)
                     .displayName ("UBL Transport Service Description Request " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllTransportServiceDescriptionRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_UNAWARDEDNOTIFICATION)
                     .displayName ("UBL Unawarded Notification " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllUnawardedNotificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_UTILITYSTATEMENT)
                     .displayName ("UBL Utility Statement " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllUtilityStatementXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_21_WAYBILL)
                     .displayName ("UBL Waybill " + VERSION_21)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllWaybillXSDs ())
                     .registerInto ();
  }

  /**
   * Register all standard UBL 2.2 validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initUBL22 (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_APPLICATIONRESPONSE)
                     .displayName ("UBL Application Response " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllApplicationResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_ATTACHEDDOCUMENT)
                     .displayName ("UBL Attached Document " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllAttachedDocumentXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_AWARDEDNOTIFICATION)
                     .displayName ("UBL Awarded Notification " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllAwardedNotificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_BILLOFLADING)
                     .displayName ("UBL Bill Of Lading " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllBillOfLadingXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_BUSINESSCARD)
                     .displayName ("UBL Business Card " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllBusinessCardXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_CALLFORTENDERS)
                     .displayName ("UBL Call For Tenders " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllCallForTendersXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_CATALOGUE)
                     .displayName ("UBL Catalogue " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllCatalogueXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_CATALOGUEDELETION)
                     .displayName ("UBL Catalogue Deletion " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllCatalogueDeletionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_CATALOGUEITEMSPECIFICATIONUPDATE)
                     .displayName ("UBL Catalogue Item Specification Update " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_CATALOGUEPRICINGUPDATE)
                     .displayName ("UBL Catalogue Pricing Update " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllCataloguePricingUpdateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_CATALOGUEREQUEST)
                     .displayName ("UBL Catalogue Request " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllCatalogueRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_CERTIFICATEOFORIGIN)
                     .displayName ("UBL Certificate Of Origin " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllCertificateOfOriginXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_CONTRACTAWARDNOTICE)
                     .displayName ("UBL Contract Award Notice " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllContractAwardNoticeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_CONTRACTNOTICE)
                     .displayName ("UBL Contract Notice " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllContractNoticeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_CREDITNOTE)
                     .displayName ("UBL Credit Note " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllCreditNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_DEBITNOTE)
                     .displayName ("UBL Debit Note " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllDebitNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_DESPATCHADVICE)
                     .displayName ("UBL Despatch Advice " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllDespatchAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_DIGITALAGREEMENT)
                     .displayName ("UBL Digital Agreement " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllDigitalAgreementXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_DIGITALCAPABILITY)
                     .displayName ("UBL Digital Capability " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllDigitalCapabilityXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_DOCUMENTSTATUS)
                     .displayName ("UBL Document Status " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllDocumentStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_DOCUMENTSTATUSREQUEST)
                     .displayName ("UBL Document Status Request " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllDocumentStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_ENQUIRY)
                     .displayName ("UBL Enquiry " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllEnquiryXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_ENQUIRYRESPONSE)
                     .displayName ("UBL Enquiry Response " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllEnquiryResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_EXCEPTIONCRITERIA)
                     .displayName ("UBL Exception Criteria " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllExceptionCriteriaXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_EXCEPTIONNOTIFICATION)
                     .displayName ("UBL Exception Notification " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllExceptionNotificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_EXPRESSIONOFINTERESTREQUEST)
                     .displayName ("UBL Expression Of Interest Request " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllExpressionOfInterestRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_EXPRESSIONOFINTERESTRESPONSE)
                     .displayName ("UBL Expression Of Interest Response " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllExpressionOfInterestResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_FORECAST)
                     .displayName ("UBL Forecast " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllForecastXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_FORECASTREVISION)
                     .displayName ("UBL Forecast Revision " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllForecastRevisionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_FORWARDINGINSTRUCTIONS)
                     .displayName ("UBL Forwarding Instructions " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllForwardingInstructionsXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_FREIGHTINVOICE)
                     .displayName ("UBL Freight Invoice " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllFreightInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_FULFILMENTCANCELLATION)
                     .displayName ("UBL Fulfilment Cancellation " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllFulfilmentCancellationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_GOODSITEMITINERARY)
                     .displayName ("UBL Goods Item Itinerary " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllGoodsItemItineraryXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_GUARANTEECERTIFICATE)
                     .displayName ("UBL Guarantee Certificate " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllGuaranteeCertificateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_INSTRUCTIONFORRETURNS)
                     .displayName ("UBL Instruction For Returns " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllInstructionForReturnsXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_INVENTORYREPORT)
                     .displayName ("UBL Inventory Report " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllInventoryReportXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_INVOICE)
                     .displayName ("UBL Invoice " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_ITEMINFORMATIONREQUEST)
                     .displayName ("UBL Item Information Request " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllItemInformationRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_ORDER)
                     .displayName ("UBL Order " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllOrderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_ORDERCANCELLATION)
                     .displayName ("UBL Order Cancellation " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllOrderCancellationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_ORDERCHANGE)
                     .displayName ("UBL Order Change " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllOrderChangeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_ORDERRESPONSE)
                     .displayName ("UBL Order Response " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllOrderResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_ORDERRESPONSESIMPLE)
                     .displayName ("UBL Order Response Simple " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllOrderResponseSimpleXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_PACKINGLIST)
                     .displayName ("UBL Packing List " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllPackingListXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_PRIORINFORMATIONNOTICE)
                     .displayName ("UBL Prior Information Notice " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllPriorInformationNoticeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_PRODUCTACTIVITY)
                     .displayName ("UBL Product Activity " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllProductActivityXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_QUALIFICATIONAPPLICATIONREQUEST)
                     .displayName ("UBL Qualification Application Request " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllQualificationApplicationRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_QUALIFICATIONAPPLICATIONRESPONSE)
                     .displayName ("UBL Qualification Application Response " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllQualificationApplicationResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_QUOTATION)
                     .displayName ("UBL Quotation " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllQuotationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_RECEIPTADVICE)
                     .displayName ("UBL Receipt Advice " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllReceiptAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_REMINDER)
                     .displayName ("UBL Reminder " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllReminderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_REMITTANCEADVICE)
                     .displayName ("UBL Remittance Advice " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllRemittanceAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_REQUESTFORQUOTATION)
                     .displayName ("UBL Request For Quotation " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllRequestForQuotationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_RETAILEVENT)
                     .displayName ("UBL Retail Event " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllRetailEventXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_SELFBILLEDCREDITNOTE)
                     .displayName ("UBL Self Billed Credit Note " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllSelfBilledCreditNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_SELFBILLEDINVOICE)
                     .displayName ("UBL Self Billed Invoice " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllSelfBilledInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_STATEMENT)
                     .displayName ("UBL Statement " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllStatementXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_STOCKAVAILABILITYREPORT)
                     .displayName ("UBL Stock Availability Report " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllStockAvailabilityReportXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TENDER)
                     .displayName ("UBL Tender " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTenderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TENDERCONTRACT)
                     .displayName ("UBL Tender Contract " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTenderContractXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TENDERERQUALIFICATION)
                     .displayName ("UBL Tenderer Qualification " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTendererQualificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TENDERERQUALIFICATIONRESPONSE)
                     .displayName ("UBL Tenderer Qualification Response " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTendererQualificationResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TENDERRECEIPT)
                     .displayName ("UBL Tender Receipt " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTenderReceiptXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TENDERSTATUS)
                     .displayName ("UBL Tender Status " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTenderStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TENDERSTATUSREQUEST)
                     .displayName ("UBL Tender Status Request " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTenderStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TENDERWITHDRAWAL)
                     .displayName ("UBL Tender Withdrawal " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTenderWithdrawalXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TRADEITEMLOCATIONPROFILE)
                     .displayName ("UBL Trade Item Location Profile " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTradeItemLocationProfileXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TRANSPORTATIONSTATUS)
                     .displayName ("UBL Transportation Status " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTransportationStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TRANSPORTATIONSTATUSREQUEST)
                     .displayName ("UBL Transportation Status Request " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTransportationStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TRANSPORTEXECUTIONPLAN)
                     .displayName ("UBL Transport Execution Plan " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTransportExecutionPlanXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TRANSPORTEXECUTIONPLANREQUEST)
                     .displayName ("UBL Transport Execution Plan Request " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTransportExecutionPlanRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TRANSPORTPROGRESSSTATUS)
                     .displayName ("UBL Transport Progress Status " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTransportProgressStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TRANSPORTPROGRESSSTATUSREQUEST)
                     .displayName ("UBL Transport Progress Status Request " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTransportProgressStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TRANSPORTSERVICEDESCRIPTION)
                     .displayName ("UBL Transport Service Description " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTransportServiceDescriptionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_TRANSPORTSERVICEDESCRIPTIONREQUEST)
                     .displayName ("UBL Transport Service Description Request " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllTransportServiceDescriptionRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_UNAWARDEDNOTIFICATION)
                     .displayName ("UBL Unawarded Notification " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllUnawardedNotificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_UNSUBSCRIBEFROMPROCEDUREREQUEST)
                     .displayName ("UBL Unsubscribe From Procedure Request " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllUnsubscribeFromProcedureRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_UNSUBSCRIBEFROMPROCEDURERESPONSE)
                     .displayName ("UBL Unsubscribe From Procedure Response " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllUnsubscribeFromProcedureResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_UTILITYSTATEMENT)
                     .displayName ("UBL Utility Statement " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllUtilityStatementXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_WAYBILL)
                     .displayName ("UBL Waybill " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllWaybillXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_22_WEIGHTSTATEMENT)
                     .displayName ("UBL Weight Statement " + VERSION_22)
                     .notDeprecated ()
                     .addXSD (UBL22Marshaller.getAllWeightStatementXSDs ())
                     .registerInto ();
  }

  /**
   * Register all standard UBL 2.3 validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initUBL23 (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_APPLICATIONRESPONSE)
                     .displayName ("UBL Application Response " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllApplicationResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_ATTACHEDDOCUMENT)
                     .displayName ("UBL Attached Document " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllAttachedDocumentXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_AWARDEDNOTIFICATION)
                     .displayName ("UBL Awarded Notification " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllAwardedNotificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_BILLOFLADING)
                     .displayName ("UBL Bill Of Lading " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllBillOfLadingXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_BUSINESSCARD)
                     .displayName ("UBL Business Card " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllBusinessCardXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_CALLFORTENDERS)
                     .displayName ("UBL Call For Tenders " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllCallForTendersXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_CATALOGUE)
                     .displayName ("UBL Catalogue " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllCatalogueXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_CATALOGUEDELETION)
                     .displayName ("UBL Catalogue Deletion " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllCatalogueDeletionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_CATALOGUEITEMSPECIFICATIONUPDATE)
                     .displayName ("UBL Catalogue Item Specification Update " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_CATALOGUEPRICINGUPDATE)
                     .displayName ("UBL Catalogue Pricing Update " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllCataloguePricingUpdateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_CATALOGUEREQUEST)
                     .displayName ("UBL Catalogue Request " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllCatalogueRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_CERTIFICATEOFORIGIN)
                     .displayName ("UBL Certificate Of Origin " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllCertificateOfOriginXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_COMMONTRANSPORTATIONREPORT)
                     .displayName ("UBL Common Transportation Report " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllCommonTransportationReportXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_CONTRACTAWARDNOTICE)
                     .displayName ("UBL Contract Award Notice " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllContractAwardNoticeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_CONTRACTNOTICE)
                     .displayName ("UBL Contract Notice " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllContractNoticeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_CREDITNOTE)
                     .displayName ("UBL Credit Note " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllCreditNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_DEBITNOTE)
                     .displayName ("UBL Debit Note " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllDebitNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_DESPATCHADVICE)
                     .displayName ("UBL Despatch Advice " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllDespatchAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_DIGITALAGREEMENT)
                     .displayName ("UBL Digital Agreement " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllDigitalAgreementXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_DIGITALCAPABILITY)
                     .displayName ("UBL Digital Capability " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllDigitalCapabilityXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_DOCUMENTSTATUS)
                     .displayName ("UBL Document Status " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllDocumentStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_DOCUMENTSTATUSREQUEST)
                     .displayName ("UBL Document Status Request " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllDocumentStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_ENQUIRY)
                     .displayName ("UBL Enquiry " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllEnquiryXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_ENQUIRYRESPONSE)
                     .displayName ("UBL Enquiry Response " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllEnquiryResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_EXCEPTIONCRITERIA)
                     .displayName ("UBL Exception Criteria " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllExceptionCriteriaXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_EXCEPTIONNOTIFICATION)
                     .displayName ("UBL Exception Notification " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllExceptionNotificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_EXPORTCUSTOMSDECLARATION)
                     .displayName ("UBL Export Customs Declaration " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllExportCustomsDeclarationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_EXPRESSIONOFINTERESTREQUEST)
                     .displayName ("UBL Expression Of Interest Request " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllExpressionOfInterestRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_EXPRESSIONOFINTERESTRESPONSE)
                     .displayName ("UBL Expression Of Interest Response " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllExpressionOfInterestResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_FORECAST)
                     .displayName ("UBL Forecast " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllForecastXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_FORECASTREVISION)
                     .displayName ("UBL Forecast Revision " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllForecastRevisionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_FORWARDINGINSTRUCTIONS)
                     .displayName ("UBL Forwarding Instructions " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllForwardingInstructionsXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_FREIGHTINVOICE)
                     .displayName ("UBL Freight Invoice " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllFreightInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_FULFILMENTCANCELLATION)
                     .displayName ("UBL Fulfilment Cancellation " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllFulfilmentCancellationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_GOODSCERTIFICATE)
                     .displayName ("UBL Goods Certificate " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllGoodsCertificateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_GOODSITEMITINERARY)
                     .displayName ("UBL Goods Item Itinerary " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllGoodsItemItineraryXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_GOODSITEMPASSPORT)
                     .displayName ("UBL Goods Item Passport " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllGoodsItemPassportXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_GUARANTEECERTIFICATE)
                     .displayName ("UBL Guarantee Certificate " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllGuaranteeCertificateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_IMPORTCUSTOMSDECLARATION)
                     .displayName ("UBL Import Customs Declaration " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllImportCustomsDeclarationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_INSTRUCTIONFORRETURNS)
                     .displayName ("UBL Instruction For Returns " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllInstructionForReturnsXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_INVENTORYREPORT)
                     .displayName ("UBL Inventory Report " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllInventoryReportXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_INVOICE)
                     .displayName ("UBL Invoice " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_ITEMINFORMATIONREQUEST)
                     .displayName ("UBL Item Information Request " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllItemInformationRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_MANIFEST)
                     .displayName ("UBL Manifest " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllManifestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_ORDER)
                     .displayName ("UBL Order " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllOrderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_ORDERCANCELLATION)
                     .displayName ("UBL Order Cancellation " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllOrderCancellationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_ORDERCHANGE)
                     .displayName ("UBL Order Change " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllOrderChangeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_ORDERRESPONSE)
                     .displayName ("UBL Order Response " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllOrderResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_ORDERRESPONSESIMPLE)
                     .displayName ("UBL Order Response Simple " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllOrderResponseSimpleXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_PACKINGLIST)
                     .displayName ("UBL Packing List " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllPackingListXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_PRIORINFORMATIONNOTICE)
                     .displayName ("UBL Prior Information Notice " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllPriorInformationNoticeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_PRODUCTACTIVITY)
                     .displayName ("UBL Product Activity " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllProductActivityXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_PROOFOFREEXPORTATION)
                     .displayName ("UBL Proof Of Reexportation " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllProofOfReexportationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_PROOFOFREEXPORTATIONREMINDER)
                     .displayName ("UBL Proof Of Reexportation Reminder " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllProofOfReexportationReminderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_PROOFOFREEXPORTATIONREQUEST)
                     .displayName ("UBL Proof Of Reexportation Request " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllProofOfReexportationRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_QUALIFICATIONAPPLICATIONREQUEST)
                     .displayName ("UBL Qualification Application Request " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllQualificationApplicationRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_QUALIFICATIONAPPLICATIONRESPONSE)
                     .displayName ("UBL Qualification Application Response " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllQualificationApplicationResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_QUOTATION)
                     .displayName ("UBL Quotation " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllQuotationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_RECEIPTADVICE)
                     .displayName ("UBL Receipt Advice " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllReceiptAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_REMINDER)
                     .displayName ("UBL Reminder " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllReminderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_REMITTANCEADVICE)
                     .displayName ("UBL Remittance Advice " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllRemittanceAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_REQUESTFORQUOTATION)
                     .displayName ("UBL Request For Quotation " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllRequestForQuotationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_RETAILEVENT)
                     .displayName ("UBL Retail Event " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllRetailEventXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_SELFBILLEDCREDITNOTE)
                     .displayName ("UBL Self Billed Credit Note " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllSelfBilledCreditNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_SELFBILLEDINVOICE)
                     .displayName ("UBL Self Billed Invoice " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllSelfBilledInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_STATEMENT)
                     .displayName ("UBL Statement " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllStatementXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_STOCKAVAILABILITYREPORT)
                     .displayName ("UBL Stock Availability Report " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllStockAvailabilityReportXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TENDER)
                     .displayName ("UBL Tender " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTenderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TENDERCONTRACT)
                     .displayName ("UBL Tender Contract " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTenderContractXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TENDERERQUALIFICATION)
                     .displayName ("UBL Tenderer Qualification " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTendererQualificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TENDERERQUALIFICATIONRESPONSE)
                     .displayName ("UBL Tenderer Qualification Response " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTendererQualificationResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TENDERRECEIPT)
                     .displayName ("UBL Tender Receipt " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTenderReceiptXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TENDERSTATUS)
                     .displayName ("UBL Tender Status " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTenderStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TENDERSTATUSREQUEST)
                     .displayName ("UBL Tender Status Request " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTenderStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TENDERWITHDRAWAL)
                     .displayName ("UBL Tender Withdrawal " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTenderWithdrawalXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TRADEITEMLOCATIONPROFILE)
                     .displayName ("UBL Trade Item Location Profile " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTradeItemLocationProfileXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TRANSITCUSTOMSDECLARATION)
                     .displayName ("UBL Transit Customs Declaration " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTransitCustomsDeclarationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TRANSPORTATIONSTATUS)
                     .displayName ("UBL Transportation Status " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTransportationStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TRANSPORTATIONSTATUSREQUEST)
                     .displayName ("UBL Transportation Status Request " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTransportationStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TRANSPORTEXECUTIONPLAN)
                     .displayName ("UBL Transport Execution Plan " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTransportExecutionPlanXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TRANSPORTEXECUTIONPLANREQUEST)
                     .displayName ("UBL Transport Execution Plan Request " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTransportExecutionPlanRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TRANSPORTPROGRESSSTATUS)
                     .displayName ("UBL Transport Progress Status " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTransportProgressStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TRANSPORTPROGRESSSTATUSREQUEST)
                     .displayName ("UBL Transport Progress Status Request " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTransportProgressStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TRANSPORTSERVICEDESCRIPTION)
                     .displayName ("UBL Transport Service Description " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTransportServiceDescriptionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_TRANSPORTSERVICEDESCRIPTIONREQUEST)
                     .displayName ("UBL Transport Service Description Request " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllTransportServiceDescriptionRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_UNAWARDEDNOTIFICATION)
                     .displayName ("UBL Unawarded Notification " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllUnawardedNotificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_UNSUBSCRIBEFROMPROCEDUREREQUEST)
                     .displayName ("UBL Unsubscribe From Procedure Request " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllUnsubscribeFromProcedureRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_UNSUBSCRIBEFROMPROCEDURERESPONSE)
                     .displayName ("UBL Unsubscribe From Procedure Response " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllUnsubscribeFromProcedureResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_UTILITYSTATEMENT)
                     .displayName ("UBL Utility Statement " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllUtilityStatementXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_WAYBILL)
                     .displayName ("UBL Waybill " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllWaybillXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_23_WEIGHTSTATEMENT)
                     .displayName ("UBL Weight Statement " + VERSION_23)
                     .notDeprecated ()
                     .addXSD (UBL23Marshaller.getAllWeightStatementXSDs ())
                     .registerInto ();
  }

  /**
   * Register all standard UBL 2.4 validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initUBL24 (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_APPLICATIONRESPONSE)
                     .displayName ("UBL Application Response " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllApplicationResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_ATTACHEDDOCUMENT)
                     .displayName ("UBL Attached Document " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllAttachedDocumentXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_AWARDEDNOTIFICATION)
                     .displayName ("UBL Awarded Notification " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllAwardedNotificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_BILLOFLADING)
                     .displayName ("UBL Bill Of Lading " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllBillOfLadingXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_BUSINESSCARD)
                     .displayName ("UBL Business Card " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllBusinessCardXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_BUSINESSINFORMATION)
                     .displayName ("UBL Business Information " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllBusinessInformationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_CALLFORTENDERS)
                     .displayName ("UBL Call For Tenders " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllCallForTendersXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_CATALOGUE)
                     .displayName ("UBL Catalogue " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllCatalogueXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_CATALOGUEDELETION)
                     .displayName ("UBL Catalogue Deletion " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllCatalogueDeletionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_CATALOGUEITEMSPECIFICATIONUPDATE)
                     .displayName ("UBL Catalogue Item Specification Update " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_CATALOGUEPRICINGUPDATE)
                     .displayName ("UBL Catalogue Pricing Update " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllCataloguePricingUpdateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_CATALOGUEREQUEST)
                     .displayName ("UBL Catalogue Request " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllCatalogueRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_CERTIFICATEOFORIGIN)
                     .displayName ("UBL Certificate Of Origin " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllCertificateOfOriginXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_COMMONTRANSPORTATIONREPORT)
                     .displayName ("UBL Common Transportation Report " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllCommonTransportationReportXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_CONTRACTAWARDNOTICE)
                     .displayName ("UBL Contract Award Notice " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllContractAwardNoticeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_CONTRACTNOTICE)
                     .displayName ("UBL Contract Notice " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllContractNoticeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_CREDITNOTE)
                     .displayName ("UBL Credit Note " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllCreditNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_DEBITNOTE)
                     .displayName ("UBL Debit Note " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllDebitNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_DESPATCHADVICE)
                     .displayName ("UBL Despatch Advice " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllDespatchAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_DIGITALAGREEMENT)
                     .displayName ("UBL Digital Agreement " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllDigitalAgreementXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_DIGITALCAPABILITY)
                     .displayName ("UBL Digital Capability " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllDigitalCapabilityXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_DOCUMENTSTATUS)
                     .displayName ("UBL Document Status " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllDocumentStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_DOCUMENTSTATUSREQUEST)
                     .displayName ("UBL Document Status Request " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllDocumentStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_ENQUIRY)
                     .displayName ("UBL Enquiry " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllEnquiryXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_ENQUIRYRESPONSE)
                     .displayName ("UBL Enquiry Response " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllEnquiryResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_EXCEPTIONCRITERIA)
                     .displayName ("UBL Exception Criteria " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllExceptionCriteriaXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_EXCEPTIONNOTIFICATION)
                     .displayName ("UBL Exception Notification " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllExceptionNotificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_EXPORTCUSTOMSDECLARATION)
                     .displayName ("UBL Export Customs Declaration " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllExportCustomsDeclarationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_EXPRESSIONOFINTERESTREQUEST)
                     .displayName ("UBL Expression Of Interest Request " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllExpressionOfInterestRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_EXPRESSIONOFINTERESTRESPONSE)
                     .displayName ("UBL Expression Of Interest Response " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllExpressionOfInterestResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_FORECAST)
                     .displayName ("UBL Forecast " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllForecastXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_FORECASTREVISION)
                     .displayName ("UBL Forecast Revision " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllForecastRevisionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_FORWARDINGINSTRUCTIONS)
                     .displayName ("UBL Forwarding Instructions " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllForwardingInstructionsXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_FREIGHTINVOICE)
                     .displayName ("UBL Freight Invoice " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllFreightInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_FULFILMENTCANCELLATION)
                     .displayName ("UBL Fulfilment Cancellation " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllFulfilmentCancellationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_GOODSCERTIFICATE)
                     .displayName ("UBL Goods Certificate " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllGoodsCertificateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_GOODSITEMITINERARY)
                     .displayName ("UBL Goods Item Itinerary " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllGoodsItemItineraryXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_GOODSITEMPASSPORT)
                     .displayName ("UBL Goods Item Passport " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllGoodsItemPassportXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_GUARANTEECERTIFICATE)
                     .displayName ("UBL Guarantee Certificate " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllGuaranteeCertificateXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_IMPORTCUSTOMSDECLARATION)
                     .displayName ("UBL Import Customs Declaration " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllImportCustomsDeclarationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_INSTRUCTIONFORRETURNS)
                     .displayName ("UBL Instruction For Returns " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllInstructionForReturnsXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_INVENTORYREPORT)
                     .displayName ("UBL Inventory Report " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllInventoryReportXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_INVOICE)
                     .displayName ("UBL Invoice " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_ITEMINFORMATIONREQUEST)
                     .displayName ("UBL Item Information Request " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllItemInformationRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_MANIFEST)
                     .displayName ("UBL Manifest " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllManifestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_ORDER)
                     .displayName ("UBL Order " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllOrderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_ORDERCANCELLATION)
                     .displayName ("UBL Order Cancellation " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllOrderCancellationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_ORDERCHANGE)
                     .displayName ("UBL Order Change " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllOrderChangeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_ORDERRESPONSE)
                     .displayName ("UBL Order Response " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllOrderResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_ORDERRESPONSESIMPLE)
                     .displayName ("UBL Order Response Simple " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllOrderResponseSimpleXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_PACKINGLIST)
                     .displayName ("UBL Packing List " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllPackingListXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_PRIORINFORMATIONNOTICE)
                     .displayName ("UBL Prior Information Notice " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllPriorInformationNoticeXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_PRODUCTACTIVITY)
                     .displayName ("UBL Product Activity " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllProductActivityXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_PROOFOFREEXPORTATION)
                     .displayName ("UBL Proof Of Reexportation " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllProofOfReexportationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_PROOFOFREEXPORTATIONREMINDER)
                     .displayName ("UBL Proof Of Reexportation Reminder " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllProofOfReexportationReminderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_PROOFOFREEXPORTATIONREQUEST)
                     .displayName ("UBL Proof Of Reexportation Request " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllProofOfReexportationRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_PURCHASERECEIPT)
                     .displayName ("UBL Purchase Receipt " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllPurchaseReceiptXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_QUALIFICATIONAPPLICATIONREQUEST)
                     .displayName ("UBL Qualification Application Request " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllQualificationApplicationRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_QUALIFICATIONAPPLICATIONRESPONSE)
                     .displayName ("UBL Qualification Application Response " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllQualificationApplicationResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_QUOTATION)
                     .displayName ("UBL Quotation " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllQuotationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_RECEIPTADVICE)
                     .displayName ("UBL Receipt Advice " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllReceiptAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_REMINDER)
                     .displayName ("UBL Reminder " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllReminderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_REMITTANCEADVICE)
                     .displayName ("UBL Remittance Advice " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllRemittanceAdviceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_REQUESTFORQUOTATION)
                     .displayName ("UBL Request For Quotation " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllRequestForQuotationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_RETAILEVENT)
                     .displayName ("UBL Retail Event " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllRetailEventXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_SELFBILLEDCREDITNOTE)
                     .displayName ("UBL Self Billed Credit Note " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllSelfBilledCreditNoteXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_SELFBILLEDINVOICE)
                     .displayName ("UBL Self Billed Invoice " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllSelfBilledInvoiceXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_STATEMENT)
                     .displayName ("UBL Statement " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllStatementXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_STOCKAVAILABILITYREPORT)
                     .displayName ("UBL Stock Availability Report " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllStockAvailabilityReportXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TENDER)
                     .displayName ("UBL Tender " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTenderXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TENDERCONTRACT)
                     .displayName ("UBL Tender Contract " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTenderContractXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TENDERERQUALIFICATION)
                     .displayName ("UBL Tenderer Qualification " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTendererQualificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TENDERERQUALIFICATIONRESPONSE)
                     .displayName ("UBL Tenderer Qualification Response " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTendererQualificationResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TENDERRECEIPT)
                     .displayName ("UBL Tender Receipt " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTenderReceiptXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TENDERSTATUS)
                     .displayName ("UBL Tender Status " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTenderStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TENDERSTATUSREQUEST)
                     .displayName ("UBL Tender Status Request " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTenderStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TENDERWITHDRAWAL)
                     .displayName ("UBL Tender Withdrawal " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTenderWithdrawalXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TRADEITEMLOCATIONPROFILE)
                     .displayName ("UBL Trade Item Location Profile " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTradeItemLocationProfileXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TRANSITCUSTOMSDECLARATION)
                     .displayName ("UBL Transit Customs Declaration " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTransitCustomsDeclarationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TRANSPORTATIONSTATUS)
                     .displayName ("UBL Transportation Status " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTransportationStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TRANSPORTATIONSTATUSREQUEST)
                     .displayName ("UBL Transportation Status Request " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTransportationStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TRANSPORTEXECUTIONPLAN)
                     .displayName ("UBL Transport Execution Plan " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTransportExecutionPlanXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TRANSPORTEXECUTIONPLANREQUEST)
                     .displayName ("UBL Transport Execution Plan Request " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTransportExecutionPlanRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TRANSPORTPROGRESSSTATUS)
                     .displayName ("UBL Transport Progress Status " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTransportProgressStatusXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TRANSPORTPROGRESSSTATUSREQUEST)
                     .displayName ("UBL Transport Progress Status Request " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTransportProgressStatusRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TRANSPORTSERVICEDESCRIPTION)
                     .displayName ("UBL Transport Service Description " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTransportServiceDescriptionXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_TRANSPORTSERVICEDESCRIPTIONREQUEST)
                     .displayName ("UBL Transport Service Description Request " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllTransportServiceDescriptionRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_UNAWARDEDNOTIFICATION)
                     .displayName ("UBL Unawarded Notification " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllUnawardedNotificationXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_UNSUBSCRIBEFROMPROCEDUREREQUEST)
                     .displayName ("UBL Unsubscribe From Procedure Request " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllUnsubscribeFromProcedureRequestXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_UNSUBSCRIBEFROMPROCEDURERESPONSE)
                     .displayName ("UBL Unsubscribe From Procedure Response " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllUnsubscribeFromProcedureResponseXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_UTILITYSTATEMENT)
                     .displayName ("UBL Utility Statement " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllUtilityStatementXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_WAYBILL)
                     .displayName ("UBL Waybill " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllWaybillXSDs ())
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_UBL_24_WEIGHTSTATEMENT)
                     .displayName ("UBL Weight Statement " + VERSION_24)
                     .notDeprecated ()
                     .addXSD (UBL24Marshaller.getAllWeightStatementXSDs ())
                     .registerInto ();
  }
}
