/*
 * Copyright (C) 2021-2025 Philip Helger (www.helger.com)
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
package com.helger.phive.ksef;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xsds.xmldsig.CXMLDSig;

import jakarta.annotation.Nonnull;

/**
 * Generic KSeF validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class KSeFValidation
{
  public static final String GROUP_ID = "pl.ksef";

  @Deprecated
  public static final DVRCoordinate KSEF_1 = PhiveRulesHelper.createCoordinate (GROUP_ID, "ksef", "1.0.0");

  public static final DVRCoordinate KSEF_2 = PhiveRulesHelper.createCoordinate (GROUP_ID, "ksef", "2.0.0");

  private KSeFValidation ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return KSeFValidation.class.getClassLoader ();
  }


  private static final MapBasedNamespaceContext NS_CTX = new MapBasedNamespaceContext ();
  static
  {
    NS_CTX.setDefaultNamespaceURI ("https://crd.gov.pl/wzor/2023/06/29/12648/");
    NS_CTX.addMapping (CXMLDSig.DEFAULT_PREFIX, CXMLDSig.NAMESPACE_URI);
  }

  @Nonnull
  private static ValidationExecutorSchematron _createXSLT (@Nonnull final IReadableResource aRes)
  {
    return PhiveRulesHelper.createXSLT (aRes, NS_CTX.getClone ());
  }

  /**
   * Register all standard KSeF validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initKSeF (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (
                               KSEF_1,
                               "KSeF " + KSEF_1.getVersionString (),
                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                               ValidationExecutorXSD.create (CXMLDSig.getXSDResource (), new ClassPathResource ("/external/schemas/1.0.0/schema.xsd", _getCL ()))
    ));

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (
                               KSEF_2,
                               "KSeF " + KSEF_2.getVersionString (),
                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                               ValidationExecutorXSD.create (CXMLDSig.getXSDResource (), new ClassPathResource ("/external/schemas/2.0.0/schema.xsd", _getCL ()))
    ));
  }
}
