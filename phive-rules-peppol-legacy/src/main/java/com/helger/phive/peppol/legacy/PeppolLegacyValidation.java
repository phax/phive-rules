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
package com.helger.phive.peppol.legacy;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;
import javax.xml.XMLConstants;

import com.helger.commons.annotation.ReturnsMutableObject;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.engine.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Generic Legacy Peppol validation configuration. It contains only the old
 * validation rules.
 *
 * @author Philip Helger
 */
@Immutable
@SuppressWarnings ("deprecation")
public final class PeppolLegacyValidation
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolLegacyValidation.class.getClassLoader ();
  }

  private PeppolLegacyValidation ()
  {}

  /**
   * Register all legacy Peppol validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL21NamespaceContext.getInstance ());

    PeppolValidation350.init (aRegistry);
    PeppolValidation360.init (aRegistry);
    PeppolValidation370.init (aRegistry);
    PeppolValidation380.init (aRegistry);
    PeppolValidation381.init (aRegistry);
    PeppolValidation390.init (aRegistry);
    PeppolValidation391.init (aRegistry);
    PeppolValidation3_10_0.init (aRegistry);
    PeppolValidation3_10_1.init (aRegistry);
    PeppolValidation3_11_0.init (aRegistry);
    PeppolValidation3_11_1.init (aRegistry);
    PeppolValidation3_12_0.init (aRegistry);
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
