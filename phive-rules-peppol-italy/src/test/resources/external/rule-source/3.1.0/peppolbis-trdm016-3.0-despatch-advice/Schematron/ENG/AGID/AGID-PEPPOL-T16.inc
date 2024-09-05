<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="IT-UBL-T16" xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="//cbc:EndpointID" flag="fatal">
		<assert test="(@schemeID='0201' and matches(.,'^[a-zA-Z0-9]{6,7}$')) or @schemeID!='0201'" flag="fatal" id="IT-T16-R026">[IT-T16-R026] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:IPA (ICD: 0201), questo dovrà seguire la sintassi [A-Z0-9]{6,7}.</assert>
		<assert test="((@schemeID='9906' or @schemeID='0211') and matches(.,'^(IT)?[0-9]{11}$')) or (@schemeID!='9906' and @schemeID!='0211')" flag="fatal" id="IT-T16-R027">[IT-T16-R027] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:VAT (ICD: 9906, 0211), questo dovrà seguire la sintassi (IT)?[0-9]{11}.</assert>
		<assert test="((@schemeID='9907' or @schemeID='0210') and matches(.,'^[0-9]{11}$|^[A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1}$')) or (@schemeID!='9907' and @schemeID!='0210')" flag="fatal" id="IT-T16-R028">[IT-T16-R028] - Se l'identificatore di endpoint si basa sullo schema di identificatori IT:CF (ICD: 9907, 0211), questo dovrà seguire la sintassi [0-9]{11} per le persone giuridiche e la sintassi [A-Z]{6}\d{2}[ABCDEHLMPRST]{1}\d{2}[A-Z]{1}\d{3}[A-Z]{1} per quelle fisiche.</assert>
	</rule>

	<rule context="//cac:DespatchLine" flag="fatal"> 
		<assert test="cac:Item/cbc:Name and (cac:Item/cac:SellersItemIdentification/cbc:ID or cac:Item/cac:StandardItemIdentification/cbc:ID) and cbc:DeliveredQuantity" flag="fatal" id="IT-T16-R003">[IT-T16-R003] - Le righe del DDT DEVONO contenere le informazioni minime previste dall’Art. 21, comma 4 del DPR n. 633/1972 (Nome articolo merce, identificativo articolo e quantità consegnata).</assert>
	</rule>

	<rule context="//cac:DespatchLine/cac:Item/cac:HazardousItem" flag="fatal"> 
		<assert test="cbc:UNDGCode" flag="fatal" id="IT-T16-R029">[IT-T16-R029] - L'elemento 'cbc:UNDGCode' DEVE essere valorizzato.</assert>
		<assert test="cbc:HazardClassID" flag="fatal" id="IT-T16-R030">[IT-T16-R030] - L'elemento 'cbc:HazardClassID' DEVE essere valorizzato.</assert>
	</rule>

	<rule context="/ubl:DespatchAdvice" flag="fatal"> 
		<assert test="normalize-space(cbc:CustomizationID) = 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3:extended:urn:www.agid.gov.it:trns:ddt:3.1'" flag="fatal" id="IT-T16-R004">[IT-T16-R004] - Il CustomizationID del Documento di Trasporto DEVE essere valorizzato con la stringa 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3:extended:urn:www.agid.gov.it:trns:ddt:3.1'.</assert>
		<assert test="cac:DespatchSupplierParty/cac:Party[cac:PartyLegalEntity/cbc:RegistrationName and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity] and cac:DeliveryCustomerParty/cac:Party[cac:PartyLegalEntity/cbc:RegistrationName and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity] and (not(cac:BuyerCustomerParty) or (cac:BuyerCustomerParty/cac:Party[cac:PartyName/cbc:Name and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity])) and (not(cac:SellerSupplierParty) or (cac:SellerSupplierParty/cac:Party[cac:PartyName/cbc:Name and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity])) and cac:Shipment/cbc:GrossWeightMeasure and cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and (not(cac:Shipment/cac:Consignment/cac:CarrierParty) or (cac:Shipment/cac:Consignment/cac:CarrierParty[cac:PartyName/cbc:Name and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity]))" flag="fatal" id="IT-T16-R002">[IT-T16-R002] - La testata del DDT DEVE contenere le informazioni minime previste dall’Art. 21, comma 4 del DPR n. 633/1972 (Identificativo, nome e indirizzo dello Speditore / Cedente, nome e indirizzo del Consegnatario / Cessionario, peso lordo e numero colli della spedizione, generalità del Trasportatore e indirizzo, se una terza parte effettua il trasporto fisico).</assert>
		<assert test="cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and (string(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) castable as xs:integer or cac:Shipment/cbc:TotalTransportHandlingUnitQuantity - floor(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) = 0)" flag="fatal" id="IT-T16-R005">[IT-T16-R005] - Il numero dei colli deve essere un intero.</assert>
	</rule>

	<rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment">
		<assert test="cac:CarrierParty" flag="fatal" id="IT-T16-R031">[IT-T16-R031] - L'elemento 'cac:CarrierParty' DEVE essere valorizzato.</assert>
		<assert test="(some $code in $clISO3166 satisfies $code = normalize-space(cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode/text()))" flag="fatal" id="IT-T16-R032">[IT-T16-R032] - L'elemento 'cac:Country/cbc:IdentificationCode' DEVE essere valorizzato in base alla codifica dei Paesi (ISO 3166-1:Alpha2).</assert>
	</rule>

</pattern>

