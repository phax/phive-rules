package com.helger.phive.rules.api;

import javax.annotation.concurrent.Immutable;

import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.api.EValidationType;
import com.helger.phive.api.artefact.IValidationArtefact;
import com.helger.phive.api.execute.IValidationExecutor;
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

    if (aVA.getValidationType () == EValidationType.XSD)
      return XMLSchemaCache.getInstance ().getSchema (aRes) != null;

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
