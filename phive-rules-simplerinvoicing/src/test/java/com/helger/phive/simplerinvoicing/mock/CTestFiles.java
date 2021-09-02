/**
 * Copyright (C) 2014-2021 Philip Helger (www.helger.com)
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
package com.helger.phive.simplerinvoicing.mock;

import javax.annotation.Nonnull;
import javax.annotation.concurrent.Immutable;

import com.helger.commons.ValueEnforcer;
import com.helger.commons.annotation.ReturnsMutableCopy;
import com.helger.commons.collection.impl.CommonsArrayList;
import com.helger.commons.collection.impl.ICommonsList;
import com.helger.commons.io.resource.ClassPathResource;
import com.helger.commons.io.resource.IReadableResource;
import com.helger.phive.api.executorset.VESID;
import com.helger.phive.api.executorset.ValidationExecutorSetRegistry;
import com.helger.phive.engine.mock.MockFile;
import com.helger.phive.engine.source.IValidationSourceXML;
import com.helger.phive.simplerinvoicing.SimplerInvoicingValidation;

@Immutable
@SuppressWarnings ("deprecation")
public final class CTestFiles
{
  public static final ValidationExecutorSetRegistry <IValidationSourceXML> VES_REGISTRY = new ValidationExecutorSetRegistry <> ();
  static
  {
    SimplerInvoicingValidation.initSimplerInvoicing (VES_REGISTRY);
  }

  private CTestFiles ()
  {}

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <MockFile> getAllTestFiles ()
  {
    final ICommonsList <MockFile> ret = new CommonsArrayList <> ();
    for (final VESID aVESID : new VESID [] { SimplerInvoicingValidation.VID_SI_INVOICE_V10,
                                             SimplerInvoicingValidation.VID_SI_INVOICE_V11,
                                             SimplerInvoicingValidation.VID_SI_INVOICE_V12,
                                             SimplerInvoicingValidation.VID_SI_ORDER_V12,
                                             SimplerInvoicingValidation.VID_SI_INVOICE_V123,
                                             SimplerInvoicingValidation.VID_SI_ORDER_V123,
                                             SimplerInvoicingValidation.VID_SI_INVOICE_V20,
                                             SimplerInvoicingValidation.VID_SI_CREDIT_NOTE_V20,
                                             SimplerInvoicingValidation.VID_SI_INVOICE_V201,
                                             SimplerInvoicingValidation.VID_SI_CREDIT_NOTE_V201,
                                             SimplerInvoicingValidation.VID_SI_INVOICE_V202,
                                             SimplerInvoicingValidation.VID_SI_CREDIT_NOTE_V202,
                                             SimplerInvoicingValidation.VID_SI_INVOICE_V203,
                                             SimplerInvoicingValidation.VID_SI_CREDIT_NOTE_V203,
                                             SimplerInvoicingValidation.VID_SI_INVOICE_V2031,
                                             SimplerInvoicingValidation.VID_SI_CREDIT_NOTE_V2031,
                                             SimplerInvoicingValidation.VID_SI_INVOICE_20_GACCOUNT_V10,
                                             SimplerInvoicingValidation.VID_SI_INVOICE_20_GACCOUNT_V101,
                                             SimplerInvoicingValidation.VID_SI_NLCIUS_CII_V103 })
      for (final IReadableResource aRes : getAllMatchingTestFiles (aVESID))
        ret.add (MockFile.createGoodCase (aRes, aVESID));

    return ret;
  }

  @Nonnull
  @ReturnsMutableCopy
  public static ICommonsList <? extends IReadableResource> getAllMatchingTestFiles (@Nonnull final VESID aVESID)
  {
    ValueEnforcer.notNull (aVESID, "VESID");

    final String sPath10 = "/test-files/simplerinvoicing/SI-UBL-1.0/";
    final String sPath11 = "/test-files/simplerinvoicing/SI-UBL-1.1/";
    final String sPath12 = "/test-files/simplerinvoicing/SI-UBL-1.2/";
    final String sPath200 = "/test-files/simplerinvoicing/SI-UBL-2.0/";
    final String sPath202 = "/test-files/simplerinvoicing/SI-UBL-2.0.2/";
    final String sPath203 = "/test-files/simplerinvoicing/SI-UBL-2.0.3/";
    final String sPathGAccount10 = "/test-files/simplerinvoicing/si-ubl-2.0-ext-gaccount-1.0/";

    final ICommonsList <IReadableResource> ret = new CommonsArrayList <> ();
    if (aVESID.equals (SimplerInvoicingValidation.VID_SI_INVOICE_V10))
    {
      final String sPath = sPath10;
      ret.add (new ClassPathResource (sPath + "SI-UBL-1.0-ok-minimal.xml"));
      ret.add (new ClassPathResource (sPath + "SI-UBL-1.0-ok-reference.xml"));
      ret.add (new ClassPathResource (sPath + "SI-UBL-1.0-ok.xml"));
    }
    else
      if (aVESID.equals (SimplerInvoicingValidation.VID_SI_INVOICE_V11))
      {
        final String sPath = sPath11;
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-BII2-T10-R034.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-BII2-T10-R035.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-BII2-T10-R037.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-BII2-T10-R045.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-BII2-T10-R046.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-EUGEN-T10-R026.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-EUGEN-T10-R030.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-EUGEN-T10-R035.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-EUGEN-T10-R036.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-EUGEN-T10-R037.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-EUGEN-T10-R038.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-extension.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-full-multiple-currencies.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-full-single-currency.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-full-tax-currency.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-full-tax-subcategory.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-full.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-minimal-corrective.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-minimal.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-reference.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-rounding-vat-1.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-single-item.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-taxes-ae.xml"));
        ret.add (new ClassPathResource (sPath + "SI-UBL-1.1-ok-taxes.xml"));
      }
      else
        if (aVESID.equals (SimplerInvoicingValidation.VID_SI_INVOICE_V12) || aVESID.equals (SimplerInvoicingValidation.VID_SI_INVOICE_V123))
        {
          final String sPath = sPath12;
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-BII2-T10-R034.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-BII2-T10-R035.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-BII2-T10-R037.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-BII2-T10-R045.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-BII2-T10-R046.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-EUGEN-T10-R026.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-EUGEN-T10-R030.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-EUGEN-T10-R035.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-EUGEN-T10-R036.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-EUGEN-T10-R037.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-EUGEN-T10-R038.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-extension.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-full-multiple-currencies.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-full-single-currency.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-full-tax-currency.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-full-tax-subcategory.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-full.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-minimal-corrective.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-minimal.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-reference.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-rounding-vat-1.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-si-extension-1.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-si-extension-2.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-si-extension-3.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-si-extension.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-single-item.xml"));
          ret.add (new ClassPathResource (sPath + "SI-UBL-INV-1.2-ok-taxes-ae.xml"));
        }
        else
          if (aVESID.equals (SimplerInvoicingValidation.VID_SI_ORDER_V12) || aVESID.equals (SimplerInvoicingValidation.VID_SI_ORDER_V123))
          {
            final String sPath = sPath12;
            ret.add (new ClassPathResource (sPath + "SI-UBL-PO-1.2-ok-minimal.xml"));
          }
          else
            if (aVESID.equals (SimplerInvoicingValidation.VID_SI_INVOICE_V20))
            {
              final String sPath = sPath200;
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-10_ok_both_nl.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-10_ok_customer_not_nl.xml"));
              if (false)
                ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-10_ok_customer_no_companyid.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-10_ok_supplier_not_nl.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-11_ok_negative_payment.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-11_ok_no_payment.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-12_ok.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-1_ok_supplier_not_nl.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-1_ok_supplier_oin.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-2_ok_supplier_not_nl.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-31_ok_notsepa.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-3_ok_not_nl.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-4_ok_customer_not_nl.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-4_ok_supplier_not_nl.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-5_ok.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-5_ok_supplier_not_nl.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-5_ok_taxpart_not_nl.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-7_ok_384.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-7_ok_389.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-9_ok.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_additionaldocumentreference.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_allowance.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_allowance_line.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_base.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_charge.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_charge_line.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_full.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_quantities_linevalues_wrong.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_quantities.xml"));
              ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_unitcode.xml"));
            }
            else
              if (aVESID.equals (SimplerInvoicingValidation.VID_SI_CREDIT_NOTE_V20))
              {
                final String sPath = sPath200;
                ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-8_ok_381.xml"));
              }
              else
                if (aVESID.equals (SimplerInvoicingValidation.VID_SI_INVOICE_V201) ||
                    aVESID.equals (SimplerInvoicingValidation.VID_SI_INVOICE_V202))
                {
                  final String sPath = sPath202;
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-10_ok_both_nl.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-10_ok_customer_not_nl.xml"));
                  if (false)
                    ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-10_ok_customer_no_companyid.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-10_ok_supplier_not_nl.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-11_ok_negative_payment.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-11_ok_no_payment.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-12_ok.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-1_ok_supplier_not_nl.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-1_ok_supplier_oin.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-2_ok_supplier_not_nl.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-31_ok_notsepa.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-3_ok_not_nl.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-4_ok_customer_not_nl.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-4_ok_supplier_not_nl.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-5_ok.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-5_ok_supplier_not_nl.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-5_ok_taxpart_not_nl.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-7_ok_384.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-7_ok_389.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-9_ok.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_additionaldocumentreference.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_allowance.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_allowance_line.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_base.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_charge.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_charge_line.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_full.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_quantities_linevalues_wrong.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_quantities.xml"));
                  ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_ok_unitcode.xml"));
                }
                else
                  if (aVESID.equals (SimplerInvoicingValidation.VID_SI_CREDIT_NOTE_V201) ||
                      aVESID.equals (SimplerInvoicingValidation.VID_SI_CREDIT_NOTE_V202))
                  {
                    final String sPath = sPath202;
                    ret.add (new ClassPathResource (sPath + "SI-UBL-2.0_BR-NL-8_ok_381.xml"));
                  }
                  else
                    if (aVESID.equals (SimplerInvoicingValidation.VID_SI_INVOICE_V203) ||
                        aVESID.equals (SimplerInvoicingValidation.VID_SI_INVOICE_V2031))
                    {
                      for (final String s : new String [] { "SI-UBL-2.0_BR-NL-10_ok_both_nl.xml",
                                                            "SI-UBL-2.0_BR-NL-10_ok_customer_not_nl.xml",
                                                            "SI-UBL-2.0_BR-NL-10_ok_customer_not_nl_no_companyid.xml",
                                                            "SI-UBL-2.0_BR-NL-10_ok_supplier_not_nl.xml",
                                                            "SI-UBL-2.0_BR-NL-11_ok_negative_payment.xml",
                                                            "SI-UBL-2.0_BR-NL-11_ok_no_payment.xml",
                                                            "SI-UBL-2.0_BR-NL-12_ok.xml",
                                                            "SI-UBL-2.0_BR-NL-13_ok.xml",
                                                            "SI-UBL-2.0_BR-NL-19_warning_tax_currency.xml",
                                                            "SI-UBL-2.0_BR-NL-1_ok_supplier_not_nl.xml",
                                                            "SI-UBL-2.0_BR-NL-1_ok_supplier_oin.xml",
                                                            "SI-UBL-2.0_BR-NL-20_warning_taxpointdate.xml",
                                                            "SI-UBL-2.0_BR-NL-21_warning_descriptioncode.xml",
                                                            "SI-UBL-2.0_BR-NL-24_warning_ref_issuedate.xml",
                                                            "SI-UBL-2.0_BR-NL-25_warning_companyid_novat.xml",
                                                            "SI-UBL-2.0_BR-NL-26_warning_legalform.xml",
                                                            "SI-UBL-2.0_BR-NL-27_warning_addressline_customer.xml",
                                                            "SI-UBL-2.0_BR-NL-27_warning_addressline_delivery.xml",
                                                            "SI-UBL-2.0_BR-NL-27_warning_addressline_representative.xml",
                                                            "SI-UBL-2.0_BR-NL-27_warning_addressline_seller.xml",
                                                            "SI-UBL-2.0_BR-NL-28_warning_countrysub_customer.xml",
                                                            "SI-UBL-2.0_BR-NL-28_warning_countrysub_delivery.xml",
                                                            "SI-UBL-2.0_BR-NL-28_warning_countrysub_representative.xml",
                                                            "SI-UBL-2.0_BR-NL-28_warning_countrysub_seller.xml",
                                                            "SI-UBL-2.0_BR-NL-29_warning_paymentmeansname.xml",
                                                            "SI-UBL-2.0_BR-NL-2_ok_supplier_not_nl.xml",
                                                            "SI-UBL-2.0_BR-NL-30_warning_financialaccount.xml",
                                                            "SI-UBL-2.0_BR-NL-31_ok_notsepa.xml",
                                                            "SI-UBL-2.0_BR-NL-31_warning_branchid.xml",
                                                            "SI-UBL-2.0_BR-NL-32_warning_linereasoncode.xml",
                                                            "SI-UBL-2.0_BR-NL-32_warning_reasoncode.xml",
                                                            "SI-UBL-2.0_BR-NL-33_warning_taxcurrency.xml",
                                                            "SI-UBL-2.0_BR-NL-34_warning_reasoncode.xml",
                                                            "SI-UBL-2.0_BR-NL-34_warning_reasoncode_line.xml",
                                                            "SI-UBL-2.0_BR-NL-35_warning_taxexemptionreason.xml",
                                                            "SI-UBL-2.0_BR-NL-3_ok_not_nl.xml",
                                                            "SI-UBL-2.0_BR-NL-4_ok_customer_not_nl.xml",
                                                            "SI-UBL-2.0_BR-NL-4_ok_supplier_not_nl.xml",
                                                            "SI-UBL-2.0_BR-NL-5_ok.xml",
                                                            "SI-UBL-2.0_BR-NL-5_ok_supplier_not_nl.xml",
                                                            "SI-UBL-2.0_BR-NL-5_ok_taxpart_not_nl.xml",
                                                            "SI-UBL-2.0_BR-NL-7_ok_384.xml",
                                                            "SI-UBL-2.0_BR-NL-7_ok_389.xml",
                                                            "SI-UBL-2.0_BR-NL-9_ok.xml",
                                                            "SI-UBL-2.0_ok_additionaldocumentreference.xml",
                                                            "SI-UBL-2.0_ok_allowance.xml",
                                                            "SI-UBL-2.0_ok_allowance_line.xml",
                                                            "SI-UBL-2.0_ok_base.xml",
                                                            "SI-UBL-2.0_ok_charge.xml",
                                                            "SI-UBL-2.0_ok_charge_line.xml",
                                                            "SI-UBL-2.0_ok_full.xml",
                                                            "SI-UBL-2.0_ok_full_negative_zero.xml",
                                                            "SI-UBL-2.0_ok_minimal.xml",
                                                            "SI-UBL-2.0_ok_negative.xml",
                                                            "SI-UBL-2.0_ok_quantities.xml",
                                                            "SI-UBL-2.0_ok_quantities_linevalues_wrong.xml",
                                                            "SI-UBL-2.0_ok_tax_category_O.xml",
                                                            "SI-UBL-2.0_ok_unitcode.xml",
                                                            "SI-UBL-2.0_UBL-CR-561_warning.xml",
                                                            "SI-UBL-2.0_UBL-SR-09_warning_multiple_legalentity_registrationname.xml",
                                                            "SI-UBL-2.0_UBL-SR-11_warning_multiple_legalentity_companyid.xml",
                                                            "SI-UBL-2.0_UBL-SR-15_warning_multiple_legalentity_registrationname.xml",
                                                            "SI-UBL-2.0_UBL-SR-17_warning_multiple_legalentity_companyid.xml",
                                                            "SI-UBL-2.0_warning_empty_elements.xml" })
                        ret.add (new ClassPathResource (sPath203 + s));
                    }
                    else
                      if (aVESID.equals (SimplerInvoicingValidation.VID_SI_CREDIT_NOTE_V203) ||
                          aVESID.equals (SimplerInvoicingValidation.VID_SI_CREDIT_NOTE_V2031) ||
                          aVESID.equals (SimplerInvoicingValidation.VID_SI_CREDIT_NOTE_V2032))
                      {
                        for (final String s : new String [] { "SI-UBL-2.0_BR-NL-8_ok_381.xml" })
                          ret.add (new ClassPathResource (sPath203 + s));
                      }
                      else
                        if (aVESID.equals (SimplerInvoicingValidation.VID_SI_INVOICE_20_GACCOUNT_V10) ||
                            aVESID.equals (SimplerInvoicingValidation.VID_SI_INVOICE_20_GACCOUNT_V101) ||
                            aVESID.equals (SimplerInvoicingValidation.VID_SI_INVOICE_20_GACCOUNT_V102))
                        {
                          for (final String s : new String [] { "si-ubl-2.0-ext-gaccount_ok_sample.xml" })
                            ret.add (new ClassPathResource (sPathGAccount10 + s));
                        }
                        else
                          if (aVESID.equals (SimplerInvoicingValidation.VID_SI_NLCIUS_CII_V103) ||
                              aVESID.equals (SimplerInvoicingValidation.VID_SI_NLCIUS_CII_V1031))
                          {
                            // no test files
                          }
                          else
                            throw new IllegalArgumentException ("Invalid VESID: " + aVESID);
    return ret;
  }
}
