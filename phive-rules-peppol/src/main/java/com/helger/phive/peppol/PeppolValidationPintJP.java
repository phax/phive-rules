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
import com.helger.base.exception.InitializationException;
import com.helger.datetime.helper.PDTFactory;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesBuilder;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Peppol Japan validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationPintJP
{
  public static final String GROUP_ID = "org.peppol.pint.jp";

  // 0.1.2 (typo in group ID)
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_INVOICE_012 = PhiveRulesHelper.createCoordinate ("org.peppol.jp.pint",
                                                                                                            "invoice",
                                                                                                            "0.1.2");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_012 = PhiveRulesHelper.createCoordinate ("org.peppol.jp.pint",
                                                                                                                "credit-note",
                                                                                                                "0.1.2");

  // 1.0.2
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_INVOICE_1_0_2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                              "invoice",
                                                                                                              "1.0.2");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_0_2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "credit-note",
                                                                                                                  "1.0.2");

  // 1.0.3
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_INVOICE_1_0_3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                              "invoice",
                                                                                                              "1.0.3");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_0_3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "credit-note",
                                                                                                                  "1.0.3");

  // 1.1.0
  public static final LocalDate V1_1_0_VALID_PER = PDTFactory.createLocalDate (2025, Month.MARCH, 10);
  public static final OffsetDateTime V1_1_0_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (V1_1_0_VALID_PER);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                              "invoice",
                                                                                                              "1.1.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "credit-note",
                                                                                                                  "1.1.0");

  // 1.1.1
  public static final LocalDate V1_1_1_VALID_PER = PDTFactory.createLocalDate (2025, Month.SEPTEMBER, 25);
  public static final OffsetDateTime V1_1_1_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (V1_1_1_VALID_PER);
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                              "invoice",
                                                                                                              "1.1.1");
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "credit-note",
                                                                                                                  "1.1.1");
  // 1.1.2
  public static final LocalDate V1_1_2_VALID_PER = PDTFactory.createLocalDate (2026, Month.MARCH, 9);
  public static final OffsetDateTime V1_1_2_VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (V1_1_2_VALID_PER);
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                              "invoice",
                                                                                                              "1.1.2");
  public static final DVRCoordinate VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                  "credit-note",
                                                                                                                  "1.1.2");

  private PeppolValidationPintJP ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPintJP.class.getClassLoader ();
  }

  @SuppressWarnings ("deprecation")
  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final String BASE_PATH = "external/schematron/pint-jp/";

    // 0.1.2
    {
      final ClassPathResource aCPR1 = new ClassPathResource (BASE_PATH +
                                                             "0.1.2/xslt/PINT-UBL-validation-preprocessed.xslt",
                                                             _getCL ());
      final ClassPathResource aCPR2 = new ClassPathResource (BASE_PATH +
                                                             "0.1.2/xslt/PINT-jurisdiction-aligned-rules.xslt",
                                                             _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_JP_PINT_INVOICE_012)
                       .displayName ("Peppol PINT Japan Invoice (UBL) 0.1.2")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR1, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR2, aNSCtxInvoice))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_012)
                       .displayName ("Peppol PINT Japan Credit Note (UBL) 0.1.2")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR1, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR2, aNSCtxCreditNote))
                       .registerInto ();
    }

    // 1.0.2
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESIDInv = aRegistry.getOfID (PeppolValidationPint.VID_OPENPEPPOL_PINT_INVOICE_1_0_1);
      final IValidationExecutorSet <IValidationSourceXML> aVESIDCN = aRegistry.getOfID (PeppolValidationPint.VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_0_1);
      if (aVESIDInv == null || aVESIDCN == null)
        throw new InitializationException ("The Generic PINT VES are missing. Make sure to call PeppolValidationPint.init first.");

      final ClassPathResource aCPR2 = new ClassPathResource (BASE_PATH +
                                                             "1.0.2/xslt/PINT-jurisdiction-aligned-rules.xslt",
                                                             _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_JP_PINT_INVOICE_1_0_2)
                       .displayName ("Peppol PINT Japan Invoice (UBL) 1.0.2")
                       .deprecated ()
                       .basedOn (aVESIDInv)
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR2, aNSCtxInvoice))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_0_2)
                       .displayName ("Peppol PINT Japan Credit Note (UBL) 1.0.2")
                       .deprecated ()
                       .basedOn (aVESIDCN)
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR2, aNSCtxCreditNote))
                       .registerInto ();
    }

    // 1.0.3
    {
      final ClassPathResource aCPR1 = new ClassPathResource (BASE_PATH +
                                                             "1.0.3/xslt/PINT-UBL-validation-preprocessed.xslt",
                                                             _getCL ());
      final ClassPathResource aCPR2 = new ClassPathResource (BASE_PATH +
                                                             "1.0.3/xslt/PINT-jurisdiction-aligned-rules.xslt",
                                                             _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_JP_PINT_INVOICE_1_0_3)
                       .displayName ("Peppol PINT Japan Invoice (UBL) 1.0.3")
                       .deprecated ()
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR1, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR2, aNSCtxInvoice))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_0_3)
                       .displayName ("Peppol PINT Japan Credit Note (UBL) 1.0.3")
                       .deprecated ()
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR1, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR2, aNSCtxCreditNote))
                       .registerInto ();
    }

    // 1.1.0
    {
      final ClassPathResource aCPR1 = new ClassPathResource (BASE_PATH +
                                                             "1.1.0/xslt/PINT-UBL-validation-preprocessed.xslt",
                                                             _getCL ());
      final ClassPathResource aCPR2 = new ClassPathResource (BASE_PATH +
                                                             "1.1.0/xslt/PINT-jurisdiction-aligned-rules.xslt",
                                                             _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_0)
                       .displayName ("Peppol PINT Japan Invoice (UBL) 1.1.0")
                       .status (PhiveRulesHelper.createSimpleStatus (true, V1_1_0_VALID_PER_UTC))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR1, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR2, aNSCtxInvoice))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_0)
                       .displayName ("Peppol PINT Japan Credit Note (UBL) 1.1.0")
                       .status (PhiveRulesHelper.createSimpleStatus (true, V1_1_0_VALID_PER_UTC))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR1, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR2, aNSCtxCreditNote))
                       .registerInto ();
    }

    // 1.1.1
    {
      final ClassPathResource aCPR1 = new ClassPathResource (BASE_PATH +
                                                             "1.1.1/xslt/PINT-UBL-validation-preprocessed.xslt",
                                                             _getCL ());
      final ClassPathResource aCPR2 = new ClassPathResource (BASE_PATH +
                                                             "1.1.1/xslt/PINT-jurisdiction-aligned-rules.xslt",
                                                             _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_1)
                       .displayName ("Peppol PINT Japan Invoice (UBL) 1.1.1")
                       .status (PhiveRulesHelper.createSimpleStatus (false, V1_1_1_VALID_PER_UTC))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR1, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR2, aNSCtxInvoice))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_1)
                       .displayName ("Peppol PINT Japan Credit Note (UBL) 1.1.1")
                       .status (PhiveRulesHelper.createSimpleStatus (false, V1_1_1_VALID_PER_UTC))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR1, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR2, aNSCtxCreditNote))
                       .registerInto ();
    }

    // 1.1.2
    {
      final ClassPathResource aCPR1 = new ClassPathResource (BASE_PATH +
                                                             "1.1.2/xslt/PINT-UBL-validation-preprocessed.xslt",
                                                             _getCL ());
      final ClassPathResource aCPR2 = new ClassPathResource (BASE_PATH +
                                                             "1.1.2/xslt/PINT-jurisdiction-aligned-rules.xslt",
                                                             _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_JP_PINT_INVOICE_1_1_2)
                       .displayName ("Peppol PINT Japan Invoice (UBL) 1.1.2")
                       .status (PhiveRulesHelper.createSimpleStatus (false, V1_1_2_VALID_PER_UTC))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR1, aNSCtxInvoice))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR2, aNSCtxInvoice))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_JP_PINT_CREDIT_NOTE_1_1_2)
                       .displayName ("Peppol PINT Japan Credit Note (UBL) 1.1.2")
                       .status (PhiveRulesHelper.createSimpleStatus (false, V1_1_2_VALID_PER_UTC))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR1, aNSCtxCreditNote))
                       .addSchematron (PhiveRulesHelper.createXSLT (aCPR2, aNSCtxCreditNote))
                       .registerInto ();
    }
  }
}
