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
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Peppol PINT Japan Self-Billing validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationPintJP_SB
{
  public static final String GROUP_ID = PeppolValidationPintJP.GROUP_ID + ".sb";

  // 1.0.1
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                 "invoice",
                                                                                                                 "1.0.1");
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "credit-note",
                                                                                                                     "1.0.1");

  private PeppolValidationPintJP_SB ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPintJP_SB.class.getClassLoader ();
  }

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final String BASE_PATH = "external/schematron/pint-jp-sb/";

    // final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // 1.0.1
    {
      final ClassPathResource aCPR1 = new ClassPathResource (BASE_PATH +
                                                             "1.0.1/xslt/PINT-UBL-validation-preprocessed.xslt",
                                                             _getCL ());
      final ClassPathResource aCPR2 = new ClassPathResource (BASE_PATH +
                                                             "1.0.1/xslt/PINT-jurisdiction-aligned-rules.xslt",
                                                             _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_JP_PINT_SB_INVOICE_1_0_1,
                                                                             "Peppol PINT Japan Self Billing Invoice (UBL) 1.0.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             PhiveRulesHelper.createXSLT (aCPR1,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aCPR2,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_JP_PINT_SB_CREDIT_NOTE_1_0_1,
                                                                             "Peppol PINT Japan Self Billing Credit Note (UBL) 1.0.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             PhiveRulesHelper.createXSLT (aCPR1,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aCPR2,
                                                                                                          aNSCtxCreditNote)));
    }
  }
}