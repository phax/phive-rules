/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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
 * Peppol Singapore (SG) validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationSG
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationSG.class.getClassLoader ();
  }

  private static final String BASE_PATH = "external/schematron/peppol-sg/";

  // 1.0.2
  @Deprecated
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                "invoice",
                                                                                "1.0.2");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                    "creditnote",
                                                                                    "1.0.2");

  // 1.0.3
  @Deprecated
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                "invoice",
                                                                                "1.0.3");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                    "creditnote",
                                                                                    "1.0.3");

  // 2023.7
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_07 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                    "invoice",
                                                                                    "2023.7");
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_07 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                        "creditnote",
                                                                                        "2023.7");

  private PeppolValidationSG ()
  {}

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PeppolValidation.createUBLNSContext (UBL21Marshaller.invoice ()
                                                                                                       .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PeppolValidation.createUBLNSContext (UBL21Marshaller.creditNote ()
                                                                                                          .getRootElementNamespaceURI ());

    // For better error messages (merge both)
    SchematronNamespaceBeautifier.addMappings (aNSCtxCreditNote);

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // 1.0.2
    {
      final IReadableResource BIS3_BILLING_SG_CEN_102 = new ClassPathResource (BASE_PATH +
                                                                               "1.0.2/xslt/CEN-EN16931-UBL-SG-Conformant.xslt",
                                                                               _getCL ());
      final IReadableResource BIS3_BILLING_SG_PEPPOL_102 = new ClassPathResource (BASE_PATH +
                                                                                  "1.0.2/xslt/PEPPOL-EN16931-UBL-SG-Conformant.xslt",
                                                                                  _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102,
                                                                             "SG Peppol BIS3 Invoice (UBL) 1.0.2",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_CEN_102,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_PEPPOL_102,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102,
                                                                             "SG Peppol BIS3 CreditNote (UBL) 1.0.2",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_CEN_102,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_PEPPOL_102,
                                                                                                                      aNSCtxCreditNote)));
    }

    // 1.0.3
    {
      final IReadableResource BIS3_BILLING_SG_CEN_103 = new ClassPathResource (BASE_PATH +
                                                                               "1.0.3/xslt/CEN-EN16931-UBL-SG-Conformant.xslt",
                                                                               _getCL ());
      final IReadableResource BIS3_BILLING_SG_PEPPOL_103 = new ClassPathResource (BASE_PATH +
                                                                                  "1.0.3/xslt/PEPPOL-EN16931-UBL-SG-Conformant.xslt",
                                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103,
                                                                             "SG Peppol BIS3 Invoice (UBL) 1.0.3",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_CEN_103,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_PEPPOL_103,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103,
                                                                             "SG Peppol BIS3 CreditNote (UBL) 1.0.3",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_CEN_103,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_PEPPOL_103,
                                                                                                                      aNSCtxCreditNote)));
    }

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

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_07,
                                                                             "SG Peppol BIS3 Invoice (UBL) 2023.7",
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_CEN_2023_07,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_PEPPOL_2023_07,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_2023_07,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_07,
                                                                             "SG Peppol BIS3 CreditNote (UBL) 2023.7",
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_CEN_2023_07,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_PEPPOL_2023_07,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_2023_07,
                                                                                                                      aNSCtxInvoice)));
    }
  }
}
