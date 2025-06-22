<pattern id="greece-senderreceiver" xmlns="http://purl.oclc.org/dsdl/schematron">
	<!-- VAT Number Rules -->
	<rule context="cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party">
		<assert id="GR-R-006-NA" test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and
				                        substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and
				                        u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))" flag="warning">Greek Suppliers must provide the VAT number of the buyer, if the buyer is Greek (not applied in the Italian context)</assert>
	</rule>
	<!-- Endpoint Rules -->
	<rule context="cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party/cbc:EndpointID">
		<assert id="GR-R-010-NA" test="./@schemeID='9933' and u:TinVerification(.)" flag="warning">Greek Suppliers that send an invoice through the PEPPOL network to a greek buyer must use a correct TIN number as an electronic address according to PEPPOL Electronic Address Identifier scheme (SchemeID 9933) (not applied in the Italian context)</assert>
	</rule>
</pattern>