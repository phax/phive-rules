/*
 * Copyright (C) 2020-2024 Philip Helger (www.helger.com)
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
package com.helger.phive.zugferd;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.ICommonsMap;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.diver.api.version.DVRVersion;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.api.executorset.ValidationExecutorSetAlias;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;

/**
 * Generic Facturae validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class ZugferdValidation
{
  public static final String GROUP_ID_ZUGFERD = "de.zugferd";
  public static final String GROUP_ID_FACTUR_X = "fr.facturx";

  public static final DVRCoordinate VID_ZUGFERD_2_3_2_MINIMUM = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                   "minimum",
                                                                                                   "2.3.2");

  // Global version map
  private static final ICommonsMap <DVRVersion, DVRVersion> ZUGFERD_TO_FACTURX_MAP = new CommonsHashMap <> ();
  static
  {
    ZUGFERD_TO_FACTURX_MAP.put (DVRVersion.parseOrNull ("2.3.2"), DVRVersion.parseOrNull ("1.7.2"));
  }

  private ZugferdValidation ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return ZugferdValidation.class.getClassLoader ();
  }

  @Nullable
  public static DVRCoordinate getMappedFacturXVESID (@Nonnull final DVRCoordinate aZugferdVESID)
  {
    ValueEnforcer.notNull (aZugferdVESID, "ZugferdVESID");
    final DVRVersion aFacturXVersion = ZUGFERD_TO_FACTURX_MAP.get (aZugferdVESID.getVersionObj ());
    if (aFacturXVersion == null)
      return null;

    return new DVRCoordinate (GROUP_ID_FACTUR_X, aZugferdVESID.getArtifactID (), aFacturXVersion);
  }

  private static void _registerFacturXAlias (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry,
                                             @Nonnull final ValidationExecutorSet <IValidationSourceXML> aVES)
  {
    final DVRCoordinate aFacturXVESID = getMappedFacturXVESID (aVES.getID ());
    aRegistry.registerValidationExecutorSet (new ValidationExecutorSetAlias <> (aFacturXVESID,
                                                                                "Factur-X " +
                                                                                               aFacturXVESID.getVersionString (),
                                                                                aVES));
  }

  /**
   * Register all standard Zugferd validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initZugferd (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // Zugferd 2.3.2 / Factur-X 1.07.2
    {
      final ValidationExecutorSet <IValidationSourceXML> aVES;
      aVES = ValidationExecutorSet.create (VID_ZUGFERD_2_3_2_MINIMUM,
                                           "ZUGFeRD " + VID_ZUGFERD_2_3_2_MINIMUM.getVersionString (),
                                           PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                           ValidationExecutorXSD.create (new ClassPathResource ("/external/schemas/2.3.2/minimum/Factur-X_1.07.2_MINIMUM.xsd",
                                                                                                _getCL ())));
      aRegistry.registerValidationExecutorSet (aVES);
      _registerFacturXAlias (aRegistry, aVES);
    }
  }
}
