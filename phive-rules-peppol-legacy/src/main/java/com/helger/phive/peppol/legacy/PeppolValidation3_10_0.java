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

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.datetime.PDTFactory;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.commons.version.Version;
import com.helger.diver.api.version.VESID;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatus;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl21.UBL21NamespaceContext;

/**
 * OpenPeppol validation artefacts release 3.10.0. Spring 2020 release. Valid
 * per May 15th, 2020
 *
 * @author Philip Helger
 */
@Deprecated
@Immutable
public final class PeppolValidation3_10_0
{
  // Standard resources
  public static final Version PEPPOL_VALIDATION_ARTEFACT_VERSION = new Version (3, 10, 0);
  public static final String VERSION_STR = PEPPOL_VALIDATION_ARTEFACT_VERSION.getAsString (true);
  public static final LocalDate VALID_PER = PDTFactory.createLocalDate (2020, Month.MAY, 15);

  // Standard
  private static final String GROUP_ID = "eu.peppol.bis3";
  public static final VESID VID_OPENPEPPOL_INVOICE_V3 = new VESID (GROUP_ID, "invoice", VERSION_STR);
  public static final VESID VID_OPENPEPPOL_CREDIT_NOTE_V3 = new VESID (GROUP_ID, "creditnote", VERSION_STR);

  public static final VESID VID_OPENPEPPOL_ORDER_V3 = new VESID (GROUP_ID, "order", VERSION_STR);
  /**
   * @deprecated Use {@link #VID_OPENPEPPOL_ORDER_V3} instead
   */
  @Deprecated
  public static final VESID VID_OPENPEPPOL_T01_V3 = new VESID (GROUP_ID, "t01", VERSION_STR);

  public static final VESID VID_OPENPEPPOL_DESPATCH_ADVICE_V3 = new VESID (GROUP_ID, "despatch-advice", VERSION_STR);
  /**
   * @deprecated Use {@link #VID_OPENPEPPOL_DESPATCH_ADVICE_V3} instead
   */
  @Deprecated
  public static final VESID VID_OPENPEPPOL_T16_V3 = new VESID (GROUP_ID, "t16", VERSION_STR);

  public static final VESID VID_OPENPEPPOL_CATALOGUE_V3 = new VESID (GROUP_ID, "catalogue", VERSION_STR);
  /**
   * @deprecated Use {@link #VID_OPENPEPPOL_CATALOGUE_V3} instead
   */
  @Deprecated
  public static final VESID VID_OPENPEPPOL_T19_V3 = new VESID (GROUP_ID, "t19", VERSION_STR);

  public static final VESID VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3 = new VESID (GROUP_ID,
                                                                              "catalogue-response",
                                                                              VERSION_STR);
  /**
   * @deprecated Use {@link #VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3} instead
   */
  @Deprecated
  public static final VESID VID_OPENPEPPOL_T58_V3 = new VESID (GROUP_ID, "t58", VERSION_STR);

  public static final VESID VID_OPENPEPPOL_MLR_V3 = new VESID (GROUP_ID, "mlr", VERSION_STR);
  /**
   * @deprecated Use {@link #VID_OPENPEPPOL_MLR_V3} instead
   */
  @Deprecated
  public static final VESID VID_OPENPEPPOL_T71_V3 = new VESID (GROUP_ID, "t71", VERSION_STR);

  public static final VESID VID_OPENPEPPOL_ORDER_RESPONSE_V3 = new VESID (GROUP_ID, "order-response", VERSION_STR);
  /**
   * @deprecated Use {@link #VID_OPENPEPPOL_ORDER_RESPONSE_V3} instead
   */
  @Deprecated
  public static final VESID VID_OPENPEPPOL_T76_V3 = new VESID (GROUP_ID, "t76", VERSION_STR);

  public static final VESID VID_OPENPEPPOL_PUNCH_OUT_V3 = new VESID (GROUP_ID, "punch-out", VERSION_STR);
  /**
   * @deprecated Use {@link #VID_OPENPEPPOL_PUNCH_OUT_V3} instead
   */
  @Deprecated
  public static final VESID VID_OPENPEPPOL_T77_V3 = new VESID (GROUP_ID, "t77", VERSION_STR);

  public static final VESID VID_OPENPEPPOL_ORDER_AGREEMENT_V3 = new VESID (GROUP_ID, "order-agreement", VERSION_STR);
  /**
   * @deprecated Use {@link #VID_OPENPEPPOL_ORDER_AGREEMENT_V3} instead
   */
  @Deprecated
  public static final VESID VID_OPENPEPPOL_T110_V3 = new VESID (GROUP_ID, "t110", VERSION_STR);

  public static final VESID VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3 = new VESID (GROUP_ID,
                                                                                    "invoice-message-response",
                                                                                    VERSION_STR);
  /**
   * @deprecated Use {@link #VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3} instead
   */
  @Deprecated
  public static final VESID VID_OPENPEPPOL_T111_V3 = new VESID (GROUP_ID, "t111", VERSION_STR);

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidation3_10_0.class.getClassLoader ();
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

  private PeppolValidation3_10_0 ()
  {}

  @Nonnull
  private static ValidationExecutorSchematron _createXSLT (@Nonnull final IReadableResource aRes)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, UBL21NamespaceContext.getInstance ());
  }

  @Nonnull
  private static IValidationExecutorSetStatus _createStatus (final boolean bIsDeprecated)
  {
    return ValidationExecutorSetStatus.createDeprecatedNow (bIsDeprecated);
  }

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sVersion = " (" + VERSION_STR + ")";
    final String sAkaVersionBilling = " (aka BIS Billing 3.0.6)";
    final String sAkaVersionBIS = " (aka BIS 3.0.4)";

    final boolean bDeprecated = true;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_INVOICE_V3,
                                                                           "OpenPeppol Invoice" +
                                                                                                      sVersion +
                                                                                                      sAkaVersionBilling,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE_CEN),
                                                                           _createXSLT (INVOICE_PEPPOL)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CREDIT_NOTE_V3,
                                                                           "OpenPeppol Credit Note" +
                                                                                                          sVersion +
                                                                                                          sAkaVersionBilling,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           _createXSLT (INVOICE_CEN),
                                                                           _createXSLT (INVOICE_PEPPOL)));

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_T01_V3,
                                                                           "OpenPeppol Order" +
                                                                                                  sVersion +
                                                                                                  sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                           _createXSLT (ORDER)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_V3,
                                                                           "OpenPeppol Order" +
                                                                                                    sVersion +
                                                                                                    sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                           _createXSLT (ORDER)));

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_T16_V3,
                                                                           "OpenPeppol Despatch Advice" +
                                                                                                  sVersion +
                                                                                                  sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllDespatchAdviceXSDs ()),
                                                                           _createXSLT (DESPATCH_ADVICE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_DESPATCH_ADVICE_V3,
                                                                           "OpenPeppol Despatch Advice" +
                                                                                                              sVersion +
                                                                                                              sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllDespatchAdviceXSDs ()),
                                                                           _createXSLT (DESPATCH_ADVICE)));

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_T19_V3,
                                                                           "OpenPeppol Catalogue" +
                                                                                                  sVersion +
                                                                                                  sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                           _createXSLT (CATALOGUE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CATALOGUE_V3,
                                                                           "OpenPeppol Catalogue" +
                                                                                                        sVersion +
                                                                                                        sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                           _createXSLT (CATALOGUE)));

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_T58_V3,
                                                                           "OpenPeppol Catalogue Response" +
                                                                                                  sVersion +
                                                                                                  sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                           _createXSLT (CATALOGUE_RESPONSE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_CATALOGUE_RESPONSE_V3,
                                                                           "OpenPeppol Catalogue Response" +
                                                                                                                 sVersion +
                                                                                                                 sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                           _createXSLT (CATALOGUE_RESPONSE)));

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_T71_V3,
                                                                           "OpenPeppol MLR" + sVersion + sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                           _createXSLT (MLR)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MLR_V3,
                                                                           "OpenPeppol MLR" + sVersion + sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                           _createXSLT (MLR)));

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_T76_V3,
                                                                           "OpenPeppol Order Response" +
                                                                                                  sVersion +
                                                                                                  sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           _createXSLT (ORDER_RESPONSE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_RESPONSE_V3,
                                                                           "OpenPeppol Order Response" +
                                                                                                             sVersion +
                                                                                                             sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           _createXSLT (ORDER_RESPONSE)));

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_T77_V3,
                                                                           "OpenPeppol Punch Out" +
                                                                                                  sVersion +
                                                                                                  sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                           _createXSLT (PUNCH_OUT)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_PUNCH_OUT_V3,
                                                                           "OpenPeppol Punch Out" +
                                                                                                        sVersion +
                                                                                                        sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCatalogueXSDs ()),
                                                                           _createXSLT (PUNCH_OUT)));

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_T110_V3,
                                                                           "OpenPeppol Order Agreement" +
                                                                                                   sVersion +
                                                                                                   sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           _createXSLT (ORDER_AGREEMENT)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_ORDER_AGREEMENT_V3,
                                                                           "OpenPeppol Order Agreement" +
                                                                                                              sVersion +
                                                                                                              sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           _createXSLT (ORDER_AGREEMENT)));

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_T111_V3,
                                                                           "OpenPeppol Invoice Message Response" +
                                                                                                   sVersion +
                                                                                                   sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                           _createXSLT (INVOICE_MESSAGE_RESPONSE)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_INVOICE_MESSAGE_RESPONSE_V3,
                                                                           "OpenPeppol Invoice Message Response" +
                                                                                                                       sVersion +
                                                                                                                       sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                           _createXSLT (INVOICE_MESSAGE_RESPONSE)));
  }
}
