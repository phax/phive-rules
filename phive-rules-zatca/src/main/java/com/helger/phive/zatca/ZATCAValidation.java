/*
 * Copyright (C) 2025 Philip Helger (www.helger.com)
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
package com.helger.phive.zatca;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;

/**
 * Saudi Arabian ZATCA validation configuration. It is based on a custom build of the EN16931
 * validation artefacts.
 *
 * @author Philip Helger
 */
@Immutable
public final class ZATCAValidation
{
  public static final String GROUP_ID = "sa.zatca";

  // v2.0.3
  @Deprecated
  public static final DVRCoordinate VID_INVOICE_UBL_2_0_3 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "ubl-invoice",
                                                                                               "2.0.3");

  // v2.3.8
  public static final DVRCoordinate VID_INVOICE_UBL_2_3_8 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "ubl-invoice",
                                                                                               "2.3.8");

  private ZATCAValidation ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return ZATCAValidation.class.getClassLoader ();
  }

  /**
   * Register all standard ZATCA validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initZATCA (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    final String sPrefix = "/external/schematron/";

    // SDK 2.0.3
    {
      final String sPath = sPrefix + "2.0.3/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_INVOICE_UBL_2_0_3,
                                                                             "ZATCA/FATOORA Invoice (SDK 2.0.3)",
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "CEN-EN16931-UBL.xsl",
                                                                                                                                          _getCL ())),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "20210819_ZATCA_E-invoice_Validation_Rules.xsl",
                                                                                                                                          _getCL ()))));
    }

    // SDK 2.3.8
    {
      final String sPath = sPrefix + "2.3.8/";
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_INVOICE_UBL_2_3_8,
                                                                             "ZATCA/FATOORA Invoice (SDK 2.3.8)",
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "CEN-EN16931-UBL.xsl",
                                                                                                                                          _getCL ())),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPath +
                                                                                                                                          "20210819_ZATCA_E-invoice_Validation_Rules.xsl",
                                                                                                                                          _getCL ()))));
    }
  }
}
