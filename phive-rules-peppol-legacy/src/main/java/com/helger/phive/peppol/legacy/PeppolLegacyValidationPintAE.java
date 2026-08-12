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
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.shared.DVRHelper;
import com.helger.phive.rules.shared.PhiveRulesHelper;
import com.helger.phive.rules.shared.PhiveRulesUBLHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Legacy Peppol United Arab Emirates (UAE) validation configuration. It contains only the old
 * validation rules.
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolLegacyValidationPintAE
{
  @Deprecated (forRemoval = false)
  public static final String GROUP_ID = "org.peppol.pint.ae";

  // 0.9.0 Preview 2025-03
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_INVOICE_0_9_0 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                       "invoice",
                                                                                                       "0.9.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_0_9_0 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                           "creditnote",
                                                                                                           "0.9.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_INVOICE_0_9_0 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                          "invoice-self-billing",
                                                                                                          "0.9.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_0_9_0 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                              "creditnote-self-billing",
                                                                                                              "0.9.0");

  // 2025-Q2 from 2025-06-10
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_INVOICE_2025_06 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                         "invoice",
                                                                                                         "2025.6");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_06 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                             "creditnote",
                                                                                                             "2025.6");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_06 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                            "invoice-self-billing",
                                                                                                            "2025.6");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_06 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                                "creditnote-self-billing",
                                                                                                                "2025.6");

  // 1.0.1 from 2025-07-30
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_INVOICE_2025_07 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                         "invoice",
                                                                                                         "2025.7");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_07 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                             "creditnote",
                                                                                                             "2025.7");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_07 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                            "invoice-self-billing",
                                                                                                            "2025.7");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_07 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                                "creditnote-self-billing",
                                                                                                                "2025.7");

  // 1.0.2 from 2026-01-21 (was originally 2026-03-09 - corrected in mail from 12.1.2026, 14:37 CET)
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_INVOICE_2025_11 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                         "invoice",
                                                                                                         "2025.11");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_11 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                             "creditnote",
                                                                                                             "2025.11");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_11 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                            "invoice-self-billing",
                                                                                                            "2025.11");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_11 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                                "creditnote-self-billing",
                                                                                                                "2025.11");

  private PeppolLegacyValidationPintAE ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolLegacyValidationPintAE.class.getClassLoader ();
  }

  /**
   * Register all legacy Peppol PINT AE validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  @Deprecated (forRemoval = false)
  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final String BASE_PATH = "external/schematron/pint-ae/";

    // 0.9.0
    {
      final String sBase = BASE_PATH + "0.9.0/xslt/";
      final String sBaseBilling = sBase + "billing/";
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_INVOICE_0_9_0)
                   .displayNamePrefix ("Peppol PINT AE Invoice (UBL) ")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_0_9_0)
                   .displayNamePrefix ("Peppol PINT AE Credit Note (UBL) ")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .registerInto (aRegistry);

      final String sBaseSelfBilling = sBase + "selfbilling/";
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_SB_INVOICE_0_9_0)
                   .displayNamePrefix ("Peppol PINT AE Invoice Self-Billing (UBL) ")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_0_9_0)
                   .displayNamePrefix ("Peppol PINT AE Credit Note Self-Billing (UBL) ")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .registerInto (aRegistry);
    }

    // 2025.6
    {
      final String sBase = BASE_PATH + "2025.6/xslt/";
      final String sBaseBilling = sBase + "billing/";
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_INVOICE_2025_06)
                   .displayName ("Peppol PINT AE Invoice (UBL) 2025-06")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_06)
                   .displayName ("Peppol PINT AE Credit Note (UBL) 2025-06")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .registerInto (aRegistry);

      final String sBaseSelfBilling = sBase + "selfbilling/";
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_06)
                   .displayName ("Peppol PINT AE Invoice Self-Billing (UBL) 2025-06")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_06)
                   .displayName ("Peppol PINT AE Credit Note Self-Billing (UBL) 2025-06")
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .registerInto (aRegistry);
    }

    // 2025.7 (aka 1.0.1)
    {
      final String sBase = BASE_PATH + "2025.7/xslt/";
      final String sBaseBilling = sBase + "billing/";
      final String sAkaVersion = " (aka 1.0.1)";
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_INVOICE_2025_07)
                   .displayName ("Peppol PINT AE Invoice (UBL) 2025-07" + sAkaVersion)
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_07)
                   .displayName ("Peppol PINT AE Credit Note (UBL) 2025-07" + sAkaVersion)
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .registerInto (aRegistry);

      final String sBaseSelfBilling = sBase + "selfbilling/";
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_07)
                   .displayName ("Peppol PINT AE Invoice Self-Billing (UBL) 2025-07" + sAkaVersion)
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_07)
                   .displayName ("Peppol PINT AE Credit Note Self-Billing (UBL) 2025-07" + sAkaVersion)
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .registerInto (aRegistry);
    }

    // 2025.11 (aka 1.0.2)
    {
      final String sBase = BASE_PATH + "2025.11/xslt/";
      final String sBaseBilling = sBase + "billing/";
      final String sAkaVersion = " (aka 1.0.2)";
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_INVOICE_2025_11)
                   .displayName ("Peppol PINT AE Invoice (UBL) 2025-11" + sAkaVersion)
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2025_11)
                   .displayName ("Peppol PINT AE Credit Note (UBL) 2025-11" + sAkaVersion)
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .registerInto (aRegistry);

      final String sBaseSelfBilling = sBase + "selfbilling/";
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2025_11)
                   .displayName ("Peppol PINT AE Invoice Self-Billing (UBL) 2025-11" + sAkaVersion)
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2025_11)
                   .displayName ("Peppol PINT AE Credit Note Self-Billing (UBL) 2025-11" + sAkaVersion)
                   .deprecated ()
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .registerInto (aRegistry);
    }
  }
}
