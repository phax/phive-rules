/**
 * Copyright (C) 2014-2020 Philip Helger (www.helger.com)
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
package com.helger.phive.svefaktura;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSet;
import com.helger.phive.engine.schematron.ValidationExecutorSchematron;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.engine.xsd.ValidationExecutorXSD;
import com.helger.xml.namespace.IIterableNamespaceContext;
import com.helger.xml.namespace.MapBasedNamespaceContext;

/**
 * Generic Svefaktura validation configuration
 *
 * @author Philip Helger
 */
@Immutable
public final class SvefakturaValidation
{
  public static final String GROUP_ID = "se.sfti";

  public static final VESID VID_SVEFAKTURA_10 = new VESID (GROUP_ID, "svefaktura", "1.0");
  public static final VESID VID_OBJECT_ENVELOPE_10 = new VESID (GROUP_ID, "object-envelope", "1.0");

  private SvefakturaValidation ()
  {}

  private static final IIterableNamespaceContext NS_CTX = new MapBasedNamespaceContext ().addMapping ("bi",
                                                                                                      "urn:sfti:documents:BasicInvoice:1:0")
                                                                                         .addMapping ("oe",
                                                                                                      "urn:sfti:documents:ObjectEnvelope:1:0")
                                                                                         .addMapping ("ccts",
                                                                                                      "urn:oasis:names:tc:ubl:CoreComponentParameters:1:0")
                                                                                         .addMapping ("cac",
                                                                                                      "urn:oasis:names:tc:ubl:CommonAggregateComponents:1:0")
                                                                                         .addMapping ("cbc",
                                                                                                      "urn:oasis:names:tc:ubl:CommonBasicComponents:1:0")
                                                                                         .addMapping ("scac",
                                                                                                      "urn:sfti:CommonAggregateComponents:1:0")
                                                                                         .addMapping ("ud",
                                                                                                      "urn:oasis:names:tc:ubl:UnspecializedDatatypes:1:0")
                                                                                         .addMapping ("sd",
                                                                                                      "urn:oasis:names:tc:ubl:SpecializedDatatypes:1:0")
                                                                                         .addMapping ("cur",
                                                                                                      "urn:oasis:names:tc:ubl:codelist:CurrencyCode:1:0");

  @Nonnull
  private static ClassLoader _getCL ()
  {
    return SvefakturaValidation.class.getClassLoader ();
  }

  @Nonnull
  private static ValidationExecutorSchematron _createXSLT (@Nonnull final ClassPathResource aRes)
  {
    return ValidationExecutorSchematron.createXSLT (aRes, NS_CTX);
  }

  /**
   * Register all standard Svefaktura validation execution sets to the provided
   * registry.
   *
   * @param aRegistry
   *        The registry to add the artefacts. May not be <code>null</code>.
   */
  public static void initSvefaktura (@Nonnull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    final boolean bNotDeprecated = false;

    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_SVEFAKTURA_10,
                                                                           "SvefakturaXML " + VID_SVEFAKTURA_10.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (new ClassPathResource ("/schemas/1.0/maindoc/SFTI-BasicInvoice-1.0.xsd",
                                                                                                                                _getCL ())),
                                                                           _createXSLT (new ClassPathResource ("/schemas/1.0/svenfaktura-1.0-sch.xslt",
                                                                                                               _getCL ()))));

    // No Schematrons here
    aRegistry.registerValidationExecutorSet (ValidationExecutorSet.create (VID_OBJECT_ENVELOPE_10,
                                                                           "SvefakturaXML ObjectEnvelope " +
                                                                                                   VID_OBJECT_ENVELOPE_10.getVersion (),
                                                                           bNotDeprecated,
                                                                           ValidationExecutorXSD.create (new ClassPathResource ("/schemas/1.0/maindoc/SFTI-ObjectEnvelope-1.0.xsd",
                                                                                                                                _getCL ()))));
  }
}
