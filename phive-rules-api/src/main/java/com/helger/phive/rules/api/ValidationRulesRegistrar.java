/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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

import java.util.List;

import org.jspecify.annotations.NonNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.base.spi.ServiceLoaderHelper;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Discovers all {@link IValidationRulesRegistrarSPI} implementations on the classpath via the JDK
 * {@link java.util.ServiceLoader} mechanism and registers their validation execution sets into a
 * provided registry.
 * <p>
 * As the SPI load order is not deterministic, an implementation is only invoked once all coordinates
 * from its {@link IValidationRulesRegistrarSPI#getAllPrerequisites()} are present in the registry.
 * An implementation whose prerequisites are not yet present is pushed to the end of the work list and
 * retried in a later round, after other implementations had the chance to register those
 * prerequisites. If a full round passes without any progress (i.e. every remaining implementation is
 * still missing a prerequisite), the remaining prerequisites are considered unresolvable and an
 * {@link IllegalStateException} is thrown.
 *
 * @author Philip Helger
 */
@Immutable
public final class ValidationRulesRegistrar
{
  private static final Logger LOGGER = LoggerFactory.getLogger (ValidationRulesRegistrar.class);

  private ValidationRulesRegistrar ()
  {}

  /**
   * Register the validation execution sets of all {@link IValidationRulesRegistrarSPI}
   * implementations found on the classpath into the provided registry, resolving the ordering
   * between modules with dependencies automatically.
   *
   * @param aRegistry
   *        The registry to add the artefacts to. May not be <code>null</code>.
   * @throws IllegalStateException
   *         If the prerequisites of one or more modules cannot be resolved (circular or missing
   *         dependency).
   */
  public static void registerAllValidationRules (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // Discover all SPI implementations - the order is not deterministic
    final List <IValidationRulesRegistrarSPI> aAllSPIs = ServiceLoaderHelper.getAllSPIImplementations (IValidationRulesRegistrarSPI.class);
    if (LOGGER.isDebugEnabled ())
      LOGGER.debug ("Found " + aAllSPIs.size () + " IValidationRulesRegistrarSPI implementations to register");

    // Work list of implementations that still need to be registered
    ICommonsList <IValidationRulesRegistrarSPI> aPending = new CommonsArrayList <> (aAllSPIs);
    while (aPending.isNotEmpty ())
    {
      // Implementations that failed this round because a prerequisite is not yet registered
      final ICommonsList <IValidationRulesRegistrarSPI> aFailed = new CommonsArrayList <> ();
      for (final IValidationRulesRegistrarSPI aSPI : aPending)
      {
        // Check whether all declared prerequisites of this implementation are already present
        boolean bAllPrerequisitesPresent = true;
        for (final DVRCoordinate aPrerequisite : aSPI.getAllPrerequisites ())
          if (aRegistry.getOfID (aPrerequisite) == null)
          {
            bAllPrerequisitesPresent = false;
            break;
          }

        // Defer if a prerequisite is missing, or if the registration itself signals a retry
        if (!bAllPrerequisitesPresent || aSPI.registerValidationRules (aRegistry).isFailure ())
        {
          if (LOGGER.isDebugEnabled ())
            LOGGER.debug ("Deferring validation rules registration of '" +
                          aSPI.getClass ().getName () +
                          "' to a later round because a prerequisite is missing");
          aFailed.add (aSPI);
        }
      }

      if (aFailed.isEmpty ())
      {
        // All remaining implementations were registered successfully
        break;
      }

      if (aFailed.size () == aPending.size ())
      {
        // A full round without any progress - the remaining prerequisites are unresolvable
        final ICommonsList <String> aFailedNames = new CommonsArrayList <> ();
        for (final IValidationRulesRegistrarSPI aSPI : aFailed)
          aFailedNames.add (aSPI.getClass ().getName ());
        throw new IllegalStateException ("Unable to register the validation rules of the following SPI implementations, because their prerequisites are unresolvable (circular or missing dependency): " +
                                         aFailedNames);
      }

      // At least one implementation succeeded this round - retry only the failed ones
      aPending = aFailed;
    }
  }
}
