/*
 * Copyright (C) 2020-2022 Philip Helger (www.helger.com)
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
package com.helger.phive.facturae;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.engine.xsd.ValidationExecutorXSD;
import com.helger.xsds.xmldsig.CXMLDSig;

/**
 * Generic Facturae validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class FacturaeValidation
{
  public static final String GROUP_ID = "es.gob";

  public static final VESID VID_FACTURAE_300 = new VESID (GROUP_ID, "facturae", "3.0");
  public static final VESID VID_FACTURAE_310 = new VESID (GROUP_ID, "facturae", "3.1");
  public static final VESID VID_FACTURAE_320 = new VESID (GROUP_ID, "facturae", "3.2");
  public static final VESID VID_FACTURAE_321 = new VESID (GROUP_ID, "facturae", "3.2.1");
  public static final VESID VID_FACTURAE_322 = new VESID (GROUP_ID, "facturae", "3.2.2");

  private FacturaeValidation ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return FacturaeValidation.class.getClassLoader ();
  }

  /**
   * Register all standard Facturae validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initFacturae (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // No Schematrons here
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FACTURAE_300,
                                                                           "Facturae " + VID_FACTURAE_300.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (CXMLDSig.getXSDResource (),
                                                                                                         new ClassPathResource ("/schemas/Facturae30.xsd",
                                                                                                                                _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FACTURAE_310,
                                                                           "Facturae " + VID_FACTURAE_310.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (CXMLDSig.getXSDResource (),
                                                                                                         new ClassPathResource ("/schemas/Facturaev31.xsd",
                                                                                                                                _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FACTURAE_320,
                                                                           "Facturae " + VID_FACTURAE_320.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (CXMLDSig.getXSDResource (),
                                                                                                         new ClassPathResource ("/schemas/Facturaev3_2.xsd",
                                                                                                                                _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FACTURAE_321,
                                                                           "Facturae " + VID_FACTURAE_321.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (CXMLDSig.getXSDResource (),
                                                                                                         new ClassPathResource ("/schemas/Facturaev3_2_1.xsd",
                                                                                                                                _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_FACTURAE_322,
                                                                           "Facturae " + VID_FACTURAE_322.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (CXMLDSig.getXSDResource (),
                                                                                                         new ClassPathResource ("/schemas/Facturaev3_2_2.xsd",
                                                                                                                                _getCL ()))));
  }
}
