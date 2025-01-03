<?xml version="1.0" encoding="UTF-8"?>

<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
	

	<let name="taxCategoryPercents" value="for $cat in /ubl:OrderResponse/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory return u:cat2str($cat)"/>
	<let name="taxCategories" value="for $cat in /ubl:OrderResponse/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory return normalize-space($cat/cbc:ID)"/>		
	<let name="documentCurrencyCode" value="/ubl:OrderResponse/cbc:DocumentCurrencyCode"/>

	<rule context="cbc:CustomizationID">
			<assert id="PEPPOL-T110-R030" 
					test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:order_agreement:3')"
					flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:poacc:trns:order_agreement:3'.</assert>
	</rule>


	<rule context="cac:Item">
		<assert id= "PEPPOL-T110-R002"
				test="(cac:StandardItemIdentification/cbc:ID) or  (cac:SellersItemIdentification/cbc:ID)"
				flag="fatal">Each item in an Order agreement line SHALL be identifiable by either "item sellers identifier" or "item standard identifier"</assert>
	</rule>

	<rule context="cbc:Amount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:PriceAmount | cbc:BaseAmount | cac:LegalMonetaryTotal/cbc:*">
		<assert id="PEPPOL-T110-R004"
				test="not(@currencyID) or @currencyID = $documentCurrencyCode"
				flag="fatal">All amounts SHALL have same currency code as document currency</assert>
		<assert id="PEPPOL-T110-R013"
				test="ancestor::node()/local-name() = 'Price' or string-length(substring-after(., '.')) &lt;= 2"
				flag="fatal">Elements of data type amount cannot have more than 2 decimals (I.e. all amounts except unit price amounts)</assert>
	</rule>
	
	
<!-- TAX rules -->
	
	<rule context="cac:TaxTotal/cac:TaxSubtotal">
			
		<assert id="PEPPOL-T110-R024"
			test="(round(cac:TaxCategory/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory/xs:decimal(cbc:Percent)) != 0 and (xs:decimal(cbc:TaxAmount) = round(xs:decimal(cbc:TaxableAmount) * (cac:TaxCategory/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 )) or (not(exists(cac:TaxCategory/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))"
			flag="fatal">TAX category tax amount = TAX category taxable amount  x (TAX category rate  / 100), rounded to two decimals.</assert>
		
	</rule>	
	
	<rule context="/ubl:OrderResponse/cac:TaxTotal[cac:TaxSubtotal]">
		<assert id="PEPPOL-T110-R025"
			test="(xs:decimal(child::cbc:TaxAmount)= round((sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount)) * 10 * 10)) div 100) or not(cac:TaxSubtotal)"
			flag="fatal">If TAX breakdown is present, the order agreement TAX total amount  = Σ TAX category tax amount.</assert>
	</rule>
		
	<rule context="cac:TaxSubtotal/cac:TaxCategory[not(cbc:TaxExemptionReason)]">
		<assert id="PEPPOL-T110-R028"
			test="contains( ' S Z L M ',concat(' ',normalize-space(cbc:ID),' '))"
			flag="fatal">A TAX breakdown with TAX Category codes E, AE, K, G or O SHALL have a TAX exemption reason text </assert>
	</rule>
	
	<rule context="cac:TaxSubtotal/cac:TaxCategory[cbc:TaxExemptionReason]">
		<assert id="PEPPOL-T110-R029"
			test="contains( ' E AE O K G ',concat(' ',normalize-space(cbc:ID),' '))"
			flag="fatal">A TAX breakdown with TAX Category codes S, Z, L and M SHALL NOT have a TAX exemption reason text </assert>
	</rule>
	
	<rule context="cac:AllowanceCharge/cac:TaxCategory | cac:Item/cac:ClassifiedTaxCategory">
		
		<let name="category" value="u:cat2str(.)"/>
		 <!-- Note: Only when Percent is present and TaxTotal is present on header level -->
		<assert id="PEPPOL-T110-R026"
			test="not(cbc:Percent) or not(//cac:TaxTotal) or (some $cat in $taxCategoryPercents satisfies $cat = $category)"
			flag="fatal">Tax category rates MUST match provided tax categories on document level when such exists.</assert>

    <!-- Note: Only  TaxTotal is present on header level -->
		<assert id="PEPPOL-T110-R027"
			test="not(//cac:TaxTotal) or (some $cat in $taxCategories satisfies $cat = cbc:ID)"
			flag="fatal">Tax categories MUST match provided tax categories on document level when such exists.</assert>
			

		<assert id="PEPPOL-T110-R019"
			test="cbc:Percent or (normalize-space(cbc:ID)='O')"
			flag="fatal">Each Tax Category SHALL have a TAX category rate, except if the order is not subject to TAX.</assert>
		<assert id="PEPPOL-T110-R020"
			test="not(normalize-space(cbc:ID)='S') or (cbc:Percent) &gt; 0"
			flag="fatal">When TAX category code is "Standard rated" (S) the TAX rate SHALL be greater than zero.</assert>
			
	</rule>
		


<!-- Document totals -->
	
	<rule context="cac:LegalMonetaryTotal">

		<let name="lineExtensionAmount" value="xs:decimal(if (cbc:LineExtensionAmount) then cbc:LineExtensionAmount else 0)"/>
		<let name="allowanceTotalAmount" value="xs:decimal(if (cbc:AllowanceTotalAmount) then cbc:AllowanceTotalAmount else 0)"/>
		<let name="chargeTotalAmount" value="xs:decimal(if (cbc:ChargeTotalAmount) then cbc:ChargeTotalAmount else 0)"/>
		<let name="taxExclusiveAmount" value="xs:decimal(if (cbc:TaxExclusiveAmount) then cbc:TaxExclusiveAmount else 0)"/>
		<let name="taxInclusiveAmount" value="xs:decimal(if (cbc:TaxInclusiveAmount) then cbc:TaxInclusiveAmount else 0)"/>
		<let name="payableRoundingAmount" value="xs:decimal(if (cbc:PayableRoundingAmount) then cbc:PayableRoundingAmount else 0)"/>
		<let name="payableAmount" value="xs:decimal(if (cbc:PayableAmount) then cbc:PayableAmount else 0)"/>
		<let name="prepaidAmount" value="xs:decimal(if (cbc:PrepaidAmount) then cbc:PrepaidAmount else 0)"/>


		<let name="taxTotal" value="xs:decimal(if (/ubl:OrderResponse/cac:TaxTotal/cbc:TaxAmount) then (/ubl:OrderResponse/cac:TaxTotal/cbc:TaxAmount) else 0)"/>
		<let name="allowanceTotal" value="round(sum(/ubl:OrderResponse/cac:AllowanceCharge[cbc:ChargeIndicator='false']/cbc:Amount/xs:decimal(.))* 10 * 10) div 100"/>
		<let name="chargeTotal" value="round(sum(/ubl:OrderResponse/cac:AllowanceCharge[cbc:ChargeIndicator='true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100"/>
		<let name="lineExtensionTotal" value="round(sum(//cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount/xs:decimal(.)) * 10 * 10) div 100"/>

		<assert id="PEPPOL-T110-R014"
				test="count(//cac:OrderLine) = count(//cac:LineItem/cbc:LineExtensionAmount)"
				flag="fatal">If document totals is provided, all order agreement lines SHALL have a line extension amount</assert>

		<assert id="PEPPOL-T110-R005"
				test="not(cbc:PayableAmount) or cbc:PayableAmount &gt;= 0"
				flag="fatal">Total amount for payment SHALL NOT be negative, if expected total amount for payment is provided.</assert>

		<assert id="PEPPOL-T110-R006"
				test="$lineExtensionAmount &gt;= 0"
				flag="fatal">Total amount for payment SHALL NOT be negative, if expected total amount for payment is provided.</assert>

		<assert id="PEPPOL-T110-R007"
				test="not(cbc:LineExtensionAmount) or $lineExtensionAmount = $lineExtensionTotal"
				flag="fatal">Total sum of line amounts SHALL equal the sum of the order line amounts at order line level, if total sum of line amounts is provided.</assert>

		<assert id="PEPPOL-T110-R008"
				test="not(cbc:ChargeTotalAmount) or $chargeTotalAmount = $chargeTotal"
				flag="fatal">Total sum of charges at document level SHALL be equal to the sum of charges at document level, if total sum of charges at document level is provided.</assert>

		<assert id="PEPPOL-T110-R009"
				test="not(cbc:AllowanceTotalAmount) or $allowanceTotalAmount = $allowanceTotal"
				flag="fatal">Total sum of allowance at document level SHALL be equal to the sum of allowance amounts at document level, if total sum of allowance at document level is provided.</assert>

		<assert id="PEPPOL-T110-R010"
				test="not(cbc:TaxExclusiveAmount) or $taxExclusiveAmount = $lineExtensionAmount + $chargeTotalAmount - $allowanceTotalAmount"
				flag="fatal">Tax exclusive amount SHALL equal the sum of line amount plus total charge amount at document level less total allowance amount at document level if tax exclusive amount is provided.</assert>

		<assert id="PEPPOL-T110-R011"
				test="$taxInclusiveAmount = $taxExclusiveAmount + $taxTotal"
				flag="fatal">Tax inclusive amount SHALL equal tax exclusive amount plus total tax amount.</assert>

		<assert id="PEPPOL-T110-R012"
				test="not(cbc:PayableAmount) or $payableAmount = $taxInclusiveAmount - $prepaidAmount + $payableRoundingAmount"
				flag="fatal">Total amount for payment SHALL be equal to the tax inclusive amount minus the prepaid amount plus rounding amount</assert>

	</rule>

	<!-- Allowance/Charge -->
	<rule context="/ubl:OrderResponse/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]">
		<assert id="PEPPOL-T110-R015"
				test="false()"
				flag="fatal">Allowance/charge base amount SHALL be provided when allowance/charge percentage is provided.</assert>
	</rule>

	<rule context="/ubl:OrderResponse/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]">
		<assert id="PEPPOL-T110-R016"
				test="false()"
				flag="fatal">Allowance/charge percentage SHALL be provided when allowance/charge base amount is provided.</assert>
	</rule>

	<rule context="/ubl:OrderResponse/cac:AllowanceCharge">
		<assert id="PEPPOL-T110-R017"
				test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)"
				flag="fatal">Allowance/charge amount SHALL equal base amount * percentage/100 if base amount and percentage exists</assert>
		<assert id="PEPPOL-T110-R018"
				test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)"
				flag="fatal">Each document level allowance SHALL have an allowance reason text or an allowance reason code.</assert>
		<assert  id="PEPPOL-T110-R021"
			test="number(cbc:Amount) &gt;= 0"
			flag="fatal">Document level allowance or charge amounts SHALL NOT be negative.</assert>
	</rule>


	
	<!-- Price -->
	<rule context="cac:Price">
		<assert id="PEPPOL-T110-R001"
			test="number(cbc:PriceAmount) &gt;=0"
			flag="fatal">Each order agreement line item net price SHALL not be negative
		</assert>
		<assert  id="PEPPOL-T110-R022"
			test="(cac:AllowanceCharge/cbc:BaseAmount) &gt;= 0 or not(exists(cac:AllowanceCharge/cbc:BaseAmount))"
			flag="fatal">The Item gross price SHALL NOT be negative.</assert>
		<assert  id="PEPPOL-T110-R023"
			test="number(cac:AllowanceCharge/cbc:Amount) &gt;= 0 or not(exists(cac:AllowanceCharge/cbc:Amount))"
			flag="fatal">Allowance or charge price amounts SHALL NOT be negative.</assert>
	</rule>

	<rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode">
		<assert id="PEPPOL-T110-CL001"
			test="
			some $code in $clUNCL5189
			satisfies normalize-space(text()) = $code"
			flag="fatal">Reason code MUST be according to subset of UNCL 5189 D.16B.</assert>
	</rule>
	
	<rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode">
		<assert id="PEPPOL-T110-CL002"
			test="
			some $code in $clUNCL7161
			satisfies normalize-space(text()) = $code"
			flag="fatal">Reason code MUST be according to UNCL 7161 D.16B.</assert>
	</rule>
</pattern>