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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesBuilder;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Peppol PINT Europe validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationPintEU
{
  public static final String GROUP_ID = "org.peppol.pint.eu";

  // 1.0.0 from 2025-10-01
  public static final DVRCoordinate VID_OPENPEPPOL_EU_PINT_INVOICE_2025_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "invoice",
                                                                                                                "2025.10");
  public static final DVRCoordinate VID_OPENPEPPOL_EU_PINT_CREDIT_NOTE_2025_10 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "creditnote",
                                                                                                                    "2025.10");

  // 1.0.1 from 2026-03-09
  public static final DVRCoordinate VID_OPENPEPPOL_EU_PINT_INVOICE_2025_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                "invoice",
                                                                                                                "2025.11");
  public static final DVRCoordinate VID_OPENPEPPOL_EU_PINT_CREDIT_NOTE_2025_11 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "creditnote",
                                                                                                                    "2025.11");

  private PeppolValidationPintEU ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPintEU.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final String BASE_PATH = "external/schematron/pint-eu/";

    // 2025.10 (aka 1.0.0)
    {
      final String sBase = BASE_PATH + "1.0.0/xslt/";
      final String sBaseBilling = sBase + "";
      final String sAkaVersion = " (aka 1.0.0)";
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_EU_PINT_INVOICE_2025_10)
                       .displayName ("Peppol PINT EU Invoice (UBL) 2025-10" + sAkaVersion)
                       .notDeprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-UBL-validation-preprocessed.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-EN16931-aligned-rules.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-jurisdiction-aligned-rules.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_EU_PINT_CREDIT_NOTE_2025_10)
                       .displayName ("Peppol PINT EU Credit Note (UBL) 2025-10" + sAkaVersion)
                       .notDeprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-UBL-validation-preprocessed.xslt",
                                                                                           _getCL ()),
                                                                    aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-EN16931-aligned-rules.xslt",
                                                                                           _getCL ()),
                                                                    aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-jurisdiction-aligned-rules.xslt",
                                                                                           _getCL ()),
                                                                    aNSCtxCreditNote))
                       .registerInto (aRegistry);
    }

    // 2025.11 (aka 1.0.1)
    {
      final String sBase = BASE_PATH + "1.0.1/xslt/";
      final String sBaseBilling = sBase + "";
      final String sAkaVersion = " (aka 1.0.1)";
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_EU_PINT_INVOICE_2025_11)
                       .displayName ("Peppol PINT EU Invoice (UBL) 2025-11" + sAkaVersion)
                       .notDeprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-UBL-validation-preprocessed.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-EN16931-aligned-rules.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-jurisdiction-aligned-rules.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_EU_PINT_CREDIT_NOTE_2025_11)
                       .displayName ("Peppol PINT EU Credit Note (UBL) 2025-11" + sAkaVersion)
                       .notDeprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-UBL-validation-preprocessed.xslt",
                                                                                           _getCL ()),
                                                                    aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-EN16931-aligned-rules.xslt",
                                                                                           _getCL ()),
                                                                    aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-jurisdiction-aligned-rules.xslt",
                                                                                           _getCL ()),
                                                                    aNSCtxCreditNote))
                       .registerInto (aRegistry);
    }
  }
}
