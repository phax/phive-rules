/*
 * Copyright (C) 2020-2026 Philip Helger (www.helger.com)
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
package com.helger.phive.fatturapa;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.fatturapa.CFatturaPA;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesBuilder;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Generic fatturaPA validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class FatturaPAValidation
{
  public static final String GROUP_ID = "it.fatturapa";

  public static final DVRCoordinate VID_FATTURAPA_120 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                           "invoice",
                                                                                           "1.2.0");
  public static final DVRCoordinate VID_FATTURAPA_121 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                           "invoice",
                                                                                           "1.2.1");
  public static final DVRCoordinate VID_FATTURAPA_122 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                           "invoice",
                                                                                           "1.2.2");

  private FatturaPAValidation ()
  {}

  /**
   * Register all standard fatturaPA validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initFatturaPA (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // No Schematrons here
    PhiveRulesBuilder.builder ()
                     .vesID (VID_FATTURAPA_120)
                     .displayNamePrefix ("fatturaPA ")
                     .deprecated ()
                     .addXSD (CFatturaPA.getAllXSDFatturaPA120 ())
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_FATTURAPA_121)
                     .displayNamePrefix ("fatturaPA ")
                     .deprecated ()
                     .addXSD (CFatturaPA.getAllXSDFatturaPA121 ())
                     .registerInto (aRegistry);
    PhiveRulesBuilder.builder ()
                     .vesID (VID_FATTURAPA_122)
                     .displayNamePrefix ("fatturaPA ")
                     .notDeprecated ()
                     .addXSD (CFatturaPA.getAllXSDFatturaPA122 ())
                     .registerInto (aRegistry);
  }
}
