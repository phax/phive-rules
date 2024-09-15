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
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
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
public final class PeppolValidationPintMY
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPintMY.class.getClassLoader ();
  }

  private static final String BASE_PATH = "external/schematron/pint-my/";
  private static final String GROUP_ID = "org.peppol.pint.my";

  // 1.0.0
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.0");
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.0");
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.0");
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.0");

  private PeppolValidationPintMY ()
  {}

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

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
                                                                             "Peppol PINT Malaysia Invoice (UBL) 1.0.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (PeppolValidationPint.RES_OPENPEPPOL_PINT_1_0_1,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aCPRBilling,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_0_0,
                                                                             "Peppol PINT Malaysia Credit Note (UBL) 1.0.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (PeppolValidationPint.RES_OPENPEPPOL_PINT_1_0_1,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aCPRBilling,
                                                                                                          aNSCtxCreditNote)));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_0_0,
                                                                             "Peppol PINT Malaysia Invoice Self-Billing (UBL) 1.0.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (PeppolValidationPint.RES_OPENPEPPOL_PINT_1_0_1,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBilling,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_0_0,
                                                                             "Peppol PINT Malaysia Credit Note Self-Billing (UBL) 1.0.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (PeppolValidationPint.RES_OPENPEPPOL_PINT_1_0_1,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBilling,
                                                                                                          aNSCtxCreditNote)));
    }
  }
}
