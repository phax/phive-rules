/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Peppol Directory Business Card validation configuration
 *
 * @author Philip Helger
 * @since 2.1.10
 */
@Immutable
public final class PeppolValidationDirectory
{
  public static final String GROUP_ID = "eu.peppol.directory";

  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BUSINESS_CARD_V1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "businesscard",
                                                                                                         "1.0.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_BUSINESS_CARD_V2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "businesscard",
                                                                                                         "2.0.0");
  public static final DVRCoordinate VID_OPENPEPPOL_BUSINESS_CARD_V3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                         "businesscard",
                                                                                                         "3.0.0");

  private PeppolValidationDirectory ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationDirectory.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String BASE_PATH = "external/schemas/";

    // v1
    {
      final IReadableResource DIRECTORY_V1 = new ClassPathResource (BASE_PATH +
                                                                    "peppol-directory-business-card-20160112.xsd",
                                                                    _getCL ());
      VesXmlBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BUSINESS_CARD_V1)
                       .displayName ("Peppol Directory BusinessCard v1")
                       .deprecated ()
                       .addXSD (DIRECTORY_V1)
                       .registerInto (aRegistry);
    }

    // v2
    {
      final IReadableResource DIRECTORY_V2 = new ClassPathResource (BASE_PATH +
                                                                    "peppol-directory-business-card-20161123.xsd",
                                                                    _getCL ());
      VesXmlBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BUSINESS_CARD_V2)
                       .displayName ("Peppol Directory BusinessCard v2")
                       .deprecated ()
                       .addXSD (DIRECTORY_V2)
                       .registerInto (aRegistry);
    }

    // v3
    {
      final IReadableResource DIRECTORY_V3 = new ClassPathResource (BASE_PATH +
                                                                    "peppol-directory-business-card-20180621.xsd",
                                                                    _getCL ());
      VesXmlBuilder.builder ()
                       .vesID (VID_OPENPEPPOL_BUSINESS_CARD_V3)
                       .displayName ("Peppol Directory BusinessCard v3")
                       .notDeprecated ()
                       .addXSD (DIRECTORY_V3)
                       .registerInto (aRegistry);
    }
  }
}
