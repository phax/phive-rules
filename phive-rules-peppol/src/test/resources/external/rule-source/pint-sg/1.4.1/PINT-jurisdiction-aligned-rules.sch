<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" queryBinding="xslt2">
  


  <title>Singapore Specific rules for Billing 3</title>
  <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
  <ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
  <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <ns uri="utils" prefix="u"/>
  <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:slack" as="xs:boolean">
      <param name="exp" as="xs:decimal"/>
      <param name="val" as="xs:decimal"/>
      <param name="slack" as="xs:decimal"/>
      <value-of select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>
  </function>  
  <phase id="EN16931model_phase">
      <active pattern="UBL-model"/>
  </phase>
  <phase id="codelist_phase">
      <active pattern="Codesmodel"/>
  </phase>
  
  
  <pattern id="Peppol_derived">
    
      <rule context="/ubl:Invoice | /cn:CreditNote">
        <assert id="PEPPOL-EN16931-R004-SG" test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:peppol:pint:billing-1@sg-1')" flag="fatal">Specification identifier MUST have the value 'urn:peppol:pint:billing-1@sg-1'.</assert>
         <assert id="PEPPOL-EN16931-R003-SG" test="cbc:BuyerReference or cac:OrderReference/cbc:ID" flag="fatal">A buyer reference or purchase order reference MUST be provided.</assert>
         <assert id="PEPPOL-EN16931-R053-SG" test="count(cac:TaxTotal[cac:TaxSubtotal]) = 1" flag="fatal">Only one tax total with tax subtotals MUST be provided.</assert>
         <assert id="PEPPOL-EN16931-R054-SG" test="count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0)" flag="fatal">Only one tax total without tax subtotals MUST be provided when tax currency code is provided.</assert>
         <assert id="PEPPOL-EN16931-R007-SG" test="normalize-space(cbc:ProfileID/text()) = 'urn:peppol:bis:billing'" flag="fatal">Business process MUST have value 'urn:peppol:bis:billing'.</assert>	 	  
      </rule>
	  
      <rule context="ubl:Invoice/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | cn:CreditNote/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | cn:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]">
         <assert id="PEPPOL-EN16931-R041-SG" test="false()" flag="fatal">Allowance/charge base amount MUST be provided when allowance/charge percentage is provided.</assert>
      </rule>	 
      <rule context="ubl:Invoice/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | cn:CreditNote/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | cn:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]">
         <assert id="PEPPOL-EN16931-R042-SG" test="false()" flag="fatal">Allowance/charge percentage MUST be provided when allowance/charge base amount is provided.</assert>
      </rule>	
      <rule context="ubl:Invoice/cac:AllowanceCharge | ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge | cn:CreditNote/cac:AllowanceCharge | cn:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge">
         <assert id="PEPPOL-EN16931-R040-SG" test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)" flag="fatal">Allowance/charge amount must equal base amount * percentage/100 if base amount and percentage exists</assert>
      </rule>

      <rule context="cac:PaymentMeans[some $code in tokenize('49 59', '\s') satisfies normalize-space(cbc:PaymentMeansCode) = $code]">
         <assert id="PEPPOL-EN16931-R061-SG" test="cac:PaymentMandate/cbc:ID" flag="fatal">Mandate reference MUST be provided for direct debit.</assert>
      </rule>	  
      <rule context="cac:Price/cac:AllowanceCharge">
         <assert id="PEPPOL-EN16931-R046-SG" test="not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)" flag="fatal">Item net price MUST equal (Gross price - Allowance amount) when gross price is provided.</assert>
      </rule>	  

      <rule context="cac:InvoiceLine | cac:CreditNoteLine">	  
         <let name="lineExtensionAmount" value="           if (cbc:LineExtensionAmount) then             xs:decimal(cbc:LineExtensionAmount)           else             0"/>
         <let name="quantity" value="           if (/ubl:Invoice) then             (if (cbc:InvoicedQuantity) then               xs:decimal(cbc:InvoicedQuantity)             else               1)           else             (if (cbc:CreditedQuantity) then               xs:decimal(cbc:CreditedQuantity)             else               1)"/>
         <let name="priceAmount" value="           if (cac:Price/cbc:PriceAmount) then             xs:decimal(cac:Price/cbc:PriceAmount)           else             0"/>
         <let name="baseQuantity" value="           if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then             xs:decimal(cac:Price/cbc:BaseQuantity)           else             1"/>
         <let name="allowancesTotal" value="           if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then             xs:decimal(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount))           else             0"/>
         <let name="chargesTotal" value="           if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then             xs:decimal(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount))           else             0"/>
	  
	  
         <assert id="PEPPOL-EN16931-R120-SG" test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)" flag="fatal">Invoice line net amount MUST equal (Invoiced quantity * (Item net price/item price base quantity) + Sum of invoice line charge amount - sum of invoice line allowance amount</assert>
	  </rule>
  </pattern>
  <pattern id="UBL-model">
		<rule context="/*/cbc:UUID">
			<assert id="BR-109-GST-SG" test="matches(normalize-space(.), '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')" flag="fatal">[BR-109-GST-SG] An Universally unique Invoice Identifier (BT-SG-003) shall be formatted according to the UUID standard </assert>				 
		</rule>
      <rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount">
         <assert id="BR-CO-25-SG" flag="fatal" test="((. &gt; 0) and (exists(//cbc:DueDate) or exists(//cac:PaymentTerms/cbc:Note))) or (. &lt;= 0)">[BR-CO-25-SG]-In case the Amount due for payment (IBT-115) is positive, either the Payment due date (IBT-009) or the Payment terms (IBT-020) shall be present.</assert>
      </rule>
      <rule context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress">
         <assert id="BR-11-SG" flag="fatal" test="normalize-space(cac:Country/cbc:IdentificationCode) != ''">[BR-11-SG]-The Buyer postal address shall contain a Buyer country code (IBT-11).</assert>
      </rule>	  
      <rule context="cac:LegalMonetaryTotal">
         <assert test="exists(cbc:TaxExclusiveAmount)" flag="fatal" id="BR-13-GST-SG">[BR-13-GST-SG]-An Invoice shall have the Invoice total amount without GST (BT-109-GST).</assert>
         <assert test="exists(cbc:TaxInclusiveAmount)" flag="fatal" id="BR-14-GST-SG">[BR-14-GST-SG]-An Invoice shall have the Invoice total amount with GST (BT-112-GST).</assert>
         <assert test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (round(xs:decimal(cbc:TaxExclusiveAmount) * 10 * 10) div 100 = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (round(xs:decimal(cbc:TaxExclusiveAmount) * 10 * 10) div 100 = round((xs:decimal(cbc:LineExtensionAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (round(xs:decimal(cbc:TaxExclusiveAmount) * 10 * 10) div 100 = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = xs:decimal(cbc:LineExtensionAmount)))" flag="fatal" id="BR-CO-13-GST-SG">[BR-CO-13-GST-SG]-Invoice total amount without GST (BT-109-GST) = Σ Invoice line net amount (BT-131) - Sum of allowances on document level (BT-107) + Sum of charges on document level (BT-108).</assert>
         <assert test="((cbc:PrepaidAmount) and not((cbc:PayableRoundingAmount)) and (round(xs:decimal(cbc:PayableAmount) * 10 * 10) div 100 = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not((cbc:PrepaidAmount)) and not((cbc:PayableRoundingAmount)) and xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)) or ((cbc:PrepaidAmount) and (cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not((cbc:PrepaidAmount)) and (cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = round(xs:decimal(cbc:TaxInclusiveAmount) * 10 * 10) div 100)) " flag="fatal" id="BR-CO-16-GST-SG">[BR-CO-16-GST-SG]-Amount due for payment (BT-115) = Invoice total amount with GST (BT-112-GST-SG) -Paid amount (BT-113) +Rounding amount (BT-114).</assert>

         <assert id="BR-DEC-12-SG" flag="fatal" test="string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2">[BR-DEC-12-SG]-The allowed maximum number of decimals for the Invoice total amount without GST (BT-109-GST) is 2.</assert>
         <assert id="BR-DEC-14-SG" flag="fatal" test="string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2">[BR-DEC-14-SG]-The allowed maximum number of decimals for the Invoice total amount with GST (BT-112-GST) is 2.</assert>
         <assert id="BR-DEC-16-SG" flag="fatal" test="string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2">[BR-DEC-16-SG]-The allowed maximum number of decimals for the Paid amount (IBT-113) is 2.</assert>
         <assert id="BR-DEC-17-SG" flag="fatal" test="string-length(substring-after(cbc:PayableRoundingAmount,'.'))&lt;=2">[BR-DEC-17-SG]-The allowed maximum number of decimals for the Rounding amount (IBT-114) is 2.</assert>      
         <assert id="BR-CO-10-SG" flag="fatal" test="(round(xs:decimal(cbc:LineExtensionAmount) * 10 * 10) div 100 = (round(sum(//(cac:InvoiceLine|cac:CreditNoteLine)/xs:decimal(cbc:LineExtensionAmount)) * 10 * 10) div 100))">[BR-CO-10-SG]-Sum of Invoice line net amount (BT-106) = Σ Invoice line net amount (BT-131).</assert>
         <assert id="BR-CO-11-SG" flag="fatal" test="round(xs:decimal(cbc:AllowanceTotalAmount) * 10 * 10) div 100 = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or  (not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]))">[BR-CO-11-SG]-Sum of allowances on document level (BT-107) = Σ Document level allowance amount (BT-92).</assert>
         <assert id="BR-CO-12-SG" flag="fatal" test="round(xs:decimal(cbc:ChargeTotalAmount) * 10 * 10) div 100 = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or (not(cbc:ChargeTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]))">[BR-CO-12-SG]-Sum of charges on document level (BT-108) = Σ Document level charge amount (BT-99).</assert>
         <assert id="BR-DEC-09-SG" flag="fatal" test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2">[BR-DEC-09-SG]-The allowed maximum number of decimals for the Sum of Invoice line net amount (IBT-106) is 2.</assert>
         <assert id="BR-DEC-10-SG" flag="fatal" test="string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2">[BR-DEC-10-SG]-The allowed maximum number of decimals for the Sum of allowanced on document level (IBT-107) is 2.</assert>
         <assert id="BR-DEC-11-SG" flag="fatal" test="string-length(substring-after(cbc:ChargeTotalAmount,'.'))&lt;=2">[BR-DEC-11-SG]-The allowed maximum number of decimals for the Sum of charges on document level (IBT-108) is 2.</assert>

      </rule>
      <rule context="/ubl:Invoice | /cn:CreditNote">
         <assert test="every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency]) and exists(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='sgdtotal-incl-gst']) and exists(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='sgdtotal-excl-gst'])" flag="fatal" id="BR-53-GST-SG">[BR-53-GST-SG]-If the GST accounting currency code (BT-6-GST) is present, then the Invoice total GST amount (BT-111-GST), Invoice total including GST amount and Invoice Total excluding GST amount in accounting currency shall be provided.</assert>
		 <assert test="exists(cbc:TaxCurrencyCode) or not(exists(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='sgdtotal-incl-gst']) or exists(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='sgdtotal-excl-gst']))" flag="fatal" id="BR-110-GST-SG">[BR-110-GST-SG]-The GST accounting currency code (BT-6-GST) must be present when Invoice total including GST amount or Invoice Total excluding GST amount in accounting currency are provided.</assert>	  
         <assert test="every $Currency in cbc:DocumentCurrencyCode satisfies (count(//cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) eq 1) and (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount) = round( (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount) + cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) * 10 * 10) div 100)" flag="fatal" id="BR-CO-15-GST-SG">[BR-CO-15-GST-SG]-Invoice total amount with GST (BT-112-GST) = Invoice total amount without GST (BT-109-GST) + Invoice total GST amount (BT-110-GST).</assert>
         <assert test="exists(cac:TaxTotal/cac:TaxSubtotal)" flag="fatal" id="BR-CO-18-GST-SG">[BR-CO-18-GST-SG]-An Invoice shall at least have one GST Breakdown group (BG-23-GST).</assert>
         <assert id="BR-NG-01-GST-SG" flag="fatal" test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']))">[BR-NG-01-GST-SG]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the GST category code (BT-151-GST, BT-95-GST or BT-102-GST) is "NG" shall contain exactly one GST breakdown group (BG-23) with the GST category code (BT-118) equal to "NG".</assert>
         <assert id="BR-NG-02-GST-SG" flag="fatal" test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'])">[BR-NG-02-GST-SG]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item GST category code (BT-151-GST) is "NG" shall not contain the Seller GST identifier (BT-31), the Seller tax representative GST identifier (BT-63-GST) or the Buyer GST identifier (BT-48-GST).</assert>
         <assert id="BR-NG-03-GST-SG" flag="fatal" test="(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']))">[BR-NG-03-GST-SG]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance GST category code (BT-95-GST) is "NG" shall not contain the Seller GST identifier (BT-31-GST), the Seller tax representative GST identifier (BT-63-GST) or the Buyer GST identifier (BT-48-GST).</assert>
         <assert id="BR-NG-04-GST-SG" flag="fatal" test="(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']))">[BR-NG-04-GST-SG]-An Invoice that contains a Document level charge (BG-21) where the Document level charge GST category code (BT-102-GST) is "NG" shall not contain the Seller GST identifier (BT-31-GST), the Seller tax representative GST identifier (BT-63-GST) or the Buyer GST identifier (BT-48-GST).</assert>
         <assert id="BR-NG-11-GST-SG" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) != 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG'])">[BR-NG-11-GST-SG]-An Invoice that contains a GST breakdown group (BG-23) with a GST category code (BT-118-GST) "NG" shall not contain other GST breakdown groups (BG-23).    </assert>
         <assert id="BR-NG-12-GST-SG" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) and count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG'])">[BR-NG-12-GST-SG]-An Invoice that contains a GST breakdown group (BG-23) with a GST category code (BT-118) "NG" shall not contain an Invoice line (BG-25) where the Invoiced item GST category code (BT-151-GST) is not "NG".</assert>
         <assert id="BR-NG-13-GST-SG" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) != 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG'])">[BR-NG-13-GST-SG]-An Invoice that contains a GST breakdown group (BG-23) with a GST category code (BT-118-GST) "NG" shall not contain Document level allowances (BG-20) where Document level allowance GST category code (BT-9-GST5) is not "NG".</assert>
         <assert id="BR-NG-14-GST-SG" flag="fatal" test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) != 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'NG'])">[BR-NG-14-GST-SG]-An Invoice that contains a GST breakdown group (BG-23) with a GST category code (BT-118-GST) "NG" shall not contain Document level charges (BG-21) where Document level charge GST category code (BT-102-GST) is not "NG".</assert>
         <assert id="BR-110-SG" flag="fatal" test="not(exists(cac:OrderReference/cbc:ID[text()!= 'NA']) and exists((cac:InvoiceLine | cac:CreditNoteLine)/cac:OrderLineReference/cac:OrderReference/cbc:ID))">[BR-110-SG]-Order references in an Invoice shall be provided on either Invoice Line level or on Document level, not both.</assert>
				 
         <assert id="BR-CO-03-GST-SG" flag="fatal" test="(exists(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and exists(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode))">[BR-CO-03-GST-SG]-Tax point date (IBT-007) and Value added tax point date code (IBT-008) are mutually exclusive.</assert>
      </rule>
      <rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'NG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']">
         <assert id="BR-NG-08-GST-SG" flag="fatal" test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='NG']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='NG']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='NG']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='NG']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='NG']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='NG']/xs:decimal(cbc:Amount)))))">[BR-NG-08]-In a GST breakdown (BG-23) where the GST category code (BT-118-GST) is "NG" the GST category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the GST category codes (BT-151-GST, BT-95-GST, BT-102-GST) are "NG".</assert>
         <assert id="BR-NG-09-GST-SG" flag="fatal" test="../cbc:TaxAmount = 0">[BR-NG-09-GST-SG]-The GST category tax amount (BT-117-GST) in a GST breakdown (BG-23) where the GST category code (BT-118-GST) is "NG" shall be 0 (zero).</assert>
      </rule>
      <rule context="cac:InvoiceLine | cac:CreditNoteLine">
         <assert test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)" flag="fatal" id="BR-CO-04-GST-SG">[BR-CO-04-GST-SG]-Each Invoice line (BG-25) shall be categorized with an Invoiced item GST category code (BT-151-GST).</assert>
      </rule>
      <rule context="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
         <assert id="BR-CO-07-SG" flag="fatal" test="true()">[BR-CO-07-SG]-Invoice line allowance reason code (IBT-140) and Invoice line allowance reason (IBT-139) shall indicate the same type of allowance reason.</assert>
      </rule>
      <rule context="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
         <assert id="BR-CO-08-SG" flag="fatal" test="true()">[BR-CO-08-SG]-Invoice line charge reason code (IBT-145) and Invoice line charge reason (IBT-144) shall indicate the same type of charge reason.</assert>
      </rule>	  
      <rule context="cac:AccountingSupplierParty">
         <assert test="exists(cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(cac:Party/cac:PartyIdentification/cbc:ID) or exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID)" flag="fatal" id="BR-CO-26-GST-SG">[BR-CO-26-GST-SG]-In order for the buyer to automatically identify a supplier, the Seller identifier (BT-29), the Seller legal registration identifier (BT-30) and/or the Seller GST identifier (BT-31-GST) shall be present.</assert>
      </rule>
      <rule context="cac:TaxRepresentativeParty">
         <assert test="exists(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'GST']/cbc:CompanyID)" flag="fatal" id="BR-56-GST-SG">[BR-56-GST-SG]-Each Seller tax representative party (BG-11) shall have a Seller tax representative GST identifier (BT-63-GST).</assert>
      </rule>
      <rule context="/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:TaxTotal">
         <assert test="(round(xs:decimal(child::cbc:TaxAmount) * 10 * 10) div 100 = round((sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount)) * 10 * 10)) div 100) or not(cac:TaxSubtotal)" flag="fatal" id="BR-CO-14-GST-SG">[BR-CO-14-GST-SG]-Invoice total GST amount (BT-110-GST) = Σ GST category tax amount (BT-117-GST).</assert>
      </rule>
      <rule context="cac:TaxTotal/cac:TaxSubtotal">
         <assert test="exists(cbc:TaxableAmount)" flag="fatal" id="BR-45-GST-SG">[BR-45-GST-SG]-Each GST Breakdown (BG-23-GST) shall have a GST category taxable amount (BT-116-GST).</assert>
         <assert test="exists(cbc:TaxAmount)" flag="fatal" id="BR-46-GST-SG">[BR-46-GST-SG]-Each GST Breakdown (BG-23-GST) shall have a GST category tax amount (BT-117-GST).</assert>
         <assert test="exists(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)" flag="fatal" id="BR-47-GST-SG">[BR-47-GST-SG]-Each GST Breakdown (BG-23-GST) shall be defined through a GST category code (BT-118-GST).</assert>
         <assert test="exists(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:Percent) or exists(normalize-space(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)='NG')" flag="fatal" id="BR-48-GST-SG">[BR-48-GST-SG]-Each GST breakdown (BG-23-GST) shall have a GST category rate (BT-119-GST), except if the Invoice is not subject to GST.</assert>
         <assert test="(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent)) != 0 and ((abs(xs:decimal(cbc:TaxAmount)) - 2 &lt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(cbc:TaxAmount)) + 2 &gt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 )))  or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))" flag="fatal" id="BR-CO-17-GST-SG">[BR-CO-17-GST-SG]-GST category tax amount (BT-117-GST) = GST category taxable amount (BT-116-GST) x (GST category rate (BT-119-GST) / 100).</assert>
      </rule>
	  
  
      <rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]">
         <assert id="BR-31-SG" flag="fatal" test="exists(cbc:Amount)">[BR-31-SG]-Each Document level allowance (IBG-20) shall have a Document level allowance amount (IBT-92).</assert>	
		 <assert id="BR-CO-05-SG" flag="fatal" test="true()">[BR-CO-05-SG]-Document level allowance reason code (IBT-98) and Document level allowance reason (IBT-97) shall indicate the same type of allowance.</assert>				 
         <assert id="BR-DEC-01-SG" flag="fatal" test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">[BR-DEC-01-SG]-The allowed maximum number of decimals for the Document level allowance amount (IBT-092) is 2.</assert>
         <assert id="BR-DEC-02-SG" flag="fatal" test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">[BR-DEC-02-SG]-The allowed maximum number of decimals for the Document level allowance base amount (IBT-093) is 2.</assert>
      </rule>
      <rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
         <assert id="BR-DEC-05-SG" flag="fatal" test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">[BR-DEC-05-SG]-The allowed maximum number of decimals for the Document level charge amount (IBT-099) is 2.</assert>
         <assert id="BR-DEC-06-SG" flag="fatal" test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">[BR-DEC-06-SG]-The allowed maximum number of decimals for the Document level charge base amount (BT-100) is 2.</assert>
         <assert id="BR-CO-06-SG" flag="fatal" test="true()">[BR-CO-06-SG]-Document level charge reason code (IBT-105) and Document level charge reason (IBT-104) shall indicate the same type of charge.</assert>
				 
+      </rule>	
	  <rule context="/ubl:Invoice/cbc:Note | /cn:CreditNote/cbc:Note">
		 <assert id="BR-CL-08-SG" flag="fatal" test="(contains(.,'#') and string-length(substring-before(substring-after(.,'#'),'#'))=3 and ( ( contains(' AAA AAB AAC AAD AAE AAF AAG AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABZ ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACM ACN ACO ACP ACQ ACR ACS ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADH ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADS ADT ADU ADV ADW ADX ADY ADZ AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHW AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ARR ARS AUT AUU AUV AUW AUX AUY AUZ AVA AVB AVC AVD AVE AVF BAG BAH BAI BAJ BAK BAL BAM BAN BAO BAP BAQ BAR BAS BLC BLD BLE BLF BLG BLH BLI BLJ BLK BLL BLM BLN BLO BLP BLQ BLR BLS BLT BLU BLV BLW BLX BLY BLZ BMA BMB BMC BMD BME CCI CEX CHG CIP CLP CLR COI CUR CUS DAR DCL DEL DIN DOC DUT EUR FBC GBL GEN GS7 HAN HAZ ICN IIN IMI IND INS INV IRP ITR ITS LAN LIN LOI MCO MDH MKS ORI OSI PAC PAI PAY PKG PKT PMD PMT PRD PRF PRI PUR QIN QQD QUT RAH REG RET REV RQR SAF SIC SIN SLR SPA SPG SPH SPP SPT SRN SSR SUR TCA TDT TRA TRR TXD WHI ZZZ ',substring-before(substring-after(.,'#'),'#') ) ) )) or not(contains(.,'#')) or not(string-length(substring-before(substring-after(.,'#'),'#'))=3)">[BR-CL-08-SG]-Invoiced note subject code shall be coded using UNCL4451</assert>
	  </rule>  

	  <rule context="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount">
		 <assert id="BR-50-SG" flag="fatal" test="normalize-space(cbc:ID) != ''">[BR-50-SG]-A Payment account identifier (IBT-84) shall be present if Credit transfer (IBG-17) information is provided in the Invoice.</assert>
	  </rule>	  
      <rule context="cac:PaymentMeans/cac:CardAccount/cbc:PrimaryAccountNumberID">
         <assert id="BR-51-SG" flag="warning" test="string-length(normalize-space(.))&lt;=10">[BR-51-SG]-In accordance with card payments security standards an invoice should never include a full card primary account number (IBT-087). At the moment PCI Security Standards Council has defined that the first 6 digits and last 4 digits are the maximum number of digits to be shown.</assert>
      </rule>	  
  </pattern>
  
    <pattern>																
	<rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[contains( ' SR SRCA-S SRCA-C ZR SRRC SROVR-RS SROVR-LVG SRLVG NA ',concat(' ',normalize-space(cbc:ID),' ') ) ] ">
		<assert test="((//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID) or (//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'GST')]/cbc:CompanyID))" flag="fatal" id="BR-105-GST-SG">[BR-105-GST-SG]-An Invoice that contains an GST Category code of value SR, SRCA-S, SRCA-C, ZR, SRRC, SROVR-RS, SROVR-LVG, SRLVG or NA shall  contain the Seller GST identifier (BT-31-GST) or the Seller tax representative GST identifier (BT-63-GST) </assert>
		<assert test="exists(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName) and exists(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone)" flag="fatal" id="BR-106-GST-SG">[BR-106-GST-SG]-An Invoice that contains an GST Category code of value SR, SRCA-S, SRCA-C, ZR, SRRC, SROVR-RS, SROVR-LVG, SRLVG or NA shall contain the Seller address line 1 (IBT-35) and Seller post code (IBT-38)</assert>	
		<assert test="exists(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName) and exists(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone)" flag="fatal" id="BR-107-GST-SG">[BR-107-GST-SG]-An Invoice that contains an GST Category code of value SR, SRCA-S, SRCA-C, ZR, SRRC, SROVR-RS, SROVR-LVG, SRLVG or NA shall contain the Buyer address line 1 (IBT-50) and Buyer post code (IBT-53)</assert>	
		<assert test="exists(/*/cbc:UUID)" flag="fatal" id="BR-108-GST-SG">[BR-108-GST-SG]-An Invoice that contains an GST Category code of value SR, SRCA-S, SRCA-C, ZR, SRRC, SROVR-RS, SROVR-LVG, SRLVG or NA shall contain an Universally unique Invoice identifier (UUID) (BT-SG-003)</assert>	
		<assert test="exists(cn:CreditNote/cbc:Note) or not(exists(cn:CreditNote))" flag="fatal" id="BR-111-GST-SG">[BR-111-GST-SG]-A CreditNote that contains an GST Category code of value SR, SRCA-S, SRCA-C, ZR, SRRC, SROVR-RS, SROVR-LVG, SRLVG or NA shall contain an Invoice note with the reason for credit (IBT-022)</assert>	
		<assert test="exists(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID )" flag="fatal" id="BR-112-GST-SG">[BR-112-GST-SG]-An Invoice that contains an GST Category code of value SR, SRCA-S, SRCA-C, ZR, SRRC, SROVR-RS, SROVR-LVG, SRLVG or NA shall contain the Seller legal registration identifier (IBT-030)</assert>			
		<assert test="(/*/normalize-space(cbc:DocumentCurrencyCode) != 'SGD' and /*/normalize-space(cbc:TaxCurrencyCode) = 'SGD')  or  (/*/normalize-space(cbc:DocumentCurrencyCode) = 'SGD' and not(/*/cbc:TaxCurrencyCode))" flag="fatal" id="BR-113-GST-SG">[BR-113-GST-SG]-An Invoice that contains an GST Category code of value SR, SRCA-S, SRCA-C, ZR, SRRC, SROVR-RS, SROVR-LVG, SRLVG or NA, shall include an Accounting currency code (IBT-006) with the value 'SGD' if the Invoice currency code (IBT-005) is not 'SGD'. If the Invoice currency code is 'SGD', then the Accounting currency code shall not be provided.</assert>	
		
	</rule>
  </pattern>

  
  <pattern id="UBL-syntax">
      <rule context="/ubl:Invoice | /cn:CreditNote">
         <assert test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='GST']/cbc:CompanyID) &lt;= 1)" flag="warning" id="UBL-SR-12-GST-SG">[UBL-SR-12-GST-SG]-Seller GST identifier shall occur maximum once</assert>
         <assert test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID!='GST']/cbc:ID) &lt;= 1)" flag="warning" id="UBL-SR-13-GST-SG">[UBL-SR-13-GST-SG]-Seller tax registration shall occur maximum once</assert>
         <assert test="(count(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) &lt;= 1)" flag="warning" id="UBL-SR-18-SG">[UBL-SR-18-GST]-Buyer GST identifier shall occur maximum once</assert>
      </rule>
      <rule context="cac:InvoiceLine | cac:CreditNoteLine">
         <assert test="(count(cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReason) &lt;= 1)" flag="warning" id="UBL-SR-38-GST-SG">[UBL-SR-38-GST-SG]-Invoiced item GST exemption reason text shall occur maximum once</assert>
		<assert id="BR-DEC-13-GST-SG" flag="fatal" test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode]))">[BR-DEC-13-GST-SG]-The allowed maximum number of decimals for the Invoice total GST amount (IBT-110) is 2.</assert>
		<assert id="BR-DEC-15-SG" flag="fatal" test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode]))">[BR-DEC-15-SG]-The allowed maximum number of decimals for the Invoice total GST amount in accounting currency (IBT-111) is 2.</assert>
      
      
      </rule>
      <rule context="cac:TaxRepresentativeParty">
         <assert test="(count(cac:Party/cac:PartyTaxScheme/cbc:CompanyID) &lt;= 1)" flag="warning" id="UBL-SR-23-GST-SG">[UBL-SR-23-GST-SG]-Seller tax representative GST identifier shall occur maximum once, if the Seller has a tax representative</assert>
      </rule>
      <rule context="cac:TaxSubtotal">
         <assert test="(count(cac:TaxCategory/cbc:TaxExemptionReason) &lt;= 1)" flag="warning" id="UBL-SR-32-SG">[UBL-SR-32-SG]-GST exemption reason text shall occur maximum once</assert>
      </rule>
      <rule context="cac:TaxTotal/cac:TaxSubtotal">
         <assert id="BR-DEC-19-SG" flag="fatal" test="string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2">[BR-DEC-19-SG]-The allowed maximum number of decimals for the GST category taxable amount (BT-116-GST) is 2.</assert>
         <assert id="BR-DEC-20-SG" flag="fatal" test="string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2">[BR-DEC-20-SG]-The allowed maximum number of decimals for the GST category tax amount (BT-117-GST) is 2.</assert>
      </rule>
      <rule context="cac:AdditionalDocumentReference[cbc:DocumentTypeCode]">
         <assert id="UBL-SR-43-GST-SG" flag="fatal" test="((cbc:DocumentTypeCode='130' or cbc:DocumentTypeCode='sgdtotal-incl-gst' or cbc:DocumentTypeCode='sgdtotal-excl-gst') or ((local-name(/*) = 'CreditNote') and (cbc:DocumentTypeCode='50')))">[UBL-SR-43-GST-SG]-AdditionalDocumentReference/DocumentTypeCode shall only be used for invoiced object (code 130), project reference in CreditNote (code 50) or total amounts including or excluding GST in SGD (code sgdtotal-incl-gst or sgdtotal-excl-gst)</assert>
         <assert id="BR-100-GST-SG" flag="fatal" test="(cbc:DocumentTypeCode='sgdtotal-incl-gst' and cbc:DocumentDescription castable as xs:decimal and string-length(substring-after(cbc:DocumentDescription,'.'))&lt;=2) or cbc:DocumentTypeCode != 'sgdtotal-incl-gst' ">[BR-100-GST-SG]- Total Amount including GST in SGD must be numeric and have maximum of 2 decimals</assert>
         <assert id="BR-101-GST-SG" flag="fatal" test="(cbc:DocumentTypeCode='sgdtotal-excl-gst' and cbc:DocumentDescription castable as xs:decimal and string-length(substring-after(cbc:DocumentDescription,'.'))&lt;=2) or cbc:DocumentTypeCode != 'sgdtotal-excl-gst' ">[BR-101-GST-SG]- Total Amount excluding GST in SGD must be numeric and have maximum of 2 decimals</assert>
		       <assert id="BR-102-GST-SG" flag="fatal" test="((cbc:DocumentTypeCode='130' or cbc:DocumentTypeCode='sgdtotal-incl-gst' or cbc:DocumentTypeCode='sgdtotal-excl-gst') or ((local-name(/*) = 'CreditNote') and (cbc:DocumentTypeCode='50'))) and not(cac:Attachment)">[BR-102-GST-SG]- Attachment must not be used when providing reference to Total Amount incl or excl GST in SGD, Invoiced Object Reference or Project Reference</assert>
         <assert id="BR-103-GST-SG" flag="fatal" test="(cbc:DocumentTypeCode='sgdtotal-incl-gst' and cbc:ID='SGD')  or cbc:DocumentTypeCode != 'sgdtotal-incl-gst' ">[BR-103-GST-SG]- When providing Total Amount including GST in SGD, element ID must be set to the code value SGD</assert>
         <assert id="BR-104-GST-SG" flag="fatal" test="(cbc:DocumentTypeCode='sgdtotal-excl-gst' and cbc:ID='SGD')  or cbc:DocumentTypeCode != 'sgdtotal-excl-gst' ">[BR-104-GST-SG]- When providing Total Amount excluding GST in SGD, element ID must be set to the code value SGD</assert>
  
      </rule>
  </pattern>
  <pattern id="Codesmodel">
      <rule context="cac:PaymentMeans/cbc:PaymentMeansCode" flag="fatal">
         <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ Z01 Z02 ',concat(' ',normalize-space(.),' ') ) ) )" id="BR-CL-16-SG" flag="fatal">[BR-CL-16-SG]-Payment means in an invoice MUST be coded using UNCL4461 code list, or code Z01 or Z02</assert>
      </rule>
      <rule context="cac:TaxCategory/cbc:ID" flag="fatal">
         <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' SR SRCA-S SRCA-C ZR ES33 ESN33 DS OS NA NG SRRC SROVR-RS SROVR-LVG SRLVG ',concat(' ',normalize-space(.),' ') ) ) )" id="BR-CL-17-GST-SG" flag="fatal">[BR-CL-17-GST-SG]-Invoice tax categories MUST be coded using valid Singapore code values</assert>
      </rule>
      <rule context="cac:ClassifiedTaxCategory/cbc:ID" flag="fatal">
         <assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' SR SRCA-S SRCA-C ZR ES33 ESN33 DS OS NA NG SRRC SROVR-RS SROVR-LVG SRLVG ',concat(' ',normalize-space(.),' ') ) ) )" id="BR-CL-18-GST-SG" flag="fatal">[BR-CL-18-GST-SG]-Invoice tax categories MUST be coded using valid Singapore code values</assert>
      </rule>
      <rule context="cac:InvoicePeriod/cbc:DescriptionCode" flag="fatal">
         <assert test="((not(contains(normalize-space(.), ' ')) and contains(' 3 35 432 ', concat(' ', normalize-space(.), ' '))))" id="BR-CL-06-GST-SG" flag="fatal">[BR-CL-06-GST-SG]-Invoice period description code must be according to UNCL 2005 D.16B.</assert>
      </rule>	  
  </pattern>
</schema>