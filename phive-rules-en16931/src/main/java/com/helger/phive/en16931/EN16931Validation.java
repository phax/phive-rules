/*
 * Copyright (C) 2017-2025 Philip Helger (www.helger.com)
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
import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesCIIHelper;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;

/**
 * CEN/TC 434 - EN 16931 validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class EN16931Validation
{
  public static final String GROUP_ID = "eu.cen.en16931";

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
  private static final String VERSION_1313 = "1.3.13";

  // CII
  @Deprecated
  public static final DVRCoordinate VID_CII_100 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_100);
  @Deprecated
  public static final DVRCoordinate VID_CII_110 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_110);
  @Deprecated
  public static final DVRCoordinate VID_CII_120 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_120);
  @Deprecated
  public static final DVRCoordinate VID_CII_121 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_121);
  @Deprecated
  public static final DVRCoordinate VID_CII_123 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_123);
  @Deprecated
  public static final DVRCoordinate VID_CII_130 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_130);
  @Deprecated
  public static final DVRCoordinate VID_CII_131 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_131);
  @Deprecated
  public static final DVRCoordinate VID_CII_132 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_132);
  @Deprecated
  public static final DVRCoordinate VID_CII_133 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_133);
  @Deprecated
  public static final DVRCoordinate VID_CII_134 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_134);
  @Deprecated
  public static final DVRCoordinate VID_CII_135 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_135);
  @Deprecated
  public static final DVRCoordinate VID_CII_136 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_136);
  @Deprecated
  public static final DVRCoordinate VID_CII_136A = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_136A);
  @Deprecated
  public static final DVRCoordinate VID_CII_137 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_137);
  @Deprecated
  public static final DVRCoordinate VID_CII_138 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_138);
  @Deprecated
  public static final DVRCoordinate VID_CII_139 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_139);
  @Deprecated
  public static final DVRCoordinate VID_CII_1310 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_1310);
  @Deprecated
  public static final DVRCoordinate VID_CII_1311 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_1311);
  public static final DVRCoordinate VID_CII_1312 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_1312);
  public static final DVRCoordinate VID_CII_1313 = PhiveRulesHelper.createCoordinate (GROUP_ID, "cii", VERSION_1313);

  // UBL
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_100);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_110 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_110);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_120 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_120);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_121 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_121);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_123 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_123);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_130 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_130);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_131 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_131);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_132 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_132);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_133 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_133);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_134 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_134);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_135 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_135);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_136 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_136);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_136A = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "ubl",
                                                                                              VERSION_136A);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_137 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_137);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_138 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_138);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_139 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "ubl",
                                                                                             VERSION_139);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_1310 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "ubl",
                                                                                              VERSION_1310);
  @Deprecated
  public static final DVRCoordinate VID_UBL_INVOICE_1311 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "ubl",
                                                                                              VERSION_1311);
  public static final DVRCoordinate VID_UBL_INVOICE_1312 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "ubl",
                                                                                              VERSION_1312);
  public static final DVRCoordinate VID_UBL_INVOICE_1313 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "ubl",
                                                                                              VERSION_1313);

  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_100);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_110 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_110);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_120 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_120);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_121 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_121);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_123 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_123);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_130 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_130);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_131 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_131);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_132 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_132);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_133 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_133);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_134 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_134);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_135 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_135);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_136 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_136);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_136A = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "ubl-creditnote",
                                                                                                  VERSION_136A);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_137 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_137);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_138 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_138);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_139 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-creditnote",
                                                                                                 VERSION_139);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_1310 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "ubl-creditnote",
                                                                                                  VERSION_1310);
  @Deprecated
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_1311 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "ubl-creditnote",
                                                                                                  VERSION_1311);
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_1312 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "ubl-creditnote",
                                                                                                  VERSION_1312);
  public static final DVRCoordinate VID_UBL_CREDIT_NOTE_1313 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "ubl-creditnote",
                                                                                                  VERSION_1313);

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return EN16931Validation.class.getClassLoader ();
  }

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

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    final String sPrefix = "/external/schematron/";

    // CII
    {
      final IReadableResource INVOICE_CII_100_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.0.0/cii/xslt/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_100,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_100.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_100_XSLT)));

      final IReadableResource INVOICE_CII_110_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.1.0/cii/xslt/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_110,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_110.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_110_XSLT)));

      final IReadableResource INVOICE_CII_120_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.2.0/cii/xslt/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_120,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_120.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_120_XSLT)));

      final IReadableResource INVOICE_CII_121_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.2.1/cii/xslt/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_121,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_121.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_121_XSLT)));

      final IReadableResource INVOICE_CII_123_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.2.3/cii/xslt/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_123,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_123.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_123_XSLT)));

      final IReadableResource INVOICE_CII_130_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.0/cii/xslt/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_130,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_130.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_130_XSLT)));

      final IReadableResource INVOICE_CII_131_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.1/cii/xslt/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_131,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_131.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_131_XSLT)));

      final IReadableResource INVOICE_CII_132_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.2/cii/xslt/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_132,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_132.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_132_XSLT)));

      final IReadableResource INVOICE_CII_133_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.3/cii/xslt/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_133,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_133.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_133_XSLT)));

      final IReadableResource INVOICE_CII_134_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.4/cii/xslt/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_134,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_134.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_134_XSLT)));

      final IReadableResource INVOICE_CII_135_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.5/cii/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_135,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_135.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_135_XSLT)));

      final IReadableResource INVOICE_CII_136_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.6/cii/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_136,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_136.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_136_XSLT)));

      // Specific bugfix version for XRechnung 2.1.1 only
      final IReadableResource INVOICE_CII_136A_XSLT = new ClassPathResource (sPrefix +
                                                                             "1.3.6a/cii/EN16931-CII-validation.xslt",
                                                                             _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_136A,
                                                                             "EN 16931 CII " +
                                                                                           VID_CII_136A.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_136A_XSLT)));

      final IReadableResource INVOICE_CII_137_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.7/cii/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_137,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_137.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_137_XSLT)));

      final IReadableResource INVOICE_CII_138_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.8/cii/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_138,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_138.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_138_XSLT)));

      final IReadableResource INVOICE_CII_139_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.9/cii/EN16931-CII-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_139,
                                                                             "EN 16931 CII " +
                                                                                          VID_CII_139.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_139_XSLT)));

      final IReadableResource INVOICE_CII_1310_XSLT = new ClassPathResource (sPrefix +
                                                                             "1.3.10/cii/EN16931-CII-validation.xslt",
                                                                             _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_1310,
                                                                             "EN 16931 CII " +
                                                                                           VID_CII_1310.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_1310_XSLT)));

      final IReadableResource INVOICE_CII_1311_XSLT = new ClassPathResource (sPrefix +
                                                                             "1.3.11/cii/EN16931-CII-validation.xslt",
                                                                             _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_1311,
                                                                             "EN 16931 CII " +
                                                                                           VID_CII_1311.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_1311_XSLT)));

      final IReadableResource INVOICE_CII_1312_XSLT = new ClassPathResource (sPrefix +
                                                                             "1.3.12/cii/EN16931-CII-validation.xslt",
                                                                             _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_1312,
                                                                             "EN 16931 CII " +
                                                                                           VID_CII_1312.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_1312_XSLT)));

      final IReadableResource INVOICE_CII_1313_XSLT = new ClassPathResource (sPrefix +
                                                                             "1.3.13/cii/EN16931-CII-validation.xslt",
                                                                             _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_1313,
                                                                             "EN 16931 CII " +
                                                                                           VID_CII_1313.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
                                                                             PhiveRulesCIIHelper.createXSLT_CII_D16B (INVOICE_CII_1313_XSLT)));
    }

    // UBL
    {
      // 1.0.0
      final IReadableResource INVOICE_UBL_100_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.0.0/ubl/xslt/EN16931-UBL-model.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_100,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_100.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_100_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_100,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_100.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_100_XSLT)));

      // 1.1.0
      final IReadableResource INVOICE_UBL_110_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.1.0/ubl/xslt/EN16931-UBL-model.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_110,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_110.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_110_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_110,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_110.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_110_XSLT)));

      // 1.2.0
      final IReadableResource INVOICE_UBL_120_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.2.0/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_120,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_120.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_120_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_120,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_120.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_120_XSLT)));

      // 1.2.1
      final IReadableResource INVOICE_UBL_121_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.2.1/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_121,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_121.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_121_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_121,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_121.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_121_XSLT)));

      // 1.2.3
      final IReadableResource INVOICE_UBL_123_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.2.3/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_123,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_123.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_123_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_123,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_123.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_123_XSLT)));

      // 1.3.0
      final IReadableResource INVOICE_UBL_130_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.0/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_130,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_130.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_130_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_130,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_130.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_130_XSLT)));

      // 1.3.1
      final IReadableResource INVOICE_UBL_131_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.1/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_131,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_131.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_131_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_131,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_131.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_131_XSLT)));

      // 1.3.2
      final IReadableResource INVOICE_UBL_132_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.2/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_132,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_132.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_132_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_132,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_132.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_132_XSLT)));

      // 1.3.3
      final IReadableResource INVOICE_UBL_133_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.3/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_133,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_133.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_133_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_133,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_133.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_133_XSLT)));

      // 1.3.4
      final IReadableResource INVOICE_UBL_134_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.4/ubl/xslt/EN16931-UBL-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_134,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_134.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_134_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_134,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_134.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_134_XSLT)));

      // 1.3.5
      final IReadableResource INVOICE_UBL_135_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.5/ubl/EN16931-UBL-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_135,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_135.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_135_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_135,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_135.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_135_XSLT)));

      // 1.3.6
      final IReadableResource INVOICE_UBL_136_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.6/ubl/EN16931-UBL-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_136,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_136.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_136_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_136,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_136.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_136_XSLT)));

      // 1.3.6a
      // Specific bugfix version for XRechnung 2.1.1 only
      final IReadableResource INVOICE_UBL_136A_XSLT = new ClassPathResource (sPrefix +
                                                                             "1.3.6a/ubl/EN16931-UBL-validation.xslt",
                                                                             _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_136A,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                   VID_UBL_INVOICE_136A.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_136A_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_136A,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                       VID_UBL_CREDIT_NOTE_136A.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_136A_XSLT)));

      // 1.3.7
      final IReadableResource INVOICE_UBL_137_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.7/ubl/EN16931-UBL-validation.xslt",
                                                                            _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_137,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_137.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_137_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_137,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_137.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_137_XSLT)));

      // 1.3.8
      final IReadableResource INVOICE_UBL_138_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.8/ubl/EN16931-UBL-validation.xslt",
                                                                            _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_138,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_138.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_138_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_138,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_138.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_138_XSLT)));

      // 1.3.9
      final IReadableResource INVOICE_UBL_139_XSLT = new ClassPathResource (sPrefix +
                                                                            "1.3.9/ubl/EN16931-UBL-validation.xslt",
                                                                            _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_139,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                  VID_UBL_INVOICE_139.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_139_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_139,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                      VID_UBL_CREDIT_NOTE_139.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_139_XSLT)));

      // 1.3.10
      final IReadableResource INVOICE_UBL_1310_XSLT = new ClassPathResource (sPrefix +
                                                                             "1.3.10/ubl/EN16931-UBL-validation.xslt",
                                                                             _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_1310,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                   VID_UBL_INVOICE_1310.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_1310_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_1310,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                       VID_UBL_CREDIT_NOTE_1310.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_1310_XSLT)));

      // 1.3.11
      final IReadableResource INVOICE_UBL_1311_XSLT = new ClassPathResource (sPrefix +
                                                                             "1.3.11/ubl/EN16931-UBL-validation.xslt",
                                                                             _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_1311,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                   VID_UBL_INVOICE_1311.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_1311_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_1311,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                       VID_UBL_CREDIT_NOTE_1311.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_1311_XSLT)));

      // 1.3.12
      final IReadableResource INVOICE_UBL_1312_XSLT = new ClassPathResource (sPrefix +
                                                                             "1.3.12/ubl/EN16931-UBL-validation.xslt",
                                                                             _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_1312,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                   VID_UBL_INVOICE_1312.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_1312_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_1312,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                       VID_UBL_CREDIT_NOTE_1312.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_1312_XSLT)));

      // 1.3.13
      final IReadableResource INVOICE_UBL_1313_XSLT = new ClassPathResource (sPrefix +
                                                                             "1.3.13/ubl/EN16931-UBL-validation.xslt",
                                                                             _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_INVOICE_1313,
                                                                             "EN 16931 UBL Invoice " +
                                                                                                   VID_UBL_INVOICE_1313.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_1313_XSLT)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_CREDIT_NOTE_1313,
                                                                             "EN 16931 UBL Credit Note " +
                                                                                                       VID_UBL_CREDIT_NOTE_1313.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_1313_XSLT)));
    }
  }
}
