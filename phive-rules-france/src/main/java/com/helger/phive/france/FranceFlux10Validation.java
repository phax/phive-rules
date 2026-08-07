/*
 * Copyright (C) 2025-2026 Philip Helger (www.helger.com)
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
package com.helger.phive.france;

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

/**
 * France PPF Flux 10 (e-reporting) validation configuration. Flux 10 uses a dedicated
 * <code>Report</code> XML format that is neither UBL nor CII and whose root element has no XML
 * namespace.
 *
 * @author Philip Helger
 * @since 4.5.0
 */
@Immutable
public final class FranceFlux10Validation
{
  public static final String GROUP_ID = "fr.ctc.flux10";

  // v1.0
  public static final DVRCoordinate VID_FR_FLUX10_REPORT_1_0 = DVRHelper.createCoordinate (GROUP_ID, "report", "1.0");

  private FranceFlux10Validation ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return FranceFlux10Validation.class.getClassLoader ();
  }

  /**
   * Register all France PPF Flux 10 validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initFranceFlux10 (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String sXsdPrefix = "/external/schemas/flux10/1.0/";
    final String sPrefix = "/external/schematron/flux10/1.0/xslt/";

    VesXmlBuilder.builder ()
                 .vesID (VID_FR_FLUX10_REPORT_1_0)
                 .displayNamePrefix ("France PPF Flux 10 e-reporting ")
                 .notDeprecated ()
                 .addXSD (new ClassPathResource (sXsdPrefix + "ereporting.xsd", _getCL ()))
                 .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (sPrefix + "PPF_Flux10_v1_0.xslt",
                                                                                     _getCL ()), null))
                 .registerInto (aRegistry);
  }
}
