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
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatus;
import com.helger.phive.xml.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Peppol Singapore (SG) validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationBisSG
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationBisSG.class.getClassLoader ();
  }

  private static final String BASE_PATH = "external/schematron/peppol-sg/";

  // 2023.7
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_7 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                   "invoice",
                                                                                   "2023.7");
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_7 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                       "creditnote",
                                                                                       "2023.7");

  // 2023.12
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_12 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                    "invoice",
                                                                                    "2023.12");
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_12 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                        "creditnote",
                                                                                        "2023.12");

  private PeppolValidationBisSG ()
  {}

  @Nonnull
  private static IValidationExecutorSetStatus _createStatus (final boolean bIsDeprecated)
  {
    return ValidationExecutorSetStatus.createDeprecatedNow (bIsDeprecated);
  }

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PeppolValidation.createUBLNSContext (UBL21Marshaller.invoice ()
                                                                                                       .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PeppolValidation.createUBLNSContext (UBL21Marshaller.creditNote ()
                                                                                                          .getRootElementNamespaceURI ());

    // For better error messages (merge both)
    SchematronNamespaceBeautifier.addMappings (aNSCtxCreditNote);

    @SuppressWarnings ("unused")
    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // 2023.7
    {
      final IReadableResource BIS3_BILLING_SG_CEN_2023_07 = new ClassPathResource (BASE_PATH +
                                                                                   "2023.7/xslt/SG-Subset-CEN-EN16931-UBL.xslt",
                                                                                   _getCL ());
      final IReadableResource BIS3_BILLING_SG_PEPPOL_2023_07 = new ClassPathResource (BASE_PATH +
                                                                                      "2023.7/xslt/SG-Subset-PEPPOL-EN16931-UBL.xslt",
                                                                                      _getCL ());
      final IReadableResource BIS3_BILLING_SG_2023_07 = new ClassPathResource (BASE_PATH +
                                                                               "2023.7/xslt/SG-Billing3-UBL.xslt",
                                                                               _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_7,
                                                                             "SG Peppol BIS3 Invoice (UBL) 2023.7",
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_CEN_2023_07,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_PEPPOL_2023_07,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_2023_07,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_7,
                                                                             "SG Peppol BIS3 Credit Note (UBL) 2023.7",
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_CEN_2023_07,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_PEPPOL_2023_07,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_2023_07,
                                                                                                                      aNSCtxCreditNote)));
    }

    // 2023.12
    {
      final IReadableResource BIS3_BILLING_SG_CEN_2023_12 = new ClassPathResource (BASE_PATH +
                                                                                   "2023.12/xslt/SG-Subset-CEN-EN16931-UBL.xslt",
                                                                                   _getCL ());
      final IReadableResource BIS3_BILLING_SG_PEPPOL_2023_12 = new ClassPathResource (BASE_PATH +
                                                                                      "2023.12/xslt/SG-Subset-PEPPOL-EN16931-UBL.xslt",
                                                                                      _getCL ());
      final IReadableResource BIS3_BILLING_SG_2023_12 = new ClassPathResource (BASE_PATH +
                                                                               "2023.12/xslt/SG-Billing3-UBL.xslt",
                                                                               _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_12,
                                                                             "SG Peppol BIS3 Invoice (UBL) 2023.12",
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_CEN_2023_12,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_PEPPOL_2023_12,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_2023_12,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_12,
                                                                             "SG Peppol BIS3 Credit Note (UBL) 2023.12",
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_CEN_2023_12,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_PEPPOL_2023_12,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_2023_12,
                                                                                                                      aNSCtxCreditNote)));
    }
  }
}
