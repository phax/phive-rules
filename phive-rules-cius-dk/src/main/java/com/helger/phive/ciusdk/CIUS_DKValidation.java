/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.phive.ciusdk;

import java.time.LocalTime;
import java.time.Month;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.datetime.helper.PDTFactory;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.peppol.PeppolValidation2026_05;
import com.helger.phive.rules.shared.DVRHelper;
import com.helger.phive.rules.shared.PhiveRulesHelper;
import com.helger.phive.rules.shared.PhiveRulesUBLHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Danish Peppol CIUS validation configuration. The Danish CIUS is published by Nemhandel /
 * Erhvervsstyrelsen and extends the Peppol BIS Billing rules with the Danish business rules.
 *
 * @author Philip Helger
 * @since 4.5.7
 */
@Immutable
public final class CIUS_DKValidation
{
  public static final String GROUP_ID = "dk.gov.erst.cius-dk";

  // Version 1.17.0
  public static final DVRCoordinate VID_CIUS_DK_UBL_CREDITNOTE_1170 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                  "ubl-creditnote",
                                                                                                  "1.17.0");
  public static final DVRCoordinate VID_CIUS_DK_UBL_INVOICE_1170 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                               "ubl-invoice",
                                                                                               "1.17.0");

  private CIUS_DKValidation ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return CIUS_DKValidation.class.getClassLoader ();
  }

  /**
   * @return A list of all prerequisite validation execution set coordinates that must already be
   *         registered before {@link #init(IValidationExecutorSetRegistry)} is called. Shares the
   *         same data basis as the initialization method. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <DVRCoordinate> getAllPrerequisites ()
  {
    return new CommonsArrayList <> (PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                    PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_UBL_V3);
  }

  /**
   * Register all standard CIUS-DK validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final IValidationExecutorSet <IValidationSourceXML> aVESCN = PhiveRulesHelper.requireVESID (aRegistry,
                                                                                                PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3);
    final IValidationExecutorSet <IValidationSourceXML> aVESInv = PhiveRulesHelper.requireVESID (aRegistry,
                                                                                                 PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_UBL_V3);

    // V1.17.0 referencing Peppol BIS Billing 3.0.21
    {
      // Mandatory use from 2026-08-17 12:00 CET
      final OffsetDateTime aValidFrom = PDTFactory.createLocalDate (2026, Month.AUGUST, 17)
                                                  .atTime (LocalTime.NOON)
                                                  .atOffset (ZoneOffset.ofHours (2));
      final ClassPathResource aXslt = new ClassPathResource ("/external/schematron/1.17.0/DK-EN16931-UBL.xslt",
                                                             _getCL ());
      VesXmlBuilder.builder ()
                   .vesID (VID_CIUS_DK_UBL_CREDITNOTE_1170)
                   .displayNamePrefix ("CIUS-DK UBL Credit Note ")
                   .notDeprecated ()
                   .basedOn (aVESCN)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_CIUS_DK_UBL_INVOICE_1170)
                   .displayNamePrefix ("CIUS-DK UBL Invoice ")
                   .notDeprecated ()
                   .basedOn (aVESInv)
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aXslt))
                   .validFrom (aValidFrom)
                   .registerInto (aRegistry);
    }
  }
}
