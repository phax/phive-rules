/*
 * Copyright (C) 2018-2024 Philip Helger (www.helger.com)
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
package com.helger.phive.ublbe;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.rules.api.PhiveRulesUBLHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.ubl21.UBL21Marshaller;

/**
 * Generic e-FFF/UBL.BE validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class UBLBEValidation
{
  public static final String GROUPID_UBL_BE = "be.ubl";
  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_CREDIT_NOTE_100 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                    "credit-note",
                                                                                                    "1.0.0");
  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_INVOICE_100 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                "invoice",
                                                                                                "1.0.0");

  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_CREDIT_NOTE_110 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                    "credit-note",
                                                                                                    "1.1.0");
  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_INVOICE_110 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                "invoice",
                                                                                                "1.1.0");

  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_CREDIT_NOTE_120 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                    "credit-note",
                                                                                                    "1.2.0");
  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_INVOICE_120 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                "invoice",
                                                                                                "1.2.0");

  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_CREDIT_NOTE_123 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                    "credit-note",
                                                                                                    "1.2.3");
  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_INVOICE_123 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                "invoice",
                                                                                                "1.2.3");

  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_CREDIT_NOTE_125 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                    "credit-note",
                                                                                                    "1.2.5");
  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_INVOICE_125 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                "invoice",
                                                                                                "1.2.5");

  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_CREDIT_NOTE_126 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                    "credit-note",
                                                                                                    "1.2.6");
  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_INVOICE_126 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                "invoice",
                                                                                                "1.2.6");

  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_CREDIT_NOTE_127 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                    "credit-note",
                                                                                                    "1.2.7");
  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_INVOICE_127 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                "invoice",
                                                                                                "1.2.7");

  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_CREDIT_NOTE_128 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                    "credit-note",
                                                                                                    "1.2.8");
  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_INVOICE_128 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                "invoice",
                                                                                                "1.2.8");

  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_CREDIT_NOTE_129 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                    "credit-note",
                                                                                                    "1.2.9");
  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_INVOICE_129 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                "invoice",
                                                                                                "1.2.9");

  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_CREDIT_NOTE_130 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                    "credit-note",
                                                                                                    "1.30");
  @Deprecated
  public static final DVRCoordinate VID_UBL_BE_INVOICE_130 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                "invoice",
                                                                                                "1.30");

  public static final DVRCoordinate VID_UBL_BE_CREDIT_NOTE_131 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                    "credit-note",
                                                                                                    "1.31");
  public static final DVRCoordinate VID_UBL_BE_INVOICE_131 = PhiveRulesHelper.createCoordinate (GROUPID_UBL_BE,
                                                                                                "invoice",
                                                                                                "1.31");

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return UBLBEValidation.class.getClassLoader ();
  }

  private UBLBEValidation ()
  {}

  /**
   * Register all standard e-FFF/UBL.BE validation execution sets to the
   * provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initUBLBE (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    final String BASE_PATH = "/external/schematron/ublbe/";

    // v1.0.0
    {
      final IReadableResource UBL_BE_100 = new ClassPathResource (BASE_PATH + "en16931/v1/GLOBALUBL.BE.xslt",
                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_INVOICE_100,
                                                                             "UBL.BE Invoice " +
                                                                                                     VID_UBL_BE_INVOICE_100.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_100)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_CREDIT_NOTE_100,
                                                                             "UBL.BE Credit Note " +
                                                                                                         VID_UBL_BE_CREDIT_NOTE_100.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_100)));
    }

    // v1.1.0
    {
      final IReadableResource UBL_BE_110 = new ClassPathResource (BASE_PATH + "en16931/v1.1/GLOBALUBL.BE-201911.xslt",
                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_INVOICE_110,
                                                                             "UBL.BE Invoice " +
                                                                                                     VID_UBL_BE_INVOICE_110.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_110)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_CREDIT_NOTE_110,
                                                                             "UBL.BE Credit Note " +
                                                                                                         VID_UBL_BE_CREDIT_NOTE_110.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_110)));
    }

    // v1.2.0
    {
      final IReadableResource UBL_BE_120 = new ClassPathResource (BASE_PATH + "en16931/v1.2/GLOBALUBL.BE.xslt",
                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_INVOICE_120,
                                                                             "UBL.BE Invoice " +
                                                                                                     VID_UBL_BE_INVOICE_120.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_120)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_CREDIT_NOTE_120,
                                                                             "UBL.BE Credit Note " +
                                                                                                         VID_UBL_BE_CREDIT_NOTE_120.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_120)));
    }

    // v1.2.3
    {
      final IReadableResource UBL_BE_123 = new ClassPathResource (BASE_PATH + "en16931/v1.2.3/GLOBALUBL.BE.xslt",
                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_INVOICE_123,
                                                                             "UBL.BE Invoice " +
                                                                                                     VID_UBL_BE_INVOICE_123.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_123)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_CREDIT_NOTE_123,
                                                                             "UBL.BE Credit Note " +
                                                                                                         VID_UBL_BE_CREDIT_NOTE_123.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_123)));
    }

    // v1.2.5
    {
      final IReadableResource UBL_BE_125 = new ClassPathResource (BASE_PATH + "en16931/v1.2.5/GLOBALUBL.BE.xslt",
                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_INVOICE_125,
                                                                             "UBL.BE Invoice " +
                                                                                                     VID_UBL_BE_INVOICE_125.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_125)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_CREDIT_NOTE_125,
                                                                             "UBL.BE Credit Note " +
                                                                                                         VID_UBL_BE_CREDIT_NOTE_125.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_125)));
    }

    // v1.2.6
    {
      final IReadableResource UBL_BE_126 = new ClassPathResource (BASE_PATH + "en16931/v1.2.6/GLOBALUBL.BE.xslt",
                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_INVOICE_126,
                                                                             "UBL.BE Invoice " +
                                                                                                     VID_UBL_BE_INVOICE_126.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_126)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_CREDIT_NOTE_126,
                                                                             "UBL.BE Credit Note " +
                                                                                                         VID_UBL_BE_CREDIT_NOTE_126.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_126)));
    }

    // v1.2.7
    {
      final IReadableResource UBL_BE_127 = new ClassPathResource (BASE_PATH + "en16931/v1.2.7/GLOBALUBL.BE.xslt",
                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_INVOICE_127,
                                                                             "UBL.BE Invoice " +
                                                                                                     VID_UBL_BE_INVOICE_127.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_127)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_CREDIT_NOTE_127,
                                                                             "UBL.BE Credit Note " +
                                                                                                         VID_UBL_BE_CREDIT_NOTE_127.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_127)));
    }

    // v1.2.8
    {
      final IReadableResource UBL_BE_128 = new ClassPathResource (BASE_PATH + "en16931/v1.2.8/GLOBALUBL.BE.xslt",
                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_INVOICE_128,
                                                                             "UBL.BE Invoice " +
                                                                                                     VID_UBL_BE_INVOICE_128.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_128)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_CREDIT_NOTE_128,
                                                                             "UBL.BE Credit Note " +
                                                                                                         VID_UBL_BE_CREDIT_NOTE_128.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_128)));
    }

    // v1.2.9
    {
      final IReadableResource UBL_BE_129 = new ClassPathResource (BASE_PATH + "en16931/v1.2.9/GLOBALUBL.BE.xslt",
                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_INVOICE_129,
                                                                             "UBL.BE Invoice " +
                                                                                                     VID_UBL_BE_INVOICE_129.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_129)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_CREDIT_NOTE_129,
                                                                             "UBL.BE Credit Note " +
                                                                                                         VID_UBL_BE_CREDIT_NOTE_129.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_129)));
    }

    // v1.30
    {
      final IReadableResource UBL_BE_130 = new ClassPathResource (BASE_PATH + "en16931/v1.30/GLOBALUBL.BE.xslt",
                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_INVOICE_130,
                                                                             "UBL.BE Invoice " +
                                                                                                     VID_UBL_BE_INVOICE_130.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_130)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_CREDIT_NOTE_130,
                                                                             "UBL.BE Credit Note " +
                                                                                                         VID_UBL_BE_CREDIT_NOTE_130.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_130)));
    }

    // v1.31
    {
      final IReadableResource UBL_BE_131 = new ClassPathResource (BASE_PATH + "en16931/v1.31/GLOBALUBL.BE.xslt",
                                                                  _getCL ());
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_INVOICE_131,
                                                                             "UBL.BE Invoice " +
                                                                                                     VID_UBL_BE_INVOICE_131.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_131)));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_UBL_BE_CREDIT_NOTE_131,
                                                                             "UBL.BE Credit Note " +
                                                                                                         VID_UBL_BE_CREDIT_NOTE_131.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllCreditNoteXSDs ()),
                                                                             PhiveRulesUBLHelper.createXSLT_UBL21 (UBL_BE_131)));
    }
  }
}
