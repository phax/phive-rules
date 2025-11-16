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

import javax.xml.XMLConstants;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableObject;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.ubl20.UBL20NamespaceContext;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.ubl22.UBL22NamespaceContext;
import com.helger.ubl23.UBL23NamespaceContext;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Utility class around UBL for phive-rules libs.
 *
 * @author Philip Helger
 */
@Immutable
public final class PhiveRulesUBLHelper
{
  private PhiveRulesUBLHelper ()
  {}

  @NonNull
  @ReturnsMutableObject
  public static MapBasedNamespaceContext createUBL21NSContext (@NonNull final String sNamespaceURI)
  {
    final MapBasedNamespaceContext aNSContext = UBL21NamespaceContext.getInstance ().getClone ();

    // Add the default mapping for the root namespace
    aNSContext.addMapping (XMLConstants.DEFAULT_NS_PREFIX, sNamespaceURI);
    // For historical reasons, the "ubl" prefix is also mapped to this
    // namespace URI
    aNSContext.addMapping ("ubl", sNamespaceURI);

    return aNSContext;
  }

  @NonNull
  public static ValidationExecutorSchematron createXSLT_UBL20 (@NonNull final IReadableResource aRes)
  {
    return PhiveRulesHelper.createXSLT (aRes, UBL20NamespaceContext.getInstance ());
  }

  @NonNull
  public static ValidationExecutorSchematron createXSLT_UBL21 (@NonNull final IReadableResource aRes)
  {
    return PhiveRulesHelper.createXSLT (aRes, UBL21NamespaceContext.getInstance ());
  }

  @NonNull
  public static ValidationExecutorSchematron createXSLT_UBL22 (@NonNull final IReadableResource aRes)
  {
    return PhiveRulesHelper.createXSLT (aRes, UBL22NamespaceContext.getInstance ());
  }

  @NonNull
  public static ValidationExecutorSchematron createXSLT_UBL23 (@NonNull final IReadableResource aRes)
  {
    return PhiveRulesHelper.createXSLT (aRes, UBL23NamespaceContext.getInstance ());
  }
}
