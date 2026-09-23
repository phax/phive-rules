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
import com.helger.phive.rules.shared.PhiveRulesUBLHelper;
import com.helger.phive.rules.shared.DVRHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
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

  // 1.17.2
  private static final String VERSION_1_17_2 = "1.17.2";
  public static final LocalDate VERSION_1_17_2_VALID_PER = PDTFactory.createLocalDate (2026, Month.MAY, 1);
  public static final OffsetDateTime VERSION_1_17_2_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (VERSION_1_17_2_VALID_PER);
  public static final DVRCoordinate VID_OIOUBL_APPLICATION_RESPONSE_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                                         "application-response",
                                                                                                         VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                              "catalogue",
                                                                                              VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_DELETION_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                                       "catalogue-deletion",
                                                                                                       VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                                                        "catalogue-item-specification-update",
                                                                                                                        VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                                             "catalogue-pricing-update",
                                                                                                             VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_REQUEST_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                                      "catalogue-request",
                                                                                                      VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_CREDIT_NOTE_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                                "credit-note",
                                                                                                VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_INVOICE_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                            "invoice",
                                                                                            VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_ORDER_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                          "order",
                                                                                          VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_ORDER_CANCELLATION_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                                       "order-cancellation",
                                                                                                       VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_ORDER_CHANGE_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                                 "order-change",
                                                                                                 VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                                   "order-response",
                                                                                                   VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                                          "order-response-simple",
                                                                                                          VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_REMINDER_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                             "reminder",
                                                                                             VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_STATEMENT_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                              "statement",
                                                                                              VERSION_1_17_2);
  public static final DVRCoordinate VID_OIOUBL_UTILITY_STATEMENT_1_17_2 = DVRHelper.createCoordinate (GROUPID,
                                                                                                      "utility-statement",
                                                                                                      VERSION_1_17_2);

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

    // 1.17.2
    {
      final String sPath = "/external/schematron/oioubl/1.17.2/xslt/";
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_APPLICATION_RESPONSE_1_17_2)
                   .displayNamePrefix ("OIOUBL Application Response ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_ApplicationResponse_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_CATALOGUE_1_17_2)
                   .displayNamePrefix ("OIOUBL Catalogue ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllCatalogueXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_Catalogue_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_CATALOGUE_DELETION_1_17_2)
                   .displayNamePrefix ("OIOUBL Catalogue Deletion ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllCatalogueDeletionXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_CatalogueDeletion_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_17_2)
                   .displayNamePrefix ("OIOUBL Catalogue Item Specification Update ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_17_2)
                   .displayNamePrefix ("OIOUBL Catalogue Pricing Update ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllCataloguePricingUpdateXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_CataloguePricingUpdate_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_CATALOGUE_REQUEST_1_17_2)
                   .displayNamePrefix ("OIOUBL Catalogue Request ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllCatalogueRequestXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_CatalogueRequest_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_CREDIT_NOTE_1_17_2)
                   .displayNamePrefix ("OIOUBL Credit Note ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_CreditNote_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_INVOICE_1_17_2)
                   .displayNamePrefix ("OIOUBL Invoice ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_Invoice_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_ORDER_1_17_2)
                   .displayNamePrefix ("OIOUBL Order ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllOrderXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_Order_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_ORDER_CANCELLATION_1_17_2)
                   .displayNamePrefix ("OIOUBL Order Cancellation ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllOrderCancellationXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_OrderCancellation_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_ORDER_CHANGE_1_17_2)
                   .displayNamePrefix ("OIOUBL Order Change ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllOrderChangeXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_OrderChange_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_ORDER_RESPONSE_1_17_2)
                   .displayNamePrefix ("OIOUBL Order Response ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllOrderResponseXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_OrderResponse_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_17_2)
                   .displayNamePrefix ("OIOUBL Order Response Simple ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllOrderResponseSimpleXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_OrderResponseSimple_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_REMINDER_1_17_2)
                   .displayNamePrefix ("OIOUBL Reminder ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllReminderXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_Reminder_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_STATEMENT_1_17_2)
                   .displayNamePrefix ("OIOUBL Statement ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllStatementXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_Statement_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);

      VesXmlBuilder.builder ()
                   .vesID (VID_OIOUBL_UTILITY_STATEMENT_1_17_2)
                   .displayNamePrefix ("OIOUBL Utility Statement ")
                   .notDeprecated ()
                   .validFrom (VERSION_1_17_2_VALID_PER_UTC)
                   .addXSD (aXSDUtilityStatement)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL20 (new ClassPathResource (sPath +
                                                                                                "OIOUBL_UtilityStatement_Schematron.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
    }
  }
}
