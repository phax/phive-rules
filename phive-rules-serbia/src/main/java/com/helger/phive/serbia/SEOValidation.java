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
package com.helger.phive.serbia;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;

/**
 * Serbian SEO (Sistem Elektronskih Otpremnica) logistics document validation configuration. It
 * covers the Despatch Advice (eOtpremnica) and Receipt Advice (ePrijemnica) documents published by
 * the Ministry of Finance for the SEO system:
 * <ul>
 * <li>Despatch Advice - Customization ID
 * <code>urn:fdc:mfin.gov.rs:logistics:trns:despatch_advice:1:2025.12</code>, Profile ID
 * <code>urn:fdc:peppol.eu:logistics:bis:despatch_advice_only:1</code></li>
 * <li>Receipt Advice - Customization ID
 * <code>urn:fdc:mfin.gov.rs:logistics:trns:receipt_advice:1:2025.12</code>, Profile ID
 * <code>urn:fdc:peppol.eu:logistics:bis:despatch_advice_w_receipt_advice:1</code></li>
 * </ul>
 * <b>Note:</b> the Ministry of Finance only publishes UBL 2.1 example documents for SEO - no
 * Schematron business rules are available. These validation execution sets therefore perform UBL
 * 2.1 XSD validation only. They do not enforce the Serbia-specific or Peppol Logistics BIS business
 * rules. See https://eotpremnica.efaktura.gov.rs/
 *
 * @author Philip Helger
 */
@Immutable
public final class SEOValidation
{
  public static final String GROUP_ID = "rs.gov.mfin.logistics";

  // Version 1.1.0 according to the published SEO UBL examples (2025.12)
  public static final DVRCoordinate VID_SEO_UBL_DESPATCH_ADVICE_110 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "ubl-despatch-advice",
                                                                                                        "1.1.0");
  public static final DVRCoordinate VID_SEO_UBL_RECEIPT_ADVICE_110 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-receipt-advice",
                                                                                                       "1.1.0");

  private SEOValidation ()
  {}

  /**
   * Register all standard Serbian SEO validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initSEO (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // V1.1.0 - UBL 2.1 XSD validation only (no Schematron business rules published)
    VesXmlBuilder.builder ()
                 .vesID (VID_SEO_UBL_DESPATCH_ADVICE_110)
                 .displayNamePrefix ("Serbia SEO UBL Despatch Advice ")
                 .addXSD (UBL21Marshaller.getAllDespatchAdviceXSDs ())
                 .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                 .vesID (VID_SEO_UBL_RECEIPT_ADVICE_110)
                 .displayNamePrefix ("Serbia SEO UBL Receipt Advice ")
                 .addXSD (UBL21Marshaller.getAllReceiptAdviceXSDs ())
                 .registerInto (aRegistry);
  }
}
