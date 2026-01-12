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
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Peppol United Arab Emirates (UAE) validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationPintAE
{
  public static final String GROUP_ID = "org.peppol.pint.ae";

  // 0.9.0 Preview 2025-03
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_INVOICE_0_9_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                              "invoice",
                                                                                                              "0.9.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_0_9_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "creditnote",
                                                                                                                  "0.9.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_INVOICE_0_9_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                 "invoice-self-billing",
                                                                                                                 "0.9.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_0_9_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "creditnote-self-billing",
                                                                                                                     "0.9.0");

  // 2025-Q2 from 2025-06-10
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_INVOICE_2025_06 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "invoice",
                                                                                                                "2025.6");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_06 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "creditnote",
                                                                                                                    "2025.6");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_06 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                   "invoice-self-billing",
                                                                                                                   "2025.6");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_06 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                       "creditnote-self-billing",
                                                                                                                       "2025.6");

  // 1.0.1 from 2025-07-30
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_INVOICE_2025_07 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "invoice",
                                                                                                                "2025.7");
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_07 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "creditnote",
                                                                                                                    "2025.7");
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_07 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                   "invoice-self-billing",
                                                                                                                   "2025.7");
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_07 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                       "creditnote-self-billing",
                                                                                                                       "2025.7");

  // 1.0.2 from 2026-01-21 (was originally 2026-03-09 - corrected in mail from 12.1.2026, 14:37 CET)
  public static final LocalDate AE_PINT_2025_11_VALID_PER = PDTFactory.createLocalDate (2026, Month.JANUARY, 21);
  public static final OffsetDateTime AE_PINT_2025_11_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (AE_PINT_2025_11_VALID_PER);
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_INVOICE_2025_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "invoice",
                                                                                                                "2025.11");
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "creditnote",
                                                                                                                    "2025.11");
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                   "invoice-self-billing",
                                                                                                                   "2025.11");
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                       "creditnote-self-billing",
                                                                                                                       "2025.11");

  private PeppolValidationPintAE ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPintAE.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = !bDeprecated;

    final String BASE_PATH = "external/schematron/pint-ae/";

    // 0.9.0
    {
      final String sBase = BASE_PATH + "0.9.0/xslt/";
      final String sBaseBilling = sBase + "billing/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_INVOICE_0_9_0,
                                                                             "Peppol PINT UAE Invoice (UBL) 0.9.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_0_9_0,
                                                                             "Peppol PINT UAE Credit Note (UBL) 0.9.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote)));

      final String sBaseSelfBilling = sBase + "selfbilling/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_SB_INVOICE_0_9_0,
                                                                             "Peppol PINT UAE Invoice Self-Billing (UBL) 0.9.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_0_9_0,
                                                                             "Peppol PINT UAE Credit Note Self-Billing (UBL) 0.9.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote)));
    }

    // 2025.6
    {
      final String sBase = BASE_PATH + "2025.6/xslt/";
      final String sBaseBilling = sBase + "billing/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_INVOICE_2025_06,
                                                                             "Peppol PINT UAE Invoice (UBL) 2025-Q2",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_06,
                                                                             "Peppol PINT UAE Credit Note (UBL) 2025-Q2",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote)));

      final String sBaseSelfBilling = sBase + "selfbilling/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_06,
                                                                             "Peppol PINT UAE Invoice Self-Billing (UBL) 2025-Q2",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_06,
                                                                             "Peppol PINT UAE Credit Note Self-Billing (UBL) 2025-Q2",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote)));
    }

    // 2025.7 (aka 1.0.1)
    {
      final String sBase = BASE_PATH + "2025.7/xslt/";
      final String sBaseBilling = sBase + "billing/";
      final String sAkaVersion = " (aka 1.0.1)";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_INVOICE_2025_07,
                                                                             "Peppol PINT UAE Invoice (UBL) 2025-07" +
                                                                                                                     sAkaVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_07,
                                                                             "Peppol PINT UAE Credit Note (UBL) 2025-07" +
                                                                                                                         sAkaVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote)));

      final String sBaseSelfBilling = sBase + "selfbilling/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_07,
                                                                             "Peppol PINT UAE Invoice Self-Billing (UBL) 2025-07" +
                                                                                                                        sAkaVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_07,
                                                                             "Peppol PINT UAE Credit Note Self-Billing (UBL) 2025-07" +
                                                                                                                            sAkaVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote)));
    }

    // 2025.11 (aka 1.0.2)
    {
      final String sBase = BASE_PATH + "2025.11/xslt/";
      final String sBaseBilling = sBase + "billing/";
      final String sAkaVersion = " (aka 1.0.1)";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_INVOICE_2025_11,
                                                                             "Peppol PINT UAE Invoice (UBL) 2025-1" +
                                                                                                                     sAkaVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  AE_PINT_2025_11_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_11,
                                                                             "Peppol PINT UAE Credit Note (UBL) 2025-11" +
                                                                                                                         sAkaVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  AE_PINT_2025_11_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote)));

      final String sBaseSelfBilling = sBase + "selfbilling/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_11,
                                                                             "Peppol PINT UAE Invoice Self-Billing (UBL) 2025-11" +
                                                                                                                        sAkaVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  AE_PINT_2025_11_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_11,
                                                                             "Peppol PINT UAE Credit Note Self-Billing (UBL) 2025-11" +
                                                                                                                            sAkaVersion,
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  AE_PINT_2025_11_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote)));
    }
  }
}
