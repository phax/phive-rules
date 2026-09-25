/*
 * Copyright (C) 2026 Philip Helger (www.helger.com)
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
package com.helger.phive.singapore.mock;

import static org.junit.Assert.assertTrue;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.annotation.style.ReturnsMutableCopy;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.collection.commons.CommonsArrayList;
import com.helger.collection.commons.CommonsHashSet;
import com.helger.collection.commons.ICommonsList;
import com.helger.collection.commons.ICommonsSet;
import com.helger.diver.api.coord.DVRCoordinate;
import com.helger.io.resource.ClassPathResource;
import com.helger.io.resource.IReadableResource;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.api.mock.PhiveTestFile;
import com.helger.phive.singapore.SingaporeIRASValidation;
import com.helger.phive.xml.source.IValidationSourceXML;

@Immutable
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    SingaporeIRASValidation.initSingaporeIRAS (VES_REGISTRY);
  }

  private static final String PREFIX = "/external/test-files/invoicenow-gst/2026.9.8/";

  private CTestFiles ()
  {}

  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <PhiveTestFile> getAllTestFiles ()
  {
    final ICommonsList <PhiveTestFile> ret = new CommonsArrayList <> ();
    for (final DVRCoordinate aVESID : new DVRCoordinate [] { SingaporeIRASValidation.VID_SG_IRAS_INVOICENOW_GST_2026_9_8 })
    {
      for (final IReadableResource aRes : getAllMatchingTestFiles (aVESID))
      {
        assertTrue ("Not existing good test file: " + aRes.getPath (), aRes.exists ());
        ret.add (PhiveTestFile.createGoodCase (aRes, aVESID));
      }
      for (final IReadableResource aRes : getAllBadTestFiles (aVESID))
      {
        assertTrue ("Not existing bad test file: " + aRes.getPath (), aRes.exists ());
        ret.add (new PhiveTestFile (aRes, aVESID, _getExpectedErrorIDs (aRes)));
      }
    }
    return ret;
  }

  /**
   * What each of the negative samples is expected to trip. <code>XSD</code> means the document is
   * already structurally invalid, so the XML Schema layer stops the validation before the
   * Schematron layer is reached.
   *
   * @param aRes
   *        The bad test file resource
   * @return The set of expected error IDs. Never <code>null</code> nor empty.
   */
  @NonNull
  private static ICommonsSet <String> _getExpectedErrorIDs (@NonNull final IReadableResource aRes)
  {
    final String sFilename = aRes.getPath ();
    // Misses the Invoice note (IRASC5-072) and the Preceding Invoice number - the latter is a
    // mandatory UBL element, so the XSD layer already fails
    if (sFilename.endsWith ("B_cr_invalid.xml"))
      return new CommonsHashSet <> ("XSD");
    if (sFilename.endsWith ("Bulk_invalid_2.xml"))
      return new CommonsHashSet <> ("IRASC5-023");
    // Misses the SBDH Receiver (IRASC5-002), which is mandatory in the SBDH 1.3 XML Schema too
    if (sFilename.endsWith ("C_sti_invalid.xml"))
      return new CommonsHashSet <> ("XSD");
    // Misses the Invoice number (IRASC5-007), which is mandatory in UBL too
    if (sFilename.endsWith ("D_invoice_purchase_invalid.xml"))
      return new CommonsHashSet <> ("XSD");
    if (sFilename.endsWith ("E_cr_purchas_invalid.xml"))
      return new CommonsHashSet <> ("IRASC5-008");
    // Not an SBDH envelope at all
    if (sFilename.endsWith ("bare-ubl-invoice.xml"))
      return new CommonsHashSet <> ("XSD");
    // The second of the two contained Invoices misses the Invoice number
    if (sFilename.endsWith ("bulk-second-invoice-no-id.xml"))
      return new CommonsHashSet <> ("XSD");

    throw new IllegalArgumentException ("Unknown bad test file: " + sFilename);
  }

  /**
   * Test files that are expected to validate cleanly (no error) for the given VES coordinate. Add
   * new positive samples here.
   *
   * @param aVESID
   *        VESID
   * @return List of all matching test files. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@NonNull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "DVRCoordinate");

    if (aVESID.equals (SingaporeIRASValidation.VID_SG_IRAS_INVOICENOW_GST_2026_9_8))
    {
      // "B_invalid_sender.xml" and "Bulk_invalid_1.xml" are negative cases of the IRAS
      // accreditation test script, but what makes them invalid (a Sender identifier that is not the
      // accredited one, and bulk document UUIDs that do not match the payload) is checked by the
      // IRAS backend and not by the Schematron. They are good cases here.
      return new CommonsArrayList <> (new String [] { "A_cr.xml",
                                                      "A_cr_BIS.xml",
                                                      "A_invoice.xml",
                                                      "A_invoice_1.xml",
                                                      "A_invoice_2.xml",
                                                      "A_invoice_BIS.xml",
                                                      "B_cr.xml",
                                                      "B_invalid_sender.xml",
                                                      "B_invoice.xml",
                                                      "Bulk_cr.xml",
                                                      "Bulk_invalid_1.xml",
                                                      "Bulk_invoice.xml",
                                                      "C_pos.xml",
                                                      "D_cr_purchase.xml",
                                                      "D_invoice_purchase.xml",
                                                      "E_cr_purchase.xml",
                                                      "E_invoice_purchase.xml",
                                                      "F_pcp.xml" },
                                      s -> new ClassPathResource (PREFIX + s));
    }

    throw new IllegalArgumentException ("Invalid DVRCoordinate: " + aVESID);
  }

  /**
   * Test files that are expected to fail validation (at least one error) for the given VES
   * coordinate. These are the negative samples of the IRAS accreditation test script plus two
   * derived ones. Add new negative samples here.
   *
   * @param aVESID
   *        VESID to get files
   * @return The list of all matching test files. Never <code>null</code>.
   */
  @NonNull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllBadTestFiles (@NonNull final DVRCoordinate aVESID)
  {
    ValueEnforcer.notNull (aVESID, "DVRCoordinate");

    if (aVESID.equals (SingaporeIRASValidation.VID_SG_IRAS_INVOICENOW_GST_2026_9_8))
    {
      final ICommonsList <IReadableResource> ret = new CommonsArrayList <> (new String [] { "B_cr_invalid.xml",
                                                                                            "Bulk_invalid_2.xml",
                                                                                            "C_sti_invalid.xml",
                                                                                            "D_invoice_purchase_invalid.xml",
                                                                                            "E_cr_purchas_invalid.xml" },
                                                                            s -> new ClassPathResource (PREFIX + s));
      // Not from IRAS - derived from the samples above to pin down the two things the partial XML
      // Schema layer adds: the SBDH envelope is mandatory, and every payload of a bulk submission
      // is validated, not just the first one
      ret.addAll (new CommonsArrayList <> (new String [] { "bare-ubl-invoice.xml",
                                                           "bulk-second-invoice-no-id.xml" },
                                           s -> new ClassPathResource (PREFIX + "derived/" + s)));
      return ret;
    }

    throw new IllegalArgumentException ("Invalid DVRCoordinate: " + aVESID);
  }
}
