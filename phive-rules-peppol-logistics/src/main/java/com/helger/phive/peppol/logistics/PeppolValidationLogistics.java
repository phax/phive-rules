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
package com.helger.phive.peppol.logistics;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.rules.shared.DVRHelper;
import com.helger.phive.rules.shared.PhiveRulesUBLHelper;
import com.helger.phive.xml.executorset.VesXmlBuilder;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl23.UBL23Marshaller;
import com.helger.ubl24.UBL24Marshaller;

/**
 * Peppol Logistics validation configuration. See https://docs.peppol.eu/logistics/<br>
 * The VES versions are the versions of the single transactions, and not the version of the overall
 * Peppol Logistics release.
 *
 * @author Philip Helger
 * @since 4.6.4
 */
@Immutable
public final class PeppolValidationLogistics
{
  public static final String GROUP_ID = "org.peppol.logistics";

  // Release 1.3.1
  public static final DVRCoordinate VID_PEPPOL_LOGISTICS_ADVANCED_DESPATCH_ADVICE_1_4 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                                    "advanced-despatch-advice",
                                                                                                                    "1.4");
  public static final DVRCoordinate VID_PEPPOL_LOGISTICS_WEIGHT_STATEMENT_1_3 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                            "weight-statement",
                                                                                                            "1.3");
  public static final DVRCoordinate VID_PEPPOL_LOGISTICS_TRANSPORT_EXECUTION_PLAN_REQUEST_1_2 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                                            "transport-execution-plan-request",
                                                                                                                            "1.2");
  public static final DVRCoordinate VID_PEPPOL_LOGISTICS_TRANSPORT_EXECUTION_PLAN_1_2 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                                    "transport-execution-plan",
                                                                                                                    "1.2");
  public static final DVRCoordinate VID_PEPPOL_LOGISTICS_WAYBILL_1_1 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                   "waybill",
                                                                                                   "1.1");
  public static final DVRCoordinate VID_PEPPOL_LOGISTICS_TRANSPORTATION_STATUS_REQUEST_1_2 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                                         "transportation-status-request",
                                                                                                                         "1.2");
  public static final DVRCoordinate VID_PEPPOL_LOGISTICS_TRANSPORTATION_STATUS_1_2 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                                 "transportation-status",
                                                                                                                 "1.2");
  public static final DVRCoordinate VID_PEPPOL_LOGISTICS_RECEIPT_ADVICE_1_1 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                          "receipt-advice",
                                                                                                          "1.1");
  public static final DVRCoordinate VID_PEPPOL_LOGISTICS_APPLICATION_RESPONSE_1_0 = DVRHelper.createCoordinate (GROUP_ID,
                                                                                                                "application-response",
                                                                                                                "1.0");

  private PeppolValidationLogistics ()
  {}

  @NonNull
  private static ClassLoader _getCL ()
  {
    return PeppolValidationLogistics.class.getClassLoader ();
  }

  public static void init (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // Release 1.3.1
    {
      final String sPrefixXslt = "external/schematron/logistics/1.3.1/xslt/";
      final String sAkaVersion = " (aka Peppol Logistics 1.3.1)";

      final IReadableResource ADVANCED_DESPATCH_ADVICE = new ClassPathResource (sPrefixXslt + "PEPPOLBIS-T120.xslt",
                                                                                _getCL ());
      final IReadableResource WEIGHT_STATEMENT = new ClassPathResource (sPrefixXslt + "PEPPOLBIS-T122.xslt", _getCL ());
      final IReadableResource TRANSPORT_EXECUTION_PLAN_REQUEST = new ClassPathResource (sPrefixXslt +
                                                                                        "PEPPOLBIS-T123.xslt",
                                                                                        _getCL ());
      final IReadableResource TRANSPORT_EXECUTION_PLAN = new ClassPathResource (sPrefixXslt + "PEPPOLBIS-T124.xslt",
                                                                                _getCL ());
      final IReadableResource WAYBILL = new ClassPathResource (sPrefixXslt + "PEPPOLBIS-T125.xslt", _getCL ());
      final IReadableResource TRANSPORTATION_STATUS_REQUEST = new ClassPathResource (sPrefixXslt +
                                                                                     "PEPPOLBIS-T126.xslt",
                                                                                     _getCL ());
      final IReadableResource TRANSPORTATION_STATUS = new ClassPathResource (sPrefixXslt + "PEPPOLBIS-T127.xslt",
                                                                             _getCL ());
      final IReadableResource RECEIPT_ADVICE = new ClassPathResource (sPrefixXslt + "PEPPOLBIS-T128.xslt", _getCL ());
      final IReadableResource APPLICATION_RESPONSE = new ClassPathResource (sPrefixXslt + "PEPPOLBIS-T129.xslt",
                                                                            _getCL ());

      VesXmlBuilder.builder ()
                   .vesID (VID_PEPPOL_LOGISTICS_ADVANCED_DESPATCH_ADVICE_1_4)
                   .displayName ("Peppol Logistics Advanced Despatch Advice 1.4 (T120)" + sAkaVersion)
                   .notDeprecated ()
                   .addXSD (UBL21Marshaller.getAllDespatchAdviceXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (ADVANCED_DESPATCH_ADVICE))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_PEPPOL_LOGISTICS_WEIGHT_STATEMENT_1_3)
                   .displayName ("Peppol Logistics Weight Statement 1.3 (T122)" + sAkaVersion)
                   .notDeprecated ()
                   .addXSD (UBL23Marshaller.getAllWeightStatementXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL23 (WEIGHT_STATEMENT))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_PEPPOL_LOGISTICS_TRANSPORT_EXECUTION_PLAN_REQUEST_1_2)
                   .displayName ("Peppol Logistics Transport Execution Plan Request 1.2 (T123)" + sAkaVersion)
                   .notDeprecated ()
                   .addXSD (UBL24Marshaller.getAllTransportExecutionPlanRequestXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL24 (TRANSPORT_EXECUTION_PLAN_REQUEST))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_PEPPOL_LOGISTICS_TRANSPORT_EXECUTION_PLAN_1_2)
                   .displayName ("Peppol Logistics Transport Execution Plan 1.2 (T124)" + sAkaVersion)
                   .notDeprecated ()
                   .addXSD (UBL24Marshaller.getAllTransportExecutionPlanXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL24 (TRANSPORT_EXECUTION_PLAN))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_PEPPOL_LOGISTICS_WAYBILL_1_1)
                   .displayName ("Peppol Logistics Waybill 1.1 (T125)" + sAkaVersion)
                   .notDeprecated ()
                   .addXSD (UBL23Marshaller.getAllWaybillXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL23 (WAYBILL))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_PEPPOL_LOGISTICS_TRANSPORTATION_STATUS_REQUEST_1_2)
                   .displayName ("Peppol Logistics Transportation Status Request 1.2 (T126)" + sAkaVersion)
                   .notDeprecated ()
                   .addXSD (UBL23Marshaller.getAllTransportationStatusRequestXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL23 (TRANSPORTATION_STATUS_REQUEST))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_PEPPOL_LOGISTICS_TRANSPORTATION_STATUS_1_2)
                   .displayName ("Peppol Logistics Transportation Status 1.2 (T127)" + sAkaVersion)
                   .notDeprecated ()
                   .addXSD (UBL23Marshaller.getAllTransportationStatusXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL23 (TRANSPORTATION_STATUS))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_PEPPOL_LOGISTICS_RECEIPT_ADVICE_1_1)
                   .displayName ("Peppol Logistics Receipt Advice 1.1 (T128)" + sAkaVersion)
                   .notDeprecated ()
                   .addXSD (UBL23Marshaller.getAllReceiptAdviceXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL23 (RECEIPT_ADVICE))
                   .registerInto (aRegistry);
      VesXmlBuilder.builder ()
                   .vesID (VID_PEPPOL_LOGISTICS_APPLICATION_RESPONSE_1_0)
                   .displayName ("Peppol Logistics Application Response 1.0 (T129)" + sAkaVersion)
                   .notDeprecated ()
                   .addXSD (UBL21Marshaller.getAllApplicationResponseXSDs ())
                   .addSchematron (PhiveRulesUBLHelper.createXSLT_UBL21 (APPLICATION_RESPONSE))
                   .registerInto (aRegistry);
    }
  }
}
