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
package com.helger.phive.peppol.legacy;

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
public final class PeppolLegacyValidationSG
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolLegacyValidationSG.class.getClassLoader ();
  }

  private static final String BASE_PATH = "external/schematron/peppol-sg/";

  // 1.0.0 aka 1
  @Deprecated
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_100 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                "invoice",
                                                                                "1");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_100 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                    "creditnote",
                                                                                    "1");

  // 1.0.2
  @Deprecated
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                "invoice",
                                                                                "1.0.2");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102 = new VESID ("eu.peppol.bis3.sg.ubl",
                                                                                    "creditnote",
                                                                                    "1.0.2");

  private PeppolLegacyValidationSG ()
  {}

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PeppolLegacyValidation.createUBLNSContext (UBL21Marshaller.invoice ()
                                                                                                             .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PeppolLegacyValidation.createUBLNSContext (UBL21Marshaller.creditNote ()
                                                                                                                .getRootElementNamespaceURI ());

    // For better error messages (merge both)
    SchematronNamespaceBeautifier.addMappings (aNSCtxCreditNote);

    final boolean bDeprecated = true;

    // 1.0.0
    {
      final IReadableResource BIS3_BILLING_SG_CEN_100 = new ClassPathResource (BASE_PATH +
                                                                               "1.0.0/xslt/CEN-EN16931-UBL-SG-Conformant.xslt",
                                                                               _getCL ());
      final IReadableResource BIS3_BILLING_SG_PEPPOL_100 = new ClassPathResource (BASE_PATH +
                                                                                  "1.0.0/xslt/PEPPOL-EN16931-UBL-SG-Conformant.xslt",
                                                                                  _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_100,
                                                                             "SG Peppol BIS3 Invoice (UBL) 1.0.0",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_CEN_100,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_PEPPOL_100,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_100,
                                                                             "SG Peppol BIS3 CreditNote (UBL) 1.0.0",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_CEN_100,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (BIS3_BILLING_SG_PEPPOL_100,
                                                                                                                      aNSCtxCreditNote)));
    }

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
  }
}
