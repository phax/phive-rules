/*
 * Copyright (C) 2018-2026 Philip Helger (www.helger.com)
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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.ebinterface.CEbInterface;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesBuilder;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.source.IValidationSourceXML;

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
   * Register all standard ebInterface validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initEbInterface (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // No Schematrons here
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EBI_30)
                     .displayName ("ebInterface 3.0")
                     .deprecated ()
                     .addXSD (CEbInterface.EBINTERFACE_30_XSDS)
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EBI_302)
                     .displayName ("ebInterface 3.0.2")
                     .deprecated ()
                     .addXSD (CEbInterface.EBINTERFACE_302_XSDS)
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EBI_40)
                     .displayName ("ebInterface 4.0")
                     .deprecated ()
                     .addXSD (CEbInterface.EBINTERFACE_40_XSDS)
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EBI_41)
                     .displayName ("ebInterface 4.1")
                     .deprecated ()
                     .addXSD (CEbInterface.EBINTERFACE_41_XSDS)
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EBI_42)
                     .displayName ("ebInterface 4.2")
                     .deprecated ()
                     .addXSD (CEbInterface.EBINTERFACE_42_XSDS)
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EBI_43)
                     .displayName ("ebInterface 4.3")
                     .notDeprecated ()
                     .addXSD (CEbInterface.EBINTERFACE_43_XSDS)
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EBI_50)
                     .displayName ("ebInterface 5.0")
                     .notDeprecated ()
                     .addXSD (CEbInterface.EBINTERFACE_50_XSDS)
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EBI_60)
                     .displayName ("ebInterface 6.0")
                     .notDeprecated ()
                     .addXSD (CEbInterface.EBINTERFACE_60_XSDS)
                     .registerInto ();
    PhiveRulesBuilder.forRegistry (aRegistry)
                     .vesID (VID_EBI_61)
                     .displayName ("ebInterface 6.1")
                     .notDeprecated ()
                     .addXSD (CEbInterface.EBINTERFACE_61_XSDS)
                     .registerInto ();
  }
}
