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
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Generic France validation configuration that aggregates all France validation rule sets (CTC /
 * Flux 2, Flux 1 and Flux 10).
 *
 * @author Philip Helger
 * @since 4.5.0
 */
@Immutable
public final class FranceValidation
{
  private FranceValidation ()
  {}

  /**
   * @return A list of all prerequisite validation execution set coordinates that must already be
   *         registered before {@link #initFrance(IValidationExecutorSetRegistry)} is called. Shares
   *         the same data basis as the initialization method. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <DVRCoordinate> getAllPrerequisites ()
  {
    // Only the CTC rules have cross-module prerequisites (EN 16931); Flux 1 and Flux 10 are
    // standalone.
    return FranceCTCValidation.getAllPrerequisites ();
  }

  /**
   * Register all France validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initFrance (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    FranceCTCValidation.initFranceCTC (aRegistry);
    FranceFlux1Validation.initFranceFlux1 (aRegistry);
    FranceFlux10Validation.initFranceFlux10 (aRegistry);
  }
}
