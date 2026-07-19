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
package com.helger.phive.rules.all;

import org.jspecify.annotations.NonNull;

import com.helger.annotation.concurrent.Immutable;
import com.helger.base.enforce.ValueEnforcer;
import com.helger.phive.api.executorset.IValidationExecutorSetRegistry;
import com.helger.phive.cii.CIIValidation;
import com.helger.phive.ciuspt.CIUS_PTValidation;
import com.helger.phive.ciusro.CIUS_ROValidation;
import com.helger.phive.ebinterface.EbInterfaceValidation;
import com.helger.phive.ehf.EHFValidation;
import com.helger.phive.en16931.EN16931Validation;
import com.helger.phive.energieefactuur.EnergieEFactuurValidation;
import com.helger.phive.eracun.HReRacunValidation;
import com.helger.phive.facturae.FacturaeValidation;
import com.helger.phive.fatturapa.FatturaPAValidation;
import com.helger.phive.finvoice.FinvoiceValidation;
import com.helger.phive.france.FranceCTCValidation;
import com.helger.phive.isdoc.ISDOCValidation;
import com.helger.phive.ksef.KSeFValidation;
import com.helger.phive.oioubl.OIOUBLValidation;
import com.helger.phive.osa.OSAValidation;
import com.helger.phive.peppol.PeppolValidation;
import com.helger.phive.peppol.italy.PeppolItalyValidation;
import com.helger.phive.peppol.taxdata.PeppolValidationTaxData;
import com.helger.phive.serbia.SEOValidation;
import com.helger.phive.serbia.SRBDTValidation;
import com.helger.phive.setu.SETUValidation;
import com.helger.phive.simplerinvoicing.SimplerInvoicingValidation;
import com.helger.phive.svefaktura.SvefakturaValidation;
import com.helger.phive.teapps.TEAPPSValidation;
import com.helger.phive.turkey.TurkeyEFaturaValidation;
import com.helger.phive.ubl.UBLValidation;
import com.helger.phive.ublbe.UBLBEValidation;
import com.helger.phive.xml.source.IValidationSourceXML;
import com.helger.phive.xrechnung.XRechnungValidation;
import com.helger.phive.zatca.ZATCAValidation;
import com.helger.phive.zugferd.ZugferdValidation;

/**
 * Convenience class to register the validation execution sets of all phive rules modules in a
 * single call.
 *
 * @author Philip Helger
 */
@Immutable
public final class PhiveRulesValidation
{
  private PhiveRulesValidation ()
  {}

  /**
   * Register all supported validation execution sets of all current (non-legacy) phive rules
   * modules to the provided registry, in the proper order. The legacy validation execution sets are
   * available separately via
   * {@code com.helger.phive.rules.all.legacy.PhiveRulesLegacyValidation#initPhiveRulesLegacy}.
   *
   * @param aRegistry
   *        The registry to add the artefacts to. May not be <code>null</code>.
   */
  public static void initPhiveRules (@NonNull final IValidationExecutorSetRegistry <IValidationSourceXML> aRegistry)
  {
    ValueEnforcer.notNull (aRegistry, "Registry");

    // Must be first
    EN16931Validation.initEN16931 (aRegistry);
    // The rest in alphabetical order, except where explicitly stated
    CIIValidation.initCII (aRegistry);
    CIUS_PTValidation.initCIUS_PT (aRegistry);
    CIUS_ROValidation.initCIUS_RO (aRegistry);
    EbInterfaceValidation.initEbInterface (aRegistry);
    EHFValidation.initEHF (aRegistry);
    FacturaeValidation.initFacturae (aRegistry);
    FatturaPAValidation.initFatturaPA (aRegistry);
    FinvoiceValidation.initFinvoice (aRegistry);
    FranceCTCValidation.initFranceCTC (aRegistry);
    HReRacunValidation.init (aRegistry);
    KSeFValidation.initKSeF (aRegistry);
    ISDOCValidation.initISDOC (aRegistry);
    OIOUBLValidation.initOIOUBL (aRegistry);
    OSAValidation.initOSA (aRegistry);
    PeppolItalyValidation.init (aRegistry);
    PeppolValidation.initStandard (aRegistry);
    PeppolValidationTaxData.init (aRegistry);
    SEOValidation.initSEO (aRegistry);
    SRBDTValidation.initSRBDT (aRegistry);
    SETUValidation.initSETU (aRegistry);
    SimplerInvoicingValidation.initSimplerInvoicing (aRegistry);
    // Must be after SimplerInvoicing
    EnergieEFactuurValidation.initEnergieEFactuur (aRegistry);
    SvefakturaValidation.initSvefaktura (aRegistry);
    TEAPPSValidation.initTEAPPS (aRegistry);
    TurkeyEFaturaValidation.initTurkeyEFatura (aRegistry);
    UBLValidation.initUBLAllVersions (aRegistry);
    UBLBEValidation.initUBLBE (aRegistry);
    XRechnungValidation.initXRechnung (aRegistry);
    ZATCAValidation.initZATCA (aRegistry);
    ZugferdValidation.initZugferd (aRegistry);
  }
}
