package com.helger.phive.rules.api;

import org.jspecify.annotations.NonNull;

import com.helger.diver.api.coord.DVRCoordinate;

/**
 * Special initialization exception, if a prerequisite validation rules is missing.
 *
 * @author Philip Helger
 * @since 4.4.0
 */
public class PhiveRulesInitializationException extends RuntimeException
{
  public PhiveRulesInitializationException (@NonNull final DVRCoordinate aCoord)
  {
    super ("The VES with coordinate '" + aCoord.getAsSingleID () + "' must be registered before this one");
  }
}
