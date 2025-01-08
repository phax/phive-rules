/*
 * Copyright (C) 2019-2024 Philip Helger (www.helger.com)
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
package com.helger.phive.xrechnung;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.CommonsHashMap;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.collection.impl.ICommonsMap;
import com.helger.commons.error.level.EErrorLevel;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executor.IValidationExecutor;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.rules.api.PhiveRulesCIIHelper;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.schematron.CustomErrorDetails;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Generic XRechnung validation configuration. It is based on the EN16931
 * validation artefacts.
 *
 * @author Philip Helger
 */
@Immutable
public final class XRechnungValidation
{
  public static final String GROUP_ID = "de.xrechnung";
  public static final String GROUP_ID_EXT = GROUP_ID + ".extension";

  // Valid from 1.7.20219- 31.12.2019
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_CII_120 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cii",
                                                                                               "1.2.0");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_CREDITNOTE_120 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "1.2.0");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_INVOICE_120 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "1.2.0");

  // Valid from 1.1.2020 - 30.6.2020
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_CII_121 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cii",
                                                                                               "1.2.1");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_CREDITNOTE_121 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "1.2.1");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_INVOICE_121 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "1.2.1");

  // Valid from 1.7.2020 - 31.12.2020
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_CII_122 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cii",
                                                                                               "1.2.2");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_CREDITNOTE_122 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "1.2.2");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_INVOICE_122 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "1.2.2");

  // Valid from 01.01.2021 - 30.06.2021
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_CII_200 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cii",
                                                                                               "2.0.0");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_CREDITNOTE_200 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "2.0.0");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_INVOICE_200 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "2.0.0");

  // Valid from 01.07.2021 - 31.01.2022
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_CII_201 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cii",
                                                                                               "2.0.1");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_CREDITNOTE_201 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "2.0.1");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_INVOICE_201 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "2.0.1");

  // Valid from 01.02.2022 - 31.07.2022
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_CII_211 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cii",
                                                                                               "2.1.1");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_CREDITNOTE_211 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "2.1.1");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_INVOICE_211 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "2.1.1");

  // Valid from 01.08.2022 - 31.07.2023
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_CII_220 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cii",
                                                                                               "2.2.0");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_CREDITNOTE_220 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "2.2.0");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_INVOICE_220 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "2.2.0");

  // Valid from 01.08.2023 - 31.01.2024
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_CII_231 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cii",
                                                                                               "2.3.1");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_CREDITNOTE_231 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "2.3.1");
  @Deprecated
  public static final DVRCoordinate VID_XRECHNUNG_UBL_INVOICE_231 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "2.3.1");

  // Valid from 01.02.2024
  public static final DVRCoordinate VID_XRECHNUNG_CII_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cii",
                                                                                               "3.0.0");
  public static final DVRCoordinate VID_XRECHNUNG_EXTENSION_CII_300 = PhiveRulesHelper.createCoordinate (GROUP_ID_EXT,
                                                                                                         "cii",
                                                                                                         "3.0.0");
  public static final DVRCoordinate VID_XRECHNUNG_UBL_CREDITNOTE_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "3.0.0");
  public static final DVRCoordinate VID_XRECHNUNG_UBL_INVOICE_300 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "3.0.0");
  public static final DVRCoordinate VID_XRECHNUNG_EXTENSION_UBL_INVOICE_300 = PhiveRulesHelper.createCoordinate (GROUP_ID_EXT,
                                                                                                                 "ubl-invoice",
                                                                                                                 "3.0.0");

  // Valid from 01.02.2024
  public static final DVRCoordinate VID_XRECHNUNG_CII_301 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cii",
                                                                                               "3.0.1");
  public static final DVRCoordinate VID_XRECHNUNG_EXTENSION_CII_301 = PhiveRulesHelper.createCoordinate (GROUP_ID_EXT,
                                                                                                         "cii",
                                                                                                         "3.0.1");
  public static final DVRCoordinate VID_XRECHNUNG_UBL_CREDITNOTE_301 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "3.0.1");
  public static final DVRCoordinate VID_XRECHNUNG_UBL_INVOICE_301 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "3.0.1");
  public static final DVRCoordinate VID_XRECHNUNG_EXTENSION_UBL_INVOICE_301 = PhiveRulesHelper.createCoordinate (GROUP_ID_EXT,
                                                                                                                 "ubl-invoice",
                                                                                                                 "3.0.1");

  // Valid from 01.02.2024
  public static final DVRCoordinate VID_XRECHNUNG_CII_302 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                               "cii",
                                                                                               "3.0.2");
  public static final DVRCoordinate VID_XRECHNUNG_EXTENSION_CII_302 = PhiveRulesHelper.createCoordinate (GROUP_ID_EXT,
                                                                                                         "cii",
                                                                                                         "3.0.2");
  public static final DVRCoordinate VID_XRECHNUNG_UBL_CREDITNOTE_302 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                          "ubl-creditnote",
                                                                                                          "3.0.2");
  public static final DVRCoordinate VID_XRECHNUNG_UBL_INVOICE_302 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                       "ubl-invoice",
                                                                                                       "3.0.2");
  public static final DVRCoordinate VID_XRECHNUNG_EXTENSION_UBL_INVOICE_302 = PhiveRulesHelper.createCoordinate (GROUP_ID_EXT,
                                                                                                                 "ubl-invoice",
                                                                                                                 "3.0.2");

  private XRechnungValidation ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return XRechnungValidation.class.getClassLoader ();
  }

  @Nonnull
  @ReturnsMutableCopy
  private static ICommonsList <IValidationExecutor <IValidationSourceXML>> _getListWithCustomErrorDetails (@Nonnull final IValidationExecutorSet <IValidationSourceXML> aSrc,
                                                                                                           @Nonnull final ICommonsMap <String, CustomErrorDetails> aCustomErrors)
  {
    // Same Schematrons as base VES, but modified customization
    final ICommonsList <IValidationExecutor <IValidationSourceXML>> ret = new CommonsArrayList <> (aSrc.executors ()
                                                                                                       .size () +
                                                                                                   1);
    for (final var aItem : aSrc)
      if (aItem instanceof ValidationExecutorSchematron)
        ret.add (((ValidationExecutorSchematron) aItem).getClone ().addCustomErrorDetails (aCustomErrors));
      else
        ret.add (aItem);
    return ret;
  }

  /**
   * Register all standard XRechnung validation execution sets to the provided
   * registry. Make sure to register the EN16931 artefacts before you register
   * this one.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  @SuppressWarnings ("deprecation")
  public static void initXRechnung (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bNotDeprecated = false;
    final boolean bDeprecated = true;

    final String sPrefix = "/external/schematron/";

    // Just new Schematrons on top
    // v1.2.0 (based on rule release 1.1.0)
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESCII110 = aRegistry.getOfID (EN16931Validation.VID_CII_110);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote110 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_110);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice110 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_110);

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESCII110,
                                                                                    VID_XRECHNUNG_CII_120,
                                                                                    "XRechnung CII " +
                                                                                                           VID_XRECHNUNG_CII_120.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                                                                                    "1.2.0/XRechnung-CII-validation.xslt",
                                                                                                                                                    _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLCreditNote110,
                                                                                    VID_XRECHNUNG_UBL_CREDITNOTE_120,
                                                                                    "XRechnung UBL Credit Note " +
                                                                                                                      VID_XRECHNUNG_UBL_CREDITNOTE_120.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                                                                                 "1.2.0/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLInvoice110,
                                                                                    VID_XRECHNUNG_UBL_INVOICE_120,
                                                                                    "XRechnung UBL Invoice " +
                                                                                                                   VID_XRECHNUNG_UBL_INVOICE_120.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                                                                                 "1.2.0/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                                 _getCL ()))));
    }

    // v1.2.1 (based on rule release 1.2.1)
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESCII121 = aRegistry.getOfID (EN16931Validation.VID_CII_121);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote121 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_121);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice121 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_121);

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESCII121,
                                                                                    VID_XRECHNUNG_CII_121,
                                                                                    "XRechnung CII " +
                                                                                                           VID_XRECHNUNG_CII_121.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                                                                                    "1.2.1/XRechnung-CII-validation.xslt",
                                                                                                                                                    _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLCreditNote121,
                                                                                    VID_XRECHNUNG_UBL_CREDITNOTE_121,
                                                                                    "XRechnung UBL Credit Note " +
                                                                                                                      VID_XRECHNUNG_UBL_CREDITNOTE_121.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                                                                                 "1.2.1/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLInvoice121,
                                                                                    VID_XRECHNUNG_UBL_INVOICE_121,
                                                                                    "XRechnung UBL Invoice " +
                                                                                                                   VID_XRECHNUNG_UBL_INVOICE_121.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                                                                                 "1.2.1/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                                 _getCL ()))));
    }

    // v1.2.2 (based on rule release 1.3.0)
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESCII130 = aRegistry.getOfID (EN16931Validation.VID_CII_130);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote130 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_130);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice130 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_130);

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESCII130,
                                                                                    VID_XRECHNUNG_CII_122,
                                                                                    "XRechnung CII " +
                                                                                                           VID_XRECHNUNG_CII_122.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                                                                                    "1.2.2/XRechnung-CII-validation.xslt",
                                                                                                                                                    _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLCreditNote130,
                                                                                    VID_XRECHNUNG_UBL_CREDITNOTE_122,
                                                                                    "XRechnung UBL Credit Note " +
                                                                                                                      VID_XRECHNUNG_UBL_CREDITNOTE_122.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                                                                                 "1.2.2/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                                                                                 _getCL ()))));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.createDerived (aVESUBLInvoice130,
                                                                                    VID_XRECHNUNG_UBL_INVOICE_122,
                                                                                    "XRechnung UBL Invoice " +
                                                                                                                   VID_XRECHNUNG_UBL_INVOICE_122.getVersionString (),
                                                                                    PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                                    PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                                                                                 "1.2.2/XRechnung-UBL-validation-Invoice.xslt",
                                                                                                                                                 _getCL ()))));
    }

    // v2.0.0 (based on rule release 1.4.0)
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESCII132 = aRegistry.getOfID (EN16931Validation.VID_CII_132);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote132 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_132);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice132 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_132);

      final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-01", CustomErrorDetails.of (EErrorLevel.INFO));
      aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
      aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));
      aCustomErrorLevels.put ("BR-CL-24", CustomErrorDetails.of (EErrorLevel.INFO));

      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESCII132,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                      "2.0.0/XRechnung-CII-validation.xslt",
                                                                                      _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_200,
                                                                               "XRechnung CII " +
                                                                                                      VID_XRECHNUNG_CII_200.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLCreditNote132,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "2.0.0/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_200,
                                                                               "XRechnung UBL Credit Note " +
                                                                                                                 VID_XRECHNUNG_UBL_CREDITNOTE_200.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLInvoice132,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "2.0.0/XRechnung-UBL-validation-Invoice.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_200,
                                                                               "XRechnung UBL Invoice " +
                                                                                                              VID_XRECHNUNG_UBL_INVOICE_200.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
    }

    // v2.0.1 (based on rule release 1.5.0)
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESCII133 = aRegistry.getOfID (EN16931Validation.VID_CII_133);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote133 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_133);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice133 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_133);

      final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-01", CustomErrorDetails.of (EErrorLevel.INFO));
      aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
      aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));
      aCustomErrorLevels.put ("BR-CL-24", CustomErrorDetails.of (EErrorLevel.INFO));

      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESCII133,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                      "2.0.1/XRechnung-CII-validation.xslt",
                                                                                      _getCL ())));
        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_201,
                                                                               "XRechnung CII " +
                                                                                                      VID_XRECHNUNG_CII_201.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLCreditNote133,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "2.0.1/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                   _getCL ())));
        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_201,
                                                                               "XRechnung UBL Credit Note " +
                                                                                                                 VID_XRECHNUNG_UBL_CREDITNOTE_201.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLInvoice133,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "2.0.1/XRechnung-UBL-validation-Invoice.xslt",
                                                                                   _getCL ())));
        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_201,
                                                                               "XRechnung UBL Invoice " +
                                                                                                              VID_XRECHNUNG_UBL_INVOICE_201.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
    }

    // v2.1.1 (based on rule release 1.6.0)
    // Based on the EN16931 rules in this fork:
    // https://github.com/phax/eInvoicing-EN16931/releases/tag/validation-1.3.6a
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESCII136a = aRegistry.getOfID (EN16931Validation.VID_CII_136A);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote136a = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_136A);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice136a = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_136A);

      final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-01", CustomErrorDetails.of (EErrorLevel.INFO));
      aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
      aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));
      aCustomErrorLevels.put ("BR-CL-24", CustomErrorDetails.of (EErrorLevel.INFO));

      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESCII136a,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                      "2.1.1/XRechnung-CII-validation.xslt",
                                                                                      _getCL ())));
        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_211,
                                                                               "XRechnung CII " +
                                                                                                      VID_XRECHNUNG_CII_211.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLCreditNote136a,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "2.1.1/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                   _getCL ())));
        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_211,
                                                                               "XRechnung UBL Credit Note " +
                                                                                                                 VID_XRECHNUNG_UBL_CREDITNOTE_211.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLInvoice136a,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "2.1.1/XRechnung-UBL-validation-Invoice.xslt",
                                                                                   _getCL ())));
        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_211,
                                                                               "XRechnung UBL Invoice " +
                                                                                                              VID_XRECHNUNG_UBL_INVOICE_211.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
    }

    // v2.2.0 (based on rule release 1.7.1)
    // Uses CEN release 1.3.7
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESCII137 = aRegistry.getOfID (EN16931Validation.VID_CII_137);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote137 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_137);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice137 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_137);

      final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-01", CustomErrorDetails.of (EErrorLevel.INFO));
      aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
      aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));

      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESCII137,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                      "2.2.0/XRechnung-CII-validation.xslt",
                                                                                      _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_220,
                                                                               "XRechnung CII " +
                                                                                                      VID_XRECHNUNG_CII_220.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLCreditNote137,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "2.2.0/XRechnung-UBL-validation-CreditNote.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_220,
                                                                               "XRechnung UBL Credit Note " +
                                                                                                                 VID_XRECHNUNG_UBL_CREDITNOTE_220.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLInvoice137,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "2.2.0/XRechnung-UBL-validation-Invoice.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_220,
                                                                               "XRechnung UBL Invoice " +
                                                                                                              VID_XRECHNUNG_UBL_INVOICE_220.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
    }

    // v2.3.1 (based on rule release 1.8.1)
    // Uses CEN rules 1.3.9
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESCII139 = aRegistry.getOfID (EN16931Validation.VID_CII_139);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote139 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_139);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice139 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_139);

      final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
      aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
      aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));

      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESCII139,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                      "2.3.1/XRechnung-CII-validation.xslt",
                                                                                      _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_231,
                                                                               "XRechnung CII " +
                                                                                                      VID_XRECHNUNG_CII_231.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLCreditNote139,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "2.3.1/XRechnung-UBL-validation.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_231,
                                                                               "XRechnung UBL Credit Note " +
                                                                                                                 VID_XRECHNUNG_UBL_CREDITNOTE_231.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLInvoice139,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "2.3.1/XRechnung-UBL-validation.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_231,
                                                                               "XRechnung UBL Invoice " +
                                                                                                              VID_XRECHNUNG_UBL_INVOICE_231.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                               aNewList));
      }
    }

    // v3.0.0 (based on rule release 2.0.0)
    // Uses CEN rules 1.3.10
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESCII1310 = aRegistry.getOfID (EN16931Validation.VID_CII_1310);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote1310 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_1310);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice1310 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_1310);

      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("CII-SR-453", CustomErrorDetails.of (EErrorLevel.ERROR));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESCII1310,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                      "3.0.0/XRechnung-CII-validation.xslt",
                                                                                      _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_300,
                                                                               "XRechnung CII " +
                                                                                                      VID_XRECHNUNG_CII_300.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-11", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-10", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-25", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-26", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("CII-SR-453", CustomErrorDetails.of (EErrorLevel.ERROR));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESCII1310,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                      "3.0.0/XRechnung-CII-validation.xslt",
                                                                                      _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_EXTENSION_CII_300,
                                                                               "XRechnung Extension CII " +
                                                                                                                VID_XRECHNUNG_EXTENSION_CII_300.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLCreditNote1310,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "3.0.0/XRechnung-UBL-validation.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_300,
                                                                               "XRechnung UBL Credit Note " +
                                                                                                                 VID_XRECHNUNG_UBL_CREDITNOTE_300.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }

      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLInvoice1310,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "3.0.0/XRechnung-UBL-validation.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_300,
                                                                               "XRechnung UBL Invoice " +
                                                                                                              VID_XRECHNUNG_UBL_INVOICE_300.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-24", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-10", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-11", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-25", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-26", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CO-16", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("UBL-CR-470", CustomErrorDetails.of (EErrorLevel.INFO));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLInvoice1310,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "3.0.0/XRechnung-UBL-validation.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_EXTENSION_UBL_INVOICE_300,
                                                                               "XRechnung Extension_UBL Invoice " +
                                                                                                                        VID_XRECHNUNG_EXTENSION_UBL_INVOICE_300.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }
    }

    // v3.0.1 (based on rule release 2.0.2)
    // Uses CEN rules 1.3.11
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESCII1311 = aRegistry.getOfID (EN16931Validation.VID_CII_1311);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote1311 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_1311);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice1311 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_1311);

      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("CII-SR-452", CustomErrorDetails.of (EErrorLevel.ERROR));
        aCustomErrorLevels.put ("CII-SR-453", CustomErrorDetails.of (EErrorLevel.ERROR));
        aCustomErrorLevels.put ("CII-SR-454", CustomErrorDetails.of (EErrorLevel.ERROR));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESCII1311,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                      "3.0.1/XRechnung-CII-validation.xslt",
                                                                                      _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_301,
                                                                               "XRechnung CII " +
                                                                                                      VID_XRECHNUNG_CII_301.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-11", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-10", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-24", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-25", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-26", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("CII-SR-452", CustomErrorDetails.of (EErrorLevel.ERROR));
        aCustomErrorLevels.put ("CII-SR-453", CustomErrorDetails.of (EErrorLevel.ERROR));
        aCustomErrorLevels.put ("CII-SR-454", CustomErrorDetails.of (EErrorLevel.ERROR));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESCII1311,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                      "3.0.1/XRechnung-CII-validation.xslt",
                                                                                      _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_EXTENSION_CII_301,
                                                                               "XRechnung ExtensionCII " +
                                                                                                                VID_XRECHNUNG_EXTENSION_CII_301.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }

      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLCreditNote1311,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "3.0.1/XRechnung-UBL-validation.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_301,
                                                                               "XRechnung UBL Credit Note " +
                                                                                                                 VID_XRECHNUNG_UBL_CREDITNOTE_301.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }

      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLInvoice1311,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "3.0.1/XRechnung-UBL-validation.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_301,
                                                                               "XRechnung UBL Invoice " +
                                                                                                              VID_XRECHNUNG_UBL_INVOICE_301.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-24", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-10", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-11", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-25", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-26", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CO-16", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("UBL-CR-470", CustomErrorDetails.of (EErrorLevel.INFO));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLInvoice1311,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "3.0.1/XRechnung-UBL-validation.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_EXTENSION_UBL_INVOICE_301,
                                                                               "XRechnung Extension UBL Invoice " +
                                                                                                                        VID_XRECHNUNG_EXTENSION_UBL_INVOICE_301.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }
    }

    // v3.0.2 (based on rule release 2.1.0)
    // Uses CEN rules 1.3.12
    {
      final IValidationExecutorSet <IValidationSourceXML> aVESCII1312 = aRegistry.getOfID (EN16931Validation.VID_CII_1312);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLCreditNote1312 = aRegistry.getOfID (EN16931Validation.VID_UBL_CREDIT_NOTE_1312);
      final IValidationExecutorSet <IValidationSourceXML> aVESUBLInvoice1312 = aRegistry.getOfID (EN16931Validation.VID_UBL_INVOICE_1312);

      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("CII-SR-452", CustomErrorDetails.of (EErrorLevel.ERROR));
        aCustomErrorLevels.put ("CII-SR-453", CustomErrorDetails.of (EErrorLevel.ERROR));
        aCustomErrorLevels.put ("CII-SR-454", CustomErrorDetails.of (EErrorLevel.ERROR));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESCII1312,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                      "3.0.2/XRechnung-CII-validation.xslt",
                                                                                      _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_CII_302,
                                                                               "XRechnung CII " +
                                                                                                      VID_XRECHNUNG_CII_302.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-11", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-10", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-24", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-25", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-26", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("CII-SR-452", CustomErrorDetails.of (EErrorLevel.ERROR));
        aCustomErrorLevels.put ("CII-SR-453", CustomErrorDetails.of (EErrorLevel.ERROR));
        aCustomErrorLevels.put ("CII-SR-454", CustomErrorDetails.of (EErrorLevel.ERROR));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESCII1312,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesCIIHelper.createXSLT_CII_D16B (new ClassPathResource (sPrefix +
                                                                                      "3.0.2/XRechnung-CII-validation.xslt",
                                                                                      _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_EXTENSION_CII_302,
                                                                               "XRechnung Extension CII " +
                                                                                                                VID_XRECHNUNG_EXTENSION_CII_302.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }

      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLCreditNote1312,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "3.0.2/XRechnung-UBL-validation.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_CREDITNOTE_302,
                                                                               "XRechnung UBL Credit Note " +
                                                                                                                 VID_XRECHNUNG_UBL_CREDITNOTE_302.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }

      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.WARN));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLInvoice1312,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "3.0.2/XRechnung-UBL-validation.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_UBL_INVOICE_302,
                                                                               "XRechnung UBL Invoice " +
                                                                                                              VID_XRECHNUNG_UBL_INVOICE_302.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }
      {
        final ICommonsMap <String, CustomErrorDetails> aCustomErrorLevels = new CommonsHashMap <> ();
        aCustomErrorLevels.put ("BR-CL-21", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-23", CustomErrorDetails.of (EErrorLevel.WARN));
        aCustomErrorLevels.put ("BR-CL-24", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-10", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-11", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-25", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CL-26", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("BR-CO-16", CustomErrorDetails.of (EErrorLevel.INFO));
        aCustomErrorLevels.put ("UBL-CR-470", CustomErrorDetails.of (EErrorLevel.INFO));

        final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = _getListWithCustomErrorDetails (aVESUBLInvoice1312,
                                                                                                                   aCustomErrorLevels);
        aNewList.add (PhiveRulesUBLHelper.createXSLT_UBL21 (new ClassPathResource (sPrefix +
                                                                                   "3.0.2/XRechnung-UBL-validation.xslt",
                                                                                   _getCL ())));

        aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_XRECHNUNG_EXTENSION_UBL_INVOICE_302,
                                                                               "XRechnung Extension UBL Invoice " +
                                                                                                                        VID_XRECHNUNG_EXTENSION_UBL_INVOICE_302.getVersionString (),
                                                                               PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                               aNewList));
      }
    }
  }
}
