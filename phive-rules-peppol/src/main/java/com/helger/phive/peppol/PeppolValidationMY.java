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
 * Peppol Malaysia validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationMY
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationMY.class.getClassLoader ();
  }

  private static final String BASE_PATH = "external/schematron/pint-my/";
  private static final String GROUP_ID = "org.peppol.pint.my";

  // 1.0.0
  public static final VESID VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_0_0 = new VESID (GROUP_ID, "invoice", "1.0.0");
  public static final VESID VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_0_0 = new VESID (GROUP_ID, "creditnote", "1.0.0");
  public static final VESID VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_0_0 = new VESID (GROUP_ID,
                                                                                               "invoice-self-billing",
                                                                                               "1.0.0");
  public static final VESID VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_0_0 = new VESID (GROUP_ID,
                                                                                                   "creditnote-self-billing",
                                                                                                   "1.0.0");

  private PeppolValidationMY ()
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

    final boolean bNotDeprecated = false;

    // 1.0.0
    {
      final ClassPathResource aCPRBilling = new ClassPathResource (BASE_PATH +
                                                                   "1.0.0/xslt/billing/PINT-jurisdiction-aligned-rules.xslt",
                                                                   _getCL ());
      final ClassPathResource aCPRSelfBilling = new ClassPathResource (BASE_PATH +
                                                                       "1.0.0/xslt/selfbilling/PINT-jurisdiction-aligned-rules.xslt",
                                                                       _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_0_0,
                                                                             "Malaysia PINT Invoice (UBL) 1.0.0",
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (PeppolValidationPINT.RES_OPENPEPPOL_PINT_1_0_1,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (aCPRBilling,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_0_0,
                                                                             "Malaysia PINT Credit Note (UBL) 1.0.0",
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (PeppolValidationPINT.RES_OPENPEPPOL_PINT_1_0_1,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (aCPRBilling,
                                                                                                                      aNSCtxCreditNote)));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_0_0,
                                                                             "Malaysia PINT Invoice Self-Billing (UBL) 1.0.0",
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (PeppolValidationPINT.RES_OPENPEPPOL_PINT_1_0_1,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (aCPRSelfBilling,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_0_0,
                                                                             "Malaysia PINT Credit Note Self-Billing (UBL) 1.0.0",
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (PeppolValidationPINT.RES_OPENPEPPOL_PINT_1_0_1,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (aCPRSelfBilling,
                                                                                                                      aNSCtxCreditNote)));
    }
  }
}
