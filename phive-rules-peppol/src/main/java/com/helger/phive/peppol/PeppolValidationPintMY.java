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
import com.helger.base.exception.InitializationException;
import com.helger.datetime.helper.PDTFactory;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Peppol Malaysia validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationPintMY
{
  public static final String GROUP_ID = "org.peppol.pint.my";

  // 1.0.0
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.0.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.0.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.0.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.0.0");

  // 1.1.0
  public static final LocalDate V1_1_0_VALID_PER = PDTFactory.createLocalDate (2025, Month.MARCH, 10);
  public static final OffsetDateTime V1_1_0_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (V1_1_0_VALID_PER);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.1.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.1.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.1.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.1.0");

  // 1.2.1
  public static final LocalDate V1_2_1_VALID_PER = PDTFactory.createLocalDate (2025, Month.SEPTEMBER, 25);
  public static final OffsetDateTime V1_2_1_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (V1_2_1_VALID_PER);
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_2_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.2.1");
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_2_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.2.1");
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_2_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.2.1");
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_2_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.2.1");

  // 1.3.0
  public static final LocalDate V1_3_0_VALID_PER = PDTFactory.createLocalDate (2026, Month.MARCH, 9);
  public static final OffsetDateTime V1_3_0_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (V1_3_0_VALID_PER);
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "invoice",
                                                                                                                  "1.3.0");
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                      "creditnote",
                                                                                                                      "1.3.0");
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                               "invoice-self-billing",
                                                                                                                               "1.3.0");
  public static final DVRCoordinate VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_3_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                                   "creditnote-self-billing",
                                                                                                                                   "1.3.0");

  private PeppolValidationPintMY ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPintMY.class.getClassLoader ();
  }

  @SuppressWarnings ("deprecation")
  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final String BASE_PATH = "external/schematron/pint-my/";

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = !bDeprecated;

    // 1.0.0
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESIDInv = aRegistry.getOfID (PeppolValidationPint.VID_OPENPEPPOL_PINT_INVOICE_1_0_1);
      final IValidationExecutorSet <IValidationSourceXML> aVESIDCN = aRegistry.getOfID (PeppolValidationPint.VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_0_1);
      if (aVESIDInv == null || aVESIDCN == null)
        throw new InitializationException ("The Generic PINT VES are missing. Make sure to call PeppolValidationPint.init first.");

      final ClassPathResource aCPRBilling = new ClassPathResource (BASE_PATH +
                                                                   "1.0.0/xslt/billing/PINT-jurisdiction-aligned-rules.xslt",
                                                                   _getCL ());
      final ClassPathResource aCPRSelfBilling = new ClassPathResource (BASE_PATH +
                                                                       "1.0.0/xslt/selfbilling/PINT-jurisdiction-aligned-rules.xslt",
                                                                       _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESIDInv,
                                                                                    VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_0_0,
                                                                                    "Peppol PINT Malaysia Invoice (UBL) 1.0.0",
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesHelper.createXSLT (aCPRBilling,
                                                                                                                 aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESIDCN,
                                                                                    VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_0_0,
                                                                                    "Peppol PINT Malaysia Credit Note (UBL) 1.0.0",
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesHelper.createXSLT (aCPRBilling,
                                                                                                                 aNSCtxCreditNote)));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESIDInv,
                                                                                    VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_0_0,
                                                                                    "Peppol PINT Malaysia Invoice Self-Billing (UBL) 1.0.0",
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesHelper.createXSLT (aCPRSelfBilling,
                                                                                                                 aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESIDCN,
                                                                                    VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_0_0,
                                                                                    "Peppol PINT Malaysia Credit Note Self-Billing (UBL) 1.0.0",
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesHelper.createXSLT (aCPRSelfBilling,
                                                                                                                 aNSCtxCreditNote)));
    }

    // 1.1.0
    {
      final ClassPathResource aCPRBillingBase = new ClassPathResource (BASE_PATH +
                                                                       "1.1.0/xslt/billing/PINT-UBL-validation-preprocessed.xslt",
                                                                       _getCL ());
      final ClassPathResource aCPRBilling = new ClassPathResource (BASE_PATH +
                                                                   "1.1.0/xslt/billing/PINT-jurisdiction-aligned-rules.xslt",
                                                                   _getCL ());

      final ClassPathResource aCPRSelfBillingBase = new ClassPathResource (BASE_PATH +
                                                                           "1.1.0/xslt/selfbilling/PINT-UBL-validation-preprocessed.xslt",
                                                                           _getCL ());
      final ClassPathResource aCPRSelfBilling = new ClassPathResource (BASE_PATH +
                                                                       "1.1.0/xslt/selfbilling/PINT-jurisdiction-aligned-rules.xslt",
                                                                       _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_1_0,
                                                                             "Peppol PINT Malaysia Invoice (UBL) 1.1.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  V1_1_0_VALID_PER_UTC),
                                                                             PhiveRulesHelper.createXSLT (aCPRBillingBase,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aCPRBilling,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_1_0,
                                                                             "Peppol PINT Malaysia Credit Note (UBL) 1.1.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  V1_1_0_VALID_PER_UTC),
                                                                             PhiveRulesHelper.createXSLT (aCPRBillingBase,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aCPRBilling,
                                                                                                          aNSCtxCreditNote)));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_1_0,
                                                                             "Peppol PINT Malaysia Invoice Self-Billing (UBL) 1.1.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  V1_1_0_VALID_PER_UTC),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBillingBase,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBilling,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_1_0,
                                                                             "Peppol PINT Malaysia Credit Note Self-Billing (UBL) 1.1.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated,
                                                                                                                  V1_1_0_VALID_PER_UTC),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBillingBase,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBilling,
                                                                                                          aNSCtxCreditNote)));
    }

    // 1.2.1
    {
      final ClassPathResource aCPRBillingBase = new ClassPathResource (BASE_PATH +
                                                                       "1.2.1/xslt/billing/PINT-UBL-validation-preprocessed.xslt",
                                                                       _getCL ());
      final ClassPathResource aCPRBilling = new ClassPathResource (BASE_PATH +
                                                                   "1.2.1/xslt/billing/PINT-jurisdiction-aligned-rules.xslt",
                                                                   _getCL ());

      final ClassPathResource aCPRSelfBillingBase = new ClassPathResource (BASE_PATH +
                                                                           "1.2.1/xslt/selfbilling/PINT-UBL-validation-preprocessed.xslt",
                                                                           _getCL ());
      final ClassPathResource aCPRSelfBilling = new ClassPathResource (BASE_PATH +
                                                                       "1.2.1/xslt/selfbilling/PINT-jurisdiction-aligned-rules.xslt",
                                                                       _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_2_1,
                                                                             "Peppol PINT Malaysia Invoice (UBL) 1.2.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_2_1_VALID_PER_UTC),
                                                                             PhiveRulesHelper.createXSLT (aCPRBillingBase,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aCPRBilling,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_2_1,
                                                                             "Peppol PINT Malaysia Credit Note (UBL) 1.2.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_2_1_VALID_PER_UTC),
                                                                             PhiveRulesHelper.createXSLT (aCPRBillingBase,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aCPRBilling,
                                                                                                          aNSCtxCreditNote)));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_2_1,
                                                                             "Peppol PINT Malaysia Invoice Self-Billing (UBL) 1.2.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_2_1_VALID_PER_UTC),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBillingBase,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBilling,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_2_1,
                                                                             "Peppol PINT Malaysia Credit Note Self-Billing (UBL) 1.2.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_2_1_VALID_PER_UTC),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBillingBase,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBilling,
                                                                                                          aNSCtxCreditNote)));
    }

    // 1.3.0
    {
      final ClassPathResource aCPRBillingBase = new ClassPathResource (BASE_PATH +
                                                                       "1.3.0/xslt/billing/PINT-UBL-validation-preprocessed.xslt",
                                                                       _getCL ());
      final ClassPathResource aCPRBilling = new ClassPathResource (BASE_PATH +
                                                                   "1.3.0/xslt/billing/PINT-jurisdiction-aligned-rules.xslt",
                                                                   _getCL ());

      final ClassPathResource aCPRSelfBillingBase = new ClassPathResource (BASE_PATH +
                                                                           "1.3.0/xslt/selfbilling/PINT-UBL-validation-preprocessed.xslt",
                                                                           _getCL ());
      final ClassPathResource aCPRSelfBilling = new ClassPathResource (BASE_PATH +
                                                                       "1.3.0/xslt/selfbilling/PINT-jurisdiction-aligned-rules.xslt",
                                                                       _getCL ());

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_1_3_0,
                                                                             "Peppol PINT Malaysia Invoice (UBL) 1.3.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_3_0_VALID_PER_UTC),
                                                                             PhiveRulesHelper.createXSLT (aCPRBillingBase,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aCPRBilling,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_1_3_0,
                                                                             "Peppol PINT Malaysia Credit Note (UBL) 1.3.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_3_0_VALID_PER_UTC),
                                                                             PhiveRulesHelper.createXSLT (aCPRBillingBase,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aCPRBilling,
                                                                                                          aNSCtxCreditNote)));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_INVOICE_SELF_BILLING_1_3_0,
                                                                             "Peppol PINT Malaysia Invoice Self-Billing (UBL) 1.3.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_3_0_VALID_PER_UTC),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBillingBase,
                                                                                                          aNSCtxInvoice),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBilling,
                                                                                                          aNSCtxInvoice)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MY_PINT_UBL_CREDIT_NOTE_SELF_BILLING_1_3_0,
                                                                             "Peppol PINT Malaysia Credit Note Self-Billing (UBL) 1.3.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated,
                                                                                                                  V1_3_0_VALID_PER_UTC),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBillingBase,
                                                                                                          aNSCtxCreditNote),
                                                                             PhiveRulesHelper.createXSLT (aCPRSelfBilling,
                                                                                                          aNSCtxCreditNote)));
    }
  }
}
