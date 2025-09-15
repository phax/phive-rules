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
package com.helger.phive.setu;

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
import com.helger.xsds.xml.CXML_XSD;

import jakarta.annotation.Nonnull;

/**
 * Generic ISDOC validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class SETUValidation
{
  public static final String GROUP_ID = "nl.setu";

  // V1.4
  public static final DVRCoordinate VID_SETU_ASSIGNMENT_14 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                "assignment",
                                                                                                "1.4");
  public static final DVRCoordinate VID_SETU_TIMECARD_14 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                              "timecard",
                                                                                              "1.4");

  /**
   * @deprecated Use {@link #VID_SETU_TIMECARD_14} instead
   */
  @Deprecated (forRemoval = true, since = "4.0.1")
  public static final DVRCoordinate VID_TIMECARD_14 = VID_SETU_TIMECARD_14;

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
    return PhiveRulesHelper.createXSLT (aRes, NS_CTX.getClone ());
  }

  /**
   * Register all standard SETU validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initSETU (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bNotDeprecated = false;

    // V1.4
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SETU_ASSIGNMENT_14,
                                                                           "SETU Assignment " +
                                                                                                   VID_SETU_ASSIGNMENT_14.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (CXML_XSD.getXSDResource (),
                                                                                                         new ClassPathResource ("/external/schemas/setu/schemas/2020-01/AssignmentAdditionalNL.xsd",
                                                                                                                                _getCL ()),
                                                                                                         new ClassPathResource ("/external/schemas/hr-xml/SIDES/Assignment.xsd",
                                                                                                                                _getCL ())),
                                                                           _createXSLT (new ClassPathResource ("/external/schematron/setu/1.4/xslt/Assignment-v1.4-Assignment.xslt",
                                                                                                               _getCL ()))));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SETU_TIMECARD_14,
                                                                           "SETU Timcard " +
                                                                                                 VID_SETU_TIMECARD_14.getVersionString (),
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (CXML_XSD.getXSDResource (),
                                                                                                         new ClassPathResource ("/external/schemas/hr-xml/SIDES/TimeCardAdditionalData.xsd",
                                                                                                                                _getCL ()),
                                                                                                         new ClassPathResource ("/external/schemas/hr-xml/TimeCard/TimeCard.xsd",
                                                                                                                                _getCL ())),
                                                                           _createXSLT (new ClassPathResource ("/external/schematron/setu/1.4/xslt/RTE-v1.4-TimeCard.xslt",
                                                                                                               _getCL ()))));
  }
}
