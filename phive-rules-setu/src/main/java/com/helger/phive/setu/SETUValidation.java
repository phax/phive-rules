/*
 * Copyright (C) 2021-2023 Philip Helger (www.helger.com)
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
package com.helger.phive.setu;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.engine.schematron.ValidationExecutorSchematron;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.engine.xsd.ValidationExecutorXSD;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xsds.xml.CXML_XSD;

/**
 * Generic ISDOC validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class SETUValidation
{
  public static final String GROUP_ID = "nl.setu";

  public static final VESID VID_TIMECARD_14 = new VESID (GROUP_ID, "timecard", "1.4");

  private SETUValidation ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return SETUValidation.class.getClassLoader ();
  }

  private static final MapBasedNamespaceContext NS_CTX = new MapBasedNamespaceContext ();
  static
  {
    NS_CTX.setDefaultNamespaceURI ("http://ns.hr-xml.org/2007-04-15");
  }

  @Nonnull
  private static ValidationExecutorSchematron _createXSLT (@Nonnull final IReadableResource aRes)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, NS_CTX.getClone ());
  }

  /**
   * Register all standard SETU validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initISDOC (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bNotDeprecated = false;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_TIMECARD_14,
                                                                           "SETU Timcard " +
                                                                                            VID_TIMECARD_14.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (CXML_XSD.getXSDResource (),
                                                                                                         new ClassPathResource ("/external/schemas/hr-xml-2007/SIDES/TimeCardAdditionalData.xsd",
                                                                                                                                _getCL ()),
                                                                                                         new ClassPathResource ("/external/schemas/hr-xml-2007/TimeCard/Timecard.xsd",
                                                                                                                                _getCL ())),
                                                                           _createXSLT (new ClassPathResource ("/external/schematron/timecard/1.4/xslt/RTE-v1.4-TimeCard.xslt"))));
  }
}
