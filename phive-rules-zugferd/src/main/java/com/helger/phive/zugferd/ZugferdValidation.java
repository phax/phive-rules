/*
 * Copyright (C) 2024-2026 Philip Helger (www.helger.com)
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

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.exception.InitializationException;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.ICommonsMap;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.diver.api.version.DVRVersion;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.api.executorset.ValidationExecutorSetAlias;
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.rules.api.PhiveRulesCIIHelper;
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
  public static final String GROUP_ID_FACTUR_X = "fr.factur-x";

  // v2.0.1
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_0_1_MINIMUM = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                   EZugferdProfile.MINIMUM.getArtifactID (),
                                                                                                   "2.0.1");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_0_1_BASIC_WL = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                    EZugferdProfile.BASIC_WL.getArtifactID (),
                                                                                                    "2.0.1");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_0_1_BASIC = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                 EZugferdProfile.BASIC.getArtifactID (),
                                                                                                 "2.0.1");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_0_1_EN16931 = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                   EZugferdProfile.EN16931.getArtifactID (),
                                                                                                   "2.0.1");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_0_1_EXTENDED = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                    EZugferdProfile.EXTENDED.getArtifactID (),
                                                                                                    "2.0.1");

  // v2.1
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_1_MINIMUM = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                 EZugferdProfile.MINIMUM.getArtifactID (),
                                                                                                 "2.1");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_1_BASIC_WL = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                  EZugferdProfile.BASIC_WL.getArtifactID (),
                                                                                                  "2.1");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_1_BASIC = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                               EZugferdProfile.BASIC.getArtifactID (),
                                                                                               "2.1");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_1_EN16931 = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                 EZugferdProfile.EN16931.getArtifactID (),
                                                                                                 "2.1");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_1_EXTENDED = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                  EZugferdProfile.EXTENDED.getArtifactID (),
                                                                                                  "2.1");

  // v2.2
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_2_MINIMUM = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                 EZugferdProfile.MINIMUM.getArtifactID (),
                                                                                                 "2.2");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_2_BASIC_WL = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                  EZugferdProfile.BASIC_WL.getArtifactID (),
                                                                                                  "2.2");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_2_BASIC = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                               EZugferdProfile.BASIC.getArtifactID (),
                                                                                               "2.2");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_2_EN16931 = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                 EZugferdProfile.EN16931.getArtifactID (),
                                                                                                 "2.2");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_2_EXTENDED = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                  EZugferdProfile.EXTENDED.getArtifactID (),
                                                                                                  "2.2");

  // v2.3.2
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_3_2_MINIMUM = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                   EZugferdProfile.MINIMUM.getArtifactID (),
                                                                                                   "2.3.2");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_3_2_BASIC_WL = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                    EZugferdProfile.BASIC_WL.getArtifactID (),
                                                                                                    "2.3.2");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_3_2_BASIC = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                 EZugferdProfile.BASIC.getArtifactID (),
                                                                                                 "2.3.2");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_3_2_EN16931 = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                   EZugferdProfile.EN16931.getArtifactID (),
                                                                                                   "2.3.2");
  @Deprecated
  public static final DVRCoordinate VID_ZUGFERD_2_3_2_EXTENDED = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                    EZugferdProfile.EXTENDED.getArtifactID (),
                                                                                                    "2.3.2");

  // v2.3.3
  public static final DVRCoordinate VID_ZUGFERD_2_3_3_MINIMUM = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                   EZugferdProfile.MINIMUM.getArtifactID (),
                                                                                                   "2.3.3");
  public static final DVRCoordinate VID_ZUGFERD_2_3_3_BASIC_WL = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                    EZugferdProfile.BASIC_WL.getArtifactID (),
                                                                                                    "2.3.3");
  public static final DVRCoordinate VID_ZUGFERD_2_3_3_BASIC = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                 EZugferdProfile.BASIC.getArtifactID (),
                                                                                                 "2.3.3");
  public static final DVRCoordinate VID_ZUGFERD_2_3_3_EN16931 = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                   EZugferdProfile.EN16931.getArtifactID (),
                                                                                                   "2.3.3");
  public static final DVRCoordinate VID_ZUGFERD_2_3_3_EXTENDED = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                    EZugferdProfile.EXTENDED.getArtifactID (),
                                                                                                    "2.3.3");

  // v2.4
  public static final DVRCoordinate VID_ZUGFERD_2_4_MINIMUM = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                 EZugferdProfile.MINIMUM.getArtifactID (),
                                                                                                 "2.4");
  public static final DVRCoordinate VID_ZUGFERD_2_4_BASIC_WL = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                  EZugferdProfile.BASIC_WL.getArtifactID (),
                                                                                                  "2.4");
  public static final DVRCoordinate VID_ZUGFERD_2_4_BASIC = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                               EZugferdProfile.BASIC.getArtifactID (),
                                                                                               "2.4");
  public static final DVRCoordinate VID_ZUGFERD_2_4_EN16931 = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                 EZugferdProfile.EN16931.getArtifactID (),
                                                                                                 "2.4");
  public static final DVRCoordinate VID_ZUGFERD_2_4_EXTENDED = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                  EZugferdProfile.EXTENDED.getArtifactID (),
                                                                                                  "2.4");

  // Global version map
  private static final ICommonsMap <DVRVersion, DVRVersion> ZUGFERD_TO_FACTURX_MAP = new CommonsHashMap <> ();
  static
  {
    ZUGFERD_TO_FACTURX_MAP.put (DVRVersion.parseOrNull ("2.0.1"), DVRVersion.parseOrNull ("1.0.3"));
    ZUGFERD_TO_FACTURX_MAP.put (DVRVersion.parseOrNull ("2.1"), DVRVersion.parseOrNull ("1.0.5"));
    ZUGFERD_TO_FACTURX_MAP.put (DVRVersion.parseOrNull ("2.2"), DVRVersion.parseOrNull ("1.0.6"));
    ZUGFERD_TO_FACTURX_MAP.put (DVRVersion.parseOrNull ("2.3.2"), DVRVersion.parseOrNull ("1.0.7-2"));
    ZUGFERD_TO_FACTURX_MAP.put (DVRVersion.parseOrNull ("2.3.3"), DVRVersion.parseOrNull ("1.0.7-3"));
    ZUGFERD_TO_FACTURX_MAP.put (DVRVersion.parseOrNull ("2.4"), DVRVersion.parseOrNull ("1.0.8"));
  }

  private ZugferdValidation ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return ZugferdValidation.class.getClassLoader ();
  }

  @Nullable
  public static DVRCoordinate getMappedFacturXVESID (@NonNull final DVRCoordinate aZugferdVESID)
  {
    ValueEnforcer.notNull (aZugferdVESID, "ZugferdVESID");
    final DVRVersion aFacturXVersion = ZUGFERD_TO_FACTURX_MAP.get (aZugferdVESID.getVersionObj ());
    if (aFacturXVersion == null)
      return null;

    return new DVRCoordinate (GROUP_ID_FACTUR_X, aZugferdVESID.getArtifactID (), aFacturXVersion);
  }

  private static void _registerFacturXAlias (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry,
                                             @NonNull final EZugferdProfile eProfile,
                                             @NonNull final ValidationExecutorSet <IValidationSourceXML> aVES)
  {
    final DVRCoordinate aFacturXVESID = getMappedFacturXVESID (aVES.getID ());
    aRegistry.registerValidationExecutorSet (new ValidationExecutorSetAlias <> (aFacturXVESID,
                                                                                "Factur-X " +
                                                                                               aFacturXVESID.getVersionString () +
                                                                                               " (" +
                                                                                               eProfile.getDisplayName () +
                                                                                               ")",
                                                                                aVES));
  }

  /**
   * Register all standard Zugferd validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  @SuppressWarnings ("deprecation")
  public static void initZugferd (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // Zugferd 2.0.1 / Factur-X 1.0.3
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      final String sZugferdVersion = "2.0.1";
      final String sProfileNamePart = switch (eProfile)
      {
        case MINIMUM, BASIC_WL -> "basicwl_minimum";
        case BASIC, EN16931 -> "en16931";
        case EXTENDED -> "extended";
        default -> throw new IllegalStateException ();
      };
      final var aVESchematron = PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource ("/external/schematron/" +
                                                                                                sZugferdVersion +
                                                                                                "/zugferd2p0_" +
                                                                                                sProfileNamePart +
                                                                                                ".xslt",
                                                                                                _getCL ()));

      // Register as Zugferd
      final DVRCoordinate aVESID = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                      eProfile.getArtifactID (),
                                                                      sZugferdVersion);
      final String sDisplayName = "ZUGFeRD " + sZugferdVersion + " (" + eProfile.getDisplayName () + ")";
      final IValidationExecutorSetStatus aStatus = PhiveRulesHelper.createSimpleStatus (bDeprecated);
      final ValidationExecutorSet <IValidationSourceXML> aVES = ValidationExecutorSet.create (aVESID,
                                                                                              sDisplayName,
                                                                                              aStatus,
                                                                                              ValidationExecutorXSD.create (new ClassPathResource ("/external/schemas/" +
                                                                                                                                                   sZugferdVersion +
                                                                                                                                                   "/" +
                                                                                                                                                   sProfileNamePart +
                                                                                                                                                   "/zugferd2p0_" +
                                                                                                                                                   sProfileNamePart +
                                                                                                                                                   ".xsd",
                                                                                                                                                   _getCL ())),
                                                                                              aVESchematron);
      aRegistry.registerValidationExecutorSet (aVES);

      // Also register alias as Factur-X
      _registerFacturXAlias (aRegistry, eProfile, aVES);
    }

    // Zugferd 2.1 / Factur-X 1.0.5
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      final String sZugferdVersion = "2.1";
      final String sFilenameSuffix = eProfile == EZugferdProfile.BASIC_WL ? "BASIC-WL" : eProfile.getFilenameSuffix ();

      final var aVESchematron = PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource ("/external/schematron/" +
                                                                                                sZugferdVersion +
                                                                                                "/FACTUR-X_" +
                                                                                                sFilenameSuffix +
                                                                                                ".xslt",
                                                                                                _getCL ()));

      // Register as Zugferd
      final DVRCoordinate aVESID = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                      eProfile.getArtifactID (),
                                                                      sZugferdVersion);
      final String sDisplayName = "ZUGFeRD " + sZugferdVersion + " (" + eProfile.getDisplayName () + ")";
      final IValidationExecutorSetStatus aStatus = PhiveRulesHelper.createSimpleStatus (bDeprecated);
      final ValidationExecutorSet <IValidationSourceXML> aVES;
      if (eProfile == EZugferdProfile.EN16931)
      {
        // Based on 1.3.1
        final IValidationExecutorSet <IValidationSourceXML> aVESCII_1_3_1 = aRegistry.getOfID (EN16931Validation.VID_CII_131);
        if (aVESCII_1_3_1 == null)
          throw new InitializationException ("The EN 16931 VES are missing. Make sure to call EN16931Validation.initEN16931 first.");

        aVES = ValidationExecutorSet.createDerived (aVESCII_1_3_1, aVESID, sDisplayName, aStatus, aVESchematron);
      }
      else
      {
        aVES = ValidationExecutorSet.create (aVESID,
                                             sDisplayName,
                                             aStatus,
                                             ValidationExecutorXSD.create (new ClassPathResource ("/external/schemas/" +
                                                                                                  sZugferdVersion +
                                                                                                  "/" +
                                                                                                  eProfile.getFolderName () +
                                                                                                  "/FACTUR-X_" +
                                                                                                  sFilenameSuffix +
                                                                                                  ".xsd",
                                                                                                  _getCL ())),
                                             aVESchematron);
      }
      aRegistry.registerValidationExecutorSet (aVES);

      // Also register alias as Factur-X
      _registerFacturXAlias (aRegistry, eProfile, aVES);
    }

    // Zugferd 2.2 / Factur-X 1.0.6
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      final String sZugferdVersion = "2.2";
      final String sFilenameSuffix = eProfile == EZugferdProfile.BASIC_WL ? "BASIC-WL" : eProfile.getFilenameSuffix ();

      final var aVESchematron = PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource ("/external/schematron/" +
                                                                                                sZugferdVersion +
                                                                                                "/FACTUR-X_" +
                                                                                                sFilenameSuffix +
                                                                                                ".xslt",
                                                                                                _getCL ()));

      // Register as Zugferd
      final DVRCoordinate aVESID = PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                      eProfile.getArtifactID (),
                                                                      sZugferdVersion);
      final String sDisplayName = "ZUGFeRD " + sZugferdVersion + " (" + eProfile.getDisplayName () + ")";
      final IValidationExecutorSetStatus aStatus = PhiveRulesHelper.createSimpleStatus (bDeprecated);
      final ValidationExecutorSet <IValidationSourceXML> aVES;
      if (eProfile == EZugferdProfile.EN16931)
      {
        // Based on 1.3.7-SNAPSHOT
        aVES = ValidationExecutorSet.createDerived (aRegistry.getOfID (EN16931Validation.VID_CII_137),
                                                    aVESID,
                                                    sDisplayName,
                                                    aStatus,
                                                    aVESchematron);
      }
      else
      {
        aVES = ValidationExecutorSet.create (aVESID,
                                             sDisplayName,
                                             aStatus,
                                             ValidationExecutorXSD.create (new ClassPathResource ("/external/schemas/" +
                                                                                                  sZugferdVersion +
                                                                                                  "/" +
                                                                                                  eProfile.getFolderName () +
                                                                                                  "/FACTUR-X_" +
                                                                                                  sFilenameSuffix +
                                                                                                  ".xsd",
                                                                                                  _getCL ())),
                                             aVESchematron);
      }
      aRegistry.registerValidationExecutorSet (aVES);

      // Also register alias as Factur-X
      _registerFacturXAlias (aRegistry, eProfile, aVES);
    }

    // Zugferd 2.3.2 / Factur-X 1.0.7-2
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      final String sZugferdVersion = "2.3.2";

      final ValidationExecutorSet <IValidationSourceXML> aVES = ValidationExecutorSet.create (PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                                                 eProfile.getArtifactID (),
                                                                                                                                 sZugferdVersion),
                                                                                              "ZUGFeRD " +
                                                                                                                                                   sZugferdVersion +
                                                                                                                                                   " (" +
                                                                                                                                                   eProfile.getDisplayName () +
                                                                                                                                                   ")",
                                                                                              PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                              ValidationExecutorXSD.create (new ClassPathResource ("/external/schemas/" +
                                                                                                                                                   sZugferdVersion +
                                                                                                                                                   "/" +
                                                                                                                                                   eProfile.getFolderName () +
                                                                                                                                                   "/Factur-X_1.07.2_" +
                                                                                                                                                   eProfile.getFilenameSuffix () +
                                                                                                                                                   ".xsd",
                                                                                                                                                   _getCL ())),
                                                                                              PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource ("/external/schematron/" +
                                                                                                                                                              sZugferdVersion +
                                                                                                                                                              "/Factur-X_1.07.2_" +
                                                                                                                                                              eProfile.getFilenameSuffix () +
                                                                                                                                                              ".xslt",
                                                                                                                                                              _getCL ())));
      aRegistry.registerValidationExecutorSet (aVES);

      // Also register alias as Factur-X
      _registerFacturXAlias (aRegistry, eProfile, aVES);
    }

    // Zugferd 2.3.3 / Factur-X 1.0.7-3
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      final String sZugferdVersion = "2.3.3";

      final ValidationExecutorSet <IValidationSourceXML> aVES = ValidationExecutorSet.create (PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                                                 eProfile.getArtifactID (),
                                                                                                                                 sZugferdVersion),
                                                                                              "ZUGFeRD " +
                                                                                                                                                   sZugferdVersion +
                                                                                                                                                   " (" +
                                                                                                                                                   eProfile.getDisplayName () +
                                                                                                                                                   ")",
                                                                                              PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                              ValidationExecutorXSD.create (new ClassPathResource ("/external/schemas/" +
                                                                                                                                                   sZugferdVersion +
                                                                                                                                                   "/" +
                                                                                                                                                   eProfile.getFolderName () +
                                                                                                                                                   "/Factur-X_1.07.3_" +
                                                                                                                                                   eProfile.getFilenameSuffix () +
                                                                                                                                                   ".xsd",
                                                                                                                                                   _getCL ())),
                                                                                              PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource ("/external/schematron/" +
                                                                                                                                                              sZugferdVersion +
                                                                                                                                                              "/Factur-X_1.07.3_" +
                                                                                                                                                              eProfile.getFilenameSuffix () +
                                                                                                                                                              ".xslt",
                                                                                                                                                              _getCL ())));
      aRegistry.registerValidationExecutorSet (aVES);

      // Also register alias as Factur-X
      _registerFacturXAlias (aRegistry, eProfile, aVES);
    }

    // Zugferd 2.4 / Factur-X 1.0.8
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      final String sZugferdVersion = "2.4";

      final ValidationExecutorSet <IValidationSourceXML> aVES = ValidationExecutorSet.create (PhiveRulesHelper.createCoordinate (GROUP_ID_ZUGFERD,
                                                                                                                                 eProfile.getArtifactID (),
                                                                                                                                 sZugferdVersion),
                                                                                              "ZUGFeRD " +
                                                                                                                                                   sZugferdVersion +
                                                                                                                                                   " (" +
                                                                                                                                                   eProfile.getDisplayName () +
                                                                                                                                                   ")",
                                                                                              PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                                              ValidationExecutorXSD.create (new ClassPathResource ("/external/schemas/" +
                                                                                                                                                   sZugferdVersion +
                                                                                                                                                   "/" +
                                                                                                                                                   eProfile.getFolderName () +
                                                                                                                                                   "/FACTUR-X_" +
                                                                                                                                                   eProfile.getFilenameSuffix24onwards () +
                                                                                                                                                   ".xsd",
                                                                                                                                                   _getCL ())),
                                                                                              PhiveRulesCIIHelper.createXSLT_CII_D22B (new ClassPathResource ("/external/schematron/" +
                                                                                                                                                              sZugferdVersion +
                                                                                                                                                              "/FACTUR-X_" +
                                                                                                                                                              eProfile.getFilenameSuffix24onwards () +
                                                                                                                                                              ".xslt",
                                                                                                                                                              _getCL ())));
      aRegistry.registerValidationExecutorSet (aVES);

      // Also register alias as Factur-X
      _registerFacturXAlias (aRegistry, eProfile, aVES);
    }
  }
}
