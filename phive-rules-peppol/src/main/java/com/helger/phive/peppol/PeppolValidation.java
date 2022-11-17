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
package com.helger.phive.peppol;

import java.time.LocalDate;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;
import javax.xml.XMLConstants;

import com.helger.commons.annotation.Nonempty;
import com.helger.commons.annotation.ReturnsMutableObject;
import com.helger.commons.datetime.PDTFactory;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.engine.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Generic Peppol validation configuration
 *
 * @author Philip Helger
 */
@Immutable
@SuppressWarnings ("deprecation")
public final class PeppolValidation
{
  /**
   * @return The currently active version number, dependent on the current date.
   *         Never <code>null</code>.
   * @since 5.1.8
   */
  @Nonnull
  @Nonempty
  public static String getVersionToUse ()
  {
    final LocalDate aNow = PDTFactory.getCurrentLocalDate ();
    if (aNow.isBefore (PeppolValidation3_14_0.VALID_PER))
    {
      // Previous version
      return PeppolValidation3_14_0.VERSION_STR;
    }
    // Latest version
    return PeppolValidation3_14_0.VERSION_STR;
  }

  private PeppolValidation ()
  {}

  /**
   * Register all standard Peppol validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initStandard (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL21NamespaceContext.getInstance ());

    PeppolValidation3_13_0.init (aRegistry);
    PeppolValidation3_14_0.init (aRegistry);
    PeppolValidationAUNZ.init (aRegistry);
    PeppolValidationSG.init (aRegistry);
    PeppolValidationDirectory.init (aRegistry);
    PeppolValidationReporting.init (aRegistry);
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
