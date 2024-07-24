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
 * Peppol Japan validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationPintJP
{
  public static final String GROUP_ID = "org.peppol.pint.jp";
  private static final String BASE_PATH = "external/schematron/pint-jp/";

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPintJP.class.getClassLoader ();
  }

  // 0.1.2 (typo in group ID)
  @Deprecated
  public static final VESID VID_OPENPEPPOL_JP_PINT_INVOICE_012 = new VESID ("org.peppol.jp.pint", "invoice", "0.1.2");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_012 = new VESID ("org.peppol.jp.pint",
                                                                                "credit-note",
                                                                                "0.1.2");

  // 1.0.2
  public static final VESID VID_OPENPEPPOL_JP_PINT_INVOICE_1_0_2 = new VESID (GROUP_ID, "invoice", "1.0.2");
  public static final VESID VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_0_2 = new VESID (GROUP_ID, "credit-note", "1.0.2");

  private PeppolValidationPintJP ()
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

    final boolean bDeprecated = false;
    final boolean bNotDeprecated = false;

    // 0.1.2
    {
      final ClassPathResource aCPR1 = new ClassPathResource (BASE_PATH +
                                                             "0.1.2/xslt/PINT-UBL-validation-preprocessed.xslt",
                                                             _getCL ());
      final ClassPathResource aCPR2 = new ClassPathResource (BASE_PATH +
                                                             "0.1.2/xslt/PINT-jurisdiction-aligned-rules.xslt",
                                                             _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_JP_PINT_INVOICE_012,
                                                                             "Peppol PINT Japan Invoice (UBL) 0.1.2",
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (aCPR1,
                                                                                                                      aNSCtxInvoice),
                                                                             ValidationExecutorSchematron.createXSLT (aCPR2,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_012,
                                                                             "Peppol PINT Japan Credit Note (UBL) 0.1.2",
                                                                             _createStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (aCPR1,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (aCPR2,
                                                                                                                      aNSCtxCreditNote)));
    }

    // 1.0.2
    {
      final ClassPathResource aCPR2 = new ClassPathResource (BASE_PATH +
                                                             "1.0.2/xslt/PINT-jurisdiction-aligned-rules.xslt",
                                                             _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_JP_PINT_INVOICE_1_0_2,
                                                                             "Peppol PINT Japan Invoice (UBL) 1.0.2",
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (PeppolValidationPint.RES_OPENPEPPOL_PINT_1_0_1,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (aCPR2,
                                                                                                                      aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_0_2,
                                                                             "Peppol PINT Japan Credit Note (UBL) 1.0.2",
                                                                             _createStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             ValidationExecutorSchematron.createXSLT (PeppolValidationPint.RES_OPENPEPPOL_PINT_1_0_1,
                                                                                                                      aNSCtxCreditNote),
                                                                             ValidationExecutorSchematron.createXSLT (aCPR2,
                                                                                                                      aNSCtxCreditNote)));
    }
  }
}
