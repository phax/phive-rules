/*
 * Copyright (C) 2024-2026 Philip Helger (www.helger.com)
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
package com.helger.phive.zugferd;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.time.Month;
import java.time.OffsetDateTime;

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;
import org.junit.Test;

import com.helger.datetime.helper.PDTFactory;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.diver.api.version.DVRVersionException;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executor.IValidationExecutor;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.ValidationExecutorSetAlias;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.zugferd.mock.CTestFiles;

/**
 * Test class for class {@link ZugferdValidation}.
 *
 * @author Philip Helger
 */
public final class ZugferdValidationTest
{
  private static final OffsetDateTime DT_BEFORE_2_5_2 = PDTFactory.createOffsetDateTimeUTC (2026, Month.AUGUST, 31);
  private static final OffsetDateTime DT_AFTER_2_5_2 = PDTFactory.createOffsetDateTimeUTC (2026, Month.SEPTEMBER, 2);

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

  @NonNull
  private static IValidationExecutorSet <IValidationSourceXML> _resolve (@NonNull final String sGroupID,
                                                                        @NonNull final EZugferdProfile eProfile,
                                                                        @NonNull final String sVersion,
                                                                        @Nullable final OffsetDateTime aCheckDT) throws DVRVersionException
  {
    final DVRCoordinate aCoord = DVRCoordinate.create (sGroupID, eProfile.getArtifactID (), sVersion);
    final IValidationExecutorSet <IValidationSourceXML> ret = CTestFiles.VES_REGISTRY.getOfID (aCoord, aCheckDT);
    assertNotNull ("Failed to resolve '" + aCoord.getAsSingleID () + "'", ret);
    return ret;
  }

  /**
   * Resolve a Factur-X VES ID - all Factur-X VES are registered as aliases only.
   *
   * @param eProfile
   *        Profile to use
   * @param sVersion
   *        Version or pseudo version to resolve
   * @param aCheckDT
   *        Check date time for the "active" pseudo versions. May be <code>null</code>.
   * @return The resolved alias. Never <code>null</code>.
   * @throws DVRVersionException
   *         on error
   */
  @NonNull
  private static ValidationExecutorSetAlias <IValidationSourceXML> _resolveFacturX (@NonNull final EZugferdProfile eProfile,
                                                                                    @NonNull final String sVersion,
                                                                                    @Nullable final OffsetDateTime aCheckDT) throws DVRVersionException
  {
    final IValidationExecutorSet <IValidationSourceXML> aVES = _resolve (ZugferdValidation.GROUP_ID_FACTUR_X,
                                                                        eProfile,
                                                                        sVersion,
                                                                        aCheckDT);
    assertTrue (aVES instanceof ValidationExecutorSetAlias);
    return (ValidationExecutorSetAlias <IValidationSourceXML>) aVES;
  }

  @Test
  public void testFacturXAliasesArePresent ()
  {
    for (final IValidationExecutorSet <IValidationSourceXML> aVES : CTestFiles.VES_REGISTRY.getAll ())
    {
      final DVRCoordinate aZugferdVESID = aVES.getID ();
      if (!ZugferdValidation.GROUP_ID_ZUGFERD.equals (aZugferdVESID.getGroupID ()))
        continue;

      // Every ZUGFeRD VES must have a Factur-X alias pointing to it
      final DVRCoordinate aFacturXVESID = ZugferdValidation.getMappedFacturXVESID (aZugferdVESID);
      assertNotNull (aFacturXVESID);

      final IValidationExecutorSet <IValidationSourceXML> aAlias = CTestFiles.VES_REGISTRY.getOfID (aFacturXVESID);
      assertNotNull (aFacturXVESID.getAsSingleID (), aAlias);
      assertTrue (aAlias instanceof ValidationExecutorSetAlias);
      assertEquals (aZugferdVESID,
                    ((ValidationExecutorSetAlias <IValidationSourceXML>) aAlias).getSourceVES ().getID ());
    }
  }

  @Test
  public void testFacturXAliasPseudoVersionOldest () throws Exception
  {
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      final ValidationExecutorSetAlias <IValidationSourceXML> aAlias = _resolveFacturX (eProfile, "oldest", null);
      assertEquals ("1.0.3", aAlias.getID ().getVersionString ());
      assertEquals ("2.0.1", aAlias.getSourceVES ().getID ().getVersionString ());
    }
  }

  @Test
  public void testFacturXAliasPseudoVersionLatest () throws Exception
  {
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      final ValidationExecutorSetAlias <IValidationSourceXML> aAlias = _resolveFacturX (eProfile, "latest", null);
      assertEquals ("1.0.9-2", aAlias.getID ().getVersionString ());
      assertEquals ("2.5.2", aAlias.getSourceVES ().getID ().getVersionString ());

      // Must be the same as resolving the ZUGFeRD side
      final IValidationExecutorSet <IValidationSourceXML> aZugferd = _resolve (ZugferdValidation.GROUP_ID_ZUGFERD,
                                                                              eProfile,
                                                                              "latest",
                                                                              null);
      assertEquals ("2.5.2", aZugferd.getID ().getVersionString ());
      assertEquals (aZugferd, aAlias.getSourceVES ());
    }
  }

  @Test
  public void testFacturXAliasPseudoVersionLatestRelease () throws Exception
  {
    // No Snapshot versions are registered, so this is the same as "latest"
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
      assertEquals ("1.0.9-2", _resolveFacturX (eProfile, "latest-release", null).getID ().getVersionString ());
  }

  @Test
  public void testFacturXAliasPseudoVersionLatestActive () throws Exception
  {
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      // Factur-X 1.0.9-2 (ZUGFeRD 2.5.2) is valid from 2026-09-01 onwards only
      assertEquals ("1.0.9", _resolveFacturX (eProfile, "latest-active", DT_BEFORE_2_5_2).getID ()
                                                                                        .getVersionString ());
      assertEquals ("1.0.9-2",
                    _resolveFacturX (eProfile, "latest-active", DT_AFTER_2_5_2).getID ().getVersionString ());

      // Same behaviour on the ZUGFeRD side
      assertEquals ("2.5",
                    _resolve (ZugferdValidation.GROUP_ID_ZUGFERD, eProfile, "latest-active", DT_BEFORE_2_5_2).getID ()
                                                                                                             .getVersionString ());
      assertEquals ("2.5.2",
                    _resolve (ZugferdValidation.GROUP_ID_ZUGFERD, eProfile, "latest-active", DT_AFTER_2_5_2).getID ()
                                                                                                            .getVersionString ());
    }
  }

  @Test
  public void testFacturXAliasPseudoVersionLatestReleaseActive () throws Exception
  {
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      assertEquals ("1.0.9",
                    _resolveFacturX (eProfile, "latest-release-active", DT_BEFORE_2_5_2).getID ()
                                                                                        .getVersionString ());
      assertEquals ("1.0.9-2",
                    _resolveFacturX (eProfile, "latest-release-active", DT_AFTER_2_5_2).getID ()
                                                                                       .getVersionString ());
    }
  }

  @Test
  public void testFacturXAliasPseudoVersionUsesSourceExecutors () throws Exception
  {
    for (final EZugferdProfile eProfile : EZugferdProfile.values ())
    {
      final ValidationExecutorSetAlias <IValidationSourceXML> aAlias = _resolveFacturX (eProfile, "latest", null);
      final IValidationExecutorSet <IValidationSourceXML> aZugferd = _resolve (ZugferdValidation.GROUP_ID_ZUGFERD,
                                                                              eProfile,
                                                                              "latest",
                                                                              null);
      assertEquals (aZugferd.getAllExecutors (), aAlias.getAllExecutors ());
      assertEquals (aZugferd.getStatus (), aAlias.getStatus ());
    }
  }
}
