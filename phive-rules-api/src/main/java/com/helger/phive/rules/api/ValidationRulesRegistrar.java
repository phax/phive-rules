/*
 * Copyright (C) 2024-2026 Philip Helger (www.helger.com)
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
package com.helger.phive.rules.api;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Discovers all validation rules registrar SPI implementations on the classpath and registers their
 * validation execution sets into a provided registry.
 *
 * @author Philip Helger
 * @deprecated Since 4.5.0 - moved to the <code>phive-rules-foundation-api</code> artifact. Use
 *             {@link com.helger.phive.rules.foundation.ValidationRulesRegistrar} instead.
 */
@Deprecated (forRemoval = true, since = "4.5.0")
@Immutable
public final class ValidationRulesRegistrar
{
  private ValidationRulesRegistrar ()
  {}

  /**
   * Register the validation execution sets of all validation rules registrar SPI implementations
   * found on the classpath into the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts to. May not be <code>null</code>.
   * @throws IllegalStateException
   *         If the prerequisites of one or more modules cannot be resolved (circular or missing
   *         dependency).
   */
  @Deprecated (forRemoval = true, since = "4.5.0")
  public static void registerAllValidationRules (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    com.helger.phive.rules.foundation.ValidationRulesRegistrar.registerAllValidationRules (aRegistry);
  }
}
