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
import com.helger.phive.rules.api.PhiveRulesBuilder;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
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
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.1.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.1.0");

  // 1.2.0
  public static final LocalDate V1_2_0_VALID_PER = PDTFactory.createLocalDate (2025, Month.MARCH, 10);
  public static final OffsetDateTime V1_2_0_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (V1_2_0_VALID_PER);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_2_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.2.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_2_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.2.0");

  // 1.3.0
  public static final LocalDate V1_3_0_VALID_PER = PDTFactory.createLocalDate (2025, Month.SEPTEMBER, 25);
  public static final OffsetDateTime V1_3_0_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (V1_3_0_VALID_PER);
  public static final DVRCoordinate VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.3.0");
  public static final DVRCoordinate VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.3.0");

  // 1.4.0
  public static final LocalDate V1_4_0_VALID_PER = PDTFactory.createLocalDate (2026, Month.MARCH, 9);
  public static final OffsetDateTime V1_4_0_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (V1_4_0_VALID_PER);
  public static final DVRCoordinate VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_4_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.4.0");
  public static final DVRCoordinate VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_4_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.4.0");

  private PeppolValidationPintSG ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPintSG.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final String BASE_PATH = "external/schematron/pint-sg/";

    // 1.1.0
    {
      final String sBaseBilling = BASE_PATH + "1.1.0/xslt/";
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_1_0)
                       .displayName ("Peppol PINT Singapore Invoice (UBL) 1.1.0")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-UBL-validation-preprocessed-inv.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-jurisdiction-aligned-rules-inv.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_1_0)
                       .displayName ("Peppol PINT Singapore Credit Note (UBL) 1.1.0")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-UBL-validation-preprocessed-cn.xslt",
                                                                                           _getCL ()),
                                                                    aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-jurisdiction-aligned-rules-cn.xslt",
                                                                                           _getCL ()),
                                                                    aNSCtxCreditNote))
                       .registerInto (aRegistry);
    }

    // 1.2.0
    {
      final String sBaseBilling = BASE_PATH + "1.2.0/xslt/";
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_2_0)
                       .displayName ("Peppol PINT Singapore Invoice (UBL) 1.2.0")
                       .status (PhiveRulesHelper.createSimpleStatus (true, V1_2_0_VALID_PER_UTC))
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-UBL-validation-preprocessed.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-jurisdiction-aligned-rules.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_2_0)
                       .displayName ("Peppol PINT Singapore Credit Note (UBL) 1.2.0")
                       .status (PhiveRulesHelper.createSimpleStatus (true, V1_2_0_VALID_PER_UTC))
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-UBL-validation-preprocessed.xslt",
                                                                                           _getCL ()),
                                                                    aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-jurisdiction-aligned-rules.xslt",
                                                                                           _getCL ()),
                                                                    aNSCtxCreditNote))
                       .registerInto (aRegistry);
    }

    // 1.3.0
    {
      final String sBaseBilling = BASE_PATH + "1.3.0/xslt/";
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_3_0)
                       .displayName ("Peppol PINT Singapore Invoice (UBL) 1.3.0")
                       .status (PhiveRulesHelper.createSimpleStatus (false, V1_3_0_VALID_PER_UTC))
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-UBL-validation-preprocessed.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-jurisdiction-aligned-rules.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_3_0)
                       .displayName ("Peppol PINT Singapore Credit Note (UBL) 1.3.0")
                       .status (PhiveRulesHelper.createSimpleStatus (false, V1_3_0_VALID_PER_UTC))
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-UBL-validation-preprocessed.xslt",
                                                                                           _getCL ()),
                                                                    aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-jurisdiction-aligned-rules.xslt",
                                                                                           _getCL ()),
                                                                    aNSCtxCreditNote))
                       .registerInto (aRegistry);
    }

    // 1.4.0
    {
      final String sBaseBilling = BASE_PATH + "1.4.0/xslt/";
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_SG_PINT_UBL_INVOICE_1_4_0)
                       .displayName ("Peppol PINT Singapore Invoice (UBL) 1.4.0")
                       .status (PhiveRulesHelper.createSimpleStatus (false, V1_4_0_VALID_PER_UTC))
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-UBL-validation-preprocessed.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-jurisdiction-aligned-rules.xslt",
                                                                                           _getCL ()), aNSCtxInvoice))
                       .registerInto (aRegistry);
      PhiveRulesBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_SG_PINT_UBL_CREDIT_NOTE_1_4_0)
                       .displayName ("Peppol PINT Singapore Credit Note (UBL) 1.4.0")
                       .status (PhiveRulesHelper.createSimpleStatus (false, V1_4_0_VALID_PER_UTC))
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                           "PINT-UBL-validation-preprocessed.xslt",
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
