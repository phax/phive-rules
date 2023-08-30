/*
 * Copyright (C) 2018-2023 Philip Helger (www.helger.com)
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
package com.helger.phive.cii;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.cii.d16b.CCIID16B;
import com.helger.cii.d16b.CIID16BNamespaceContext;
import com.helger.commons.ValueEnforcer;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.xml.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;

/**
 * Generic CII validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class CIIValidation
{
  public static final String GROUP_ID = "un.unece.uncefact";
  public static final String VERSION_D16B = "D16B";

  public static final VESID VID_CII_D16B_CROSSINDUSTRYINVOICE = new VESID (GROUP_ID,
                                                                           "crossindustryinvoice",
                                                                           VERSION_D16B);

  private CIIValidation ()
  {}

  /**
   * Register all standard CII D16B validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initCIID16B (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // For better error messages
    SchematronNamespaceBeautifier.addMappings (CIID16BNamespaceContext.getInstance ());

    final boolean bNotDeprecated = false;

    // No Schematrons here
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_CII_D16B_CROSSINDUSTRYINVOICE,
                                                                           "CII CrossIndustryInvoice " + VERSION_D16B,
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (CCIID16B.getXSDResource ())));
  }
}
