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
package com.helger.phive.peppol.pint;

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
import com.helger.phive.rules.shared.PhiveRulesHelper;
import com.helger.phive.rules.shared.PhiveRulesUBLHelper;
import com.helger.phive.rules.shared.DVRHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
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

  // 1.0.3 from 2026-03-25
  public static final LocalDate AE_PINT_2026_03_VALID_PER = PDTFactory.createLocalDate (2026, Month.JANUARY, 21);
  public static final OffsetDateTime AE_PINT_2026_03_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (AE_PINT_2026_03_VALID_PER);
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_INVOICE_2026_03 = DVRHelper.createCoordinate (GROUP_ID, "invoice", "2026.3");
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2026_03 = DVRHelper.createCoordinate (GROUP_ID, "creditnote", "2026.3");
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2026_03 = DVRHelper.createCoordinate (GROUP_ID, "invoice-self-billing", "2026.3");
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2026_03 = DVRHelper.createCoordinate (GROUP_ID, "creditnote-self-billing", "2026.3");

  // 1.0.4 from 2026-05-28
  public static final LocalDate AE_PINT_2026_05_VALID_PER = PDTFactory.createLocalDate (2026, Month.MAY, 28);
  public static final OffsetDateTime AE_PINT_2026_05_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (AE_PINT_2026_05_VALID_PER);
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_INVOICE_2026_05 = DVRHelper.createCoordinate (GROUP_ID, "invoice", "2026.5");
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2026_05 = DVRHelper.createCoordinate (GROUP_ID, "creditnote", "2026.5");
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2026_05 = DVRHelper.createCoordinate (GROUP_ID, "invoice-self-billing", "2026.5");
  public static final DVRCoordinate VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2026_05 = DVRHelper.createCoordinate (GROUP_ID, "creditnote-self-billing", "2026.5");

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

    final String BASE_PATH = "external/schematron/pint-ae/";

    // 2026.3 (aka 1.0.3)
    {
      final String sBase = BASE_PATH + "2026.3/";
      final String sBaseBilling = sBase + "billing/";
      final String sAkaVersion = " (aka 1.0.3)";
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_INVOICE_2026_03)
                   .displayName ("Peppol PINT AE Invoice (UBL) 2026-03" + sAkaVersion)
                   .notDeprecated ()
                   .validFrom (AE_PINT_2026_03_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2026_03)
                   .displayName ("Peppol PINT AE Credit Note (UBL) 2026-03" + sAkaVersion)
                   .notDeprecated ()
                   .validFrom (AE_PINT_2026_03_VALID_PER_UTC)
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
                   .vesID (VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2026_03)
                   .displayName ("Peppol PINT AE Invoice Self-Billing (UBL) 2026-03" + sAkaVersion)
                   .notDeprecated ()
                   .validFrom (AE_PINT_2026_03_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2026_03)
                   .displayName ("Peppol PINT AE Credit Note Self-Billing (UBL) 2026-03" + sAkaVersion)
                   .notDeprecated ()
                   .validFrom (AE_PINT_2026_03_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxCreditNote))
                   .registerInto (aRegistry);
    }

    // 2026.5 (aka 1.0.4)
    {
      final String sBase = BASE_PATH + "2026.5/";
      final String sBaseBilling = sBase + "billing/";
      final String sAkaVersion = " (aka 1.0.4)";
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_INVOICE_2026_05)
                   .displayName ("Peppol PINT AE Invoice (UBL) 2026-05" + sAkaVersion)
                   .notDeprecated ()
                   .validFrom (AE_PINT_2026_05_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_CREDIT_NOTE_2026_05)
                   .displayName ("Peppol PINT AE Credit Note (UBL) 2026-05" + sAkaVersion)
                   .notDeprecated ()
                   .validFrom (AE_PINT_2026_05_VALID_PER_UTC)
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
                   .vesID (VID_OPENPEPPOL_AE_PINT_SB_INVOICE_2026_05)
                   .displayName ("Peppol PINT AE Invoice Self-Billing (UBL) 2026-05" + sAkaVersion)
                   .notDeprecated ()
                   .validFrom (AE_PINT_2026_05_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_AE_PINT_SB_CREDIT_NOTE_2026_05)
                   .displayName ("Peppol PINT AE Credit Note Self-Billing (UBL) 2026-05" + sAkaVersion)
                   .notDeprecated ()
                   .validFrom (AE_PINT_2026_05_VALID_PER_UTC)
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
