/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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
import javax.xml.XMLConstants;

import com.helger.commons.annotation.ReturnsMutableObject;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.xml.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.xml.namespace.MapBasedNamespaceContext;

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
    PeppolItalyValidation3_0_2.init (aRegistry);
    PeppolItalyValidation3_1_0.init (aRegistry);
  }

  @Nonnull
  @ReturnsMutableObject
  static MapBasedNamespaceContext createUBLNSContext (@Nonnull final String sNamespaceURI)
  {
    final MapBasedNamespaceContext aNSContext = UBL21NamespaceContext.getInstance ().getClone ();

    // Add the default mapping for the root namespace
    aNSContext.addMapping (XMLConstants.DEFAULT_NS_PREFIX, sNamespaceURI);
    // For historical reasons, the "ubl" prefix is also mapped to this
    // namespace URI
    aNSContext.addMapping ("ubl", sNamespaceURI);

    return aNSContext;
  }
}
