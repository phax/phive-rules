/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.datetime.PDTFactory;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.version.Version;
import com.helger.diver.api.coord.DVRCoordinate;
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

/**
 * OpenPeppol validation artefacts release 3.11.1.<br>
 * Fall 2020 release hotfix 2020-11-12.<br>
 * Valid per November 16th, 2020
 *
 * @author Philip Helger
 */
@Immutable
@Deprecated
public final class PeppolValidation3_11_1
{
  // Standard resources
  public static final Version PEPPOL_VALIDATION_ARTEFACT_VERSION = new Version (3, 11, 1);
  public static final String VERSION_STR = PEPPOL_VALIDATION_ARTEFACT_VERSION.getAsString (true);
  public static final LocalDate VALID_PER = PDTFactory.createLocalDate (2020, Month.NOVEMBER, 16);
  public static final OffsetDateTime VALID_PER_UTC = PDTFactory.createOffsetDateTimeUTC (VALID_PER);

  // Standard
  private static final String GROUP_ID = "eu.peppol.bis3";
  public static final DVRCoordinate VID_OPENPEPPOL_INVOICE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                   "invoice",
                                                                                                   VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_CREDIT_NOTE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "creditnote",
                                                                                                       VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_ORDER_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "order",
                                                                                                 VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_DESPATCH_ADVICE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "despatch-advice",
                                                                                                           VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_CATALOGUE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "catalogue",
                                                                                                     VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                              "catalogue-response",
                                                                                                              VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_MLR_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "mlr",
                                                                                               VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_ORDER_RESPONSE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "order-response",
                                                                                                          VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_PUNCH_OUT_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "punch-out",
                                                                                                     VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_ORDER_AGREEMENT_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                           "order-agreement",
                                                                                                           VERSION_STR);
  public static final DVRCoordinate VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                                    "invoice-message-response",
                                                                                                                    VERSION_STR);

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidation3_11_1.class.getClassLoader ();
  }

  // Previously T10 and T14
  private static final String PREFIX_XSLT = "external/schematron/openpeppol/" + VERSION_STR + "/xslt/";
  public static final IReadableResource INVOICE_CEN = new ClassPathResource (PREFIX_XSLT + "CEN-EN16931-UBL.xslt",
                                                                             _getCL ());
  public static final IReadableResource INVOICE_PEPPOL = new ClassPathResource (PREFIX_XSLT + "PEPPOL-EN16931-UBL.xslt",
                                                                                _getCL ());

  public static final IReadableResource ORDER = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T01.xslt", _getCL ());

  public static final IReadableResource DESPATCH_ADVICE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T16.xslt",
                                                                                 _getCL ());

  public static final IReadableResource CATALOGUE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T19.xslt",
                                                                           _getCL ());

  public static final IReadableResource CATALOGUE_RESPONSE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T58.xslt",
                                                                                    _getCL ());

  public static final IReadableResource MLR = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T71.xslt", _getCL ());

  public static final IReadableResource ORDER_RESPONSE = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T76.xslt",
                                                                                _getCL ());

  public static final IReadableResource PUNCH_OUT = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T77.xslt",
                                                                           _getCL ());

  public static final IReadableResource ORDER_AGREEMENT = new ClassPathResource (PREFIX_XSLT + "PEPPOLBIS-T110.xslt",
                                                                                 _getCL ());

  public static final IReadableResource INVOICE_MESSAGE_RESPONSE = new ClassPathResource (PREFIX_XSLT +
                                                                                          "PEPPOLBIS-T111.xslt",
                                                                                          _getCL ());

  private PeppolValidation3_11_1 ()
  {}

  @Nonnull
  private static IValidationExecutorSetStatus _createStatus (final boolean bIsDeprecated)
  {
    return new ValidationExecutorSetStatus (PDTFactory.getCurrentOffsetDateTime (),
                                            bIsDeprecated ? EValidationExecutorStatusType.DEPRECATED
                                                          : EValidationExecutorStatusType.VALID,
                                            VALID_PER_UTC,
                                            PeppolValidation3_12_0.VALID_PER_UTC,
                                            (String) null,
                                            (DVRCoordinate) null,
                                            (ICommonsList <ValidationExecutorSetStatusHistoryItem>) null);
  }

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sVersion = " (" + VERSION_STR + ")";
    // See https://docs.peppol.eu/poacc/billing/3.0/release-notes/
    final String sAkaVersionBilling = " (aka BIS Billing 3.0.9)";
    // See https://docs.peppol.eu/poacc/upgrade-3/release-notes/
    final String sAkaVersionBIS = " (aka BIS 3.0.6)";

    final boolean bDeprecated = true;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_INVOICE_V3,
                                                                           "OpenPeppol Invoice" +
                                                                                                      sVersion +
                                                                                                      sAkaVersionBilling,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_CEN),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_PEPPOL)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                                                           "OpenPeppol Credit Note" +
                                                                                                          sVersion +
                                                                                                          sAkaVersionBilling,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_CEN),
                                                                           PhiveRulesUBLHelper.createXSLT_UBL21 (INVOICE_PEPPOL)));
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
  }
}
