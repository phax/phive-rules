/**
 * Copyright (C) 2019-2020 Philip Helger (www.helger.com)
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
package com.helger.bdve.xrechnung;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.bdve.api.executorset.IValidationExecutorSet;
import com.helger.bdve.api.executorset.IValidationExecutorSetRegistry;
import com.helger.bdve.api.executorset.VESID;
import com.helger.bdve.api.executorset.ValidationExecutorSet;
import com.helger.bdve.en16931.EN16931Validation;
import com.helger.bdve.engine.schematron.ValidationExecutorSchematron;
import com.helger.bdve.engine.source.IValidationSourceXML;
import com.helger.bdve.engine.xsd.ValidationExecutorXSD;
import com.helger.cii.d16b.CIID16BNamespaceContext;
import com.helger.cii.d16b.ECIID16BDocumentType;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.ubl21.EUBL21DocumentType;
import com.helger.ubl21.UBL21NamespaceContext;

/**
 * Generic XRechnung validation configuration. It is based on the EN16931
 * validation artefacts.
 *
 * @author Philip Helger
 */
@Immutable
public final class XRechnungValidation
{
  public static final String GROUP_ID = "de.xrechnung";

  // Valid from 1.7.20219- 31.12.2019
  @Deprecated
  public static final VESID VID_XRECHNUNG_CII_120 = new VESID (GROUP_ID, "cii", "1.2.0");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_120 = new VESID (GROUP_ID, "ubl-creditnote", "1.2.0");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_120 = new VESID (GROUP_ID, "ubl-invoice", "1.2.0");

  // Valid from 1.1.2020 - 30.6.2020
  @Deprecated
  public static final VESID VID_XRECHNUNG_CII_121 = new VESID (GROUP_ID, "cii", "1.2.1");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_121 = new VESID (GROUP_ID, "ubl-creditnote", "1.2.1");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_121 = new VESID (GROUP_ID, "ubl-invoice", "1.2.1");

  // Valid from 1.7.2020 - 31.12.2020
  public static final VESID VID_XRECHNUNG_CII_122 = new VESID (GROUP_ID, "cii", "1.2.2");
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_122 = new VESID (GROUP_ID, "ubl-creditnote", "1.2.2");
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_122 = new VESID (GROUP_ID, "ubl-invoice", "1.2.2");

  // Valid from 01.01.2021
  public static final VESID VID_XRECHNUNG_CII_200 = new VESID (GROUP_ID, "cii", "2.0.0");
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_200 = new VESID (GROUP_ID, "ubl-creditnote", "2.0.0");
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_200 = new VESID (GROUP_ID, "ubl-invoice", "2.0.0");

  private XRechnungValidation ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return XRechnungValidation.class.getClassLoader ();
  }

  /**
   * Register all standard XRechnung validation execution sets to the provided
   * registry. Make sure to register the EN16931 artefacts before you register
   * this one.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  @SuppressWarnings ("deprecation")
  public static void initXRechnung (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bNotDeprecated = false;
    final boolean bDeprecated = true;

    // Extending third-party artefacts
    final IValidationExecutorSet <IValidationSourceXML> aVESCII110 = aRegistry.getOfID (EN16931Validation.VID_CII_110);
    final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote110 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_110);
    final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice110 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_110);
    if (aVESCII110 == null || aVESUBLCreditNote110 == null || aVESUBLInvoice110 == null)
      throw new IllegalStateException ("Standard EN16931 artefacts 1.1.0 must be registered before XRechnung artefacts!");

    final IValidationExecutorSet <IValidationSourceXML> aVESCII121 = aRegistry.getOfID (EN16931Validation.VID_CII_121);
    final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote121 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_121);
    final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice121 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_121);
    if (aVESCII121 == null || aVESUBLCreditNote121 == null || aVESUBLInvoice121 == null)
      throw new IllegalStateException ("Standard EN16931 artefacts 1.2.1 must be registered before XRechnung artefacts!");

    final IValidationExecutorSet <IValidationSourceXML> aVESCII130 = aRegistry.getOfID (EN16931Validation.VID_CII_130);
    final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote130 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_130);
    final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice130 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_130);
    if (aVESCII130 == null || aVESUBLCreditNote130 == null || aVESUBLInvoice130 == null)
      throw new IllegalStateException ("Standard EN16931 artefacts 1.3.0 must be registered before XRechnung artefacts!");

    // Just new Schematrons on top
    // v1.2.0 (based on 1.1.0)
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESCII110,
                                                                                  VID_XRECHNUNG_CII_120,
                                                                                  "XRechnung CII " + VID_XRECHNUNG_CII_120.getVersion (),
                                                                                  bDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (new ClassPathResource ("/schematron/1.2.0/XRechnung-CII-validation.xslt",
                                                                                                                                                  _getCL ()),
                                                                                                                           CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLCreditNote110,
                                                                                  VID_XRECHNUNG_UBL_CREDITNOTE_120,
                                                                                  "XRechnung UBL CrediteNote " +
                                                                                                                    VID_XRECHNUNG_UBL_CREDITNOTE_120.getVersion (),
                                                                                  bDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (new ClassPathResource ("/schematron/1.2.0/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                                  _getCL ()),
                                                                                                                           UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLInvoice110,
                                                                                  VID_XRECHNUNG_UBL_INVOICE_120,
                                                                                  "XRechnung UBL Invoice " +
                                                                                                                 VID_XRECHNUNG_UBL_INVOICE_120.getVersion (),
                                                                                  bDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (new ClassPathResource ("/schematron/1.2.0/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                                  _getCL ()),
                                                                                                                           UBL21NamespaceContext.getInstance ())));

    // v1.2.1 (based on 1.2.1)
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESCII121,
                                                                                  VID_XRECHNUNG_CII_121,
                                                                                  "XRechnung CII " + VID_XRECHNUNG_CII_121.getVersion (),
                                                                                  bDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (new ClassPathResource ("/schematron/1.2.1/XRechnung-CII-validation.xslt",
                                                                                                                                                  _getCL ()),
                                                                                                                           CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLCreditNote121,
                                                                                  VID_XRECHNUNG_UBL_CREDITNOTE_121,
                                                                                  "XRechnung UBL CrediteNote " +
                                                                                                                    VID_XRECHNUNG_UBL_CREDITNOTE_121.getVersion (),
                                                                                  bDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (new ClassPathResource ("/schematron/1.2.1/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                                  _getCL ()),
                                                                                                                           UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLInvoice121,
                                                                                  VID_XRECHNUNG_UBL_INVOICE_121,
                                                                                  "XRechnung UBL Invoice " +
                                                                                                                 VID_XRECHNUNG_UBL_INVOICE_121.getVersion (),
                                                                                  bDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (new ClassPathResource ("/schematron/1.2.1/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                                  _getCL ()),
                                                                                                                           UBL21NamespaceContext.getInstance ())));

    // v1.2.2 (based on 1.3.0)
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESCII130,
                                                                                  VID_XRECHNUNG_CII_122,
                                                                                  "XRechnung CII " + VID_XRECHNUNG_CII_122.getVersion (),
                                                                                  bNotDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (new ClassPathResource ("/schematron/1.2.2/XRechnung-CII-validation.xslt",
                                                                                                                                                  _getCL ()),
                                                                                                                           CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLCreditNote130,
                                                                                  VID_XRECHNUNG_UBL_CREDITNOTE_122,
                                                                                  "XRechnung UBL CrediteNote " +
                                                                                                                    VID_XRECHNUNG_UBL_CREDITNOTE_122.getVersion (),
                                                                                  bNotDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (new ClassPathResource ("/schematron/1.2.2/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                                  _getCL ()),
                                                                                                                           UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLInvoice130,
                                                                                  VID_XRECHNUNG_UBL_INVOICE_122,
                                                                                  "XRechnung UBL Invoice " +
                                                                                                                 VID_XRECHNUNG_UBL_INVOICE_122.getVersion (),
                                                                                  bNotDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (new ClassPathResource ("/schematron/1.2.2/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                                  _getCL ()),
                                                                                                                           UBL21NamespaceContext.getInstance ())));

    // v2.0.0 (based on 1.4.0)
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_200,
                                                                           "XRechnung CII " + VID_XRECHNUNG_CII_200.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_CII_132_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ()),
                                                                           ValidationExecutorSchematron.createXSLT (new ClassPathResource ("/schematron/2.0.0/XRechnung-CII-validation.xslt",
                                                                                                                                           _getCL ()),
                                                                                                                    CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_200,
                                                                           "XRechnung UBL CrediteNote " +
                                                                                                             VID_XRECHNUNG_UBL_CREDITNOTE_200.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_132_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ()),
                                                                           ValidationExecutorSchematron.createXSLT (new ClassPathResource ("/schematron/2.0.0/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                           _getCL ()),
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_200,
                                                                           "XRechnung UBL Invoice " +
                                                                                                          VID_XRECHNUNG_UBL_INVOICE_200.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_132_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ()),
                                                                           ValidationExecutorSchematron.createXSLT (new ClassPathResource ("/schematron/2.0.0/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                           _getCL ()),
                                                                                                                    UBL21NamespaceContext.getInstance ())));
  }
}
