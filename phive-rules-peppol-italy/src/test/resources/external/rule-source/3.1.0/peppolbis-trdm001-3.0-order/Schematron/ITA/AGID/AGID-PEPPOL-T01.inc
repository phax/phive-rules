<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="IT-UBL-T01" xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="/ubl:Order" flag="fatal"> 
		<assert test="normalize-space(cbc:CustomizationID) = 'urn:fdc:peppol.eu:poacc:trns:order:3:restrictive:urn:www.agid.gov.it:trns:ordine:3.1'" flag="fatal" id="IT-T01-R001">[IT-T01-R001] - Il CustomizationID dell'Ordine DEVE essere valorizzato con la stringa 'urn:fdc:peppol.eu:poacc:trns:order:3:restrictive:urn:www.agid.gov.it:trns:ordine:3.1'.</assert>
	</rule>

</pattern>

