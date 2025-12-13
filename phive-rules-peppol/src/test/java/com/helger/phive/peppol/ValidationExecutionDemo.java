/*
 * Copyright (C) 2014-2025 Philip Helger (www.helger.com)
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
import org.jspecify.annotations.Nullable;
import org.w3c.dom.Document;

import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.execute.ValidationExecutionManager;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.result.ValidationResultList;
import com.helger.phive.api.validity.IValidityDeterminator;
import com.helger.phive.peppol.mock.CTestFiles;
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
  public void testCode (@Nullable final String sSystemID, @NonNull final byte [] aXML)
  {
    // Example: validate against orders
    final DVRCoordinate aVESID = PeppolValidation2025_11.VID_OPENPEPPOL_INVOICE_UBL_V3;

    // Note: Use the currently active version
    final IValidationExecutorSet <IValidationSourceXML> aExecutors = CTestFiles.VES_REGISTRY.getOfID (aVESID);

    // Parse the XML document to be validated
    final Document aXMLDoc = DOMReader.readXMLDOM (aXML);

    // Build object to be validated (with some metadata)
    final IValidationSourceXML aSource = ValidationSourceXML.create (sSystemID, aXMLDoc);

    // Perform the execution
    final ValidationResultList aErrors = ValidationExecutionManager.executeValidation (IValidityDeterminator.createDefault (),
                                                                                       aExecutors,
                                                                                       aSource);
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
