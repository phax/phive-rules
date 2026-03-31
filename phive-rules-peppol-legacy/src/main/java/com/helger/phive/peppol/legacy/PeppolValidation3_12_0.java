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
package com.helger.phive.peppol.legacy;

import java.time.LocalDate;
import java.time.Month;
import java.time.OffsetDateTime;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.version.Version;
import com.helger.collection.commons.ICommonsList;
import com.helger.datetime.helper.PDTFactory;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.status.EValidationExecutorStatusType;
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatusHistoryItem;
import com.helger.phive.rules.api.PhiveRulesBuilder;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;

/**
 * OpenPeppol validation artefacts release 3.12.0.<br>
 * Spring 2021 release 2021-03-05.<br>
 * Valid per May 17th, 2021
 *
 * @author Philip Helger
 */
@Immutable
@Deprecated (forRemoval = false)
public final class PeppolValidation3_12_0
{
  // Standard resources
  @Deprecated (forRemoval = false)
  public static final Version PEPPOL_VALIDATION_ARTEFACT_VERSION = new Version (3, 12, 0);
  @Deprecated (forRemoval = false)
  public static final String VERSION_STR = PEPPOL_VALIDATION_ARTEFACT_VERSION.getAsString (true);
  @Deprecated (forRemoval = false)
  public static final LocalDate VALID_PER = PDTFactory.createLocalDate (2021, Month.MAY, 17);
  @Deprecated (forRemoval = false)
  public static final OffsetDateTime VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (VALID_PER);

  // Standard
  private static final String GROUP_ID = "eu.peppol.bis3";
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_INVOICE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "invoice",
                                                                                                   VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_CREDIT_NOTE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "creditnote",
                                                                                                       VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_ORDER_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "order",
                                                                                                 VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_DESPATCH_ADVICE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "despatch-advice",
                                                                                                           VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_CATALOGUE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "catalogue",
                                                                                                     VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                              "catalogue-response",
                                                                                                              VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_MLR_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "mlr",
                                                                                               VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_ORDER_RESPONSE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "order-response",
                                                                                                          VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_PUNCH_OUT_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "punch-out",
                                                                                                     VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_ORDER_AGREEMENT_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "order-agreement",
                                                                                                           VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "invoice-message-response",
                                                                                                                    VERSION_STR);

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidation3_12_0.class.getClassLoader ();
  }

  private PeppolValidation3_12_0 ()
  {}

  @NonNull
  private static IValidationExecutorSetStatus _createStatus (final boolean bIsDeprecated)
  {
    return new ValidationExecutorSetStatus (PDTFactory.getCurrentOffsetDateTime (),
                                            bIsDeprecated ? EValidationExecutorStatusType.DEPRECATED
                                                          : EValidationExecutorStatusType.VALID,
                                            VALID_PER_UTC,
                                            PeppolValidation3_13_0.VALID_PER_UTC,
                                            (String) null,
                                            (DVRCoordinate) null,
                                            (ICommonsList <ValidationExecutorSetStatusHistoryItem>) null);
  }

  @Deprecated (forRemoval = false)
  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sVersion = " (" + VERSION_STR + ")";
    // See https://docs.peppol.eu/poacc/billing/3.0/release-notes/
    final String sAkaVersionBilling = " (aka BIS Billing 3.0.10)";
    // See https://docs.peppol.eu/poacc/upgrade-3/release-notes/
    final String sAkaVersionBIS = " (aka BIS 3.0.7)";

    // Previously T10 and T14
    final String PREFIX_XSLT = "external/schematron/openpeppol/" + VERSION_STR + "/xslt/";
    final IReadableResource INVOICE_CEN = new ClassPathResource (PREFIX_XSLT + "CEN-EN16931-UBL.xslt", _getCL ());
    final IReadableResource INVOICE_PEPPOL = new ClassPathResource (PREFIX_XSLT + "PEPPOL-EN16931-UBL.xslt", _getCL ());
    final IReadableResource ORDER = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T01.xslt", _getCL ());
    final IReadableResource DESPATCH_ADVICE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T16.xslt", _getCL ());
    final IReadableResource CATALOGUE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T19.xslt", _getCL ());
    final IReadableResource CATALOGUE_RESPONSE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T58.xslt", _getCL ());
    final IReadableResource MLR = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T71.xslt", _getCL ());
    final IReadableResource ORDER_RESPONSE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T76.xslt", _getCL ());
    final IReadableResource PUNCH_OUT = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T77.xslt", _getCL ());
    final IReadableResource ORDER_AGREEMENT = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T110.xslt", _getCL ());
    final IReadableResource INVOICE_MESSAGE_RESPONSE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T111.xslt",
                                                                              _getCL ());

    final boolean bDeprecated = true;

    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_INVOICE_V3)
                     .displayName ("OpenPeppol Invoice" + sVersion + sAkaVersionBilling)
                     .status (_createStatus (bDeprecated))
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_CEN))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_PEPPOL))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_CREDIT_NOTE_V3)
                     .displayName ("OpenPeppol Credit Note" + sVersion + sAkaVersionBilling)
                     .status (_createStatus (bDeprecated))
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_CEN))
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_PEPPOL))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_ORDER_V3)
                     .displayName ("OpenPeppol Order" + sVersion + sAkaVersionBIS)
                     .status (_createStatus (bDeprecated))
                     .addXSD (UBL21Marshaller.getAllOrderXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (ORDER))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_DESPATCH_ADVICE_V3)
                     .displayName ("OpenPeppol Despatch Advice" + sVersion + sAkaVersionBIS)
                     .status (_createStatus (bDeprecated))
                     .addXSD (UBL21Marshaller.getAllDespatchAdviceXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (DESPATCH_ADVICE))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_CATALOGUE_V3)
                     .displayName ("OpenPeppol Catalogue" + sVersion + sAkaVersionBIS)
                     .status (_createStatus (bDeprecated))
                     .addXSD (UBL21Marshaller.getAllCatalogueXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (CATALOGUE))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3)
                     .displayName ("OpenPeppol Catalogue Response" + sVersion + sAkaVersionBIS)
                     .status (_createStatus (bDeprecated))
                     .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (CATALOGUE_RESPONSE))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_MLR_V3)
                     .displayName ("OpenPeppol MLR" + sVersion + sAkaVersionBIS)
                     .status (_createStatus (bDeprecated))
                     .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (MLR))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_ORDER_RESPONSE_V3)
                     .displayName ("OpenPeppol Order Response" + sVersion + sAkaVersionBIS)
                     .status (_createStatus (bDeprecated))
                     .addXSD (UBL21Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (ORDER_RESPONSE))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_PUNCH_OUT_V3)
                     .displayName ("OpenPeppol Punch Out" + sVersion + sAkaVersionBIS)
                     .status (_createStatus (bDeprecated))
                     .addXSD (UBL21Marshaller.getAllCatalogueXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (PUNCH_OUT))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_ORDER_AGREEMENT_V3)
                     .displayName ("OpenPeppol Order Agreement" + sVersion + sAkaVersionBIS)
                     .status (_createStatus (bDeprecated))
                     .addXSD (UBL21Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (ORDER_AGREEMENT))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3)
                     .displayName ("OpenPeppol Invoice Message Response" + sVersion + sAkaVersionBIS)
                     .status (_createStatus (bDeprecated))
                     .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                     .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_MESSAGE_RESPONSE))
                     .registerInto (aRegistry);
  }
}
