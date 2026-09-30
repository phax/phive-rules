<pattern id="UBL-general" xmlns="http://purl.oclc.org/dsdl/schematron">
	<!-- Document level -->
	<rule context="ubl-creditnote:CreditNote | ubl-invoice:Invoice">
		<assert id="PEPPOL-EN16931-R001" test="cbc:ProfileID" flag="fatal">Business process MUST be provided.</assert>
		<assert id="PEPPOL-EN16931-R007" test="$profile != 'Unknown'" flag="fatal">[PEPPOL-EN16931-R007]-Business process MUST have an approved identifier.</assert>
		<assert id="PEPPOL-EN16931-R002" test="count(cbc:Note) &lt;= 1 or ($supplierCountryIsDE and $customerCountryIsDE)" flag="fatal">No more than one note is allowed on document level, unless both the buyer and seller are German organizations.</assert>
		<assert id="PEPPOL-EN16931-R003" test="cbc:BuyerReference or cac:OrderReference/cbc:ID" flag="fatal">A buyer reference or purchase order reference MUST be provided.</assert>
		<assert id="PEPPOL-EN16931-R004" test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0') and not(contains(normalize-space(cbc:CustomizationID/text()), '::'))" flag="fatal">[PEPPOL-EN16931-R004]-Specification identifier MUST begin with the value 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0' and follow the format rules for the identifier.</assert>
		<assert id="PEPPOL-EN16931-R053" test="count(cac:TaxTotal[cac:TaxSubtotal]) = 1" flag="fatal">Only one tax total with tax subtotals MUST be provided.</assert>
		<assert id="PEPPOL-EN16931-R054" test="count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0)" flag="fatal">Only one tax total without tax subtotals MUST be provided when tax currency code is provided.</assert>
		<assert id="PEPPOL-EN16931-R055" test="not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &gt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &gt;= 0) " flag="fatal">Invoice total VAT amount and Invoice total VAT amount in accounting currency MUST have the same operational sign</assert>
	</rule>
	<rule context="cbc:TaxCurrencyCode">
		<assert id="PEPPOL-EN16931-R005" test="not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text()))" flag="fatal">VAT accounting currency code MUST be different from invoice currency code when provided.</assert>
	</rule>
	<!-- Accounting customer -->
	<rule context="cac:AccountingCustomerParty/cac:Party">
		<assert id="PEPPOL-EN16931-R010" test="cbc:EndpointID" flag="fatal">Buyer electronic address MUST be provided</assert>
	</rule>
	<!-- Accounting supplier -->
	<rule context="cac:AccountingSupplierParty/cac:Party">
		<assert id="PEPPOL-EN16931-R020" test="cbc:EndpointID" flag="fatal">Seller electronic address MUST be provided</assert>
	</rule>
	<!-- Allowance/Charge (document level/line level) -->
	<rule context="ubl-invoice:Invoice/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]">
		<assert id="PEPPOL-EN16931-R041" test="false()" flag="fatal">Allowance/charge base amount MUST be provided when allowance/charge percentage is provided.</assert>
	</rule>
	<rule context="ubl-invoice:Invoice/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]">
		<assert id="PEPPOL-EN16931-R042" test="false()" flag="fatal">Allowance/charge percentage MUST be provided when allowance/charge base amount is provided.</assert>
	</rule>
	<rule context="ubl-invoice:Invoice/cac:AllowanceCharge | ubl-invoice:Invoice/cac:InvoiceLine/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:AllowanceCharge | ubl-creditnote:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge">
		<assert id="PEPPOL-EN16931-R040" test="
          not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then
            cbc:Amount
          else
            0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)" flag="fatal">Allowance/charge amount must equal base amount * percentage/100 if base amount and percentage exists</assert>
		<assert id="PEPPOL-EN16931-R043" test="normalize-space(cbc:ChargeIndicator/text()) = 'true' or normalize-space(cbc:ChargeIndicator/text()) = 'false'" flag="fatal">Allowance/charge ChargeIndicator value MUST equal 'true' or 'false'</assert>
	</rule>
	<!-- Payment -->
	<rule context="
        cac:PaymentMeans[some $code in tokenize('49 59', '\s')
          satisfies normalize-space(cbc:PaymentMeansCode) = $code]">
		<assert id="PEPPOL-EN16931-R061" test="cac:PaymentMandate/cbc:ID" flag="fatal">Mandate reference MUST be provided for direct debit.</assert>
	</rule>
	<!-- Currency -->
		<rule context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cac:TaxTotal[cac:TaxSubtotal]/cbc:TaxAmount | cac:TaxSubtotal/cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount">
			<assert id="PEPPOL-EN16931-R051" test="@currencyID = $documentCurrencyCode" flag="fatal">All currencyID attributes must have the same value as the invoice currency code (BT-5), except for the invoice total VAT amount in accounting currency (BT-111).</assert>
		</rule>
	<!-- Line level - invoice period -->
	<rule context="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:StartDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:StartDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:StartDate">
		<assert id="PEPPOL-EN16931-R110" test="xs:date(text()) &gt;= xs:date(../../../cac:InvoicePeriod/cbc:StartDate)" flag="fatal">Start date of line period MUST be within invoice period.</assert>
	</rule>
	<rule context="ubl-invoice:Invoice[cac:InvoicePeriod/cbc:EndDate]/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate | ubl-creditnote:CreditNote[cac:InvoicePeriod/cbc:EndDate]/cac:CreditNoteLine/cac:InvoicePeriod/cbc:EndDate">
		<assert id="PEPPOL-EN16931-R111" test="xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate)" flag="fatal">End date of line period MUST be within invoice period.</assert>
	</rule>
	<!-- Line level - line extension amount -->
	<rule context="cac:InvoiceLine | cac:CreditNoteLine">
		<let name="lineExtensionAmount" value="
          if (cbc:LineExtensionAmount) then
            xs:decimal(cbc:LineExtensionAmount)
          else
            0"/>
		<let name="quantity" value="
          if (/ubl-invoice:Invoice) then
            (if (cbc:InvoicedQuantity) then
              xs:decimal(cbc:InvoicedQuantity)
            else
              1)
          else
            (if (cbc:CreditedQuantity) then
              xs:decimal(cbc:CreditedQuantity)
            else
              1)"/>
		<let name="priceAmount" value="
          if (cac:Price/cbc:PriceAmount) then
            xs:decimal(cac:Price/cbc:PriceAmount)
          else
            0"/>
		<let name="baseQuantity" value="
          if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then
            xs:decimal(cac:Price/cbc:BaseQuantity)
          else
            1"/>
		<let name="allowancesTotal" value="
          if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then
            round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100
          else
            0"/>
		<let name="chargesTotal" value="
          if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then
            round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100
          else
            0"/>
		<assert id="PEPPOL-EN16931-R120" test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)" flag="fatal">Invoice line net amount MUST equal (Invoiced quantity * (Item net price/item price base quantity) + Sum of invoice line charge amount - sum of invoice line allowance amount</assert>
		<assert id="PEPPOL-EN16931-R121" test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) &gt; 0" flag="fatal">Base quantity MUST be a positive number above zero.</assert>
		<assert id="PEPPOL-EN16931-R100-NA" test="(count(cac:DocumentReference) &lt;= 1)" flag="warning">Only one invoiced object is allowed pr line (not applied in the Italian context).</assert>
		<assert id="PEPPOL-EN16931-R101" test="(not(cac:DocumentReference) or (cac:DocumentReference/cbc:DocumentTypeCode='130'))" flag="fatal">Element Document reference can only be used for Invoice line object</assert>
	</rule>
	<!-- Allowance (price level) -->
	<rule context="cac:Price/cac:AllowanceCharge">
		<assert id="PEPPOL-EN16931-R044" test="normalize-space(cbc:ChargeIndicator) = 'false'" flag="fatal">Charge on price level is NOT allowed. Only value 'false' allowed.</assert>
		<assert id="PEPPOL-EN16931-R046" test="not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)" flag="fatal">Item net price MUST equal (Gross price - Allowance amount) when gross price is provided.</assert>
	</rule>
	<!-- Price -->
	<rule context="cac:Price/cbc:BaseQuantity[@unitCode]">
		<let name="hasQuantity" value="../../cbc:InvoicedQuantity or ../../cbc:CreditedQuantity"/>
		<let name="quantity" value="
          if (/ubl-invoice:Invoice) then
            ../../cbc:InvoicedQuantity
          else
            ../../cbc:CreditedQuantity"/>
		<assert id="PEPPOL-EN16931-R130" test="not($hasQuantity) or @unitCode = $quantity/@unitCode" flag="fatal">Unit code of price base quantity MUST be same as invoiced quantity.</assert>
	</rule>
	<!-- Validation of ICD -->
	<rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']">
		<assert id="PEPPOL-COMMON-R040" test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())" flag="fatal">GLN must have a valid format according to GS1 rules.</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']">
		<assert id="PEPPOL-COMMON-R041" test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())" flag="fatal">Norwegian organization number MUST be stated in the correct format.</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '0184'] | cac:PartyIdentification/cbc:ID[@schemeID = '0184'] | cbc:CompanyID[@schemeID = '0184']">
		<assert id="PEPPOL-COMMON-R042" test="(string-length(string()) = 10 and substring(string(), 1, 2) = 'DK' and string-length(translate(substring(string(), 3, 8), '1234567890', '')) = 0)
               or
              (string-length(string()) = 8) and (string-length(translate(substring(string(), 1, 8),'1234567890', '')) = 0)" flag="fatal">Danish organization number (CVR) MUST be stated in the correct format.</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '0096'] | cac:PartyIdentification/cbc:ID[@schemeID = '0096'] | cbc:CompanyID[@schemeID = '0096']">
		<assert id="PEPPOL-COMMON-R052" test="(string-length(string()) = 10) and (string-length(translate(substring(string(), 1, 10),'1234567890', '')) = 0)" flag="fatal">[PEPPOL-COMMON-R052]-Danish chamber of commerce number (P) MUST be stated in the correct format.</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '0198'] | cac:PartyIdentification/cbc:ID[@schemeID = '0198'] | cbc:CompanyID[@schemeID = '0198']">
		<assert id="PEPPOL-COMMON-R053" test="(string-length(string()) = 10 and substring(string(), 1, 2) = 'DK' and string-length(translate(substring(string(), 3, 8), '1234567890', '')) = 0)" flag="fatal">[PEPPOL-COMMON-R053]-Danish ERSTORG number (SE) MUST be stated in the correct format.</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '0106'] | cac:PartyIdentification/cbc:ID[@schemeID = '0106'] | cbc:CompanyID[@schemeID = '0106']">
		<assert id="PEPPOL-COMMON-R054" test="matches(normalize-space(), '^[0-9]{8}$')" flag="warning">[PEPPOL-COMMON-R054]-Dutch Chamber of Commerce (KVK) numbers (0106) MUST be stated in the correct format (12345678).</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '0190'] | cac:PartyIdentification/cbc:ID[@schemeID = '0190'] | cbc:CompanyID[@schemeID = '0190']">
		<assert id="PEPPOL-COMMON-R055" test="matches(normalize-space(), '^[0-9]{20}$')" flag="warning">[PEPPOL-COMMON-R055]-Dutch organization identification numbers (0190) MUST be stated in the correct format (12345678901234567890).</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '9944'] | cac:PartyIdentification/cbc:ID[@schemeID = '9944'] | cbc:CompanyID[@schemeID = '9944']">
		<assert id="PEPPOL-COMMON-R056-1" test="matches(normalize-space(), '^NL[0-9]{9}B[0-9]{2}$')" flag="warning">[PEPPOL-COMMON-R056-1]-Dutch VAT numbers (9944) MUST be stated in the correct format (NL123456789B12).</assert>
	</rule>
	<rule context="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID[starts-with(., 'NL')]">
		<assert id="PEPPOL-COMMON-R056-2" test="matches(normalize-space(.), '^NL[0-9]{9}B[0-9]{2}$')" flag="warning">[PEPPOL-COMMON-R056-2]-Dutch VAT numbers MUST have the format (NL123456789B12).</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '0217'] | cac:PartyIdentification/cbc:ID[@schemeID = '0217'] | cbc:CompanyID[@schemeID = '0217']">
		<assert id="PEPPOL-COMMON-R057" test="matches(normalize-space(), '^[0-9]{12}$')" flag="warning">[PEPPOL-COMMON-R057]-Dutch Chamber of Commerce Establishment numbers (0217) MUST be stated in the correct format (123456789012).</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']">
		<assert id="PEPPOL-COMMON-R043" test="matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())" flag="fatal">Belgian enterprise number MUST be stated in the correct format.</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']">
		<assert id="PEPPOL-COMMON-R044" test="u:checkCodiceIPA(normalize-space())" flag="warning">IPA Code (Codice Univoco Unità Organizzativa) must be stated in the correct format</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']">
		<assert id="PEPPOL-COMMON-R045" test="u:checkCF(normalize-space())" flag="warning">Tax Code (Codice Fiscale) must be stated in the correct format</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '9907']">
		<assert id="PEPPOL-COMMON-R046" test="u:checkCF(normalize-space())" flag="warning">Tax Code (Codice Fiscale) must be stated in the correct format</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']">
		<assert id="PEPPOL-COMMON-R047" test="u:checkPIVAseIT(normalize-space())" flag="warning">Italian VAT Code (Partita Iva) must be stated in the correct format</assert>
	</rule>
	<!--    <rule context="cbc:EndpointID[@schemeID = '9906']">
       <assert id="PEPPOL-COMMON-R048" test="u:checkPIVAseIT(normalize-space())" flag="warning">Italian
    VAT Code (Partita Iva) must be stated in the correct format</assert>
    </rule> -->
	<rule context="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']">
		<assert id="PEPPOL-COMMON-R049" test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN' and u:checkSEOrgnr(normalize-space())" flag="fatal">Swedish organization number MUST be stated in the correct format.</assert>
	</rule>
	<rule context="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']">
		<assert id="PEPPOL-COMMON-R050" test="matches(normalize-space(), '^[0-9]{11}$') and u:abn(normalize-space())" flag="fatal">Australian Business Number (ABN) MUST be stated in the correct format.</assert>
	</rule>
</pattern>