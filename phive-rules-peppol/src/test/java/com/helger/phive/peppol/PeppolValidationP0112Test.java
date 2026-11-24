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

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.nio.charset.StandardCharsets;

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
 * Test rule PEPPOL-EN16931-P0112 as changed by the BIS Billing 3.0.22 hotfix: invoice type code 384
 * is allowed for domestic German and domestic Slovak invoices only.
 *
 * @author Philip Helger
 */
public final class PeppolValidationP0112Test
{
  private static final String RULE_ID = "PEPPOL-EN16931-P0112";

  @NonNull
  private static String _createInvoice (@NonNull final String sVersion,
                                        @NonNull final String sTypeCode,
                                        @NonNull final String sSupplierCountry,
                                        @NonNull final String sCustomerCountry)
  {
    final String sXML = SimpleFileIO.getFileAsString (new File ("src/test/resources/external/test-files/openpeppol/" +
                                                                sVersion +
                                                                "/billing/base-example.xml"),
                                                      StandardCharsets.UTF_8);
    assertNotNull (sXML);
    // DE is determined from the postal address, SK from the VAT identifier prefix - set both
    return sXML.replace ("<cbc:IdentificationCode>GB</cbc:IdentificationCode>",
                         "<cbc:IdentificationCode>" + sSupplierCountry + "</cbc:IdentificationCode>")
               .replaceFirst ("<cbc:IdentificationCode>SE</cbc:IdentificationCode>",
                              "<cbc:IdentificationCode>" + sCustomerCountry + "</cbc:IdentificationCode>")
               .replace ("<cbc:InvoiceTypeCode>380</cbc:InvoiceTypeCode>",
                         "<cbc:InvoiceTypeCode>" + sTypeCode + "</cbc:InvoiceTypeCode>")
               .replace ("<cbc:CompanyID>GB1232434</cbc:CompanyID>",
                         "<cbc:CompanyID>" + sSupplierCountry + "1232434</cbc:CompanyID>")
               .replace ("<cbc:CompanyID>SE4598375937</cbc:CompanyID>",
                         "<cbc:CompanyID>" + sCustomerCountry + "4598375937</cbc:CompanyID>");
  }

  private static boolean _hasP0112 (@NonNull final DVRCoordinate aVESID, @NonNull final String sXML)
  {
    final IValidationExecutorSet <IValidationSourceXML> aVES = CTestFiles.VES_REGISTRY.getOfID (aVESID);
    assertNotNull (aVES);
    final ValidationResultList aResults = ValidationExecutionManager.executeValidation (IValidityDeterminator.createDefault (),
                                                                                        aVES,
                                                                                        ValidationSourceXML.create (null,
                                                                                                                    DOMReader.readXMLDOM (sXML)));
    final ErrorList aErrors = aResults.getAllErrors ();
    return aErrors.containsAny (x -> RULE_ID.equals (x.getErrorID ()));
  }

  private static void _testRelease (@NonNull final String sVersion, @NonNull final DVRCoordinate aVESID)
  {
    // Allowed
    assertFalse (_hasP0112 (aVESID, _createInvoice (sVersion, "384", "DE", "DE")));
    assertFalse (_hasP0112 (aVESID, _createInvoice (sVersion, "384", "SK", "SK")));
    assertFalse (_hasP0112 (aVESID, _createInvoice (sVersion, "380", "SK", "DE")));

    // Not allowed
    assertTrue (_hasP0112 (aVESID, _createInvoice (sVersion, "384", "SK", "DE")));
    assertTrue (_hasP0112 (aVESID, _createInvoice (sVersion, "384", "GB", "SE")));
    assertTrue (_hasP0112 (aVESID, _createInvoice (sVersion, "326", "SK", "SK")));
  }

  @Test
  public void testHotfix2026_05 ()
  {
    _testRelease (PeppolValidation2026_05.VERSION_STR, PeppolValidation2026_05.VID_OPENPEPPOL_INVOICE_UBL_V3);
  }

  @Test
  public void test2026_11 ()
  {
    _testRelease (PeppolValidation2026_11.VERSION_STR, PeppolValidation2026_11.VID_OPENPEPPOL_INVOICE_UBL_V3);
  }
}
