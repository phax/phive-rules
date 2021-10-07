/*
 * Copyright (C) 2014-2021 Philip Helger (www.helger.com)
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
package com.helger.phive.simplerinvoicing;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.cii.d16b.ECIID16BDocumentType;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.engine.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.engine.schematron.ValidationExecutorSchematron;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.engine.xsd.ValidationExecutorXSD;
import com.helger.ubl21.EUBL21DocumentType;
import com.helger.ubl21.UBL21NamespaceContext;

/**
 * SimplerInvoicing validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class SimplerInvoicingValidation
{
  @Deprecated
  public static final VESID VID_SI_INVOICE_V10 = new VESID ("org.simplerinvoicing", "invoice", "1.0");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V11 = new VESID ("org.simplerinvoicing", "invoice", "1.1");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V12 = new VESID ("org.simplerinvoicing", "invoice", "1.2");
  @Deprecated
  public static final VESID VID_SI_ORDER_V12 = new VESID ("org.simplerinvoicing", "order", "1.2");

  public static final VESID VID_SI_INVOICE_V123 = new VESID ("org.simplerinvoicing", "invoice", "1.2.3");
  public static final VESID VID_SI_ORDER_V123 = new VESID ("org.simplerinvoicing", "order", "1.2.3");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V20 = new VESID ("org.simplerinvoicing", "invoice", "2.0");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V20 = new VESID ("org.simplerinvoicing", "creditnote", "2.0");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V201 = new VESID ("org.simplerinvoicing", "invoice", "2.0.1");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V201 = new VESID ("org.simplerinvoicing", "creditnote", "2.0.1");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V202 = new VESID ("org.simplerinvoicing", "invoice", "2.0.2");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V202 = new VESID ("org.simplerinvoicing", "creditnote", "2.0.2");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V203 = new VESID ("org.simplerinvoicing", "invoice", "2.0.3");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V203 = new VESID ("org.simplerinvoicing", "creditnote", "2.0.3");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V2031 = new VESID ("org.simplerinvoicing", "invoice", "2.0.3.1");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V2031 = new VESID ("org.simplerinvoicing", "creditnote", "2.0.3.1");

  public static final VESID VID_SI_INVOICE_V2032 = new VESID ("org.simplerinvoicing", "invoice", "2.0.3.2");
  public static final VESID VID_SI_CREDIT_NOTE_V2032 = new VESID ("org.simplerinvoicing", "creditnote", "2.0.3.2");

  @Deprecated
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V10 = new VESID ("org.simplerinvoicing", "invoice20.g-account", "1.0");
  @Deprecated
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V101 = new VESID ("org.simplerinvoicing", "invoice20.g-account", "1.0.1");
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V102 = new VESID ("org.simplerinvoicing", "invoice20.g-account", "1.0.2");

  @Deprecated
  public static final VESID VID_SI_NLCIUS_CII_V103 = new VESID ("org.simplerinvoicing", "nlcius-cii", "1.0.3");
  public static final VESID VID_SI_NLCIUS_CII_V1031 = new VESID ("org.simplerinvoicing", "nlcius-cii", "1.0.3.1");

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return SimplerInvoicingValidation.class.getClassLoader ();
  }

  private static final String PATH_SI = "/schematron/simplerinvoicing/";
  private static final String PATH_NL_CIUS = "/schematron/nlcius/";

  // SimplerInvoicing
  // 1.0
  @Deprecated
  public static final ClassPathResource INVOICE_SI10 = new ClassPathResource (PATH_SI + "si-ubl-1.0.xslt", _getCL ());

  // 1.1
  @Deprecated
  public static final ClassPathResource INVOICE_SI11 = new ClassPathResource (PATH_SI + "si-ubl-1.1.xslt", _getCL ());

  // 1.2
  @Deprecated
  public static final ClassPathResource INVOICE_SI12 = new ClassPathResource (PATH_SI + "si-ubl-1.2.xslt", _getCL ());
  @Deprecated
  public static final ClassPathResource ORDER_SI12 = new ClassPathResource (PATH_SI + "si-ubl-1.2-purchaseorder.xslt", _getCL ());

  // 1.2.3
  public static final ClassPathResource INVOICE_SI123 = new ClassPathResource (PATH_SI + "si-ubl-1.2.3.xslt", _getCL ());
  public static final ClassPathResource ORDER_SI123 = new ClassPathResource (PATH_SI + "si-ubl-1.2.3-purchaseorder.xslt", _getCL ());

  // 2.0
  @Deprecated
  public static final ClassPathResource INVOICE_SI20 = new ClassPathResource (PATH_SI + "si-ubl-2.0.xslt", _getCL ());

  // 2.0.1
  @Deprecated
  public static final ClassPathResource INVOICE_SI201 = new ClassPathResource (PATH_SI + "si-ubl-2.0.1.xslt", _getCL ());

  // 2.0.2
  @Deprecated
  public static final ClassPathResource INVOICE_SI202 = new ClassPathResource (PATH_SI + "si-ubl-2.0.2.xslt", _getCL ());

  // 2.0.3
  public static final ClassPathResource INVOICE_SI203 = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.xslt", _getCL ());

  // 2.0.3.1
  public static final ClassPathResource INVOICE_SI2031 = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.1.xslt", _getCL ());

  // 2.0.3.2
  public static final ClassPathResource INVOICE_SI2032 = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.2.xslt", _getCL ());

  private SimplerInvoicingValidation ()
  {}

  @Nonnull
  private static ValidationExecutorSchematron _createXSLT (@Nonnull final ClassPathResource aRes)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, UBL21NamespaceContext.getInstance ());
  }

  /**
   * Register all standard SimplerInvoicing validation execution sets to the
   * provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initSimplerInvoicing (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL21NamespaceContext.getInstance ());

    // SimplerInvoicing is self-contained
    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;
    // 1.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V10,
                                                                           "Simplerinvoicing Invoice 1.0",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (INVOICE_SI10)));

    // 1.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V11,
                                                                           "Simplerinvoicing Invoice 1.1",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (INVOICE_SI11)));

    // 1.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V12,
                                                                           "Simplerinvoicing Invoice 1.2",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (INVOICE_SI12)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_ORDER_V12,
                                                                           "Simplerinvoicing Order 1.2",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER),
                                                                           _createXSLT (ORDER_SI12)));

    // 1.2.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V123,
                                                                           "Simplerinvoicing Invoice 1.2.3",
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (INVOICE_SI123)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_ORDER_V123,
                                                                           "Simplerinvoicing Order 1.2.3",
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER),
                                                                           _createXSLT (ORDER_SI123)));

    // 2.0
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V20,
                                                                           "Simplerinvoicing Invoice 2.0",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (INVOICE_SI20)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V20,
                                                                           "Simplerinvoicing CreditNote 2.0",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           _createXSLT (INVOICE_SI20)));

    // 2.0.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V201,
                                                                           "Simplerinvoicing Invoice 2.0.1",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (INVOICE_SI201)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V201,
                                                                           "Simplerinvoicing CreditNote 2.0.1",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           _createXSLT (INVOICE_SI201)));

    // 2.0.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V202,
                                                                           "Simplerinvoicing Invoice 2.0.2",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (INVOICE_SI202)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V202,
                                                                           "Simplerinvoicing CreditNote 2.0.2",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           _createXSLT (INVOICE_SI202)));

    // 2.0.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V203,
                                                                           "Simplerinvoicing Invoice 2.0.3",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (INVOICE_SI203)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V203,
                                                                           "Simplerinvoicing CreditNote 2.0.3",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           _createXSLT (INVOICE_SI203)));

    // 2.0.3.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2031,
                                                                           "Simplerinvoicing Invoice 2.0.3.1",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (INVOICE_SI2031)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2031,
                                                                           "Simplerinvoicing CreditNote 2.0.3.1",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           _createXSLT (INVOICE_SI2031)));

    // 2.0.3.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2032,
                                                                           "Simplerinvoicing Invoice 2.0.3.2",
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (INVOICE_SI2032)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2032,
                                                                           "Simplerinvoicing CreditNote 2.0.3.2",
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           _createXSLT (INVOICE_SI2032)));

    // 2.0 G-Account 1.0
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V10,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.xslt",
                                                                                                               _getCL ()))));

    // 2.0 G-Account 1.0.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V101,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.1",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.1.xslt",
                                                                                                               _getCL ()))));

    // 2.0 G-Account 1.0.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V102,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.2",
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.2.xslt",
                                                                                                               _getCL ()))));

    // NLCIUS 1.0.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V103,
                                                                           "NLCIUS-CII 1.0.3",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           _createXSLT (new ClassPathResource (PATH_NL_CIUS +
                                                                                                               "nlcius-cii-1.0.3.xslt",
                                                                                                               _getCL ()))));

    // NLCIUS 1.0.3.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1031,
                                                                           "NLCIUS-CII 1.0.3.1",
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           _createXSLT (new ClassPathResource (PATH_NL_CIUS +
                                                                                                               "nlcius-cii-1.0.3.1.xslt",
                                                                                                               _getCL ()))));
  }
}
