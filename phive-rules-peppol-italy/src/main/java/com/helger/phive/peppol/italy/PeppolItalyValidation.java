/*
 * Copyright (C) 2014-2022 Philip Helger (www.helger.com)
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
package com.helger.phive.peppol.italy;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.engine.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.ubl21.UBL21NamespaceContext;

/**
 * Generic Peppol Italy validation configuration. It contains only the old
 * validation rules.
 *
 * @author Philip Helger
 */
@Immutable
public final class PeppolItalyValidation
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolItalyValidation.class.getClassLoader ();
  }

  private PeppolItalyValidation ()
  {}

  /**
   * Register all Peppol Italy validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  @SuppressWarnings ("deprecation")
  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL21NamespaceContext.getInstance ());

    PeppolItalyValidation2_2_9.init (aRegistry);
    PeppolItalyValidation2_3_0.init (aRegistry);
  }
}
