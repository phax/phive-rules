/*
 * Copyright (C) 2017-2024 Philip Helger (www.helger.com)
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

import com.helger.cii.d16b.CCIID16B;
import com.helger.cii.d16b.CIID16BNamespaceContext;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
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
 * CEN/TC 434 - EN 16931 validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class EN16931Validation
{
  private static final String GROUP_ID = "eu.cen.en16931";

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
  private static final String VERSION_136 = "1.3.6";
  // Special fork
  // https://github.com/phax/eInvoicing-EN16931/releases/tag/validation-1.3.6a
  private static final String VERSION_136A = "1.3.6.a";
  private static final String VERSION_137 = "1.3.7";
  private static final String VERSION_138 = "1.3.8";
  private static final String VERSION_139 = "1.3.9";
  private static final String VERSION_1310 = "1.3.10";
  private static final String VERSION_1311 = "1.3.11";
  private static final String VERSION_1312 = "1.3.12";

  // CII
  @Deprecated
  public static final VESID VID_CII_100 = new VESID (GROUP_ID, "cii", VERSION_100);
  @Deprecated
  public static final VESID VID_CII_110 = new VESID (GROUP_ID, "cii", VERSION_110);
  @Deprecated
  public static final VESID VID_CII_120 = new VESID (GROUP_ID, "cii", VERSION_120);
  @Deprecated
  public static final VESID VID_CII_121 = new VESID (GROUP_ID, "cii", VERSION_121);
  @Deprecated
  public static final VESID VID_CII_123 = new VESID (GROUP_ID, "cii", VERSION_123);
  @Deprecated
  public static final VESID VID_CII_130 = new VESID (GROUP_ID, "cii", VERSION_130);
  @Deprecated
  public static final VESID VID_CII_131 = new VESID (GROUP_ID, "cii", VERSION_131);
  @Deprecated
  public static final VESID VID_CII_132 = new VESID (GROUP_ID, "cii", VERSION_132);
  @Deprecated
  public static final VESID VID_CII_133 = new VESID (GROUP_ID, "cii", VERSION_133);
  @Deprecated
  public static final VESID VID_CII_134 = new VESID (GROUP_ID, "cii", VERSION_134);
  @Deprecated
  public static final VESID VID_CII_135 = new VESID (GROUP_ID, "cii", VERSION_135);
  @Deprecated
  public static final VESID VID_CII_136 = new VESID (GROUP_ID, "cii", VERSION_136);
  @Deprecated
  public static final VESID VID_CII_136A = new VESID (GROUP_ID, "cii", VERSION_136A);
  @Deprecated
  public static final VESID VID_CII_137 = new VESID (GROUP_ID, "cii", VERSION_137);
  @Deprecated
  public static final VESID VID_CII_138 = new VESID (GROUP_ID, "cii", VERSION_138);
  @Deprecated
  public static final VESID VID_CII_139 = new VESID (GROUP_ID, "cii", VERSION_139);
  @Deprecated
  public static final VESID VID_CII_1310 = new VESID (GROUP_ID, "cii", VERSION_1310);
  public static final VESID VID_CII_1311 = new VESID (GROUP_ID, "cii", VERSION_1311);
  public static final VESID VID_CII_1312 = new VESID (GROUP_ID, "cii", VERSION_1312);

  // UBL
  @Deprecated
  public static final VESID VID_UBL_INVOICE_100 = new VESID (GROUP_ID, "ubl", VERSION_100);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_110 = new VESID (GROUP_ID, "ubl", VERSION_110);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_120 = new VESID (GROUP_ID, "ubl", VERSION_120);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_121 = new VESID (GROUP_ID, "ubl", VERSION_121);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_123 = new VESID (GROUP_ID, "ubl", VERSION_123);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_130 = new VESID (GROUP_ID, "ubl", VERSION_130);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_131 = new VESID (GROUP_ID, "ubl", VERSION_131);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_132 = new VESID (GROUP_ID, "ubl", VERSION_132);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_133 = new VESID (GROUP_ID, "ubl", VERSION_133);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_134 = new VESID (GROUP_ID, "ubl", VERSION_134);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_135 = new VESID (GROUP_ID, "ubl", VERSION_135);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_136 = new VESID (GROUP_ID, "ubl", VERSION_136);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_136A = new VESID (GROUP_ID, "ubl", VERSION_136A);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_137 = new VESID (GROUP_ID, "ubl", VERSION_137);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_138 = new VESID (GROUP_ID, "ubl", VERSION_138);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_139 = new VESID (GROUP_ID, "ubl", VERSION_139);
  @Deprecated
  public static final VESID VID_UBL_INVOICE_1310 = new VESID (GROUP_ID, "ubl", VERSION_1310);
  public static final VESID VID_UBL_INVOICE_1311 = new VESID (GROUP_ID, "ubl", VERSION_1311);
  public static final VESID VID_UBL_INVOICE_1312 = new VESID (GROUP_ID, "ubl", VERSION_1312);

  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_100 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_100);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_110 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_110);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_120 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_120);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_121 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_121);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_123 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_123);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_130 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_130);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_131 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_131);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_132 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_132);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_133 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_133);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_134 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_134);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_135 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_135);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_136 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_136);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_136A = new VESID (GROUP_ID, "ubl-creditnote", VERSION_136A);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_137 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_137);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_138 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_138);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_139 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_139);
  @Deprecated
  public static final VESID VID_UBL_CREDIT_NOTE_1310 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_1310);
  public static final VESID VID_UBL_CREDIT_NOTE_1311 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_1311);
  public static final VESID VID_UBL_CREDIT_NOTE_1312 = new VESID (GROUP_ID, "ubl-creditnote", VERSION_1312);

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return EN16931Validation.class.getClassLoader ();
  }

  private static final String PREFIX = "/external/schematron/";

  // CII
  @Deprecated
  public static final IReadableResource INVOICE_CII_100_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.0.0/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_110_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.1.0/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_120_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.2.0/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_121_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.2.1/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_123_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.2.3/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_130_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.0/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_131_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.1/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_132_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.2/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_133_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.3/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_134_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.4/cii/xslt/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_135_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.5/cii/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_136_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.6/cii/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  // Specific bugfix version for XRechnung 2.1.1 only
  @Deprecated
  public static final IReadableResource INVOICE_CII_136A_XSLT = new ClassPathResource (PREFIX +
                                                                                       "1.3.6a/cii/EN16931-CII-validation.xslt",
                                                                                       _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_137_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.7/cii/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_138_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.8/cii/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_139_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.9/cii/EN16931-CII-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_CII_1310_XSLT = new ClassPathResource (PREFIX +
                                                                                       "1.3.10/cii/EN16931-CII-validation.xslt",
                                                                                       _getCL ());
  public static final IReadableResource INVOICE_CII_1311_XSLT = new ClassPathResource (PREFIX +
                                                                                       "1.3.11/cii/EN16931-CII-validation.xslt",
                                                                                       _getCL ());
  public static final IReadableResource INVOICE_CII_1312_XSLT = new ClassPathResource (PREFIX +
                                                                                       "1.3.12/cii/EN16931-CII-validation.xslt",
                                                                                       _getCL ());

  // UBL
  @Deprecated
  public static final IReadableResource INVOICE_UBL_100_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.0.0/ubl/xslt/EN16931-UBL-model.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_110_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.1.0/ubl/xslt/EN16931-UBL-model.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_120_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.2.0/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_121_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.2.1/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_123_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.2.3/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_130_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.0/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_131_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.1/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_132_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.2/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_133_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.3/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_134_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.4/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_135_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.5/ubl/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_136_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.6/ubl/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  // Specific bugfix version for XRechnung 2.1.1 only
  @Deprecated
  public static final IReadableResource INVOICE_UBL_136A_XSLT = new ClassPathResource (PREFIX +
                                                                                       "1.3.6a/ubl/EN16931-UBL-validation.xslt",
                                                                                       _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_137_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.7/ubl/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_138_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.8/ubl/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_139_XSLT = new ClassPathResource (PREFIX +
                                                                                      "1.3.9/ubl/EN16931-UBL-validation.xslt",
                                                                                      _getCL ());
  @Deprecated
  public static final IReadableResource INVOICE_UBL_1310_XSLT = new ClassPathResource (PREFIX +
                                                                                       "1.3.10/ubl/EN16931-UBL-validation.xslt",
                                                                                       _getCL ());
  public static final IReadableResource INVOICE_UBL_1311_XSLT = new ClassPathResource (PREFIX +
                                                                                       "1.3.11/ubl/EN16931-UBL-validation.xslt",
                                                                                       _getCL ());
  public static final IReadableResource INVOICE_UBL_1312_XSLT = new ClassPathResource (PREFIX +
                                                                                       "1.3.12/ubl/EN16931-UBL-validation.xslt",
                                                                                       _getCL ());

  private EN16931Validation ()
  {}

  @Nonnull
  private static IValidationExecutorSetStatus _createStatus (final boolean bIsDeprecated)
  {
    return ValidationExecutorSetStatus.createDeprecatedNow (bIsDeprecated);
  }

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
    {
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_100,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_100.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_100_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_110,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_110.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_110_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_120,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_120.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_120_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_121,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_121.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_121_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_123,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_123.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_123_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_130,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_130.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_130_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_131,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_131.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_131_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_132,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_132.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_132_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_133,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_133.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_133_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_134,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_134.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_134_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_135,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_135.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_135_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_136,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_136.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_136_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_136A,
                                                                             "EN 16931 CII " +
                                                                                           VID_CII_136A.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_136A_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_137,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_137.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_137_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_138,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_138.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_138_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_139,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_139.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_139_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_1310,
                                                                             "EN 16931 CII " +
                                                                                           VID_CII_1310.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_1310_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_1311,
                                                                             "EN 16931 CII " +
                                                                                           VID_CII_1311.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_1311_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_1312,
                                                                             "EN 16931 CII " +
                                                                                           VID_CII_1312.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_CII_1312_XSLT,
                                                                                                                      CIID16BNamespaceContext.getInstance ())));
    }

    // UBL
    {
      // 1.0.0
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_100,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_100.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_100_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_100,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_100.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_110_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.1.0
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_110,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_110.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_110_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_110,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_110.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_110_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.2.0
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_120,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_120.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_120_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_120,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_120.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_120_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.2.1
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_121,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_121.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_121_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_121,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_121.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_121_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.2.3
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_123,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_123.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_123_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_123,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_123.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_123_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.0
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_130,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_130.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_130_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_130,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_130.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_130_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.1
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_131,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_131.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_131_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_131,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_131.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_131_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.2
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_132,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_132.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_132_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_132,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_132.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_132_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.3
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_133,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_133.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_133_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_133,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_133.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_133_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.4
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_134,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_134.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_134_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_134,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_134.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_134_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.5
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_135,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_135.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_135_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_135,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_135.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_135_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.6
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_136,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_136.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_136_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_136,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_136.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_136_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.6a
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_136A,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                   VID_UBL_INVOICE_136A.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_136A_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_136A,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                       VID_UBL_CREDIT_NOTE_136A.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_136A_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.7
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_137,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_137.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_137_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_137,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_137.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_137_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.8
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_138,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_138.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_138_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_138,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_138.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_138_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.9
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_139,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_139.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_139_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_139,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_139.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_139_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.10
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_1310,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                   VID_UBL_INVOICE_1310.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_1310_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_1310,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                       VID_UBL_CREDIT_NOTE_1310.getVersionString (),
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_1310_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.11
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_1311,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                   VID_UBL_INVOICE_1311.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_1311_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_1311,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                       VID_UBL_CREDIT_NOTE_1311.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_1311_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));

      // 1.3.12
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_1312,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                   VID_UBL_INVOICE_1312.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_1312_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_1312,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                       VID_UBL_CREDIT_NOTE_1312.getVersionString (),
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_UBL_1312_XSLT,
                                                                                                                      UBL21NamespaceContext.getInstance ())));
    }
  }
}
