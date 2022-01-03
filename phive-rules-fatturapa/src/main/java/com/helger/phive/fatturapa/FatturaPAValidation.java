/*
 * Copyright (C) 2020-2022 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.fatturapa.builder.EFatturaPADocumentType;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.engine.xsd.ValidationExecutorXSD;

/**
 * Generic fatturaPA validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class FatturaPAValidation
{
  public static final String GROUP_ID = "it.fatturapa";

  public static final VESID VID_FATTURAPA_120 = new VESID (GROUP_ID, "invoice", "1.2.0");
  public static final VESID VID_FATTURAPA_121 = new VESID (GROUP_ID, "invoice", "1.2.1");

  private FatturaPAValidation ()
  {}

  /**
   * Register all standard fatturaPA validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initFatturaPA (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bNotDeprecated = false;

    // No Schematrons here
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FATTURAPA_120,
                                                                           "fatturaPA " + VID_FATTURAPA_120.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EFatturaPADocumentType.FATTURAPA_120)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FATTURAPA_121,
                                                                           "fatturaPA " + VID_FATTURAPA_121.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EFatturaPADocumentType.FATTURAPA_121)));
  }
}
