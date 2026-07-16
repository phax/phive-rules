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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.helger.annotation.concurrent.Immutable;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.EValidationType;
import com.helger.phive.api.artefact.IValidationArtefact;
import com.helger.phive.api.executor.IValidationExecutor;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.schematron.pure.SchematronResourcePureXPath;
import com.helger.schematron.sch.SchematronResourceSCH;
import com.helger.schematron.schxslt.xslt2.SchematronResourceSchXslt_XSLT2;
import com.helger.schematron.schxslt2.xslt.SchematronResourceSchXslt2;
import com.helger.schematron.xslt.SchematronResourceXSLT;
import com.helger.xml.schema.XMLSchemaCache;

@Immutable
public final class PhiveRulesTestHelper
{
  private static final Logger LOGGER = LoggerFactory.getLogger (PhiveRulesTestHelper.class);

  private PhiveRulesTestHelper ()
  {}

  public static boolean isContentCorrect (final IValidationExecutor <IValidationSourceXML> aVE)
  {
    final IValidationArtefact aVA = aVE.getValidationArtefact ();
    final IReadableResource aRes = aVA.getRuleResource ();

    if (aVA.getValidationType () == EValidationType.XSD)
    {
      // Don't check XSD, because the dependency list will is not correctly
      // available
      if (false)
      {
        return XMLSchemaCache.getInstance ().getSchema (aRes) != null;
      }
      return true;
    }

    // Check that the passed Schematron is valid
    if (aVA.getValidationType () == EValidationType.SCHEMATRON_PURE)
      return SchematronResourcePureXPath.builder (aRes).build ().isValidSchematron ();

    if (aVA.getValidationType () == EValidationType.SCHEMATRON_SCH_ISO_XSLT2)
      return SchematronResourceSCH.builder (aRes).build ().isValidSchematron ();

    if (aVA.getValidationType () == EValidationType.SCHEMATRON_XSLT1 ||
        aVA.getValidationType () == EValidationType.SCHEMATRON_XSLT2 ||
        aVA.getValidationType () == EValidationType.SCHEMATRON_XSLT3)
      return SchematronResourceXSLT.builder (aRes).build ().isValidSchematron ();

    if (aVA.getValidationType () == EValidationType.SCHEMATRON_SCHXSLT1_XSLT2)
      return SchematronResourceSchXslt_XSLT2.builder (aRes).build ().isValidSchematron ();

    if (aVA.getValidationType () == EValidationType.SCHEMATRON_SCHXSLT2_XSLT3)
      return SchematronResourceSchXslt2.builder (aRes).build ().isValidSchematron ();

    // Assume success
    LOGGER.warn ("Unexpected validation type: " + aVA.getValidationType () + " - assuming it is okay");
    return true;
  }
}
