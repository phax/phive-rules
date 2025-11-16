/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
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

  // 1.0.12
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_12 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "invoice",
                                                                                                                     "1.0.12");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_12 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                  "invoice-self-billing",
                                                                                                                                  "1.0.12");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_12 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                         "creditnote",
                                                                                                                         "1.0.12");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_12 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                      "creditnote-self-billing",
                                                                                                                                      "1.0.12");

  private PeppolValidationBisAUNZ ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationBisAUNZ.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = !bDeprecated;

    final String BASE_PATH = "external/schematron/peppol-aunz/";

    // 1.0.11
    {
      final IReadableResource aResSB = new ClassPathResource (BASE_PATH + "1.0.11/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                              _getCL ());
      final IReadableResource aResInv = new ClassPathResource (BASE_PATH + "1.0.11/xslt/AUNZ-PEPPOL-validation.xslt",
                                                               _getCL ());
      final IReadableResource aResShared = new ClassPathResource (BASE_PATH + "1.0.11/xslt/AUNZ-UBL-validation.xslt",
                                                                  _getCL ());

      final String sVersion = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_11.getVersionString ();
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_11,
                                                                             "A-NZ Peppol BIS3 Invoice (UBL) " +
                                                                                                                          sVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (aResInv,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aResShared,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_11,
                                                                             "A-NZ Peppol BIS3 Credit Note (UBL) " +
                                                                                                                              sVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (aResInv,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aResShared,
                                                                                                          aNSCtxCreditNote)));

      // Self-billing
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_11,
                                                                             "A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " +
                                                                                                                                       sVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (aResSB,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aResShared,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_11,
                                                                             "A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " +
                                                                                                                                           sVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (aResSB,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aResShared,
                                                                                                          aNSCtxCreditNote)));
    }

    // 1.0.12
    {
      final IReadableResource aResSB = new ClassPathResource (BASE_PATH + "1.0.12/xslt/AUNZ-PEPPOL-SB-validation.xslt",
                                                              _getCL ());
      final IReadableResource aResInv = new ClassPathResource (BASE_PATH + "1.0.12/xslt/AUNZ-PEPPOL-validation.xslt",
                                                               _getCL ());
      final IReadableResource aResShared = new ClassPathResource (BASE_PATH + "1.0.12/xslt/AUNZ-UBL-validation.xslt",
                                                                  _getCL ());

      final String sVersion = VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_12.getVersionString ();
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_12,
                                                                             "A-NZ Peppol BIS3 Invoice (UBL) " +
                                                                                                                          sVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (aResInv,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aResShared,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_12,
                                                                             "A-NZ Peppol BIS3 Credit Note (UBL) " +
                                                                                                                              sVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (aResInv,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aResShared,
                                                                                                          aNSCtxCreditNote)));

      // Self-billing
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_12,
                                                                             "A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " +
                                                                                                                                       sVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (aResSB,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aResShared,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_12,
                                                                             "A-NZ Peppol BIS3 Credit Note Self-Billing (UBL) " +
                                                                                                                                           sVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (aResSB,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aResShared,
                                                                                                          aNSCtxCreditNote)));
    }
  }
}
