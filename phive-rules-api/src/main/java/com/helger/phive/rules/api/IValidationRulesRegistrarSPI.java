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

import com.helger.annotation.style.IsSPIInterface;

/**
 * SPI interface to register the validation execution sets of a single phive rules module into a
 * provided registry.
 *
 * @author Philip Helger
 * @since 4.4.0
 * @deprecated Since 4.5.0 - moved to the <code>phive-rules-foundation-api</code> artifact. Use
 *             {@link com.helger.phive.rules.shared.IValidationRulesRegistrarSPI} instead.
 */
@Deprecated (forRemoval = true, since = "4.5.0")
@IsSPIInterface
public interface IValidationRulesRegistrarSPI extends com.helger.phive.rules.shared.IValidationRulesRegistrarSPI
{
  /* All members are inherited from the foundation SPI interface. */
}
