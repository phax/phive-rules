/*
 * Copyright (C) 2014-2026 Philip Helger (www.helger.com)
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
package com.helger.phive.peppol;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.util.Locale;

import org.jspecify.annotations.NonNull;
import org.junit.Test;

import com.helger.diagnostics.error.list.ErrorList;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.file.SimpleFileIO;
import com.helger.phive.api.execute.ValidationExecutionManager;
import com.helger.phive.api.executorset.IValidationExecutorSet;
import com.helger.phive.api.result.ValidationResultList;
import com.helger.phive.api.validity.IValidityDeterminator;
import com.helger.phive.peppol.mock.CTestFiles;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xml.source.ValidationSourceXML;
import com.helger.xml.serialize.read.DOMReader;

/**
 * Test class for class {@link PeppolValidationSbdhEnvelope2026_05} with documents that must fail.
 *
 * @author Philip Helger
 */
public final class PeppolValidationSbdhEnvelope2026_05Test
{
  private static final String BASE_PATH = "src/test/resources/external/test-files/openpeppol/2026.5/";
  private static final String SUPPLIER = "0088:9482348239847239874";
  private static final String CUSTOMER = "0002:FR23342";

  @NonNull
  private static String _read (@NonNull final String sFilename)
  {
    final String ret = SimpleFileIO.getFileAsString (new File (BASE_PATH + sFilename), StandardCharsets.UTF_8);
    assertNotNull (sFilename, ret);
    return ret;
  }

  @NonNull
  private static ErrorList _validate (@NonNull final DVRCoordinate aVESID, @NonNull final String sXML)
  {
    final IValidationExecutorSet <IValidationSourceXML> aVES = CTestFiles.VES_REGISTRY.getOfID (aVESID);
    assertNotNull (aVES);
    final ValidationResultList aResults = ValidationExecutionManager.executeValidation (IValidityDeterminator.createDefault (),
                                                                                        aVES,
                                                                                        ValidationSourceXML.create (null,
                                                                                                                    DOMReader.readXMLDOM (sXML)));
    return aResults.getAllErrors ();
  }

  private static boolean _containsText (@NonNull final ErrorList aErrors, @NonNull final String sText)
  {
    return aErrors.containsAny (x -> x.getErrorText (Locale.US).contains (sText));
  }

  @Test
  public void testValid ()
  {
    ErrorList aErrors = _validate (PeppolValidationSbdhEnvelope2026_05.VID_SBDH_INVOICE,
                                   _read ("sbdh/sbdh-base-example.xml"));
    assertTrue (aErrors.toString (), aErrors.isEmpty ());

    aErrors = _validate (PeppolValidationSbdhEnvelope2026_05.VID_SBDH_INVOICE_SELF_BILLING,
                         _read ("sbdh/sbdh-SB-base-example.xml"));
    assertTrue (aErrors.toString (), aErrors.isEmpty ());
  }

  @Test
  public void testReceiverMismatch ()
  {
    // Receiver is not the customer
    final String sXML = _read ("sbdh/sbdh-base-example.xml").replace (">" + CUSTOMER + "</Identifier>",
                                                                      ">0002:FR99999</Identifier>");
    final ErrorList aErrors = _validate (PeppolValidationSbdhEnvelope2026_05.VID_SBDH_INVOICE, sXML);
    assertEquals (aErrors.toString (), 1, aErrors.size ());
    assertTrue (aErrors.toString (), _containsText (aErrors, "[BR-SBDH-1]"));
  }

  @Test
  public void testSelfBillingWithBillingRoles ()
  {
    // Sender and receiver swapped, as they would be for regular billing
    final String sXML = _read ("sbdh/sbdh-SB-base-example.xml").replace (">" + CUSTOMER + "</Identifier>",
                                                                         ">TMP</Identifier>")
                                                               .replace (">" + SUPPLIER + "</Identifier>",
                                                                         ">" + CUSTOMER + "</Identifier>")
                                                               .replace (">TMP</Identifier>",
                                                                         ">" + SUPPLIER + "</Identifier>");
    final ErrorList aErrors = _validate (PeppolValidationSbdhEnvelope2026_05.VID_SBDH_INVOICE_SELF_BILLING, sXML);
    assertEquals (aErrors.toString (), 2, aErrors.size ());
    assertTrue (aErrors.toString (), _containsText (aErrors, "[BR-SBDH-3]"));
    assertTrue (aErrors.toString (), _containsText (aErrors, "[BR-SBDH-4]"));
  }

  @Test
  public void testMissingEnvelope ()
  {
    // The business document is valid, but not enveloped
    final ErrorList aErrors = _validate (PeppolValidationSbdhEnvelope2026_05.VID_SBDH_INVOICE,
                                         _read ("billing/base-example.xml"));
    assertTrue (aErrors.toString (), aErrors.isNotEmpty ());
  }

  @Test
  public void testWrongPayload ()
  {
    // A Credit Note inside the envelope, validated as Invoice
    final ErrorList aErrors = _validate (PeppolValidationSbdhEnvelope2026_05.VID_SBDH_INVOICE,
                                         _read ("sbdh/sbdh-base-creditnote-correction.xml"));
    assertTrue (aErrors.toString (), _containsText (aErrors, "minimum number of result nodes"));
  }

  @Test
  public void testInvalidPayload ()
  {
    // Remove the mandatory BuyerReference/OrderReference - the BIS rules of the payload must fire
    final String sXML = _read ("sbdh/sbdh-base-example.xml").replaceAll ("<cbc:BuyerReference>[^<]*</cbc:BuyerReference>",
                                                                         "");
    final ErrorList aErrors = _validate (PeppolValidationSbdhEnvelope2026_05.VID_SBDH_INVOICE, sXML);
    assertEquals (aErrors.toString (), 1, aErrors.size ());
    assertEquals (aErrors.toString (), "PEPPOL-EN16931-R003", aErrors.getFirstOrNull ().getErrorID ());
  }
}
