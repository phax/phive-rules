<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="IT-UBL-T16" xmlns="http://purl.oclc.org/dsdl/schematron">

	<rule context="/ubl:DespatchAdvice" flag="fatal"> 
		<assert test="normalize-space(cbc:CustomizationID) = 'urn:fdc:peppol.eu:poacc:trns:despatch_advice:3:extended:urn:www.agid.gov.it:trns:ddt:3.1'" flag="fatal" id="IT-T16-R001">[IT-T16-R001] - L'elemento 'Specification identification - Tipo documento' (cbc:CustomizationID) DEVE essere valorizzato con la stringa urn:fdc:peppol.eu:poacc:trns:despatch_advice:3:extended:urn:www.agid.gov.it:trns:ddt:3.1.</assert>
		<assert test="cac:BuyerCustomerParty" flag="fatal" id="IT-T16-R014">[IT-T16-R014] - L'elemento 'Buyer - Acquirente' (cac:BuyerCustomerParty) DEVE essere valorizzato.</assert>
		<assert test="cac:SellerSupplierParty" flag="fatal" id="IT-T16-R020">[IT-T16-R020] - L'elemento 'Seller - Venditore' (cac:SellerSupplierParty) DEVE essere valorizzato.</assert>
		<assert test="not (cac:OriginatorCustomerParty) or (cac:OriginatorCustomerParty/cac:Party/cac:PartyName)" flag="fatal" id="IT-T16-R026">[IT-T16-R026] - Se la struttura del Richiedente è presente, l'elemento 'Party name - Denominazione della parte' relativo al Richiedente (cac:OriginatorCustomerParty/cac:Party/cac:PartyName) DEVE essere valorizzato.</assert>
		<assert test="cac:OrderReference or cac:DespatchLine/cac:OrderLineReference/cac:OrderReference" flag="fatal" id="IT-T16-R033">[IT-T16-R033] - Il DDT deve riportare il riferimento ad almeno un ordine d'acquisto, che può essere indicato in testata, in riga o in entrambi - Almeno uno degli elementi 'Order reference - Riferimento all'ordine' (cac:OrderReference) oppure 'Order reference - Riferimento all'ordine' (cac:DespatchLine/cac:OrderLineReference/cac:OrderReference) DEVE essere valorizzato.</assert>
		<assert test="cac:Shipment" flag="fatal" id="IT-T16-R034">[IT-T16-R034] - L'elemento 'Shipment information - Informazioni sulla spedizione' (cac:Shipment) DEVE essere valorizzato.</assert>
		<assert test="cac:Shipment/cac:Consignment" flag="fatal" id="IT-T16-R045">[IT-T16-R045] - L'elemento 'Consignment information - Informazioni sul trasporto' (cac:Shipment/cac:Consignment) DEVE essere  valorizzato.</assert>
		<assert test="cac:Shipment/cbc:GrossWeightMeasure" flag="fatal" id="IT-T16-R035">[IT-T16-R035] - L'elemento 'Shipment gross weight - Peso lordo' (cac:Shipment/cbc:GrossWeightMeasure) DEVE essere valorizzato.</assert>
		<assert test="cac:Shipment/cbc:TotalTransportHandlingUnitQuantity and (string(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) castable as xs:integer or cac:Shipment/cbc:TotalTransportHandlingUnitQuantity - floor(cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) = 0)" flag="fatal" id="IT-T16-R036">[IT-T16-R036] - L'elemento 'Total number of transport handling units - Numero Colli' (cac:Shipment/cbc:TotalTransportHandlingUnitQuantity) DEVE essere valorizzato e DEVE contenere un numero intero.</assert>
		<assert test="cac:Shipment/cac:Delivery" flag="fatal" id="IT-T16-R037">[IT-T16-R037] - L'elemento 'Delivery information - Informazioni consegna' (cac:Shipment/cac:Delivery) DEVE essere  valorizzato.</assert>
		<assert test="cac:Shipment/cac:Delivery/cac:Despatch" flag="fatal" id="IT-T16-R038">[IT-T16-R038] - L'elemento 'Actual or expected despatch period - Ulteriori informazioni di consegna' (cac:Shipment/cac:Delivery/cac:Despatch) DEVE essere  valorizzato.</assert>
		<assert test="cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress" flag="fatal" id="IT-T16-R039">[IT-T16-R039] - L'elemento 'Despatch address - Indirizzo di consegna' (cac:Shipment/cac:Delivery/cac:Despatch/cac:DespatchAddress) DEVE essere  valorizzato.</assert>
	</rule>
		
	<rule context="//cac:DespatchLine" flag="fatal"> 
		<assert test="cac:OrderLineReference" flag="fatal" id="IT-T16-R040">[IT-T16-R040] - L'elemento 'Order line reference - Riferimento alla riga d'ordine' (cac:DespatchLine/cac:OrderLineReference) DEVE essere valorizzato e può essere ripetuto più volte all'interno della stessa riga di DDT.</assert>
	</rule>
	
	<rule context="//cac:DespatchLine/cac:Item" flag="fatal"> 
		<assert test="cac:SellersItemIdentification or cac:StandardItemIdentification" flag="fatal" id="IT-T16-R041">[IT-T16-R041] - Almeno uno degli elementi 'Sellers item identification - Identificativo articolo attribuito dal Fornitore' (cac:DespatchLine/cac:Item/cac:SellersItemIdentification) oppure 'Standard item identification - Identificativo standard dell'articolo' (cac:DespatchLine/cac:Item/cac:StandardItemIdentification) DEVE essere valorizzato.</assert>
	</rule>
		
	<rule context="//cac:DespatchLine/cac:Item/cac:HazardousItem" flag="fatal"> 
		<assert test="cbc:UNDGCode" flag="fatal" id="IT-T16-R042">[IT-T16-R042] - L'elemento 'Hazardous item UNDG code - Codice UNDG pericolosità merce' (cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:UNDGCode) DEVE essere valorizzato.</assert>
		<assert test="cbc:HazardClassID" flag="fatal" id="IT-T16-R043">[IT-T16-R043] - L'elemento 'Hazardous hazard class Identifier - Classe di pericolosità' (cac:DespatchLine/cac:Item/cac:HazardousItem/cbc:HazardClassID) DEVE essere valorizzato.</assert>
	</rule>
		
	<rule context="/ubl:DespatchAdvice/cac:Shipment/cac:Consignment">
		<assert test="cac:CarrierParty" flag="fatal" id="IT-T16-R027">[IT-T16-R027] - L'elemento 'Carrier party - Vettore' (cac:Shipment/cac:Consignment/cac:CarrierParty) DEVE essere valorizzato.</assert>
		<assert test="(some $code in $clISO3166 satisfies $code = normalize-space(cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode/text()))" flag="fatal" id="IT-T16-R044">[IT-T16-R044] - L'elemento 'Country code - Codice nazione' (cac:PostalAddress/cac:Country/cbc:IdentificationCode) DEVE essere valorizzato in base alla codifica dei Paesi (Country Codes - ISO 3166-1:Alpha2).</assert>
	</rule>

	
	<rule context="//cac:DespatchSupplierParty/cac:Party" flag="fatal">
		<assert test="cac:PartyIdentification" flag="fatal" id="IT-T16-R005">[IT-T16-R005] - L'elemento 'Party identification - Identificazione del soggetto Speditore' (cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification) DEVE essere valorizzato.</assert>
		<assert test="cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT' or (cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT' and (cac:PartyIdentification/cbc:ID/@schemeID='0210' or cac:PartyIdentification/cbc:ID/@schemeID='0211'))" flag="fatal" id="IT-T16-R006">[IT-T16-R006] - Se lo Speditore è un soggetto italiano (cac:PostalAddress/cac:Country/cbc:IdentificationCode = "IT"), allora l'elemento 'schemeID dell'Identificativo dello Speditore' (cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) è obbligatorio e deve essere pari a "0210" oppure "0211".</assert>
		<assert test="cac:PostalAddress and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity" flag="fatal" id="IT-T16-R009">[IT-T16-R009] - L'elemento 'Postal address - Indirizzo dello Speditore' (cac:DespatchSupplierParty/cac:Party/cac:PostalAddress) DEVE essere valorizzato. Gli elementi 'Indirizzo dello Speditore' (cbc:StreetName), 'Città' (cbc:CityName), 'CAP' (cbc:PostalZone), 'Provincia' (cbc:CountrySubentity) DEVONO essere valorizzati.</assert>
	</rule>
	
	<rule context="//cac:DeliveryCustomerParty/cac:Party" flag="fatal">
		<assert test="cac:PartyIdentification" flag="fatal" id="IT-T16-R010">[IT-T16-R010] - L'elemento 'Party identification - Identificazione del soggetto Consegnatario' (cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification) DEVE essere valorizzato.</assert>
		<assert test="cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT' or (cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT' and cac:PartyIdentification/cbc:ID/@schemeID='0210')" flag="fatal" id="IT-T16-R011">[IT-T16-R011] - Se il Consegnatario è un soggetto italiano (cac:PostalAddress/cac:Country/cbc:IdentificationCode = "IT"), allora l'elemento 'schemeID dell'Identificativo del Consegnatario' (cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) è obbligatorio e deve essere pari a "0210".</assert>
		<assert test="cac:PostalAddress and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity" flag="fatal" id="IT-T16-R013">[IT-T16-R013] - L'elemento 'Postal address - Indirizzo del Consegnatario' (cac:DeliveryCustomerParty/cac:Party/cac:PostalAddress) DEVE essere valorizzato. Gli elementi 'Indirizzo del Consegnatario' (cbc:StreetName), 'Città' (cbc:CityName), 'CAP' (cbc:PostalZone), 'Provincia' (cbc:CountrySubentity) DEVONO essere valorizzati.</assert>
	</rule>
	
	<rule context="//cac:BuyerCustomerParty/cac:Party" flag="fatal">
		<assert test="cac:PartyIdentification" flag="fatal" id="IT-T16-R015">[IT-T16-R015] - L'elemento 'Party identification - Identificazione del soggetto Acquirente' (cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification) DEVE essere valorizzato.</assert>
		<assert test="cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT' or (cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT' and cac:PartyIdentification/cbc:ID/@schemeID='0210')" flag="fatal" id="IT-T16-R016">[IT-T16-R016] - Se l'Acquirente è un soggetto italiano (cac:PostalAddress/cac:Country/cbc:IdentificationCode = "IT"), allora l'elemento 'schemeID dell'Identificativo dell'Acquirente' (cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) è obbligatorio e deve essere pari a "0210".</assert>
		<assert test="cac:PartyName" flag="fatal" id="IT-T16-R018">[IT-T16-R018] - L'elemento 'Party name - Denominazione della parte' relativo all'Acquirente (cac:BuyerCustomerParty/cac:Party/cac:PartyName) DEVE essere valorizzato.</assert>
		<assert test="cac:PostalAddress and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity" flag="fatal" id="IT-T16-R019">[IT-T16-R019] - L'elemento 'Postal address - Indirizzo dell'Acquirente' (cac:BuyerCustomerParty/cac:Party/cac:PostalAddress) DEVE essere valorizzato. Gli elementi 'Indirizzo dell'Acquirente' (cbc:StreetName), 'Città' (cbc:CityName), 'CAP' (cbc:PostalZone), 'Provincia' (cbc:CountrySubentity) DEVONO essere valorizzati.</assert>
	</rule>
		
	<rule context="//cac:SellerSupplierParty/cac:Party" flag="fatal">
		<assert test="cac:PartyIdentification" flag="fatal" id="IT-T16-R021">[IT-T16-R021] - L'elemento 'Party identification - Identificazione del soggetto Venditore' (cac:SellerSupplierParty/cac:Party/cac:PartyIdentification) DEVE essere valorizzato.</assert>
		<assert test="cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT' or (cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT' and cac:PartyIdentification/cbc:ID/@schemeID='0210' or cac:PartyIdentification/cbc:ID/@schemeID='0211')" flag="fatal" id="IT-T16-R022">[IT-T16-R022] - Se il Venditore è un soggetto italiano (cac:PostalAddress/cac:Country/cbc:IdentificationCode = "IT"), allora l'elemento 'schemeID dell'Identificativo del Venditore' (cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) è obbligatorio e deve essere pari a  "0210" oppure "0211" .</assert>
		<assert test="cac:PartyName" flag="fatal" id="IT-T16-R024">[IT-T16-R024] - L'elemento 'Party name - Denominazione della parte' relativo al Venditore (cac:SellerSupplierParty/cac:Party/cac:PartyName) DEVE essere valorizzato.</assert>
		<assert test="cac:PostalAddress and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity" flag="fatal" id="IT-T16-R025">[IT-T16-R025] - L'elemento 'Postal address - Indirizzo del Venditore' (cac:SellerSupplierParty/cac:Party/cac:PostalAddress) DEVE essere valorizzato. Gli elementi 'Indirizzo del Venditore' (cbc:StreetName), 'Città' (cbc:CityName), 'CAP' (cbc:PostalZone), 'Provincia' (cbc:CountrySubentity) DEVONO essere valorizzati.</assert>
	</rule>
	
	<rule context="ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty" flag="fatal">
		<assert test="cac:PartyIdentification" flag="fatal" id="IT-T16-R028">[IT-T16-R028] - L'elemento 'Party identification - Identificazione del soggetto Vettore' (cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification) DEVE essere valorizzato.</assert>
		<assert test="cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT' or (cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT' and cac:PartyIdentification/cbc:ID/@schemeID='0210' or cac:PartyIdentification/cbc:ID/@schemeID='0211')" flag="fatal" id="IT-T16-R029">[IT-T16-R029] - Se il Vettore è un soggetto italiano (cac:PostalAddress/cac:Country/cbc:IdentificationCode = "IT"), allora l'elemento 'schemeID dell'Identificativo del Vettore' (cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification/cbc:ID/@schemeID) è obbligatorio e deve essere pari a "0210" oppure "0211".</assert>
		<assert test="cac:PartyName" flag="fatal" id="IT-T16-R031">[IT-T16-R031] - L'elemento 'Party name - Denominazione della parte' relativo al Vettore (cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyName) DEVE essere valorizzato.</assert>
		<assert test="cac:PostalAddress and cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cbc:CountrySubentity" flag="fatal" id="IT-T16-R032">[IT-T16-R032] - L'elemento 'Postal address - Indirizzo del Vettore' (cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PostalAddress) DEVE essere valorizzato. Gli elementi 'Indirizzo del Vettore' (cbc:StreetName), 'Città' (cbc:CityName), 'CAP' (cbc:PostalZone), 'Provincia' (cbc:CountrySubentity) DEVONO essere valorizzati.</assert>
	</rule>
		
	<rule context="//cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" flag="fatal">
		<assert test="not (@schemeID='0211') or (@schemeID='0211' and matches(.,'^IT?[0-9]{11}$'))" flag="fatal" id="IT-T16-R007">[IT-T16-R007] - Se lo Speditore è un soggetto italiano (cac:PostalAddress/cac:Country/cbc:IdentificationCode = "IT") e lo schemeID dell'Identificativo dello Speditore (cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) è pari a "0211", allora l'elemento 'Identificativo dello Speditore' (cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) deve avere una lunghezza pari a 13 caratteri alfanumerici e deve iniziare con la stringa "IT" seguita da 11 cifre.</assert>
		<assert test="not (@schemeID='0210') or (@schemeID='0210' and matches(.,'^[a-zA-Z0-9]{11,16}$'))" flag="fatal" id="IT-T16-R008">[IT-T16-R008] - Se lo Speditore è un soggetto italiano (cac:PostalAddress/cac:Country/cbc:IdentificationCode = "IT") e lo schemeID dell'Identificativo dello Speditore (cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) è pari a "0210", allora l'elemento 'Identificativo dello Speditore' (cac:DespatchSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) deve avere una lunghezza compresa tra 11 e 16 caratteri alfanumerici.</assert>
	</rule>
	
	<rule context="//cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" flag="fatal">
		<assert test="not (@schemeID='0210') or (@schemeID='0210' and matches(.,'^[a-zA-Z0-9]{11,16}$'))" flag="fatal" id="IT-T16-R012">[IT-T16-R012] - Se il Consegnatario è un soggetto italiano (cac:PostalAddress/cac:Country/cbc:IdentificationCode = "IT") e lo schemeID dell'Identificativo del Consegnatario (cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) è pari a "0210", allora l'elemento 'Identificativo del Consegnatario' (cac:DeliveryCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID) deve avere una lunghezza compresa tra 11 e 16 caratteri alfanumerici.</assert>
	</rule>
	
	<rule context="//cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" flag="fatal">
		<assert test="not (@schemeID='0210') or (@schemeID='0210' and matches(.,'^[a-zA-Z0-9]{11,16}$'))" flag="fatal" id="IT-T16-R017">[IT-T16-R017] - Se l'Acquirente è un soggetto italiano (cac:PostalAddress/cac:Country/cbc:IdentificationCode = "IT") e lo schemeID dell'Identificativo dell'Acquirente (cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) è pari a "0210", allora l'elemento 'Identificativo dell'Acquirente' (cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID) deve avere una lunghezza compresa tra 11 e 16 caratteri alfanumerici.</assert>
	</rule>
	
	<rule context="//cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" flag="fatal">
		<assert test="not (@schemeID='0211') or (@schemeID='0211' and matches(.,'^IT?[0-9]{11}$'))" flag="fatal" id="IT-T16-R023">[IT-T16-R023] - Se il Venditore è un soggetto italiano (cac:PostalAddress/cac:Country/cbc:IdentificationCode = "IT") e lo schemeID dell'Identificativo del Venditore (cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID) è pari a "0211", allora l'elemento 'Identificativo del Venditore' (cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) deve avere una lunghezza pari a 13 caratteri alfanumerici e deve iniziare con la stringa "IT" seguita da 11 cifre.</assert>
	</rule>
	
	<rule context="ubl:DespatchAdvice/cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification/cbc:ID" flag="fatal">
		<assert test="not (@schemeID='0211') or (@schemeID='0211' and matches(.,'^IT?[0-9]{11}$'))" flag="fatal" id="IT-T16-R030">[IT-T16-R030] - Se il Vettore è un soggetto italiano (cac:PostalAddress/cac:Country/cbc:IdentificationCode = "IT") e lo schemeID dell'Identificativo del Vettore (cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification/cbc:ID/@schemeID) è pari a "0211", allora l'elemento 'Identificativo del Vettore' (cac:Shipment/cac:Consignment/cac:CarrierParty/cac:PartyIdentification/cbc:ID/@schemeID) deve avere una lunghezza pari a 13 caratteri alfanumerici e deve iniziare con la stringa "IT" seguita da 11 cifre.</assert>
	</rule>
	
	<rule context="//cbc:EndpointID" flag="fatal">
		<assert test="(@schemeID='0201' and matches(.,'^[a-zA-Z0-9]{6}$')) or @schemeID!='0201'" flag="fatal" id="IT-T16-R002">[IT-T16-R002] - Se l'elemento 'schemeID' dell'EndpointID' (cbc:EndpointID/@schemeID) è pari a "0201", allora la lunghezza dell'elemento 'EndpointID' (cbc:EndpointID) DEVE essere pari a 6 caratteri alfanumerici [A-Z;0-9].</assert>
		<assert test="(@schemeID='0210' and matches(.,'^[a-zA-Z0-9]{11,16}$')) or @schemeID!='0210'" flag="fatal" id="IT-T16-R003">[IT-T16-R003] - Se l'elemento 'schemeID dell'EndpointID' (cbc:EndpointID/@schemeID) è pari a "0210", allora la lunghezza dell'elemento 'EndpointID' (cbc:EndpointID) DEVE essere compresa tra 11 e 16 caratteri alfanumerici.</assert>
		<assert test="(@schemeID='0211' and matches(.,'^IT?[0-9]{11}$')) or @schemeID!='0211'" flag="fatal" id="IT-T16-R004">[IT-T16-R004] - Se l'elemento 'schemeID dell'EndpointID' (cbc:EndpointID/@schemeID) è pari a "0211", allora la lunghezza dell'elemento 'EndpointID' (cbc:EndpointID) DEVE essere pari a 13 caratteri alfanumerici e deve iniziare con la stringa "IT" seguita da 11 cifre.</assert>
	</rule>

</pattern>

