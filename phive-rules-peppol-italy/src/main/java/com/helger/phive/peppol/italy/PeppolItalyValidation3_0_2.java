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
package com.helger.phive.peppol.italy;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesBuilder;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;

/**
 * Italian Peppol validation artefacts based on BIS 3.0.14.
 *
 * @author Philip Helger
 */
@Immutable
@Deprecated (forRemoval = false)
public final class PeppolItalyValidation3_0_2
{
  // Standard resources
  @Deprecated
  public static final String VERSION_STR = "3.0.2";

  // Standard
  @Deprecated
  public static final String GROUP_ID = "it.peppol";

  @Deprecated
  public static final DVRCoordinate VID_CREDIT_NOTE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                         "creditnote",
                                                                                         VERSION_STR);
  @Deprecated
  public static final DVRCoordinate VID_DESPATCH_ADVICE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "despatch-advice",
                                                                                             VERSION_STR);
  @Deprecated
  public static final DVRCoordinate VID_INVOICE = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", VERSION_STR);
  @Deprecated
  public static final DVRCoordinate VID_ORDER = PhiveRulesHelper.createCoordinate (GROUP_ID, "order", VERSION_STR);
  @Deprecated
  public static final DVRCoordinate VID_ORDER_AGREEMENT = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                             "order-agreement",
                                                                                             VERSION_STR);
  @Deprecated
  public static final DVRCoordinate VID_ORDER_RESPONSE = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                            "order-response",
                                                                                            VERSION_STR);

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolItalyValidation3_0_2.class.getClassLoader ();
  }

  private PeppolItalyValidation3_0_2 ()
  {}

  @Deprecated
  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sVersion = " (" + VERSION_STR + ")";
    final String sAkaVersionBIS = " (for BIS 3.0.14)";

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

    PhiveRulesBuilder.builder ()
                     .vesID (VID_DESPATCH_ADVICE)
                     .displayName ("AGID Peppol Despatch Advice" + sVersion + sAkaVersionBIS)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllDespatchAdviceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (DESPATCH_ADVICE,
                                                                  PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.despatchAdvice ()
                                                                                                                           .getRootElementNamespaceURI ())))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_INVOICE)
                     .displayName ("AGID Peppol Invoice" + sVersion + sAkaVersionBIS)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllInvoiceXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (INVOICE,
                                                                  PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.invoice ()
                                                                                                                           .getRootElementNamespaceURI ())))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_CREDIT_NOTE)
                     .displayName ("AGID Peppol Credit Note" + sVersion + sAkaVersionBIS)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllCreditNoteXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (INVOICE,
                                                                  PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.creditNote ()
                                                                                                                           .getRootElementNamespaceURI ())))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_ORDER)
                     .displayName ("AGID Peppol Order" + sVersion + sAkaVersionBIS)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (ORDER,
                                                                  PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.order ()
                                                                                                                           .getRootElementNamespaceURI ())))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_ORDER_AGREEMENT)
                     .displayName ("AGID Peppol Order Agreement" + sVersion + sAkaVersionBIS)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (ORDER_AGREEMENT,
                                                                  PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.orderResponse ()
                                                                                                                           .getRootElementNamespaceURI ())))
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_ORDER_RESPONSE)
                     .displayName ("AGID Peppol Order Response" + sVersion + sAkaVersionBIS)
                     .deprecated ()
                     .addXSD (UBL21Marshaller.getAllOrderResponseXSDs ())
                     .addSchematron (PhiveRulesHelper.createXSLT (ORDER_RESPONSE,
                                                                  PhiveRulesUBLHelper.createUBL21NSContext (UBL21Marshaller.orderResponse ()
                                                                                                                           .getRootElementNamespaceURI ())))
                     .registerInto (aRegistry);
  }
}
