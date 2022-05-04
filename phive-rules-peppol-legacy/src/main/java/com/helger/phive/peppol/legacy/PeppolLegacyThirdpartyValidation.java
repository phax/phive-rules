/*
 * Copyright (C) 2014-2022 Philip Helger (www.helger.com)
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

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.engine.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.engine.schematron.ValidationExecutorSchematron;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.ubl21.EUBL21DocumentType;
import com.helger.ubl21.UBL21NamespaceContext;

public class PeppolLegacyThirdpartyValidation
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolLegacyThirdpartyValidation.class.getClassLoader ();
  }

  private static final String BASE_PATH = "schematron/peppol-thirdparty/";

  // Third-party
  public static final VESID VID_OPENPEPPOL_T10_AT_NAT = new VESID ("eu.peppol.bis2", "t10", "6", "at");
  public static final VESID VID_OPENPEPPOL_T10_AT_GOV = new VESID ("eu.peppol.bis2", "t10", "8", "at-gov");
  public static final VESID VID_OPENPEPPOL_T14_AT_NAT = new VESID ("eu.peppol.bis2", "t14", "6", "at");
  public static final VESID VID_OPENPEPPOL_T14_AT_GOV = new VESID ("eu.peppol.bis2", "t14", "8", "at-gov");

  public static final ClassPathResource INVOICE_AT_NAT = new ClassPathResource (BASE_PATH +
                                                                                "atnat-invoice/atnat-invoice-ubl.xslt",
                                                                                _getCL ());
  public static final ClassPathResource INVOICE_AT_GOV = new ClassPathResource (BASE_PATH +
                                                                                "atgov-invoice/atgov-invoice-ubl.xslt",
                                                                                _getCL ());

  public static final ClassPathResource CREDIT_NOTE_AT_NAT = new ClassPathResource (BASE_PATH +
                                                                                    "atnat-creditnote/atnat-creditnote-ubl.xslt",
                                                                                    _getCL ());
  public static final ClassPathResource CREDIT_NOTE_AT_GOV = new ClassPathResource (BASE_PATH +
                                                                                    "atgov-creditnote/atgov-creditnote-ubl.xslt",
                                                                                    _getCL ());

  private PeppolLegacyThirdpartyValidation ()
  {}

  @SuppressWarnings ("deprecation")
  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL21NamespaceContext.getInstance ());

    // Extending third-party artefacts
    final IValidationExecutorSet <IValidationSourceXML> aVESInvoice = aRegistry.getOfID (PeppolValidation370.VID_OPENPEPPOL_T10_V2);
    final IValidationExecutorSet <IValidationSourceXML> aVESCreditNote = aRegistry.getOfID (PeppolValidation370.VID_OPENPEPPOL_T14_V2);
    if (aVESInvoice == null || aVESCreditNote == null)
      throw new IllegalStateException ("Standard Peppol artefacts must be registered before third-party artefacts!");

    final String sPreReqInvoice = "/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'";
    final String sPreReqCreditNote = "/ubl:CreditNote/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AT'";

    final boolean bNotDeprecated = false;
    // Invoice
    final IValidationExecutorSet <IValidationSourceXML> aVESInvoiceAT = ValidationExecutorSet.createDerived (aVESInvoice,
                                                                                                             VID_OPENPEPPOL_T10_AT_NAT,
                                                                                                             "OpenPeppol Invoice (Austria)",
                                                                                                             bNotDeprecated,
                                                                                                             ValidationExecutorSchematron.createXSLT (INVOICE_AT_NAT,
                                                                                                                                                      sPreReqInvoice,
                                                                                                                                                      PeppolLegacyValidation.createUBLNSContext (EUBL21DocumentType.INVOICE.getNamespaceURI ())));
    aRegistry.registerValidationExecutorSet (aVESInvoiceAT);
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESInvoiceAT,
                                                                                  VID_OPENPEPPOL_T10_AT_GOV,
                                                                                  "OpenPeppol Invoice (Austrian Government)",
                                                                                  bNotDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (INVOICE_AT_GOV,
                                                                                                                           sPreReqInvoice,
                                                                                                                           PeppolLegacyValidation.createUBLNSContext (EUBL21DocumentType.INVOICE.getNamespaceURI ()))));

    // CreditNote
    final IValidationExecutorSet <IValidationSourceXML> aVESCreditNoteAT = ValidationExecutorSet.createDerived (aVESCreditNote,
                                                                                                                VID_OPENPEPPOL_T14_AT_NAT,
                                                                                                                "OpenPeppol Credit Note (Austria)",
                                                                                                                bNotDeprecated,
                                                                                                                ValidationExecutorSchematron.createXSLT (CREDIT_NOTE_AT_NAT,
                                                                                                                                                         sPreReqCreditNote,
                                                                                                                                                         PeppolLegacyValidation.createUBLNSContext (EUBL21DocumentType.CREDIT_NOTE.getNamespaceURI ())));
    aRegistry.registerValidationExecutorSet (aVESCreditNoteAT);
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESCreditNoteAT,
                                                                                  VID_OPENPEPPOL_T14_AT_GOV,
                                                                                  "OpenPeppol Credit Note (Austrian Government)",
                                                                                  bNotDeprecated,
                                                                                  ValidationExecutorSchematron.createXSLT (CREDIT_NOTE_AT_GOV,
                                                                                                                           sPreReqCreditNote,
                                                                                                                           PeppolLegacyValidation.createUBLNSContext (EUBL21DocumentType.CREDIT_NOTE.getNamespaceURI ()))));
  }

}
