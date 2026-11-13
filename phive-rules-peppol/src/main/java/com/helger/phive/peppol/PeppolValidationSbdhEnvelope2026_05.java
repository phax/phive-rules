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

import javax.xml.xpath.XPath;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.shared.DVRHelper;
import com.helger.phive.rules.shared.PhiveRulesHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.schematron.ValidationExecutorSchematronBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSDPartial;
import com.helger.phive.xml.xsd.XSDPartialContext;
import com.helger.sbdh.CSBDH;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.xpath.XPathHelper;

/**
 * Peppol BIS Billing and Self-Billing documents enveloped in a Peppol Business Message Envelope
 * (SBDH), based on the OpenPeppol validation artefacts release May 2026.
 * <p>
 * The validated document is the complete SBDH envelope (<code>StandardBusinessDocument</code>).
 * Each VES consists of:
 * <ol>
 * <li>the XML Schema of the SBDH header - the header must be present, so an unwrapped business
 * document is rejected</li>
 * <li>all executors of the respective Peppol BIS 2026.5 VES (XML Schema, CEN and Peppol
 * Schematron), applied on the contained business document only, which must be present exactly
 * once</li>
 * <li>the "Peppol BIS Envelope Rules" Schematron (rules <code>BR-SBDH-1</code> to
 * <code>BR-SBDH-4</code>), checking that the SBDH sender and receiver match the endpoint IDs of the
 * business document. Use of this Schematron is optional, but conformance to the rules is mandatory.
 * It is only applied for BIS Billing and Self-Billing documents.</li>
 * </ol>
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolValidationSbdhEnvelope2026_05
{
  public static final String GROUP_ID = "org.peppol.bis3.sbdh-envelope";
  public static final String VERSION_STR = PeppolValidation2026_05.VERSION_STR;

  public static final DVRCoordinate VID_SBDH_INVOICE = DVRHelper.createCoordinate (GROUP_ID, "invoice", VERSION_STR);
  public static final DVRCoordinate VID_SBDH_CREDIT_NOTE = DVRHelper.createCoordinate (GROUP_ID,
                                                                                       "creditnote",
                                                                                       VERSION_STR);
  public static final DVRCoordinate VID_SBDH_INVOICE_SELF_BILLING = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                "invoice-self-billing",
                                                                                                VERSION_STR);
  public static final DVRCoordinate VID_SBDH_CREDIT_NOTE_SELF_BILLING = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                    "creditnote-self-billing",
                                                                                                    VERSION_STR);

  private static final String SUFFIX_VERSION = " (" + VERSION_STR + ")";
  private static final String PREFIX_XSLT = "external/schematron/openpeppol/" + VERSION_STR + "/xslt/";

  private PeppolValidationSbdhEnvelope2026_05 ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationSbdhEnvelope2026_05.class.getClassLoader ();
  }

  /**
   * @return The VES IDs of the Peppol BIS VES that are applied on the business documents. Never
   *         <code>null</code>.
   */
  @NonNull
  public static DVRCoordinate [] getAllPrerequisites ()
  {
    return new DVRCoordinate [] { PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_UBL_V3,
                                  PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
                                  PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3,
                                  PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3 };
  }

  private static void _register (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry,
                                 @NonNull final XPath aXP,
                                 @NonNull final ValidationExecutorSchematron aEnvelopeRules,
                                 @NonNull final DVRCoordinate aVESID,
                                 @NonNull @Nonempty final String sDisplayName,
                                 @NonNull final DVRCoordinate aBaseVESID,
                                 @NonNull @Nonempty final String sPayloadXPath)
  {
    VesXmlBuilder.builder ()
                 .vesID (aVESID)
                 .displayName (sDisplayName + SUFFIX_VERSION)
                 .notDeprecated ()
                 .validFrom (PeppolValidation2026_05.VALID_PER_UTC)
                 // The SBDH header must be present - this is what makes an unwrapped document fail
                 .addExecutorsManually (new CommonsArrayList <> (ValidationExecutorXSDPartial.create (CSBDH.SBDH_XSDS,
                                                                                                      XSDPartialContext.builder ()
                                                                                                                       .xpathExpression (aXP,
                                                                                                                                         "/sh:StandardBusinessDocument/sh:StandardBusinessDocumentHeader")
                                                                                                                       .exactNodeCount (1)
                                                                                                                       .build ())))
                 // Envelope Schematron
                 .addSchematron (aEnvelopeRules)
                 // The business document is validated with the existing BIS VES
                 .addPartialVES (PhiveRulesHelper.requireVESID (aRegistry, aBaseVESID),
                                 XSDPartialContext.builder ()
                                                  .xpathExpression (aXP, sPayloadXPath)
                                                  .exactNodeCount (1)
                                                  .build (),
                                 null)
                 .registerInto (aRegistry);
  }

  /**
   * Register the Peppol BIS Billing and Self-Billing SBDH envelope validation execution sets. The
   * respective Peppol BIS 2026.5 VES must already be registered.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   * @see PeppolValidation2026_05#initBilling(IValidationExecutorSetRegistry)
   */
  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // The rules address the SBDH envelope as well as the contained Invoice and Credit Note
    final MapBasedNamespaceContext aNSCtx = UBL21NamespaceContext.getInstance ().getClone ();
    aNSCtx.addMapping ("sh", CSBDH.SBDH_NS);
    aNSCtx.addMapping ("ubl", UBL21Marshaller.invoice ().getRootElementNamespaceURI ());
    aNSCtx.addMapping ("cn", UBL21Marshaller.creditNote ().getRootElementNamespaceURI ());

    final XPath aXP = XPathHelper.createXPathFactorySaxonFirst ().newXPath ();
    aXP.setNamespaceContext (aNSCtx);

    // The envelope rules only apply to BIS Billing and Self-Billing documents (the Schematron
    // itself additionally checks the ProfileID)
    final String sCustomizationID = "normalize-space(/sh:StandardBusinessDocument/*/cbc:CustomizationID)";
    final ValidationExecutorSchematron aEnvelopeRules = new ValidationExecutorSchematronBuilder (PhiveRulesHelper.createXSLT (new ClassPathResource (PREFIX_XSLT +
                                                                                                                                                     "PeppolBIS-Envelope-Rules.xslt",
                                                                                                                                                     _getCL ()),
                                                                                                                              aNSCtx)).prerequisiteXPath (sCustomizationID +
                                                                                                                                                          " = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0' or " +
                                                                                                                                                          sCustomizationID +
                                                                                                                                                          " = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:selfbilling:3.0'")
                                                                                                                                      .build ();

    _register (aRegistry,
               aXP,
               aEnvelopeRules,
               VID_SBDH_INVOICE,
               "OpenPeppol UBL Invoice in SBDH",
               PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_UBL_V3,
               "/sh:StandardBusinessDocument/ubl:Invoice");
    _register (aRegistry,
               aXP,
               aEnvelopeRules,
               VID_SBDH_CREDIT_NOTE,
               "OpenPeppol UBL Credit Note in SBDH",
               PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3,
               "/sh:StandardBusinessDocument/cn:CreditNote");
    _register (aRegistry,
               aXP,
               aEnvelopeRules,
               VID_SBDH_INVOICE_SELF_BILLING,
               "OpenPeppol UBL Invoice Self-Billing in SBDH",
               PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3,
               "/sh:StandardBusinessDocument/ubl:Invoice");
    _register (aRegistry,
               aXP,
               aEnvelopeRules,
               VID_SBDH_CREDIT_NOTE_SELF_BILLING,
               "OpenPeppol UBL Credit Note Self-Billing in SBDH",
               PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3,
               "/sh:StandardBusinessDocument/cn:CreditNote");
  }
}
