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
package com.helger.phive.peppol;

import java.time.LocalDate;
import java.time.Month;
import java.time.OffsetDateTime;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.datetime.helper.PDTFactory;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
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
public final class PeppolValidationBisSG
{
  public static final String GROUP_ID_BIS_BILLING = "eu.peppol.bis3.sg.ubl";
  public static final String GROUP_ID_ORDER_BALANCE = "org.peppol.sg";

  // 2023.7
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_7 = PhiveRulesHelper.createCoordinate (GROUP_ID_BIS_BILLING,
                                                                                                                   "invoice",
                                                                                                                   "2023.7");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_7 = PhiveRulesHelper.createCoordinate (GROUP_ID_BIS_BILLING,
                                                                                                                       "creditnote",
                                                                                                                       "2023.7");

  // 2023.12
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_12 = PhiveRulesHelper.createCoordinate (GROUP_ID_BIS_BILLING,
                                                                                                                    "invoice",
                                                                                                                    "2023.12");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_12 = PhiveRulesHelper.createCoordinate (GROUP_ID_BIS_BILLING,
                                                                                                                        "creditnote",
                                                                                                                        "2023.12");

  // 2024.12
  public static final LocalDate VALID_PER_2024_12 = PDTFactory.createLocalDate (2025, Month.MARCH, 3);
  public static final OffsetDateTime VALID_PER_UTC_2014_12 = PDTFactory.createOffsetDateTimeUTC (VALID_PER_2024_12);
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2024_12 = PhiveRulesHelper.createCoordinate (GROUP_ID_BIS_BILLING,
                                                                                                                    "invoice",
                                                                                                                    "2024.12");
  public static final DVRCoordinate VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2024_12 = PhiveRulesHelper.createCoordinate (GROUP_ID_BIS_BILLING,
                                                                                                                        "creditnote",
                                                                                                                        "2024.12");

  // Order Balance
  public static final DVRCoordinate VID_PEPPOL_SG_ORDER_BALANCE_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID_ORDER_BALANCE,
                                                                                                         "order-balance",
                                                                                                         "1.0");

  private PeppolValidationBisSG ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationBisSG.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxOrder = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.order ()
                                                                                                          .getRootElementNamespaceURI ());

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = !bDeprecated;

    final String BASE_PATH = "external/schematron/peppol-sg/";

    // 2023.7
    {
      final IReadableResource BIS3_BILLING_SG_CEN_2023_07 = new ClassPathResource (BASE_PATH +
                                                                                   "2023.7/xslt/SG-Subset-CEN-EN16931-UBL.xslt",
                                                                                   _getCL ());
      final IReadableResource BIS3_BILLING_SG_PEPPOL_2023_07 = new ClassPathResource (BASE_PATH +
                                                                                      "2023.7/xslt/SG-Subset-PEPPOL-EN16931-UBL.xslt",
                                                                                      _getCL ());
      final IReadableResource BIS3_BILLING_SG_2023_07 = new ClassPathResource (BASE_PATH +
                                                                               "2023.7/xslt/SG-Billing3-UBL.xslt",
                                                                               _getCL ());
      final String sAkaVersionBilling = " (aka BIS 3.0.11)";

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_7,
                                                                             "SG Peppol BIS3 Invoice (UBL) 2023.7" +
                                                                                                                        sAkaVersionBilling,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_2023_07,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_2023_07,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_2023_07,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_7,
                                                                             "SG Peppol BIS3 Credit Note (UBL) 2023.7" +
                                                                                                                            sAkaVersionBilling,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_2023_07,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_2023_07,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_2023_07,
                                                                                                          aNSCtxCreditNote)));
    }

    // 2023.12
    {
      final IReadableResource BIS3_BILLING_SG_CEN_2023_12 = new ClassPathResource (BASE_PATH +
                                                                                   "2023.12/xslt/SG-Subset-CEN-EN16931-UBL.xslt",
                                                                                   _getCL ());
      final IReadableResource BIS3_BILLING_SG_PEPPOL_2023_12 = new ClassPathResource (BASE_PATH +
                                                                                      "2023.12/xslt/SG-Subset-PEPPOL-EN16931-UBL.xslt",
                                                                                      _getCL ());
      final IReadableResource BIS3_BILLING_SG_2023_12 = new ClassPathResource (BASE_PATH +
                                                                               "2023.12/xslt/SG-Billing3-UBL.xslt",
                                                                               _getCL ());
      final String sAkaVersionBilling = " (aka BIS 3.0.12)";

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2023_12,
                                                                             "SG Peppol BIS3 Invoice (UBL) 2023.12" +
                                                                                                                         sAkaVersionBilling,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_2023_12,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_2023_12,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_2023_12,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2023_12,
                                                                             "SG Peppol BIS3 Credit Note (UBL) 2023.12" +
                                                                                                                             sAkaVersionBilling,
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_2023_12,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_2023_12,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_2023_12,
                                                                                                          aNSCtxCreditNote)));
    }

    // 2024.12
    {
      final IReadableResource BIS3_BILLING_SG_CEN_2024_12 = new ClassPathResource (BASE_PATH +
                                                                                   "2024.12/xslt/SG-Subset-CEN-EN16931-UBL.xslt",
                                                                                   _getCL ());
      final IReadableResource BIS3_BILLING_SG_PEPPOL_2024_12 = new ClassPathResource (BASE_PATH +
                                                                                      "2024.12/xslt/SG-Subset-PEPPOL-EN16931-UBL.xslt",
                                                                                      _getCL ());
      final IReadableResource BIS3_BILLING_SG_2024_12 = new ClassPathResource (BASE_PATH +
                                                                               "2024.12/xslt/SG-Billing3-UBL.xslt",
                                                                               _getCL ());
      final String sAkaVersionBilling = " (aka BIS 3.0.14)";

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_INVOICE_2024_12,
                                                                             "SG Peppol BIS3 Invoice (UBL) 2024.12" +
                                                                                                                         sAkaVersionBilling,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VALID_PER_UTC_2014_12),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_2024_12,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_2024_12,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_2024_12,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BIS3_SG_UBL_CREDIT_NOTE_2024_12,
                                                                             "SG Peppol BIS3 Credit Note (UBL) 2024.12" +
                                                                                                                             sAkaVersionBilling,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  VALID_PER_UTC_2014_12),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_CEN_2024_12,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_PEPPOL_2024_12,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (BIS3_BILLING_SG_2024_12,
                                                                                                          aNSCtxCreditNote)));
    }

    // Order Balance 1.0
    {
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_PEPPOL_SG_ORDER_BALANCE_1_0,
                                                                             "SG Peppol Order Balance 1.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH +
                                                                                                                                 "ob-1.0/xslt/SGBIS-TOB.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxOrder)));
    }
  }
}
