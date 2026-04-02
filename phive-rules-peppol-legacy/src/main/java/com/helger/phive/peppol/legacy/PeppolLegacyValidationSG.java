/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Peppol Singapore (SG) validation configuration
 *
 * @author Philip Helger
 */
@Immutable
@Deprecated (forRemoval = false)
public final class PeppolLegacyValidationSG
{
  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolLegacyValidationSG.class.getClassLoader ();
  }

  private static final String BASE_PATH = "external/schematron/peppol-sg/";

  // 1.0.0 aka 1
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_100 = PhiveRulesHelper.createCoordinate ("eu.peppol.bis3.sg.ubl",
                                                                                                                "invoice",
                                                                                                                "1");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_100 = PhiveRulesHelper.createCoordinate ("eu.peppol.bis3.sg.ubl",
                                                                                                                    "creditnote",
                                                                                                                    "1");

  // 1.0.2
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102 = PhiveRulesHelper.createCoordinate ("eu.peppol.bis3.sg.ubl",
                                                                                                                "invoice",
                                                                                                                "1.0.2");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102 = PhiveRulesHelper.createCoordinate ("eu.peppol.bis3.sg.ubl",
                                                                                                                    "creditnote",
                                                                                                                    "1.0.2");

  // 1.0.3
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103 = PhiveRulesHelper.createCoordinate ("eu.peppol.bis3.sg.ubl",
                                                                                                                "invoice",
                                                                                                                "1.0.3");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103 = PhiveRulesHelper.createCoordinate ("eu.peppol.bis3.sg.ubl",
                                                                                                                    "creditnote",
                                                                                                                    "1.0.3");

  private PeppolLegacyValidationSG ()
  {}

  @Deprecated (forRemoval = false)
  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    // 1.0.0
    {
      final IReadableResource BIS3_BILLING_SG_CEN_100 = new ClassPathResource (BASE_PATH +
                                                                               "1.0.0/xslt/CEN-EN16931-UBL-SG-Conformant.xslt",
                                                                               _getCL ());
      final IReadableResource BIS3_BILLING_SG_PEPPOL_100 = new ClassPathResource (BASE_PATH +
                                                                                  "1.0.0/xslt/PEPPOL-EN16931-UBL-SG-Conformant.xslt",
                                                                                  _getCL ());

      VesXmlBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_100)
                       .displayName ("SG Peppol BIS3 Invoice (UBL) 1.0.0")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_100, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_100, aNSCtxInvoice))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_100)
                       .displayName ("SG Peppol BIS3 Credit Note (UBL) 1.0.0")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_100, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_100, aNSCtxCreditNote))
                       .registerInto (aRegistry);
    }

    // 1.0.2
    {
      final IReadableResource BIS3_BILLING_SG_CEN_102 = new ClassPathResource (BASE_PATH +
                                                                               "1.0.2/xslt/CEN-EN16931-UBL-SG-Conformant.xslt",
                                                                               _getCL ());
      final IReadableResource BIS3_BILLING_SG_PEPPOL_102 = new ClassPathResource (BASE_PATH +
                                                                                  "1.0.2/xslt/PEPPOL-EN16931-UBL-SG-Conformant.xslt",
                                                                                  _getCL ());

      VesXmlBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_102)
                       .displayName ("SG Peppol BIS3 Invoice (UBL) 1.0.2")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_102, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_102, aNSCtxInvoice))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_102)
                       .displayName ("SG Peppol BIS3 Credit Note (UBL) 1.0.2")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_102, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_102, aNSCtxCreditNote))
                       .registerInto (aRegistry);
    }

    // 1.0.3
    {
      final IReadableResource BIS3_BILLING_SG_CEN_103 = new ClassPathResource (BASE_PATH +
                                                                               "1.0.3/xslt/CEN-EN16931-UBL-SG-Conformant.xslt",
                                                                               _getCL ());
      final IReadableResource BIS3_BILLING_SG_PEPPOL_103 = new ClassPathResource (BASE_PATH +
                                                                                  "1.0.3/xslt/PEPPOL-EN16931-UBL-SG-Conformant.xslt",
                                                                                  _getCL ());
      VesXmlBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_103)
                       .displayName ("SG Peppol BIS3 Invoice (UBL) 1.0.3")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_103, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_103, aNSCtxInvoice))
                       .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_103)
                       .displayName ("SG Peppol BIS3 Credit Note (UBL) 1.0.3")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_103, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_103, aNSCtxCreditNote))
                       .registerInto (aRegistry);
    }
  }
}
