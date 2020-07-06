/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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
package com.helger.bdve.peppol;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.bdve.api.EValidationType;
import com.helger.bdve.api.artefact.ValidationArtefact;
import com.helger.bdve.api.executorset.IValidationExecutorSetRegistry;
import com.helger.bdve.api.executorset.VESID;
import com.helger.bdve.api.executorset.ValidationExecutorSet;
import com.helger.bdve.engine.schematron.SchematronNamespaceBeautifier;
import com.helger.bdve.engine.schematron.ValidationExecutorSchematron;
import com.helger.bdve.engine.source.IValidationSourceXML;
import com.helger.bdve.engine.xsd.ValidationExecutorXSD;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.ubl21.EUBL21DocumentType;
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

  // 1.0.0 aka 1
  @Deprecated
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_100 = new VESID ("eu.peppol.bis3.sg.ubl", "invoice", "1");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_100 = new VESID ("eu.peppol.bis3.sg.ubl", "creditnote", "1");
  @Deprecated
  public static final IReadableResource BIS3_BILLING_SG_CEN_100 = new ClassPathResource ("/sg-peppol/1.0.0/xslt/CEN-EN16931-UBL-SG-Conformant.xslt",
                                                                                         _getCL ());
  @Deprecated
  public static final IReadableResource BIS3_BILLING_SG_PEPPOL_100 = new ClassPathResource ("/sg-peppol/1.0.0/xslt/PEPPOL-EN16931-UBL-SG-Conformant.xslt",
                                                                                            _getCL ());

  // 1.0.2
  @Deprecated
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102 = new VESID ("eu.peppol.bis3.sg.ubl", "invoice", "1.0.2");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102 = new VESID ("eu.peppol.bis3.sg.ubl", "creditnote", "1.0.2");
  @Deprecated
  public static final IReadableResource BIS3_BILLING_SG_CEN_102 = new ClassPathResource ("/sg-peppol/1.0.2/xslt/CEN-EN16931-UBL-SG-Conformant.xslt",
                                                                                         _getCL ());
  @Deprecated
  public static final IReadableResource BIS3_BILLING_SG_PEPPOL_102 = new ClassPathResource ("/sg-peppol/1.0.2/xslt/PEPPOL-EN16931-UBL-SG-Conformant.xslt",
                                                                                            _getCL ());

  // 1.0.3
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103 = new VESID ("eu.peppol.bis3.sg.ubl", "invoice", "1.0.3");
  public static final VESID VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103 = new VESID ("eu.peppol.bis3.sg.ubl", "creditnote", "1.0.3");
  public static final IReadableResource BIS3_BILLING_SG_CEN_103 = new ClassPathResource ("/sg-peppol/1.0.3/xslt/CEN-EN16931-UBL-SG-Conformant.xslt",
                                                                                         _getCL ());
  public static final IReadableResource BIS3_BILLING_SG_PEPPOL_103 = new ClassPathResource ("/sg-peppol/1.0.3/xslt/PEPPOL-EN16931-UBL-SG-Conformant.xslt",
                                                                                            _getCL ());

  private PeppolValidationSG ()
  {}

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PeppolValidation.createUBLNSContext (EUBL21DocumentType.INVOICE.getNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PeppolValidation.createUBLNSContext (EUBL21DocumentType.CREDIT_NOTE.getNamespaceURI ());

    // For better error messages (merge both)
    SchematronNamespaceBeautifier.addMappings (aNSCtxCreditNote);

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // 1.0.0
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_100,
                                                                           "SG PEPPOL BIS3 Invoice (UBL) 1.0.0",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           new ValidationExecutorSchematron (new ValidationArtefact (EValidationType.SCHEMATRON_XSLT,
                                                                                                                                     BIS3_BILLING_SG_CEN_100),
                                                                                                             null,
                                                                                                             aNSCtxInvoice),
                                                                           new ValidationExecutorSchematron (new ValidationArtefact (EValidationType.SCHEMATRON_XSLT,
                                                                                                                                     BIS3_BILLING_SG_PEPPOL_100),
                                                                                                             null,
                                                                                                             aNSCtxInvoice)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_100,
                                                                           "SG PEPPOL BIS3 CreditNote (UBL) 1.0.0",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           new ValidationExecutorSchematron (new ValidationArtefact (EValidationType.SCHEMATRON_XSLT,
                                                                                                                                     BIS3_BILLING_SG_CEN_100),
                                                                                                             null,
                                                                                                             aNSCtxCreditNote),
                                                                           new ValidationExecutorSchematron (new ValidationArtefact (EValidationType.SCHEMATRON_XSLT,
                                                                                                                                     BIS3_BILLING_SG_PEPPOL_100),
                                                                                                             null,
                                                                                                             aNSCtxCreditNote)));

    // 1.0.2
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102,
                                                                           "SG PEPPOL BIS3 Invoice (UBL) 1.0.2",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           new ValidationExecutorSchematron (new ValidationArtefact (EValidationType.SCHEMATRON_XSLT,
                                                                                                                                     BIS3_BILLING_SG_CEN_102),
                                                                                                             null,
                                                                                                             aNSCtxInvoice),
                                                                           new ValidationExecutorSchematron (new ValidationArtefact (EValidationType.SCHEMATRON_XSLT,
                                                                                                                                     BIS3_BILLING_SG_PEPPOL_102),
                                                                                                             null,
                                                                                                             aNSCtxInvoice)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102,
                                                                           "SG PEPPOL BIS3 CreditNote (UBL) 1.0.2",
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           new ValidationExecutorSchematron (new ValidationArtefact (EValidationType.SCHEMATRON_XSLT,
                                                                                                                                     BIS3_BILLING_SG_CEN_102),
                                                                                                             null,
                                                                                                             aNSCtxCreditNote),
                                                                           new ValidationExecutorSchematron (new ValidationArtefact (EValidationType.SCHEMATRON_XSLT,
                                                                                                                                     BIS3_BILLING_SG_PEPPOL_102),
                                                                                                             null,
                                                                                                             aNSCtxCreditNote)));

    // 1.0.3
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103,
                                                                           "SG PEPPOL BIS3 Invoice (UBL) 1.0.3",
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           new ValidationExecutorSchematron (new ValidationArtefact (EValidationType.SCHEMATRON_XSLT,
                                                                                                                                     BIS3_BILLING_SG_CEN_103),
                                                                                                             null,
                                                                                                             aNSCtxInvoice),
                                                                           new ValidationExecutorSchematron (new ValidationArtefact (EValidationType.SCHEMATRON_XSLT,
                                                                                                                                     BIS3_BILLING_SG_PEPPOL_103),
                                                                                                             null,
                                                                                                             aNSCtxInvoice)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103,
                                                                           "SG PEPPOL BIS3 CreditNote (UBL) 1.0.3",
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           new ValidationExecutorSchematron (new ValidationArtefact (EValidationType.SCHEMATRON_XSLT,
                                                                                                                                     BIS3_BILLING_SG_CEN_103),
                                                                                                             null,
                                                                                                             aNSCtxCreditNote),
                                                                           new ValidationExecutorSchematron (new ValidationArtefact (EValidationType.SCHEMATRON_XSLT,
                                                                                                                                     BIS3_BILLING_SG_PEPPOL_103),
                                                                                                             null,
                                                                                                             aNSCtxCreditNote)));
  }
}
