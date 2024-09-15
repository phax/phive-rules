/*
 * Copyright (C) 2014-2024 Philip Helger (www.helger.com)
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

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;

/**
 * Peppol Directory Business Card validation configuration
 *
 * @author Philip Helger
 * @since 2.1.10
 */
@Immutable
public final class PeppolValidationDirectory
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationDirectory.class.getClassLoader ();
  }

  private static final String BASE_PATH = "external/schemas/";

  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_BUSINESS_CARD_V1 = PhiveRulesHelper.createCoordinate ("eu.peppol.directory",
                                                                                                         "businesscard",
                                                                                                         "1.0.0");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_BUSINESS_CARD_V2 = PhiveRulesHelper.createCoordinate ("eu.peppol.directory",
                                                                                                         "businesscard",
                                                                                                         "2.0.0");
  public static final DVRCoordinate VID_OPENPEPPOL_BUSINESS_CARD_V3 = PhiveRulesHelper.createCoordinate ("eu.peppol.directory",
                                                                                                         "businesscard",
                                                                                                         "3.0.0");

  private PeppolValidationDirectory ()
  {}

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // v1
    {
      final IReadableResource DIRECTORY_V1 = new ClassPathResource (BASE_PATH +
                                                                    "peppol-directory-business-card-20160112.xsd",
                                                                    _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BUSINESS_CARD_V1,
                                                                             "Peppol Directory BusinessCard v1",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (DIRECTORY_V1)));
    }

    // v2
    {
      final IReadableResource DIRECTORY_V2 = new ClassPathResource (BASE_PATH +
                                                                    "peppol-directory-business-card-20161123.xsd",
                                                                    _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BUSINESS_CARD_V2,
                                                                             "Peppol Directory BusinessCard v2",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (DIRECTORY_V2)));
    }

    // v3
    {
      final IReadableResource DIRECTORY_V3 = new ClassPathResource (BASE_PATH +
                                                                    "peppol-directory-business-card-20180621.xsd",
                                                                    _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_BUSINESS_CARD_V3,
                                                                             "Peppol Directory BusinessCard v3",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (DIRECTORY_V3)));
    }
  }
}
