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
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.api.executorset.status.EValidationExecutorStatusType;
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatusHistoryItem;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl23.UBL23Marshaller;

/**
 * OpenPeppol validation artefacts release 2023.5.<br>
 * May 2023 release 2023-05-06.<br>
 * Valid from Monday, 7 August 2023
 *
 * @author Philip Helger
 */
@Immutable
@Deprecated (forRemoval = false)
public final class PeppolValidation2023_05
{
  // Standard resources
  @Deprecated (forRemoval = false)
  public static final Version PEPPOL_VALIDATION_ARTEFACT_VERSION = new Version (2023, 5, 0);
  @Deprecated (forRemoval = false)
  public static final String VERSION_STR = PEPPOL_VALIDATION_ARTEFACT_VERSION.getAsString (false);
  @Deprecated (forRemoval = false)
  public static final LocalDate VALID_PER = PDTFactory.createLocalDate (2023, Month.AUGUST, 7);
  @Deprecated (forRemoval = false)
  public static final OffsetDateTime VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (VALID_PER);

  // Standard
  @Deprecated (forRemoval = false)
  public static final String GROUP_ID = "eu.peppol.bis3";
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_INVOICE_UBL_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "invoice",
                                                                                                       VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "creditnote",
                                                                                                           VERSION_STR);
  // public static final DVRCoordinate VID_OPENPEPPOL_INVOICE_CII_V3 =
  // PhiveRulesHelper.createCoordinate
  // (GROUP_ID, "invoice-cii", VERSION_STR);
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
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_ORDER_CHANGE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                        "order-change",
                                                                                                        VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_ORDER_CANCELLATION_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                              "order-cancellation",
                                                                                                              VERSION_STR);
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                   "order-response-advanced",
                                                                                                                   VERSION_STR);

  private PeppolValidation2023_05 ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidation2023_05.class.getClassLoader ();
  }

  @NonNull
  private static IValidationExecutorSetStatus _createStatus (final boolean bIsDeprecated)
  {
    return new ValidationExecutorSetStatus (PDTFactory.getCurrentOffsetDateTime (),
                                            bIsDeprecated ? EValidationExecutorStatusType.DEPRECATED
                                                          : EValidationExecutorStatusType.VALID,
                                            VALID_PER_UTC,
                                            PeppolValidation2023_11.VALID_PER_UTC,
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
    final String sAkaVersionBilling = " (aka BIS Billing 3.0.15)";
    // See https://docs.peppol.eu/poacc/upgrade-3/release-notes/
    final String sAkaVersionBIS = " (aka BIS 3.0.11)";

    final boolean bDeprecated = true;

    final String PREFIX_XSLT = "external/schematron/openpeppol/" + VERSION_STR + "/xslt/";
    final IReadableResource INVOICE_UBL_CEN = new ClassPathResource (PREFIX_XSLT + "CEN-EN16931-UBL.xslt", _getCL ());
    final IReadableResource INVOICE_UBL_PEPPOL = new ClassPathResource (PREFIX_XSLT + "PEPPOL-EN16931-UBL.xslt",
                                                                        _getCL ());
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
    final IReadableResource ORDER_CHANGE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T114.xslt", _getCL ());
    final IReadableResource ORDER_CANCELLATION = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T115.xslt", _getCL ());
    final IReadableResource ORDER_RESPONSE_ADVANCED = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T116.xslt",
                                                                             _getCL ());

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_INVOICE_UBL_V3,
                                                                           "OpenPeppol UBL Invoice" +
                                                                                                          sVersion +
                                                                                                          sAkaVersionBilling,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_CEN),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_PEPPOL)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                                                           "OpenPeppol UBL Credit Note" +
                                                                                                              sVersion +
                                                                                                              sAkaVersionBilling,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_CEN),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_UBL_PEPPOL)));
    // aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create
    // (VID_OPENPEPPOL_INVOICE_CII_V3,
    // "OpenPeppol CII Invoice" +
    // sVersion +
    // sAkaVersionBilling,
    // bNotDeprecated,
    // ValidationExecutorXSD.create (CCIID16B.getXSDResource ()),
    // _createXsltCII (INVOICE_CII_CEN),
    // _createXsltCII (INVOICE_CII_PEPPOL)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_V3,
                                                                           "OpenPeppol Order" +
                                                                                                    sVersion +
                                                                                                    sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (ORDER)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                                           "OpenPeppol Despatch Advice" +
                                                                                                              sVersion +
                                                                                                              sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllDespatchAdviceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (DESPATCH_ADVICE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CATALOGUE_V3,
                                                                           "OpenPeppol Catalogue" +
                                                                                                        sVersion +
                                                                                                        sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (CATALOGUE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                                           "OpenPeppol Catalogue Response" +
                                                                                                                 sVersion +
                                                                                                                 sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (CATALOGUE_RESPONSE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MLR_V3,
                                                                           "OpenPeppol MLR" + sVersion + sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (MLR)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                                           "OpenPeppol Order Response" +
                                                                                                             sVersion +
                                                                                                             sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (ORDER_RESPONSE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                                           "OpenPeppol Punch Out" +
                                                                                                        sVersion +
                                                                                                        sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (PUNCH_OUT)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                                           "OpenPeppol Order Agreement" +
                                                                                                              sVersion +
                                                                                                              sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (ORDER_AGREEMENT)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,
                                                                           "OpenPeppol Invoice Message Response" +
                                                                                                                       sVersion +
                                                                                                                       sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_MESSAGE_RESPONSE)));
    // UBL 2.3!
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_CHANGE_V3,
                                                                           "OpenPeppol Order Change" +
                                                                                                           sVersion +
                                                                                                           sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllOrderChangeXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL23 (ORDER_CHANGE)));
    // UBL 2.3!
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_CANCELLATION_V3,
                                                                           "OpenPeppol Order Cancellation" +
                                                                                                                 sVersion +
                                                                                                                 sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllOrderCancellationXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL23 (ORDER_CANCELLATION)));
    // UBL 2.3!
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3,
                                                                           "OpenPeppol Order Response Advanced" +
                                                                                                                      sVersion +
                                                                                                                      sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL23Marshaller.getAllOrderResponseXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL23 (ORDER_RESPONSE_ADVANCED)));
  }
}
