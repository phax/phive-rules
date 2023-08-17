/*
 * Copyright (C) 2020-2023 Philip Helger (www.helger.com)
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
package com.helger.phive.ciusro;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.engine.schematron.ValidationExecutorSchematron;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.engine.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl21.UBL21NamespaceContext;

/**
 * Generic CIUS-RO validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class CIUS_ROValidation
{
  public static final String GROUP_ID = "ro.gov.mfinante.cius-ro";

  // Version 1.0.3
  @Deprecated
  public static final VESID VID_CIUS_RO_UBL_CREDITNOTE_103 = new VESID (GROUP_ID, "ubl-creditnote", "1.0.3");
  @Deprecated
  public static final VESID VID_CIUS_RO_UBL_INVOICE_103 = new VESID (GROUP_ID, "ubl-invoice", "1.0.3");

  // Version 1.0.4
  @Deprecated
  public static final VESID VID_CIUS_RO_UBL_CREDITNOTE_104 = new VESID (GROUP_ID, "ubl-creditnote", "1.0.4");
  @Deprecated
  public static final VESID VID_CIUS_RO_UBL_INVOICE_104 = new VESID (GROUP_ID, "ubl-invoice", "1.0.4");

  // Version 1.0.8
  public static final VESID VID_CIUS_RO_UBL_CREDITNOTE_108 = new VESID (GROUP_ID, "ubl-creditnote", "1.0.8");
  public static final VESID VID_CIUS_RO_UBL_INVOICE_108 = new VESID (GROUP_ID, "ubl-invoice", "1.0.8");

  @Deprecated
  private static final ClassPathResource RES_103 = new ClassPathResource ("/external/schematron/1.0.3/ROeFactura-UBL-validation-Invoice_v1.0.3.xslt",
                                                                          _getCL ());

  @Deprecated
  private static final ClassPathResource RES_104 = new ClassPathResource ("/external/schematron/1.0.4/ROeFactura-UBL-validation-Invoice_v1.0.4.xslt",
                                                                          _getCL ());

  private static final ClassPathResource RES_108 = new ClassPathResource ("/external/schematron/1.0.8/ROeFactura-UBL-validation-Invoice_v1.0.8.xslt",
                                                                          _getCL ());

  private CIUS_ROValidation ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return CIUS_ROValidation.class.getClassLoader ();
  }

  /**
   * Register all standard CIUS-RO validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  @SuppressWarnings ("deprecation")
  public static void initCIUS_RO (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // V1.0.3 referencing the underlying EN rules
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CIUS_RO_UBL_CREDITNOTE_103,
                                                                           "CIUS-RO UBL CreditNote " +
                                                                                                           VID_CIUS_RO_UBL_CREDITNOTE_103.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_137_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ()),
                                                                           ValidationExecutorSchematron.createXSLT (RES_103,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CIUS_RO_UBL_INVOICE_103,
                                                                           "CIUS-RO UBL Invoice " +
                                                                                                        VID_CIUS_RO_UBL_INVOICE_103.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_137_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ()),
                                                                           ValidationExecutorSchematron.createXSLT (RES_103,
                                                                                                                    UBL21NamespaceContext.getInstance ())));

    // V1.0.4 referencing the underlying EN rules
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CIUS_RO_UBL_CREDITNOTE_104,
                                                                           "CIUS-RO UBL CreditNote " +
                                                                                                           VID_CIUS_RO_UBL_CREDITNOTE_104.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_137_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ()),
                                                                           ValidationExecutorSchematron.createXSLT (RES_104,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CIUS_RO_UBL_INVOICE_104,
                                                                           "CIUS-RO UBL Invoice " +
                                                                                                        VID_CIUS_RO_UBL_INVOICE_104.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_137_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ()),
                                                                           ValidationExecutorSchematron.createXSLT (RES_104,
                                                                                                                    UBL21NamespaceContext.getInstance ())));

    // V1.0.8 referencing the underlying EN rules, valid per 27.12.2022
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CIUS_RO_UBL_CREDITNOTE_108,
                                                                           "CIUS-RO UBL CreditNote " +
                                                                                                           VID_CIUS_RO_UBL_CREDITNOTE_108.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_138_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ()),
                                                                           ValidationExecutorSchematron.createXSLT (RES_108,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CIUS_RO_UBL_INVOICE_108,
                                                                           "CIUS-RO UBL Invoice " +
                                                                                                        VID_CIUS_RO_UBL_INVOICE_108.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_138_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ()),
                                                                           ValidationExecutorSchematron.createXSLT (RES_108,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
  }
}
