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

import static org.junit.Assert.assertTrue;

import org.junit.Test;

import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.rules.all.PhiveRulesValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

/**
 * Test class for class {@link PhiveRulesLegacyValidation}.
 *
 * @author Philip Helger
 */
public final class PhiveRulesLegacyValidationTest
{
  @Test
  public void testInitPhiveRulesLegacyStandalone ()
  {
    final ValidationExecutorSetRegistry <IValidationSourceXML> aRegistry = new ValidationExecutorSetRegistry <> ();
    PhiveRulesLegacyValidation.initPhiveRulesLegacy (aRegistry);
    assertTrue (aRegistry.getAll ().isNotEmpty ());
  }

  @Test
  public void testCurrentAndLegacyCoexist ()
  {
    // The current and the legacy aggregator must be loadable into the same registry without a
    // duplicate VES ID collision. Register the current rules first, then the legacy rules.
    final ValidationExecutorSetRegistry <IValidationSourceXML> aRegistry = new ValidationExecutorSetRegistry <> ();
    PhiveRulesValidation.initPhiveRules (aRegistry);
    PhiveRulesLegacyValidation.initPhiveRulesLegacy (aRegistry);
    assertTrue (aRegistry.getAll ().isNotEmpty ());
  }
}
