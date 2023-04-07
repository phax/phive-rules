<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="Italy-CIUS-rules" xmlns="http://purl.oclc.org/dsdl/schematron">

	<!-- Document Level -->
	
	<!--rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode!='IT']" flag="fatal">
		<assert test="cbc:ProfileID = 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0' and cbc:CustomizationID = 'urn:cen.eu:en16931:2017#compliant#urn:fatturapa.gov.it:CIUS-IT:2.0.0'" flag="fatal" id="BR-IT-000">[BR-IT-000] - Se il valore dell’elemento BT-40 (Seller country code) è diverso da "IT", il BT-24 deve essere valorizzato come segue: urn:cen.eu:en16931:2017#compliant#urn:fatturapa.gov.it:CIUS-IT:2.0.0</assert>
	</rule-->

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode!='IT']" flag="fatal">
		<assert test="cbc:ProfileID = 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0' and cbc:CustomizationID = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#compliant#urn:www.agid.gov.it:trns:fattura:3'" flag="fatal" id="BR-IT-001">[BR-IT-001] - Se il valore dell’elemento BT-40 (Seller country code) è diverso da "IT", il BT-24 deve essere valorizzato come segue: urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#compliant#urn:www.agid.gov.it:trns:fattura:3</assert>
	</rule>
	
	<rule context="/*/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin})*[0-9]+(\p{IsBasicLatin})*$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 20" flag="fatal" id="BR-IT-010">[BR-IT-010] - BT-1 (Invoice number) maximum lenght shall be 20 chars with at least one digit - La lunghezza dell'elemento non può superare i 20 caratteri e deve includere almeno una cifra.</assert>
	</rule>

	<rule context="/*/cac:ProjectReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,15}$')" flag="fatal" id="BR-IT-020">[BR-IT-020] - BT-11 (Project reference) maximum lenght shall be 15 chars - La lunghezza dell'elemento non può superare i 15 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:ContractDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-030">[BR-IT-030] - BT-12 (Contract reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:OrderReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-040">[BR-IT-040] - BT-13 (Purchase order reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:ReceiptDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-050">[BR-IT-050] - BT-15 (Receiving advice reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:DespatchDocumentReference" flag="fatal">
		<assert test="matches(cbc:ID,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-060">[BR-IT-060] - BT-16 (Despatch advice reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:OriginatorDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,15}$')" flag="fatal" id="BR-IT-070">[BR-IT-070] - BT-17 (Tender or lot reference) maximum lenght shall be 15 chars - La lunghezza dell'elemento non può superare i 15 caratteri.</assert>
	</rule>
	
	<rule context="/*/cbc:AccountingCost" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-080">[BR-IT-080] - BT-19 (Buyer accounting reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-090">[BR-IT-090] - BT-25 (Preceding Invoice number) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyIdentification/cbc:ID[starts-with(., 'EORI:')]" flag="fatal">
		<assert test="matches(.,'^EORI:[A-Z0-9]{18,22}$')" flag="fatal" id="BR-IT-DC-100A">[BR-IT-DC-100A] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT29 Seller identifier comincia con "EORI:", la sua lunghezza deve essere compresa fra 18 e 22 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyIdentification/cbc:ID[starts-with(., 'ALBO:')]" flag="fatal">
		<assert test="matches(.,'^ALBO:[a-zA-Z]+:[A-Z0-9]+$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 137" flag="fatal" id="BR-IT-DC-100B">[BR-IT-DC-100B] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT29 Seller identifier comincia con "ALBO:", la sua lunghezza non può superare i 137 caratteri e può essere indicato come "ALBO:AlboProfessionale#NumeroIscrizioneAlbo#DataIscrizione" (con Data nel formato AAAA-MM-GG).</assert>
	</rule>

	<!--rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyLegalEntity/cbc:CompanyID[starts-with(., 'REA:')]" flag="fatal">
		<assert test="matches(.,'^REA:[a-zA-Z0-9]+:[A-Z0-9]+$') and string-length(.) &gt;= 8 and string-length(.) &lt;= 27" flag="fatal" id="BR-IT-DC-110">[BR-IT-DC-110] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-30 Seller legal registration identifier comincia con "REA:", la sua lunghezza deve essere compresa fra 8 e 27 caratteri e deve essere indicato come "REA:Ufficio#NumeroREA". 

Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-29 Seller identifier comincia con "CF:", la sua lunghezza deve essere compresa fra 14 e 19 caratteri.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyLegalEntity/cbc:CompanyID[starts-with(., 'CF:')]" flag="fatal">
		<assert test="matches(.,'^CF:[A-Z0-9]{14,19}$')" flag="fatal" id="BR-IT-DC-110">[BR-IT-DC-110] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-30 Seller legal registration identifier comincia con "REA:", la sua lunghezza deve essere compresa fra 8 e 27 caratteri e deve essere indicato come "REA:Ufficio#NumeroREA". 

Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-29 Seller identifier comincia con "CF:", la sua lunghezza deve essere compresa fra 14 e 19 caratteri.</assert>
	</rule-->
	
	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyLegalEntity/cbc:CompanyID[starts-with(., 'REA:')]" flag="fatal">
		<assert test="matches(.,'^REA:[a-zA-Z0-9]+:[A-Z0-9]+$') and string-length(.) &gt;= 8 and string-length(.) &lt;= 27" flag="fatal" id="BR-IT-DC-111A">[BR-IT-DC-111A] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-30 Seller legal registration identifier comincia con "REA:", la sua lunghezza deve essere compresa fra 8 e 27 caratteri e deve essere indicato come "REA:Ufficio#NumeroREA".</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0210']" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{11,16}$')" flag="fatal" id="BR-IT-DC-111B">[BR-IT-DC-111B] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se l'elemento BT-30-1 (Seller legal registration identifier scheme identifier) contiene il valore "0210", l'elemento BT-30 (Seller legal registration identifier) deve contenere un Codice Fiscale con lunghezza compresa fra 11 e 16 caratteri.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">
		<assert test="matches(.,'^[a-zA-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-120">[BR-IT-120] - BT-31 (Seller VAT identifier) maximum lenght shall be 30 chars - La lunghezza dell'elemento non può superare i 30 caratteri.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm" flag="fatal">
		<assert test="string-length(.) &lt;= 19" flag="fatal" id="BR-IT-DC-122">[BR-IT-DC-122][FPA 1.2.4.3 CapitaleSociale, 1.2.4.4 SocioUnico, 1.2.4.5 StatoLiquidazione] - La lunghezza dell'elemento non può superare i 19 caratteri.</assert>
	</rule>	

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<!--assert test="cbc:ProfileID = 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0' and cbc:CustomizationID = 'urn:cen.eu:en16931:2017#compliant#urn:fatturapa.gov.it:CIUS-IT:2.0.0#conformant#urn:fatturapa.gov.it:EXT-IT:1.0.0'" flag="fatal" id="BR-IT-DC-001">[BR-IT-DC-001] - Se il valore dell’elemento BT-40 (Seller country code) è uguale a "IT", il BT-24 deve essere valorizzato come segue: urn:cen.eu:en16931:2017#compliant#urn:fatturapa.gov.it:CIUS-IT:2.0.0#conformant#urn:fatturapa.gov.it:EXT-IT:1.0.0</assert-->
		<assert test="cbc:ProfileID = 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0' and cbc:CustomizationID = 'urn:cen.eu:en16931:2017#compliant#urn:fatturapa.gov.it:CIUS-IT:2.0.0#conformant#urn:fatturapa.gov.it:EXT-IT:1.0.0'" flag="fatal" id="BR-IT-DC-002">[BR-IT-DC-002] - Se il valore dell’elemento BT-40 (Seller country code) è uguale a "IT", il BT-24 deve essere valorizzato come segue: urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:www.agid.gov.it:trns:fattura:3</assert>
		<assert test="((not(contains(normalize-space(cac:PostalAddress/cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cac:PostalAddress/cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-DC-150">[BR-IT-DC-150] - Se l'elemento BT-40 (Seller country code) ha valore "IT", per l'elemento BT-39 Seller country subdivision deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione è riportata in allegato.</assert>
		<!-- Esigibilità: Split Payment -->
		<assert test="count(//cac:TaxCategory[cbc:ID='B'] | //cac:ClassifiedTaxCategory[cbc:ID='B'])=0 or (count(//cac:TaxCategory[cbc:ID='B'] | //cac:ClassifiedTaxCategory[cbc:ID='B'])=count(//cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID | //cac:ClassifiedTaxCategory/cbc:ID) and contains(/*/cac:PaymentTerms/cbc:Note, '17-ter') and contains(/*/cac:PaymentTerms/cbc:Note, '633/1972'))" flag="fatal" id="BR-IT-DC-510">[BR-IT-DC-510] - Se l'elemento BT-40 Seller country code ha valore "IT" e la fattura è soggetta allo Split Payment questa deve esclusivamente utilizzare il TaxCategory = 'B' e deve indicare nei termini di pagamento "The total is without the VAT amount due to Split payment (ex art.17-ter del DPR 633/1972)".</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress[cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone" flag="fatal" id="BR-IT-DC-140">[BR-IT-DC-140] - Se il valore dell’elemento BT-40 Seller country code è “IT”, gli elementi devono essere obbligatoriamente valorizzati.</assert>
		<assert test="((not(contains(normalize-space(cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-DC-150">[BR-IT-DC-150] - Se l'elemento BT-40 (Seller country code) ha valore "IT", per l'elemento BT-39 Seller country subdivision deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione è riportata in allegato.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-180">[BR-IT-180] - BT-48 (Buyer VAT identifier) maximum lenght shall be 30 chars - La lunghezza dell'elemento non può superare i 30 caratteri.</assert>
	</rule>

	<!--rule context="/*/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" flag="fatal">
		<assert test="@schemeID='0201' and matches(.,'^[a-zA-Z0-9]{6}$')" flag="fatal" id="BR-IT-200">[BR-IT-200] - Se l'elemento BT-49-1 (Buyer electronic address identification scheme identifier) contiene il valore "0201", l'elemento BT-49 (Buyer electronic address) deve contenere un codice IPA con lunghezza pari a 6 caratteri.</assert>
	</rule-->

	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0201']" flag="fatal">
		<assert test="matches(.,'^[a-zA-Z0-9]{6}$')" flag="fatal" id="BR-IT-201">[BR-IT-201] - Se l'elemento BT-49-1 (Buyer electronic address identification scheme identifier) contiene il valore "0201", l'elemento BT-49 (Buyer electronic address) deve contenere un codice IPA con lunghezza pari a 6 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0205']" flag="fatal">
		<assert test="matches(.,'^[a-zA-Z0-9]{7}$')" flag="fatal" id="BR-IT-DC-202">[BR-IT-DC-202] - Se l'elemento BT-49-1 (Buyer electronic address identification scheme identifier) contiene il valore "0205", l'elemento BT-49 (Buyer electronic address) deve contenere un codice Codice Destinatario con lunghezza pari a 7 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID[@schemeID='0202']" flag="fatal">
		<assert test="matches(.,'^[a-zA-Z0-9]{7,256}$')" flag="fatal" id="BR-IT-DC-203">[BR-IT-DC-203] - Se l'elemento BT-49-1 (Buyer electronic address identification scheme identifier) contiene il valore "0202", l'elemento BT-49 deve contenere un indirizzo PEC di lunghezza compresa fra 7 e 256.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress[cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone" flag="fatal" id="BR-IT-210">[BR-IT-210] - Tutti gli elementi sono obbligatori a meno del Numero Civico.</assert>
		<assert test="((not(contains(normalize-space(cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-220">[BR-IT-220] - Per l'elemento BT-54 (Buyer country subdivision) deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione è riportata in allegato.</assert>
	</rule>

	<rule context="/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-230">[BR-IT-230] - BT-63 (Seller tax representative VAT identifier) maximum lenght shall be 30 chars - La lunghezza dell'elemento non può superare i 30 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:Delivery/cac:DeliveryLocation/cac:Address[cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone" flag="fatal" id="BR-IT-240">[BR-IT-240] - Se il valore dell’elemento BT-80 Deliver to country code è ”IT”, gli elementi devono essere obbligatoriamente valorizzati.</assert>
		<assert test="((not(contains(normalize-space(cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-250">[BR-IT-250] - Se l'elemento BT-80 Deliver to country code ha valore "IT", per l'elemento BT-79 Deliver to country subdivision deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione deve essere riportata in allegato.</assert>
	</rule>
	
	<rule context="/*/cac:PaymentMeans" flag="fatal">
		<assert test="." flag="fatal" id="BR-IT-260">[BR-IT-260] - Il gruppo di elementi BG-16 (Payment instructions) deve essere obbligatorio.</assert>
		<assert test="matches(cac:PayeeFinancialAccount/cbc:ID, '^[a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{11,30}$')" flag="fatal" id="BR-IT-270">[BR-IT-270] - L'identificativo del pagamento BT-84 (Payment account identifier) deve essere un codice IBAN.</assert>
		<assert test="matches(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID, '^[A-Z]{6}[A-Z2-9][A-NP-Z0-9]([A-Z0-9]{3}){0,1}$') or not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch)" flag="fatal" id="BR-IT-280">[BR-IT-280] - La lunghezza dell'elemento deve essere compresa fra 8 e 11 caratteri (BIC).</assert>
	</rule>

	<rule context="/*/cac:AllowanceCharge/cbc:Amount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-290">[BR-IT-290] - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-300">[BR-IT-300] - BT-112 (Invoice total amount with VAT) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-310">[BR-IT-310] - BT-114 (Rounding amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:LegalMonetaryTotal/cbc:PayableAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-320">[BR-IT-320] - BT-115 (Amount due for payment) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-330">[BR-IT-330] - BT-116 (VAT category taxable amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-340">[BR-IT-340] - BT-117 (VAT category tax amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="//cac:TaxCategory/cbc:ID | //cac:ClassifiedTaxCategory/cbc:ID" flag="fatal">
		<assert test="contains(' AE E S G K Z B ', concat(' ',normalize-space(.),' '))" flag="fatal" id="BR-IT-350">[BR-IT-350] - For VAT category code only values AE E S G K Z B shall be allowed - I valori accettati sono esclusivamente AE E S G K Z B.</assert>
	</rule>
	
	<rule context="//cac:AdditionalDocumentReference[cbc:ID and not(cbc:DocumentTypeCode)]" flag="fatal">
		<assert test="cac:Attachment/cac:ExternalReference/cbc:URI or cac:Attachment/cbc:EmbeddedDocumentBinaryObject" flag="fatal" id="BR-IT-360">[BR-IT-360] - If BT-122 is not empty, then BT-124 or BT-125 shall be mandatory - Se l'elemento BT-122 Supporting document reference è valorizzato, è obbligatorio valorizzare almeno uno degli elementi BT-124 External document location e BT-125 Attached document.</assert>
	</rule>

	<!-- BOLLO -->
	<rule context="/*/cac:AllowanceCharge[cbc:AllowanceChargeReasonCode = 'SAE' and ../cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']]" flag="fatal">
		<assert test="cbc:ChargeIndicator = true() and cbc:AllowanceChargeReason = 'BOLLO' and cac:TaxCategory[cbc:ID = 'Z' and cbc:Percent = 0] and ../cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount &gt; 77.47 and not(../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'S' or cbc:ID = 'B']) and ((cbc:Amount = 0.00 and ../cac:TaxTotal/cac:TaxSubtotal[cbc:TaxableAmount = 0.00]/cac:TaxCategory[cbc:ID = 'Z' and cbc:Percent = 0]) or (cbc:Amount = 2.00 and ../cac:TaxTotal/cac:TaxSubtotal[cbc:TaxableAmount = 2.00]/cac:TaxCategory[cbc:ID = 'Z' and cbc:Percent = 0]))" flag="fatal" id="BR-IT-DC-480">[BR-IT-DC-480] - Se l'elemento BT-40 Seller country code ha valore "IT e la fattura è soggetta alla marca da bollo, il motivo della maggiorazione deve essere posto a "BOLLO", la fattura non deve contenere IVA e l'importo deve essere superiore a 77.47 EURO. Se l'importo del bollo viene rifatturato al cliente, il suo valore deve essere posto a 2.00 EUR come operazione non imponibile IVA (TaxCategory/ID = 'Z') e il relativo riepilogo IVA deve riportare un imponibile di 2.00 EUR".</assert>
	</rule>
	
	<!--rule context="/*/cac:AccountingCustomerParty/cac:Party" flag="fatal">
		<assert test="cac:PartyTaxScheme/cbc:CompanyID or cac:PartyLegalEntity/cbc:CompanyID" flag="fatal" id="BR-IT-520">[BR-IT-520][FPA 1.4.1.2, 1.4.1.1] - Almeno uno degli elementi BT-48 (Buyer VAT identifier) o BT-47 (Buyer legal registration identifier) deve essere valorizzato.</assert>
	</rule-->

	<rule context="/*/cac:AccountingCustomerParty/cac:Party" flag="fatal">
		<assert test="cac:PartyTaxScheme/cbc:CompanyID or cac:PartyLegalEntity/cbc:CompanyID" flag="fatal" id="BR-IT-521">[BR-IT-521][FPA 1.4.1.2 Codice Fiscale, 1.4.1.1 Id Paese] - Almeno uno degli elementi BT-48 (Buyer VAT identifier) o BT-47 (Buyer legal registration identifier) deve essere valorizzato.</assert>
	</rule>
	
	<!--rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0210']" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{11,16}$')" flag="fatal" id="BR-IT-521">[BR-IT-521][FPA 1.4.1.2 - Codice Fiscale] - Se l'elemento BT-47-1 (Buyer legal registration identifier scheme identifier) contiene il valore "0210", l'elemento BT-47 (Buyer legal registration identifier) deve contenere un Codice Fiscale con lunghezza compresa fra 11 e 16 caratteri.</assert>
	</rule-->
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID='0210']" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{11,16}$')" flag="fatal" id="BR-IT-522">[BR-IT-522][FPA 1.4.1.2 - Codice Fiscale] - Se l'elemento BT-47-1 (Buyer legal registration identifier scheme identifier) contiene il valore "0210", l'elemento BT-47 (Buyer legal registration identifier) deve contenere un Codice Fiscale con lunghezza compresa fra 11 e 16 caratteri.</assert>
	</rule>
	
	<!--rule context="/*/cac:AccountingCustomerParty/cac:PartyIdentification/cbc:ID" flag="fatal">
		<assert test="matches(.,'^EORI:[A-Z0-9]{13,17}$')" flag="fatal" id="BR-IT-522">[BR-IT-522][FPA 1.4.1.3.5 - Codice EORI] - Il Codice EORI (BT-46 Buyer identifier) deve essere preceduto dal prefisso 'EORI:' ed avere la lunghezza del codice compresa fra 13 e 17 caratteri alfanumerici.</assert>
	</rule-->
	
	<rule context="/*/cac:AccountingCustomerParty/cac:PartyIdentification/cbc:ID[starts-with(., 'EORI:')]" flag="fatal">
		<assert test="matches(.,'^EORI:[A-Z0-9]{13,17}$')" flag="fatal" id="BR-IT-DC-523">[BR-IT-DC-523][FPA 1.4.1.3.5 - Codice EORI] - Il Codice EORI (BT-46 Buyer identifier) deve essere preceduto dal prefisso 'EORI:' ed avere la lunghezza del codice compresa fra 13 e 17 caratteri alfanumerici.</assert>
	</rule>

		
	<!-- Line Level -->
	
	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,100}$')" flag="fatal" id="BR-IT-370">[BR-IT-370] - BT-128 (Invoice line object identifier) maximum lenght shall be 100 chars - La lunghezza dell'elemento non può superare i 100 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cbc:InvoicedQuantity" flag="fatal">
		<assert test="matches(.,'^\d{1,12}\.\d{2,8}$')" flag="fatal" id="BR-IT-380">[BR-IT-380] - BT-129 (Invoiced quantity) maximum lenght shall be 21 chars and BT allowed fraction digits shall be 8 - La lunghezza dell'elemento non deve essere superiore a 21 caratteri e l'elemento dovrà avere 8 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cbc:LineExtensionAmount" flag="fatal">
		<assert test="matches(.,'^\d*(\.\d{0,2})?$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 15" flag="fatal" id="BR-IT-390">[BR-IT-390] - BT-131 (Invoice line net amount) BT maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:OrderLineReference/cbc:LineID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-400">[BR-IT-400] - BT-132 (Referenced purchase order line reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cbc:AccountingCost" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-410">[BR-IT-410] - BT-133 (Invoice line Buyer accounting reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount" flag="fatal">
		<assert test="matches(.,'^\d*(\.\d{0,2})?$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 15" flag="fatal" id="BR-IT-420">[BR-IT-420][FPA 2.2.1.10.3 - Importo] - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:Price/cbc:PriceAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2,8}$')" flag="fatal" id="BR-IT-430">[BR-IT-430] - BT-146 (Item net price) maximum length shall be 21 chars and BT allowed fraction digits shall be 8 - La lunghezza dell'elemento non deve essere superiore a 21 caratteri e l'elemento dovrà avere 8 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-440">[BR-IT-440] - BT-155 (Item Seller's identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-470">[BR-IT-470] - BT-158 (Item classification identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule>
	
</pattern>

