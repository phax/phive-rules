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
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsSet;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.sbdh.CSBDH;
import com.helger.ubl21.UBL21Marshaller;

/**
 * Turkey UBL-TR / e-Fatura validation configuration.
 * <p>
 * The Turkish Revenue Administration (GİB) e-Fatura format is based on UBL-TR 1.2.1 (XSDs) and the
 * e-Fatura Schematron package. The four covered document types are Invoice, ApplicationResponse,
 * DespatchAdvice and ReceiptAdvice. Each is validated against the UBL 2.1 XSD plus the GİB
 * <code>UBL-TR_Main_Schematron</code> rules.
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
  /**
   * SBDH-wrapped Zarf (envelope) — the on-the-wire transport unit. Validates the GS1/UN-CEFACT
   * Standard Business Document wrapper, the GİB <code>ef:Package</code> payload and the inner UBL
   * document(s) all in one go. Use this when the input is the Zarf XML; for an unwrapped UBL
   * document use the bare <code>VID_TR_EFATURA_INVOICE_1_2_1</code> / -APPRESP / -DESPATCH /
   * -RECEIPT instead.
   */
  public static final DVRCoordinate VID_TR_EFATURA_ZARF_1_2_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "zarf",
                                                                                                   "1.2.1");

  private TurkeyEFaturaValidation ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return TurkeyEFaturaValidation.class.getClassLoader ();
  }

  /**
   * Register all standard Turkey e-Fatura validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initTurkeyEFatura (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // UBL-TR 1.2.1 — e-Fatura business rules (originally authored against the SBDH-wrapped Zarf
    // payload; envelope-level patterns silently no-op when the document is unwrapped UBL).
    {
      final String sPrefix = "/external/schematron/efatura/1.2.1/xslt/";
      final ClassPathResource aSchematron = new ClassPathResource (sPrefix + "UBL-TR_Main_Schematron.xslt", _getCL ());

      VesXmlBuilder.builder ()
                   .vesID (VID_TR_EFATURA_INVOICE_1_2_1)
                   .displayNamePrefix ("Turkey e-Fatura UBL Invoice ")
                   .notDeprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aSchematron))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_TR_EFATURA_APPRESP_1_2_1)
                   .displayNamePrefix ("Turkey e-Fatura UBL Application Response ")
                   .notDeprecated ()
                   .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aSchematron))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_TR_EFATURA_DESPATCH_1_2_1)
                   .displayNamePrefix ("Turkey e-Fatura UBL Despatch Advice ")
                   .notDeprecated ()
                   .addXSD (UBL21Marshaller.getAllDespatchAdviceXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aSchematron))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_TR_EFATURA_RECEIPT_1_2_1)
                   .displayNamePrefix ("Turkey e-Fatura UBL Receipt Advice ")
                   .notDeprecated ()
                   .addXSD (UBL21Marshaller.getAllReceiptAdviceXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aSchematron))
                   .registerInto (aRegistry);

      // SBDH-wrapped Zarf — XSD set is SBDH wrapper plus all four UBL document schemas, so the
      // <xs:any processContents="lax"/> inner payload is also strictly validated.
      final ICommonsSet <IReadableResource> aZarfXSDs = new CommonsHashSet <> ();
      aZarfXSDs.addAll (CSBDH.SBDH_XSDS);
      aZarfXSDs.addAll (UBL21Marshaller.getAllInvoiceXSDs ());
      aZarfXSDs.addAll (UBL21Marshaller.getAllApplicationResponseXSDs ());
      aZarfXSDs.addAll (UBL21Marshaller.getAllDespatchAdviceXSDs ());
      aZarfXSDs.addAll (UBL21Marshaller.getAllReceiptAdviceXSDs ());
      VesXmlBuilder.builder ()
                   .vesID (VID_TR_EFATURA_ZARF_1_2_1)
                   .displayNamePrefix ("Turkey e-Fatura Zarf ")
                   .notDeprecated ()
                   .addXSD (aZarfXSDs.getCopyAsList ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aSchematron))
                   .registerInto (aRegistry);
    }
  }
}
