/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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
 * Peppol Singapore (SG) validation configuration
 *
 * @author Philip Helger
 */
@Immutable
@Deprecated
public final class PeppolLegacyValidationSG
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolLegacyValidationSG.class.getClassLoader ();
  }

  private static final String BASE_PATH = "external/schematron/peppol-sg/";

  // 1.0.0 aka 1
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_100 = PhiveRulesHelper.createCoordinate ("eu.peppol.bis3.sg.ubl",
                                                                                                                "invoice",
                                                                                                                "1");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_100 = PhiveRulesHelper.createCoordinate ("eu.peppol.bis3.sg.ubl",
                                                                                                                    "creditnote",
                                                                                                                    "1");

  // 1.0.2
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102 = PhiveRulesHelper.createCoordinate ("eu.peppol.bis3.sg.ubl",
                                                                                                                "invoice",
                                                                                                                "1.0.2");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102 = PhiveRulesHelper.createCoordinate ("eu.peppol.bis3.sg.ubl",
                                                                                                                    "creditnote",
                                                                                                                    "1.0.2");

  // 1.0.3
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103 = PhiveRulesHelper.createCoordinate ("eu.peppol.bis3.sg.ubl",
                                                                                                                "invoice",
                                                                                                                "1.0.3");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103 = PhiveRulesHelper.createCoordinate ("eu.peppol.bis3.sg.ubl",
                                                                                                                    "creditnote",
                                                                                                                    "1.0.3");

  private PeppolLegacyValidationSG ()
  {}

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

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
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_100,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_100,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_100,
                                                                             "SG Peppol BIS3 Credit Note (UBL) 1.0.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_100,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_100,
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
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_102,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_102,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102,
                                                                             "SG Peppol BIS3 Credit Note (UBL) 1.0.2",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_102,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_102,
                                                                                                          aNSCtxCreditNote)));
    }

    // 1.0.3
    {
      final IReadableResource BIS3_BILLING_SG_CEN_103 = new ClassPathResource (BASE_PATH +
                                                                               "1.0.3/xslt/CEN-EN16931-UBL-SG-Conformant.xslt",
                                                                               _getCL ());
      final IReadableResource BIS3_BILLING_SG_PEPPOL_103 = new ClassPathResource (BASE_PATH +
                                                                                  "1.0.3/xslt/PEPPOL-EN16931-UBL-SG-Conformant.xslt",
                                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103,
                                                                             "SG Peppol BIS3 Invoice (UBL) 1.0.3",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_103,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_103,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103,
                                                                             "SG Peppol BIS3 Credit Note (UBL) 1.0.3",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_103,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_103,
                                                                                                          aNSCtxCreditNote)));
    }
  }
}
