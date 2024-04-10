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
package com.helger.phive.peppol.italy;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.version.VESID;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatus;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.IIterableNamespaceContext;

/**
 * Italian Peppol validation artefacts based on BIS 3.0.11.
 *
 * @author Philip Helger
 */
@Immutable
@Deprecated
public final class PeppolItalyValidation2_3_0
{
  // Standard resources
  public static final String VERSION_STR = "2.3.0";

  // Standard
  private static final String GROUP_ID = "it.peppol";

  public static final VESID VID_DESPATCH_ADVICE = new VESID (GROUP_ID, "despatch-advice", VERSION_STR);
  public static final VESID VID_INVOICE = new VESID (GROUP_ID, "invoice", VERSION_STR);
  public static final VESID VID_ORDER = new VESID (GROUP_ID, "order", VERSION_STR);
  public static final VESID VID_ORDER_AGREEMENT = new VESID (GROUP_ID, "order-agreement", VERSION_STR);
  public static final VESID VID_ORDER_RESPONSE = new VESID (GROUP_ID, "order-response", VERSION_STR);

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolItalyValidation2_3_0.class.getClassLoader ();
  }

  private static final String PREFIX_XSLT = "external/schematron/peppol-italy/" + VERSION_STR + "/";

  public static final IReadableResource DESPATCH_ADVICE = new ClassPathResource (PREFIX_XSLT +
                                                                                 "despatch-advice/AGID-PEPPOL-T16.xslt",
                                                                                 _getCL ());
  public static final IReadableResource INVOICE = new ClassPathResource (PREFIX_XSLT + "invoice/AGID-EN16931-UBL.xslt",
                                                                         _getCL ());
  public static final IReadableResource ORDER = new ClassPathResource (PREFIX_XSLT + "order/AGID-PEPPOL-T01.xslt",
                                                                       _getCL ());
  public static final IReadableResource ORDER_AGREEMENT = new ClassPathResource (PREFIX_XSLT +
                                                                                 "order-agreement/AGID-PEPPOL-T110.xslt",
                                                                                 _getCL ());
  public static final IReadableResource ORDER_RESPONSE = new ClassPathResource (PREFIX_XSLT +
                                                                                "order-response/AGID-PEPPOL-T76.xslt",
                                                                                _getCL ());

  private PeppolItalyValidation2_3_0 ()
  {}

  @Nonnull
  private static ValidationExecutorSchematron _createXSLT (@Nonnull final IReadableResource aRes,
                                                           @Nonnull final IIterableNamespaceContext aNamespaceContext)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, aNamespaceContext);
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
    final String sAkaVersionBIS = " (for BIS 3.0.11)";

    final boolean bDeprecated = true;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_DESPATCH_ADVICE,
                                                                           "AGID Peppol Despatch Advice" +
                                                                                                sVersion +
                                                                                                sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllDespatchAdviceXSDs ()),
                                                                           _createXSLT (DESPATCH_ADVICE,
                                                                                        PeppolItalyValidation.createUBLNSContext (UBL21Marshaller.despatchAdvice ()
                                                                                                                                                 .getRootElementNamespaceURI ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_INVOICE,
                                                                           "AGID Peppol Invoice" +
                                                                                        sVersion +
                                                                                        sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                           _createXSLT (INVOICE,
                                                                                        PeppolItalyValidation.createUBLNSContext (UBL21Marshaller.invoice ()
                                                                                                                                                 .getRootElementNamespaceURI ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ORDER,
                                                                           "AGID Peppol Order" +
                                                                                      sVersion +
                                                                                      sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderXSDs ()),
                                                                           _createXSLT (ORDER,
                                                                                        PeppolItalyValidation.createUBLNSContext (UBL21Marshaller.order ()
                                                                                                                                                 .getRootElementNamespaceURI ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ORDER_AGREEMENT,
                                                                           "AGID Peppol Order Agreement" +
                                                                                                sVersion +
                                                                                                sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           _createXSLT (ORDER_AGREEMENT,
                                                                                        PeppolItalyValidation.createUBLNSContext (UBL21Marshaller.orderResponse ()
                                                                                                                                                 .getRootElementNamespaceURI ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ORDER_RESPONSE,
                                                                           "AGID Peppol Order Response" +
                                                                                               sVersion +
                                                                                               sAkaVersionBIS,
                                                                           _createStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (UBL21Marshaller.getAllOrderResponseXSDs ()),
                                                                           _createXSLT (ORDER_RESPONSE,
                                                                                        PeppolItalyValidation.createUBLNSContext (UBL21Marshaller.orderResponse ()
                                                                                                                                                 .getRootElementNamespaceURI ()))));
  }
}
