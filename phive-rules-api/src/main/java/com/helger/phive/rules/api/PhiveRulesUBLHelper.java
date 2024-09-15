package com.helger.phive.rules.api;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.xml.schematron.SchematronNamespaceBeautifier;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.ubl22.UBL22NamespaceContext;
import com.helger.xml.namespace.IIterableNamespaceContext;

/**
 * Utility class around UBL for phive-rules libs.
 *
 * @author Philip Helger
 */
@Immutable
public final class PhiveRulesUBLHelper
{
  private PhiveRulesUBLHelper ()
  {}

  @Nonnull
  public static ValidationExecutorSchematron createXSLT_UBL21 (@Nonnull final IReadableResource aRes)
  {
    final IIterableNamespaceContext aNsCtx = UBL21NamespaceContext.getInstance ();
    SchematronNamespaceBeautifier.addMappings (aNsCtx);
    return ValidationExecutorSchematron.createXSLT (aRes, aNsCtx);
  }

  @Nonnull
  public static ValidationExecutorSchematron createXSLT_UBL22 (@Nonnull final IReadableResource aRes)
  {
    final IIterableNamespaceContext aNsCtx = UBL22NamespaceContext.getInstance ();
    SchematronNamespaceBeautifier.addMappings (aNsCtx);
    return ValidationExecutorSchematron.createXSLT (aRes, aNsCtx);
  }
}
