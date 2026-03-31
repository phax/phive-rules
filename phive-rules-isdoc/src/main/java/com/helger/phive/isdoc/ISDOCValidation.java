/*
 * Copyright (C) 2021-2026 Philip Helger (www.helger.com)
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
package com.helger.phive.isdoc;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesBuilder;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xsds.xmldsig.CXMLDSig;

/**
 * Generic ISDOC validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class ISDOCValidation
{
  public static final String GROUP_ID = "cz.isdoc";

  @Deprecated
  public static final DVRCoordinate VID_ISDOC_601 = PhiveRulesHelper.createCoordinate (GROUP_ID, "isdoc", "6.0.1");
  public static final DVRCoordinate VID_ISDOC_602 = PhiveRulesHelper.createCoordinate (GROUP_ID, "isdoc", "6.0.2");

  private ISDOCValidation ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return ISDOCValidation.class.getClassLoader ();
  }

  private static final MapBasedNamespaceContext NS_CTX = new MapBasedNamespaceContext ();
  static
  {
    NS_CTX.setDefaultNamespaceURI ("http://isdoc.cz/namespace/2013");
    NS_CTX.addMapping (CXMLDSig.DEFAULT_PREFIX, CXMLDSig.NAMESPACE_URI);
  }

  @NonNull
  private static ValidationExecutorSchematron _createXSLT (@NonNull final IReadableResource aRes)
  {
    return PhiveRulesHelper.createXSLT (aRes, NS_CTX.getClone ());
  }

  /**
   * Register all standard ISDOC validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initISDOC (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_ISDOC_601)
                     .displayNamePrefix ("ISDOC ")
                     .deprecated ()
                     .addXSD (CXMLDSig.getXSDResource (),
                              new ClassPathResource ("/external/schemas/isdoc/6.0.1/isdoc-invoice-dsig-6.0.1.xsd",
                                                     _getCL ()))
                     .addSchematron (_createXSLT (new ClassPathResource ("/external/schematron/isdoc/6.0.1/isdoc-6.0.1.xslt",
                                                                         _getCL ())))
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_ISDOC_602)
                     .displayNamePrefix ("ISDOC ")
                     .notDeprecated ()
                     .addXSD (CXMLDSig.getXSDResource (),
                              new ClassPathResource ("/external/schemas/isdoc/6.0.2/isdoc-invoice-dsig-6.0.2.xsd",
                                                     _getCL ()))
                     .addSchematron (_createXSLT (new ClassPathResource ("/external/schematron/isdoc/6.0.2/isdoc-6.0.2.xslt",
                                                                         _getCL ())))
                     .registerInto ();
  }
}
