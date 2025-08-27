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

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.xml.namespace.MapBasedNamespaceContext;

import jakarta.annotation.Nonnull;

/**
 * Peppol Network Reporting validation configuration
 *
 * @author Philip Helger
 * @since 2.1.17
 */
@Immutable
public final class PeppolValidationReporting
{
  public static final String GROUP_ID = "eu.peppol.reporting";

  // EUSR

  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_EUSR_V114 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "eusr",
                                                                                                  "1.1.4");
  public static final DVRCoordinate VID_OPENPEPPOL_EUSR_V115 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                  "eusr",
                                                                                                  "1.1.5");

  // TSR

  @Deprecated
  public static final DVRCoordinate VID_OPENPEPPOL_TSR_V104 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "tsr",
                                                                                                 "1.0.4");
  public static final DVRCoordinate VID_OPENPEPPOL_TSR_V105 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                 "tsr",
                                                                                                 "1.0.5");

  private PeppolValidationReporting ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationReporting.class.getClassLoader ();
  }

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = !bDeprecated;

    final String BASE_PATH_XSD = "external/schemas/";
    final String BASE_PATH_SCH = "external/schematron/reporting/";

    // EUSR
    {
      final ClassPathResource aXSD11 = new ClassPathResource (BASE_PATH_XSD +
                                                              "peppol-end-user-statistics-reporting-1.1.xsd",
                                                              _getCL ());

      final MapBasedNamespaceContext aNsCtx = new MapBasedNamespaceContext ().setDefaultNamespaceURI ("urn:fdc:peppol:end-user-statistics-report:1.1");

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_EUSR_V114,
                                                                             "Peppol End User Statistics Report v1.1.4",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (aXSD11),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                 "eusr/1.1.4/xslt/peppol-end-user-statistics-reporting-1.1.4.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNsCtx)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_EUSR_V115,
                                                                             "Peppol End User Statistics Report v1.1.5",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (aXSD11),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                 "eusr/1.1.5/xslt/peppol-end-user-statistics-reporting-1.1.5.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNsCtx)));
    }

    // TSR
    {
      final ClassPathResource aXSD101 = new ClassPathResource (BASE_PATH_XSD +
                                                               "peppol-transaction-statistics-reporting-1.0.1.xsd",
                                                               _getCL ());

      final MapBasedNamespaceContext aNsCtx = new MapBasedNamespaceContext ().setDefaultNamespaceURI ("urn:fdc:peppol:transaction-statistics-report:1.0");

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_TSR_V104,
                                                                             "Peppol Transaction Statistics Report v1.0.4",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (aXSD101),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                 "tsr/1.0.4/xslt/peppol-transaction-statistics-reporting-1.0.4.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNsCtx)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_TSR_V105,
                                                                             "Peppol Transaction Statistics Report v1.0.5",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (aXSD101),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                 "tsr/1.0.5/xslt/peppol-transaction-statistics-reporting-1.0.5.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNsCtx)));
    }
  }
}
