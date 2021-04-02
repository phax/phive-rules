/**
 * Copyright (C) 2017-2021 Philip Helger (www.helger.com)
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
package com.helger.phive.en16931;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.cii.d16b.CIID16BNamespaceContext;
import com.helger.cii.d16b.ECIID16BDocumentType;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.engine.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.engine.schematron.ValidationExecutorSchematron;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.engine.xsd.ValidationExecutorXSD;
import com.helger.ubl21.EUBL21DocumentType;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.xml.XMLSystemProperties;

/**
 * CEN/TC 434 - EN 16931 validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class EN16931Validation
{
  static
  {
    // Required for EDIFACT ISO 20625
    XMLSystemProperties.setXMLMaxOccurIfLarger (9_999_999);
  }

  private static final String VERSION_100 = "1.0.0";
  private static final String VERSION_110 = "1.1.0";
  private static final String VERSION_120 = "1.2.0";
  private static final String VERSION_121 = "1.2.1";
  private static final String VERSION_123 = "1.2.3";
  private static final String VERSION_130 = "1.3.0";
  private static final String VERSION_131 = "1.3.1";
  private static final String VERSION_132 = "1.3.2";
  private static final String VERSION_133 = "1.3.3";
  private static final String VERSION_134 = "1.3.4";
  private static final String VERSION_135 = "1.3.5";

  // CII
  @Deprecated
  public static final VESID VID_CII_100 = new VESID ("eu.cen.en16931", "cii", VERSION_100);
  @Deprecated
  public static final VESID VID_CII_110 = new VESID ("eu.cen.en16931", "cii", VERSION_110);
  @Deprecated
  public static final VESID VID_CII_120 = new VESID ("eu.cen.en16931", "cii", VERSION_120);
  @Deprecated
  public static final VESID VID_CII_121 = new VESID ("eu.cen.en16931", "cii", VERSION_121);
  @Deprecated
  public static final VESID VID_CII_123 = new VESID ("eu.cen.en16931", "cii", VERSION_123);
  @Deprecated
  public static final VESID VID_CII_130 = new VESID ("eu.cen.en16931", "cii", VERSION_130);
  @Deprecated
  public static final VESID VID_CII_131 = new VESID ("eu.cen.en16931", "cii", VERSION_131);
  @Deprecated
  public static final VESID VID_CII_132 = new VESID ("eu.cen.en16931", "cii", VERSION_132);
  @Deprecated
  public static final VESID VID_CII_133 = new VESID ("eu.cen.en16931", "cii", VERSION_133);
  @Deprecated
  public static final VESID VID_CII_134 = new VESID ("eu.cen.en16931", "cii", VERSION_134);
  public static final VESID VID_CII_135 = new VESID ("eu.cen.en16931", "cii", VERSION_135);

  // UBL
  @Deprecated
  public static final VESID VID_UBL_INVOICE_100 = new VESID ("eu.cen.en16931", "ubl", VERSION_100);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_110 = new VESID ("eu.cen.en16931", "ubl", VERSION_110);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_120 = new VESID ("eu.cen.en16931", "ubl", VERSION_120);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_121 = new VESID ("eu.cen.en16931", "ubl", VERSION_121);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_123 = new VESID ("eu.cen.en16931", "ubl", VERSION_123);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_130 = new VESID ("eu.cen.en16931", "ubl", VERSION_130);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_131 = new VESID ("eu.cen.en16931", "ubl", VERSION_131);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_132 = new VESID ("eu.cen.en16931", "ubl", VERSION_132);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_133 = new VESID ("eu.cen.en16931", "ubl", VERSION_133);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_134 = new VESID ("eu.cen.en16931", "ubl", VERSION_134);
  public static final VESID VID_UBL_INVOICE_135 = new VESID ("eu.cen.en16931", "ubl", VERSION_135);

  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_100 = new VESID ("eu.cen.en16931", "ubl-creditnote", VERSION_100);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_110 = new VESID ("eu.cen.en16931", "ubl-creditnote", VERSION_110);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_120 = new VESID ("eu.cen.en16931", "ubl-creditnote", VERSION_120);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_121 = new VESID ("eu.cen.en16931", "ubl-creditnote", VERSION_121);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_123 = new VESID ("eu.cen.en16931", "ubl-creditnote", VERSION_123);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_130 = new VESID ("eu.cen.en16931", "ubl-creditnote", VERSION_130);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_131 = new VESID ("eu.cen.en16931", "ubl-creditnote", VERSION_131);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_132 = new VESID ("eu.cen.en16931", "ubl-creditnote", VERSION_132);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_133 = new VESID ("eu.cen.en16931", "ubl-creditnote", VERSION_133);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_134 = new VESID ("eu.cen.en16931", "ubl-creditnote", VERSION_134);
  public static final VESID VID_UBL_CREDIT_NOTE_135 = new VESID ("eu.cen.en16931", "ubl-creditnote", VERSION_135);

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return EN16931Validation.class.getClassLoader ();
  }

  // CII
  @Deprecated
  public static final IReadableResource INVOICE_CII_100_XSLT = new ClassPathResource ("/schematron/1.0.0/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_110_XSLT = new ClassPathResource ("/schematron/1.1.0/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_120_XSLT = new ClassPathResource ("/schematron/1.2.0/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_121_XSLT = new ClassPathResource ("/schematron/1.2.1/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_123_XSLT = new ClassPathResource ("/schematron/1.2.3/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_130_XSLT = new ClassPathResource ("/schematron/1.3.0/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_131_XSLT = new ClassPathResource ("/schematron/1.3.1/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_132_XSLT = new ClassPathResource ("/schematron/1.3.2/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_133_XSLT = new ClassPathResource ("/schematron/1.3.3/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_134_XSLT = new ClassPathResource ("/schematron/1.3.4/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  public static final IReadableResource INVOICE_CII_135_XSLT = new ClassPathResource ("/schematron/1.3.5/cii/EN16931-CII-validation.xslt",
                                                                                      _getCL ());

  // UBL
  @Deprecated
  public static final IReadableResource INVOICE_UBL_100_XSLT = new ClassPathResource ("/schematron/1.0.0/ubl/xslt/EN16931-UBL-model.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_110_XSLT = new ClassPathResource ("/schematron/1.1.0/ubl/xslt/EN16931-UBL-model.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_120_XSLT = new ClassPathResource ("/schematron/1.2.0/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_121_XSLT = new ClassPathResource ("/schematron/1.2.1/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_123_XSLT = new ClassPathResource ("/schematron/1.2.3/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_130_XSLT = new ClassPathResource ("/schematron/1.3.0/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_131_XSLT = new ClassPathResource ("/schematron/1.3.1/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_132_XSLT = new ClassPathResource ("/schematron/1.3.2/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_133_XSLT = new ClassPathResource ("/schematron/1.3.3/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_134_XSLT = new ClassPathResource ("/schematron/1.3.4/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  public static final IReadableResource INVOICE_UBL_135_XSLT = new ClassPathResource ("/schematron/1.3.5/ubl/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());

  private EN16931Validation ()
  {}

  /**
   * Register all standard EN 16931 validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initEN16931 (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL21NamespaceContext.getInstance ());
    SchematronNamespaceBeautifier.addMappings (CIID16BNamespaceContext.getInstance ());

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // CII
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_100,
                                                                           "EN 16931 CII " + VID_CII_100.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_CII_100_XSLT,
                                                                                                                    CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_110,
                                                                           "EN 16931 CII " + VID_CII_110.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_CII_110_XSLT,
                                                                                                                    CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_120,
                                                                           "EN 16931 CII " + VID_CII_120.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_CII_120_XSLT,
                                                                                                                    CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_121,
                                                                           "EN 16931 CII " + VID_CII_121.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_CII_121_XSLT,
                                                                                                                    CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_123,
                                                                           "EN 16931 CII " + VID_CII_123.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_CII_123_XSLT,
                                                                                                                    CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_130,
                                                                           "EN 16931 CII " + VID_CII_130.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_CII_130_XSLT,
                                                                                                                    CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_131,
                                                                           "EN 16931 CII " + VID_CII_131.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_CII_131_XSLT,
                                                                                                                    CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_132,
                                                                           "EN 16931 CII " + VID_CII_132.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_CII_132_XSLT,
                                                                                                                    CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_133,
                                                                           "EN 16931 CII " + VID_CII_133.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_CII_133_XSLT,
                                                                                                                    CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_134,
                                                                           "EN 16931 CII " + VID_CII_134.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_CII_134_XSLT,
                                                                                                                    CIID16BNamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_135,
                                                                           "EN 16931 CII " + VID_CII_135.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_CII_135_XSLT,
                                                                                                                    CIID16BNamespaceContext.getInstance ())));

    // UBL
    // 1.0.0
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_100,
                                                                           "EN 16931 UBL Invoice " + VID_UBL_INVOICE_100.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_100_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_100,
                                                                           "EN 16931 UBL CreditNote " +
                                                                                                    VID_UBL_CREDIT_NOTE_100.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_110_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));

    // 1.1.0
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_110,
                                                                           "EN 16931 UBL Invoice " + VID_UBL_INVOICE_110.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_110_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_110,
                                                                           "EN 16931 UBL CreditNote " +
                                                                                                    VID_UBL_CREDIT_NOTE_110.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_110_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));

    // 1.2.0
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_120,
                                                                           "EN 16931 UBL Invoice " + VID_UBL_INVOICE_120.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_120_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_120,
                                                                           "EN 16931 UBL CreditNote " +
                                                                                                    VID_UBL_CREDIT_NOTE_120.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_120_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));

    // 1.2.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_121,
                                                                           "EN 16931 UBL Invoice " + VID_UBL_INVOICE_121.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_121_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_121,
                                                                           "EN 16931 UBL CreditNote " +
                                                                                                    VID_UBL_CREDIT_NOTE_121.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_121_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));

    // 1.2.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_123,
                                                                           "EN 16931 UBL Invoice " + VID_UBL_INVOICE_123.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_123_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_123,
                                                                           "EN 16931 UBL CreditNote " +
                                                                                                    VID_UBL_CREDIT_NOTE_123.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_123_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));

    // 1.3.0
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_130,
                                                                           "EN 16931 UBL Invoice " + VID_UBL_INVOICE_130.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_130_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_130,
                                                                           "EN 16931 UBL CreditNote " +
                                                                                                    VID_UBL_CREDIT_NOTE_130.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_130_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));

    // 1.3.1
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_131,
                                                                           "EN 16931 UBL Invoice " + VID_UBL_INVOICE_131.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_131_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_131,
                                                                           "EN 16931 UBL CreditNote " +
                                                                                                    VID_UBL_CREDIT_NOTE_131.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_131_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));

    // 1.3.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_132,
                                                                           "EN 16931 UBL Invoice " + VID_UBL_INVOICE_132.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_132_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_132,
                                                                           "EN 16931 UBL CreditNote " +
                                                                                                    VID_UBL_CREDIT_NOTE_132.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_132_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));

    // 1.3.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_133,
                                                                           "EN 16931 UBL Invoice " + VID_UBL_INVOICE_133.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_133_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_133,
                                                                           "EN 16931 UBL CreditNote " +
                                                                                                    VID_UBL_CREDIT_NOTE_133.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_133_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));

    // 1.3.4
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_134,
                                                                           "EN 16931 UBL Invoice " + VID_UBL_INVOICE_134.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_134_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_134,
                                                                           "EN 16931 UBL CreditNote " +
                                                                                                    VID_UBL_CREDIT_NOTE_134.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_134_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));

    // 1.3.5
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_135,
                                                                           "EN 16931 UBL Invoice " + VID_UBL_INVOICE_135.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_135_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_135,
                                                                           "EN 16931 UBL CreditNote " +
                                                                                                    VID_UBL_CREDIT_NOTE_135.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           ValidationExecutorSchematron.createXSLT (INVOICE_UBL_135_XSLT,
                                                                                                                    UBL21NamespaceContext.getInstance ())));
  }
}
