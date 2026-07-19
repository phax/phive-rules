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
package com.helger.phive.zugferd;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.style.IsSPIImplementation;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.state.ESuccess;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.IValidationRulesRegistrarSPI;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * SPI implementation that registers the ZUGFeRD validation rules.
 *
 * @author Philip Helger
 */
@IsSPIImplementation
public final class ZugferdValidationSPI implements IValidationRulesRegistrarSPI
{
  @Override
  @NonNull
  @ReturnsMutableCopy
  public ICommonsList <DVRCoordinate> getAllPrerequisites ()
  {
    return ZugferdValidation.getAllPrerequisites ();
  }

  @NonNull
  public ESuccess registerValidationRules (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ZugferdValidation.initZugferd (aRegistry);
    return ESuccess.SUCCESS;
  }
}
