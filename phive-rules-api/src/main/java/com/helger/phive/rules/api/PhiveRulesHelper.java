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

import org.jspecify.annotations.NonNull;
import org.jspecify.annotations.Nullable;

import com.helger.annotation.Nonempty;
import com.helger.annotation.concurrent.Immutable;
import com.helger.collection.commons.ICommonsList;
import com.helger.datetime.helper.PDTFactory;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.diver.api.version.DVRVersionException;
import com.helger.io.resource.IReadableResource;
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
  @NonNull
  public static DVRCoordinate createCoordinate (@NonNull @Nonempty final String sGroupID,
                                                @NonNull @Nonempty final String sArtifactID,
                                                @NonNull @Nonempty final String sVersion)
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
  @NonNull
  public static DVRCoordinate createCoordinate (@NonNull @Nonempty final String sGroupID,
                                                @NonNull @Nonempty final String sArtifactID,
                                                @NonNull @Nonempty final String sVersion,
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

  @NonNull
  public static ValidationExecutorSchematron createXSLT (@NonNull final IReadableResource aRes,
                                                         @Nullable final IIterableNamespaceContext aNsCtx)
  {
    SchematronNamespaceBeautifier.addMappings (aNsCtx);
    return ValidationExecutorSchematron.createXSLT (aRes, null, aNsCtx);
  }

  @NonNull
  public static IValidationExecutorSetStatus createSimpleStatus (final boolean bIsDeprecated)
  {
    return ValidationExecutorSetStatus.createDeprecatedNow (bIsDeprecated);
  }

  @NonNull
  public static IValidationExecutorSetStatus createSimpleStatus (final boolean bIsDeprecated,
                                                                 @NonNull final OffsetDateTime aValidPer)
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
