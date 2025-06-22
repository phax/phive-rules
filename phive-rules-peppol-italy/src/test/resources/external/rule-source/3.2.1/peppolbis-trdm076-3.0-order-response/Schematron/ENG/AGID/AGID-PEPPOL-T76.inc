<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="IT-UBL-T76" xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="/ubl:OrderResponse" flag="fatal"> 
		<assert test="normalize-space(cbc:CustomizationID) = 'urn:fdc:peppol.eu:poacc:trns:order_response:3:restrictive:urn:www.agid.gov.it:trns:risposta_ordine:3.0'" flag="fatal" id="IT-T76-R001">[IT-T76-R001] - Il CustomizationID della Risposta d'Ordine DEVE essere valorizzato con la stringa 'urn:fdc:peppol.eu:poacc:trns:order_response:3:restrictive:urn:www.agid.gov.it:trns:risposta_ordine:3.0'.</assert>
	</rule>

</pattern>

