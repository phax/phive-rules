<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="IT-UBL-T110" xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="/ubl:OrderResponse" flag="fatal"> 
		<assert test="normalize-space(cbc:CustomizationID) = 'urn:fdc:peppol.eu:poacc:trns:order_agreement:3:restrictive:urn:www.agid.gov.it:trns:ordine_preconcordato:3.0'" flag="fatal" id="IT-T110-R001">[IT-T110-R001] - Il CustomizationID dell'Ordine Pre-concordato DEVE essere valorizzato con la stringa 'urn:fdc:peppol.eu:poacc:trns:order_agreement:3:restrictive:urn:www.agid.gov.it:trns:ordine_preconcordato:3.0'.</assert>
	</rule>

</pattern>

