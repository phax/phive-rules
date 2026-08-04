/*
 * Copyright (C) 2025-2026 Philip Helger (www.helger.com)
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
package com.helger.phive.france;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.shared.DVRHelper;
import com.helger.phive.rules.shared.PhiveRulesCIIHelper;
import com.helger.phive.rules.shared.PhiveRulesUBLHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * France PPF Flux 1 (e-invoicing &amp; e-reporting) validation configuration. Flux 1 is provided in
 * two trajectories: the base "Démarrage" profile and the full "Cible" profile, each available for
 * UBL and CII.
 *
 * @author Philip Helger
 * @since 4.5.0
 */
@Immutable
public final class FranceFlux1Validation
{
  public static final String GROUP_ID = "fr.ctc.flux1";

  // v0.2
  public static final DVRCoordinate VID_FR_FLUX1_UBL_INV_DEMARRAGE_0_2 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                     "ubl-invoice-demarrage",
                                                                                                     "0.2");
  public static final DVRCoordinate VID_FR_FLUX1_UBL_INV_CIBLE_0_2 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                 "ubl-invoice-cible",
                                                                                                 "0.2");
  public static final DVRCoordinate VID_FR_FLUX1_UBL_CN_DEMARRAGE_0_2 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                    "ubl-creditnote-demarrage",
                                                                                                    "0.2");
  public static final DVRCoordinate VID_FR_FLUX1_UBL_CN_CIBLE_0_2 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                "ubl-creditnote-cible",
                                                                                                "0.2");
  public static final DVRCoordinate VID_FR_FLUX1_CII_DEMARRAGE_0_2 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                 "cii-demarrage",
                                                                                                 "0.2");
  public static final DVRCoordinate VID_FR_FLUX1_CII_CIBLE_0_2 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                             "cii-cible",
                                                                                             "0.2");

  private FranceFlux1Validation ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return FranceFlux1Validation.class.getClassLoader ();
  }

  /**
   * Register all France PPF Flux 1 validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initFranceFlux1 (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sPrefix = "/external/schematron/flux1/0.2/xslt/";
    final String sXsdPrefix = "/external/schemas/flux1/0.2/";

    // v0.2
    {
      // Démarrage (base trajectory)
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_FLUX1_UBL_INV_DEMARRAGE_0_2)
                   .displayNamePrefix ("France PPF Flux 1 UBL Invoice Démarrage ")
                   .notDeprecated ()
                   .addXSD (new ClassPathResource (sXsdPrefix + "ubl-demarrage/F1BASE_UBL-invoice-2.1.xsd", _getCL ()))
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                                "PPF_Flux1_UBL_1_8_DEMARRAGE_v0_2.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_FLUX1_UBL_CN_DEMARRAGE_0_2)
                   .displayNamePrefix ("France PPF Flux 1 UBL Credit Note Démarrage ")
                   .notDeprecated ()
                   .addXSD (new ClassPathResource (sXsdPrefix + "ubl-demarrage/F1BASE_UBL-CreditNote-2.1.xsd",
                                                   _getCL ()))
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                                "PPF_Flux1_UBL_1_8_DEMARRAGE_v0_2.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_FLUX1_CII_DEMARRAGE_0_2)
                   .displayNamePrefix ("France PPF Flux 1 CII Démarrage ")
                   .notDeprecated ()
                   .addXSD (new ClassPathResource (sXsdPrefix +
                                                   "cii-demarrage/uncefact/data/standard/F1BASE_CrossIndustryInvoice_100pD22B.xsd",
                                                   _getCL ()))
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix +
                                                                                                   "PPF_Flux1_CII_1_8_DEMARRAGE_v0_2.xslt",
                                                                                                   _getCL ())))
                   .registerInto (aRegistry);

      // Cible (full trajectory) - a strict superset of the Démarrage rules
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_FLUX1_UBL_INV_CIBLE_0_2)
                   .displayNamePrefix ("France PPF Flux 1 UBL Invoice Cible ")
                   .notDeprecated ()
                   .addXSD (new ClassPathResource (sXsdPrefix + "ubl-cible/F1FULL_UBL_invoice-2.1.xsd", _getCL ()))
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                                "PPF_Flux1_UBL_1_8_CIBLE_v0_2.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_FLUX1_UBL_CN_CIBLE_0_2)
                   .displayNamePrefix ("France PPF Flux 1 UBL Credit Note Cible ")
                   .notDeprecated ()
                   .addXSD (new ClassPathResource (sXsdPrefix + "ubl-cible/F1FULL_UBL_CreditNote-2.1.xsd", _getCL ()))
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                                "PPF_Flux1_UBL_1_8_CIBLE_v0_2.xslt",
                                                                                                _getCL ())))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_FR_FLUX1_CII_CIBLE_0_2)
                   .displayNamePrefix ("France PPF Flux 1 CII Cible ")
                   .notDeprecated ()
                   .addXSD (new ClassPathResource (sXsdPrefix +
                                                   "cii-cible/uncefact/data/standard/F1FULL_CrossIndustryInvoice_100pD22B.xsd",
                                                   _getCL ()))
                   .addSchematron (PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource (sPrefix +
                                                                                                   "PPF_Flux1_CII_1_8_CIBLE_v0_2.xslt",
                                                                                                   _getCL ())))
                   .registerInto (aRegistry);
    }
  }
}
