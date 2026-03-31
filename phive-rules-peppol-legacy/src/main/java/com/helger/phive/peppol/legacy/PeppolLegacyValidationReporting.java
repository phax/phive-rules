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
package com.helger.phive.peppol.legacy;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesBuilder;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Peppol Network Reporting legacy validation configuration
 *
 * @author Philip Helger
 * @since 3.1.8
 */
@Immutable
@Deprecated (forRemoval = false)
public final class PeppolLegacyValidationReporting
{
  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolLegacyValidationReporting.class.getClassLoader ();
  }

  private static final String BASE_PATH_XSD = "external/schemas/";
  private static final String BASE_PATH_SCH = "external/schematron/reporting/";

  private static final String GROUP_ID = "eu.peppol.reporting";

  // EUSR

  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_EUSR_V100RC2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "eusr",
                                                                                                     "1.0.0-RC2");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_EUSR_V100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "eusr",
                                                                                                  "1.0.0");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_EUSR_V101 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "eusr",
                                                                                                  "1.0.1");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_EUSR_V110 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "eusr",
                                                                                                  "1.1.0");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_EUSR_V111 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "eusr",
                                                                                                  "1.1.1");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_EUSR_V112 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "eusr",
                                                                                                  "1.1.2");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_EUSR_V113 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "eusr",
                                                                                                  "1.1.3");

  // TSR

  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_TSR_V100 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "tsr",
                                                                                                 "1.0.0");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_TSR_V101 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "tsr",
                                                                                                 "1.0.1");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_TSR_V102 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "tsr",
                                                                                                 "1.0.2");
  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_TSR_V103 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "tsr",
                                                                                                 "1.0.3");

  private PeppolLegacyValidationReporting ()
  {}

  @Deprecated
  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;

    // EUSR
    {
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_EUSR_V100RC2)
                       .displayName ("Peppol End User Statistics Report v1.0.0-RC2")
                       .deprecated ()
                       .addXSD (new ClassPathResource (BASE_PATH_XSD +
                                                       "peppol-end-user-statistics-reporting-1.0.0-RC2.xsd",
                                                       _getCL ()))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                           "eusr/1.0.0-RC2/xslt/peppol-end-user-statistics-reporting-1.0.0-RC2.xslt",
                                                                                           _getCL ()), null))
                       .registerInto ();
      final ClassPathResource aXSD100 = new ClassPathResource (BASE_PATH_XSD +
                                                               "peppol-end-user-statistics-reporting-1.0.0.xsd",
                                                               _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_EUSR_V100)
                       .displayName ("Peppol End User Statistics Report v1.0.0")
                       .deprecated ()
                       .addXSD (aXSD100)
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                           "eusr/1.0.0/xslt/peppol-end-user-statistics-reporting-1.0.0.xslt",
                                                                                           _getCL ()), null))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_EUSR_V101)
                       .displayName ("Peppol End User Statistics Report v1.0.1")
                       .deprecated ()
                       .addXSD (aXSD100)
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                           "eusr/1.0.1/xslt/peppol-end-user-statistics-reporting-1.0.1.xslt",
                                                                                           _getCL ()), null))
                       .registerInto ();

      final ClassPathResource aXSD11 = new ClassPathResource (BASE_PATH_XSD +
                                                              "peppol-end-user-statistics-reporting-1.1.xsd",
                                                              _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_EUSR_V110)
                       .displayName ("Peppol End User Statistics Report v1.1.0")
                       .deprecated ()
                       .addXSD (aXSD11)
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                           "eusr/1.1.0/xslt/peppol-end-user-statistics-reporting-1.1.0.xslt",
                                                                                           _getCL ()), null))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_EUSR_V111)
                       .displayName ("Peppol End User Statistics Report v1.1.1")
                       .deprecated ()
                       .addXSD (aXSD11)
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                           "eusr/1.1.1/xslt/peppol-end-user-statistics-reporting-1.1.1.xslt",
                                                                                           _getCL ()), null))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_EUSR_V112)
                       .displayName ("Peppol End User Statistics Report v1.1.2")
                       .deprecated ()
                       .addXSD (aXSD11)
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                           "eusr/1.1.2/xslt/peppol-end-user-statistics-reporting-1.1.2.xslt",
                                                                                           _getCL ()), null))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_EUSR_V113)
                       .displayName ("Peppol End User Statistics Report v1.1.3")
                       .deprecated ()
                       .addXSD (aXSD11)
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                           "eusr/1.1.3/xslt/peppol-end-user-statistics-reporting-1.1.3.xslt",
                                                                                           _getCL ()), null))
                       .registerInto ();
    }

    // TSR
    {
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_TSR_V100)
                       .displayName ("Peppol Transaction Statistics Report v1.0.0")
                       .deprecated ()
                       .addXSD (new ClassPathResource (BASE_PATH_XSD +
                                                       "peppol-transaction-statistics-reporting-1.0.0.xsd",
                                                       _getCL ()))
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                           "tsr/1.0.0/xslt/peppol-transaction-statistics-reporting-1.0.0.xslt",
                                                                                           _getCL ()), null))
                       .registerInto ();

      final ClassPathResource aXSD101 = new ClassPathResource (BASE_PATH_XSD +
                                                               "peppol-transaction-statistics-reporting-1.0.1.xsd",
                                                               _getCL ());
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_TSR_V101)
                       .displayName ("Peppol Transaction Statistics Report v1.0.1")
                       .deprecated ()
                       .addXSD (aXSD101)
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                           "tsr/1.0.1/xslt/peppol-transaction-statistics-reporting-1.0.1.xslt",
                                                                                           _getCL ()), null))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_TSR_V102)
                       .displayName ("Peppol Transaction Statistics Report v1.0.2")
                       .deprecated ()
                       .addXSD (aXSD101)
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                           "tsr/1.0.2/xslt/peppol-transaction-statistics-reporting-1.0.2.xslt",
                                                                                           _getCL ()), null))
                       .registerInto ();
      PhiveRulesBuilder.forRegistry (aRegistry)
                       .vesID (VID_OPENPEPPOL_TSR_V103)
                       .displayName ("Peppol Transaction Statistics Report v1.0.3")
                       .deprecated ()
                       .addXSD (aXSD101)
                       .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                           "tsr/1.0.3/xslt/peppol-transaction-statistics-reporting-1.0.3.xslt",
                                                                                           _getCL ()), null))
                       .registerInto ();
    }
  }
}
