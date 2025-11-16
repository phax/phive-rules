/*
 * Copyright (C) 2018-2025 Philip Helger (www.helger.com)
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
package com.helger.phive.ehf;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * EHF validation G2 and G3.
 *
 * @author Philip Helger
 */
@Immutable
public final class EHFValidation
{
  private EHFValidation ()
  {}

  /**
   * Register G2 and G3 artefacts.
   *
   * @param aRegistry
   *        The registry to register to. May not be <code>null</code>.
   */
  @SuppressWarnings ("deprecation")
  public static void initEHF (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    EHFValidationG2.initEHF (aRegistry);
    EHFValidationG3_2020_03.initEHF (aRegistry);
    EHFValidationG3_2023_02.initEHF (aRegistry);
  }
}
