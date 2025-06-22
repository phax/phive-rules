<pattern id="Italy-EXTENSION-rules" xmlns="http://purl.oclc.org/dsdl/schematron">

	<!-- UBL Extensions -->
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:SoggettoEmittente']/ext:ExtensionContent" flag="fatal">
		<assert test="( ( not(contains(normalize-space(cbc:TypeCode),' ')) and contains( ' CC TZ ',concat(' ',normalize-space(cbc:TypeCode),' ') ) ) )" flag="fatal" id="BR-IT-DE-001">[BR-IT-DE-001][FPA 1.6 Soggetto Emittente] - The extension must contain a cbc:TypeCode element valued exclusively with the values ​​'CC' or 'TZ' - L'estensione deve contenere un elemento cbc:TypeCode valorizzato esclusivamente con i valori 'CC' o 'TZ'.</assert>
	</rule>
	
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:TipoDocumento']/ext:ExtensionContent" flag="fatal">
		<assert test="( ( not(contains(normalize-space(cbc:TypeCode),' ')) and contains( ' TD01 TD02 TD03 TD04 TD05 TD06 TD16 TD17 TD18 TD19 TD20 TD21 TD22 TD23 TD24 TD25 TD26 TD27 TD28 ',concat(' ',normalize-space(cbc:TypeCode),' ') ) ) )" flag="fatal" id="BR-IT-DE-002">[BR-IT-DE-002][FPA 2.1.1.1 Tipo Documento] - The extension must contain a cbc:TypeCode element valued exclusively with the values ​​of the Document Type, according to the specific FatturaPA 1.2.1 - L'estensione deve contenere un elemento cbc:TypeCode valorizzato esclusivamente con i valori del TipoDocumento, secondo la specifica FatturaPA 1.2.1.</assert>
	</rule>

	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[starts-with(ext:ExtensionURI, 'urn:fdc:agid.gov.it:fatturapa:TipoRitenuta')]/ext:ExtensionContent" flag="fatal">
		<assert test="( ( not(contains(normalize-space(cbc:TypeCode),' ')) and contains( ' RT01 RT02 RT03 RT04 RT05 RT06 ',concat(' ',normalize-space(cbc:TypeCode),' ') ) ) )" flag="fatal" id="BR-IT-DE-003">[BR-IT-DE-003][FPA 2.1.1.5.1 Tipo Ritenuta] - The extension must contain a cbc:TypeCode element valued exclusively with the values ​​of Withholding Type, according to the specific FatturaPA 1.2.1 - L'estensione deve contenere un elemento cbc:TypeCode valorizzato esclusivamente con i valori del TipoRitenuta, secondo la specifica FatturaPA 1.2.1.</assert>
	</rule>
	
	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:Art73']/ext:ExtensionContent" flag="fatal">
		<assert test="cbc:TypeCode = 'SI'" flag="fatal" id="BR-IT-DE-004">[BR-IT-DE-004][FPA 2.1.1.12 Art.73] - The extension must contain a cbc:TypeCode element valued exclusively with the value 'YES' to apply Article 73 of the Italian Presidential Decree 633/72 - L'estensione deve contenere un elemento cbc:TypeCode valorizzato esclusivamente con il valore 'SI' per applicare l'Articolo 73 del DPR 633/72.</assert>
	</rule>

	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[starts-with(ext:ExtensionURI, 'urn:fdc:agid.gov.it:fatturapa:RiepilogoIVA:Arrotondamento')]/ext:ExtensionContent" flag="fatal">
		<assert test="matches(cbc:Amount,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-DE-005">[BR-IT-DE-005][FPA 2.2.2.4 Arrotondamento] - The extension must contain a cbc:Amount element whose length cannot exceed 15 characters including 2 fraction digits - L'estensione deve contenere un elemento cbc:Amount la cui lunghezza non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>

	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:ScontoMaggiorazione']/ext:ExtensionContent" flag="fatal">
		<assert test="cac:AllowanceCharge" flag="fatal" id="BR-IT-DE-006">[BR-IT-DE-006][FPA 2.1.1.8 Sconto Maggiorazione] - The extension must contain one or more cac:AllowanceCharge elements - L'estensione deve contenere uno o più elementi cac:AllowanceCharge.</assert>
	</rule>

	<rule context="/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:ScontoMaggiorazione']/ext:ExtensionContent/cac:AllowanceCharge" flag="fatal">
		<assert test="matches(cbc:Amount,'^[\-]?\d{1,11}\.\d{2,8}$')" flag="fatal" id="BR-IT-DE-007">[BR-IT-DE-007][FPA 2.1.1.8 Sconto Maggiorazione] - The amount of the discount or surcharge (cbc:Amount) must contain from 4 to 21 characters including 2 fraction digits - L'importo dello sconto o maggiorazione (cbc:Amount) deve contenere da 4 fino a 21 caratteri incluso 2 cifre decimali.</assert>
		<assert test="not(cbc:MultiplierFactorNumeric) or matches(cbc:MultiplierFactorNumeric,'^\d{1,3}\.\d{2}$')" flag="fatal" id="BR-IT-DE-008">[BR-IT-DE-008][FPA 2.1.1.8 Sconto Maggiorazione] - The amount of the discount/surcharge in percentage, if present, (cbc:MultiplierFactorNumeric) must contain from 4 to 6 characters including 2 fraction digits - L'importo dello sconto/maggiorazione in percentuale, se presente, (cbc:MultiplierFactorNumeric) deve contenere da 4 fino a 6 caratteri incluso 2 cifre decimali.</assert>
	</rule>

    <rule context="/ubl-invoice:Invoice" flag="fatal">
        <assert test="count(cac:WithholdingTaxTotal) &lt;= 1" flag="fatal" id="BR-IT-DE-009FT1">[BR-IT-DE-009FT1][FPA 2.1.1.5 Dati Ritenuta] - The extension must contain a cac:WithholdingTaxTotal element - L'estensione deve contenere un elemento cac:WithholdingTaxTotal.</assert>
    </rule>
	
	<rule context="/ubl-creditnote:CreditNote/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:Ritenuta']/ext:ExtensionContent" flag="fatal">
		<assert test="count(cac:WithholdingTaxTotal) = 1 and count(/*/ext:UBLExtensions/ext:UBLExtension[ext:ExtensionURI = 'urn:fdc:agid.gov.it:fatturapa:Ritenuta']) = 1" flag="fatal" id="BR-IT-DE-009NC1">[BR-IT-DE-009NC1][FPA 2.1.1.5 Dati Ritenuta] - The extension must contain a cac:WithholdingTaxTotal element - L'estensione deve contenere uno elemento cac:WithholdingTaxTotal.</assert>
	</rule>

	<rule context="//cac:WithholdingTaxTotal" flag="fatal">
		<assert test="matches(cbc:TaxAmount,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-DE-010">[BR-IT-DE-010][FPA 2.1.1.5 Dati Ritenuta] - The total amount of withholding taxes (cbc:TaxAmount) must contain from 4 to 15 characters including 2 fraction digits - L'importo totale delle ritenute (cbc:TaxAmount) deve contenere da 4 fino a 15 caratteri incluso 2 cifre decimali.</assert>
		<assert test="count(cac:TaxSubtotal) &gt;= 1 and count(cac:TaxSubtotal) &lt;= 2" flag="fatal" id="BR-IT-DE-011">[BR-IT-DE-011][FPA 2.1.1.5 Dati Ritenuta] - The cac:WithholdingTaxTotal must contain one to maximum two withholdings (cac:TaxSubtotal) - Il cac:WithholdingTaxTotal deve contenere almeno una e al massimo due ritenute (cac:TaxSubtotal).</assert>
	</rule>

	<rule context="//cac:WithholdingTaxTotal/cac:TaxSubtotal" flag="fatal">
		<assert test="matches(cbc:TaxAmount,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-DE-012">[BR-IT-DE-012][FPA 2.1.1. Dati Ritenuta] - The amount of each withholding tax (cbc:TaxAmount) must contain from 4 to 15 characters including 2 fraction digits - L'importo di ogni ritenuta (cbc:TaxAmount) deve contenere da 4 fino a 15 caratteri incluso 2 cifre decimali.</assert>
		<assert test="(matches(./cac:TaxCategory/cbc:Percent,'^\d{1,3}\.\d{2}$') 
				and ./cac:TaxCategory/cbc:ID = 'S' 
				and ./cac:TaxCategory/cac:TaxScheme/cbc:ID = 'SWT' 
				and ./cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode	
				and /*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'IT')
				or /*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT'" flag="fatal" id="BR-IT-DE-013">
		[BR-IT-DE-013][FPA 2.1.1.5.1 Tipo Ritenuta, 2.1.1.5.2 Importo Ritenuta, 2.1.1.5.3 Aliquota Ritenuta, 2.1.1.5.4 Causale Pagamento] - For each withholding must be indicated the type, the withholding amount (cbc:TaxAmount), the withholding category (cac:TaxCategory) with the identifier set to "S" (cbc: ID), the withholding rate (cbc:Percent) with a length from 4 to 6 characters including 2 fraction digits, the withholding scheme (cac:TaxScheme/cbc:ID) set to "SWT" and the reason for payment (cac:TaxScheme/cbc:TaxTypeCode) - Per ogni ritenuta di acconto, devono essere indicati la tipologia di ritenuta, l’importo della ritenuta (cbc:TaxAmount), la categoria della ritenuta (cac:TaxCategory) con identificativo uguale a "S" (cbc:ID), aliquota della ritenuta (cbc:Percent) da 4 fino a 6 caratteri incluso 2 cifre decimali, schema della ritenuta (cac:TaxScheme/cbc:ID) valorizzato con "SWT" e causale del pagamento (cac:TaxScheme/cbc:TaxTypeCode).</assert>
	</rule>

	<!-- Document Level -->

	<rule context="/*/cac:BillingReference/cac:AdditionalDocumentReference" flag="fatal">
		<assert test="cbc:ID and cbc:IssueDate" flag="fatal" id="BR-IT-DE-014">[BR-IT-DE-014][FPA 2.1.10.1 Numero Fattura Principale e 2.1.10.2 Data Fattura Principale] - To refer to a main invoice relating to the transport of goods, must be values the ID and IssueDate elements of the main invoice - Se si vuole fare riferimento ad una fattura principale relativa al trasporto di beni devono essere obbligatoriamente valorizzati gli estremi della fattura con gli elementi ID e IssueDate.</assert>
		<assert test="matches(cbc:ID,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-DE-015">[BR-IT-DE-015][FPA 2.1.10.1 Numero Fattura Principale] - The main invoice identifier cannot exceed 20 characters - L'identificativo della fattura principale non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:DespatchDocumentReference" flag="fatal">
		<assert test="cbc:IssueDate" flag="fatal" id="BR-IT-DE-016">[BR-IT-DE-016][FPA 2.1.8.2 Data DDT] - The Despatch Advice date must be valued in the document - La data del documento di trasporto deve essere obbligatoriamente valorizzata a livello di documento.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode" flag="fatal">
		<assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' RF01 RF02 RF04 RF05 RF06 RF07 RF08 RF09 RF10 RF11 RF12 RF13 RF14 RF15 RF16 RF17 RF18 RF19 ',concat(' ',normalize-space(.),' ') ) ) )" flag="fatal" id="BR-IT-DE-017">[BR-IT-DE-017][FPA 1.2.1.8 Regime Fiscale] - The Tax System (cbc:TaxLevelCode) must be filled exclusively with the values ​​ of the relative coding - Il Regime Fiscale (cbc:TaxLevelCode) deve essere valorizzato esclusivamente con i valori della relativa codifica.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress" flag="fatal">
		<assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone and cbc:CountrySubentity and cac:Country/cbc:IdentificationCode" flag="fatal" id="BR-IT-DE-018">[BR-IT-DE-018][FPA 1.2.3 Stabile Organizzazione] - The Permanent Organisation must provide the complete address of street and street number, municipality, postcode, province and country - La Stabile Organizzazione deve fornire l'indirizzo completo di via e numero civico, comune, CAP, provincia e nazione.</assert>
		<assert test="matches(cbc:StreetName,'^(\p{IsBasicLatin}){0,60}$')" flag="fatal" id="BR-IT-DE-019">[BR-IT-DE-019][FPA 1.2.3.1 Indirizzo e 1.2.3.2 Numero Civico] - The length of the element cannot exceed 60 characters - La lunghezza dell'elemento non può superare i 60 caratteri.</assert>
		<assert test="matches(cbc:Cityname,'^(\p{IsBasicLatin}){0,60}$')" flag="fatal" id="BR-IT-DE-020">[BR-IT-DE-020][FPA 1.2.3.4 Comune] - The length of the element cannot exceed 60 characters - La lunghezza dell'elemento non può superare i 60 caratteri.</assert>
		<assert test="matches(cbc:PostalZone,'^(\p{IsBasicLatin}){5}$')" flag="fatal" id="BR-IT-DE-021">[BR-IT-DE-021][FPA 1.2.3.3 CAP] - The length of the element must consist of 5 digits - La lunghezza dell'elemento deve essere costituita da 5 cifre.</assert>
		<assert test="matches(cbc:CountrySubentity,'^[A-Z]{0,2}$')" flag="fatal" id="BR-IT-DE-022">[BR-IT-DE-022][FPA 1.2.3.5 Provincia] - The length of the element cannot exceed 2 characters - La lunghezza dell'elemento non può superare i 2 caratteri.</assert>
	</rule>
		
	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty/cac:Party" flag="fatal">
		<assert test="cac:PartyTaxScheme/cbc:CompanyID and cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = 'VAT' and (cac:PartyName/cbc:Name or (cac:Person/cbc:FirstName and cac:Person/cbc:FamilyName))" flag="fatal" id="BR-IT-DE-023">[BR-IT-DE-023][FPA 1.5 Terzo Intermediario] - The Third-Party Intermediary or Issuer must contain the VAT number, the tax scheme = 'VAT', the company name or a natural person (first name and surname) - Il Terzo Intermediario o Soggetto Emittente deve contenere la P.IVA, lo schema fiscale = 'VAT', la ragione sociale o una persona fisica (nome e cognome).</assert>
		<assert test="not(starts-with(upper-case(cac:PartyTaxScheme/cbc:CompanyID), 'IT')) or (cac:PartyIdentification/cbc:ID[@schemeID='0210'] and matches(cac:PartyIdentification/cbc:ID[@schemeID='0210'],'^[A-Z0-9]{11,16}$'))" flag="fatal" id="BR-IT-DE-050">[BR-IT-DE-050][FPA 1.5.1.2 Codice Fiscale] - If the Third-Party Intermediary or Issuer is Italian, its Tax Code must be provided (cac:PartyIdentification/cbc:ID) qualified by the @schemeID attribute with the value "0210" and the length of the code must be between 11 and 16 alphanumeric characters - Se il Terzo Intermediario o Soggetto Emittente è italiano, deve essere fornito il suo Codice Fiscale (cac:PartyIdentification/cbc:ID) qualificato dall'attributo @schemeID con il valore "0210" e la lunghezza del codice deve essere compresa fra 11 e 16 caratteri alfanumerici.</assert>
	</rule>

	<rule context="/*/cac:TaxRepresentativeParty/cac:PartyIdentification/cbc:ID[@schemeID='0210']" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{11,16}$')" flag="fatal" id="BR-IT-DE-024A">[BR-IT-DE-024A][FPA 1.3.1.2 Codice Fiscale] - The Tax Code must have the @schemeID attribute valued with "0210" and the length between 11 and 16 alphanumeric characters - Il Codice Fiscale deve specificare l'attributo @schemeID valorizzato con "0210" ed avere la lunghezza del codice compresa fra 11 e 16 caratteri alfanumerici.</assert>
	</rule>

	<rule context="/*/cac:TaxRepresentativeParty/cac:PartyIdentification/cbc:ID[starts-with(., 'EORI:')]" flag="fatal">
		<assert test="matches(.,'^EORI:[A-Z0-9]{13,17}$')" flag="fatal" id="BR-IT-DE-025">[BR-IT-DE-025][FPA 1.3.1.3.5 Codice EORI] - The EORI Code must be preceded by the prefix 'EORI:' and have the code length between 13 and 17 alphanumeric characters - Il Codice EORI deve essere preceduto dal prefisso 'EORI:' ed avere la lunghezza del codice compresa fra 13 e 17 caratteri alfanumerici.</assert>
	</rule>

	<rule context="/*/cac:Delivery/cac:CarrierParty" flag="fatal">
		<assert test="not(cac:PartyIdentification/cbc:ID) or (matches(cac:PartyIdentification/cbc:ID,'^[A-Z0-9]{11,16}$') and cac:PartyIdentification/cbc:ID[@schemeID='0210'])" flag="fatal" id="BR-IT-DE-026A">[BR-IT-DE-026A][FPA 2.1.9.1.2 Codice Fiscale] - The Tax Code must have the @schemeID attribute valued with "0210" and a length between 11 and 16 alphanumeric characters - Il Codice Fiscale deve specificare l'attributo @schemeID valorizzato con "0210" ed avere la lunghezza del codice compresa fra 11 e 16 caratteri alfanumerici.</assert>
		<assert test="matches(cac:PartyName/cbc:Name,'^(\p{IsBasicLatin}){0,80}$') or (matches(cac:Person/cbc:FirstName,'^(\p{IsBasicLatin}){0,60}$') and matches(cac:Person/cbc:FamilyName,'^(\p{IsBasicLatin}){0,60}$'))" flag="fatal" id="BR-IT-DE-027">[BR-IT-DE-027][FPA 2.1.9.1.3.1 Denominazione, 2.1.9.1.3.2 Nome, 2.1.9.1.3.3 Cognome] - If the Carrier Name is entered, its length cannot exceed 80 characters, alternatively, if the First Name and Surname are entered, their length cannot exceed 60 characters - Se la Denominazione del Vettore è valorizzata, la sua lunghezza non può superare 80 caratteri, alternativamente, se è invece valorizzato il Nome e il Cognome, la loro lunghezza non potrà superare 60 caratteri.</assert>
		<assert test="matches(cac:PartyTaxScheme/cbc:CompanyID,'^[a-zA-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-DE-028">[BR-IT-DE-028][FPA 2.1.9.1.1 Partita IVA] - The length of the element cannot exceed 30 characters - La lunghezza dell'elemento non può superare i 30 caratteri.</assert>
		<assert test="cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = 'VAT'" flag="fatal" id="BR-IT-DE-029">[BR-IT-DE-029] - The TaxScheme identifier must be valued with 'VAT' - L'identificativo del TaxScheme deve essere valorizzato con 'VAT'.</assert>
		<assert test="not(cac:Person/cac:IdentityDocumentReference) or (matches(cac:Person/cac:IdentityDocumentReference/cbc:ID,'^[A-Z0-9]{0,20}$') and cac:Person/cac:IdentityDocumentReference/cbc:DocumentTypeCode = '40')" flag="fatal" id="BR-IT-DE-030">[BR-IT-DE-030][FPA 2.1.9.1.4 Numero Licenza Guida] - If the Driving License Number is valued, its length cannot exceed 20 characters and the document type ( cbc:DocumentTypeCode) must be '40' - Se il Numero Licenza Guida è valorizzata, la sua lunghezza non può superare 20 caratteri e il tipo documento (cbc:DocumentTypeCode) deve essere '40'.</assert>
	</rule>

	<rule context="/*/cac:Delivery/cac:Shipment" flag="fatal">
		<assert test="(not(cbc:GrossWeightMeasure) or matches(cbc:GrossWeightMeasure,'^[0-9]{1,4}\.[0-9]{1,2}$')) and (not(cbc:NetWeightMeasure) or matches(cbc:NetWeightMeasure,'^[0-9]{1,4}\.[0-9]{1,2}$'))" flag="fatal" id="BR-IT-DE-031">[BR-IT-DE-031][FPA 2.1.9.7 Peso Lordo, FPA 2.1.9.8 Peso Netto] - The length of the Gross or Net weight must be from 4 to 7 characters, including 1 or 2 fraction digits - La lunghezza del Peso Lordo o Netto deve essere da 4 a 7 caratteri, incluse 1 o 2 cifre decimali.</assert>
		<assert test="not(cbc:TotalTransportHandlingUnitQuantity) or matches(cbc:TotalTransportHandlingUnitQuantity,'^[0-9]{1,9999}$')" flag="fatal" id="BR-IT-DE-032">[BR-IT-DE-032][FPA 2.1.9.4 Numero Colli] - The Number of Packages can be from 1 to 9999 - Il Numero di Colli può essere da 1 a 9999.</assert>
		<assert test="not(cac:GoodsItem/cbc:Description) or matches(cac:GoodsItem/cbc:Description,'^(\p{IsBasicLatin}){0,100}$')" flag="fatal" id="BR-IT-DE-033">[BR-IT-DE-033][FPA 2.1.9.5 Descrizione Merce] - The length of the element cannot exceed 100 characters - La lunghezza dell'elemento non può superare i 100 caratteri.</assert>
		<assert test="not(cac:ShipmentStage/cbc:TransportMeansTypeCode) or matches(cac:ShipmentStage/cbc:TransportMeansTypeCode,'^(\p{IsBasicLatin}){0,80}$')" flag="fatal" id="BR-IT-DE-034">[BR-IT-DE-034][FPA 2.1.9.2 Mezzo di Trasporto] - The length of the element cannot exceed 80 characters - La lunghezza dell'elemento non può superare gli 80 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:Despatch" flag="fatal">
		<assert test="not(cbc:Instructions) or matches(cbc:Instructions,'^[a-zA-Z0-9]{0,100}$')" flag="fatal" id="BR-IT-DE-035">[BR-IT-DE-035][FPA 2.1.9.3 Causale Trasporto] - The length of the element cannot exceed 100 characters - La lunghezza dell'elemento non può superare i 100 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:DeliveryTerms/cbc:ID" flag="fatal">
		<assert test="matches(.,'^[a-zA-Z0-9]{3,3}$')" flag="fatal" id="BR-IT-DE-036">[BR-IT-DE-036][FPA 2.1.9.11 Tipo Resa Merce] - The length of the element must be 3 characters - La lunghezza dell'elemento deve essere di 3 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:PaymentTerms/cbc:SettlementDiscountAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-DE-037">[BR-IT-DE-037][FPA 2.4.2.17 Sconto Pagamento Anticipato] - The length of the element must be at least 4 characters and cannot exceed 15 characters including 2 fraction digits - La lunghezza dell'elemento deve essere di almeno 4 caratteri e non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>

	<rule context="/*/cac:PaymentTerms/cbc:PenaltyAmount" flag="fatal">
		<assert test="matches(.,'^[\-]?\d{1,11}\.\d{2}$')" flag="fatal" id="BR-IT-DE-038">[BR-IT-DE-038][FPA 2.4.2.19 Penalita Pagamenti Ritardati] - The length of the element must be at least 4 characters and cannot exceed 15 characters including 2 fraction digits - La lunghezza dell'elemento deve essere di almeno 4 caratteri e non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>

	<rule context="/*/cac:InvoiceLine/cac:OrderLineReference/cac:OrderReference/cbc:ID | /*/cac:CreditNoteLine/cac:OrderLineReference/cac:OrderReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-DE-039">[BR-IT-DE-039][FPA 2.1.2.2 Numero Ordine] - The lenght of the element cannot exceed 20 characters - La lunghezza dell’elemento non può superare i 20 caratteri.</assert>
	</rule>

	<rule context="/*/cac:InvoiceLine/cac:DespatchLineReference/cbc:LineID | /*/cac:CreditNoteLine/cac:DespatchLineReference/cbc:LineID" flag="fatal">
		<assert test=".='NA'" flag="fatal" id="BR-IT-DE-040">[BR-IT-DE-040] - Regarding the reference to a Despatch Advice line from the invoice line not supported by SDI, always value it with 'NA' - Il riferimento ad una riga DDT dalla riga fattura non supportato da SDI, valorizzarlo sempre con 'NA'.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DespatchLineReference/cac:DocumentReference/cbc:ID | /*/cac:CreditNoteLine/cac:DespatchLineReference/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-DE-041">[BR-IT-DE-041][FPA 2.1.8.1 Numero DDT] - The length of the element cannot exceed 20 characters - La lunghezza dell’elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DespatchLineReference/cac:DocumentReference" flag="fatal">
		<assert test="cbc:IssueDate" flag="fatal" id="BR-IT-DE-042">[BR-IT-DE-042][FPA 2.1.8.2 Data DDT] - The date of the despatch advice must be valued at line level - La data del documento di trasporto deve essere obbligatoriamente valorizzata a livello di riga.</assert>
	</rule>
		
	<!-- B2B -->
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:AgentParty/cac:PostalAddress" flag="fatal">
		<assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone and cbc:CountrySubentity and cac:Country/cbc:IdentificationCode" flag="fatal" id="BR-IT-DE-043">[BR-IT-DE-043][FPA 1.4.3 Stabile Organizzazione] - The Permanent Organisazion must provide the complete address of street and street number, municipality, postcode, province and country - La Stabile Organizzazione deve fornire l'indirizzo completo di via e numero civico, comune, CAP, provincia e nazione.</assert>
		<assert test="matches(cbc:StreetName,'^(\p{IsBasicLatin}){0,60}$')" flag="fatal" id="BR-IT-DE-044">[BR-IT-DE-044][FPA 1.4.3.1 Indirizzo e 1.4.3.2 Numero Civico] - The length of the element cannot exceed 60 characters - La lunghezza dell'elemento non può superare i 60 caratteri.</assert>
		<assert test="matches(cbc:Cityname,'^(\p{IsBasicLatin}){0,60}$')" flag="fatal" id="BR-IT-DE-045">[BR-IT-DE-045][FPA 1.4.3.4 Comune] - The length of the element cannot exceed 60 characters - La lunghezza dell'elemento non può superare i 60 caratteri.</assert>
		<assert test="matches(cbc:PostalZone,'^(\p{IsBasicLatin}){5}$')" flag="fatal" id="BR-IT-DE-046">[BR-IT-DE-046][FPA 1.4.3.3 CAP] - The length of the element must consist of 5 digits - La lunghezza dell'elemento deve essere costituita da 5 cifre.</assert>
		<assert test="matches(cbc:CountrySubentity,'^[A-Z]{0,2}$')" flag="fatal" id="BR-IT-DE-047">[BR-IT-DE-047][FPA 1.4.3.5 Provincia] - The length of the element cannot exceed 2 characters - La lunghezza dell'elemento non può superare 2 caratteri.</assert>
	</rule>
	
	<!-- B2B -->
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PowerOfAttorney/cac:AgentParty" flag="fatal">
		<assert test="cac:PartyTaxScheme/cbc:CompanyID and cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = 'VAT' and cac:PartyLegalEntity/cbc:RegistrationName and (not(cac:Person) or (cac:Person/cbc:FirstName and cac:Person/cbc:FamilyName))"
		        flag="fatal" id="BR-IT-DE-048">[BR-IT-DE-048][FPA 1.4.4 Rappresentante Fiscale del Cliente] - The Customer’s Tax Representative must contain the VAT number, the tax scheme = 'VAT', the company name or a person name (first name and surname) - Il Rappresentante Fiscale del Cliente deve contenere la P.IVA, lo schema fiscale = 'VAT', la ragione sociale e se viene specificata una persona fisica, il nome e cognome.</assert>
	</rule>

   <rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PowerOfAttorney/cac:AgentParty/cac:PartyLegalEntity/cbc:RegistrationName" flag="fatal">
    		<assert test="matches(.,'^(\p{IsBasicLatin}){1,80}$')"
    		        flag="fatal" id="BR-IT-DE-049">[BR-IT-DE-049][FPA 1.4.4.2 Denominazione] - The name of the Customer’s Tax Representative cannot exceed 80 characters - La denominazione del Rappresentante Fiscale non può superare gli 80 caratteri.</assert>
    </rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:ServiceProviderParty/cac:Party/cac:PartyName/cbc:Name" flag="fatal">
    		<assert test="matches(.,'^(\p{IsBasicLatin}){1,80}$')"
    		        flag="fatal" id="BR-IT-DE-051">[BR-IT-DE-051][FPA 1.5.1.3.1 Denominazione] - The name of the Third-Party Intermediary (cbc:Name) cannot exceed 80 characters - La denominazione del Terzo Intermediario (cbc:Name) non può superare gli 80 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine | /*/cac:CreditNoteLine" flag="fatal">
		<assert test="((./cac:OrderLineReference/cac:OrderReference) or (/*/cac:OrderReference) or (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'IT') or not(./cbc:LineID))" 
		flag="fatal" id="BR-IT-DE-052">[BR-IT-DE-052][FPA 2.1.2.2 Id Documento] - If the value of the BT-40 (Seller country code) element is “IT” and there is a reference to an order line in an invoice line (BT-132 Referenced purchase order line reference), the order reference MUST be indicated in the header (BT-13 Purchase order reference) or in the line - Se il valore dell’elemento BT-40 (Seller country code) è uguale a "IT" e in una riga di fattura è presente il riferimento ad una riga d’ordine (BT-132 Referenced purchase order line reference), DEVE essere indicato il riferimento all’ordine in testata (BT-13 Purchase order reference) o in riga</assert>
	</rule>
	
	
	
</pattern>