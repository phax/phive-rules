/*
 * Copyright (C) 2018-2024 Philip Helger (www.helger.com)
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
package com.helger.phive.ebinterface;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.ebinterface.CEbInterface;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;

/**
 * Generic ebInterface validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class EbInterfaceValidation
{
  public static final String GROUP_ID = "at.ebinterface";

  public static final DVRCoordinate VID_EBI_30 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "3.0");
  public static final DVRCoordinate VID_EBI_302 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "3.0.2");
  public static final DVRCoordinate VID_EBI_40 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "4.0");
  public static final DVRCoordinate VID_EBI_41 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "4.1");
  public static final DVRCoordinate VID_EBI_42 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "4.2");
  public static final DVRCoordinate VID_EBI_43 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "4.3");
  public static final DVRCoordinate VID_EBI_50 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "5.0");
  public static final DVRCoordinate VID_EBI_60 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "6.0");
  public static final DVRCoordinate VID_EBI_61 = PhiveRulesHelper.createCoordinate (GROUP_ID, "invoice", "6.1");

  private EbInterfaceValidation ()
  {}

  /**
   * Register all standard ebInterface validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initEbInterface (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // No Schematrons here
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EBI_30,
                                                                           "ebInterface 3.0",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CEbInterface.EBINTERFACE_30_XSDS)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EBI_302,
                                                                           "ebInterface 3.0.2",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CEbInterface.EBINTERFACE_302_XSDS)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EBI_40,
                                                                           "ebInterface 4.0",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CEbInterface.EBINTERFACE_40_XSDS)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EBI_41,
                                                                           "ebInterface 4.1",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CEbInterface.EBINTERFACE_41_XSDS)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EBI_42,
                                                                           "ebInterface 4.2",
                                                                           PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                           ValidationExecutorXSD.create (CEbInterface.EBINTERFACE_42_XSDS)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EBI_43,
                                                                           "ebInterface 4.3",
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (CEbInterface.EBINTERFACE_43_XSDS)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EBI_50,
                                                                           "ebInterface 5.0",
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (CEbInterface.EBINTERFACE_50_XSDS)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EBI_60,
                                                                           "ebInterface 6.0",
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (CEbInterface.EBINTERFACE_60_XSDS)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EBI_61,
                                                                           "ebInterface 6.1",
                                                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                           ValidationExecutorXSD.create (CEbInterface.EBINTERFACE_61_XSDS)));
  }
}
