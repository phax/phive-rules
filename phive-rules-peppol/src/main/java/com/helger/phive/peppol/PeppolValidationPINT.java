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
 * Peppol PINT validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationPINT
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPINT.class.getClassLoader ();
  }

  private static final String BASE_PATH = "external/schematron/pint/";

  // 1.0.0
  @Deprecated
  public static final ClassPathResource RES_OPENPEPPOL_PINT_1_0_0 = new ClassPathResource (BASE_PATH +
                                                                                           "1.0.0/xslt/PINT-UBL-validation-preprocessed.xslt",
                                                                                           _getCL ());
  @Deprecated
  public static final VESID VID_OPENPEPPOL_PINT_INVOICE_1_0_0 = new VESID ("org.peppol.pint", "invoice", "1.0.0");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_0_0 = new VESID ("org.peppol.pint",
                                                                               "credit-note",
                                                                               "1.0.0");

  // 1.0.1
  public static final ClassPathResource RES_OPENPEPPOL_PINT_1_0_1 = new ClassPathResource (BASE_PATH +
                                                                                           "1.0.1/xslt/PINT-UBL-validation-preprocessed.xslt",
                                                                                           _getCL ());
  public static final VESID VID_OPENPEPPOL_PINT_INVOICE_1_0_1 = new VESID ("org.peppol.pint", "invoice", "1.0.1");
  public static final VESID VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_0_1 = new VESID ("org.peppol.pint",
                                                                               "credit-note",
                                                                               "1.0.1");

  private PeppolValidationPINT ()
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

    // 1.0.0
    {
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_PINT_INVOICE_1_0_0,
                                                                             "OpenPeppol PINT Invoice (UBL) 1.0.0",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (RES_OPENPEPPOL_PINT_1_0_0,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_0_0,
                                                                             "OpenPeppol PINT Credit Note (UBL) 1.0.0",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (RES_OPENPEPPOL_PINT_1_0_0,
                                                                                                                      aNSCtxCreditNote)));
    }

    // 1.0.1
    {
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_PINT_INVOICE_1_0_1,
                                                                             "OpenPeppol PINT Invoice (UBL) 1.0.1",
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (RES_OPENPEPPOL_PINT_1_0_1,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_0_1,
                                                                             "OpenPeppol PINT Credit Note (UBL) 1.0.1",
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (RES_OPENPEPPOL_PINT_1_0_1,
                                                                                                                      aNSCtxCreditNote)));
    }
  }
}
