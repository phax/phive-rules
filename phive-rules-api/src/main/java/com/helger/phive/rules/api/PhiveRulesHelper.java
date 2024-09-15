package com.helger.phive.rules.api;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.annotation.Nonempty;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.diver.api.version.DVRVersionException;
import com.helger.phive.api.executorset.status.IValidationExecutorSetStatus;
import com.helger.phive.api.executorset.status.ValidationExecutorSetStatus;

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
    try
    {
      return DVRCoordinate.create (sGroupID, sArtifactID, sVersion);
    }
    catch (final DVRVersionException ex)
    {
      throw new IllegalArgumentException (ex);
    }
  }

  @Nonnull
  public static IValidationExecutorSetStatus createStatus (final boolean bIsDeprecated)
  {
    return ValidationExecutorSetStatus.createDeprecatedNow (bIsDeprecated);
  }
}
