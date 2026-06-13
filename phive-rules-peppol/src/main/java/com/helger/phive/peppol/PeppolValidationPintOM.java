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
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Peppol Oman (OM) validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationPintOM
{
  public static final String GROUP_ID = "org.peppol.pint.om";

  // 1.0.0 from 2026-05-24 (2026-Q2-FIN snapshot)
  public static final LocalDate OM_PINT_1_0_0_VALID_PER = PDTFactory.createLocalDate (2026, Month.MAY, 24);
  public static final OffsetDateTime OM_PINT_1_0_0_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (OM_PINT_1_0_0_VALID_PER);
  public static final DVRCoordinate VID_OPENPEPPOL_OM_PINT_INVOICE_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                              "invoice",
                                                                                                              "1.0.0");
  public static final DVRCoordinate VID_OPENPEPPOL_OM_PINT_CREDIT_NOTE_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "creditnote",
                                                                                                                  "1.0.0");
  public static final DVRCoordinate VID_OPENPEPPOL_OM_PINT_SB_INVOICE_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                 "invoice-self-billing",
                                                                                                                 "1.0.0");
  public static final DVRCoordinate VID_OPENPEPPOL_OM_PINT_SB_CREDIT_NOTE_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                     "creditnote-self-billing",
                                                                                                                     "1.0.0");

  private PeppolValidationPintOM ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPintOM.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final String BASE_PATH = "external/schematron/pint-om/";

    // 1.0.0
    {
      final String sBase = BASE_PATH + "1.0.0/";
      final String sBaseBilling = sBase + "billing/";
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_OM_PINT_INVOICE_1_0_0)
                   .displayName ("Peppol PINT OM Invoice (UBL) 1.0.0")
                   .notDeprecated ()
                   .validFrom (OM_PINT_1_0_0_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_OM_PINT_CREDIT_NOTE_1_0_0)
                   .displayName ("Peppol PINT OM Credit Note (UBL) 1.0.0")
                   .notDeprecated ()
                   .validFrom (OM_PINT_1_0_0_VALID_PER_UTC)
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
                   .vesID (VID_OPENPEPPOL_OM_PINT_SB_INVOICE_1_0_0)
                   .displayName ("Peppol PINT OM Invoice Self-Billing (UBL) 1.0.0")
                   .notDeprecated ()
                   .validFrom (OM_PINT_1_0_0_VALID_PER_UTC)
                   .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-UBL-validation-preprocessed.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                       "PINT-jurisdiction-aligned-rules.xslt",
                                                                                       _getCL ()), aNSCtxInvoice))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_OM_PINT_SB_CREDIT_NOTE_1_0_0)
                   .displayName ("Peppol PINT OM Credit Note Self-Billing (UBL) 1.0.0")
                   .notDeprecated ()
                   .validFrom (OM_PINT_1_0_0_VALID_PER_UTC)
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
