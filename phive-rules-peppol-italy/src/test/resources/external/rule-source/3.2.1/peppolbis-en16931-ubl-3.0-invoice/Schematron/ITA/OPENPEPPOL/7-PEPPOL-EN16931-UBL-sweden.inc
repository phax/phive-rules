<pattern id="UBL-sweden" xmlns="http://purl.oclc.org/dsdl/schematron">
	<rule context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE']">
		<assert id="SE-R-001-NA" test="string-length(normalize-space(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID)) = 14" flag="warning">For Swedish suppliers, Swedish VAT-numbers must consist of 14 characters (not applied in the Italian context).</assert>
		<assert id="SE-R-002-NA" test="string(number(substring(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID, 3, 12))) != 'NaN'" flag="warning">For Swedish suppliers, the Swedish VAT-numbers must have the trailing 12 characters in numeric form (not applied in the Italian context)</assert>
	</rule>
	<rule context="//cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity[../cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cbc:CompanyID]">
		<assert id="SE-R-003-NA" test="string(number(cbc:CompanyID)) != 'NaN'" flag="warning">Swedish organisation numbers should be numeric (not applied in the Italian context).</assert>
		<assert id="SE-R-004-NA" test="string-length(normalize-space(cbc:CompanyID)) = 10" flag="warning">Swedish organisation numbers consist of 10 characters (not applied in the Italian context).</assert>
		<assert id="SE-R-013-NA" test="u:checkSEOrgnr(normalize-space(cbc:CompanyID))" flag="warning">The last digit of a Swedish organization number must be valid according to the Luhn algorithm (not applied in the Italian context).</assert>
	</rule>
	<rule context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and exists(cac:PartyLegalEntity/cbc:CompanyID)]/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) != 'VAT']/cbc:CompanyID">
		<assert id="SE-R-005-NA" test="normalize-space(upper-case(.)) = 'GODKÄND FÖR F-SKATT'" flag="warning">For Swedish suppliers, when using Seller tax registration identifier, 'Godkänd för F-skatt' must be stated (not applied in the Italian context)</assert>
	</rule>
	<rule context="//cac:TaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and cbc:ID = 'S'] | //cac:ClassifiedTaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and cbc:ID = 'S']">
		<assert id="SE-R-006-NA" test="number(cbc:Percent) = 25 or number(cbc:Percent) = 12 or number(cbc:Percent) = 6" flag="warning">For Swedish suppliers, only standard VAT rate of 6, 12 or 25 are used (not applied in the Italian context)</assert>
	</rule>
	<rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:PLUSGIRO']/cac:PayeeFinancialAccount/cbc:ID">
		<assert id="SE-R-007-NA" test="string(number(normalize-space(.))) != 'NaN'" flag="warning">For Swedish suppliers using Plusgiro, the Account ID must be numeric (not applied in the Italian context)</assert>
		<assert id="SE-R-010-NA" test="string-length(normalize-space(.)) &gt;= 2 and string-length(normalize-space(.)) &lt;= 8" flag="warning">For Swedish suppliers using Plusgiro, the Account ID must have 2-8 characters (not applied in the Italian context)</assert>
	</rule>
	<rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:BANKGIRO']/cac:PayeeFinancialAccount/cbc:ID">
		<assert id="SE-R-008-NA" test="string(number(normalize-space(.))) != 'NaN'" flag="warning">For Swedish suppliers using Bankgiro, the Account ID must be numeric (not applied in the Italian context)</assert>
		<assert id="SE-R-009-NA" test="string-length(normalize-space(.)) = 7 or string-length(normalize-space(.)) = 8" flag="warning">For Swedish suppliers using Bankgiro, the Account ID must have 7-8 characters (not applied in the Italian context)</assert>
	</rule>
	<rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('50') or cbc:PaymentMeansCode = normalize-space('56'))]">
		<assert id="SE-R-011-NA" test="false()" flag="warning">For Swedish suppliers using Swedish Bankgiro or Plusgiro, the proper way to indicate this is to use Code 30 for PaymentMeans and FinancialInstitutionBranch ID with code SE:BANKGIRO or SE:PLUSGIRO (not applied in the Italian context)</assert>
	</rule>
	<rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE']  and //cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('31'))]">
		<assert id="SE-R-012-NA" test="false()" flag="warning">For domestic transactions between Swedish trading partners, credit transfer should be indicated by PaymentMeansCode="30" (not applied in the Italian context)</assert>
	</rule>
</pattern>
