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
 * Peppol Singapore validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationPintSG
{
  public static final String GROUP_ID = "org.peppol.pint.sg";

  // 1.1.0
  public static final DVRCoordinate VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.1.0");
  public static final DVRCoordinate VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.1.0");

  private PeppolValidationPintSG ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPintSG.class.getClassLoader ();
  }

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final boolean bNotDeprecated = false;

    final String BASE_PATH = "external/schematron/pint-sg/";

    // 1.0.1
    {
      final String sBaseBilling = BASE_PATH + "1.1.0/xslt/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_1_0,
                                                                             "Peppol PINT Singapore Invoice (UBL) 1.1.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed-inv.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules-inv.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_1_0,
                                                                             "Peppol PINT Singapore Credit Note (UBL) 1.1.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed-cn.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules-cn.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote)));
    }
  }
}
