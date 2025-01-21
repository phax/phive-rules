/*
 * Copyright (C) 2024-2025 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.cii.d16b.CIID16BNamespaceContext;
import com.helger.cii.d22b.CIID22BNamespaceContext;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;

/**
 * Utility class around CII for phive-rules libs.
 *
 * @author Philip Helger
 */
@Immutable
public final class PhiveRulesCIIHelper
{
  private PhiveRulesCIIHelper ()
  {}

  @Nonnull
  public static ValidationExecutorSchematron createXSLT_CII_D16B (@Nonnull final IReadableResource aRes)
  {
    return PhiveRulesHelper.createXSLT (aRes, CIID16BNamespaceContext.getInstance ());
  }

  @Nonnull
  public static ValidationExecutorSchematron createXSLT_CII_D22B (@Nonnull final IReadableResource aRes)
  {
    return PhiveRulesHelper.createXSLT (aRes, CIID22BNamespaceContext.getInstance ());
  }
}
