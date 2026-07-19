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
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.state.ESuccess;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * SPI interface to register the validation execution sets of a single phive rules module into a
 * provided registry. All implementations of this interface are discovered via the JDK
 * {@link java.util.ServiceLoader} mechanism and invoked by
 * {@link ValidationRulesRegistrar#registerAllValidationRules(IValidationExecutorSetRegistry)}.
 * <p>
 * Because the SPI load order is not deterministic, an implementation that is based on the
 * validation execution sets of another module (e.g. the EN 16931 rules) must declare those as
 * prerequisites via {@link #getAllPrerequisites()}. The registrar only invokes
 * {@link #registerValidationRules(IValidationExecutorSetRegistry)} once all declared prerequisites
 * are present in the registry; otherwise it retries the implementation in a later round, after
 * other implementations had the chance to register those prerequisites.
 *
 * @author Philip Helger
 * @since 4.4.0
 */
@IsSPIInterface
public interface IValidationRulesRegistrarSPI
{
  /**
   * @return The list of validation execution set coordinates that must already be registered before
   *         {@link #registerValidationRules(IValidationExecutorSetRegistry)} of this implementation
   *         may be called. By default an empty list is returned, meaning this module has no
   *         prerequisites. Implementations with prerequisites should return the very same
   *         coordinates that their static <code>init…</code> methods require, so that both share
   *         the same data basis.
   */
  @NonNull
  @ReturnsMutableCopy
  default ICommonsList <DVRCoordinate> getAllPrerequisites ()
  {
    return new CommonsArrayList <> ();
  }

  /**
   * Register all validation execution sets of this module into the provided registry. This is only
   * called by the registrar once all coordinates from {@link #getAllPrerequisites()} are present in
   * the registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts to. May not be <code>null</code>.
   * @return {@link ESuccess#SUCCESS} if all validation execution sets were registered.
   *         {@link ESuccess#FAILURE} if this module should be retried in a later round. In case of
   *         {@link ESuccess#FAILURE} no validation execution set of this module may have been
   *         registered.
   */
  @NonNull
  ESuccess registerValidationRules (@NonNull IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry);
}
