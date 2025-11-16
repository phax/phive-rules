/*
 * Copyright (C) 2018-2025 Philip Helger (www.helger.com)
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
package com.helger.phive.oioubl;

import java.time.LocalDate;
import java.time.Month;
import java.time.OffsetDateTime;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.datetime.helper.PDTFactory;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl20.CUBL20;
import com.helger.ubl21.UBL21Marshaller;

/**
 * Generic OIOUBL validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class OIOUBLValidation
{
  public static final String GROUPID = "dk.oioubl";

  @NonNull
  private static ClassLoader _getCL ()
  {
    return OIOUBLValidation.class.getClassLoader ();
  }

  // 1.12.3
  private static final String VERSION_1_12_3 = "1.12.3";
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_APPLICATION_RESPONSE_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                "application-response",
                                                                                                                VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                     "catalogue",
                                                                                                     VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_DELETION_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                              "catalogue-deletion",
                                                                                                              VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                               "catalogue-item-specification-update",
                                                                                                                               VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                    "catalogue-pricing-update",
                                                                                                                    VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_REQUEST_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "catalogue-request",
                                                                                                             VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CREDIT_NOTE_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                       "credit-note",
                                                                                                       VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_INVOICE_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                   "invoice",
                                                                                                   VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                 "order",
                                                                                                 VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CANCELLATION_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                              "order-cancellation",
                                                                                                              VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CHANGE_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                        "order-change",
                                                                                                        VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                          "order-response",
                                                                                                          VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                 "order-response-simple",
                                                                                                                 VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_REMINDER_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                    "reminder",
                                                                                                    VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_STATEMENT_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                     "statement",
                                                                                                     VERSION_1_12_3);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_UTILITY_STATEMENT_1_12_3 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "utility-statement",
                                                                                                             VERSION_1_12_3);

  // 1.13.0
  private static final String VERSION_1_13_0 = "1.13.0";
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_APPLICATION_RESPONSE_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                "application-response",
                                                                                                                VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                     "catalogue",
                                                                                                     VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_DELETION_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                              "catalogue-deletion",
                                                                                                              VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                               "catalogue-item-specification-update",
                                                                                                                               VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                    "catalogue-pricing-update",
                                                                                                                    VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_REQUEST_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "catalogue-request",
                                                                                                             VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CREDIT_NOTE_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                       "credit-note",
                                                                                                       VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_INVOICE_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                   "invoice",
                                                                                                   VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                 "order",
                                                                                                 VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CANCELLATION_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                              "order-cancellation",
                                                                                                              VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CHANGE_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                        "order-change",
                                                                                                        VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                          "order-response",
                                                                                                          VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                 "order-response-simple",
                                                                                                                 VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_REMINDER_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                    "reminder",
                                                                                                    VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_STATEMENT_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                     "statement",
                                                                                                     VERSION_1_13_0);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_UTILITY_STATEMENT_1_13_0 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "utility-statement",
                                                                                                             VERSION_1_13_0);

  // 1.13.2
  private static final String VERSION_1_13_2 = "1.13.2";
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_APPLICATION_RESPONSE_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                "application-response",
                                                                                                                VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                     "catalogue",
                                                                                                     VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_DELETION_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                              "catalogue-deletion",
                                                                                                              VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                               "catalogue-item-specification-update",
                                                                                                                               VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                    "catalogue-pricing-update",
                                                                                                                    VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_REQUEST_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "catalogue-request",
                                                                                                             VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CREDIT_NOTE_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                       "credit-note",
                                                                                                       VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_INVOICE_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                   "invoice",
                                                                                                   VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                 "order",
                                                                                                 VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CANCELLATION_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                              "order-cancellation",
                                                                                                              VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CHANGE_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                        "order-change",
                                                                                                        VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                          "order-response",
                                                                                                          VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                 "order-response-simple",
                                                                                                                 VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_REMINDER_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                    "reminder",
                                                                                                    VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_STATEMENT_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                     "statement",
                                                                                                     VERSION_1_13_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_UTILITY_STATEMENT_1_13_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "utility-statement",
                                                                                                             VERSION_1_13_2);

  // 1.14.2
  private static final String VERSION_1_14_2 = "1.14.2";
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_APPLICATION_RESPONSE_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                "application-response",
                                                                                                                VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                     "catalogue",
                                                                                                     VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_DELETION_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                              "catalogue-deletion",
                                                                                                              VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                               "catalogue-item-specification-update",
                                                                                                                               VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                    "catalogue-pricing-update",
                                                                                                                    VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_REQUEST_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "catalogue-request",
                                                                                                             VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CREDIT_NOTE_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                       "credit-note",
                                                                                                       VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_INVOICE_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                   "invoice",
                                                                                                   VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                 "order",
                                                                                                 VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CANCELLATION_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                              "order-cancellation",
                                                                                                              VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CHANGE_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                        "order-change",
                                                                                                        VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                          "order-response",
                                                                                                          VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                 "order-response-simple",
                                                                                                                 VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_REMINDER_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                    "reminder",
                                                                                                    VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_STATEMENT_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                     "statement",
                                                                                                     VERSION_1_14_2);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_UTILITY_STATEMENT_1_14_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "utility-statement",
                                                                                                             VERSION_1_14_2);

  // 1.15.0-rc
  private static final String VERSION_1_15_0_RC = "1.15.0-rc";
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_APPLICATION_RESPONSE_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                   "application-response",
                                                                                                                   VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                        "catalogue",
                                                                                                        VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_DELETION_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                 "catalogue-deletion",
                                                                                                                 VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                                  "catalogue-item-specification-update",
                                                                                                                                  VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                       "catalogue-pricing-update",
                                                                                                                       VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_REQUEST_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                "catalogue-request",
                                                                                                                VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CREDIT_NOTE_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                          "credit-note",
                                                                                                          VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_INVOICE_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                      "invoice",
                                                                                                      VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                    "order",
                                                                                                    VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CANCELLATION_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                 "order-cancellation",
                                                                                                                 VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CHANGE_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                           "order-change",
                                                                                                           VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "order-response",
                                                                                                             VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                    "order-response-simple",
                                                                                                                    VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_REMINDER_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                       "reminder",
                                                                                                       VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_STATEMENT_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                        "statement",
                                                                                                        VERSION_1_15_0_RC);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_UTILITY_STATEMENT_1_15_0_RC = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                "utility-statement",
                                                                                                                VERSION_1_15_0_RC);

  // 1.15.1
  private static final String VERSION_1_15_1 = "1.15.1";
  public static final LocalDate VERSION_1_15_1_VALID_PER = PDTFactory.createLocalDate (2025, Month.MAY, 15);
  public static final OffsetDateTime VERSION_1_15_1_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (VERSION_1_15_1_VALID_PER);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_APPLICATION_RESPONSE_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                "application-response",
                                                                                                                VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                     "catalogue",
                                                                                                     VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_DELETION_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                              "catalogue-deletion",
                                                                                                              VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                               "catalogue-item-specification-update",
                                                                                                                               VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                    "catalogue-pricing-update",
                                                                                                                    VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_REQUEST_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "catalogue-request",
                                                                                                             VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CREDIT_NOTE_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                       "credit-note",
                                                                                                       VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_INVOICE_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                   "invoice",
                                                                                                   VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                 "order",
                                                                                                 VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CANCELLATION_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                              "order-cancellation",
                                                                                                              VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CHANGE_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                        "order-change",
                                                                                                        VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                          "order-response",
                                                                                                          VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                 "order-response-simple",
                                                                                                                 VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_REMINDER_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                    "reminder",
                                                                                                    VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_STATEMENT_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                     "statement",
                                                                                                     VERSION_1_15_1);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_UTILITY_STATEMENT_1_15_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "utility-statement",
                                                                                                             VERSION_1_15_1);

  // 1.15.2
  private static final String VERSION_1_15_2 = "1.15.2";
  public static final LocalDate VERSION_1_15_2_VALID_PER = PDTFactory.createLocalDate (2025, Month.MAY, 15);
  public static final OffsetDateTime VERSION_1_15_2_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (VERSION_1_15_2_VALID_PER);
  public static final DVRCoordinate VID_OIOUBL_APPLICATION_RESPONSE_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                "application-response",
                                                                                                                VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                     "catalogue",
                                                                                                     VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_DELETION_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                              "catalogue-deletion",
                                                                                                              VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                               "catalogue-item-specification-update",
                                                                                                                               VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                    "catalogue-pricing-update",
                                                                                                                    VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_REQUEST_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "catalogue-request",
                                                                                                             VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_CREDIT_NOTE_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                       "credit-note",
                                                                                                       VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_INVOICE_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                   "invoice",
                                                                                                   VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_ORDER_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                 "order",
                                                                                                 VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_ORDER_CANCELLATION_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                              "order-cancellation",
                                                                                                              VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_ORDER_CHANGE_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                        "order-change",
                                                                                                        VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                          "order-response",
                                                                                                          VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                 "order-response-simple",
                                                                                                                 VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_REMINDER_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                    "reminder",
                                                                                                    VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_STATEMENT_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                     "statement",
                                                                                                     VERSION_1_15_2);
  public static final DVRCoordinate VID_OIOUBL_UTILITY_STATEMENT_1_15_2 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "utility-statement",
                                                                                                             VERSION_1_15_2);

  // 3.0.1
  private static final String VERSION_3_0_1 = "3.0.1";
  public static final DVRCoordinate VID_OIOUBL_CREDIT_NOTE_3_0_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                      "credit-note",
                                                                                                      VERSION_3_0_1);
  public static final DVRCoordinate VID_OIOUBL_INVOICE_3_0_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                  "invoice",
                                                                                                  VERSION_3_0_1);
  public static final DVRCoordinate VID_OIOUBL_INVOICE_RESPONSE_3_0_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                           "invoice-response",
                                                                                                           VERSION_3_0_1);
  public static final DVRCoordinate VID_OIOUBL_MLR_3_0_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                              "mlr",
                                                                                              VERSION_3_0_1);

  private OIOUBLValidation ()
  {}

  /**
   * Register all standard OIOUBL validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initOIOUBL (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // MUST be UBL 2.0 as an include refers to a file only available in UBL 2.0
    final ICommonsList <ClassPathResource> aXSDUtilityStatement = new CommonsArrayList <> (CUBL20.XSD_CODELIST_UNIT_CODE,
                                                                                           CUBL20.XSD_CODELIST_MIME_MEDIA_TYPE_CODE,
                                                                                           CUBL20.XSD_CODELIST_CURRENCY_CODE,
                                                                                           CUBL20.XSD_CODELIST_LANGUAGE_CODE,
                                                                                           CUBL20.XSD_UNQUALIFIED_DATA_TYPES,
                                                                                           CUBL20.XSD_QUALIFIED_DATA_TYPES,
                                                                                           new ClassPathResource ("external/schemas/OIOUBL_v2.1-b/common/OIOUBL_UTS-CommonBasicComponents-2.1.xsd",
                                                                                                                  _getCL ()),
                                                                                           new ClassPathResource ("external/schemas/OIOUBL_v2.1-b/common/OIOUBL_UTS-CommonAggregateComponents-2.1.xsd",
                                                                                                                  _getCL ()),
                                                                                           new ClassPathResource ("external/schemas/OIOUBL_v2.1-b/maindoc/UBL-UtilityStatement-2.1.xsd",
                                                                                                                  _getCL ()));

    // 1.12.3
    {
      final String sPath = "/external/schematron/oioubl/1.12.3/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_APPLICATION_RESPONSE_1_12_3,
                                                                             "OIOUBL Application Response " +
                                                                                                                     VID_OIOUBL_APPLICATION_RESPONSE_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_ApplicationResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_1_12_3,
                                                                             "OIOUBL Catalogue " +
                                                                                                          VID_OIOUBL_CATALOGUE_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Catalogue_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_DELETION_1_12_3,
                                                                             "OIOUBL Catalogue Deletion " +
                                                                                                                   VID_OIOUBL_CATALOGUE_DELETION_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueDeletionXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueDeletion_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_12_3,
                                                                             "OIOUBL Catalogue Item Specification Update " +
                                                                                                                                    VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_12_3,
                                                                             "OIOUBL Catalogue Pricing Update " +
                                                                                                                         VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCataloguePricingUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CataloguePricingUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_REQUEST_1_12_3,
                                                                             "OIOUBL Catalogue Request " +
                                                                                                                  VID_OIOUBL_CATALOGUE_REQUEST_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueRequestXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueRequest_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CREDIT_NOTE_1_12_3,
                                                                             "OIOUBL Credit Note " +
                                                                                                            VID_OIOUBL_CREDIT_NOTE_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CreditNote_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_INVOICE_1_12_3,
                                                                             "OIOUBL Invoice " +
                                                                                                        VID_OIOUBL_INVOICE_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Invoice_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_1_12_3,
                                                                             "OIOUBL Order " +
                                                                                                      VID_OIOUBL_ORDER_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Order_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CANCELLATION_1_12_3,
                                                                             "OIOUBL Order Cancellation " +
                                                                                                                   VID_OIOUBL_ORDER_CANCELLATION_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderCancellationXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderCancellation_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CHANGE_1_12_3,
                                                                             "OIOUBL Order Change " +
                                                                                                             VID_OIOUBL_ORDER_CHANGE_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderChangeXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderChange_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_1_12_3,
                                                                             "OIOUBL Order Response " +
                                                                                                               VID_OIOUBL_ORDER_RESPONSE_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_12_3,
                                                                             "OIOUBL Order Response Simple " +
                                                                                                                      VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseSimpleXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponseSimple_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_REMINDER_1_12_3,
                                                                             "OIOUBL Reminder " +
                                                                                                         VID_OIOUBL_REMINDER_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllReminderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Reminder_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_STATEMENT_1_12_3,
                                                                             "OIOUBL Statement " +
                                                                                                          VID_OIOUBL_STATEMENT_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllStatementXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Statement_Schematron.xslt",
                                                                                                                                          _getCL ()))));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_UTILITY_STATEMENT_1_12_3,
                                                                             "OIOUBL Utility Statement " +
                                                                                                                  VID_OIOUBL_UTILITY_STATEMENT_1_12_3.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (aXSDUtilityStatement),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL20 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_UtilityStatement_Schematron.xslt",
                                                                                                                                          _getCL ()))));
    }

    // 1.13.0
    {
      final String sPath = "/external/schematron/oioubl/1.13.0/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_APPLICATION_RESPONSE_1_13_0,
                                                                             "OIOUBL Application Response " +
                                                                                                                     VID_OIOUBL_APPLICATION_RESPONSE_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_ApplicationResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_1_13_0,
                                                                             "OIOUBL Catalogue " +
                                                                                                          VID_OIOUBL_CATALOGUE_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Catalogue_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_DELETION_1_13_0,
                                                                             "OIOUBL Catalogue Deletion " +
                                                                                                                   VID_OIOUBL_CATALOGUE_DELETION_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueDeletionXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueDeletion_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_0,
                                                                             "OIOUBL Catalogue Item Specification Update " +
                                                                                                                                    VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_0,
                                                                             "OIOUBL Catalogue Pricing Update " +
                                                                                                                         VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCataloguePricingUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CataloguePricingUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_REQUEST_1_13_0,
                                                                             "OIOUBL Catalogue Request " +
                                                                                                                  VID_OIOUBL_CATALOGUE_REQUEST_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueRequestXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueRequest_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CREDIT_NOTE_1_13_0,
                                                                             "OIOUBL Credit Note " +
                                                                                                            VID_OIOUBL_CREDIT_NOTE_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CreditNote_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_INVOICE_1_13_0,
                                                                             "OIOUBL Invoice " +
                                                                                                        VID_OIOUBL_INVOICE_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Invoice_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_1_13_0,
                                                                             "OIOUBL Order " +
                                                                                                      VID_OIOUBL_ORDER_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Order_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CANCELLATION_1_13_0,
                                                                             "OIOUBL Order Cancellation " +
                                                                                                                   VID_OIOUBL_ORDER_CANCELLATION_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderCancellationXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderCancellation_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CHANGE_1_13_0,
                                                                             "OIOUBL Order Change " +
                                                                                                             VID_OIOUBL_ORDER_CHANGE_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderChangeXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderChange_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_1_13_0,
                                                                             "OIOUBL Order Response " +
                                                                                                               VID_OIOUBL_ORDER_RESPONSE_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_0,
                                                                             "OIOUBL Order Response Simple " +
                                                                                                                      VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseSimpleXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponseSimple_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_REMINDER_1_13_0,
                                                                             "OIOUBL Reminder " +
                                                                                                         VID_OIOUBL_REMINDER_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllReminderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Reminder_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_STATEMENT_1_13_0,
                                                                             "OIOUBL Statement " +
                                                                                                          VID_OIOUBL_STATEMENT_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllStatementXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Statement_Schematron.xslt",
                                                                                                                                          _getCL ()))));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_UTILITY_STATEMENT_1_13_0,
                                                                             "OIOUBL Utility Statement " +
                                                                                                                  VID_OIOUBL_UTILITY_STATEMENT_1_13_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (aXSDUtilityStatement),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL20 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_UtilityStatement_Schematron.xslt",
                                                                                                                                          _getCL ()))));
    }

    // 1.13.2
    {
      final String sPath = "/external/schematron/oioubl/1.13.2/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_APPLICATION_RESPONSE_1_13_2,
                                                                             "OIOUBL Application Response " +
                                                                                                                     VID_OIOUBL_APPLICATION_RESPONSE_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_ApplicationResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_1_13_2,
                                                                             "OIOUBL Catalogue " +
                                                                                                          VID_OIOUBL_CATALOGUE_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Catalogue_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_DELETION_1_13_2,
                                                                             "OIOUBL Catalogue Deletion " +
                                                                                                                   VID_OIOUBL_CATALOGUE_DELETION_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueDeletionXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueDeletion_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_2,
                                                                             "OIOUBL Catalogue Item Specification Update " +
                                                                                                                                    VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_2,
                                                                             "OIOUBL Catalogue Pricing Update " +
                                                                                                                         VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCataloguePricingUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CataloguePricingUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_REQUEST_1_13_2,
                                                                             "OIOUBL Catalogue Request " +
                                                                                                                  VID_OIOUBL_CATALOGUE_REQUEST_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueRequestXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueRequest_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CREDIT_NOTE_1_13_2,
                                                                             "OIOUBL Credit Note " +
                                                                                                            VID_OIOUBL_CREDIT_NOTE_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CreditNote_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_INVOICE_1_13_2,
                                                                             "OIOUBL Invoice " +
                                                                                                        VID_OIOUBL_INVOICE_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Invoice_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_1_13_2,
                                                                             "OIOUBL Order " +
                                                                                                      VID_OIOUBL_ORDER_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Order_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CANCELLATION_1_13_2,
                                                                             "OIOUBL Order Cancellation " +
                                                                                                                   VID_OIOUBL_ORDER_CANCELLATION_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderCancellationXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderCancellation_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CHANGE_1_13_2,
                                                                             "OIOUBL Order Change " +
                                                                                                             VID_OIOUBL_ORDER_CHANGE_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderChangeXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderChange_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_1_13_2,
                                                                             "OIOUBL Order Response " +
                                                                                                               VID_OIOUBL_ORDER_RESPONSE_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_2,
                                                                             "OIOUBL Order Response Simple " +
                                                                                                                      VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseSimpleXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponseSimple_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_REMINDER_1_13_2,
                                                                             "OIOUBL Reminder " +
                                                                                                         VID_OIOUBL_REMINDER_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllReminderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Reminder_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_STATEMENT_1_13_2,
                                                                             "OIOUBL Statement " +
                                                                                                          VID_OIOUBL_STATEMENT_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllStatementXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Statement_Schematron.xslt",
                                                                                                                                          _getCL ()))));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_UTILITY_STATEMENT_1_13_2,
                                                                             "OIOUBL Utility Statement " +
                                                                                                                  VID_OIOUBL_UTILITY_STATEMENT_1_13_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (aXSDUtilityStatement),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL20 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_UtilityStatement_Schematron.xslt",
                                                                                                                                          _getCL ()))));
    }

    // 1.14.2
    {
      final String sPath = "/external/schematron/oioubl/1.14.2/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_APPLICATION_RESPONSE_1_14_2,
                                                                             "OIOUBL Application Response " +
                                                                                                                     VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_ApplicationResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_1_14_2,
                                                                             "OIOUBL Catalogue " + VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Catalogue_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_DELETION_1_14_2,
                                                                             "OIOUBL Catalogue Deletion " +
                                                                                                                   VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueDeletionXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueDeletion_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_14_2,
                                                                             "OIOUBL Catalogue Item Specification Update " +
                                                                                                                                    VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_14_2,
                                                                             "OIOUBL Catalogue Pricing Update " +
                                                                                                                         VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCataloguePricingUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CataloguePricingUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_REQUEST_1_14_2,
                                                                             "OIOUBL Catalogue Request " +
                                                                                                                  VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueRequestXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueRequest_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CREDIT_NOTE_1_14_2,
                                                                             "OIOUBL Credit Note " + VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CreditNote_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_INVOICE_1_14_2,
                                                                             "OIOUBL Invoice " + VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Invoice_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_1_14_2,
                                                                             "OIOUBL Order " + VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Order_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CANCELLATION_1_14_2,
                                                                             "OIOUBL Order Cancellation " +
                                                                                                                   VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderCancellationXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderCancellation_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CHANGE_1_14_2,
                                                                             "OIOUBL Order Change " + VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderChangeXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderChange_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_1_14_2,
                                                                             "OIOUBL Order Response " + VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_14_2,
                                                                             "OIOUBL Order Response Simple " +
                                                                                                                      VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseSimpleXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponseSimple_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_REMINDER_1_14_2,
                                                                             "OIOUBL Reminder " + VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllReminderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Reminder_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_STATEMENT_1_14_2,
                                                                             "OIOUBL Statement " + VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllStatementXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Statement_Schematron.xslt",
                                                                                                                                          _getCL ()))));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_UTILITY_STATEMENT_1_14_2,
                                                                             "OIOUBL Utility Statement " +
                                                                                                                  VERSION_1_14_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (aXSDUtilityStatement),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL20 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_UtilityStatement_Schematron.xslt",
                                                                                                                                          _getCL ()))));
    }

    // 1.15.0-rc
    {
      final String sPath = "/external/schematron/oioubl/1.15.0-rc/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_APPLICATION_RESPONSE_1_15_0_RC,
                                                                             "OIOUBL Application Response " +
                                                                                                                        VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_ApplicationResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_1_15_0_RC,
                                                                             "OIOUBL Catalogue " + VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Catalogue_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_DELETION_1_15_0_RC,
                                                                             "OIOUBL Catalogue Deletion " +
                                                                                                                      VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueDeletionXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueDeletion_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_15_0_RC,
                                                                             "OIOUBL Catalogue Item Specification Update " +
                                                                                                                                       VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_15_0_RC,
                                                                             "OIOUBL Catalogue Pricing Update " +
                                                                                                                            VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCataloguePricingUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CataloguePricingUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_REQUEST_1_15_0_RC,
                                                                             "OIOUBL Catalogue Request " +
                                                                                                                     VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueRequestXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueRequest_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CREDIT_NOTE_1_15_0_RC,
                                                                             "OIOUBL Credit Note " + VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CreditNote_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_INVOICE_1_15_0_RC,
                                                                             "OIOUBL Invoice " + VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Invoice_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_1_15_0_RC,
                                                                             "OIOUBL Order " + VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Order_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CANCELLATION_1_15_0_RC,
                                                                             "OIOUBL Order Cancellation " +
                                                                                                                      VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderCancellationXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderCancellation_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CHANGE_1_15_0_RC,
                                                                             "OIOUBL Order Change " + VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderChangeXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderChange_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_1_15_0_RC,
                                                                             "OIOUBL Order Response " +
                                                                                                                  VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_15_0_RC,
                                                                             "OIOUBL Order Response Simple " +
                                                                                                                         VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseSimpleXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponseSimple_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_REMINDER_1_15_0_RC,
                                                                             "OIOUBL Reminder " + VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllReminderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Reminder_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_STATEMENT_1_15_0_RC,
                                                                             "OIOUBL Statement " + VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllStatementXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Statement_Schematron.xslt",
                                                                                                                                          _getCL ()))));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_UTILITY_STATEMENT_1_15_0_RC,
                                                                             "OIOUBL Utility Statement " +
                                                                                                                     VERSION_1_15_0_RC,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (aXSDUtilityStatement),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL20 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_UtilityStatement_Schematron.xslt",
                                                                                                                                          _getCL ()))));
    }

    // 1.15.1
    {
      final String sPath = "/external/schematron/oioubl/1.15.1/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_APPLICATION_RESPONSE_1_15_1,
                                                                             "OIOUBL Application Response " +
                                                                                                                     VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_ApplicationResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_1_15_1,
                                                                             "OIOUBL Catalogue " + VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Catalogue_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_DELETION_1_15_1,
                                                                             "OIOUBL Catalogue Deletion " +
                                                                                                                   VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueDeletionXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueDeletion_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_15_1,
                                                                             "OIOUBL Catalogue Item Specification Update " +
                                                                                                                                    VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_15_1,
                                                                             "OIOUBL Catalogue Pricing Update " +
                                                                                                                         VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCataloguePricingUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CataloguePricingUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_REQUEST_1_15_1,
                                                                             "OIOUBL Catalogue Request " +
                                                                                                                  VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueRequestXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueRequest_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CREDIT_NOTE_1_15_1,
                                                                             "OIOUBL Credit Note " + VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CreditNote_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_INVOICE_1_15_1,
                                                                             "OIOUBL Invoice " + VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Invoice_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_1_15_1,
                                                                             "OIOUBL Order " + VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Order_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CANCELLATION_1_15_1,
                                                                             "OIOUBL Order Cancellation " +
                                                                                                                   VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderCancellationXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderCancellation_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CHANGE_1_15_1,
                                                                             "OIOUBL Order Change " + VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderChangeXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderChange_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_1_15_1,
                                                                             "OIOUBL Order Response " + VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_15_1,
                                                                             "OIOUBL Order Response Simple " +
                                                                                                                      VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseSimpleXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponseSimple_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_REMINDER_1_15_1,
                                                                             "OIOUBL Reminder " + VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllReminderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Reminder_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_STATEMENT_1_15_1,
                                                                             "OIOUBL Statement " + VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllStatementXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Statement_Schematron.xslt",
                                                                                                                                          _getCL ()))));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_UTILITY_STATEMENT_1_15_1,
                                                                             "OIOUBL Utility Statement " +
                                                                                                                  VERSION_1_15_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  VERSION_1_15_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (aXSDUtilityStatement),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL20 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_UtilityStatement_Schematron.xslt",
                                                                                                                                          _getCL ()))));
    }

    // 1.15.2
    {
      final String sPath = "/external/schematron/oioubl/1.15.2/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_APPLICATION_RESPONSE_1_15_2,
                                                                             "OIOUBL Application Response " +
                                                                                                                     VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_ApplicationResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_1_15_2,
                                                                             "OIOUBL Catalogue " + VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Catalogue_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_DELETION_1_15_2,
                                                                             "OIOUBL Catalogue Deletion " +
                                                                                                                   VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueDeletionXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueDeletion_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_15_2,
                                                                             "OIOUBL Catalogue Item Specification Update " +
                                                                                                                                    VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_15_2,
                                                                             "OIOUBL Catalogue Pricing Update " +
                                                                                                                         VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCataloguePricingUpdateXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CataloguePricingUpdate_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_REQUEST_1_15_2,
                                                                             "OIOUBL Catalogue Request " +
                                                                                                                  VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueRequestXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CatalogueRequest_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CREDIT_NOTE_1_15_2,
                                                                             "OIOUBL Credit Note " + VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_CreditNote_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_INVOICE_1_15_2,
                                                                             "OIOUBL Invoice " + VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Invoice_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_1_15_2,
                                                                             "OIOUBL Order " + VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Order_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CANCELLATION_1_15_2,
                                                                             "OIOUBL Order Cancellation " +
                                                                                                                   VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderCancellationXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderCancellation_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CHANGE_1_15_2,
                                                                             "OIOUBL Order Change " + VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderChangeXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderChange_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_1_15_2,
                                                                             "OIOUBL Order Response " + VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponse_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_15_2,
                                                                             "OIOUBL Order Response Simple " +
                                                                                                                      VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseSimpleXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_OrderResponseSimple_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_REMINDER_1_15_2,
                                                                             "OIOUBL Reminder " + VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllReminderXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Reminder_Schematron.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_STATEMENT_1_15_2,
                                                                             "OIOUBL Statement " + VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllStatementXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_Statement_Schematron.xslt",
                                                                                                                                          _getCL ()))));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_UTILITY_STATEMENT_1_15_2,
                                                                             "OIOUBL Utility Statement " +
                                                                                                                  VERSION_1_15_2,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VERSION_1_15_2_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (aXSDUtilityStatement),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL20 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL_UtilityStatement_Schematron.xslt",
                                                                                                                                          _getCL ()))));
    }

    // 3.0.1
    {
      final String sPath = "/external/schematron/oioubl/3.0.1/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_1313),
                                                                                    VID_OIOUBL_CREDIT_NOTE_3_0_1,
                                                                                    "OIOUBL Credit Note " +
                                                                                                                  VERSION_3_0_1,
                                                                                    PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                                 "OIOUBL-Creditnote.xslt",
                                                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_1313),
                                                                                    VID_OIOUBL_INVOICE_3_0_1,
                                                                                    "OIOUBL Invoice " + VERSION_3_0_1,
                                                                                    PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                                 "OIOUBL-Invoice.xslt",
                                                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_INVOICE_RESPONSE_3_0_1,
                                                                             "OIOUBL Invoice Response " + VERSION_3_0_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "DK-PEPPOLBIS-T111.xslt",
                                                                                                                                          _getCL ())),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL-Invoice-Response.xslt",
                                                                                                                                          _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_MLR_3_0_1,
                                                                             "OIOUBL Message Level Response " +
                                                                                                   VERSION_3_0_1,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "DK-PEPPOLBIS-T71.xslt",
                                                                                                                                          _getCL ())),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "OIOUBL-Message-Level-Response.xslt",
                                                                                                                                          _getCL ()))));
    }
  }
}
