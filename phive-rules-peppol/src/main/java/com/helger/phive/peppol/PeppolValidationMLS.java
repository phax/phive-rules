/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;

/**
 * Peppol MLS validation configuration
 *
 * @author Philip Helger
 * @since 3.2.13
 */
@Immutable
public final class PeppolValidationMLS
{
  public static final String GROUP_ID = "org.peppol";

  public static final DVRCoordinate VID_OPENPEPPOL_MLS_V100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "mls",
                                                                                                 "1.0.0");

  private PeppolValidationMLS ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationMLS.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = !bDeprecated;

    final String BASE_PATH_SCH = "external/schematron/mls/";

    // v1.0.0
    {
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_MLS_V100,
                                                                             "Peppol Message Level Status v1.0.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllApplicationResponseXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                          "1.0.0/xslt/peppol-mls-1.0.0.xslt",
                                                                                                                                          _getCL ()))));
    }
  }
}
