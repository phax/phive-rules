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
import static org.junit.Assert.assertNull;

import org.junit.Test;

import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.xml.source.IValidationSourceXML;

public final class PeppolValidationBillingTest
{
  @Test
  public void testSingleReleaseBillingOnly ()
  {
    final ValidationExecutorSetRegistry <IValidationSourceXML> aRegistry = new ValidationExecutorSetRegistry <> ();
    PeppolValidation2025_05.initBilling (aRegistry);

    assertEquals (2, aRegistry.getAll ().size ());
    assertNotNull (aRegistry.getOfID (PeppolValidation2025_05.VID_OPENPEPPOL_INVOICE_UBL_V3));
    assertNotNull (aRegistry.getOfID (PeppolValidation2025_05.VID_OPENPEPPOL_CREDIT_NOTE_UBL_V3));
    assertNull (aRegistry.getOfID (PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_V3));
    assertNull (aRegistry.getOfID (PeppolValidation2025_05.VID_OPENPEPPOL_ORDER_CHANGE_V3));
  }

  @Test
  public void testAllSupportedBillingOnly ()
  {
    final ValidationExecutorSetRegistry <IValidationSourceXML> aRegistry = new ValidationExecutorSetRegistry <> ();
    PeppolValidationBisEurope.initBilling (aRegistry);

    assertEquals (10, aRegistry.getAll ().size ());
    assertNotNull (aRegistry.getOfID (PeppolValidation2025_11.VID_OPENPEPPOL_INVOICE_UBL_V3));
    assertNotNull (aRegistry.getOfID (PeppolValidation2026_03.VID_OPENPEPPOL_INVOICE_SELF_BILLING_UBL_V3));
    assertNotNull (aRegistry.getOfID (PeppolValidation2026_05.VID_OPENPEPPOL_CREDIT_NOTE_SELF_BILLING_UBL_V3));
    assertNull (aRegistry.getOfID (PeppolValidation2026_05.VID_OPENPEPPOL_ORDER_RESPONSE_ADVANCED_V3));
  }
}
