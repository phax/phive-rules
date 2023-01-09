/*
 * Copyright (C) 2014-2023 Philip Helger (www.helger.com)
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
package com.helger.phive.simplerinvoicing;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.Locale;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.phive.api.execute.ValidationExecutionManager;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.result.ValidationResultList;
import com.helger.phive.engine.mock.MockFile;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.engine.source.ValidationSourceXML;
import com.helger.phive.simplerinvoicing.mock.CTestFiles;

/**
 * Test class for class {@link ValidationExecutionManager}.
 *
 * @author Philip Helger
 */
public final class ValidationExecutionManagerFuncTest
{
  private static final Logger LOGGER = LoggerFactory.getLogger (ValidationExecutionManagerFuncTest.class);

  @Test
  public void testAllGoodCases ()
  {
    for (final MockFile aTestFile : CTestFiles.getAllTestFiles ())
      if (aTestFile.isGoodCase ())
      {
        final IValidationExecutorSet <IValidationSourceXML> aExecutors = CTestFiles.VES_REGISTRY.getOfID (aTestFile.getVESID ());
        assertNotNull (aExecutors);

        LOGGER.info ("Validating " +
                     aTestFile.getResource ().getPath () +
                     " against " +
                     aExecutors.executors ().size () +
                     " validation layers using " +
                     aTestFile.getVESID ().getAsSingleID () +
                     " - expecting success");

        // Read as desired type
        final IValidationSourceXML aSource = ValidationSourceXML.create (aTestFile.getResource ());
        final ValidationResultList aValidationResultList = ValidationExecutionManager.executeValidation (aExecutors, aSource, Locale.US);
        aValidationResultList.getAllErrors ().forEach (x -> LOGGER.info ("  " + x.getErrorLevel () + " " + x.getAsString (Locale.US)));
        assertTrue (aValidationResultList.getAllErrors ().toString (), aValidationResultList.containsNoError ());
      }
  }

  @Test
  public void testAllBadCases ()
  {
    for (final MockFile aTestFile : CTestFiles.getAllTestFiles ())
      if (aTestFile.isBadCase ())
      {
        final IValidationExecutorSet <IValidationSourceXML> aExecutors = CTestFiles.VES_REGISTRY.getOfID (aTestFile.getVESID ());
        assertNotNull (aExecutors);

        LOGGER.info ("Validating " +
                     aTestFile.getResource ().getPath () +
                     " against " +
                     aExecutors.executors ().size () +
                     " validation layers using " +
                     aTestFile.getVESID ().getAsSingleID () +
                     " - expecting error");

        // Read as desired type
        final IValidationSourceXML aSource = ValidationSourceXML.create (aTestFile.getResource ());
        final ValidationResultList aValidationResultList = ValidationExecutionManager.executeValidation (aExecutors, aSource, Locale.US);
        aValidationResultList.getAllFailures ().forEach (x -> LOGGER.info ("  " + x.getErrorLevel () + " " + x.getAsString (Locale.US)));
        assertTrue (aValidationResultList.containsAtLeastOneError ());
      }
  }
}
