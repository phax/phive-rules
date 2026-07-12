/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.phive.peppol.billing;

import java.time.LocalDate;
import java.time.Month;
import java.time.OffsetDateTime;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.version.Version;
import com.helger.datetime.helper.PDTFactory;
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
 * Peppol BIS Billing 3.0.21, mandatory from 2026-08-17.
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidation2026_05
{
  public static final Version PEPPOL_VALIDATION_ARTEFACT_VERSION = new Version (2026, 5, 0);
  public static final String VERSION_STR = PEPPOL_VALIDATION_ARTEFACT_VERSION.getAsString (false);
  public static final LocalDate VALID_PER = PDTFactory.createLocalDate (2026, Month.AUGUST, 17);
  public static final OffsetDateTime VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (VALID_PER);

  public static final String GROUP_ID = "eu.peppol.bis3";
  public static final DVRCoordinate VID_OPENPEPPOL_INVOICE_UBL_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "invoice",
                                                                                                       VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "creditnote",
                                                                                                           VERSION_STR);

  private PeppolValidation2026_05 ()
  {}

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sVersion = " (" + VERSION_STR + ")";
    final String sAkaVersionBilling = " (aka BIS Billing 3.0.21)";
    final String sPrefixXslt = "external/schematron/openpeppol/" + VERSION_STR + "/xslt/";
    final ClassLoader aClassLoader = PeppolValidation2026_05.class.getClassLoader ();
    final IReadableResource aInvoiceUblCen = new ClassPathResource (sPrefixXslt + "CEN-EN16931-UBL.xslt",
                                                                    aClassLoader);
    final IReadableResource aInvoiceUblPeppol = new ClassPathResource (sPrefixXslt + "PEPPOL-EN16931-UBL.xslt",
                                                                       aClassLoader);

    VesXmlBuilder.builder ()
                 .vesID (VID_OPENPEPPOL_INVOICE_UBL_V3)
                 .displayName ("OpenPeppol UBL Invoice" + sVersion + sAkaVersionBilling)
                 .notDeprecated ()
                 .validFrom (VALID_PER_UTC)
                 .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                 .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aInvoiceUblCen))
                 .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aInvoiceUblPeppol))
                 .registerInto (aRegistry);
    VesXmlBuilder.builder ()
                 .vesID (VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3)
                 .displayName ("OpenPeppol UBL Credit Note" + sVersion + sAkaVersionBilling)
                 .notDeprecated ()
                 .validFrom (VALID_PER_UTC)
                 .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                 .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aInvoiceUblCen))
                 .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (aInvoiceUblPeppol))
                 .registerInto (aRegistry);
  }
}
