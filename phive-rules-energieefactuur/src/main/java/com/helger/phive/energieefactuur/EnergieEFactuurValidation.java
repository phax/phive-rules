/*
 * Copyright (C) 2017-2024 Philip Helger (www.helger.com)
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
package com.helger.phive.energieefactuur;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.simplerinvoicing.SimplerInvoicingValidation;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.phive.xml.xsd.ValidationExecutorXSDPartial;
import com.helger.phive.xml.xsd.XSDPartialContext;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.xpath.XPathHelper;

/**
 * Energie e-Factuur validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class EnergieEFactuurValidation
{
  public static final String GROUP_ID = "nl.energie-efactuur";
  public static final DVRCoordinate VID_ENERGIE_EFACTUUR_1_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "energie-efactuur",
                                                                                                    "1.0.0");
  public static final DVRCoordinate VID_ENERGIE_EFACTUUR_1_0_1 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "energie-efactuur",
                                                                                                    "1.0.1");
  public static final DVRCoordinate VID_ENERGIE_EFACTUUR_2_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "energie-efactuur",
                                                                                                    "2.0.0");
  public static final DVRCoordinate VID_ENERGIE_EFACTUUR_3_0_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "energie-efactuur",
                                                                                                    "3.0.0");
  public static final DVRCoordinate VID_ENERGIE_EFACTUUR_3_1_0 = PhiveRulesHelper.createCoordinate (GROUP_ID,
                                                                                                    "energie-efactuur",
                                                                                                    "3.1.0");

  /** Namespace URL for Energie e-Factuur 1.0.0 */
  public static final String EEF_EXT_NS_1_0_0 = "urn:www.energie-efactuur.nl:profile:invoice:ver1.0.0";
  /** Namespace URL for Energie e-Factuur 1.0.1 */
  public static final String EEF_EXT_NS_1_0_1 = "urn:www.energie-efactuur.nl:profile:invoice:ver1.0";
  /** Namespace URL for Energie e-Factuur 2.0.0 */
  public static final String EEF_EXT_NS_2_0_0 = "urn:www.energie-efactuur.nl:profile:invoice:ver2.0";
  /** Namespace URL for Energie e-Factuur 3.0.0 */
  public static final String EEF_EXT_NS_3_0_0 = "urn:www.energie-efactuur.nl:profile:invoice:ver3.0";
  /** Namespace URL for Energie e-Factuur 3.1.0 */
  public static final String EEF_EXT_NS_3_1_0 = "urn:www.energie-efactuur.nl:profile:invoice:ver3.1";

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return EnergieEFactuurValidation.class.getClassLoader ();
  }

  private static final ClassPathResource SEEF_EXT_XSD_1_0_0 = new ClassPathResource ("/external/schemas/energieefactuur/SEeF_UBLExtension_v1.0.0.xsd",
                                                                                     _getCL ());
  private static final ClassPathResource SEEF_EXT_XSD_1_0_1 = new ClassPathResource ("/external/schemas/energieefactuur/SEeF_UBLExtension_v1.0.1.xsd",
                                                                                     _getCL ());
  private static final ClassPathResource SEEF_EXT_XSD_2_0_0 = new ClassPathResource ("/external/schemas/energieefactuur/SEeF_UBLExtension_v2.0.0.xsd",
                                                                                     _getCL ());
  private static final ClassPathResource SEEF_EXT_XSD_3_0_0 = new ClassPathResource ("/external/schemas/energieefactuur/SEeF_UBLExtension_v3.0.0.xsd",
                                                                                     _getCL ());
  private static final ClassPathResource SEEF_EXT_XSD_3_1_0 = new ClassPathResource ("/external/schemas/energieefactuur/SEeF_UBLExtension_v3.1.0.xsd",
                                                                                     _getCL ());

  private EnergieEFactuurValidation ()
  {}

  /**
   * Register all standard Energie eFactuur validation execution sets to the
   * provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  @SuppressWarnings ("deprecation")
  public static void initEnergieEFactuur (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bNotDeprecated = false;

    final String sUBL21InvoiceNamespaceURI = UBL21Marshaller.invoice ().getRootElementNamespaceURI ();

    {
      // Create XPathExpression for extension validation
      final XPathFactory aXF = XPathHelper.createXPathFactorySaxonFirst ();
      final XPath aXP = aXF.newXPath ();
      final MapBasedNamespaceContext aNsCtx = UBL21NamespaceContext.getInstance ().getClone ();
      aNsCtx.addMapping ("ubl", sUBL21InvoiceNamespaceURI);
      aNsCtx.addMapping ("eef1", EEF_EXT_NS_1_0_0);
      aXP.setNamespaceContext (aNsCtx);

      final XPathExpression aXE100 = XPathHelper.createNewXPathExpression (aXP,
                                                                           "/ubl:Invoice/cec:UBLExtensions/cec:UBLExtension/cec:ExtensionContent" +
                                                                                "/eef1:UtilityConsumptionPoint");

      final ICommonsList <ClassPathResource> aPartialXSDs = UBL21Marshaller.getAllBaseXSDs ();
      aPartialXSDs.add (SEEF_EXT_XSD_1_0_0);

      // Same Schematrons as SimplerInvoicing - and same classloader!
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ENERGIE_EFACTUUR_1_0_0,
                                                                             "Energie eFactuur " +
                                                                                                         VID_ENERGIE_EFACTUUR_1_0_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorXSDPartial.create (aPartialXSDs,
                                                                                                                  XSDPartialContext.create (aXE100,
                                                                                                                                            1,
                                                                                                                                            1)),
                                                                             PhiveRulesHelper.createXSLT (SimplerInvoicingValidation.INVOICE_SI11,
                                                                                                          aNsCtx)));
    }
    {
      // Create XPathExpression for extension validation
      final XPathFactory aXF = XPathHelper.createXPathFactorySaxonFirst ();
      final XPath aXP = aXF.newXPath ();
      final MapBasedNamespaceContext aNsCtx = UBL21NamespaceContext.getInstance ().getClone ();
      aNsCtx.addMapping ("ubl", sUBL21InvoiceNamespaceURI);
      aNsCtx.addMapping ("eef101", EEF_EXT_NS_1_0_1);
      aXP.setNamespaceContext (aNsCtx);

      final XPathExpression aXE101 = XPathHelper.createNewXPathExpression (aXP,
                                                                           "/ubl:Invoice/cec:UBLExtensions/cec:UBLExtension/cec:ExtensionContent" +
                                                                                "/eef101:SEEFExtensionWrapper");

      final ICommonsList <ClassPathResource> aPartialXSDs = UBL21Marshaller.getAllBaseXSDs ();
      aPartialXSDs.add (SEEF_EXT_XSD_1_0_1);

      // Same Schematrons as SimplerInvoicing - and same classloader!
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ENERGIE_EFACTUUR_1_0_1,
                                                                             "Energie eFactuur " +
                                                                                                         VID_ENERGIE_EFACTUUR_1_0_1.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorXSDPartial.create (aPartialXSDs,
                                                                                                                  XSDPartialContext.create (aXE101,
                                                                                                                                            1,
                                                                                                                                            1)),
                                                                             PhiveRulesHelper.createXSLT (SimplerInvoicingValidation.INVOICE_SI11,
                                                                                                          aNsCtx)));
    }
    {
      // Create XPathExpression for extension validation
      final XPathFactory aXF = XPathHelper.createXPathFactorySaxonFirst ();
      final XPath aXP = aXF.newXPath ();
      final MapBasedNamespaceContext aNsCtx = UBL21NamespaceContext.getInstance ().getClone ();
      aNsCtx.addMapping ("ubl", sUBL21InvoiceNamespaceURI);
      aNsCtx.addMapping ("eef2", EEF_EXT_NS_2_0_0);
      aXP.setNamespaceContext (aNsCtx);

      final XPathExpression aXE200 = XPathHelper.createNewXPathExpression (aXP,
                                                                           "/ubl:Invoice/cec:UBLExtensions/cec:UBLExtension/cec:ExtensionContent" +
                                                                                "/eef2:SEEFExtensionWrapper");

      final ICommonsList <ClassPathResource> aPartialXSDs = UBL21Marshaller.getAllBaseXSDs ();
      aPartialXSDs.add (SEEF_EXT_XSD_2_0_0);

      // Same Schematrons as SimplerInvoicing - and same classloader!
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ENERGIE_EFACTUUR_2_0_0,
                                                                             "Energie eFactuur " +
                                                                                                         VID_ENERGIE_EFACTUUR_2_0_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorXSDPartial.create (aPartialXSDs,
                                                                                                                  XSDPartialContext.create (aXE200,
                                                                                                                                            1,
                                                                                                                                            1)),
                                                                             PhiveRulesHelper.createXSLT (SimplerInvoicingValidation.INVOICE_SI12,
                                                                                                          aNsCtx)));
    }
    {
      // Create XPathExpression for extension validation
      final XPathFactory aXF = XPathHelper.createXPathFactorySaxonFirst ();
      final XPath aXP = aXF.newXPath ();
      final MapBasedNamespaceContext aNsCtx = UBL21NamespaceContext.getInstance ().getClone ();
      aNsCtx.addMapping ("ubl", sUBL21InvoiceNamespaceURI);
      aNsCtx.addMapping ("eef3", EEF_EXT_NS_3_0_0);
      aXP.setNamespaceContext (aNsCtx);

      final XPathExpression aXE300 = XPathHelper.createNewXPathExpression (aXP,
                                                                           "/ubl:Invoice/cec:UBLExtensions/cec:UBLExtension/cec:ExtensionContent" +
                                                                                "/eef3:SEEFExtensionWrapper");

      final ICommonsList <ClassPathResource> aPartialXSDs = UBL21Marshaller.getAllBaseXSDs ();
      aPartialXSDs.add (SEEF_EXT_XSD_3_0_0);

      // Same Schematrons as SimplerInvoicing - and same classloader!
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ENERGIE_EFACTUUR_3_0_0,
                                                                             "Energie eFactuur " +
                                                                                                         VID_ENERGIE_EFACTUUR_3_0_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorXSDPartial.create (aPartialXSDs,
                                                                                                                  XSDPartialContext.create (aXE300,
                                                                                                                                            1,
                                                                                                                                            1)),
                                                                             PhiveRulesHelper.createXSLT (SimplerInvoicingValidation.INVOICE_SI20,
                                                                                                          aNsCtx)));
    }
    {
      // Create XPathExpression for extension validation
      final XPathFactory aXF = XPathHelper.createXPathFactorySaxonFirst ();
      final XPath aXP = aXF.newXPath ();
      final MapBasedNamespaceContext aNsCtx = UBL21NamespaceContext.getInstance ().getClone ();
      aNsCtx.addMapping ("ubl", sUBL21InvoiceNamespaceURI);
      aNsCtx.addMapping ("eef31", EEF_EXT_NS_3_1_0);
      aXP.setNamespaceContext (aNsCtx);

      final XPathExpression aXE310 = XPathHelper.createNewXPathExpression (aXP,
                                                                           "/ubl:Invoice/cec:UBLExtensions/cec:UBLExtension/cec:ExtensionContent" +
                                                                                "/eef31:SEEFExtensionWrapper");

      final ICommonsList <ClassPathResource> aPartialXSDs = UBL21Marshaller.getAllBaseXSDs ();
      aPartialXSDs.add (SEEF_EXT_XSD_3_1_0);

      // Same Schematrons as SimplerInvoicing - and same classloader!
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ENERGIE_EFACTUUR_3_1_0,
                                                                             "Energie eFactuur " +
                                                                                                         VID_ENERGIE_EFACTUUR_3_1_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             ValidationExecutorXSD.create (UBL21Marshaller.getAllInvoiceXSDs ()),
                                                                             ValidationExecutorXSDPartial.create (aPartialXSDs,
                                                                                                                  XSDPartialContext.create (aXE310,
                                                                                                                                            1,
                                                                                                                                            1)),
                                                                             PhiveRulesHelper.createXSLT (SimplerInvoicingValidation.INVOICE_SI2035,
                                                                                                          aNsCtx)));
    }
  }
}
