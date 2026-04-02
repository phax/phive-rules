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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.exception.InitializationException;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl20.UBL20Marshaller;
import com.helger.ubl20.UBL20NamespaceContext;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.IIterableNamespaceContext;

/**
 * Generic OIOUBL validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class OIOUBLLegacyValidation
{
  public static final String GROUPID = "dk.oioubl";

  @NonNull
  private static ClassLoader _getCL ()
  {
    return OIOUBLLegacyValidation.class.getClassLoader ();
  }

  // Ancient old 2.0.2
  private static final String VERSION_202 = "2.0.2";
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_APPLICATION_RESPONSE = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                         "application-response",
                                                                                                         VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                              "catalogue",
                                                                                              VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_DELETION = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                       "catalogue-deletion",
                                                                                                       VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                                        "catalogue-item-specification-update",
                                                                                                                        VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_PRICING_UPDATE = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                             "catalogue-pricing-update",
                                                                                                             VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CATALOGUE_REQUEST = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                      "catalogue-request",
                                                                                                      VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_CREDIT_NOTE = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                "credit-note",
                                                                                                VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_INVOICE = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                            "invoice",
                                                                                            VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                          "order",
                                                                                          VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CANCELLATION = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                       "order-cancellation",
                                                                                                       VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_CHANGE = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                 "order-change",
                                                                                                 VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                   "order-response",
                                                                                                   VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_ORDER_RESPONSE_SIMPLE = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                          "order-response-simple",
                                                                                                          VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_REMINDER = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                             "reminder",
                                                                                             VERSION_202);
  @Deprecated
  public static final DVRCoordinate VID_OIOUBL_STATEMENT = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                              "statement",
                                                                                              VERSION_202);

  // 3.0.1 - deprecated by the government
  private static final String VERSION_3_0_1 = "3.0.1";
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OIOUBL_CREDIT_NOTE_3_0_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                      "credit-note",
                                                                                                      VERSION_3_0_1);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OIOUBL_INVOICE_3_0_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                  "invoice",
                                                                                                  VERSION_3_0_1);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OIOUBL_INVOICE_RESPONSE_3_0_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                                           "invoice-response",
                                                                                                           VERSION_3_0_1);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OIOUBL_MLR_3_0_1 = PhiveRulesHelper.createCoordinate (GROUPID,
                                                                                              "mlr",
                                                                                              VERSION_3_0_1);

  private OIOUBLLegacyValidation ()
  {}

  @NonNull
  private static ValidationExecutorSchematron _createOIOUBL (@NonNull final IReadableResource aRes)
  {
    final IIterableNamespaceContext aNsCtx = UBL20NamespaceContext.getInstance ();
    SchematronNamespaceBeautifier.addMappings (aNsCtx);
    return ValidationExecutorSchematron.createOIOUBL (aRes, aNsCtx);
  }

  /**
   * Register all legacy OIOUBL validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  @SuppressWarnings ("deprecation")
  public static void initLegacyOIOUBL (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // 2.0.2 - ancient old version
    {
      final String sPath202 = "/external/schematron/oioubl/2.0.2/";
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_APPLICATION_RESPONSE)
                       .displayNamePrefix ("OIOUBL Application Response ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllApplicationResponseXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_ApplicationResponse_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_CATALOGUE)
                       .displayNamePrefix ("OIOUBL Catalogue ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllCatalogueXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_Catalogue_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_CATALOGUE_DELETION)
                       .displayNamePrefix ("OIOUBL Catalogue Deletion ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllCatalogueDeletionXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_CatalogueDeletion_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE)
                       .displayNamePrefix ("OIOUBL Catalogue Item Specification Update ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_CATALOGUE_PRICING_UPDATE)
                       .displayNamePrefix ("OIOUBL Catalogue Pricing Update ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllCataloguePricingUpdateXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_CataloguePricingUpdate_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_CATALOGUE_REQUEST)
                       .displayNamePrefix ("OIOUBL Catalogue Request ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllCatalogueRequestXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_CatalogueRequest_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_CREDIT_NOTE)
                       .displayNamePrefix ("OIOUBL Credit Note ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_CreditNote_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_INVOICE)
                       .displayNamePrefix ("OIOUBL Invoice ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 + "OIOUBL_Invoice_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_ORDER)
                       .displayNamePrefix ("OIOUBL Order ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllOrderXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 + "OIOUBL_Order_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_ORDER_CANCELLATION)
                       .displayNamePrefix ("OIOUBL Order Cancellation ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllOrderCancellationXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_OrderCancellation_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_ORDER_CHANGE)
                       .displayNamePrefix ("OIOUBL Order Change ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllOrderChangeXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_OrderChange_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_ORDER_RESPONSE)
                       .displayNamePrefix ("OIOUBL Order Response ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllOrderResponseXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_OrderResponse_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_ORDER_RESPONSE_SIMPLE)
                       .displayNamePrefix ("OIOUBL Order Response Simple ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllOrderResponseSimpleXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_OrderResponseSimple_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_REMINDER)
                       .displayNamePrefix ("OIOUBL Reminder ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllReminderXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_Reminder_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_STATEMENT)
                       .displayNamePrefix ("OIOUBL Statement ")
                       .deprecated ()
                       .addXSD (UBL20Marshaller.getAllStatementXSDs ())
                       .addSchematron (_createOIOUBL (new ClassPathResource (sPath202 +
                                                                             "OIOUBL_Statement_Schematron.xsl",
                                                                             _getCL ())))
                       .registerInto (aRegistry);
    }

    // 3.0.1 (Deprecated)
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote_1_3_13 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_1313);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice_1_3_13 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_1313);
      if (aVESUBLCreditNote_1_3_13 == null || aVESUBLInvoice_1_3_13 == null)
        throw new InitializationException ("The EN 16931 VES are missing. Make sure to call EN16931Validation.initEN16931 first.");

      final String sPath = "/external/schematron/oioubl/3.0.1/xslt/";
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_CREDIT_NOTE_3_0_1)
                       .displayNamePrefix ("OIOUBL Credit Note ")
                       .deprecated ()
                       .basedOn (aVESUBLCreditNote_1_3_13)
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                    "OIOUBL-Creditnote.xslt",
                                                                                                    _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_INVOICE_3_0_1)
                       .displayNamePrefix ("OIOUBL Invoice ")
                       .deprecated ()
                       .basedOn (aVESUBLInvoice_1_3_13)
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                    "OIOUBL-Invoice.xslt",
                                                                                                    _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_INVOICE_RESPONSE_3_0_1)
                       .displayNamePrefix ("OIOUBL Invoice Response ")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                    "DK-PEPPOLBIS-T111.xslt",
                                                                                                    _getCL ())))
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                    "OIOUBL-Invoice-Response.xslt",
                                                                                                    _getCL ())))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OIOUBL_MLR_3_0_1)
                       .displayNamePrefix ("OIOUBL Message Level Response ")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                    "DK-PEPPOLBIS-T71.xslt",
                                                                                                    _getCL ())))
                       .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                    "OIOUBL-Message-Level-Response.xslt",
                                                                                                    _getCL ())))
                       .registerInto (aRegistry);
    }
  }
}
