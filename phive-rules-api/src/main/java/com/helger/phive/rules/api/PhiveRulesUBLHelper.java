package com.helger.phive.rules.api;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;
import javax.xml.XMLConstants;

import com.helger.commons.annotation.ReturnsMutableObject;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.xml.schematron.ValidationExecutorSchematron;
import com.helger.ubl20.UBL20NamespaceContext;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.ubl22.UBL22NamespaceContext;
import com.helger.ubl23.UBL23NamespaceContext;
import com.helger.xml.namespace.MapBasedNamespaceContext;

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
  @ReturnsMutableObject
  public static MapBasedNamespaceContext createUBL21NSContext (@Nonnull final String sNamespaceURI)
  {
    final MapBasedNamespaceContext aNSContext = UBL21NamespaceContext.getInstance ().getClone ();

    // Add the default mapping for the root namespace
    aNSContext.addMapping (XMLConstants.DEFAULT_NS_PREFIX, sNamespaceURI);
    // For historical reasons, the "ubl" prefix is also mapped to this
    // namespace URI
    aNSContext.addMapping ("ubl", sNamespaceURI);

    return aNSContext;
  }

  @Nonnull
  public static ValidationExecutorSchematron createXSLT_UBL20 (@Nonnull final IReadableResource aRes)
  {
    return PhiveRulesHelper.createXSLT (aRes, UBL20NamespaceContext.getInstance ());
  }

  @Nonnull
  public static ValidationExecutorSchematron createXSLT_UBL21 (@Nonnull final IReadableResource aRes)
  {
    return PhiveRulesHelper.createXSLT (aRes, UBL21NamespaceContext.getInstance ());
  }

  @Nonnull
  public static ValidationExecutorSchematron createXSLT_UBL22 (@Nonnull final IReadableResource aRes)
  {
    return PhiveRulesHelper.createXSLT (aRes, UBL22NamespaceContext.getInstance ());
  }

  @Nonnull
  public static ValidationExecutorSchematron createXSLT_UBL23 (@Nonnull final IReadableResource aRes)
  {
    return PhiveRulesHelper.createXSLT (aRes, UBL23NamespaceContext.getInstance ());
  }
}
