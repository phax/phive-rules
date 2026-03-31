/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
package com.helger.phive.peppol.legacy;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesBuilder;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Peppol Australia/New Zealand (AUNZ) validation configuration
 *
 * @author Philip Helger
 */
@Immutable
@Deprecated (forRemoval = false)
public final class PeppolLegacyValidationBisAUNZ
{
  @Deprecated (forRemoval = false)
  public static final String GROUP_ID = "eu.peppol.bis3.aunz.ubl";

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolLegacyValidationBisAUNZ.class.getClassLoader ();
  }

  private static final String BASE_PATH = "external/schematron/peppol-aunz/";

  // 1.0.0
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.0");

  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_100 = new ClassPathResource (BASE_PATH +
                                                                                                            "1.0.0/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                                                                            _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_100 = new ClassPathResource (BASE_PATH +
                                                                                               "1.0.0/xslt/AUNZ-PEPPOL-validation.xslt",
                                                                                               _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_UBL_100 = new ClassPathResource (BASE_PATH +
                                                                                            "1.0.0/xslt/AUNZ-UBL-validation.xslt",
                                                                                            _getCL ());

  // 1.0.1
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_101 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.1");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_101 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.1");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_101 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.1");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_101 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.1");

  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_101 = new ClassPathResource (BASE_PATH +
                                                                                                            "1.0.1/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                                                                            _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_101 = new ClassPathResource (BASE_PATH +
                                                                                               "1.0.1/xslt/AUNZ-PEPPOL-validation.xslt",
                                                                                               _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_UBL_101 = new ClassPathResource (BASE_PATH +
                                                                                            "1.0.1/xslt/AUNZ-UBL-validation.xslt",
                                                                                            _getCL ());

  // 1.0.2
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_102 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.2");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_102 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.2");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_102 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.2");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_102 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.2");

  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_102 = new ClassPathResource (BASE_PATH +
                                                                                                            "1.0.2/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                                                                            _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_102 = new ClassPathResource (BASE_PATH +
                                                                                               "1.0.2/xslt/AUNZ-PEPPOL-validation.xslt",
                                                                                               _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_UBL_102 = new ClassPathResource (BASE_PATH +
                                                                                            "1.0.2/xslt/AUNZ-UBL-validation.xslt",
                                                                                            _getCL ());

  // 1.0.3
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_103 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.3");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_103 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.3");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_103 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.3");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_103 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.3");

  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_103 = new ClassPathResource (BASE_PATH +
                                                                                                            "1.0.3/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                                                                            _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_103 = new ClassPathResource (BASE_PATH +
                                                                                               "1.0.3/xslt/AUNZ-PEPPOL-validation.xslt",
                                                                                               _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_UBL_103 = new ClassPathResource (BASE_PATH +
                                                                                            "1.0.3/xslt/AUNZ-UBL-validation.xslt",
                                                                                            _getCL ());

  // 1.0.4
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_104 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.4");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_104 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.4");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_104 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.4");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_104 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.4");

  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_104 = new ClassPathResource (BASE_PATH +
                                                                                                            "1.0.4/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                                                                            _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_104 = new ClassPathResource (BASE_PATH +
                                                                                               "1.0.4/xslt/AUNZ-PEPPOL-validation.xslt",
                                                                                               _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_UBL_104 = new ClassPathResource (BASE_PATH +
                                                                                            "1.0.4/xslt/AUNZ-UBL-validation.xslt",
                                                                                            _getCL ());

  // 1.0.5
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_105 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.5");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_105 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.5");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_105 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.5");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_105 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.5");

  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_105 = new ClassPathResource (BASE_PATH +
                                                                                                            "1.0.5/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                                                                            _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_105 = new ClassPathResource (BASE_PATH +
                                                                                               "1.0.5/xslt/AUNZ-PEPPOL-validation.xslt",
                                                                                               _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_UBL_105 = new ClassPathResource (BASE_PATH +
                                                                                            "1.0.5/xslt/AUNZ-UBL-validation.xslt",
                                                                                            _getCL ());

  // 1.0.6
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_106 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.6");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_106 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.6");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_106 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.6");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_106 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.6");

  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_106 = new ClassPathResource (BASE_PATH +
                                                                                                            "1.0.6/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                                                                            _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_106 = new ClassPathResource (BASE_PATH +
                                                                                               "1.0.6/xslt/AUNZ-PEPPOL-validation.xslt",
                                                                                               _getCL ());
  private static final IReadableResource BIS3_BILLING_AUNZ_UBL_106 = new ClassPathResource (BASE_PATH +
                                                                                            "1.0.6/xslt/AUNZ-UBL-validation.xslt",
                                                                                            _getCL ());

  // 1.0.7
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_107 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.7");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_107 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.7");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_107 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.7");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_107 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.7");

  // 1.0.8
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_108 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.8");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_108 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.8");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_108 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.8");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_108 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.8");

  // 1.0.9
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_109 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.9");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_109 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.9");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_109 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.9");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_109 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.9");

  // 1.0.10
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "invoice",
                                                                                                                     "1.0.10");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                  "invoice-self-billing",
                                                                                                                                  "1.0.10");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                         "creditnote",
                                                                                                                         "1.0.10");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                      "creditnote-self-billing",
                                                                                                                                      "1.0.10");

  private PeppolLegacyValidationBisAUNZ ()
  {}

  @Deprecated (forRemoval = false)
  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final boolean bDeprecated = true;

    // 1.0.0
    final String sVersion100 = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_100.getVersionString ();
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_100)
                     .displayName ("A-NZ Peppol BIS3 Invoice (UBL) " + sVersion100)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_100, aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_100, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_100)
                     .displayName ("A-NZ Peppol BIS3 Credit Note (UBL) " + sVersion100)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_100, aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_100, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // Self-billing
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_100)
                     .displayName ("A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " + sVersion100)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_100,
                                                                  aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_100, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_100)
                     .displayName ("A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " + sVersion100)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_100,
                                                                  aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_100, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // 1.0.1
    final String sVersion101 = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_101.getVersionString ();
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_101)
                     .displayName ("A-NZ Peppol BIS3 Invoice (UBL) " + sVersion101)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_101, aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_101, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_101)
                     .displayName ("A-NZ Peppol BIS3 Credit Note (UBL) " + sVersion101)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_101, aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_101, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // Self-billing
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_101)
                     .displayName ("A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " + sVersion101)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_101,
                                                                  aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_101, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_101)
                     .displayName ("A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " + sVersion101)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_101,
                                                                  aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_101, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // 1.0.2
    final String sVersion102 = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_102.getVersionString ();
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_102)
                     .displayName ("A-NZ Peppol BIS3 Invoice (UBL) " + sVersion102)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_102, aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_102, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_102)
                     .displayName ("A-NZ Peppol BIS3 Credit Note (UBL) " + sVersion102)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_102, aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_102, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // Self-billing
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_102)
                     .displayName ("A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " + sVersion102)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_102,
                                                                  aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_102, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_102)
                     .displayName ("A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " + sVersion102)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_102,
                                                                  aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_102, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // 1.0.3
    final String sVersion103 = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_103.getVersionString ();
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_103)
                     .displayName ("A-NZ Peppol BIS3 Invoice (UBL) " + sVersion103)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_103, aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_103, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_103)
                     .displayName ("A-NZ Peppol BIS3 Credit Note (UBL) " + sVersion103)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_103, aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_103, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // Self-billing
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_103)
                     .displayName ("A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " + sVersion103)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_103,
                                                                  aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_103, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_103)
                     .displayName ("A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " + sVersion103)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_103,
                                                                  aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_103, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // 1.0.4
    final String sVersion104 = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_104.getVersionString ();
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_104)
                     .displayName ("A-NZ Peppol BIS3 Invoice (UBL) " + sVersion104)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_104, aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_104, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_104)
                     .displayName ("A-NZ Peppol BIS3 Credit Note (UBL) " + sVersion104)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_104, aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_104, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // Self-billing
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_104)
                     .displayName ("A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " + sVersion104)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_104,
                                                                  aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_104, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_104)
                     .displayName ("A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " + sVersion104)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_104,
                                                                  aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_104, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // 1.0.5
    final String sVersion105 = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_105.getVersionString ();
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_105)
                     .displayName ("A-NZ Peppol BIS3 Invoice (UBL) " + sVersion105)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_105, aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_105, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_105)
                     .displayName ("A-NZ Peppol BIS3 Credit Note (UBL) " + sVersion105)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_105, aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_105, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // Self-billing
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_105)
                     .displayName ("A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " + sVersion105)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_105,
                                                                  aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_105, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_105)
                     .displayName ("A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " + sVersion105)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_105,
                                                                  aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_105, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // 1.0.6
    final String sVersion106 = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_106.getVersionString ();
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_106)
                     .displayName ("A-NZ Peppol BIS3 Invoice (UBL) " + sVersion106)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_106, aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_106, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_106)
                     .displayName ("A-NZ Peppol BIS3 Credit Note (UBL) " + sVersion106)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_106, aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_106, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // Self-billing
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_106)
                     .displayName ("A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " + sVersion106)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_106,
                                                                  aNSCtxInvoice))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_106, aNSCtxInvoice))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_106)
                     .displayName ("A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " + sVersion106)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_106,
                                                                  aNSCtxCreditNote))
                     .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_106, aNSCtxCreditNote))
                     .registerInto (aRegistry);

    // 1.0.7
    {
      final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_107 = new ClassPathResource (BASE_PATH +
                                                                                                 "1.0.7/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                                                                 _getCL ());
      final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_107 = new ClassPathResource (BASE_PATH +
                                                                                    "1.0.7/xslt/AUNZ-PEPPOL-validation.xslt",
                                                                                    _getCL ());
      final IReadableResource BIS3_BILLING_AUNZ_UBL_107 = new ClassPathResource (BASE_PATH +
                                                                                 "1.0.7/xslt/AUNZ-UBL-validation.xslt",
                                                                                 _getCL ());

      final String sVersion107 = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_107.getVersionString ();
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_107)
                       .displayName ("A-NZ Peppol BIS3 Invoice (UBL) " + sVersion107)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_107, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_107, aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_107)
                       .displayName ("A-NZ Peppol BIS3 Credit Note (UBL) " + sVersion107)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_107, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_107, aNSCtxCreditNote))
                       .registerInto (aRegistry);

      // Self-billing
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_107)
                       .displayName ("A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " + sVersion107)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_107,
                                                                    aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_107, aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_107)
                       .displayName ("A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " + sVersion107)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_107,
                                                                    aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_107, aNSCtxCreditNote))
                       .registerInto (aRegistry);
    }

    // 1.0.8
    {
      final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_108 = new ClassPathResource (BASE_PATH +
                                                                                                 "1.0.8/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                                                                 _getCL ());
      final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_108 = new ClassPathResource (BASE_PATH +
                                                                                    "1.0.8/xslt/AUNZ-PEPPOL-validation.xslt",
                                                                                    _getCL ());
      final IReadableResource BIS3_BILLING_AUNZ_UBL_108 = new ClassPathResource (BASE_PATH +
                                                                                 "1.0.8/xslt/AUNZ-UBL-validation.xslt",
                                                                                 _getCL ());

      final String sVersion108 = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_108.getVersionString ();
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_108)
                       .displayName ("A-NZ Peppol BIS3 Invoice (UBL) " + sVersion108)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_108, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_108, aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_108)
                       .displayName ("A-NZ Peppol BIS3 Credit Note (UBL) " + sVersion108)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_108, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_108, aNSCtxCreditNote))
                       .registerInto (aRegistry);

      // Self-billing
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_108)
                       .displayName ("A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " + sVersion108)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_108,
                                                                    aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_108, aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_108)
                       .displayName ("A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " + sVersion108)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_108,
                                                                    aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_108, aNSCtxCreditNote))
                       .registerInto (aRegistry);
    }

    // 1.0.9
    {
      final IReadableResource aResSB = new ClassPathResource (BASE_PATH + "1.0.9/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                              _getCL ());
      final IReadableResource aResInv = new ClassPathResource (BASE_PATH + "1.0.9/xslt/AUNZ-PEPPOL-validation.xslt",
                                                               _getCL ());
      final IReadableResource aResShared = new ClassPathResource (BASE_PATH + "1.0.9/xslt/AUNZ-UBL-validation.xslt",
                                                                  _getCL ());

      final String sVersion = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_109.getVersionString ();
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_109)
                       .displayName ("A-NZ Peppol BIS3 Invoice (UBL) " + sVersion)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aResInv, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (aResShared, aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_109)
                       .displayName ("A-NZ Peppol BIS3 Credit Note (UBL) " + sVersion)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aResInv, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (aResShared, aNSCtxCreditNote))
                       .registerInto (aRegistry);

      // Self-billing
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_109)
                       .displayName ("A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " + sVersion)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aResSB, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (aResShared, aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_109)
                       .displayName ("A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " + sVersion)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aResSB, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (aResShared, aNSCtxCreditNote))
                       .registerInto (aRegistry);
    }

    // 1.0.10
    {
      final IReadableResource aResSB = new ClassPathResource (BASE_PATH + "1.0.10/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                              _getCL ());
      final IReadableResource aResInv = new ClassPathResource (BASE_PATH + "1.0.10/xslt/AUNZ-PEPPOL-validation.xslt",
                                                               _getCL ());
      final IReadableResource aResShared = new ClassPathResource (BASE_PATH + "1.0.10/xslt/AUNZ-UBL-validation.xslt",
                                                                  _getCL ());

      final String sVersion = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_10.getVersionString ();
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_10)
                       .displayName ("A-NZ Peppol BIS3 Invoice (UBL) " + sVersion)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aResInv, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (aResShared, aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_10)
                       .displayName ("A-NZ Peppol BIS3 Credit Note (UBL) " + sVersion)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aResInv, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (aResShared, aNSCtxCreditNote))
                       .registerInto (aRegistry);

      // Self-billing
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_10)
                       .displayName ("A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " + sVersion)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aResSB, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (aResShared, aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_10)
                       .displayName ("A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " + sVersion)
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aResSB, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (aResShared, aNSCtxCreditNote))
                       .registerInto (aRegistry);
    }
  }
}
