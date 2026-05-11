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
package com.helger.phive.osa;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Hungarian NAV Online Számla (OSA) validation configuration.
 *
 * @author Philip Helger
 */
@Immutable
public final class OSAValidation
{
  public static final String GROUP_ID = "hu.gov.nav.osa";

  // v2.0
  public static final DVRCoordinate VID_OSA_INVOICE_DATA_20 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "invoice-data",
                                                                                                 "2.0");
  public static final DVRCoordinate VID_OSA_INVOICE_ANNULMENT_20 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "invoice-annulment",
                                                                                                      "2.0");

  // v3.0
  public static final DVRCoordinate VID_OSA_INVOICE_DATA_30 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "invoice-data",
                                                                                                 "3.0");
  public static final DVRCoordinate VID_OSA_INVOICE_ANNULMENT_30 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                      "invoice-annulment",
                                                                                                      "3.0");

  private OSAValidation ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return OSAValidation.class.getClassLoader ();
  }

  /**
   * Register all standard OSA validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initOSA (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // OSA v2.0 - no Schematron
    {
      VesXmlBuilder.builder ()
                   .vesID (VID_OSA_INVOICE_DATA_20)
                   .displayNamePrefix ("OSA InvoiceData ")
                   .notDeprecated ()
                   .addXSD (new ClassPathResource ("/external/schemas/v2.0/invoiceData.xsd", _getCL ()))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OSA_INVOICE_ANNULMENT_20)
                   .displayNamePrefix ("OSA InvoiceAnnulment ")
                   .notDeprecated ()
                   .addXSD (new ClassPathResource ("/external/schemas/v2.0/invoiceData.xsd", _getCL ()),
                            new ClassPathResource ("/external/schemas/v2.0/invoiceAnnulment.xsd", _getCL ()))
                   .registerInto (aRegistry);
    }

    // OSA v3.0 - no Schematron
    {
      VesXmlBuilder.builder ()
                   .vesID (VID_OSA_INVOICE_DATA_30)
                   .displayNamePrefix ("OSA InvoiceData ")
                   .notDeprecated ()
                   .addXSD (new ClassPathResource ("/external/schemas/v3.0/common.xsd", _getCL ()),
                            new ClassPathResource ("/external/schemas/v3.0/invoiceBase.xsd", _getCL ()),
                            new ClassPathResource ("/external/schemas/v3.0/invoiceData.xsd", _getCL ()))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_OSA_INVOICE_ANNULMENT_30)
                   .displayNamePrefix ("OSA InvoiceAnnulment ")
                   .notDeprecated ()
                   .addXSD (new ClassPathResource ("/external/schemas/v3.0/common.xsd", _getCL ()),
                            new ClassPathResource ("/external/schemas/v3.0/invoiceBase.xsd", _getCL ()),
                            new ClassPathResource ("/external/schemas/v3.0/invoiceAnnulment.xsd", _getCL ()))
                   .registerInto (aRegistry);
    }
  }
}
