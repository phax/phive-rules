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

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl20.UBL20Marshaller;
import com.helger.ubl20.UBL20NamespaceContext;
import com.helger.xml.namespace.IIterableNamespaceContext;

import jakarta.annotation.Nonnull;

/**
 * Generic OIOUBL validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class OIOUBLLegacyValidation
{
  public static final String GROUPID = "dk.oioubl";

  @Nonnull
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

  private OIOUBLLegacyValidation ()
  {}

  @Nonnull
  private static ValidationExecutorSchematron _createOIOUBL (@Nonnull final IReadableResource aRes)
  {
    final IIterableNamespaceContext aNsCtx = UBL20NamespaceContext.getInstance ();
    SchematronNamespaceBeautifier.addMappings (aNsCtx);
    return ValidationExecutorSchematron.createOIOUBL (aRes, aNsCtx);
  }

  /**
   * Register all legacy OIOUBL validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initLegacyOIOUBL (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;

    // 2.0.2 - ancient old version
    {
      final String sPath202 = "/external/schematron/oioubl/2.0.2/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_APPLICATION_RESPONSE,
                                                                             "OIOUBL Application Response " +
                                                                                                              VID_OIOUBL_APPLICATION_RESPONSE.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllApplicationResponseXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_ApplicationResponse_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE,
                                                                             "OIOUBL Catalogue " +
                                                                                                   VID_OIOUBL_CATALOGUE.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllCatalogueXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_Catalogue_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_DELETION,
                                                                             "OIOUBL Catalogue Deletion " +
                                                                                                            VID_OIOUBL_CATALOGUE_DELETION.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllCatalogueDeletionXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_CatalogueDeletion_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE,
                                                                             "OIOUBL Catalogue Item Specification Update " +
                                                                                                                             VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllCatalogueItemSpecificationUpdateXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_PRICING_UPDATE,
                                                                             "OIOUBL Catalogue Pricing Update " +
                                                                                                                  VID_OIOUBL_CATALOGUE_PRICING_UPDATE.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllCataloguePricingUpdateXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_CataloguePricingUpdate_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_REQUEST,
                                                                             "OIOUBL Catalogue Request " +
                                                                                                           VID_OIOUBL_CATALOGUE_REQUEST.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllCatalogueRequestXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_CatalogueRequest_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CREDIT_NOTE,
                                                                             "OIOUBL Credit Note " +
                                                                                                     VID_OIOUBL_CREDIT_NOTE.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllCreditNoteXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_CreditNote_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_INVOICE,
                                                                             "OIOUBL Invoice " +
                                                                                                 VID_OIOUBL_INVOICE.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllInvoiceXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_Invoice_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER,
                                                                             "OIOUBL Order " +
                                                                                               VID_OIOUBL_ORDER.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllOrderXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_Order_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CANCELLATION,
                                                                             "OIOUBL Order Cancellation " +
                                                                                                            VID_OIOUBL_ORDER_CANCELLATION.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllOrderCancellationXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_OrderCancellation_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CHANGE,
                                                                             "OIOUBL Order Change " +
                                                                                                      VID_OIOUBL_ORDER_CHANGE.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllOrderChangeXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_OrderChange_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE,
                                                                             "OIOUBL Order Response " +
                                                                                                        VID_OIOUBL_ORDER_RESPONSE.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllOrderResponseXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_OrderResponse_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_SIMPLE,
                                                                             "OIOUBL Order Response Simple " +
                                                                                                               VID_OIOUBL_ORDER_RESPONSE_SIMPLE.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllOrderResponseSimpleXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_OrderResponseSimple_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_REMINDER,
                                                                             "OIOUBL Reminder " +
                                                                                                  VID_OIOUBL_REMINDER.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllReminderXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_Reminder_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_STATEMENT,
                                                                             "OIOUBL Statement " +
                                                                                                   VID_OIOUBL_STATEMENT.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL20Marshaller.getAllStatementXSDs ()),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_Statement_Schematron.xsl",
                                                                                                                   _getCL ()))));
    }
  }
}
