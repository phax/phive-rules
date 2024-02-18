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
import com.helger.diver.api.version.VESID;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.xml.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
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
public final class PeppolValidationAUNZ
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationAUNZ.class.getClassLoader ();
  }

  private static final String BASE_PATH = "external/schematron/peppol-aunz/";

  // 1.0.9
  public static final VESID VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_109 = new VESID ("eu.peppol.bis3.aunz.ubl",
                                                                                  "invoice",
                                                                                  "1.0.9");
  public static final VESID VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_109 = new VESID ("eu.peppol.bis3.aunz.ubl",
                                                                                               "invoice-self-billing",
                                                                                               "1.0.9");
  public static final VESID VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_109 = new VESID ("eu.peppol.bis3.aunz.ubl",
                                                                                      "creditnote",
                                                                                      "1.0.9");
  public static final VESID VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_109 = new VESID ("eu.peppol.bis3.aunz.ubl",
                                                                                                   "creditnote-self-billing",
                                                                                                   "1.0.9");

  // 1.0.10
  public static final VESID VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_1_0_10 = new VESID ("eu.peppol.bis3.aunz.ubl",
                                                                                     "invoice",
                                                                                     "1.0.10");
  public static final VESID VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_10 = new VESID ("eu.peppol.bis3.aunz.ubl",
                                                                                                  "invoice-self-billing",
                                                                                                  "1.0.10");
  public static final VESID VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_10 = new VESID ("eu.peppol.bis3.aunz.ubl",
                                                                                         "creditnote",
                                                                                         "1.0.10");
  public static final VESID VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_10 = new VESID ("eu.peppol.bis3.aunz.ubl",
                                                                                                      "creditnote-self-billing",
                                                                                                      "1.0.10");

  private PeppolValidationAUNZ ()
  {}

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PeppolValidation.createUBLNSContext (UBL21Marshaller.invoice ()
                                                                                                       .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PeppolValidation.createUBLNSContext (UBL21Marshaller.creditNote ()
                                                                                                          .getRootElementNamespaceURI ());

    // For better error messages (merge both)
    SchematronNamespaceBeautifier.addMappings (aNSCtxCreditNote.getClone ().setMappings (aNSCtxInvoice));

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

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
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_109,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_UBL_109,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_109,
                                                                             "A-NZ Peppol BIS3 CreditNote (UBL) " +
                                                                                                                           sVersion109,
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_109,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_UBL_109,
                                                                                                                      aNSCtxCreditNote)));

      // Self-billing
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_109,
                                                                             "A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " +
                                                                                                                                    sVersion109,
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_109,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_UBL_109,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_109,
                                                                             "A-NZ Peppol BIS3 CreditNote Self-Billing (UBL) " +
                                                                                                                                        sVersion109,
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_109,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_UBL_109,
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
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_1_0_10,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_UBL_1_0_10,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_1_0_10,
                                                                             "A-NZ Peppol BIS3 CreditNote (UBL) " +
                                                                                                                              sVersion1010,
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_1_0_10,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_UBL_1_0_10,
                                                                                                                      aNSCtxCreditNote)));

      // Self-billing
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_INVOICE_SELF_BILLING_1_0_10,
                                                                             "A-NZ Peppol BIS3 Invoice Self-Billing (UBL) " +
                                                                                                                                       sVersion1010,
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_1_0_10,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_UBL_1_0_10,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_AUNZ_UBL_CREDIT_NOTE_SELF_BILLING_1_0_10,
                                                                             "A-NZ Peppol BIS3 CreditNote Self-Billing (UBL) " +
                                                                                                                                           sVersion1010,
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_PEPPOL_SELF_BILLING_1_0_10,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_AUNZ_UBL_1_0_10,
                                                                                                                      aNSCtxCreditNote)));
    }
  }
}
