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
 * Peppol PINT validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationPint
{
  public static final String GROUP_ID = "org.peppol.pint";

  // 1.0.0
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_PINT_INVOICE_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "invoice",
                                                                                                           "1.0.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                               "credit-note",
                                                                                                               "1.0.0");

  // 1.0.1
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_PINT_INVOICE_1_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "invoice",
                                                                                                           "1.0.1");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                               "credit-note",
                                                                                                               "1.0.1");

  // 1.0.2
  public static final DVRCoordinate VID_OPENPEPPOL_PINT_INVOICE_1_0_2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "invoice",
                                                                                                           "1.0.2");
  public static final DVRCoordinate VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_0_2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                               "credit-note",
                                                                                                               "1.0.2");

  // 1.1.2 - from 2026-03-09
  public static final DVRCoordinate VID_OPENPEPPOL_PINT_INVOICE_1_1_2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "invoice",
                                                                                                           "1.1.2");
  public static final DVRCoordinate VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_1_2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                               "credit-note",
                                                                                                               "1.1.2");

  private PeppolValidationPint ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationPint.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final MapBasedNamespaceContext aNSCtxInvoice = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                            .getRootElementNamespaceURI ());
    final MapBasedNamespaceContext aNSCtxCreditNote = PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                               .getRootElementNamespaceURI ());

    final String BASE_PATH = "external/schematron/pint/";

    // 1.0.0 - 2023-07-07
    {
      final ClassPathResource aRes = new ClassPathResource (BASE_PATH +
                                                            "1.0.0/xslt/PINT-UBL-validation-preprocessed.xslt",
                                                            _getCL ());

      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_PINT_INVOICE_1_0_0)
                       .displayName ("OpenPeppol PINT Invoice (UBL) 1.0.0")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aRes, aNSCtxInvoice))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_0_0)
                       .displayName ("OpenPeppol PINT Credit Note (UBL) 1.0.0")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aRes, aNSCtxCreditNote))
                       .registerInto ();
    }

    // 1.0.1 - November 2023
    {
      final ClassPathResource aRes = new ClassPathResource (BASE_PATH +
                                                            "1.0.1/xslt/PINT-UBL-validation-preprocessed.xslt",
                                                            _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_PINT_INVOICE_1_0_1)
                       .displayName ("OpenPeppol PINT Invoice (UBL) 1.0.1")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aRes, aNSCtxInvoice))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_0_1)
                       .displayName ("OpenPeppol PINT Credit Note (UBL) 1.0.1")
                       .deprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aRes, aNSCtxCreditNote))
                       .registerInto ();
    }

    // 1.0.2 - May 2024
    {
      final ClassPathResource aResInvoice = new ClassPathResource (BASE_PATH +
                                                                   "1.0.2/xslt/PINT-UBL-validation-preprocessed-inv.xslt",
                                                                   _getCL ());
      final ClassPathResource aResCreditNote = new ClassPathResource (BASE_PATH +
                                                                      "1.0.2/xslt/PINT-UBL-validation-preprocessed-cn.xslt",
                                                                      _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_PINT_INVOICE_1_0_2)
                       .displayName ("OpenPeppol PINT Invoice (UBL) 1.0.2")
                       .notDeprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aResInvoice, aNSCtxInvoice))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_0_2)
                       .displayName ("OpenPeppol PINT Credit Note (UBL) 1.0.2")
                       .notDeprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aResCreditNote, aNSCtxCreditNote))
                       .registerInto ();
    }

    // 1.1.2 - November 2025
    {
      final ClassPathResource aRes = new ClassPathResource (BASE_PATH +
                                                            "1.1.2/xslt/PINT-UBL-validation-preprocessed.xslt",
                                                            _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_PINT_INVOICE_1_1_2)
                       .displayName ("OpenPeppol PINT Invoice (UBL) 1.1.2")
                       .notDeprecated ()
                       .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aRes, aNSCtxInvoice))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_PINT_CREDIT_NOTE_1_1_2)
                       .displayName ("OpenPeppol PINT Credit Note (UBL) 1.1.2")
                       .notDeprecated ()
                       .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                       .addSchematron (PhiveRulesHelper.createXSLT (aRes, aNSCtxCreditNote))
                       .registerInto ();
    }
  }
}
