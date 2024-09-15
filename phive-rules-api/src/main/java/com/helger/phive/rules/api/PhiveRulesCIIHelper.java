package com.helger.phive.rules.api;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.cii.d16b.CIID16BNamespaceContext;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.xml.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.xml.namespace.IIterableNamespaceContext;

/**
 * Utility class around CII for phive-rules libs.
 *
 * @author Philip Helger
 */
@Immutable
public final class PhiveRulesCIIHelper
{
  private PhiveRulesCIIHelper ()
  {}

  @Nonnull
  public static ValidationExecutorSchematron createXSLT_CII_D16B (@Nonnull final IReadableResource aRes)
  {
    final IIterableNamespaceContext aNsCtx = CIID16BNamespaceContext.getInstance ();
    SchematronNamespaceBeautifier.addMappings (aNsCtx);
    return ValidationExecutorSchematron.createXSLT (aRes, aNsCtx);
  }
}
