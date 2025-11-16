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
package com.helger.phive.peppol.legacy;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Generic Legacy Peppol validation configuration. It contains only the old
 * validation rules.
 *
 * @author Philip Helger
 */
@Immutable
@SuppressWarnings ("deprecation")
public final class PeppolLegacyValidationBisEurope
{
  private PeppolLegacyValidationBisEurope ()
  {}

  /**
   * Register all legacy Peppol validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    PeppolValidation3_10_0.init (aRegistry);
    PeppolValidation3_10_1.init (aRegistry);
    PeppolValidation3_11_0.init (aRegistry);
    PeppolValidation3_11_1.init (aRegistry);
    PeppolValidation3_12_0.init (aRegistry);
    PeppolValidation3_13_0.init (aRegistry);
    PeppolValidation3_14_0.init (aRegistry);
    PeppolValidation3_15_0.init (aRegistry);
    PeppolValidation2023_05.init (aRegistry);
    PeppolValidation2023_11.init (aRegistry);
  }
}
