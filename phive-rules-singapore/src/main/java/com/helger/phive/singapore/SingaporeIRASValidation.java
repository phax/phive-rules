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
package com.helger.phive.singapore;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.shared.DVRHelper;
import com.helger.phive.rules.shared.PhiveRulesHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.sbdh.CSBDH;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Singapore IRAS GST InvoiceNow validation configuration.
 * <p>
 * The Inland Revenue Authority of Singapore (IRAS) requires GST registered businesses to transmit
 * their invoice data to IRAS via the InvoiceNow (Peppol) network. The
 * <code>non_peppol_doc_validation</code> Schematron published by IRAS as part of the C5
 * accreditation resources contains the rules that such a data submission must satisfy.
 * <p>
 * The validated document is the complete SBDH envelope (<code>StandardBusinessDocument</code>) and
 * not the contained UBL Invoice or Credit Note, because four of the rules
 * (<code>IRASC5-001</code> to <code>IRASC5-004</code>) have the SBDH header as their context. A
 * single submission may contain more than one UBL document ("bulk" submission), which is why no XSD
 * layer is present - the SBDH 1.3 XML Schema permits exactly one payload element.
 *
 * @author Philip Helger
 */
@Immutable
public final class SingaporeIRASValidation
{
  public static final String GROUP_ID = "sg.gov.iras";

  /**
   * IRAS GST InvoiceNow data submission, state of 2026-09-08. IRAS does not maintain a version
   * number in the Schematron itself - the title claims "v0.3.4" since January 2025 - so the date of
   * the last entry of the accompanying changelog is used as the version.
   */
  public static final DVRCoordinate VID_SG_IRAS_INVOICENOW_GST_2026_9_8 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                      "invoicenow-gst",
                                                                                                      "2026.9.8");

  private SingaporeIRASValidation ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return SingaporeIRASValidation.class.getClassLoader ();
  }

  /**
   * Register all standard Singapore IRAS validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initSingaporeIRAS (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // The rules address the SBDH envelope as well as the contained UBL Invoice and Credit Note, so
    // the namespace context needs the prefixes of all three
    final MapBasedNamespaceContext aNSCtx = UBL21NamespaceContext.getInstance ().getClone ();
    aNSCtx.addMapping ("sh", CSBDH.SBDH_NS);
    aNSCtx.addMapping ("ubl", UBL21Marshaller.invoice ().getRootElementNamespaceURI ());
    aNSCtx.addMapping ("cn", UBL21Marshaller.creditNote ().getRootElementNamespaceURI ());

    // 2026.9.8
    {
      final String sPrefix = "/external/schematron/invoicenow-gst/2026.9.8/xslt/";
      VesXmlBuilder.builder ()
                   .vesID (VID_SG_IRAS_INVOICENOW_GST_2026_9_8)
                   .displayNamePrefix ("Singapore IRAS GST InvoiceNow data submission ")
                   .notDeprecated ()
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sPrefix +
                                                                                       "non_peppol_doc_validation.xslt",
                                                                                       _getCL ()), aNSCtx))
                   .registerInto (aRegistry);
    }
  }
}
