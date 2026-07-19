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
package com.helger.phive.rules.api;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.style.IsSPIInterface;
import com.helger.base.state.ESuccess;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * SPI interface to register the validation execution sets of a single phive rules module into a
 * provided registry. All implementations of this interface are discovered via the JDK
 * {@link java.util.ServiceLoader} mechanism and invoked by
 * {@link ValidationRulesRegistrar#registerAllValidationRules(IValidationExecutorSetRegistry)}.
 * <p>
 * Because the SPI load order is not deterministic, an implementation that requires validation
 * execution sets of another module to be present first (e.g. because it is based on the EN 16931
 * rules) must not fail hard. Instead it must check whether its prerequisites are already registered
 * and return {@link ESuccess#FAILURE} if they are not yet available. The registrar will then retry
 * that implementation in a later round, after other implementations had the chance to register
 * their prerequisites. An implementation returning {@link ESuccess#FAILURE} must not have
 * registered any of its own validation execution sets yet, so that a later retry cannot cause
 * duplicate registrations.
 *
 * @author Philip Helger
 * @since 4.4.0
 */
@IsSPIInterface
public interface IValidationRulesRegistrarSPI
{
  /**
   * Register all validation execution sets of this module into the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts to. May not be <code>null</code>.
   * @return {@link ESuccess#SUCCESS} if all validation execution sets were registered.
   *         {@link ESuccess#FAILURE} if a prerequisite of this module is not yet registered and
   *         this module should be retried in a later round. In case of {@link ESuccess#FAILURE} no
   *         validation execution set of this module may have been registered.
   */
  @NonNull
  ESuccess registerValidationRules (@NonNull IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry);
}
