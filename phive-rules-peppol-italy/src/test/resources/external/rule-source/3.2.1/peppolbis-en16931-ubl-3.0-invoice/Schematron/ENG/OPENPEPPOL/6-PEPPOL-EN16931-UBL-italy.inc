<pattern id="UBL-italy" xmlns="http://purl.oclc.org/dsdl/schematron">
		<rule context="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'IT']/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) != 'VAT']">
			<assert id="IT-R-001" test="matches(normalize-space(cbc:CompanyID),'^[A-Z0-9]{11,16}$')" flag="fatal">[IT-R-001] BT-32 (Seller tax registration identifier) - For Italian suppliers BT-32 minimum length 11 and maximum length shall be 16.  Per i fornitori italiani il BT-32 deve avere una lunghezza tra 11 e 16 caratteri</assert>
		</rule>
		<rule context="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'IT']">
			<assert id="IT-R-002" test="cac:PostalAddress/cbc:StreetName" flag="fatal">[IT-R-002] BT-35 (Seller address line 1) - Italian suppliers MUST provide the postal address line 1 - I fornitori italiani devono indicare l'indirizzo postale.</assert>
			<assert id="IT-R-003" test="cac:PostalAddress/cbc:CityName" flag="fatal">[IT-R-003] BT-37 (Seller city) - Italian suppliers MUST provide the postal address city - I fornitori italiani devono indicare la città di residenza.</assert>
			<assert id="IT-R-004" test="cac:PostalAddress/cbc:PostalZone" flag="fatal">"[IT-R-004] BT-38 (Seller post code) - Italian suppliers MUST provide the postal address post code - I fornitori italiani devono indicare il CAP di residenza.</assert>
		</rule>
	</pattern>