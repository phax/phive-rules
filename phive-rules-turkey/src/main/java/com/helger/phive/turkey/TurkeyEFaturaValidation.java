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
package com.helger.phive.turkey;

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
 * Turkey UBL-TR / e-Fatura validation configuration.
 * <p>
 * The Turkish Revenue Administration (GİB) e-Fatura format is based on UBL-TR 1.2.1 (XSDs) and the
 * e-Fatura Schematron package. This module currently only registers the UBL 2.1 XSD validation for
 * the four covered document types: Invoice, ApplicationResponse, DespatchAdvice and ReceiptAdvice.
 * The Schematron rules from the e-Fatura package still need to be added.
 *
 * @author Philip Helger
 */
@Immutable
public final class TurkeyEFaturaValidation
{
  public static final String GROUP_ID = "tr.efatura";

  // UBL-TR 1.2.1
  public static final DVRCoordinate VID_TR_EFATURA_INVOICE_1_2_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "invoice",
                                                                                                      "1.2.1");
  public static final DVRCoordinate VID_TR_EFATURA_APPRESP_1_2_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "application-response",
                                                                                                      "1.2.1");
  public static final DVRCoordinate VID_TR_EFATURA_DESPATCH_1_2_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "despatch-advice",
                                                                                                       "1.2.1");
  public static final DVRCoordinate VID_TR_EFATURA_RECEIPT_1_2_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "receipt-advice",
                                                                                                      "1.2.1");

  private TurkeyEFaturaValidation ()
  {}

  /**
   * Register all standard Turkey e-Fatura validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initTurkeyEFatura (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // UBL-TR 1.2.1
    // TODO add e-Fatura Schematron rules from https://efatura.gov.tr/ when available
    {
      VesXmlBuilder.builder ()
                       .vesID (VID_TR_EFATURA_INVOICE_1_2_1)
                       .displayNamePrefix ("Turkey e-Fatura UBL Invoice ")
                       .notDeprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_TR_EFATURA_APPRESP_1_2_1)
                       .displayNamePrefix ("Turkey e-Fatura UBL Application Response ")
                       .notDeprecated ()
                       .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_TR_EFATURA_DESPATCH_1_2_1)
                       .displayNamePrefix ("Turkey e-Fatura UBL Despatch Advice ")
                       .notDeprecated ()
                       .addXSD (UBL21Marshaller.getAllDespatchAdviceXSDs ())
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_TR_EFATURA_RECEIPT_1_2_1)
                       .displayNamePrefix ("Turkey e-Fatura UBL Receipt Advice ")
                       .notDeprecated ()
                       .addXSD (UBL21Marshaller.getAllReceiptAdviceXSDs ())
                       .registerInto (aRegistry);
    }
  }
}
