/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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

import com.helger.cii.d16b.CCIID16B;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.diver.api.version.VESID;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatus;
import com.helger.phive.xml.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl21.UBL21NamespaceContext;

/**
 * SimplerInvoicing validation configuration<br>
 * November 2022 release: will be in effect on February 6th, 2023
 *
 * @author Philip Helger
 */
@Immutable
public final class SimplerInvoicingValidation
{
  public static final String GROUP_ID = "org.simplerinvoicing";

  @Deprecated
  public static final VESID VID_SI_INVOICE_V10 = new VESID (GROUP_ID, "invoice", "1.0");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V11 = new VESID (GROUP_ID, "invoice", "1.1");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V12 = new VESID (GROUP_ID, "invoice", "1.2");
  @Deprecated
  public static final VESID VID_SI_ORDER_V12 = new VESID (GROUP_ID, "order", "1.2");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V123 = new VESID (GROUP_ID, "invoice", "1.2.3");
  @Deprecated
  public static final VESID VID_SI_ORDER_V123 = new VESID (GROUP_ID, "order", "1.2.3");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V124 = new VESID (GROUP_ID, "invoice", "1.2.4");
  @Deprecated
  public static final VESID VID_SI_ORDER_V124 = new VESID (GROUP_ID, "order", "1.2.4");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V20 = new VESID (GROUP_ID, "invoice", "2.0");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V20 = new VESID (GROUP_ID, "creditnote", "2.0");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V201 = new VESID (GROUP_ID, "invoice", "2.0.1");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V201 = new VESID (GROUP_ID, "creditnote", "2.0.1");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V202 = new VESID (GROUP_ID, "invoice", "2.0.2");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V202 = new VESID (GROUP_ID, "creditnote", "2.0.2");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V203 = new VESID (GROUP_ID, "invoice", "2.0.3");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V203 = new VESID (GROUP_ID, "creditnote", "2.0.3");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V2031 = new VESID (GROUP_ID, "invoice", "2.0.3.1");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V2031 = new VESID (GROUP_ID, "creditnote", "2.0.3.1");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V2032 = new VESID (GROUP_ID, "invoice", "2.0.3.2");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V2032 = new VESID (GROUP_ID, "creditnote", "2.0.3.2");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V2033 = new VESID (GROUP_ID, "invoice", "2.0.3.3");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V2033 = new VESID (GROUP_ID, "creditnote", "2.0.3.3");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V2034 = new VESID (GROUP_ID, "invoice", "2.0.3.4");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V2034 = new VESID (GROUP_ID, "creditnote", "2.0.3.4");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V2035 = new VESID (GROUP_ID, "invoice", "2.0.3.5");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V2035 = new VESID (GROUP_ID, "creditnote", "2.0.3.5");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V2036 = new VESID (GROUP_ID, "invoice", "2.0.3.6");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V2036 = new VESID (GROUP_ID, "creditnote", "2.0.3.6");

  @Deprecated
  public static final VESID VID_SI_INVOICE_V2037 = new VESID (GROUP_ID, "invoice", "2.0.3.7");
  @Deprecated
  public static final VESID VID_SI_CREDIT_NOTE_V2037 = new VESID (GROUP_ID, "creditnote", "2.0.3.7");

  public static final VESID VID_SI_INVOICE_V2038 = new VESID (GROUP_ID, "invoice", "2.0.3.8");
  public static final VESID VID_SI_CREDIT_NOTE_V2038 = new VESID (GROUP_ID, "creditnote", "2.0.3.8");

  // In effect from August 27, 2024
  public static final VESID VID_SI_INVOICE_V2039 = new VESID (GROUP_ID, "invoice", "2.0.3.9");
  public static final VESID VID_SI_CREDIT_NOTE_V2039 = new VESID (GROUP_ID, "creditnote", "2.0.3.9");

  @Deprecated
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V10 = new VESID (GROUP_ID, "invoice20.g-account", "1.0");
  @Deprecated
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V101 = new VESID (GROUP_ID, "invoice20.g-account", "1.0.1");
  @Deprecated
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V102 = new VESID (GROUP_ID, "invoice20.g-account", "1.0.2");
  @Deprecated
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V103 = new VESID (GROUP_ID, "invoice20.g-account", "1.0.3");
  @Deprecated
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V104 = new VESID (GROUP_ID, "invoice20.g-account", "1.0.4");
  @Deprecated
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V105 = new VESID (GROUP_ID, "invoice20.g-account", "1.0.5");
  @Deprecated
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V106 = new VESID (GROUP_ID, "invoice20.g-account", "1.0.6");
  @Deprecated
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V107 = new VESID (GROUP_ID, "invoice20.g-account", "1.0.7");
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V108 = new VESID (GROUP_ID, "invoice20.g-account", "1.0.8");
  public static final VESID VID_SI_INVOICE_20_GACCOUNT_V109 = new VESID (GROUP_ID, "invoice20.g-account", "1.0.9");

  @Deprecated
  public static final VESID VID_SI_NLCIUS_CII_V103 = new VESID (GROUP_ID, "nlcius-cii", "1.0.3");
  @Deprecated
  public static final VESID VID_SI_NLCIUS_CII_V1031 = new VESID (GROUP_ID, "nlcius-cii", "1.0.3.1");
  @Deprecated
  public static final VESID VID_SI_NLCIUS_CII_V1032 = new VESID (GROUP_ID, "nlcius-cii", "1.0.3.2");
  @Deprecated
  public static final VESID VID_SI_NLCIUS_CII_V1033 = new VESID (GROUP_ID, "nlcius-cii", "1.0.3.3");
  @Deprecated
  public static final VESID VID_SI_NLCIUS_CII_V1034 = new VESID (GROUP_ID, "nlcius-cii", "1.0.3.4");
  @Deprecated
  public static final VESID VID_SI_NLCIUS_CII_V1035 = new VESID (GROUP_ID, "nlcius-cii", "1.0.3.5");
  @Deprecated
  public static final VESID VID_SI_NLCIUS_CII_V1036 = new VESID (GROUP_ID, "nlcius-cii", "1.0.3.6");
  public static final VESID VID_SI_NLCIUS_CII_V1037 = new VESID (GROUP_ID, "nlcius-cii", "1.0.3.7");
  public static final VESID VID_SI_NLCIUS_CII_V1038 = new VESID (GROUP_ID, "nlcius-cii", "1.0.3.8");

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return SimplerInvoicingValidation.class.getClassLoader ();
  }

  private static final String PATH_SI = "/external/schematron/simplerinvoicing/";
  private static final String PATH_NL_CIUS = "/external/schematron/nlcius/";

  // SimplerInvoicing
  // 1.0
  @Deprecated
  private static final ClassPathResource INVOICE_SI10 = new ClassPathResource (PATH_SI + "si-ubl-1.0.xslt", _getCL ());

  // 1.1
  @Deprecated
  public static final ClassPathResource INVOICE_SI11 = new ClassPathResource (PATH_SI + "si-ubl-1.1.xslt", _getCL ());

  // 1.2
  @Deprecated
  public static final ClassPathResource INVOICE_SI12 = new ClassPathResource (PATH_SI + "si-ubl-1.2.xslt", _getCL ());
  @Deprecated
  private static final ClassPathResource ORDER_SI12 = new ClassPathResource (PATH_SI + "si-ubl-1.2-purchaseorder.xslt",
                                                                             _getCL ());

  // 1.2.3
  @Deprecated
  private static final ClassPathResource INVOICE_SI123 = new ClassPathResource (PATH_SI + "si-ubl-1.2.3.xslt",
                                                                                _getCL ());
  @Deprecated
  private static final ClassPathResource ORDER_SI123 = new ClassPathResource (PATH_SI +
                                                                              "si-ubl-1.2.3-purchaseorder.xslt",
                                                                              _getCL ());

  // 1.2.4
  private static final ClassPathResource INVOICE_SI124 = new ClassPathResource (PATH_SI + "si-ubl-1.2.4.xslt",
                                                                                _getCL ());
  private static final ClassPathResource ORDER_SI124 = new ClassPathResource (PATH_SI +
                                                                              "si-ubl-1.2.4-purchaseorder.xslt",
                                                                              _getCL ());

  // 2.0
  @Deprecated
  public static final ClassPathResource INVOICE_SI20 = new ClassPathResource (PATH_SI + "si-ubl-2.0.xslt", _getCL ());

  // 2.0.1
  @Deprecated
  private static final ClassPathResource INVOICE_SI201 = new ClassPathResource (PATH_SI + "si-ubl-2.0.1.xslt",
                                                                                _getCL ());

  // 2.0.2
  @Deprecated
  private static final ClassPathResource INVOICE_SI202 = new ClassPathResource (PATH_SI + "si-ubl-2.0.2.xslt",
                                                                                _getCL ());

  // 2.0.3
  @Deprecated
  private static final ClassPathResource INVOICE_SI203 = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.xslt",
                                                                                _getCL ());

  // 2.0.3.1
  @Deprecated
  private static final ClassPathResource INVOICE_SI2031 = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.1.xslt",
                                                                                 _getCL ());

  // 2.0.3.2
  @Deprecated
  private static final ClassPathResource INVOICE_SI2032 = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.2.xslt",
                                                                                 _getCL ());

  // 2.0.3.3
  @Deprecated
  private static final ClassPathResource INVOICE_SI2033 = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.3.xslt",
                                                                                 _getCL ());

  // 2.0.3.4
  @Deprecated
  private static final ClassPathResource INVOICE_SI2034 = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.4.xslt",
                                                                                 _getCL ());

  // 2.0.3.5
  @Deprecated
  public static final ClassPathResource INVOICE_SI2035 = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.5.xslt",
                                                                                _getCL ());

  // 2.0.3.6
  @Deprecated
  private static final ClassPathResource INVOICE_SI2036 = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.6.xslt",
                                                                                 _getCL ());

  // 2.0.3.7
  private static final ClassPathResource INVOICE_SI2037 = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.7.xslt",
                                                                                 _getCL ());

  // 2.0.3.8
  private static final ClassPathResource INVOICE_SI2038 = new ClassPathResource (PATH_SI + "si-ubl-2.0.3.8.xslt",
                                                                                 _getCL ());

  private SimplerInvoicingValidation ()
  {}

  @Nonnull
  private static ValidationExecutorSchematron _createXSLT (@Nonnull final ClassPathResource aRes)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, UBL21NamespaceContext.getInstance ());
  }

  @Nonnull
  private static IValidationExecutorSetStatus _createStatus (final boolean bIsDeprecated)
  {
    return ValidationExecutorSetStatus.createDeprecatedNow (bIsDeprecated);
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
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI10)));

    // 1.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V11,
                                                                           "Simplerinvoicing Invoice 1.1",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI11)));

    // 1.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V12,
                                                                           "Simplerinvoicing Invoice 1.2",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI12)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_ORDER_V12,
                                                                           "Simplerinvoicing Order 1.2",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                           _createXSLT (ORDER_SI12)));

    // 1.2.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V123,
                                                                           "Simplerinvoicing Invoice 1.2.3",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI123)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_ORDER_V123,
                                                                           "Simplerinvoicing Order 1.2.3",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                           _createXSLT (ORDER_SI123)));

    // 1.2.4
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V124,
                                                                           "Simplerinvoicing Invoice 1.2.4",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI124)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_ORDER_V124,
                                                                           "Simplerinvoicing Order 1.2.4",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                           _createXSLT (ORDER_SI124)));

    // 2.0
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V20,
                                                                           "Simplerinvoicing Invoice 2.0",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI20)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V20,
                                                                           "Simplerinvoicing Credit Note 2.0",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI20)));

    // 2.0.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V201,
                                                                           "Simplerinvoicing Invoice 2.0.1",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI201)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V201,
                                                                           "Simplerinvoicing Credit Note 2.0.1",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI201)));

    // 2.0.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V202,
                                                                           "Simplerinvoicing Invoice 2.0.2",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI202)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V202,
                                                                           "Simplerinvoicing Credit Note 2.0.2",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI202)));

    // 2.0.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V203,
                                                                           "Simplerinvoicing Invoice 2.0.3",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI203)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V203,
                                                                           "Simplerinvoicing Credit Note 2.0.3",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI203)));

    // 2.0.3.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2031,
                                                                           "Simplerinvoicing Invoice 2.0.3.1",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI2031)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2031,
                                                                           "Simplerinvoicing Credit Note 2.0.3.1",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI2031)));

    // 2.0.3.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2032,
                                                                           "Simplerinvoicing Invoice 2.0.3.2",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI2032)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2032,
                                                                           "Simplerinvoicing Credit Note 2.0.3.2",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI2032)));

    // 2.0.3.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2033,
                                                                           "Simplerinvoicing Invoice 2.0.3.3",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI2033)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2033,
                                                                           "Simplerinvoicing Credit Note 2.0.3.3",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI2033)));

    // 2.0.3.4
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2034,
                                                                           "Simplerinvoicing Invoice 2.0.3.4",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI2034)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2034,
                                                                           "Simplerinvoicing Credit Note 2.0.3.4",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI2034)));

    // 2.0.3.5
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2035,
                                                                           "Simplerinvoicing Invoice 2.0.3.5",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI2035)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2035,
                                                                           "Simplerinvoicing Credit Note 2.0.3.5",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI2035)));

    // 2.0.3.6
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2036,
                                                                           "Simplerinvoicing Invoice 2.0.3.6",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI2036)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2036,
                                                                           "Simplerinvoicing Credit Note 2.0.3.6",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI2036)));

    // 2.0.3.7
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2037,
                                                                           "Simplerinvoicing Invoice 2.0.3.7",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI2037)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2037,
                                                                           "Simplerinvoicing Credit Note 2.0.3.7",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI2037)));

    // 2.0.3.8
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2038,
                                                                           "Simplerinvoicing Invoice 2.0.3.8",
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI2038)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2038,
                                                                           "Simplerinvoicing Credit Note 2.0.3.8",
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI2038)));

    // 2.0.3.9
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_V2039,
                                                                           "Simplerinvoicing Invoice 2.0.3.9",
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_SI2038)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_CREDIT_NOTE_V2039,
                                                                           "Simplerinvoicing Credit Note 2.0.3.9",
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_SI2038)));

    // 2.0 G-Account 1.0
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V10,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.xslt",
                                                                                                               _getCL ()))));

    // 2.0 G-Account 1.0.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V101,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.1",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.1.xslt",
                                                                                                               _getCL ()))));

    // 2.0 G-Account 1.0.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V102,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.2",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.2.xslt",
                                                                                                               _getCL ()))));

    // 2.0 G-Account 1.0.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V103,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.3",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.3.xslt",
                                                                                                               _getCL ()))));

    // 2.0 G-Account 1.0.4
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V104,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.4",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.4.xslt",
                                                                                                               _getCL ()))));

    // 2.0 G-Account 1.0.5
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V105,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.5",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.5.xslt",
                                                                                                               _getCL ()))));

    // 2.0 G-Account 1.0.6
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V106,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.6",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.6.xslt",
                                                                                                               _getCL ()))));

    // 2.0 G-Account 1.0.7
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V107,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.7",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.7.xslt",
                                                                                                               _getCL ()))));

    // 2.0 G-Account 1.0.8
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V108,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.8",
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.8.xslt",
                                                                                                               _getCL ()))));

    // 2.0 G-Account 1.0.9
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_INVOICE_20_GACCOUNT_V109,
                                                                           "Simplerinvoicing 2.0 G-Account extension 1.0.9",
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (new ClassPathResource (PATH_SI +
                                                                                                               "si-ubl-2.0-ext-gaccount-1.0.9.xslt",
                                                                                                               _getCL ()))));

    // NLCIUS 1.0.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V103,
                                                                           "NLCIUS-CII 1.0.3",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           _createXSLT (new ClassPathResource (PATH_NL_CIUS +
                                                                                                               "nlcius-cii-1.0.3.xslt",
                                                                                                               _getCL ()))));

    // NLCIUS 1.0.3.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1031,
                                                                           "NLCIUS-CII 1.0.3.1",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           _createXSLT (new ClassPathResource (PATH_NL_CIUS +
                                                                                                               "nlcius-cii-1.0.3.1.xslt",
                                                                                                               _getCL ()))));

    // NLCIUS 1.0.3.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1032,
                                                                           "NLCIUS-CII 1.0.3.2",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           _createXSLT (new ClassPathResource (PATH_NL_CIUS +
                                                                                                               "nlcius-cii-1.0.3.2.xslt",
                                                                                                               _getCL ()))));

    // NLCIUS 1.0.3.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1033,
                                                                           "NLCIUS-CII 1.0.3.3",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           _createXSLT (new ClassPathResource (PATH_NL_CIUS +
                                                                                                               "nlcius-cii-1.0.3.3.xslt",
                                                                                                               _getCL ()))));

    // NLCIUS 1.0.3.4
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1034,
                                                                           "NLCIUS-CII 1.0.3.4",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           _createXSLT (new ClassPathResource (PATH_NL_CIUS +
                                                                                                               "nlcius-cii-1.0.3.4.xslt",
                                                                                                               _getCL ()))));

    // NLCIUS 1.0.3.5
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1035,
                                                                           "NLCIUS-CII 1.0.3.5",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           _createXSLT (new ClassPathResource (PATH_NL_CIUS +
                                                                                                               "nlcius-cii-1.0.3.5.xslt",
                                                                                                               _getCL ()))));

    // NLCIUS 1.0.3.6
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1036,
                                                                           "NLCIUS-CII 1.0.3.6",
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           _createXSLT (new ClassPathResource (PATH_NL_CIUS +
                                                                                                               "nlcius-cii-1.0.3.6.xslt",
                                                                                                               _getCL ()))));

    // NLCIUS 1.0.3.7
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1037,
                                                                           "NLCIUS-CII 1.0.3.7",
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           _createXSLT (new ClassPathResource (PATH_NL_CIUS +
                                                                                                               "nlcius-cii-1.0.3.7.xslt",
                                                                                                               _getCL ()))));

    // NLCIUS 1.0.3.8
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SI_NLCIUS_CII_V1038,
                                                                           "NLCIUS-CII 1.0.3.8",
                                                                           _createStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                           _createXSLT (new ClassPathResource (PATH_NL_CIUS +
                                                                                                               "nlcius-cii-1.0.3.8.xslt",
                                                                                                               _getCL ()))));
  }
}
