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
package com.helger.phive.oioubl;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.string.StringHelper;
import com.helger.jaxb.builder.IJAXBDocumentType;
import com.helger.jaxb.builder.JAXBDocumentType;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.engine.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.engine.schematron.ValidationExecutorSchematron;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.engine.xsd.ValidationExecutorXSD;
import com.helger.ubl20.CUBL20;
import com.helger.ubl20.EUBL20DocumentType;
import com.helger.ubl20.UBL20NamespaceContext;

import oioubl.names.specification.oioubl.schema.xsd.utilitystatement_2.UtilityStatementType;

/**
 * Generic OIOUBL validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class OIOUBLValidation
{
  public static final String GROUPID = "dk.oioubl";

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return OIOUBLValidation.class.getClassLoader ();
  }

  // Ancient old 2.0.2
  private static final String VERSION_202 = "2.0.2";
  public static final VESID VID_OIOUBL_APPLICATION_RESPONSE = new VESID (GROUPID, "application-response", VERSION_202);
  public static final VESID VID_OIOUBL_CATALOGUE = new VESID (GROUPID, "catalogue", VERSION_202);
  public static final VESID VID_OIOUBL_CATALOGUE_DELETION = new VESID (GROUPID, "catalogue-deletion", VERSION_202);
  public static final VESID VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE = new VESID (GROUPID,
                                                                                        "catalogue-item-specification-update",
                                                                                        VERSION_202);
  public static final VESID VID_OIOUBL_CATALOGUE_PRICING_UPDATE = new VESID (GROUPID, "catalogue-pricing-update", VERSION_202);
  public static final VESID VID_OIOUBL_CATALOGUE_REQUEST = new VESID (GROUPID, "catalogue-request", VERSION_202);
  public static final VESID VID_OIOUBL_CREDIT_NOTE = new VESID (GROUPID, "credit-note", VERSION_202);
  public static final VESID VID_OIOUBL_INVOICE = new VESID (GROUPID, "invoice", VERSION_202);
  public static final VESID VID_OIOUBL_ORDER = new VESID (GROUPID, "order", VERSION_202);
  public static final VESID VID_OIOUBL_ORDER_CANCELLATION = new VESID (GROUPID, "order-cancellation", VERSION_202);
  public static final VESID VID_OIOUBL_ORDER_CHANGE = new VESID (GROUPID, "order-change", VERSION_202);
  public static final VESID VID_OIOUBL_ORDER_RESPONSE = new VESID (GROUPID, "order-response", VERSION_202);
  public static final VESID VID_OIOUBL_ORDER_RESPONSE_SIMPLE = new VESID (GROUPID, "order-response-simple", VERSION_202);
  public static final VESID VID_OIOUBL_REMINDER = new VESID (GROUPID, "reminder", VERSION_202);
  public static final VESID VID_OIOUBL_STATEMENT = new VESID (GROUPID, "statement", VERSION_202);

  // 1.12.3
  private static final String VERSION_1_12_3 = "1.12.3";
  public static final VESID VID_OIOUBL_APPLICATION_RESPONSE_1_12_3 = new VESID (GROUPID, "application-response", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_CATALOGUE_1_12_3 = new VESID (GROUPID, "catalogue", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_CATALOGUE_DELETION_1_12_3 = new VESID (GROUPID, "catalogue-deletion", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_12_3 = new VESID (GROUPID,
                                                                                               "catalogue-item-specification-update",
                                                                                               VERSION_1_12_3);
  public static final VESID VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_12_3 = new VESID (GROUPID, "catalogue-pricing-update", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_CATALOGUE_REQUEST_1_12_3 = new VESID (GROUPID, "catalogue-request", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_CREDIT_NOTE_1_12_3 = new VESID (GROUPID, "credit-note", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_INVOICE_1_12_3 = new VESID (GROUPID, "invoice", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_ORDER_1_12_3 = new VESID (GROUPID, "order", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_ORDER_CANCELLATION_1_12_3 = new VESID (GROUPID, "order-cancellation", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_ORDER_CHANGE_1_12_3 = new VESID (GROUPID, "order-change", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_ORDER_RESPONSE_1_12_3 = new VESID (GROUPID, "order-response", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_12_3 = new VESID (GROUPID, "order-response-simple", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_REMINDER_1_12_3 = new VESID (GROUPID, "reminder", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_STATEMENT_1_12_3 = new VESID (GROUPID, "statement", VERSION_1_12_3);
  public static final VESID VID_OIOUBL_UTILITY_STATEMENT_1_12_3 = new VESID (GROUPID, "utility-statement", VERSION_1_12_3);

  // 1.13.0
  private static final String VERSION_1_13_0 = "1.13.0";
  public static final VESID VID_OIOUBL_APPLICATION_RESPONSE_1_13_0 = new VESID (GROUPID, "application-response", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_CATALOGUE_1_13_0 = new VESID (GROUPID, "catalogue", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_CATALOGUE_DELETION_1_13_0 = new VESID (GROUPID, "catalogue-deletion", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_0 = new VESID (GROUPID,
                                                                                               "catalogue-item-specification-update",
                                                                                               VERSION_1_13_0);
  public static final VESID VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_0 = new VESID (GROUPID, "catalogue-pricing-update", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_CATALOGUE_REQUEST_1_13_0 = new VESID (GROUPID, "catalogue-request", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_CREDIT_NOTE_1_13_0 = new VESID (GROUPID, "credit-note", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_INVOICE_1_13_0 = new VESID (GROUPID, "invoice", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_ORDER_1_13_0 = new VESID (GROUPID, "order", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_ORDER_CANCELLATION_1_13_0 = new VESID (GROUPID, "order-cancellation", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_ORDER_CHANGE_1_13_0 = new VESID (GROUPID, "order-change", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_ORDER_RESPONSE_1_13_0 = new VESID (GROUPID, "order-response", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_0 = new VESID (GROUPID, "order-response-simple", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_REMINDER_1_13_0 = new VESID (GROUPID, "reminder", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_STATEMENT_1_13_0 = new VESID (GROUPID, "statement", VERSION_1_13_0);
  public static final VESID VID_OIOUBL_UTILITY_STATEMENT_1_13_0 = new VESID (GROUPID, "utility-statement", VERSION_1_13_0);

  private OIOUBLValidation ()
  {}

  @Nonnull
  private static ValidationExecutorSchematron _createOIOUBL (@Nonnull final IReadableResource aRes)
  {
    return ValidationExecutorSchematron.createOIOUBL (aRes, UBL20NamespaceContext.getInstance ());
  }

  @Nonnull
  private static ValidationExecutorSchematron _createXSLT (@Nonnull final IReadableResource aRes)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, UBL20NamespaceContext.getInstance ());
  }

  /**
   * Register all standard OIOUBL validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initOIOUBL (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL20NamespaceContext.getInstance ());

    final boolean bNotDeprecated = false;

    // 2.0.2 - ancient old version
    {
      final String sPath202 = "/schematron/oioubl/2.0.2/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_APPLICATION_RESPONSE,
                                                                             "OIOUBL Application Response " +
                                                                                                              VID_OIOUBL_APPLICATION_RESPONSE.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.APPLICATION_RESPONSE),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_ApplicationResponse_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE,
                                                                             "OIOUBL Catalogue " + VID_OIOUBL_CATALOGUE.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_Catalogue_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_DELETION,
                                                                             "OIOUBL Catalogue Deletion " +
                                                                                                            VID_OIOUBL_CATALOGUE_DELETION.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE_DELETION),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_CatalogueDeletion_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE,
                                                                             "OIOUBL Catalogue Item Specification Update " +
                                                                                                                             VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE_ITEM_SPECIFICATION_UPDATE),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_PRICING_UPDATE,
                                                                             "OIOUBL Catalogue Pricing Update " +
                                                                                                                  VID_OIOUBL_CATALOGUE_PRICING_UPDATE.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE_PRICING_UPDATE),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_CataloguePricingUpdate_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_REQUEST,
                                                                             "OIOUBL Catalogue Request " +
                                                                                                           VID_OIOUBL_CATALOGUE_REQUEST.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE_REQUEST),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_CatalogueRequest_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CREDIT_NOTE,
                                                                             "OIOUBL Credit Note " + VID_OIOUBL_CREDIT_NOTE.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CREDIT_NOTE),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_CreditNote_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_INVOICE,
                                                                             "OIOUBL Invoice " + VID_OIOUBL_INVOICE.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.INVOICE),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_Invoice_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER,
                                                                             "OIOUBL Order " + VID_OIOUBL_ORDER.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_Order_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CANCELLATION,
                                                                             "OIOUBL Order Cancellation " +
                                                                                                            VID_OIOUBL_ORDER_CANCELLATION.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER_CANCELLATION),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_OrderCancellation_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CHANGE,
                                                                             "OIOUBL Order Change " + VID_OIOUBL_ORDER_CHANGE.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER_CHANGE),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_OrderChange_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE,
                                                                             "OIOUBL Order Response " +
                                                                                                        VID_OIOUBL_ORDER_RESPONSE.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER_RESPONSE),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_OrderResponse_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_SIMPLE,
                                                                             "OIOUBL Order Response Simple " +
                                                                                                               VID_OIOUBL_ORDER_RESPONSE_SIMPLE.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER_RESPONSE_SIMPLE),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_OrderResponseSimple_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_REMINDER,
                                                                             "OIOUBL Reminder " + VID_OIOUBL_REMINDER.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.REMINDER),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_Reminder_Schematron.xsl",
                                                                                                                   _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_STATEMENT,
                                                                             "OIOUBL Statement " + VID_OIOUBL_STATEMENT.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.STATEMENT),
                                                                             _createOIOUBL (new ClassPathResource (sPath202 +
                                                                                                                   "OIOUBL_Statement_Schematron.xsl",
                                                                                                                   _getCL ()))));
    }

    final IJAXBDocumentType aXSDUtilityStatement = new JAXBDocumentType (UtilityStatementType.class,
                                                                         new CommonsArrayList <> (CUBL20.XSD_CODELIST_UNIT_CODE,
                                                                                                  CUBL20.XSD_CODELIST_MIME_MEDIA_TYPE_CODE,
                                                                                                  CUBL20.XSD_CODELIST_CURRENCY_CODE,
                                                                                                  CUBL20.XSD_CODELIST_LANGUAGE_CODE,
                                                                                                  CUBL20.XSD_UNQUALIFIED_DATA_TYPES,
                                                                                                  CUBL20.XSD_QUALIFIED_DATA_TYPES,
                                                                                                  new ClassPathResource ("schemas/OIOUBL_v2.1-b/common/OIOUBL_UTS-CommonBasicComponents-2.1.xsd",
                                                                                                                         _getCL ()),
                                                                                                  new ClassPathResource ("schemas/OIOUBL_v2.1-b/common/OIOUBL_UTS-CommonAggregateComponents-2.1.xsd",
                                                                                                                         _getCL ()),
                                                                                                  new ClassPathResource ("schemas/OIOUBL_v2.1-b/maindoc/UBL-UtilityStatement-2.1.xsd",
                                                                                                                         _getCL ())),
                                                                         s -> StringHelper.trimEnd (s, "Type"));

    // 1.12.3
    {
      final String sPath = "/schematron/oioubl/1.12.3/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_APPLICATION_RESPONSE_1_12_3,
                                                                             "OIOUBL Application Response " +
                                                                                                                     VID_OIOUBL_APPLICATION_RESPONSE_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.APPLICATION_RESPONSE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_ApplicationResponse_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_1_12_3,
                                                                             "OIOUBL Catalogue " +
                                                                                                          VID_OIOUBL_CATALOGUE_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_Catalogue_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_DELETION_1_12_3,
                                                                             "OIOUBL Catalogue Deletion " +
                                                                                                                   VID_OIOUBL_CATALOGUE_DELETION_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE_DELETION),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_CatalogueDeletion_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_12_3,
                                                                             "OIOUBL Catalogue Item Specification Update " +
                                                                                                                                    VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE_ITEM_SPECIFICATION_UPDATE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_12_3,
                                                                             "OIOUBL Catalogue Pricing Update " +
                                                                                                                         VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE_PRICING_UPDATE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_CataloguePricingUpdate_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_REQUEST_1_12_3,
                                                                             "OIOUBL Catalogue Request " +
                                                                                                                  VID_OIOUBL_CATALOGUE_REQUEST_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE_REQUEST),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_CatalogueRequest_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CREDIT_NOTE_1_12_3,
                                                                             "OIOUBL Credit Note " +
                                                                                                            VID_OIOUBL_CREDIT_NOTE_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CREDIT_NOTE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_CreditNote_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_INVOICE_1_12_3,
                                                                             "OIOUBL Invoice " + VID_OIOUBL_INVOICE_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.INVOICE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_Invoice_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_1_12_3,
                                                                             "OIOUBL Order " + VID_OIOUBL_ORDER_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_Order_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CANCELLATION_1_12_3,
                                                                             "OIOUBL Order Cancellation " +
                                                                                                                   VID_OIOUBL_ORDER_CANCELLATION_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER_CANCELLATION),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_OrderCancellation_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CHANGE_1_12_3,
                                                                             "OIOUBL Order Change " +
                                                                                                             VID_OIOUBL_ORDER_CHANGE_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER_CHANGE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_OrderChange_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_1_12_3,
                                                                             "OIOUBL Order Response " +
                                                                                                               VID_OIOUBL_ORDER_RESPONSE_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER_RESPONSE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_OrderResponse_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_12_3,
                                                                             "OIOUBL Order Response Simple " +
                                                                                                                      VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER_RESPONSE_SIMPLE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_OrderResponseSimple_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_REMINDER_1_12_3,
                                                                             "OIOUBL Reminder " + VID_OIOUBL_REMINDER_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.REMINDER),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_Reminder_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_STATEMENT_1_12_3,
                                                                             "OIOUBL Statement " +
                                                                                                          VID_OIOUBL_STATEMENT_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.STATEMENT),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_Statement_Schematron.xslt",
                                                                                                                 _getCL ()))));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_UTILITY_STATEMENT_1_12_3,
                                                                             "OIOUBL Utility Statement " +
                                                                                                                  VID_OIOUBL_UTILITY_STATEMENT_1_12_3.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (aXSDUtilityStatement),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_UtilityStatement_Schematron.xslt",
                                                                                                                 _getCL ()))));
    }

    // 1.13.0
    {
      final String sPath = "/schematron/oioubl/1.13.0/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_APPLICATION_RESPONSE_1_13_0,
                                                                             "OIOUBL Application Response " +
                                                                                                                     VID_OIOUBL_APPLICATION_RESPONSE_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.APPLICATION_RESPONSE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_ApplicationResponse_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_1_13_0,
                                                                             "OIOUBL Catalogue " +
                                                                                                          VID_OIOUBL_CATALOGUE_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_Catalogue_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_DELETION_1_13_0,
                                                                             "OIOUBL Catalogue Deletion " +
                                                                                                                   VID_OIOUBL_CATALOGUE_DELETION_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE_DELETION),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_CatalogueDeletion_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_0,
                                                                             "OIOUBL Catalogue Item Specification Update " +
                                                                                                                                    VID_OIOUBL_CATALOGUE_ITEM_SPECIFICATION_UPDATE_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE_ITEM_SPECIFICATION_UPDATE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_CatalogueItemSpecificationUpdate_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_0,
                                                                             "OIOUBL Catalogue Pricing Update " +
                                                                                                                         VID_OIOUBL_CATALOGUE_PRICING_UPDATE_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE_PRICING_UPDATE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_CataloguePricingUpdate_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CATALOGUE_REQUEST_1_13_0,
                                                                             "OIOUBL Catalogue Request " +
                                                                                                                  VID_OIOUBL_CATALOGUE_REQUEST_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CATALOGUE_REQUEST),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_CatalogueRequest_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_CREDIT_NOTE_1_13_0,
                                                                             "OIOUBL Credit Note " +
                                                                                                            VID_OIOUBL_CREDIT_NOTE_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.CREDIT_NOTE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_CreditNote_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_INVOICE_1_13_0,
                                                                             "OIOUBL Invoice " + VID_OIOUBL_INVOICE_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.INVOICE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_Invoice_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_1_13_0,
                                                                             "OIOUBL Order " + VID_OIOUBL_ORDER_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_Order_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CANCELLATION_1_13_0,
                                                                             "OIOUBL Order Cancellation " +
                                                                                                                   VID_OIOUBL_ORDER_CANCELLATION_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER_CANCELLATION),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_OrderCancellation_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_CHANGE_1_13_0,
                                                                             "OIOUBL Order Change " +
                                                                                                             VID_OIOUBL_ORDER_CHANGE_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER_CHANGE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_OrderChange_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_1_13_0,
                                                                             "OIOUBL Order Response " +
                                                                                                               VID_OIOUBL_ORDER_RESPONSE_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER_RESPONSE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_OrderResponse_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_0,
                                                                             "OIOUBL Order Response Simple " +
                                                                                                                      VID_OIOUBL_ORDER_RESPONSE_SIMPLE_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.ORDER_RESPONSE_SIMPLE),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_OrderResponseSimple_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_REMINDER_1_13_0,
                                                                             "OIOUBL Reminder " + VID_OIOUBL_REMINDER_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.REMINDER),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_Reminder_Schematron.xslt",
                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_STATEMENT_1_13_0,
                                                                             "OIOUBL Statement " +
                                                                                                          VID_OIOUBL_STATEMENT_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (EUBL20DocumentType.STATEMENT),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_Statement_Schematron.xslt",
                                                                                                                 _getCL ()))));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OIOUBL_UTILITY_STATEMENT_1_13_0,
                                                                             "OIOUBL Utility Statement " +
                                                                                                                  VID_OIOUBL_UTILITY_STATEMENT_1_13_0.getVersion (),
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (aXSDUtilityStatement),
                                                                             _createXSLT (new ClassPathResource (sPath +
                                                                                                                 "OIOUBL_UtilityStatement_Schematron.xslt",
                                                                                                                 _getCL ()))));
    }
  }
}
