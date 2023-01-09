/*
 * Copyright (C) 2018-2023 Philip Helger (www.helger.com)
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
package com.helger.phive.ehf;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.engine.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.engine.schematron.ValidationExecutorSchematron;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.engine.xsd.ValidationExecutorXSD;
import com.helger.ubl21.EUBL21DocumentType;
import com.helger.ubl21.UBL21NamespaceContext;

/**
 * EHF G2 validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public class EHFValidationG2
{
  private static final String GROUP_ID = "no.ehf";

  // 2018-11
  @Deprecated
  public static final VESID VID_EHF_CATALOGUE_1_0_13 = new VESID (GROUP_ID, "catalogue", "1.0.13");
  @Deprecated
  public static final VESID VID_EHF_CATALOGUE_RESPONSE_1_0_13 = new VESID (GROUP_ID, "catalogue-response", "1.0.13");
  @Deprecated
  public static final VESID VID_EHF_CREDITNOTE_2_0_15 = new VESID (GROUP_ID, "creditnote", "2.0.15");
  @Deprecated
  public static final VESID VID_EHF_DESPATCH_ADVICE_1_0_10 = new VESID (GROUP_ID, "despatch-advice", "1.0.10");
  @Deprecated
  public static final VESID VID_EHF_INVOICE_2_0_15 = new VESID (GROUP_ID, "invoice", "2.0.15");
  @Deprecated
  public static final VESID VID_EHF_ORDER_1_0_11 = new VESID (GROUP_ID, "order", "1.0.11");
  @Deprecated
  public static final VESID VID_EHF_ORDER_AGREEMENT_1_0_2 = new VESID (GROUP_ID, "order-agreement", "1.0.2");
  @Deprecated
  public static final VESID VID_EHF_ORDER_RESPONSE_1_0_11 = new VESID (GROUP_ID, "order-response", "1.0.11");
  @Deprecated
  public static final VESID VID_EHF_PUNCH_OUT_1_0_1 = new VESID (GROUP_ID, "punch-out", "1.0.1");
  public static final VESID VID_EHF_REMINDER_1_1_0 = new VESID (GROUP_ID, "reminder", "1.1.0");

  // 2019-06
  @Deprecated
  public static final VESID VID_EHF_CATALOGUE_1_0_14 = new VESID (GROUP_ID, "catalogue", "1.0.14");
  @Deprecated
  public static final VESID VID_EHF_CATALOGUE_RESPONSE_1_0_14 = new VESID (GROUP_ID, "catalogue-response", "1.0.14");
  @Deprecated
  public static final VESID VID_EHF_CREDITNOTE_2_0_16 = new VESID (GROUP_ID, "creditnote", "2.0.16");
  @Deprecated
  public static final VESID VID_EHF_DESPATCH_ADVICE_1_0_11 = new VESID (GROUP_ID, "despatch-advice", "1.0.11");
  @Deprecated
  public static final VESID VID_EHF_INVOICE_2_0_16 = new VESID (GROUP_ID, "invoice", "2.0.16");
  @Deprecated
  public static final VESID VID_EHF_ORDER_1_0_12 = new VESID (GROUP_ID, "order", "1.0.12");
  @Deprecated
  public static final VESID VID_EHF_ORDER_AGREEMENT_1_0_3 = new VESID (GROUP_ID, "order-agreement", "1.0.3");
  @Deprecated
  public static final VESID VID_EHF_ORDER_RESPONSE_1_0_12 = new VESID (GROUP_ID, "order-response", "1.0.12");
  @Deprecated
  public static final VESID VID_EHF_PUNCH_OUT_1_0_2 = new VESID (GROUP_ID, "punch-out", "1.0.2");
  // Reminder is unchanged 1.1.0

  // 2019-12
  public static final VESID VID_EHF_CATALOGUE_1_0_15 = new VESID (GROUP_ID, "catalogue", "1.0.15");
  public static final VESID VID_EHF_CATALOGUE_RESPONSE_1_0_15 = new VESID (GROUP_ID, "catalogue-response", "1.0.15");
  public static final VESID VID_EHF_CREDITNOTE_2_0_17 = new VESID (GROUP_ID, "creditnote", "2.0.17");
  public static final VESID VID_EHF_DESPATCH_ADVICE_1_0_12 = new VESID (GROUP_ID, "despatch-advice", "1.0.12");
  public static final VESID VID_EHF_INVOICE_2_0_17 = new VESID (GROUP_ID, "invoice", "2.0.17");
  public static final VESID VID_EHF_ORDER_1_0_13 = new VESID (GROUP_ID, "order", "1.0.13");
  public static final VESID VID_EHF_ORDER_AGREEMENT_1_0_4 = new VESID (GROUP_ID, "order-agreement", "1.0.4");
  public static final VESID VID_EHF_ORDER_RESPONSE_1_0_13 = new VESID (GROUP_ID, "order-response", "1.0.13");
  public static final VESID VID_EHF_PUNCH_OUT_1_0_3 = new VESID (GROUP_ID, "punch-out", "1.0.3");
  // Reminder is unchanged 1.1.0

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return EHFValidationG2.class.getClassLoader ();
  }

  // 2018-11
  private static final String PATH_201811 = "/schematron/2018-11/xslt/";
  @Deprecated
  private static final IReadableResource EHF_COMMON_V1_0_4 = new ClassPathResource (PATH_201811 + "EHF-UBL-COMMON.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_CATALOGUE_V1_0_13 = new ClassPathResource (PATH_201811 + "EHF-UBL-T19.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_CATALOGUE_RESPONSE_V1_0_13 = new ClassPathResource (PATH_201811 + "EHF-UBL-T58.xslt",
                                                                                                 _getCL ());
  @Deprecated
  private static final IReadableResource EHF_CREDITNOTE_V2_0_15 = new ClassPathResource (PATH_201811 + "EHF-UBL-T14.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_DESPATCH_ADVICE_V1_0_10 = new ClassPathResource (PATH_201811 + "EHF-UBL-T16.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_INVOICE_V2_0_15 = new ClassPathResource (PATH_201811 + "EHF-UBL-T10.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_ORDER_V1_0_11 = new ClassPathResource (PATH_201811 + "EHF-UBL-T01.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_ORDER_AGREEMENT_V1_0_2 = new ClassPathResource (PATH_201811 + "EHF-UBL-T110.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_ORDER_RESPONSE_V1_0_11 = new ClassPathResource (PATH_201811 + "EHF-UBL-T76.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_PUNCH_OUT_V1_0_1 = new ClassPathResource (PATH_201811 + "EHF-UBL-T77.xslt", _getCL ());
  private static final IReadableResource EHF_REMINDER_V1_1_0 = new ClassPathResource (PATH_201811 + "EHF-UBL-T17.xslt", _getCL ());

  // 2019-06
  private static final String PATH_201906 = "/schematron/2019-06/xslt/";
  // Has the same version but is different
  @Deprecated
  private static final IReadableResource EHF_COMMON_V1_0_4B = new ClassPathResource (PATH_201906 + "EHF-UBL-COMMON.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_CATALOGUE_V1_0_14 = new ClassPathResource (PATH_201906 + "EHF-UBL-T19.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_CATALOGUE_RESPONSE_V1_0_14 = new ClassPathResource (PATH_201906 + "EHF-UBL-T58.xslt",
                                                                                                 _getCL ());
  @Deprecated
  private static final IReadableResource EHF_CREDITNOTE_V2_0_16 = new ClassPathResource (PATH_201906 + "EHF-UBL-T14.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_DESPATCH_ADVICE_V1_0_11 = new ClassPathResource (PATH_201906 + "EHF-UBL-T16.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_INVOICE_V2_0_16 = new ClassPathResource (PATH_201906 + "EHF-UBL-T10.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_ORDER_V1_0_12 = new ClassPathResource (PATH_201906 + "EHF-UBL-T01.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_ORDER_AGREEMENT_V1_0_3 = new ClassPathResource (PATH_201906 + "EHF-UBL-T110.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_ORDER_RESPONSE_V1_0_12 = new ClassPathResource (PATH_201906 + "EHF-UBL-T76.xslt", _getCL ());
  @Deprecated
  private static final IReadableResource EHF_PUNCH_OUT_V1_0_2 = new ClassPathResource (PATH_201906 + "EHF-UBL-T77.xslt", _getCL ());

  // 2019-12
  private static final String PATH_201912 = "/schematron/2019-12/xslt/";
  private static final IReadableResource EHF_COMMON_V1_0_4C = new ClassPathResource (PATH_201912 + "EHF-UBL-COMMON.xslt", _getCL ());
  private static final IReadableResource EHF_CATALOGUE_V1_0_15 = new ClassPathResource (PATH_201912 + "EHF-UBL-T19.xslt", _getCL ());
  private static final IReadableResource EHF_CATALOGUE_RESPONSE_V1_0_15 = new ClassPathResource (PATH_201912 + "EHF-UBL-T58.xslt",
                                                                                                 _getCL ());
  private static final IReadableResource EHF_CREDITNOTE_V2_0_17 = new ClassPathResource (PATH_201912 + "EHF-UBL-T14.xslt", _getCL ());
  private static final IReadableResource EHF_DESPATCH_ADVICE_V1_0_12 = new ClassPathResource (PATH_201912 + "EHF-UBL-T16.xslt", _getCL ());
  private static final IReadableResource EHF_INVOICE_V2_0_17 = new ClassPathResource (PATH_201912 + "EHF-UBL-T10.xslt", _getCL ());
  private static final IReadableResource EHF_ORDER_V1_0_13 = new ClassPathResource (PATH_201912 + "EHF-UBL-T01.xslt", _getCL ());
  private static final IReadableResource EHF_ORDER_AGREEMENT_V1_0_4 = new ClassPathResource (PATH_201912 + "EHF-UBL-T110.xslt", _getCL ());
  private static final IReadableResource EHF_ORDER_RESPONSE_V1_0_13 = new ClassPathResource (PATH_201912 + "EHF-UBL-T76.xslt", _getCL ());
  private static final IReadableResource EHF_PUNCH_OUT_V1_0_3 = new ClassPathResource (PATH_201912 + "EHF-UBL-T77.xslt", _getCL ());

  private EHFValidationG2 ()
  {}

  @Nonnull
  private static ValidationExecutorSchematron _createXSLT (@Nonnull final IReadableResource aRes)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, UBL21NamespaceContext.getInstance ());
  }

  /**
   * Register all standard EHF validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initEHF (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // For better error messages
    SchematronNamespaceBeautifier.addMappings (UBL21NamespaceContext.getInstance ());

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // 2018-11
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_CATALOGUE_1_0_13,
                                                                           "EHF Catalogue " + VID_EHF_CATALOGUE_1_0_13.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CATALOGUE),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "BIIRULES-UBL-T19.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "OPENPEPPOL-UBL-T19.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4),
                                                                           _createXSLT (EHF_CATALOGUE_V1_0_13)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_CATALOGUE_RESPONSE_1_0_13,
                                                                           "EHF Catalogue Response " +
                                                                                                              VID_EHF_CATALOGUE_RESPONSE_1_0_13.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.APPLICATION_RESPONSE),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "BIIRULES-UBL-T58.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "OPENPEPPOL-UBL-T58.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4),
                                                                           _createXSLT (EHF_CATALOGUE_RESPONSE_V1_0_13)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_CREDITNOTE_2_0_15,
                                                                           "EHF Creditnote " + VID_EHF_CREDITNOTE_2_0_15.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "BIIRULES-UBL-T14.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "OPENPEPPOL-UBL-T14.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4),
                                                                           _createXSLT (EHF_CREDITNOTE_V2_0_15)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_DESPATCH_ADVICE_1_0_10,
                                                                           "EHF Despatch Advice " +
                                                                                                           VID_EHF_DESPATCH_ADVICE_1_0_10.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.DESPATCH_ADVICE),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "BIIRULES-UBL-T16.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "OPENPEPPOL-UBL-T16.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4),
                                                                           _createXSLT (EHF_DESPATCH_ADVICE_V1_0_10)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_INVOICE_2_0_15,
                                                                           "EHF Invoice " + VID_EHF_INVOICE_2_0_15.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "BIIRULES-UBL-T10.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "OPENPEPPOL-UBL-T10.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4),
                                                                           _createXSLT (EHF_INVOICE_V2_0_15)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ORDER_1_0_11,
                                                                           "EHF Ordering " + VID_EHF_ORDER_1_0_11.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "BIIRULES-UBL-T01.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "OPENPEPPOL-UBL-T01.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4),
                                                                           _createXSLT (EHF_ORDER_V1_0_11)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ORDER_AGREEMENT_1_0_2,
                                                                           "EHF Order Agreement " +
                                                                                                          VID_EHF_ORDER_AGREEMENT_1_0_2.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER_RESPONSE),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "BIIRULES-UBL-T110.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "OPENPEPPOL-UBL-T110.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4),
                                                                           _createXSLT (EHF_ORDER_AGREEMENT_V1_0_2)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ORDER_RESPONSE_1_0_11,
                                                                           "EHF Order Response " +
                                                                                                          VID_EHF_ORDER_RESPONSE_1_0_11.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER_RESPONSE),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "BIIRULES-UBL-T76.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "OPENPEPPOL-UBL-T76.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4),
                                                                           _createXSLT (EHF_ORDER_RESPONSE_V1_0_11)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_PUNCH_OUT_1_0_1,
                                                                           "EHF Punch Out " + VID_EHF_PUNCH_OUT_1_0_1.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CATALOGUE),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "BIIRULES-UBL-T77.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201811 +
                                                                                                               "OPENPEPPOL-UBL-T77.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4),
                                                                           _createXSLT (EHF_PUNCH_OUT_V1_0_1)));

    // Reminder is NOT in PEPPOL
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_REMINDER_1_1_0,
                                                                           "EHF Reminder " + VID_EHF_REMINDER_1_1_0.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.REMINDER),
                                                                           _createXSLT (EHF_COMMON_V1_0_4),
                                                                           _createXSLT (EHF_REMINDER_V1_1_0)));

    // 2019-06
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_CATALOGUE_1_0_14,
                                                                           "EHF Catalogue " + VID_EHF_CATALOGUE_1_0_14.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CATALOGUE),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "BIIRULES-UBL-T19.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "OPENPEPPOL-UBL-T19.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4B),
                                                                           _createXSLT (EHF_CATALOGUE_V1_0_14)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_CATALOGUE_RESPONSE_1_0_14,
                                                                           "EHF Catalogue Response " +
                                                                                                              VID_EHF_CATALOGUE_RESPONSE_1_0_14.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.APPLICATION_RESPONSE),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "BIIRULES-UBL-T58.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "OPENPEPPOL-UBL-T58.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4B),
                                                                           _createXSLT (EHF_CATALOGUE_RESPONSE_V1_0_14)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_CREDITNOTE_2_0_16,
                                                                           "EHF Creditnote " + VID_EHF_CREDITNOTE_2_0_16.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "BIIRULES-UBL-T14.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "OPENPEPPOL-UBL-T14.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4B),
                                                                           _createXSLT (EHF_CREDITNOTE_V2_0_16)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_DESPATCH_ADVICE_1_0_11,
                                                                           "EHF Despatch Advice " +
                                                                                                           VID_EHF_DESPATCH_ADVICE_1_0_11.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.DESPATCH_ADVICE),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "BIIRULES-UBL-T16.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "OPENPEPPOL-UBL-T16.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4B),
                                                                           _createXSLT (EHF_DESPATCH_ADVICE_V1_0_11)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_INVOICE_2_0_16,
                                                                           "EHF Invoice " + VID_EHF_INVOICE_2_0_16.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "BIIRULES-UBL-T10.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "OPENPEPPOL-UBL-T10.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4B),
                                                                           _createXSLT (EHF_INVOICE_V2_0_16)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ORDER_1_0_12,
                                                                           "EHF Ordering " + VID_EHF_ORDER_1_0_12.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "BIIRULES-UBL-T01.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "OPENPEPPOL-UBL-T01.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4B),
                                                                           _createXSLT (EHF_ORDER_V1_0_12)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ORDER_AGREEMENT_1_0_3,
                                                                           "EHF Order Agreement " +
                                                                                                          VID_EHF_ORDER_AGREEMENT_1_0_3.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER_RESPONSE),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "BIIRULES-UBL-T110.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "OPENPEPPOL-UBL-T110.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4B),
                                                                           _createXSLT (EHF_ORDER_AGREEMENT_V1_0_3)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ORDER_RESPONSE_1_0_12,
                                                                           "EHF Order Response " +
                                                                                                          VID_EHF_ORDER_RESPONSE_1_0_12.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER_RESPONSE),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "BIIRULES-UBL-T76.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "OPENPEPPOL-UBL-T76.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4B),
                                                                           _createXSLT (EHF_ORDER_RESPONSE_V1_0_12)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_PUNCH_OUT_1_0_2,
                                                                           "EHF Punch Out " + VID_EHF_PUNCH_OUT_1_0_2.getVersion (),
                                                                           bDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CATALOGUE),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "BIIRULES-UBL-T77.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201906 +
                                                                                                               "OPENPEPPOL-UBL-T77.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4B),
                                                                           _createXSLT (EHF_PUNCH_OUT_V1_0_2)));
    // Reminder is from 2018-11

    // 2019-12
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_CATALOGUE_1_0_15,
                                                                           "EHF Catalogue " + VID_EHF_CATALOGUE_1_0_15.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CATALOGUE),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "BIIRULES-UBL-T19.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "OPENPEPPOL-UBL-T19.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4C),
                                                                           _createXSLT (EHF_CATALOGUE_V1_0_15)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_CATALOGUE_RESPONSE_1_0_15,
                                                                           "EHF Catalogue Response " +
                                                                                                              VID_EHF_CATALOGUE_RESPONSE_1_0_15.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.APPLICATION_RESPONSE),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "BIIRULES-UBL-T58.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "OPENPEPPOL-UBL-T58.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4C),
                                                                           _createXSLT (EHF_CATALOGUE_RESPONSE_V1_0_15)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_CREDITNOTE_2_0_17,
                                                                           "EHF Creditnote " + VID_EHF_CREDITNOTE_2_0_17.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CREDIT_NOTE),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "BIIRULES-UBL-T14.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "OPENPEPPOL-UBL-T14.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4C),
                                                                           _createXSLT (EHF_CREDITNOTE_V2_0_17)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_DESPATCH_ADVICE_1_0_12,
                                                                           "EHF Despatch Advice " +
                                                                                                           VID_EHF_DESPATCH_ADVICE_1_0_12.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.DESPATCH_ADVICE),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "BIIRULES-UBL-T16.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "OPENPEPPOL-UBL-T16.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4C),
                                                                           _createXSLT (EHF_DESPATCH_ADVICE_V1_0_12)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_INVOICE_2_0_17,
                                                                           "EHF Invoice " + VID_EHF_INVOICE_2_0_17.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.INVOICE),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "BIIRULES-UBL-T10.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "OPENPEPPOL-UBL-T10.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4C),
                                                                           _createXSLT (EHF_INVOICE_V2_0_17)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ORDER_1_0_13,
                                                                           "EHF Ordering " + VID_EHF_ORDER_1_0_13.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "BIIRULES-UBL-T01.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "OPENPEPPOL-UBL-T01.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4C),
                                                                           _createXSLT (EHF_ORDER_V1_0_13)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ORDER_AGREEMENT_1_0_4,
                                                                           "EHF Order Agreement " +
                                                                                                          VID_EHF_ORDER_AGREEMENT_1_0_4.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER_RESPONSE),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "BIIRULES-UBL-T110.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "OPENPEPPOL-UBL-T110.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4C),
                                                                           _createXSLT (EHF_ORDER_AGREEMENT_V1_0_4)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_ORDER_RESPONSE_1_0_13,
                                                                           "EHF Order Response " +
                                                                                                          VID_EHF_ORDER_RESPONSE_1_0_13.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.ORDER_RESPONSE),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "BIIRULES-UBL-T76.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "OPENPEPPOL-UBL-T76.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4C),
                                                                           _createXSLT (EHF_ORDER_RESPONSE_V1_0_13)));
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_EHF_PUNCH_OUT_1_0_3,
                                                                           "EHF Punch Out " + VID_EHF_PUNCH_OUT_1_0_3.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (EUBL21DocumentType.CATALOGUE),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "BIIRULES-UBL-T77.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (new ClassPathResource (PATH_201912 +
                                                                                                               "OPENPEPPOL-UBL-T77.xslt",
                                                                                                               _getCL ())),
                                                                           _createXSLT (EHF_COMMON_V1_0_4C),
                                                                           _createXSLT (EHF_PUNCH_OUT_V1_0_3)));
    // Reminder is from 2018-11
  }
}
