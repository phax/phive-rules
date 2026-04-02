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
import com.helger.base.version.Version;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;

/**
 * OpenPeppol Self-Billing artefacts March 2026 - v3.0.1
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidation2026_03
{
  // Standard resources
  public static final Version PEPPOL_VALIDATION_ARTEFACT_VERSION = new Version (2026, 3, 0);
  public static final String VERSION_STR = PEPPOL_VALIDATION_ARTEFACT_VERSION.getAsString (false);

  // Standard
  public static final String GROUP_ID = "eu.peppol.bis3";
  public static final DVRCoordinate VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "invoice-self-billing",
                                                                                                                    VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                        "creditnote-self-billing",
                                                                                                                        VERSION_STR);

  private PeppolValidation2026_03 ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidation2026_03.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sVersion = " (" + VERSION_STR + ")";
    final String sAkaVersionBilling = " (aka BIS 3.0.1)";

    final String PREFIX_XSLT = "external/schematron/openpeppol/" + VERSION_STR + "/xslt/";
    final IReadableResource aCENSB = new ClassPathResource (PREFIX_XSLT + "CEN-EN16931-UBL.xslt", _getCL ());
    final IReadableResource aPeppolSB = new ClassPathResource (PREFIX_XSLT + "PEPPOL-EN16931-UBL-SB.xslt", _getCL ());

    VesXmlBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3)
                     .displayName ("OpenPeppol UBL Invoice Self-Billing" + sVersion + sAkaVersionBilling)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aCENSB))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aPeppolSB))
                     .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3)
                     .displayName ("OpenPeppol UBL Credit Note Self-Billing" + sVersion + sAkaVersionBilling)
                     .notDeprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aCENSB))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aPeppolSB))
                     .registerInto (aRegistry);
  }
}
