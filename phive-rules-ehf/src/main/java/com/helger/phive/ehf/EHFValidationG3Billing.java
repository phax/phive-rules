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

import org.jspecify.annotations.NonNull;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSetAliasReadOnly;
import com.helger.phive.peppol.PeppolValidation2026_05;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * EHF Billing 3.0 validation configuration.<br>
 * EHF Billing 3.0 is a rebranding of Peppol BIS Billing 3.0, so every non-deprecated Peppol BIS
 * Billing Invoice and Credit Note that is registered is also registered as a read-only alias with
 * the group ID {@value #GROUP_ID}, the same artifact ID and the same version. EHF Self-Billing has
 * its own rules and is therefore not aliased.
 *
 * @author Philip Helger
 * @since 4.6.5
 */
@Immutable
public final class EHFValidationG3Billing
{
  public static final String GROUP_ID = "no.ehf.g3";
  public static final String ARTIFACT_ID_INVOICE = "invoice";
  public static final String ARTIFACT_ID_CREDIT_NOTE = "creditnote";

  private static final String PEPPOL_GROUP_ID = PeppolValidation2026_05.GROUP_ID;

  private EHFValidationG3Billing ()
  {}

  private static void _registerAllAliases (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry,
                                           @NonNull @Nonempty final String sArtifactID,
                                           @NonNull @Nonempty final String sDisplayNamePrefix)
  {
    // All Peppol BIS Billing versions registered so far - deprecated ones (e.g. from
    // phive-rules-peppol-legacy) are skipped, so that the result does not depend on the
    // registration order
    final ICommonsList <IValidationExecutorSet <IValidationSourceXML>> aSourceVESs = aRegistry.findAll (x -> x.getID ()
                                                                                                              .getGroupID ()
                                                                                                              .equals (PEPPOL_GROUP_ID) &&
                                                                                                             x.getID ()
                                                                                                              .getArtifactID ()
                                                                                                              .equals (sArtifactID) &&
                                                                                                             !x.getStatus ()
                                                                                                               .isDeprecated ());
    if (aSourceVESs.isEmpty ())
      throw new IllegalStateException ("Found no Peppol BIS Billing VES with artifact ID '" +
                                       sArtifactID +
                                       "' to create EHF aliases for");

    for (final IValidationExecutorSet <IValidationSourceXML> aSourceVES : aSourceVESs)
      aRegistry.registerValidationExecutorSet (new ValidationExecutorSetAliasReadOnly <> (aSourceVES.getID ()
                                                                                                    .getWithGroupID (GROUP_ID),
                                                                                          sDisplayNamePrefix +
                                                                                                                                aSourceVES.getDisplayName (),
                                                                                          aSourceVES));
  }

  /**
   * @return A list of all prerequisite validation execution set coordinates that must already be
   *         registered before {@link #initEHF(IValidationExecutorSetRegistry)} is called. The
   *         Peppol BIS Billing versions are all registered together, so requiring the latest one is
   *         sufficient. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <DVRCoordinate> getAllPrerequisites ()
  {
    return new CommonsArrayList <> (PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_UBL_V3,
                                    PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3);
  }

  /**
   * Register an EHF Billing 3.0 alias for every non-deprecated Peppol BIS Billing Invoice and
   * Credit Note contained in the provided registry. The Peppol BIS Billing validation execution
   * sets must therefore be registered before.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   * @throws IllegalStateException
   *         If no Peppol BIS Billing Invoice or Credit Note is registered
   */
  public static void initEHF (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    _registerAllAliases (aRegistry, ARTIFACT_ID_INVOICE, "EHF Billing Invoice - alias of ");
    _registerAllAliases (aRegistry, ARTIFACT_ID_CREDIT_NOTE, "EHF Billing Credit Note - alias of ");
  }
}
