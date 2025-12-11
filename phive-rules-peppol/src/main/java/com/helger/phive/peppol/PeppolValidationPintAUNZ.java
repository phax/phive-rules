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
 * Peppol Malaysia validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationPintAUNZ
{
  public static final String GROUP_ID = "org.peppol.pint.aunz";

  // 1.0.1
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "invoice",
                                                                                                                    "1.0.1");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                        "creditnote",
                                                                                                                        "1.0.1");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                 "invoice-self-billing",
                                                                                                                                 "1.0.1");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                     "creditnote-self-billing",
                                                                                                                                     "1.0.1");

  // 1.1.0
  public static final LocalDate V1_1_0_VALID_PER = PDTFactory.createLocalDate (2025, Month.MARCH, 10);
  public static final OffsetDateTime V1_1_0_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (V1_1_0_VALID_PER);
  public static final DVRCoordinate VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "invoice",
                                                                                                                    "1.1.0");
  public static final DVRCoordinate VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                        "creditnote",
                                                                                                                        "1.1.0");
  public static final DVRCoordinate VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                 "invoice-self-billing",
                                                                                                                                 "1.1.0");
  public static final DVRCoordinate VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                     "creditnote-self-billing",
                                                                                                                                     "1.1.0");

  // 1.1.1
  public static final LocalDate V1_1_1_VALID_PER = PDTFactory.createLocalDate (2025, Month.SEPTEMBER, 15);
  public static final OffsetDateTime V1_1_1_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (V1_1_1_VALID_PER);
  public static final DVRCoordinate VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_1_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "invoice",
                                                                                                                    "1.1.1");
  public static final DVRCoordinate VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_1_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                        "creditnote",
                                                                                                                        "1.1.1");
  public static final DVRCoordinate VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_1_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                 "invoice-self-billing",
                                                                                                                                 "1.1.1");
  public static final DVRCoordinate VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                     "creditnote-self-billing",
                                                                                                                                     "1.1.1");

  private PeppolValidationPintAUNZ ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPintAUNZ.class.getClassLoader ();
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

    final String BASE_PATH = "external/schematron/pint-aunz/";

    // 1.0.1
    {
      final String sBaseBilling = BASE_PATH + "1.0.1/xslt/billing/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_0_1,
                                                                             "Peppol PINT A-NZ Invoice (UBL) 1.0.1",
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
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_0_1,
                                                                             "Peppol PINT A-NZ Credit Note (UBL) 1.0.1",
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

      final String sBaseSelfBilling = BASE_PATH + "1.0.1/xslt/selfbilling/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_0_1,
                                                                             "Peppol PINT A-NZ Invoice Self-Billing (UBL) 1.0.1",
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
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_0_1,
                                                                             "Peppol PINT A-NZ Credit Note Self-Billing (UBL) 1.0.1",
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

    // 1.1.0
    {
      final String sBaseBilling = BASE_PATH + "1.1.0/xslt/billing/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_1_0,
                                                                             "Peppol PINT A-NZ Invoice (UBL) 1.1.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_1_0_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_1_0,
                                                                             "Peppol PINT A-NZ Credit Note (UBL) 1.1.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_1_0_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote)));

      final String sBaseSelfBilling = BASE_PATH + "1.1.0/xslt/selfbilling/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_1_0,
                                                                             "Peppol PINT A-NZ Invoice Self-Billing (UBL) 1.1.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_1_0_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_0,
                                                                             "Peppol PINT A-NZ Credit Note Self-Billing (UBL) 1.1.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_1_0_VALID_PER_UTC),
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

    // 1.1.1
    {
      final String sBaseBilling = BASE_PATH + "1.1.1/xslt/billing/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_1_1_1,
                                                                             "Peppol PINT A-NZ Invoice (UBL) 1.1.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_1_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_1_1_1,
                                                                             "Peppol PINT A-NZ Credit Note (UBL) 1.1.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_1_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxCreditNote)));

      final String sBaseSelfBilling = BASE_PATH + "1.1.1/xslt/selfbilling/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_INVOICE_SELF_BILLING_1_1_1,
                                                                             "Peppol PINT A-NZ Invoice Self-Billing (UBL) 1.1.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_1_1_VALID_PER_UTC),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-UBL-validation-preprocessed.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (sBaseSelfBilling +
                                                                                                                                 "PINT-jurisdiction-aligned-rules.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_AUNZ_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_1,
                                                                             "Peppol PINT A-NZ Credit Note Self-Billing (UBL) 1.1.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_1_1_VALID_PER_UTC),
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
