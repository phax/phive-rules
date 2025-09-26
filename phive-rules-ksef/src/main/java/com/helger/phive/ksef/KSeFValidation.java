/*
 * Copyright (C) 2021-2025 Philip Helger (www.helger.com)
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
package com.helger.phive.ksef;

import javax.xml.XMLConstants;
import javax.xml.validation.SchemaFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.SAXNotRecognizedException;
import org.xml.sax.SAXNotSupportedException;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.ICommonsList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.phive.api.EValidationType;
import com.helger.phive.api.artefact.ValidationArtefact;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.rules.api.PhiveRulesHelper;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.xsd.ValidationExecutorXSD;
import com.helger.xml.ls.SimpleLSResourceResolver;
import com.helger.xml.sax.LoggingSAXErrorHandler;
import com.helger.xml.schema.XMLSchemaCache;
import com.helger.xsds.xmldsig.CXMLDSig;

import jakarta.annotation.Nonnull;

/**
 * Generic KSeF validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class KSeFValidation
{
  public static final String GROUP_ID = "pl.ksef";

  @Deprecated
  public static final DVRCoordinate KSEF_1 = PhiveRulesHelper.createCoordinate (GROUP_ID, "ksef", "1.0.0");

  public static final DVRCoordinate KSEF_2 = PhiveRulesHelper.createCoordinate (GROUP_ID, "ksef", "2.0.0");

  private static final Logger LOGGER = LoggerFactory.getLogger (KSeFValidation.class);

  private KSeFValidation ()
  {}

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return KSeFValidation.class.getClassLoader ();
  }

  /**
   * Register all standard KSeF validation execution sets to the provided registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initKSeF (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bDeprecated = true;
    final boolean bNotDeprecated = false;

    // KSeF 2.0
    final SchemaFactory aCustomSF = SchemaFactory.newInstance (XMLConstants.W3C_XML_SCHEMA_NS_URI);
    try
    {
      // <xsd:element name="NowySrodekTransportu" maxOccurs="10000">
      aCustomSF.setProperty ("jdk.xml.maxOccurLimit", Integer.valueOf (10000));
    }
    catch (final SAXNotRecognizedException | SAXNotSupportedException ex)
    {
      LOGGER.error ("Failed to set XML property", ex);
    }
    final XMLSchemaCache aCustomSchemaCache = new XMLSchemaCache (aCustomSF,
                                                                  new LoggingSAXErrorHandler (),
                                                                  new SimpleLSResourceResolver ());

    {
      final ICommonsList <ClassPathResource> aResList = new CommonsArrayList <> (CXMLDSig.getXSDResource (),
                                                                                 new ClassPathResource ("/external/schemas/1.0.0/StrukturyDanych_v9-0E.xsd",
                                                                                                        _getCL ()),
                                                                                 new ClassPathResource ("/external/schemas/1.0.0/schema.xsd",
                                                                                                        _getCL ()));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (KSEF_1,
                                                                             "KSeF " + KSEF_1.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bDeprecated),
                                                                             ValidationExecutorXSD.create (aResList)));
    }

    {
      final ICommonsList <ClassPathResource> aResList = new CommonsArrayList <> (CXMLDSig.getXSDResource (),
                                                                                 new ClassPathResource ("/external/schemas/2.0.0/StrukturyDanych_v10-0E.xsd",
                                                                                                        _getCL ()),
                                                                                 new ClassPathResource ("/external/schemas/2.0.0/schema.xsd",
                                                                                                        _getCL ()));
      aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (KSEF_2,
                                                                             "KSeF " + KSEF_2.getVersionString (),
                                                                             PhiveRulesHelper.createSimpleStatus (bNotDeprecated),
                                                                             new ValidationExecutorXSD (new ValidationArtefact (EValidationType.XSD,
                                                                                                                                aResList.getLastOrNull ()),
                                                                                                        () -> aCustomSchemaCache.getSchema (aResList))));
    }
  }
}
