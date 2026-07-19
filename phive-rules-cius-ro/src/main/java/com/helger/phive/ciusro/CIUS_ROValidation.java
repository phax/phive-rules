/*
 * Copyright (C) 2020-2026 Philip Helger (www.helger.com)
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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesInitializationException;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;

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

  @NonNull
  private static ClassLoader _getCL ()
  {
    return CIUS_ROValidation.class.getClassLoader ();
  }

  /**
   * @return A list of all prerequisite validation execution set coordinates that must already be
   *         registered before {@link #initCIUS_RO(IValidationExecutorSetRegistry)} is called.
   *         Shares the same data basis as the initialization method. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  @SuppressWarnings ("deprecation")
  public static ICommonsList <DVRCoordinate> getAllPrerequisites ()
  {
    final ICommonsList <DVRCoordinate> ret = new CommonsArrayList <> ();
    ret.add (EN16931Validation.VID_UBL_CREDIT_NOTE_137);
    ret.add (EN16931Validation.VID_UBL_INVOICE_137);
    ret.add (EN16931Validation.VID_UBL_CREDIT_NOTE_138);
    ret.add (EN16931Validation.VID_UBL_INVOICE_138);
    return ret;
  }

  /**
   * Register all standard CIUS-RO validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   * @throws PhiveRulesInitializationException
   *         If prerequisites are not present
   */
  @SuppressWarnings ("deprecation")
  public static void initCIUS_RO (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry) throws PhiveRulesInitializationException
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final IValidationExecutorSet <IValidationSourceXML> aVESCN_1_3_7 = PhiveRulesHelper.requireVESID (aRegistry,
                                                                                                      EN16931Validation.VID_UBL_CREDIT_NOTE_137);
    final IValidationExecutorSet <IValidationSourceXML> aVESInv_1_3_7 = PhiveRulesHelper.requireVESID (aRegistry,
                                                                                                       EN16931Validation.VID_UBL_INVOICE_137);
    final IValidationExecutorSet <IValidationSourceXML> aVESCN_1_3_8 = PhiveRulesHelper.requireVESID (aRegistry,
                                                                                                      EN16931Validation.VID_UBL_CREDIT_NOTE_138);
    final IValidationExecutorSet <IValidationSourceXML> aVESInv_1_3_8 = PhiveRulesHelper.requireVESID (aRegistry,
                                                                                                       EN16931Validation.VID_UBL_INVOICE_138);

    // V1.0.3 referencing the underlying EN rules
    {
      final ClassPathResource RES_103 = new ClassPathResource ("/external/schematron/1.0.3/ROeFactura-UBL-validation-Invoice_v1.0.3.xslt",
                                                               _getCL ());
      VesXmlBuilder.builder ()
                   .vesID (VID_CIUS_RO_UBL_CREDITNOTE_103)
                   .displayNamePrefix ("CIUS-RO UBL Credit Note ")
                   .deprecated ()
                   .basedOn (aVESCN_1_3_7)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (RES_103))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_CIUS_RO_UBL_INVOICE_103)
                   .displayNamePrefix ("CIUS-RO UBL Invoice ")
                   .deprecated ()
                   .basedOn (aVESInv_1_3_7)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (RES_103))
                   .registerInto (aRegistry);
    }

    // V1.0.4 referencing the underlying EN rules
    {
      final ClassPathResource RES_104 = new ClassPathResource ("/external/schematron/1.0.4/ROeFactura-UBL-validation-Invoice_v1.0.4.xslt",
                                                               _getCL ());
      VesXmlBuilder.builder ()
                   .vesID (VID_CIUS_RO_UBL_CREDITNOTE_104)
                   .displayNamePrefix ("CIUS-RO UBL Credit Note ")
                   .deprecated ()
                   .basedOn (aVESCN_1_3_7)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (RES_104))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_CIUS_RO_UBL_INVOICE_104)
                   .displayNamePrefix ("CIUS-RO UBL Invoice ")
                   .deprecated ()
                   .basedOn (aVESInv_1_3_7)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (RES_104))
                   .registerInto (aRegistry);
    }

    // V1.0.8 referencing the underlying EN rules, valid per 27.12.2022
    {
      final ClassPathResource RES_108 = new ClassPathResource ("/external/schematron/1.0.8/ROeFactura-UBL-validation-Invoice_v1.0.8.xslt",
                                                               _getCL ());
      VesXmlBuilder.builder ()
                   .vesID (VID_CIUS_RO_UBL_CREDITNOTE_108)
                   .displayNamePrefix ("CIUS-RO UBL Credit Note ")
                   .deprecated ()
                   .basedOn (aVESCN_1_3_8)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (RES_108))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_CIUS_RO_UBL_INVOICE_108)
                   .displayNamePrefix ("CIUS-RO UBL Invoice ")
                   .deprecated ()
                   .basedOn (aVESInv_1_3_8)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (RES_108))
                   .registerInto (aRegistry);
    }

    // V1.0.9 referencing the underlying EN rules, valid per 05.06.2024
    {
      final ClassPathResource RES_109 = new ClassPathResource ("/external/schematron/1.0.9/ROeFactura-UBL-validation-Invoice_v1.0.9.xslt",
                                                               _getCL ());
      VesXmlBuilder.builder ()
                   .vesID (VID_CIUS_RO_UBL_CREDITNOTE_109)
                   .displayNamePrefix ("CIUS-RO UBL Credit Note ")
                   .notDeprecated ()
                   .basedOn (aVESCN_1_3_8)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (RES_109))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_CIUS_RO_UBL_INVOICE_109)
                   .displayNamePrefix ("CIUS-RO UBL Invoice ")
                   .notDeprecated ()
                   .basedOn (aVESInv_1_3_8)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (RES_109))
                   .registerInto (aRegistry);
    }
  }
}
