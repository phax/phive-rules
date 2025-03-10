/*
 * Copyright (C) 2024-2025 Philip Helger (www.helger.com)
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
package com.helger.phive.rules.api;

import java.time.OffsetDateTime;

import javax.annotation.Nonnull;
import javax.annotation.Nullable;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.annotation.Nonempty;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.datetime.PDTFactory;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.diver.api.version.DVRVersionException;
import com.helger.phive.api.executorset.status.EValidationExecutorStatusType;
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatusHistoryItem;
import com.helger.phive.xml.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.xml.namespace.IIterableNamespaceContext;

/**
 * Utility class for phive-rules libs.
 *
 * @author Philip Helger
 */
@Immutable
public final class PhiveRulesHelper
{
  private PhiveRulesHelper ()
  {}

  /**
   * Create coordinates, capturing version parsing exceptions
   *
   * @param sGroupID
   *        Coordinate group ID
   * @param sArtifactID
   *        Coordinate artifact ID
   * @param sVersion
   *        Coordinate version
   * @return The created {@link DVRCoordinate} and never <code>null</code>.
   */
  @Nonnull
  public static DVRCoordinate createCoordinate (@Nonnull @Nonempty final String sGroupID,
                                                @Nonnull @Nonempty final String sArtifactID,
                                                @Nonnull @Nonempty final String sVersion)
  {
    return createCoordinate (sGroupID, sArtifactID, sVersion, null);
  }

  /**
   * Create coordinates, capturing version parsing exceptions
   *
   * @param sGroupID
   *        Coordinate group ID
   * @param sArtifactID
   *        Coordinate artifact ID
   * @param sVersion
   *        Coordinate version
   * @param sClassifier
   *        Optional coordinate classifier
   * @return The created {@link DVRCoordinate} and never <code>null</code>.
   */
  @Nonnull
  public static DVRCoordinate createCoordinate (@Nonnull @Nonempty final String sGroupID,
                                                @Nonnull @Nonempty final String sArtifactID,
                                                @Nonnull @Nonempty final String sVersion,
                                                @Nullable final String sClassifier)
  {
    try
    {
      return DVRCoordinate.create (sGroupID, sArtifactID, sVersion, sClassifier);
    }
    catch (final DVRVersionException ex)
    {
      throw new IllegalArgumentException (ex);
    }
  }

  @Nonnull
  public static ValidationExecutorSchematron createXSLT (@Nonnull final IReadableResource aRes,
                                                         @Nullable final IIterableNamespaceContext aNsCtx)
  {
    SchematronNamespaceBeautifier.addMappings (aNsCtx);
    return ValidationExecutorSchematron.createXSLT (aRes, null, aNsCtx);
  }

  @Nonnull
  public static IValidationExecutorSetStatus createSimpleStatus (final boolean bIsDeprecated)
  {
    return ValidationExecutorSetStatus.createDeprecatedNow (bIsDeprecated);
  }

  @Nonnull
  public static IValidationExecutorSetStatus createSimpleStatus (final boolean bIsDeprecated,
                                                                 @Nonnull final OffsetDateTime aValidPer)
  {
    return new ValidationExecutorSetStatus (PDTFactory.getCurrentOffsetDateTime (),
                                            bIsDeprecated ? EValidationExecutorStatusType.DEPRECATED
                                                          : EValidationExecutorStatusType.VALID,
                                            aValidPer,
                                            (OffsetDateTime) null,
                                            (String) null,
                                            (DVRCoordinate) null,
                                            (ICommonsList <ValidationExecutorSetStatusHistoryItem>) null);
  }
}
