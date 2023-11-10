/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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
import com.helger.diver.api.version.VESID;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;

/**
 * Peppol Directory Business Card validation configuration
 *
 * @author Philip Helger
 * @since 2.1.17
 */
@Immutable
public final class PeppolValidationReporting
{
  @Nonnull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationReporting.class.getClassLoader ();
  }

  private static final String BASE_PATH_XSD = "external/schemas/";
  private static final String BASE_PATH_SCH = "external/schematron/reporting/";

  private static final String GROUP_ID = "eu.peppol.reporting";

  // EUSR

  @Deprecated
  public static final VESID VID_OPENPEPPOL_EUSR_V100RC2 = new VESID (GROUP_ID, "eusr", "1.0.0-RC2");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_EUSR_V100 = new VESID (GROUP_ID, "eusr", "1.0.0");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_EUSR_V101 = new VESID (GROUP_ID, "eusr", "1.0.1");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_EUSR_V110 = new VESID (GROUP_ID, "eusr", "1.1.0");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_EUSR_V111 = new VESID (GROUP_ID, "eusr", "1.1.1");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_EUSR_V112 = new VESID (GROUP_ID, "eusr", "1.1.2");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_EUSR_V113 = new VESID (GROUP_ID, "eusr", "1.1.3");
  public static final VESID VID_OPENPEPPOL_EUSR_V114 = new VESID (GROUP_ID, "eusr", "1.1.4");

  // TSR

  @Deprecated
  public static final VESID VID_OPENPEPPOL_TSR_V100 = new VESID (GROUP_ID, "tsr", "1.0.0");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_TSR_V101 = new VESID (GROUP_ID, "tsr", "1.0.1");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_TSR_V102 = new VESID (GROUP_ID, "tsr", "1.0.2");
  @Deprecated
  public static final VESID VID_OPENPEPPOL_TSR_V103 = new VESID (GROUP_ID, "tsr", "1.0.3");
  public static final VESID VID_OPENPEPPOL_TSR_V104 = new VESID (GROUP_ID, "tsr", "1.0.4");

  private PeppolValidationReporting ()
  {}

  public static void init (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // EUSR
    {
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_EUSR_V100RC2,
                                                                             "Peppol End User Statistics Report v1.0.0-RC2",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (new ClassPathResource (BASE_PATH_XSD +
                                                                                                                                  "peppol-end-user-statistics-reporting-1.0.0-RC2.xsd",
                                                                                                                                  _getCL ())),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "eusr/1.0.0-RC2/xslt/peppol-end-user-statistics-reporting-1.0.0-RC2.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));
      final ClassPathResource aXSD100 = new ClassPathResource (BASE_PATH_XSD +
                                                               "peppol-end-user-statistics-reporting-1.0.0.xsd",
                                                               _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_EUSR_V100,
                                                                             "Peppol End User Statistics Report v1.0.0",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (aXSD100),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "eusr/1.0.0/xslt/peppol-end-user-statistics-reporting-1.0.0.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_EUSR_V101,
                                                                             "Peppol End User Statistics Report v1.0.1",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (aXSD100),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "eusr/1.0.1/xslt/peppol-end-user-statistics-reporting-1.0.1.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));

      final ClassPathResource aXSD11 = new ClassPathResource (BASE_PATH_XSD +
                                                              "peppol-end-user-statistics-reporting-1.1.xsd",
                                                              _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_EUSR_V110,
                                                                             "Peppol End User Statistics Report v1.1.0",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (aXSD11),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "eusr/1.1.0/xslt/peppol-end-user-statistics-reporting-1.1.0.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_EUSR_V111,
                                                                             "Peppol End User Statistics Report v1.1.1",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (aXSD11),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "eusr/1.1.1/xslt/peppol-end-user-statistics-reporting-1.1.1.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_EUSR_V112,
                                                                             "Peppol End User Statistics Report v1.1.2",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (aXSD11),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "eusr/1.1.2/xslt/peppol-end-user-statistics-reporting-1.1.2.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_EUSR_V113,
                                                                             "Peppol End User Statistics Report v1.1.3",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (aXSD11),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "eusr/1.1.3/xslt/peppol-end-user-statistics-reporting-1.1.3.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_EUSR_V114,
                                                                             "Peppol End User Statistics Report v1.1.4",
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (aXSD11),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "eusr/1.1.4/xslt/peppol-end-user-statistics-reporting-1.1.4.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));
    }

    // TSR
    {
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_TSR_V100,
                                                                             "Peppol Transaction Statistics Report v1.0.0",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (new ClassPathResource (BASE_PATH_XSD +
                                                                                                                                  "peppol-transaction-statistics-reporting-1.0.0.xsd",
                                                                                                                                  _getCL ())),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "tsr/1.0.0/xslt/peppol-transaction-statistics-reporting-1.0.0.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));

      final ClassPathResource aXSD101 = new ClassPathResource (BASE_PATH_XSD +
                                                               "peppol-transaction-statistics-reporting-1.0.1.xsd",
                                                               _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_TSR_V101,
                                                                             "Peppol Transaction Statistics Report v1.0.1",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (aXSD101),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "tsr/1.0.1/xslt/peppol-transaction-statistics-reporting-1.0.1.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_TSR_V102,
                                                                             "Peppol Transaction Statistics Report v1.0.2",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (aXSD101),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "tsr/1.0.2/xslt/peppol-transaction-statistics-reporting-1.0.2.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_TSR_V103,
                                                                             "Peppol Transaction Statistics Report v1.0.3",
                                                                             bDeprecated,
                                                                             ValidationExecutorXSD.create (aXSD101),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "tsr/1.0.3/xslt/peppol-transaction-statistics-reporting-1.0.3.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_TSR_V104,
                                                                             "Peppol Transaction Statistics Report v1.0.4",
                                                                             bNotDeprecated,
                                                                             ValidationExecutorXSD.create (aXSD101),
                                                                             ValidationExecutorSchematron.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                             "tsr/1.0.4/xslt/peppol-transaction-statistics-reporting-1.0.4.xslt",
                                                                                                                                             _getCL ()),
                                                                                                                      null)));
    }
  }
}
