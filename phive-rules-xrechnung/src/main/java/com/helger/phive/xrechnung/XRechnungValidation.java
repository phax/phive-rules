/*
 * Copyright (C) 2019-2024 Philip Helger (www.helger.com)
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
package com.helger.phive.xrechnung;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.cii.d16b.CCIID16B;
import com.helger.cii.d16b.CIID16BNamespaceContext;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.ICommonsMap;
import com.helger.commons.error.level.EErrorLevel;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.diver.api.version.VESID;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatus;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;
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
  @Deprecated
  public static final VESID VID_XRECHNUNG_CII_122 = new VESID (GROUP_ID, "cii", "1.2.2");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_122 = new VESID (GROUP_ID, "ubl-creditnote", "1.2.2");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_122 = new VESID (GROUP_ID, "ubl-invoice", "1.2.2");

  // Valid from 01.01.2021 - 30.06.2021
  @Deprecated
  public static final VESID VID_XRECHNUNG_CII_200 = new VESID (GROUP_ID, "cii", "2.0.0");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_200 = new VESID (GROUP_ID, "ubl-creditnote", "2.0.0");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_200 = new VESID (GROUP_ID, "ubl-invoice", "2.0.0");

  // Valid from 01.07.2021 - 31.01.2022
  @Deprecated
  public static final VESID VID_XRECHNUNG_CII_201 = new VESID (GROUP_ID, "cii", "2.0.1");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_201 = new VESID (GROUP_ID, "ubl-creditnote", "2.0.1");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_201 = new VESID (GROUP_ID, "ubl-invoice", "2.0.1");

  // Valid from 01.02.2022 - 31.07.2022
  @Deprecated
  public static final VESID VID_XRECHNUNG_CII_211 = new VESID (GROUP_ID, "cii", "2.1.1");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_211 = new VESID (GROUP_ID, "ubl-creditnote", "2.1.1");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_211 = new VESID (GROUP_ID, "ubl-invoice", "2.1.1");

  // Valid from 01.08.2022 - 31.07.2023
  @Deprecated
  public static final VESID VID_XRECHNUNG_CII_220 = new VESID (GROUP_ID, "cii", "2.2.0");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_220 = new VESID (GROUP_ID, "ubl-creditnote", "2.2.0");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_220 = new VESID (GROUP_ID, "ubl-invoice", "2.2.0");

  // Valid from 01.08.2023 - 31.01.2024
  @Deprecated
  public static final VESID VID_XRECHNUNG_CII_231 = new VESID (GROUP_ID, "cii", "2.3.1");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_231 = new VESID (GROUP_ID, "ubl-creditnote", "2.3.1");
  @Deprecated
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_231 = new VESID (GROUP_ID, "ubl-invoice", "2.3.1");

  // Valid from 01.02.2024
  public static final VESID VID_XRECHNUNG_CII_300 = new VESID (GROUP_ID, "cii", "3.0.0");
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_300 = new VESID (GROUP_ID, "ubl-creditnote", "3.0.0");
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_300 = new VESID (GROUP_ID, "ubl-invoice", "3.0.0");

  // Valid from 01.02.2024
  public static final VESID VID_XRECHNUNG_CII_301 = new VESID (GROUP_ID, "cii", "3.0.1");
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_301 = new VESID (GROUP_ID, "ubl-creditnote", "3.0.1");
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_301 = new VESID (GROUP_ID, "ubl-invoice", "3.0.1");

  // Valid from 01.02.2024
  public static final VESID VID_XRECHNUNG_CII_302 = new VESID (GROUP_ID, "cii", "3.0.2");
  public static final VESID VID_XRECHNUNG_UBL_CREDITNOTE_302 = new VESID (GROUP_ID, "ubl-creditnote", "3.0.2");
  public static final VESID VID_XRECHNUNG_UBL_INVOICE_302 = new VESID (GROUP_ID, "ubl-invoice", "3.0.2");

  private XRechnungValidation ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return XRechnungValidation.class.getClassLoader ();
  }

  @Nonnull
  private static IValidationExecutorSetStatus _createStatus (final boolean bIsDeprecated)
  {
    return ValidationExecutorSetStatus.createDeprecatedNow (bIsDeprecated);
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

    final String sPrefix = "/external/schematron/";

    // Just new Schematrons on top
    // v1.2.0 (based on rule release 1.1.0)
    {
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESCII110,
                                                                                    VID_XRECHNUNG_CII_120,
                                                                                    "XRechnung CII " +
                                                                                                           VID_XRECHNUNG_CII_120.getVersionString (),
                                                                                    _createStatus (bDeprecated),
                                                                                    ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                                    "1.2.0/XRechnung-CII-validation.xslt",
                                                                                                                                                    _getCL ()),
                                                                                                                             CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLCreditNote110,
                                                                                    VID_XRECHNUNG_UBL_CREDITNOTE_120,
                                                                                    "XRechnung UBL Credit Note " +
                                                                                                                      VID_XRECHNUNG_UBL_CREDITNOTE_120.getVersionString (),
                                                                                    _createStatus (bDeprecated),
                                                                                    ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                                    "1.2.0/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                                    _getCL ()),
                                                                                                                             UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLInvoice110,
                                                                                    VID_XRECHNUNG_UBL_INVOICE_120,
                                                                                    "XRechnung UBL Invoice " +
                                                                                                                   VID_XRECHNUNG_UBL_INVOICE_120.getVersionString (),
                                                                                    _createStatus (bDeprecated),
                                                                                    ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                                    "1.2.0/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                                    _getCL ()),
                                                                                                                             UBL21NamespaceContext.getInstance ())));
    }

    // v1.2.1 (based on rule release 1.2.1)
    {
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESCII121,
                                                                                    VID_XRECHNUNG_CII_121,
                                                                                    "XRechnung CII " +
                                                                                                           VID_XRECHNUNG_CII_121.getVersionString (),
                                                                                    _createStatus (bDeprecated),
                                                                                    ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                                    "1.2.1/XRechnung-CII-validation.xslt",
                                                                                                                                                    _getCL ()),
                                                                                                                             CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLCreditNote121,
                                                                                    VID_XRECHNUNG_UBL_CREDITNOTE_121,
                                                                                    "XRechnung UBL Credit Note " +
                                                                                                                      VID_XRECHNUNG_UBL_CREDITNOTE_121.getVersionString (),
                                                                                    _createStatus (bDeprecated),
                                                                                    ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                                    "1.2.1/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                                    _getCL ()),
                                                                                                                             UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLInvoice121,
                                                                                    VID_XRECHNUNG_UBL_INVOICE_121,
                                                                                    "XRechnung UBL Invoice " +
                                                                                                                   VID_XRECHNUNG_UBL_INVOICE_121.getVersionString (),
                                                                                    _createStatus (bDeprecated),
                                                                                    ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                                    "1.2.1/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                                    _getCL ()),
                                                                                                                             UBL21NamespaceContext.getInstance ())));
    }

    // v1.2.2 (based on rule release 1.3.0)
    {
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESCII130,
                                                                                    VID_XRECHNUNG_CII_122,
                                                                                    "XRechnung CII " +
                                                                                                           VID_XRECHNUNG_CII_122.getVersionString (),
                                                                                    _createStatus (bDeprecated),
                                                                                    ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                                    "1.2.2/XRechnung-CII-validation.xslt",
                                                                                                                                                    _getCL ()),
                                                                                                                             CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLCreditNote130,
                                                                                    VID_XRECHNUNG_UBL_CREDITNOTE_122,
                                                                                    "XRechnung UBL Credit Note " +
                                                                                                                      VID_XRECHNUNG_UBL_CREDITNOTE_122.getVersionString (),
                                                                                    _createStatus (bDeprecated),
                                                                                    ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                                    "1.2.2/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                                    _getCL ()),
                                                                                                                             UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLInvoice130,
                                                                                    VID_XRECHNUNG_UBL_INVOICE_122,
                                                                                    "XRechnung UBL Invoice " +
                                                                                                                   VID_XRECHNUNG_UBL_INVOICE_122.getVersionString (),
                                                                                    _createStatus (bDeprecated),
                                                                                    ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                                    "1.2.2/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                                    _getCL ()),
                                                                                                                             UBL21NamespaceContext.getInstance ())));
    }

    // v2.0.0 (based on rule release 1.4.0)
    {
      final ICommonsMap <String, EErrorLevel> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-01", EErrorLevel.INFO);
      aCustomErrorLevels.put ("BR-CL-23", EErrorLevel.WARN);
      aCustomErrorLevels.put ("BR-CL-21", EErrorLevel.WARN);
      aCustomErrorLevels.put ("BR-CL-24", EErrorLevel.INFO);
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_200,
                                                                             "XRechnung CII " +
                                                                                                    VID_XRECHNUNG_CII_200.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_CII_132_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.0.0/XRechnung-CII-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_200,
                                                                             "XRechnung UBL Credit Note " +
                                                                                                               VID_XRECHNUNG_UBL_CREDITNOTE_200.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_132_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.0.0/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_200,
                                                                             "XRechnung UBL Invoice " +
                                                                                                            VID_XRECHNUNG_UBL_INVOICE_200.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_132_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.0.0/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
    }

    // v2.0.1 (based on rule release 1.5.0)
    {
      final ICommonsMap <String, EErrorLevel> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-01", EErrorLevel.INFO);
      aCustomErrorLevels.put ("BR-CL-23", EErrorLevel.WARN);
      aCustomErrorLevels.put ("BR-CL-21", EErrorLevel.WARN);
      aCustomErrorLevels.put ("BR-CL-24", EErrorLevel.INFO);
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_201,
                                                                             "XRechnung CII " +
                                                                                                    VID_XRECHNUNG_CII_201.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_CII_133_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.0.1/XRechnung-CII-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_201,
                                                                             "XRechnung UBL Credit Note " +
                                                                                                               VID_XRECHNUNG_UBL_CREDITNOTE_201.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_133_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.0.1/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_201,
                                                                             "XRechnung UBL Invoice " +
                                                                                                            VID_XRECHNUNG_UBL_INVOICE_201.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_133_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.0.1/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
    }

    // v2.1.1 (based on rule release 1.6.0)
    // Based on the EN16931 rules in this fork:
    // https://github.com/phax/eInvoicing-EN16931/releases/tag/validation-1.3.6a
    {
      final ICommonsMap <String, EErrorLevel> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-01", EErrorLevel.INFO);
      aCustomErrorLevels.put ("BR-CL-23", EErrorLevel.WARN);
      aCustomErrorLevels.put ("BR-CL-21", EErrorLevel.WARN);
      aCustomErrorLevels.put ("BR-CL-24", EErrorLevel.INFO);
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_211,
                                                                             "XRechnung CII " +
                                                                                                    VID_XRECHNUNG_CII_211.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_CII_136A_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.1.1/XRechnung-CII-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_211,
                                                                             "XRechnung UBL Credit Note " +
                                                                                                               VID_XRECHNUNG_UBL_CREDITNOTE_211.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_136A_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.1.1/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_211,
                                                                             "XRechnung UBL Invoice " +
                                                                                                            VID_XRECHNUNG_UBL_INVOICE_211.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_136A_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.1.1/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
    }

    // v2.2.0 (based on rule release 1.7.1)
    // Uses CEN release 1.3.7
    {
      final ICommonsMap <String, EErrorLevel> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-01", EErrorLevel.INFO);
      aCustomErrorLevels.put ("BR-CL-23", EErrorLevel.WARN);
      aCustomErrorLevels.put ("BR-CL-21", EErrorLevel.WARN);
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_220,
                                                                             "XRechnung CII " +
                                                                                                    VID_XRECHNUNG_CII_220.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_CII_137_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.2.0/XRechnung-CII-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_220,
                                                                             "XRechnung UBL Credit Note " +
                                                                                                               VID_XRECHNUNG_UBL_CREDITNOTE_220.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_137_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.2.0/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_220,
                                                                             "XRechnung UBL Invoice " +
                                                                                                            VID_XRECHNUNG_UBL_INVOICE_220.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_137_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.2.0/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
    }

    // v2.3.1 (based on rule release 1.8.1)
    // Uses CEN rules 1.3.9
    {
      final ICommonsMap <String, EErrorLevel> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-23", EErrorLevel.WARN);
      aCustomErrorLevels.put ("BR-CL-21", EErrorLevel.WARN);
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_231,
                                                                             "XRechnung CII " +
                                                                                                    VID_XRECHNUNG_CII_231.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_CII_139_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.3.1/XRechnung-CII-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_231,
                                                                             "XRechnung UBL Credit Note " +
                                                                                                               VID_XRECHNUNG_UBL_CREDITNOTE_231.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_139_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.3.1/XRechnung-UBL-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_231,
                                                                             "XRechnung UBL Invoice " +
                                                                                                            VID_XRECHNUNG_UBL_INVOICE_231.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_139_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "2.3.1/XRechnung-UBL-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
    }

    // v3.0.0 (based on rule release 2.0.0)
    // Uses CEN rules 1.3.10
    {
      final ICommonsMap <String, EErrorLevel> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-23", EErrorLevel.WARN);
      aCustomErrorLevels.put ("BR-CL-21", EErrorLevel.WARN);
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_300,
                                                                             "XRechnung CII " +
                                                                                                    VID_XRECHNUNG_CII_300.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_CII_1310_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "3.0.0/XRechnung-CII-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_300,
                                                                             "XRechnung UBL Credit Note " +
                                                                                                               VID_XRECHNUNG_UBL_CREDITNOTE_300.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_1310_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "3.0.0/XRechnung-UBL-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_300,
                                                                             "XRechnung UBL Invoice " +
                                                                                                            VID_XRECHNUNG_UBL_INVOICE_300.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_1310_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "3.0.0/XRechnung-UBL-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
    }

    // v3.0.1 (based on rule release 2.0.2)
    // Uses CEN rules 1.3.11
    {
      final ICommonsMap <String, EErrorLevel> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-23", EErrorLevel.WARN);
      aCustomErrorLevels.put ("BR-CL-21", EErrorLevel.WARN);
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_301,
                                                                             "XRechnung CII " +
                                                                                                    VID_XRECHNUNG_CII_301.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_CII_1311_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "3.0.1/XRechnung-CII-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_301,
                                                                             "XRechnung UBL Credit Note " +
                                                                                                               VID_XRECHNUNG_UBL_CREDITNOTE_301.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_1311_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "3.0.1/XRechnung-UBL-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_301,
                                                                             "XRechnung UBL Invoice " +
                                                                                                            VID_XRECHNUNG_UBL_INVOICE_301.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_1311_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "3.0.1/XRechnung-UBL-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
    }

    // v3.0.2 (based on rule release 2.1.0)
    // Uses CEN rules 1.3.12
    {
      final ICommonsMap <String, EErrorLevel> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-23", EErrorLevel.WARN);
      aCustomErrorLevels.put ("BR-CL-21", EErrorLevel.WARN);
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_302,
                                                                             "XRechnung CII " +
                                                                                                    VID_XRECHNUNG_CII_302.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_CII_1312_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "3.0.2/XRechnung-CII-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_302,
                                                                             "XRechnung UBL Credit Note " +
                                                                                                               VID_XRECHNUNG_UBL_CREDITNOTE_302.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_1312_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "3.0.2/XRechnung-UBL-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_302,
                                                                             "XRechnung UBL Invoice " +
                                                                                                            VID_XRECHNUNG_UBL_INVOICE_302.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (EN16931Validation.INVOICE_UBL_1312_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())
                                                                                                         .addCustomErrorLevels (aCustomErrorLevels),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sPrefix +
                                                                                                                                             "3.0.2/XRechnung-UBL-validation.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      UBL21NamespaceContext.getInstance ())));
    }
  }
}
