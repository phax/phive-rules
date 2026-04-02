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
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.peppol.uae.tdd.jaxb.CPeppolUAETDD;
import com.helger.peppol.uae.tdd.jaxb.PeppolUAETDD10Marshaller;
import com.helger.peppol.vida.tdd.jaxb.PeppolViDATDD100Marshaller;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Peppol Tax Data validation configuration
 *
 * @author Philip Helger
 * @since 4.1.2
 */
@Immutable
public final class PeppolValidationTaxData
{
  public static final String GROUP_ID = "org.peppol.taxdata";

  // AE
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_TDD_AE_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "ae",
                                                                                                     "1.0.0");
  @Deprecated (forRemoval = false)
  public static final DVRCoordinate VID_OPENPEPPOL_TDD_AE_1_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "ae",
                                                                                                     "1.0.1");
  public static final DVRCoordinate VID_OPENPEPPOL_TDD_AE_1_0_2 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                     "ae",
                                                                                                     "1.0.2");

  // ViDA Pilot
  public static final DVRCoordinate VID_OPENPEPPOL_TDD_VIDA_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "vida",
                                                                                                       "1.0.0");

  private PeppolValidationTaxData ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationTaxData.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final String BASE_PATH_SCH = "external/schematron/tdd/";

    // AE
    {
      // TODO peppol-uae >= 0.9.3: use PeppolUAETDD10Marshaller.getAllXSDs
      final ICommonsList <ClassPathResource> aXsds100 = UBL21Marshaller.getAllBaseXSDs ();
      aXsds100.add (CPeppolUAETDD.TDD_XSD_1_0);

      final MapBasedNamespaceContext aNsCtx = PeppolUAETDD10Marshaller.createNamespaceContext ();

      // TDD AE 1.0.0
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_TDD_AE_1_0_0)
                   .displayName ("AE Tax Data Document 1.0.0")
                   .deprecated ()
                   .addXSD (aXsds100)
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                       "ae/xslt/peppol-ae-tdd-1.0.0.xslt",
                                                                                       _getCL ()), aNsCtx))
                   .registerInto (aRegistry);

      // TDD AE 1.0.1
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_TDD_AE_1_0_1)
                   .displayName ("AE Tax Data Document 1.0.1")
                   .deprecated ()
                   .addXSD (aXsds100)
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                       "ae/xslt/peppol-ae-tdd-1.0.1.xslt",
                                                                                       _getCL ()), aNsCtx))
                   .registerInto (aRegistry);

      // TDD AE 1.0.2
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_TDD_AE_1_0_2)
                   .displayName ("AE Tax Data Document 1.0.2")
                   .notDeprecated ()
                   .addXSD (aXsds100)
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                       "ae/xslt/peppol-ae-tdd-1.0.2.xslt",
                                                                                       _getCL ()), aNsCtx))
                   .registerInto (aRegistry);
    }

    // ViDA Pilot
    {
      final MapBasedNamespaceContext aNsCtx = PeppolViDATDD100Marshaller.createNamespaceContext ();

      // 1.0.0
      VesXmlBuilder.builder ()
                   .vesID (VID_OPENPEPPOL_TDD_VIDA_1_0_0)
                   .displayName ("Peppol ViDA Pilot Tax Data Document 1.0.0")
                   .notDeprecated ()
                   .addXSD (PeppolViDATDD100Marshaller.getAllXSDs ())
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                       "vida/1.0.0/CEN-EN16931-UBL.xslt",
                                                                                       _getCL ()), aNsCtx))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                       "vida/1.0.0/PEPPOL-EN16931-UBL.xslt",
                                                                                       _getCL ()), aNsCtx))
                   .addSchematron (PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                       "vida/1.0.0/Peppol-ViDA-TDD.xslt",
                                                                                       _getCL ()), aNsCtx))
                   .registerInto (aRegistry);
    }
  }
}
