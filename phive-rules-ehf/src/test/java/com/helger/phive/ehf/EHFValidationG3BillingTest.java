/*
 * Copyright (C) 2018-2026 Philip Helger (www.helger.com)
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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertSame;
import static org.junit.Assert.assertTrue;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetAlias;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.ehf.mock.CTestFiles;
import com.helger.phive.peppol.PeppolValidation2025_11;
import com.helger.phive.peppol.PeppolValidation2026_05;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Test class for class {@link EHFValidationG3Billing}.
 *
 * @author Philip Helger
 */
public final class EHFValidationG3BillingTest
{
  private static void _assertAlias (@NonNull final DVRCoordinate aSourceVESID)
  {
    final DVRCoordinate aAliasVESID = aSourceVESID.getWithGroupID (EHFValidationG3Billing.GROUP_ID);
    final IValidationExecutorSet <IValidationSourceXML> aAlias = CTestFiles.VES_REGISTRY.getOfID (aAliasVESID);
    assertNotNull (aAliasVESID.getAsSingleID (), aAlias);
    assertTrue (aAlias instanceof IValidationExecutorSetAlias);
    assertEquals (aAliasVESID, aAlias.getID ());

    final IValidationExecutorSet <IValidationSourceXML> aSource = CTestFiles.VES_REGISTRY.getOfID (aSourceVESID);
    assertNotNull (aSourceVESID.getAsSingleID (), aSource);
    assertSame (aSource, ((IValidationExecutorSetAlias <IValidationSourceXML>) aAlias).getSourceVES ());
    assertEquals (aSource.getAllExecutors (), aAlias.getAllExecutors ());
    assertSame (aSource.getStatus (), aAlias.getStatus ());
  }

  @Test
  public void testKnownAliasesArePresent ()
  {
    _assertAlias (PeppolValidation2025_11.VID_OPENPEPPOL_INVOICE_UBL_V3);
    _assertAlias (PeppolValidation2025_11.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3);
    _assertAlias (PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_UBL_V3);
    _assertAlias (PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3);
  }

  @Test
  public void testAllPeppolBillingVersionsAreAliased ()
  {
    int nCount = 0;
    for (final IValidationExecutorSet <IValidationSourceXML> aVES : CTestFiles.VES_REGISTRY.getAll ())
    {
      final DVRCoordinate aVESID = aVES.getID ();
      if (aVESID.getGroupID ().equals (PeppolValidation2026_05.GROUP_ID) &&
          (aVESID.getArtifactID ().equals (EHFValidationG3Billing.ARTIFACT_ID_INVOICE) ||
           aVESID.getArtifactID ().equals (EHFValidationG3Billing.ARTIFACT_ID_CREDIT_NOTE)))
      {
        _assertAlias (aVESID);
        nCount++;
      }
    }
    assertTrue (nCount > 0);
  }

  @Test
  public void testPseudoVersionLatest () throws Exception
  {
    final IValidationExecutorSet <IValidationSourceXML> aAlias = CTestFiles.VES_REGISTRY.getOfID (DVRCoordinate.create (EHFValidationG3Billing.GROUP_ID,
                                                                                                                       EHFValidationG3Billing.ARTIFACT_ID_INVOICE,
                                                                                                                       "latest"));
    assertNotNull (aAlias);
    assertEquals (PeppolValidation2026_05.VERSION_STR, aAlias.getID ().getVersionString ());
  }

  @Test
  public void testPrerequisites ()
  {
    for (final DVRCoordinate aVESID : EHFValidation.getAllPrerequisites ())
      assertNotNull (aVESID.getAsSingleID (), CTestFiles.VES_REGISTRY.getOfID (aVESID));
  }

  @Test (expected = IllegalStateException.class)
  public void testNoPeppolRegistered ()
  {
    EHFValidationG3Billing.initEHF (new ValidationExecutorSetRegistry <> ());
  }
}
