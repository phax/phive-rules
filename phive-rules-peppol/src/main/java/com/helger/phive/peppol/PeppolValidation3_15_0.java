/*
 * Copyright (C) 2014-2022 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.cii.d16b.CIID16BNamespaceContext;
import com.helger.cii.d16b.ECIID16BDocumentType;
import com.helger.commons.ValueEnforcer;
import com.helger.commons.datetime.PDTFactory;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.version.Version;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.engine.schematron.ValidationExecutorSchematron;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.engine.xsd.ValidationExecutorXSD;
import com.helger.ubl21.EUBL21DocumentType;
import com.helger.ubl21.UBL21NamespaceContext;

/**
 * OpenPeppol validation artefacts release 3.15.0.<br>
 * November 2022 release 2022-05-05.<br>
 * Valid per Feb 6th, 2023
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidation3_15_0
{
  // Standard resources
  public static final Version PEPPOL_VALIDATION_ARTEFACT_VERSION = new Version (3, 15, 0);
  public static final String VERSION_STR = PEPPOL_VALIDATION_ARTEFACT_VERSION.getAsString (true);
  public static final LocalDate VALID_PER = PDTFactory.createLocalDate (2023, Month.FEBRUARY, 6);

  // Standard
  private static final String GROUP_ID = "eu.peppol.bis3";
  public static final VESID VID_OPENPEPPOL_INVOICE_UBL_V3 = new VESID (GROUP_ID, "invoice", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3 = new VESID (GROUP_ID, "creditnote", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_INVOICE_CII_V3 = new VESID (GROUP_ID, "invoice-cii", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_ORDER_V3 = new VESID (GROUP_ID, "order", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_DESPATCH_ADVICE_V3 = new VESID (GROUP_ID, "despatch-advice", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_CATALOGUE_V3 = new VESID (GROUP_ID, "catalogue", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3 = new VESID (GROUP_ID,
                                                                              "catalogue-response",
                                                                              VERSION_STR);
  public static final VESID VID_OPENPEPPOL_MLR_V3 = new VESID (GROUP_ID, "mlr", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_ORDER_RESPONSE_V3 = new VESID (GROUP_ID, "order-response", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_PUNCH_OUT_V3 = new VESID (GROUP_ID, "punch-out", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_ORDER_AGREEMENT_V3 = new VESID (GROUP_ID, "order-agreement", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3 = new VESID (GROUP_ID,
                                                                                    "invoice-message-response",
                                                                                    VERSION_STR);

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidation3_15_0.class.getClassLoader ();
  }

  private static final String PREFIX_XSLT = "schematron/openpeppol/" + VERSION_STR + "/xslt/";
  public static final IReadableResource INVOICE_UBL_CEN = new ClassPathResource (PREFIX_XSLT + "CEN-EN16931-UBL.xslt",
                                                                                 _getCL ());
  public static final IReadableResource INVOICE_UBL_PEPPOL = new ClassPathResource (PREFIX_XSLT +
                                                                                    "PEPPOL-EN16931-UBL.xslt",
                                                                                    _getCL ());

  public static final IReadableResource INVOICE_CII_CEN = new ClassPathResource (PREFIX_XSLT + "CEN-EN16931-CII.xslt",
                                                                                 _getCL ());
  public static final IReadableResource INVOICE_CII_PEPPOL = new ClassPathResource (PREFIX_XSLT +
                                                                                    "PEPPOL-EN16931-CII.xslt",
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

  private PeppolValidation3_15_0 ()
  {}

  @Nonnull
  private static ValidationExecutorSchematron _createXsltCII (@Nonnull final IReadableResource aRes)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, CIID16BNamespaceContext.getInstance ());
  }

  @Nonnull
  private static ValidationExecutorSchematron _createXsltUBL (@Nonnull final IReadableResource aRes)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, UBL21NamespaceContext.getInstance ());
  }

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sVersion = " (" + VERSION_STR + ")";
    // See https://docs.peppol.eu/poacc/billing/3.0/release-notes/
    final String sAkaVersionBilling = " (aka BIS Billing 3.0.14)";
    // See https://docs.peppol.eu/poacc/upgrade-3/release-notes/
    final String sAkaVersionBIS = " (aka BIS 3.0.10)";

    final boolean bNotDeprecated = false;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_INVOICE_UBL_V3,
                                                                           "OpenPeppol UBL Invoice" +
                                                                                                          sVersion +
                                                                                                          sAkaVersionBilling,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXsltUBL (INVOICE_UBL_CEN),
                                                                           _createXsltUBL (INVOICE_UBL_PEPPOL)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                                                           "OpenPeppol UBL Credit Note" +
                                                                                                              sVersion +
                                                                                                              sAkaVersionBilling,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           _createXsltUBL (INVOICE_UBL_CEN),
                                                                           _createXsltUBL (INVOICE_UBL_PEPPOL)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_INVOICE_CII_V3,
                                                                           "OpenPeppol CII Invoice" +
                                                                                                          sVersion +
                                                                                                          sAkaVersionBilling,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (ECIID16BDocumentType.CROSS_INDUSTRY_INVOICE),
                                                                           _createXsltCII (INVOICE_CII_CEN),
                                                                           _createXsltCII (INVOICE_CII_PEPPOL)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_V3,
                                                                           "OpenPeppol Order" +
                                                                                                    sVersion +
                                                                                                    sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER),
                                                                           _createXsltUBL (ORDER)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                                           "OpenPeppol Despatch Advice" +
                                                                                                              sVersion +
                                                                                                              sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.DESPATCH_ADVICE),
                                                                           _createXsltUBL (DESPATCH_ADVICE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CATALOGUE_V3,
                                                                           "OpenPeppol Catalogue" +
                                                                                                        sVersion +
                                                                                                        sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CATALOGUE),
                                                                           _createXsltUBL (CATALOGUE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                                           "OpenPeppol Catalogue Response" +
                                                                                                                 sVersion +
                                                                                                                 sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.APPLICATION_RESPONSE),
                                                                           _createXsltUBL (CATALOGUE_RESPONSE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MLR_V3,
                                                                           "OpenPeppol MLR" + sVersion + sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.APPLICATION_RESPONSE),
                                                                           _createXsltUBL (MLR)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                                           "OpenPeppol Order Response" +
                                                                                                             sVersion +
                                                                                                             sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER_RESPONSE),
                                                                           _createXsltUBL (ORDER_RESPONSE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                                           "OpenPeppol Punch Out" +
                                                                                                        sVersion +
                                                                                                        sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CATALOGUE),
                                                                           _createXsltUBL (PUNCH_OUT)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                                           "OpenPeppol Order Agreement" +
                                                                                                              sVersion +
                                                                                                              sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER_RESPONSE),
                                                                           _createXsltUBL (ORDER_AGREEMENT)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,
                                                                           "OpenPeppol Invoice Message Response" +
                                                                                                                       sVersion +
                                                                                                                       sAkaVersionBIS,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.APPLICATION_RESPONSE),
                                                                           _createXsltUBL (INVOICE_MESSAGE_RESPONSE)));
  }
}
