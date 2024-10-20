/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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
package com.helger.phive.peppol;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Peppol Australia/New Zealand (AUNZ) validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationBisAUNZ
{
  public static final String GROUP_ID = "eu.peppol.bis3.aunz.ubl";

  // 1.0.9
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_109 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.9");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_109 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.9");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_109 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.9");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_109 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.9");

  // 1.0.10
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "invoice",
                                                                                                                     "1.0.10");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                  "invoice-self-billing",
                                                                                                                                  "1.0.10");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                         "creditnote",
                                                                                                                         "1.0.10");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                      "creditnote-self-billing",
                                                                                                                                      "1.0.10");

  // 1.0.11
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "invoice",
                                                                                                                     "1.0.11");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                  "invoice-self-billing",
                                                                                                                                  "1.0.11");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                         "creditnote",
                                                                                                                         "1.0.11");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                      "creditnote-self-billing",
                                                                                                                                      "1.0.11");

  private PeppolValidationBisAUNZ ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationBisAUNZ.class.getClassLoader ();
  }

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    final String BASE_PATH = "external/schematron/peppol-aunz/";

    // 1.0.9
    {
      final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_109 = new ClassPathResource (BASE_PATH +
                                                                                                 "1.0.9/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                                                                 _getCL ());
      final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_109 = new ClassPathResource (BASE_PATH +
                                                                                    "1.0.9/xslt/AUNZ-PEPPOL-validation.xslt",
                                                                                    _getCL ());
      final IReadableResource BIS3_BILLING_AUNZ_UBL_109 = new ClassPathResource (BASE_PATH +
                                                                                 "1.0.9/xslt/AUNZ-UBL-validation.xslt",
                                                                                 _getCL ());

      final String sVersion109 = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_109.getVersionString ();
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_109,
                                                                             "A-NZ Peppol BIS3 Invoice (UBL) " +
                                                                                                                       sVersion109,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_109,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_109,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_109,
                                                                             "A-NZ Peppol BIS3 Credit Note (UBL) " +
                                                                                                                           sVersion109,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_109,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_109,
                                                                                                          aNSCtxCreditNote)));

      // Self-billing
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_109,
                                                                             "A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " +
                                                                                                                                    sVersion109,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_109,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_109,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_109,
                                                                             "A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " +
                                                                                                                                        sVersion109,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_109,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_109,
                                                                                                          aNSCtxCreditNote)));
    }

    // 1.0.10
    {
      final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_1_0_10 = new ClassPathResource (BASE_PATH +
                                                                                                    "1.0.10/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                                                                    _getCL ());
      final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_1_0_10 = new ClassPathResource (BASE_PATH +
                                                                                       "1.0.10/xslt/AUNZ-PEPPOL-validation.xslt",
                                                                                       _getCL ());
      final IReadableResource BIS3_BILLING_AUNZ_UBL_1_0_10 = new ClassPathResource (BASE_PATH +
                                                                                    "1.0.10/xslt/AUNZ-UBL-validation.xslt",
                                                                                    _getCL ());

      final String sVersion1010 = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_10.getVersionString ();
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_10,
                                                                             "A-NZ Peppol BIS3 Invoice (UBL) " +
                                                                                                                          sVersion1010,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_1_0_10,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_1_0_10,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_10,
                                                                             "A-NZ Peppol BIS3 Credit Note (UBL) " +
                                                                                                                              sVersion1010,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_1_0_10,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_1_0_10,
                                                                                                          aNSCtxCreditNote)));

      // Self-billing
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_10,
                                                                             "A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " +
                                                                                                                                       sVersion1010,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_1_0_10,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_1_0_10,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_10,
                                                                             "A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " +
                                                                                                                                           sVersion1010,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_1_0_10,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_1_0_10,
                                                                                                          aNSCtxCreditNote)));
    }

    // 1.0.11
    {
      final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_1_0_11 = new ClassPathResource (BASE_PATH +
                                                                                                    "1.0.11/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                                                                    _getCL ());
      final IReadableResource BIS3_BILLING_AUNZ_PEPPOL_1_0_11 = new ClassPathResource (BASE_PATH +
                                                                                       "1.0.11/xslt/AUNZ-PEPPOL-validation.xslt",
                                                                                       _getCL ());
      final IReadableResource BIS3_BILLING_AUNZ_UBL_1_0_11 = new ClassPathResource (BASE_PATH +
                                                                                    "1.0.11/xslt/AUNZ-UBL-validation.xslt",
                                                                                    _getCL ());

      final String sVersion1111 = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_11.getVersionString ();
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_11,
                                                                             "A-NZ Peppol BIS3 Invoice (UBL) " +
                                                                                                                          sVersion1111,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_1_0_11,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_1_0_11,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_11,
                                                                             "A-NZ Peppol BIS3 Credit Note (UBL) " +
                                                                                                                              sVersion1111,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_1_0_11,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_1_0_11,
                                                                                                          aNSCtxCreditNote)));

      // Self-billing
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_11,
                                                                             "A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " +
                                                                                                                                       sVersion1111,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_1_0_11,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_1_0_11,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_11,
                                                                             "A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " +
                                                                                                                                           sVersion1111,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_1_0_11,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_AUNZ_UBL_1_0_11,
                                                                                                          aNSCtxCreditNote)));
    }
  }
}
