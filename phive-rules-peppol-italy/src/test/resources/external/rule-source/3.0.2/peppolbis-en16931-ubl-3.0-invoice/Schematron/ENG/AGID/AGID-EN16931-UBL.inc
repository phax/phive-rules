<?xml version="1.0" encoding="UTF-8"?>  
<pattern id="Italian-CIUS-rules" xmlns="http://purl.oclc.org/dsdl/schematron">

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
	
	<rule context="/*/cac:DespatchDocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-060">[BR-IT-060] - BT-16 (Despatch advice reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
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

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT' and sum(for $i in cac:PartyIdentification/cbc:ID return if (starts-with($i, 'IT:EORI:')) then 1 else 0) &gt; 0]" flag="fatal">
		<assert test="sum(for $i in cac:PartyIdentification/cbc:ID return if (matches($i,'^IT:EORI:[A-Z0-9]+$') and string-length($i) &gt;= 21 and string-length($i) &lt;= 25) then 1 else 0) &gt; 0" flag="fatal" id="BR-IT-100">[BR-IT-100] - BT-29 (Seller identifier) Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-29 Seller identifier comincia con "IT:EORI:",  la sua lunghezza deve essere compresa fra 21 e 25 caratteri. 
Altrimenti, se il valore dell'elemento BT-29 Seller identifier comincia con "IT:ALBO:",  la sua lunghezza non può superare i 129 caratteri e deve essere indicato come "IT:ALBO:AlboProfessionale:NumeroIscrizioneAlbo".</assert>
	</rule>
	
	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT' and sum(for $i in cac:PartyIdentification/cbc:ID return if (starts-with($i, 'IT:ALBO:')) then 1 else 0) &gt; 0]" flag="fatal">
		<assert test="sum(for $i in cac:PartyIdentification/cbc:ID return if (matches($i,'^IT:ALBO:[a-zA-Z]+:[A-Z0-9]+$') and string-length($i) &gt;= 1 and string-length($i) &lt;= 129) then 1 else 0) &gt; 0" flag="fatal" id="BR-IT-100">[BR-IT-100] - BT-29 (Seller identifier) Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-29 Seller identifier comincia con "IT:EORI:",  la sua lunghezza deve essere compresa fra 21 e 25 caratteri. 
Altrimenti, se il valore dell'elemento BT-29 Seller identifier comincia con "IT:ALBO:",  la sua lunghezza non può superare i 129 caratteri e deve essere indicato come "IT:ALBO:AlboProfessionale:NumeroIscrizioneAlbo".</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT' and sum(for $i in cac:PartyIdentification/cbc:ID return if (starts-with($i, 'IT:REA:')) then 1 else 0) &gt; 0]" flag="fatal">
		<assert test="sum(for $i in cac:PartyIdentification/cbc:ID return if (matches($i,'^IT:REA:[a-zA-Z0-9]+:[A-Z0-9]+$') and string-length($i) &gt;= 10 and string-length($i) &lt;= 30) then 1 else 0) &gt; 0" flag="fatal" id="BR-IT-110">[BR-IT-110] - Se il valore dell’elemento BT-40 (Seller country code) è "IT", se il valore dell'elemento BT-30 Seller legal registration identifier comincia con "IT:REA:", la sua lunghezza deve essere compresa fra 10 e 30 caratteri e deve essere indicato come "IT:REA:Ufficio:NumeroREA".</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">
		<assert test="matches(.,'^[a-zA-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-120">[BR-IT-120] - BT-31 (Seller VAT identifier) maximum lenght shall be 30 chars - La lunghezza dell'elemento non può superare i 30 caratteri.</assert>
	</rule>

	<rule context="/*/cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<assert test="cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = 'VAT' or matches(cac:PartyTaxScheme/cbc:CompanyID,'^[a-zA-Z0-9]{17,22}$')" flag="fatal" id="BR-IT-130">[BR-IT-130] - Se il valore dell’elemento BT-40 Seller country code è "IT", la lunghezza dell'elemento BT-32 Seller tax registration identifier deve essere compresa fra 17 e 22 caratteri.</assert>
		<assert test="((not(contains(normalize-space(cac:PostalAddress/cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cac:PostalAddress/cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-150">[BR-IT-150] - Se l'elemento BT-40 (Seller country code) ha valore "IT", per l'elemento BT-39 Seller country subdivision deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione è riportata in allegato.</assert>
	</rule>

	<rule context="/*/cac:AccountingCustomerParty/cac:Party" flag="fatal">
		<assert test="cac:PartyTaxScheme/cbc:CompanyID or (cac:PartyIdentification/cbc:ID and matches(cac:PartyIdentification/cbc:ID,'^IT:CF:[a-zA-Z0-9]{17,22}$'))" flag="fatal" id="BR-IT-160">[BR-IT-160] - Almeno uno degli elementi  BT-48 Buyer VAT identifier e BT-46 Buyer identifier deve essere valorizzato. BT-46 Buyer identifier, se presente, deve iniziare con "IT:CF:" e la sua lunghezza deve essere compresa fra 17 e 22 caratteri.</assert>
	</rule>

	<rule context="/*/cac:AccountingCustomerParty/cac:Party[starts-with(cac:PartyLegalEntity/cbc:CompanyID, 'IT:EORI:')]" flag="fatal">
		<assert test="matches(cac:PartyLegalEntity/cbc:CompanyID,'^IT:EORI:[A-Z0-9]+$') and string-length(cac:PartyLegalEntity/cbc:CompanyID) &gt;= 21 and string-length(cac:PartyLegalEntity/cbc:CompanyID) &lt;= 25" flag="fatal" id="BR-IT-170">[BR-IT-170] - Se l'elemento BT-47 Buyer legal registration identifier inizia con "IT:EORI:", la lunghezza dell'elemento BT-47 Buyer legal registration identifier deve essere compresa fra 21 e 25 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-180">[BR-IT-180] - BT-48 (Buyer VAT identifier) maximum lenght shall be 30 chars - La lunghezza dell'elemento non può superare i 30 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" flag="fatal">
		<assert test="@schemeID='0201' and (matches(.,'^(IT:IPA:)?[a-zA-Z0-9]{6}$') or (matches(.,'^IT:PEC:(\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)$') and matches(.,'^.{14,256}$')) or matches(.,'^IT:CODDEST:[a-zA-Z0-9]{7}$'))" flag="fatal" id="BR-IT-200">[BR-IT-200] - Se l'elemento BT-49-1 Buyer electronic address identification scheme identifier contiene il valore "0201", l'elemento BT-49 Buyer electronic address 
		rappresenta un codice IPA, può iniziare opzionalmente con il prefisso "IT:IPA:" e deve essere seguito da un identificatore con lunghezza pari a 6 caratteri,
		oppure può iniziare con il prefisso "IT:PEC:" ed essere seguito da un indirizzo PEC di lunghezza compresa fra 7 e 256 caratteri,
		oppure può iniziare con il prefisso "IT:CODDEST:" ed essere seguito da un identificatore con lunghezza pari a 7 caratteri.</assert>
		<assert test="@schemeID='0201'" flag="fatal" id="BR-IT-190">[BR-IT-190] - L'elemento BT-49 Buyer electronic address deve contenere la PEC del destinatario della fattura, oppure l’indice IPA oppure il codice destinatario. Di conseguenza per l'elemento BT-49-1 Buyer electronic address identification scheme identifier DEVE indicare lo schema "0201".</assert>
	</rule>
	
	<rule context="/*/cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<assert test="((not(contains(normalize-space(cac:PostalAddress/cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cac:PostalAddress/cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-220">[BR-IT-220] - Per l'elemento BT-54 (Buyer country subdivision) deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione è riportata in allegato.</assert>
	</rule>
	
	<rule context="/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID" flag="fatal">
		<assert test="matches(.,'^[A-Z0-9]{0,30}$')" flag="fatal" id="BR-IT-230">[BR-IT-230] - BT-63 (Seller tax representative VAT identifier) maximum lenght shall be 30 chars - La lunghezza dell'elemento non può superare i 30 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:Delivery/cac:DeliveryLocation/cac:Address[cac:Country/cbc:IdentificationCode='IT']" flag="fatal">
		<assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone" flag="fatal" id="BR-IT-240">[BR-IT-240] - Se il valore dell’elemento BT-80 Deliver to country code è ”IT”, gli elementi BT-75 (Deliver to address line 1), BT-77 (Deliver to city) and BT-78 (Deliver to post code) devono essere obbligatoriamente valorizzati.</assert>
		<assert test="((not(contains(normalize-space(cbc:CountrySubentity),' ')) and contains(' AG AL AN AO AP AQ AR AT AV BA BG BI BL BN BO BR BS BT BZ CA CB CE CH CI CL CN CO CR CS CT CZ EN FC FE FG FI FM FR FU GE GO GR IM IS KR LC LE LI LO LT LU MB MC ME MI MN MO MS MT NA NO NU OG OR OT PA PC PD PE PG PI PL PN PO PR PT PU PV PZ RA RC RE RG RI RM RN RO SA SI SO SP SR SS SU SV TA TE TN TO TP TR TS TV UD VA VB VC VE VI VR VS VT VV ZA ',concat(' ',normalize-space(cbc:CountrySubentity),' '))))" flag="fatal" id="BR-IT-250">[BR-IT-250] - Per l'elemento BT-79 (Deliver to country subdivision) deve essere utilizzato uno dei valori della lista delle province italiane. Altrimenti l'informazione è riportata in allegato.</assert>
	</rule>
	
	<rule context="/*/cac:PaymentMeans" flag="fatal">
		<assert test="." flag="fatal" id="BR-IT-260">[BR-IT-260] - Il gruppo di elementi BG-16 (Payment instructions) deve essere obbligatorio.</assert>
		<assert test="matches(cac:PayeeFinancialAccount/cbc:ID, '^[a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{11,30}$')" flag="fatal" id="BR-IT-270">[BR-IT-270] - L'identificativo del pagamento BT-84 (Payment account identifier) deve essere un codice IBAN.</assert>
		<assert test="matches(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID, '^[A-Z]{6}[A-Z2-9][A-NP-Z0-9]([A-Z0-9]{3}){0,1}$') or not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch)" flag="fatal" id="BR-IT-280">[BR-IT-280] - La lunghezza dell'elemento deve essere compresa fra 8 e 11 caratteri (BIC).</assert>
	</rule>
	
	<rule context="/*/cac:AllowanceCharge/cbc:Amount" flag="fatal">
		<assert test="matches(.,'^[.\d]{1,15}$')" flag="fatal" id="BR-IT-290">[BR-IT-290] - BT-92 and BT-99(Document level allowance/charge amounts) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount" flag="fatal">
		<assert test="matches(.,'^[.\d]{1,15}$')" flag="fatal" id="BR-IT-300">[BR-IT-300] - BT-112 (Invoice total amount with VAT) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount" flag="fatal">
		<assert test="matches(.,'^[.\d]{1,15}$')" flag="fatal" id="BR-IT-310">[BR-IT-310] - BT-114 (Rounding amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:LegalMonetaryTotal/cbc:PayableAmount" flag="fatal">
		<assert test="matches(.,'^[.\d]{1,15}$')" flag="fatal" id="BR-IT-320">[BR-IT-320] - BT-115 (Amount due for payment) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount" flag="fatal">
		<assert test="matches(.,'^[.\d]{1,15}$')" flag="fatal" id="BR-IT-330">[BR-IT-330] - BT-116 (VAT category taxable amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount" flag="fatal">
		<assert test="matches(.,'^[.\d]{1,15}$')" flag="fatal" id="BR-IT-340">[BR-IT-340] - BT-117 (VAT category tax amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="//cac:TaxCategory/cbc:ID | //cac:ClassifiedTaxCategory/cbc:ID" flag="fatal">
		<assert test="contains(' AE B E S G K Z H AA O ', concat(' ',normalize-space(.),' '))" flag="fatal" id="BR-IT-350">[BR-IT-350] - For VAT category code only values AE B E S G K Z H AA O shall be allowed - I valori accettati sono esclusivamente AE B E S G K Z H AA O.</assert>
	</rule>
	
	<rule context="//cac:AdditionalDocumentReference[cbc:ID]" flag="fatal">
		<assert test="cac:Attachment/cac:ExternalReference/cbc:URI or cac:Attachment/cbc:EmbeddedDocumentBinaryObject" flag="fatal" id="BR-IT-360">[BR-IT-360] - If BT-122 not empty then BT-124 or BT-125 shall be mandatory - Se l'elemento l’elemento BT-122 (Supporting document reference) è valorizzato, è obbligatorio valorizzare almeno uno degli elementi BT-124 (External document location) e BT-125 (Attached document).</assert>
	</rule>

	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-370">[BR-IT-370] - BT-128 (Invoice line object identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^\d*\.\d{8}$') and string-length(.) &gt;= 9 and string-length(.) &lt;= 21" flag="fatal" id="BR-IT-380">[BR-IT-380] - BT-129 (Invoiced quantity) maximum lenght shall be 21 chars and BT allowed fraction digits shall be 8 - La lunghezza dell'elemento non deve essere superiore a 21 caratteri e l'elemento dovrà avere 8 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^\d*(\.\d{0,2})?$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 15" flag="fatal" id="BR-IT-390">[BR-IT-390] - BT-131 (Invoice line net amount) BT maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-400">[BR-IT-400] - BT-132 (Referenced purchase order line reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,20}$')" flag="fatal" id="BR-IT-410">[BR-IT-410] - BT-133 (Invoice line Buyer accounting reference) maximum lenght shall be 20 chars - La lunghezza dell'elemento non può superare i 20 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^\d*(\.\d{0,2})?$') and string-length(.) &gt;= 1 and string-length(.) &lt;= 15" flag="fatal" id="BR-IT-420">[BR-IT-420] - BT-136 and BT-141 (Invoice line allowance/charge amount) maximum length shall be 15, including two fraction digits - La lunghezza dell'elemento non può superare i 15 caratteri incluso 2 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^\d*\.\d{8}$') and string-length(.) &gt;= 9 and string-length(.) &lt;= 21" flag="fatal" id="BR-IT-430">[BR-IT-430] - BT-146 (Item net price) maximum length shall be 21 chars and BT allowed fraction digits shall be 8 - La lunghezza dell'elemento non deve essere superiore a 21 caratteri e l'elemento dovrà avere 8 cifre decimali.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-440">[BR-IT-440] - BT-155 (Item Seller's identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-450">[BR-IT-450] - BT-156 (Item Buyer's identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:DocumentReference/cbc:ID" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-460">[BR-IT-460] - BT-157 (Item standard identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule>
	
	<rule context="/*/cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" flag="fatal">
		<assert test="matches(.,'^(\p{IsBasicLatin}){0,35}$')" flag="fatal" id="BR-IT-470">[BR-IT-470] - BT-158 (Item classification identifier) maximum lenght shall be 35 chars - La lunghezza dell'elemento non può superare i 35 caratteri.</assert>
	</rule>
	
	<!-- BOLLO -->
	<rule context="/*/cac:AllowanceCharge" flag="fatal">
		<assert test="cbc:AllowanceChargeReason = 'IT:BOLLO' and (not(cbc:AllowanceChargeReasonCode) or cbc:AllowanceChargeReasonCode = 'SAE') and cbc:Amount = 0.00 and cbc:BaseAmount &gt; 0 and count(cac:TaxCategory[cbc:ID = 'E' and cbc:Percent = 0]) = 1 and ../cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount &gt; 77.47 and not(../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'S' or cbc:ID = 'B']) and count(../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'E' and cbc:Percent = 0 and contains(lower-case(cbc:TaxExemptionReason), 'bollo')]) = 1" flag="fatal" id="BR-IT-480">[BR-IT-480] - Se la fattura è soggetta alla marca da bollo questa non deve contenere IVA, l'importo deve essere superiore a 77.47 EURO e nel riepilogo IVA deve menzionare il motivo dell'esenzione "Bollo assolto ai sensi del decreto MEF 17 giugno 2014 (art. 6)".</assert>
	</rule>

	<rule context="/*/cac:InvoiceLine/cac:Item[sum(for $i in cac:AdditionalItemProperty return if ($i[starts-with(cbc:Name,'IT:RITENUTA:')]) then 1 else 0) &gt; 0]" flag="fatal">
		<!-- RITENUTA -->
		<assert test="sum(for $i in cac:AdditionalItemProperty return if ($i[cbc:Name='IT:RITENUTA:TIPO' or cbc:Name='IT:RITENUTA:ALIQUOTA' or cbc:Name='IT:RITENUTA:CAUSALE']) then 1 else 0) = 3" flag="fatal" id="BR-IT-490">[BR-IT-490] - La ritenuta d'acconto, se presente, deve specificare almeno il Tipo, l'Aliquota e la Causale.</assert>
	</rule>

	<!-- CASSA -->
	<rule context="/*/cac:InvoiceLine/cac:Item[cbc:Name = 'IT:CASSA']" flag="fatal">
		<assert test="sum(for $i in cac:AdditionalItemProperty return if ($i[cbc:Name = 'IT:CASSA:TIPO' or cbc:Name = 'IT:CASSA:ALIQUOTA']) then 1 else 0) = 2" flag="fatal" id="BR-IT-500">[BR-IT-500] - La Cassa Previdenziale, se presente, deve contenere almeno il Tipo e l'Aliquota.</assert>
	</rule>

	<!-- Esigibilità: Split Payment -->
	<rule context="/*/cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cbc:ID = 'B']" flag="fatal">
		<assert test="not(/*/cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cbc:ID = 'S']) and /*/cac:PaymentTerms/cbc:Note" flag="fatal" id="BR-IT-510">[BR-IT-510] - Se la fattura è soggetta allo Split Payment questa deve esclusivamente utilizzare il TaxCategory = 'B' e deve indicare nei termini di pagamento "The total is without the VAT amount due to Split payment (ex art.17-ter del DPR 633/1972)".</assert>
	</rule>

</pattern>

