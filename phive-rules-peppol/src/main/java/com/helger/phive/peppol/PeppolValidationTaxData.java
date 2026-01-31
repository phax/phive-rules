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
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl21.UBL21NamespaceContext;
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

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = !bDeprecated;

    final String BASE_PATH_XSD = "external/schemas/";
    final String BASE_PATH_SCH = "external/schematron/tdd/";

    final ICommonsList <ClassPathResource> aXSDs_AE_100 = UBL21Marshaller.getAllBaseXSDs ();
    aXSDs_AE_100.add (new ClassPathResource (BASE_PATH_XSD + "peppol-tdd-1.0.0.xsd", _getCL ()));

    // TDD AE 1.0.0
    {
      final MapBasedNamespaceContext aNsCtx = UBL21NamespaceContext.getInstance ().getClone ();
      aNsCtx.addMapping ("pxs", "urn:peppol:schema:taxdata:1.0");

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_TDD_AE_1_0_0,
                                                                             "AE Tax Data Document v1.0.0",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (aXSDs_AE_100),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                 "ae/xslt/peppol-ae-tdd-1.0.0.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNsCtx)));
    }

    // TDD AE 1.0.1
    {
      final MapBasedNamespaceContext aNsCtx = UBL21NamespaceContext.getInstance ().getClone ();
      aNsCtx.addMapping ("pxs", "urn:peppol:schema:taxdata:1.0");

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_TDD_AE_1_0_1,
                                                                             "AE Tax Data Document v1.0.1",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (aXSDs_AE_100),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                 "ae/xslt/peppol-ae-tdd-1.0.1.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNsCtx)));
    }

    // TDD AE 1.0.2
    {
      final MapBasedNamespaceContext aNsCtx = UBL21NamespaceContext.getInstance ().getClone ();
      aNsCtx.addMapping ("pxs", "urn:peppol:schema:taxdata:1.0");

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OPENPEPPOL_TDD_AE_1_0_2,
                                                                             "AE Tax Data Document v1.0.2",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (aXSDs_AE_100),
                                                                             PhiveRulesHelper.createXSLT (new ClassPathResource (BASE_PATH_SCH +
                                                                                                                                 "ae/xslt/peppol-ae-tdd-1.0.2.xslt",
                                                                                                                                 _getCL ()),
                                                                                                          aNsCtx)));
    }
  }
}
