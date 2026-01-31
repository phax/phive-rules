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
package com.helger.phive.rules.api;

import com.helger.annotation.concurrent.Immutable;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.EValidationType;
import com.helger.phive.api.artefact.IValidationArtefact;
import com.helger.phive.api.executor.IValidationExecutor;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.schematron.pure.SchematronResourcePure;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;
import com.helger.schematron.xslt.SchematronResourceXSLT;
import com.helger.xml.schema.XMLSchemaCache;

@Immutable
public final class PhiveRulesTestHelper
{
  private PhiveRulesTestHelper ()
  {}

  public static boolean isContentCorrect (final IValidationExecutor <IValidationSourceXML> aVE)
  {
    final IValidationArtefact aVA = aVE.getValidationArtefact ();
    final IReadableResource aRes = aVA.getRuleResource ();

    // Don't check XSD, because the dependency list will is not correctly
    // available
    if (false)
    {
      if (aVA.getValidationType () == EValidationType.XSD)
        return XMLSchemaCache.getInstance ().getSchema (aRes) != null;
    }

    // Check that the passed Schematron is valid
    if (aVA.getValidationType () == EValidationType.SCHEMATRON_PURE)
      return new SchematronResourcePure (aRes).isValidSchematron ();
    if (aVA.getValidationType () == EValidationType.SCHEMATRON_SCH)
      return new SchematronResourceSCH (aRes).isValidSchematron ();
    if (aVA.getValidationType () == EValidationType.SCHEMATRON_XSLT)
      return new SchematronResourceXSLT (aRes).isValidSchematron ();
    if (aVA.getValidationType () == EValidationType.SCHEMATRON_SCHXSLT)
      return new SchematronResourceSchXslt_XSLT2 (aRes).isValidSchematron ();

    // Assume success
    return true;
  }
}
