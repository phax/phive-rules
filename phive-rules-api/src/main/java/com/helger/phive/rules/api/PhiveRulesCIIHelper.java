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
import com.helger.io.resource.IReadableResource;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;

/**
 * Utility class around CII for phive-rules libs.
 *
 * @author Philip Helger
 * @deprecated Since 4.5.0 - moved to the <code>phive-rules-shared</code> artifact. Use
 *             {@link com.helger.phive.rules.shared.PhiveRulesCIIHelper} instead.
 */
@Deprecated (forRemoval = true, since = "4.5.0")
@Immutable
public final class PhiveRulesCIIHelper
{
  private PhiveRulesCIIHelper ()
  {}

  @Deprecated (forRemoval = true, since = "4.5.0")
  @NonNull
  public static ValidationExecutorSchematron createXSLT_CII_D16B (@NonNull final IReadableResource aRes)
  {
    return com.helger.phive.rules.shared.PhiveRulesCIIHelper.createXSLT_CII_D16B (aRes);
  }

  @Deprecated (forRemoval = true, since = "4.5.0")
  @NonNull
  public static ValidationExecutorSchematron createXSLT_CII_D22B (@NonNull final IReadableResource aRes)
  {
    return com.helger.phive.rules.shared.PhiveRulesCIIHelper.createXSLT_CII_D22B (aRes);
  }
}
