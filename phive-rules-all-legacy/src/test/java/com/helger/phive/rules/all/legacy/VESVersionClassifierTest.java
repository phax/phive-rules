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
package com.helger.phive.rules.all.legacy;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.util.Map;

import org.junit.Test;

import com.helger.base.string.StringParser;
import com.helger.base.version.Version;
import com.helger.collection.commons.CommonsHashMap;
import com.helger.collection.commons.CommonsTreeSet;
import com.helger.collection.commons.ICommonsMap;
import com.helger.collection.commons.ICommonsSortedSet;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.rules.all.PhiveRulesValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Test class that verifies that all registered VES IDs - the current as well as the legacy ones -
 * are consistently ordered. See https://github.com/phax/phive-rules/issues/80
 *
 * @author Philip Helger
 */
public final class VESVersionClassifierTest
{
  /**
   * <code>com.helger.base.version.Version.compareTo</code> compares the version classifier (the
   * part after the major/minor/micro numbers) as a String. Therefore all numeric classifiers of a
   * single group ID + artifact ID + numeric version combination must have the same number of
   * digits - otherwise e.g. "9" would be sorted after "13" and the "latest" pseudo version would
   * resolve to the wrong VES.
   */
  @Test
  public void testAllNumericVersionClassifiersAreStringComparable ()
  {
    final ValidationExecutorSetRegistry <IValidationSourceXML> aRegistry = new ValidationExecutorSetRegistry <> ();
    PhiveRulesValidation.initPhiveRules (aRegistry);
    PhiveRulesLegacyValidation.initPhiveRulesLegacy (aRegistry);

    // Group all numeric version classifiers by group ID + artifact ID + numeric version
    final ICommonsMap <String, ICommonsSortedSet <String>> aNumericClassifiers = new CommonsHashMap <> ();
    for (final IValidationExecutorSet <IValidationSourceXML> aVES : aRegistry.getAll ())
    {
      final DVRCoordinate aVESID = aVES.getID ();
      final Version aVersion = aVESID.getVersionObj ().getStaticVersion ();
      if (aVersion == null)
      {
        // It's a pseudo version - it has no classifier
        continue;
      }

      final String sClassifier = aVersion.getQualifier ();
      if (!StringParser.isUnsignedInt (sClassifier))
      {
        // No classifier at all or a non-numeric one like "SNAPSHOT", "rc" or
        // "RC2" - nothing to compare numerically
        continue;
      }

      final String sKey = aVESID.getGroupID () +
                          DVRCoordinate.PART_SEPARATOR +
                          aVESID.getArtifactID () +
                          DVRCoordinate.PART_SEPARATOR +
                          aVersion.getMajor () +
                          "." +
                          aVersion.getMinor () +
                          "." +
                          aVersion.getMicro ();
      aNumericClassifiers.computeIfAbsent (sKey, k -> new CommonsTreeSet <> ()).add (sClassifier);
    }

    // Safety net, so that this test cannot silently pass on an empty registry
    assertTrue (aNumericClassifiers.isNotEmpty ());

    for (final Map.Entry <String, ICommonsSortedSet <String>> aEntry : aNumericClassifiers.entrySet ())
    {
      final ICommonsSortedSet <String> aClassifiers = aEntry.getValue ();
      final int nExpectedLength = aClassifiers.getFirst ().length ();
      for (final String sClassifier : aClassifiers)
        assertEquals ("The numeric version classifiers of '" +
                      aEntry.getKey () +
                      "' are not String comparable: " +
                      aClassifiers +
                      " - pad them with leading zeroes so that all of them have the same length",
                      nExpectedLength,
                      sClassifier.length ());
    }
  }
}
