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
import com.helger.annotation.style.ReturnsMutableObject;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Utility class around UBL for phive-rules libs.
 *
 * @author Philip Helger
 * @deprecated Since 4.5.0 - moved to the <code>phive-rules-shared</code> artifact. Use
 *             {@link com.helger.phive.rules.shared.PhiveRulesUBLHelper} instead.
 */
@Deprecated (forRemoval = true, since = "4.5.0")
@Immutable
public final class PhiveRulesUBLHelper
{
  private PhiveRulesUBLHelper ()
  {}

  @Deprecated (forRemoval = true, since = "4.5.0")
  @NonNull
  @ReturnsMutableObject
  public static MapBasedNamespaceContext createUBL21NSContext (@NonNull final String sNamespaceURI)
  {
    return com.helger.phive.rules.shared.PhiveRulesUBLHelper.createUBL21NSContext (sNamespaceURI);
  }

  @Deprecated (forRemoval = true, since = "4.5.0")
  @NonNull
  public static ValidationExecutorSchematron createXSLT_UBL20 (@NonNull final IReadableResource aRes)
  {
    return com.helger.phive.rules.shared.PhiveRulesUBLHelper.createXSLT_UBL20 (aRes);
  }

  @Deprecated (forRemoval = true, since = "4.5.0")
  @NonNull
  public static ValidationExecutorSchematron createXSLT_UBL21 (@NonNull final IReadableResource aRes)
  {
    return com.helger.phive.rules.shared.PhiveRulesUBLHelper.createXSLT_UBL21 (aRes);
  }

  @Deprecated (forRemoval = true, since = "4.5.0")
  @NonNull
  public static ValidationExecutorSchematron createXSLT_UBL22 (@NonNull final IReadableResource aRes)
  {
    return com.helger.phive.rules.shared.PhiveRulesUBLHelper.createXSLT_UBL22 (aRes);
  }

  @Deprecated (forRemoval = true, since = "4.5.0")
  @NonNull
  public static ValidationExecutorSchematron createXSLT_UBL23 (@NonNull final IReadableResource aRes)
  {
    return com.helger.phive.rules.shared.PhiveRulesUBLHelper.createXSLT_UBL23 (aRes);
  }
}
