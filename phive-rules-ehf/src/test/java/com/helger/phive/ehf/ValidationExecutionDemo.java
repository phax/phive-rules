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
package com.helger.phive.ehf;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;

import org.w3c.dom.Document;

import com.helger.diver.api.version.VESID;
import com.helger.phive.api.execute.ValidationExecutionManager;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.result.ValidationResultList;
import com.helger.phive.ehf.mock.CTestFiles;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.source.ValidationSourceXML;
import com.helger.xml.serialize.read.DOMReader;

/**
 * Demo code for validating against order rules
 *
 * @author Philip Helger
 */
public final class ValidationExecutionDemo
{
  public void testCode (@Nullable final String sSystemID, @Nonnull final byte [] aXML)
  {
    // Example: validate against orders
    final VESID aVESID = EHFValidationG2.VID_EHF_INVOICE_2_0_17;

    // Note: Use the currently active version
    final IValidationExecutorSet <IValidationSourceXML> aExecutors = CTestFiles.VES_REGISTRY.getOfID (aVESID);

    // Parse the XML document to be validated
    final Document aXMLDoc = DOMReader.readXMLDOM (aXML);

    // Build object to be validated (with some metadata)
    final IValidationSourceXML aSource = ValidationSourceXML.create (sSystemID, aXMLDoc);

    // Perform the execution
    final ValidationResultList aErrors = ValidationExecutionManager.executeValidation (aExecutors, aSource);
    if (aErrors.containsNoError ())
    {
      // TODO success
    }
    else
    {
      // TODO interpret errors
    }
  }
}
