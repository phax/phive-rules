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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.exception.InitializationException;
import com.helger.base.version.Version;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * OpenPeppol Self-Billing artefacts March 2025 - initial version
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidation2025_03
{
  // Standard resources
  public static final Version PEPPOL_VALIDATION_ARTEFACT_VERSION = new Version (2025, 3, 0);
  public static final String VERSION_STR = PEPPOL_VALIDATION_ARTEFACT_VERSION.getAsString (false);

  // Standard
  public static final String GROUP_ID = "eu.peppol.bis3";
  public static final DVRCoordinate VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "invoice-self-billing",
                                                                                                                    VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                        "creditnote-self-billing",
                                                                                                                        VERSION_STR);

  private PeppolValidation2025_03 ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidation2025_03.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sVersion = " (" + VERSION_STR + ")";
    final String sAkaVersionBilling = "";

    final boolean bNotDeprecated = false;

    final String PREFIX_XSLT = "external/schematron/openpeppol/" + VERSION_STR + "/xslt/";
    final IReadableResource INVOICE_UBL_PEPPOL = new ClassPathResource (PREFIX_XSLT + "PEPPOL-EN16931-UBL-SB.xslt",
                                                                        _getCL ());

    final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice_1_3_13 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_1313);
    final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote_1_3_13 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_1313);
    if (aVESUBLCreditNote_1_3_13 == null || aVESUBLInvoice_1_3_13 == null)
      throw new InitializationException ("The EN 16931 VES are missing. Make sure to call EN16931Validation.initEN16931 first.");

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLInvoice_1_3_13,
                                                                                  VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3,
                                                                                  "OpenPeppol UBL Invoice Self-Billing" +
                                                                                                                              sVersion +
                                                                                                                              sAkaVersionBilling,
                                                                                  PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                  PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_PEPPOL)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLCreditNote_1_3_13,
                                                                                  VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3,
                                                                                  "OpenPeppol UBL Credit Note Self-Billing" +
                                                                                                                                  sVersion +
                                                                                                                                  sAkaVersionBilling,
                                                                                  PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                  PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_PEPPOL)));
  }
}
