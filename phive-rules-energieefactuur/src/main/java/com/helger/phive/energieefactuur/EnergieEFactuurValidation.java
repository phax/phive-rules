/*
 * Copyright (C) 2017-2025 Philip Helger (www.helger.com)
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

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.executor.IValidationExecutor;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.simplerinvoicing.SimplerInvoicingValidation;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSDPartial;
import com.helger.phive.xml.xsd.XSDPartialContext;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl21.UBL21NamespaceContext;
import com.helger.xml.namespace.MapBasedNamespaceContext;
import com.helger.xml.xpath.XPathHelper;

import jakarta.annotation.Nonnull;

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

    final IValidationExecutorSet <IValidationSourceXML> aSI11 = aRegistry.getOfID (SimplerInvoicingValidation.VID_SI_INVOICE_V11);
    assert 2 == aSI11.executors ().size ();

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
      aPartialXSDs.add (new ClassPathResource ("/external/schemas/energieefactuur/SEeF_UBLExtension_v1.0.0.xsd",
                                               _getCL ()));

      // Same Schematrons as SimplerInvoicing - and same classloader!
      final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = new CommonsArrayList <> (aSI11.executors ());
      // Add the Partial XSD in the middle
      aNewList.add (1, ValidationExecutorXSDPartial.create (aPartialXSDs, XSDPartialContext.createMandatory (aXE100)));

      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ENERGIE_EFACTUUR_1_0_0,
                                                                             "Energie eFactuur " +
                                                                                                         VID_ENERGIE_EFACTUUR_1_0_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             aNewList));
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
      aPartialXSDs.add (new ClassPathResource ("/external/schemas/energieefactuur/SEeF_UBLExtension_v1.0.1.xsd",
                                               _getCL ()));

      // Same Schematrons as SimplerInvoicing - and same classloader!
      final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = new CommonsArrayList <> (aSI11.executors ());
      // Add the Partial XSD in the middle
      aNewList.add (1, ValidationExecutorXSDPartial.create (aPartialXSDs, XSDPartialContext.createMandatory (aXE101)));

      // Same Schematrons as SimplerInvoicing - and same classloader!
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ENERGIE_EFACTUUR_1_0_1,
                                                                             "Energie eFactuur " +
                                                                                                         VID_ENERGIE_EFACTUUR_1_0_1.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             aNewList));
    }

    {
      final IValidationExecutorSet <IValidationSourceXML> aSI12 = aRegistry.getOfID (SimplerInvoicingValidation.VID_SI_INVOICE_V12);
      assert 2 == aSI12.executors ().size ();

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
      aPartialXSDs.add (new ClassPathResource ("/external/schemas/energieefactuur/SEeF_UBLExtension_v2.0.0.xsd",
                                               _getCL ()));

      // Same Schematrons as SimplerInvoicing - and same classloader!
      final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = new CommonsArrayList <> (aSI12.executors ());
      // Add the Partial XSD in the middle
      aNewList.add (1, ValidationExecutorXSDPartial.create (aPartialXSDs, XSDPartialContext.createMandatory (aXE200)));

      // Same Schematrons as SimplerInvoicing - and same classloader!
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ENERGIE_EFACTUUR_2_0_0,
                                                                             "Energie eFactuur " +
                                                                                                         VID_ENERGIE_EFACTUUR_2_0_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             aNewList));
    }

    {
      final IValidationExecutorSet <IValidationSourceXML> aSI20 = aRegistry.getOfID (SimplerInvoicingValidation.VID_SI_INVOICE_V20);
      assert 2 == aSI20.executors ().size ();

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
      aPartialXSDs.add (new ClassPathResource ("/external/schemas/energieefactuur/SEeF_UBLExtension_v3.0.0.xsd",
                                               _getCL ()));

      // Same Schematrons as SimplerInvoicing - and same classloader!
      final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = new CommonsArrayList <> (aSI20.executors ());
      // Add the Partial XSD in the middle
      aNewList.add (1, ValidationExecutorXSDPartial.create (aPartialXSDs, XSDPartialContext.createMandatory (aXE300)));

      // Same Schematrons as SimplerInvoicing - and same classloader!
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ENERGIE_EFACTUUR_3_0_0,
                                                                             "Energie eFactuur " +
                                                                                                         VID_ENERGIE_EFACTUUR_3_0_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             aNewList));
    }

    {
      final IValidationExecutorSet <IValidationSourceXML> aSI2035 = aRegistry.getOfID (SimplerInvoicingValidation.VID_SI_INVOICE_V20);
      assert 2 == aSI2035.executors ().size ();

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
      aPartialXSDs.add (new ClassPathResource ("/external/schemas/energieefactuur/SEeF_UBLExtension_v3.1.0.xsd",
                                               _getCL ()));

      // Same Schematrons as SimplerInvoicing - and same classloader!
      final ICommonsList <IValidationExecutor <IValidationSourceXML>> aNewList = new CommonsArrayList <> (aSI2035.executors ());
      // Add the Partial XSD in the middle
      aNewList.add (1, ValidationExecutorXSDPartial.create (aPartialXSDs, XSDPartialContext.createMandatory (aXE310)));

      // Same Schematrons as SimplerInvoicing - and same classloader!
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_ENERGIE_EFACTUUR_3_1_0,
                                                                             "Energie eFactuur " +
                                                                                                         VID_ENERGIE_EFACTUUR_3_1_0.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             aNewList));
    }
  }
}
