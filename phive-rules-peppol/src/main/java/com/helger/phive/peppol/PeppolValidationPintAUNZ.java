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
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatus;
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
public final class PeppolValidationPintAUNZ
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPintAUNZ.class.getClassLoader ();
  }

  private static final String BASE_PATH = "external/schematron/pint-aunz/";
  private static final String GROUP_ID = "org.peppol.pint.aunz";

  // 1.0.1
  public static final VESID VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_0_1 = new VESID (GROUP_ID, "invoice", "1.0.1");
  public static final VESID VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_0_1 = new VESID (GROUP_ID,
                                                                                        "creditnote",
                                                                                        "1.0.1");

  private PeppolValidationPintAUNZ ()
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

    final boolean bNotDeprecated = false;

    // 1.0.1
    {
      final String sBase = BASE_PATH + "1.0.1/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_0_1,
                                                                             "AU-NZ PINT Invoice (UBL) 1.0.1",
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sBase +
                                                                                                                                             "PINT-UBL-validation-preprocessed-inv.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sBase +
                                                                                                                                             "PINT-jurisdiction-aligned-rules-inv.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_0_1,
                                                                             "AU-NZ PINT Credit Note (UBL) 1.0.1",
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sBase +
                                                                                                                                             "PINT-UBL-validation-preprocessed-cn.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (sBase +
                                                                                                                                             "PINT-jurisdiction-aligned-rules-cn.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      aNSCtxInvoice)));

    }
  }
}
