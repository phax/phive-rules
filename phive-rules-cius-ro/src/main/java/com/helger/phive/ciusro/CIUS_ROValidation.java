/*
 * Copyright (C) 2020-2025 Philip Helger (www.helger.com)
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

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;

import jakarta.annotation.Nonnull;

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
  public static final DVRCoordinate VID_CIUS_RO_UBL_CREDITNOTE_103 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "ubl-creditnote",
                                                                                                        "1.0.3");
  @Deprecated
  public static final DVRCoordinate VID_CIUS_RO_UBL_INVOICE_103 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "ubl-invoice",
                                                                                                     "1.0.3");

  // Version 1.0.4
  @Deprecated
  public static final DVRCoordinate VID_CIUS_RO_UBL_CREDITNOTE_104 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "ubl-creditnote",
                                                                                                        "1.0.4");
  @Deprecated
  public static final DVRCoordinate VID_CIUS_RO_UBL_INVOICE_104 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "ubl-invoice",
                                                                                                     "1.0.4");

  // Version 1.0.8
  @Deprecated
  public static final DVRCoordinate VID_CIUS_RO_UBL_CREDITNOTE_108 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "ubl-creditnote",
                                                                                                        "1.0.8");
  @Deprecated
  public static final DVRCoordinate VID_CIUS_RO_UBL_INVOICE_108 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "ubl-invoice",
                                                                                                     "1.0.8");

  // Version 1.0.9
  public static final DVRCoordinate VID_CIUS_RO_UBL_CREDITNOTE_109 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "ubl-creditnote",
                                                                                                        "1.0.9");
  public static final DVRCoordinate VID_CIUS_RO_UBL_INVOICE_109 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "ubl-invoice",
                                                                                                     "1.0.9");

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
    {
      final ClassPathResource RES_103 = new ClassPathResource ("/external/schematron/1.0.3/ROeFactura-UBL-validation-Invoice_v1.0.3.xslt",
                                                               _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_137),
                                                                                    VID_CIUS_RO_UBL_CREDITNOTE_103,
                                                                                    "CIUS-RO UBL Credit Note " +
                                                                                                                    VID_CIUS_RO_UBL_CREDITNOTE_103.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (RES_103)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_137),
                                                                                    VID_CIUS_RO_UBL_INVOICE_103,
                                                                                    "CIUS-RO UBL Invoice " +
                                                                                                                 VID_CIUS_RO_UBL_INVOICE_103.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (RES_103)));
    }

    // V1.0.4 referencing the underlying EN rules
    {
      final ClassPathResource RES_104 = new ClassPathResource ("/external/schematron/1.0.4/ROeFactura-UBL-validation-Invoice_v1.0.4.xslt",
                                                               _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_137),
                                                                                    VID_CIUS_RO_UBL_CREDITNOTE_104,
                                                                                    "CIUS-RO UBL Credit Note " +
                                                                                                                    VID_CIUS_RO_UBL_CREDITNOTE_104.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (RES_104)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_137),
                                                                                    VID_CIUS_RO_UBL_INVOICE_104,
                                                                                    "CIUS-RO UBL Invoice " +
                                                                                                                 VID_CIUS_RO_UBL_INVOICE_104.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (RES_104)));
    }

    // V1.0.8 referencing the underlying EN rules, valid per 27.12.2022
    {
      final ClassPathResource RES_108 = new ClassPathResource ("/external/schematron/1.0.8/ROeFactura-UBL-validation-Invoice_v1.0.8.xslt",
                                                               _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_138),
                                                                                    VID_CIUS_RO_UBL_CREDITNOTE_108,
                                                                                    "CIUS-RO UBL Credit Note " +
                                                                                                                    VID_CIUS_RO_UBL_CREDITNOTE_108.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (RES_108)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_138),
                                                                                    VID_CIUS_RO_UBL_INVOICE_108,
                                                                                    "CIUS-RO UBL Invoice " +
                                                                                                                 VID_CIUS_RO_UBL_INVOICE_108.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (RES_108)));
    }

    // V1.0.9 referencing the underlying EN rules, valid per 05.06.2024
    {
      final ClassPathResource RES_109 = new ClassPathResource ("/external/schematron/1.0.9/ROeFactura-UBL-validation-Invoice_v1.0.9.xslt",
                                                               _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_138),
                                                                                    VID_CIUS_RO_UBL_CREDITNOTE_109,
                                                                                    "CIUS-RO UBL Credit Note " +
                                                                                                                    VID_CIUS_RO_UBL_CREDITNOTE_109.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (RES_109)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_138),
                                                                                    VID_CIUS_RO_UBL_INVOICE_109,
                                                                                    "CIUS-RO UBL Invoice " +
                                                                                                                 VID_CIUS_RO_UBL_INVOICE_109.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (RES_109)));
    }
  }
}
