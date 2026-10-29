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
package com.helger.phive.peppol.logistics.mock;

import static org.junit.Assert.assertTrue;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.FileSystemResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.peppol.logistics.PeppolValidationLogistics;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    PeppolValidationLogistics.init (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aVESID : new DVRCoordinate [] { PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_ADVANCED_DESPATCH_ADVICE_1_4,
                                                             PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_WEIGHT_STATEMENT_1_3,
                                                             PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_TRANSPORT_EXECUTION_PLAN_REQUEST_1_2,
                                                             PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_TRANSPORT_EXECUTION_PLAN_1_2,
                                                             PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_WAYBILL_1_1,
                                                             PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_TRANSPORTATION_STATUS_REQUEST_1_2,
                                                             PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_TRANSPORTATION_STATUS_1_2,
                                                             PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_RECEIPT_ADVICE_1_1,
                                                             PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_APPLICATION_RESPONSE_1_0 })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aVESID))
      {
        assertTrue ("Not existing test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aVESID));
      }
    return ret;
  }

  @NonNull
  @ReturnsMutableCopy
  private static ICommonsList <@NonNull FileSystemResource> _getAll (@NonNull final String sPrefix,
                                                                     @NonNull final String @NonNull... aFilenames)
  {
    final String sPrefix0 = "src/test/resources/external/test-files/";
    final ICommonsList <FileSystemResource> ret = new CommonsArrayList <> (aFilenames.length);
    for (final String s : aFilenames)
      ret.add (new FileSystemResource (sPrefix0 + sPrefix + s));
    return ret;
  }

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@NonNull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    // Release 1.3.1
    if (aVESID.equals (PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_ADVANCED_DESPATCH_ADVICE_1_4))
    {
      return _getAll ("1.3.1/",
                      "AdvancedDespatchAdvice_Example_Full.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_01_Environmental_Data.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_01_Precast_concrete_element.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_01_Wood.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_01.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_02.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_03.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_04_Concrete_pump_service.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_04.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_05.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_06_Concrete_material.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_06.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_07.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_08.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_09.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_10.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_11.xml",
                      "advanced-despatch-advice-use-cases/AdvancedDespatchAdvice__Example_UseCase_12.xml");
    }
    if (aVESID.equals (PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_WEIGHT_STATEMENT_1_3))
    {
      return _getAll ("1.3.1/",
                      "WeightStatement_Example_Full.xml",
                      "weight-statement-use-cases/WeightStatement_Example_1.xml");
    }
    if (aVESID.equals (PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_TRANSPORT_EXECUTION_PLAN_REQUEST_1_2))
    {
      return _getAll ("1.3.1/",
                      "TransportExecutionPlanRequest_Example_Full.xml",
                      "advanced-transport-execution-plan-use-cases/TransportExecutionPlanRequest_Example_UseCase_04.xml",
                      "transport-execution-plan-with-request-use-cases/TransportExecutionPlanRequest_Example_UseCase1.xml",
                      "transport-execution-plan-with-request-use-cases/TransportExecutionPlanRequest_Example_UseCase2.xml",
                      "transport-execution-plan-with-request-use-cases/TransportExecutionPlanRequest_Example_UseCase3.xml");
    }
    if (aVESID.equals (PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_TRANSPORT_EXECUTION_PLAN_1_2))
    {
      return _getAll ("1.3.1/",
                      "TransportExecutionPlan_Example_Full.xml",
                      "advanced-transport-execution-plan-use-cases/TransportExecutionPlan_Example_UseCase_04.xml",
                      "transport-execution-plan-only-use-cases/TransportExecutionPlan_Example_UseCase1.xml",
                      "transport-execution-plan-with-request-use-cases/TransportExecutionPlan_Example_UseCase1.xml",
                      "transport-execution-plan-with-request-use-cases/TransportExecutionPlan_Example_UseCase2.xml",
                      "transport-execution-plan-with-request-use-cases/TransportExecutionPlan_Example_UseCase3.xml");
    }
    if (aVESID.equals (PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_WAYBILL_1_1))
    {
      return _getAll ("1.3.1/", "Waybill_Example_Full.xml", "waybill-use-cases/Waybill_Example_usecase1.xml");
    }
    if (aVESID.equals (PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_TRANSPORTATION_STATUS_REQUEST_1_2))
    {
      return _getAll ("1.3.1/",
                      "TransportationStatusRequest_Example_Full.xml",
                      "advanced-transport-execution-plan-use-cases/TransportationStatusRequest_Example_UseCase_04.xml",
                      "transportation-status-with-request-use-cases/TransportationStatusRequest_Example_usecase1.xml",
                      "transportation-status-with-request-use-cases/TransportationStatusRequest_Example_usecase2.xml",
                      "transportation-status-with-request-use-cases/TransportationStatusRequest_Example_usecase3.xml",
                      "transportation-status-with-request-use-cases/TransportationStatusRequest_Example_usecase4.xml");
    }
    if (aVESID.equals (PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_TRANSPORTATION_STATUS_1_2))
    {
      return _getAll ("1.3.1/",
                      "TransportationStatus_Example_Full.xml",
                      "advanced-transport-execution-plan-use-cases/TransportationStatus_Example_UseCase_04.xml",
                      "transportation-status-only/TransportationStatus_Example_UseCase1.xml",
                      "transportation-status-only/TransportationStatus_Example_UseCase2.xml",
                      "transportation-status-only/TransportationStatus_Example_UseCase3.xml",
                      "transportation-status-with-request-use-cases/TransportationStatus_Example_UseCase1.xml",
                      "transportation-status-with-request-use-cases/TransportationStatus_Example_UseCase2.xml",
                      "transportation-status-with-request-use-cases/TransportationStatus_Example_UseCase3.xml",
                      "transportation-status-with-request-use-cases/TransportationStatus_Example_UseCase4.xml");
    }
    if (aVESID.equals (PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_RECEIPT_ADVICE_1_1))
    {
      return _getAll ("1.3.1/",
                      "ReceiptAdvice_Example_Full.xml",
                      "receipt-advice-use-cases/ReceiptAdvice_Example_UseCase_1.xml",
                      "receipt-advice-use-cases/ReceiptAdvice_Example_UseCase_2.xml",
                      "receipt-advice-use-cases/ReceiptAdvice_Example_UseCase_3.xml",
                      "receipt-advice-use-cases/ReceiptAdvice_Example_UseCase_4.xml",
                      "receipt-advice-use-cases/ReceiptAdvice_Example_UseCase_5.xml",
                      "receipt-advice-use-cases/ReceiptAdvice_Example_UseCase_6.xml",
                      "receipt-advice-use-cases/ReceiptAdvice_Example_UseCase_7.xml",
                      "receipt-advice-use-cases/ReceiptAdvice_Example_UseCase_8.xml",
                      "receipt-advice-use-cases/ReceiptAdvice_Example_UseCase_9.xml");
    }
    if (aVESID.equals (PeppolValidationLogistics.VID_PEPPOL_LOGISTICS_APPLICATION_RESPONSE_1_0))
    {
      return _getAll ("1.3.1/",
                      "ApplicationResponse_Example_Full.xml",
                      "advanced-transport-execution-plan-use-cases/ApplicationResponseAccept_Example_UseCase_04.xml");
    }

    throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
  }
}
