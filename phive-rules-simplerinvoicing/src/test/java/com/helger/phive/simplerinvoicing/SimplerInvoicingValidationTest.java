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
package com.helger.phive.simplerinvoicing;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executor.IValidationExecutor;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.rules.shared.DVRHelper;
import com.helger.phive.simplerinvoicing.mock.CTestFiles;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Test class for class {@link SimplerInvoicingValidation}.
 *
 * @author Philip Helger
 */
public final class SimplerInvoicingValidationTest
{
  @Test
  public void testFilesExist ()
  {
    for (final IValidationExecutorSet <IValidationSourceXML> aVES : CTestFiles.VES_REGISTRY.getAll ())
      for (final IValidationExecutor <IValidationSourceXML> aVE : aVES)
      {
        final IReadableResource aRes = aVE.getValidationArtefact ().getRuleResource ();
        assertTrue (aRes.toString (), aRes.exists ());
      }
  }

  @Test
  public void testSchematronsValid ()
  {
    for (final IValidationExecutorSet <IValidationSourceXML> aVES : CTestFiles.VES_REGISTRY.getAll ())
      for (final IValidationExecutor <IValidationSourceXML> aVE : aVES)
        assertTrue (com.helger.phive.rules.shared.PhiveRulesTestHelper.isContentCorrect (aVE));
  }

  private static void _testLatest (@NonNull final String sArtifactID, @NonNull final String sExpectedVersion)
  {
    for (final String sPseudoVersion : new String [] { "latest", "latest-release" })
    {
      final DVRCoordinate aVESID = DVRHelper.createCoordinate (SimplerInvoicingValidation.GROUP_ID,
                                                               sArtifactID,
                                                               sPseudoVersion);
      final IValidationExecutorSet <IValidationSourceXML> aVES = CTestFiles.VES_REGISTRY.getOfID (aVESID);
      assertNotNull (aVESID.getAsSingleID (), aVES);
      assertEquals (aVESID.getAsSingleID (), sExpectedVersion, aVES.getID ().getVersionString ());
    }
  }

  @Test
  public void testLatestVersionResolution ()
  {
    // The numeric version classifiers are compared as Strings, hence they must
    // be zero padded to be comparable - see
    // https://github.com/phax/phive-rules/issues/80
    _testLatest ("invoice", "2.0.3-13");
    _testLatest ("creditnote", "2.0.3-13");
    _testLatest ("nlcius-cii", "1.0.3-13");
    _testLatest ("invoice20.g-account", "1.0.13");
  }
}
