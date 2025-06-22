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
package com.helger.phive.peppol.italy;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;

/**
 * Italian Peppol validation artefacts based on BIS 3.0.17.
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolItalyValidation3_2_1
{
  // Standard resources
  public static final String VERSION_STR = "3.2.1";

  // Standard
  public static final String GROUP_ID = "it.peppol";

  public static final DVRCoordinate VID_CREDIT_NOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                         "creditnote",
                                                                                         VERSION_STR);
  public static final DVRCoordinate VID_DESPATCH_ADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "despatch-advice",
                                                                                             VERSION_STR);
  public static final DVRCoordinate VID_INVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", VERSION_STR);
  public static final DVRCoordinate VID_ORDER = PhiveRulesHelper.createCoordinate (GROUP_ID, "order", VERSION_STR);
  public static final DVRCoordinate VID_ORDER_AGREEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "order-agreement",
                                                                                             VERSION_STR);
  public static final DVRCoordinate VID_ORDER_RESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "order-response",
                                                                                            VERSION_STR);

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolItalyValidation3_2_1.class.getClassLoader ();
  }

  private PeppolItalyValidation3_2_1 ()
  {}

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sVersion = " (" + VERSION_STR + ")";
    final String sAkaVersionBIS = " (for BIS 3.0.18)";

    final String PREFIX_XSLT = "external/schematron/peppol-italy/" + VERSION_STR + "/";
    final IReadableResource DESPATCH_ADVICE = new ClassPathResource (PREFIX_XSLT +
                                                                     "despatch-advice/AGID-PEPPOL-T16.xslt",
                                                                     _getCL ());
    final IReadableResource INVOICE = new ClassPathResource (PREFIX_XSLT + "invoice/AGID-EN16931-UBL.xslt", _getCL ());
    final IReadableResource ORDER = new ClassPathResource (PREFIX_XSLT + "order/AGID-PEPPOL-T01.xslt", _getCL ());
    final IReadableResource ORDER_AGREEMENT = new ClassPathResource (PREFIX_XSLT +
                                                                     "order-agreement/AGID-PEPPOL-T110.xslt",
                                                                     _getCL ());
    final IReadableResource ORDER_RESPONSE = new ClassPathResource (PREFIX_XSLT + "order-response/AGID-PEPPOL-T76.xslt",
                                                                    _getCL ());

    final boolean bNotDeprecated = false;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_DESPATCH_ADVICE,
                                                                           "AGID Peppol Despatch Advice" +
                                                                                                sVersion +
                                                                                                sAkaVersionBIS,
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllDespatchAdviceXSDs ()),
                                                                           PhiveRulesHelper.createXSLT (DESPATCH_ADVICE,
                                                                                                        PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.despatchAdvice ()
                                                                                                                                                                 .getRootElementNamespaceURI ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_INVOICE,
                                                                           "AGID Peppol Invoice" +
                                                                                        sVersion +
                                                                                        sAkaVersionBIS,
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           PhiveRulesHelper.createXSLT (INVOICE,
                                                                                                        PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                                                                                 .getRootElementNamespaceURI ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CREDIT_NOTE,
                                                                           "AGID Peppol Credit Note" +
                                                                                            sVersion +
                                                                                            sAkaVersionBIS,
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                           PhiveRulesHelper.createXSLT (INVOICE,
                                                                                                        PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                                                                                 .getRootElementNamespaceURI ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ORDER,
                                                                           "AGID Peppol Order" +
                                                                                      sVersion +
                                                                                      sAkaVersionBIS,
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                           PhiveRulesHelper.createXSLT (ORDER,
                                                                                                        PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.order ()
                                                                                                                                                                 .getRootElementNamespaceURI ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ORDER_AGREEMENT,
                                                                           "AGID Peppol Order Agreement" +
                                                                                                sVersion +
                                                                                                sAkaVersionBIS,
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           PhiveRulesHelper.createXSLT (ORDER_AGREEMENT,
                                                                                                        PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.orderResponse ()
                                                                                                                                                                 .getRootElementNamespaceURI ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ORDER_RESPONSE,
                                                                           "AGID Peppol Order Response" +
                                                                                               sVersion +
                                                                                               sAkaVersionBIS,
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           PhiveRulesHelper.createXSLT (ORDER_RESPONSE,
                                                                                                        PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.orderResponse ()
                                                                                                                                                                 .getRootElementNamespaceURI ()))));
  }
}
