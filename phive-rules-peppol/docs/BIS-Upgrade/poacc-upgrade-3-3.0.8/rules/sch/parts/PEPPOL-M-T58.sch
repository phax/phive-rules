<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="cbc:CustomizationID">
		<assert id="PEPPOL-T58-R001" 
				test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:catalogue_response:3')"
				flag="fatal">Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:poacc:trns:catalogue_response:3'.</assert>
	</rule>

</pattern>

