<pattern id="greece-sender" xmlns="http://purl.oclc.org/dsdl/schematron">
	<let name="dateRegExp" value="'^(0?[1-9]|[12][0-9]|3[01])[-\\/ ]?(0?[1-9]|1[0-2])[-\\/ ]?(19|20)[0-9]{2}'"/>
	<let name="greekDocumentType" value="tokenize('1.1 1.6 2.1 2.4 5.1 5.2 ','\s')"/>
	<let name="tokenizedUblIssueDate" value="tokenize(/*/cbc:IssueDate,'-')"/>
	<!-- Invoice ID -->
	<rule context="/ubl-invoice:Invoice/cbc:ID[$isGreekSender] | /ubl-creditnote:CreditNote/cbc:ID[$isGreekSender]">
		<let name="IdSegments" value="tokenize(.,'\|')"/>
		<assert id="GR-R-001-1" test="count($IdSegments) = 6" flag="fatal"> When the Supplier is Greek, the Invoice Id should consist of 6 segments</assert>
		<assert id="GR-R-001-2" test="string-length(normalize-space($IdSegments[1])) = 9 
			                              and u:TinVerification($IdSegments[1])
			                              and ($IdSegments[1] = /*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9)
			                              or $IdSegments[1] = /*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9) )" flag="fatal">When the Supplier is Greek, the Invoice Id first segment must be a valid TIN Number and match either the Supplier's or the Tax Representative's Tin Number</assert>
		<let name="tokenizedIdDate" value="tokenize($IdSegments[2],'/')"/>
		<assert id="GR-R-001-3" test="string-length(normalize-space($IdSegments[2]))>0 
			                              and matches($IdSegments[2],$dateRegExp)
			                              and ($tokenizedIdDate[1] = $tokenizedUblIssueDate[3] 
			                                and $tokenizedIdDate[2] = $tokenizedUblIssueDate[2]
			                                and $tokenizedIdDate[3] = $tokenizedUblIssueDate[1])" flag="fatal">When the Supplier is Greek, the Invoice Id second segment must be a valid Date that matches the invoice Issue Date</assert>
		<assert id="GR-R-001-4" test="string-length(normalize-space($IdSegments[3]))>0 and string(number($IdSegments[3])) != 'NaN' and xs:integer($IdSegments[3]) >= 0" flag="fatal">When Supplier is Greek, the Invoice Id third segment must be a positive integer</assert>
		<assert id="GR-R-001-5" test="string-length(normalize-space($IdSegments[4]))>0 and (some $c in $greekDocumentType satisfies $IdSegments[4] = $c)" flag="fatal">When Supplier is Greek, the Invoice Id in the fourth segment must be a valid greek document type</assert>
		<assert id="GR-R-001-6" test="string-length($IdSegments[5]) > 0 " flag="fatal">When Supplier is Greek, the Invoice Id fifth segment must not be empty</assert>
		<assert id="GR-R-001-7" test="string-length($IdSegments[6]) > 0 " flag="fatal">When Supplier is Greek, the Invoice Id sixth segment must not be empty</assert>
	</rule>
	<rule context="cac:AccountingSupplierParty[$isGreekSender]/cac:Party">
		<!-- Supplier Name Mandatory -->
		<assert id="GR-R-002" test="string-length(./cac:PartyName/cbc:Name)>0" flag="fatal">Greek Suppliers must provide their full name as they are registered in the  Greek Business Registry (G.E.MH.) as a legal entity or in the Tax Registry as a natural person </assert>
		<!-- Supplier VAT Mandatory -->
		<assert id="GR-S-011" test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and
				                        substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and
				                        u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))" flag="warning">Greek suppliers must provide their Seller Tax Registration Number, prefixed by the country code</assert>
	</rule>
	<!-- VAT Number Rules -->
	<rule context="cac:AccountingSupplierParty[$isGreekSender]/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID">
		<assert id="GR-R-003" test="substring(.,1,2) = 'EL' and u:TinVerification(substring(.,3))" flag="fatal">For the Greek Suppliers, the VAT must start with 'EL' and must be a valid TIN number</assert>
	</rule>
	<!-- Document Reference Rules (existence of MARK and Invoice Verification URL) -->
	<rule context="/ubl-invoice:Invoice[$isGreekSender and ( /*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'GR')] | /ubl-creditnote:CreditNote[$isGreekSender and ( /*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'GR')]">
		<!-- ΜARK Rules -->
		<assert id="GR-R-004-1" test="count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##M.AR.K##'])=1" flag="fatal"> When Supplier is Greek, there must be one MARK Number</assert>
		<assert id="GR-S-008-1" flag="warning" test="count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE|URL##'])=1"> When Supplier is Greek, there should be one invoice url</assert>
		<assert id="GR-R-008-2" test="(count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE|URL##']) = 0 ) or (count(cac:AdditionalDocumentReference[cbc:DocumentDescription = '##INVOICE|URL##']) = 1 )" flag="fatal"> When Supplier is Greek, there should be no more than one invoice url</assert>
	</rule>
	<!-- MARK Rules -->
	<rule context="cac:AdditionalDocumentReference[$isGreekSender and ( /*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'GR') and cbc:DocumentDescription = '##M.AR.K##']/cbc:ID">
		<assert id="GR-R-004-2" test="matches(.,'^[1-9]([0-9]*)')" flag="fatal"> When Supplier is Greek, the MARK Number must be a positive integer</assert>
	</rule>
	<!-- Invoice Verification URL Rules -->
	<rule context="cac:AdditionalDocumentReference[$isGreekSender and cbc:DocumentDescription = '##INVOICE|URL##']">
		<assert id="GR-R-008-3" test="string-length(normalize-space(cac:Attachment/cac:ExternalReference/cbc:URI))>0" flag="fatal">When Supplier is Greek and the INVOICE URL Document reference exists, the External Reference URI should be present</assert>
	</rule>
	<!-- Customer Name Mandatory -->
	<rule context="cac:AccountingCustomerParty[$isGreekSender]/cac:Party">
		<assert id="GR-R-005" test="string-length(./cac:PartyName/cbc:Name)>0" flag="fatal">Greek Suppliers must provide the full name of the buyer</assert>
	</rule>
	<!-- Endpoint Rules -->
	<rule context="cac:AccountingSupplierParty/cac:Party[$accountingSupplierCountry='GR' or $accountingSupplierCountry='EL']/cbc:EndpointID">
		<assert id="GR-R-009" test="./@schemeID='9933' and u:TinVerification(.)" flag="fatal">Greek suppliers that send an invoice through the PEPPOL network must use a correct TIN number as an electronic address according to PEPPOL Electronic Address Identifier scheme (schemeID 9933).</assert>
	</rule>
</pattern>
