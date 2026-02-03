<?xml version="1.0" encoding="UTF-8"?>
<!--
This schematron uses business terms defined the CEN/EN16931-1 and is reproduced with permission from CEN. CEN bears no liability from the use of the content and implementation of this schematron and gives no warranties expressed or implied for any purpose.
 -->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" schemaVersion="iso" queryBinding="xslt2">
	<title>Rules for CIUS-HR and EXT-HR 2025 (1.0.0)</title>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" prefix="ext"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonSignatureComponents-2" prefix="sig"/>
	<ns uri="urn:mfin.gov.hr:schema:xsd:HRExtensionAggregateComponents-1" prefix="hrextac"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" prefix="ubl-creditnote"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" prefix="ubl-invoice"/>
	<ns uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
	
	<!-- Empty elements -->
	<pattern>
		
		<rule context="//*[not(*) and not(normalize-space()) and not(ancestor-or-self::sig:UBLDocumentSignatures)]">
			<assert id="HR-BR-33" test="false()" flag="fatal">[HR-BR-33] - Račun ne smije sadržavati prazne xml elemente osim elementa s elektroničkim potpisom računa.</assert>
		</rule> 
	</pattern>
	
	<pattern>
		<!-- Document level -->
		<rule context="ubl-creditnote:CreditNote | ubl-invoice:Invoice">
			<assert test="not(matches(/*/cbc:ID, '\s'))" 
				flag="fatal"
				id="HR-BR-1">[HR-BR-1] - Broj računa ne smije sadržavati bjeline (whitespace znakove)
			</assert>
			<let name="issueDate" value="xs:date(cbc:IssueDate)"/>
			<assert test="(xs:date(cbc:IssueDate) &gt;= xs:date('2026-01-01')) and (xs:date(cbc:IssueDate) &lt;= xs:date('2100-01-01'))" 
				flag="fatal"
				id="HR-BR-40">[HR-BR-40] - Datum izdavanja računa (BT-2) - (<value-of select="$issueDate"/>) mora biti veći od 01.01.2026 i manji od 01.01.2100.
			</assert>
			<assert test="cbc:IssueTime and matches(cbc:IssueTime, '^[0-9]{2}:[0-9]{2}:[0-9]{2}$')" 
				flag="fatal"
				id="HR-BR-2">[HR-BR-2] - Račun mora imati vrijeme izdavanja računa (HR-BT-2). Vrijeme se upisuje u formatu hh:mm:ss</assert>
			<assert test="/*/cbc:ProfileID and (matches(normalize-space(/*/cbc:ProfileID), '^P([1-9]{1})$') or matches(normalize-space(/*/cbc:ProfileID), '^P([1]{1}[0-2]{1})$') or matches(normalize-space(/*/cbc:ProfileID), '^P99:'))"
				flag="fatal"
				id="HR-BR-34">[HR-BR-34] - Oznaka procesa (BT-23) MORA biti navedena. Koriste se vrijednosti P1-P12 ili P99:Oznaka kupca</assert>
			<assert test="string-length(cbc:ProfileID) &lt;= 200"
				flag="fatal"
				id="HR-BR-42">[HR-BR-42] - Oznaka procesa (BT-23) ne smije biti veća od 200 znakova</assert>
			<assert test="string-length(cac:ContractDocumentReference/cbc:ID) &lt;= 1024"
				flag="fatal"
				id="HR-BR-43">[HR-BR-43] - Referenca ugovora (BT-12) ne smije imati više od 1024 znakova</assert>
			<assert test="xs:date(cac:Delivery/cbc:ActualDeliveryDate) &lt;= xs:date('2100-01-01') or (not(exists(cac:Delivery/cbc:ActualDeliveryDate)))"
				flag="fatal"
				id="HR-BR-44">[HR-BR-44] - Stvarni datum isporuke (BT-72) mora biti manji od 01.01.2100.</assert>
			
			<assert test="normalize-space(cbc:CustomizationID) = 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.hr:cius-2025:1.0#conformant#urn:mfin.gov.hr:ext-2025:1.0'"
				flag="fatal"
				id="HR-BR-5">[HR-BR-5] - Identifikator specifikacije (BT-24) mora imati vrijednost 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.hr:cius-2025:1.0#conformant#urn:mfin.gov.hr:ext-2025:1.0'</assert>
			
			<assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S']) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S']))"
                 flag="fatal"
                 id="HR-BR-S-1">[HR-BR-S-1] - Račun koji sadržava stavku računa (BG-25) u kojoj je šifra kategorije PDV-a fakturiranog artikla (BT-151) 'Standardna ili reducirana stopa PDV' mora sadržavati PDV identifikator Kupca (BT-48)</assert>
            <assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID) = 'S']))"
                 flag="fatal"
                 id="HR-BR-S-2">[HR-BR-S-2] - Račun koji sadržava popust na razini dokumenta (BG-20) u kojemu je šifra kategorije PDV-a popusta na razini dokumenta (BT-95) 'Standardna ili reducirana stopa PDV' mora sadržavati PDV identifikator Kupca (BT-48)</assert>
			<assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID) = 'S']))"
                 flag="fatal"
                 id="HR-BR-S-3">[HR-BR-S-3] - Račun koji sadržava trošak na razini dokumenta (BG-21) u kojemu je šifra kategorije PDV-a troška na razini dokumenta (BT-102) 'Standardna ili reducirana stopa PDV' mora sadržavati PDV identifikator Kupca (BT-48)</assert>
               
            <assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z']) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z']))"
                 flag="fatal"
                 id="HR-BR-Z-1">[HR-BR-Z-1] - Račun koji sadržava stavku računa (BG-25) u kojoj je šifra kategorije PDV-a fakturiranog artikla (BT-151) 'Nulta stopa PDV' mora sadržavati PDV identifikator Kupca (BT-48)</assert>
            <assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID) = 'Z']) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID) = 'Z']))"
                 flag="fatal"
                 id="HR-BR-Z-2">[HR-BR-Z-2] - Račun koji sadržava popust na razini dokumenta (BG-20) u kojemu je šifra kategorije PDV-a popusta na razini dokumenta (BT-95) 'Nulta stopa PDV' mora sadržavati PDV identifikator Kupca (BT-48)</assert>
			<assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID) = 'Z']) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID) = 'Z']))"
                 flag="fatal"
                 id="HR-BR-Z-3">[HR-BR-Z-3] - Račun koji sadržava trošak na razini dokumenta (BG-21) u kojemu je šifra kategorije PDV-a troška na razini dokumenta (BT-102) 'Nulta stopa PDV' mora sadržavati PDV identifikator Kupca (BT-48)</assert>
                     
			<assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E']) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E']))"
                 flag="fatal"
                 id="HR-BR-E-1">[HR-BR-E-1] - Račun koji sadržava stavku računa (BG-25) u kojoj je šifra kategorije PDV-a fakturiranog artikla (BT-151) 'Oslobođeno PDV' mora sadržavati PDV identifikator Kupca (BT-48)</assert>
            <assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID) = 'E']) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID) = 'E']))"
                 flag="fatal"
                 id="HR-BR-E-2">[HR-BR-E-2] - Račun koji sadržava popust na razini dokumenta (BG-20) u kojemu je šifra kategorije PDV-a popusta na razini dokumenta (BT-95) 'Oslobođeno PDV' mora sadržavati PDV identifikator Kupca (BT-48)</assert>
			<assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID) = 'E']) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID) = 'E']))"
                 flag="fatal"
                 id="HR-BR-E-3">[HR-BR-E-3] - Račun koji sadržava trošak na razini dokumenta (BG-21) u kojemu je šifra kategorije PDV-a troška na razini dokumenta (BT-102) 'Oslobođeno PDV' mora sadržavati PDV identifikator Kupca (BT-48)</assert>
            
            <assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE']) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE']))"
                 flag="fatal"
                 id="HR-BR-AE-1">[HR-BR-AE-1] - Račun koji sadržava stavku računa (BG-25) u kojoj je šifra kategorije PDV-a fakturiranog artikla (BT-151) 'Prijenos porezne obveze' mora sadržavati PDV identifikator Kupca (BT-48)</assert>
            <assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID) = 'AE']) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID) = 'AE']))"
                 flag="fatal"
                 id="HR-BR-AE-2">[HR-BR-AE-2] - Račun koji sadržava popust na razini dokumenta (BG-20) u kojemu je šifra kategorije PDV-a popusta na razini dokumenta (BT-95) 'Prijenos porezne obveze' mora sadržavati PDV identifikator Kupca (BT-48)</assert>
			<assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID) = 'AE']) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID) = 'AE']))"
                 flag="fatal"
                 id="HR-BR-AE-3">[HR-BR-AE-3] - Račun koji sadržava trošak na razini dokumenta (BG-21) u kojemu je šifra kategorije PDV-a troška na razini dokumenta (BT-102) 'Prijenos porezne obveze' mora sadržavati PDV identifikator Kupca (BT-48)</assert>
            
            <assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E']) or exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID) = 'E']) or exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID) = 'E'])) and (exists(//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRTaxTotal)) or (not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'])) and (not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='false']/cac:TaxCategory[normalize-space(cbc:ID) = 'E']))) and (not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:ID) = 'E']))))"
                 flag="fatal"
                 id="HR-BR-26">[HR-BR-26] - Račun koji sadržava stavku računa (BG-25), popust na razini dokumenta (BG-20) ili trošak na razini dokumenta (BG-21), gdje je kod kategorije PDV-a (BT-151, BT-95 ili  BT-102) „oslobođeno od PDV-a“ mora sadržavati HR raspodjelu PDV (HR-BG-2)</assert>
            
            <assert test="((cac:LegalMonetaryTotal/cbc:ChargeTotalAmount) and (cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount) and (xs:decimal(//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRLegalMonetaryTotal/cbc:TaxExclusiveAmount) = round((xs:decimal(cac:LegalMonetaryTotal/cbc:LineExtensionAmount) + xs:decimal(cac:LegalMonetaryTotal/cbc:ChargeTotalAmount) - xs:decimal(cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount) - xs:decimal(ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRLegalMonetaryTotal/hrextac:OutOfScopeOfVATAmount)) * 10 * 10) div 100 ))  or (not(cac:LegalMonetaryTotal/cbc:ChargeTotalAmount) and (cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount) and (xs:decimal(//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRLegalMonetaryTotal/cbc:TaxExclusiveAmount) = round((xs:decimal(cac:LegalMonetaryTotal/cbc:LineExtensionAmount) - xs:decimal(cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount) - xs:decimal(ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRLegalMonetaryTotal/hrextac:OutOfScopeOfVATAmount)) * 10 * 10 ) div 100)) or ((cac:LegalMonetaryTotal/cbc:ChargeTotalAmount) and not(cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount) and (xs:decimal(//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRLegalMonetaryTotal/cbc:TaxExclusiveAmount) = round((xs:decimal(cac:LegalMonetaryTotal/cbc:LineExtensionAmount) + xs:decimal(cac:LegalMonetaryTotal/cbc:ChargeTotalAmount) - xs:decimal(ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRLegalMonetaryTotal/hrextac:OutOfScopeOfVATAmount)) * 10 * 10 ) div 100)) or (not(cac:LegalMonetaryTotal/cbc:ChargeTotalAmount) and not(cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount) and (xs:decimal(//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRLegalMonetaryTotal/cbc:TaxExclusiveAmount) = xs:decimal(cac:LegalMonetaryTotal/cbc:LineExtensionAmount) - xs:decimal(ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRLegalMonetaryTotal/hrextac:OutOfScopeOfVATAmount))) or (not(exists(ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRLegalMonetaryTotal)))"
            	flag="fatal"
            	id="HR-BR-27">[HR-BR-27] - HR iznos osnovice za PDV (HR-BT-23) mora biti jednak zbroju neto iznosa stavki računa (BT-131) umanjen za zbroj iznosa popusta na razini dokumenta (BT-92) uvećan za zbroj iznosa troškova na razini dokumenta (BT-99) i umanjen za HR neoporezivi iznos (HR-BT-24)</assert>
            
            <assert test="(exists(//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRTaxTotal/hrextac:HRTaxSubtotal/hrextac:HRTaxCategory[normalize-space(cbc:ID) = 'O'])) and (//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRTaxTotal/hrextac:HRTaxSubtotal/cbc:TaxAmount = 0) or (not(exists(//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRTaxTotal/hrextac:HRTaxSubtotal/hrextac:HRTaxCategory[normalize-space(cbc:ID) = 'O'])))"
                 flag="fatal"
                 id="HR-BR-29">[HR-BR-29] - Stavke računa, troškovi ili popusti koji ne ulaze u poreznu osnovicu HR kod kategorije PDV-a (HR-BT-18) mora biti „O“, a HR iznos kategorije poreza (HR-BT-17) mora biti 0</assert>
            
            <assert test="((exists(//cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:Name) = 'HR:POVNAK']) or exists(//cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:Name) = 'HR:PP']) or exists(//cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:Name) = 'HR:PPMV']) or exists(//cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:Name) = 'HR:N']) or exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:Name) = 'HR:POVNAK']) or exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:Name) = 'HR:PP']) or exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:Name) = 'HR:PPMV']) or exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:Name) = 'HR:N'])) and (exists(//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRLegalMonetaryTotal))) or (not(exists(//cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:Name) = 'HR:POVNAK'])) and not(exists(//cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:Name) = 'HR:PP'])) and not(exists(//cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:Name) = 'HR:PPMV'])) and not(exists(//cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:Name) = 'HR:N'])) and not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:Name) = 'HR:POVNAK'])) and not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:Name) = 'HR:PP'])) and not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:Name) = 'HR:PPMV'])) and not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator='true']/cac:TaxCategory[normalize-space(cbc:Name) = 'HR:N'])))"
                 flag="fatal"
                 id="HR-BR-30">[HR-BR-30] - HR Ukupni iznosi računa (HR-BG-3) se navodi na računu ako račun sadrži stavke računa (BG-25) ili troškove na razini dokumenta (BG-21) koji ne ulaze u poreznu osnovicu računa osim ako je EN porezna kategorija (O) Neoporeziva prodaja I Oznaka porezne kategorije HR:O.</assert>
            
            <assert test="(xs:decimal(//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRLegalMonetaryTotal/hrextac:OutOfScopeOfVATAmount) = round(sum(ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRTaxTotal/hrextac:HRTaxSubtotal[hrextac:HRTaxCategory/normalize-space(cbc:ID) = 'O']/xs:decimal(cbc:TaxableAmount)) * 10 * 10) div 100) or (not(exists(//ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRLegalMonetaryTotal)))"
            	flag="fatal"
            	id="HR-BR-32">[HR-BR-32] - HR neoporezivi iznos (HR-BT-24) jednak je zbroju neto iznosa stavki računa (BT-131) koje NE ulaze u poreznu osnovicu umanjen za zbroj iznosa popusta na razini dokumenta (BT-92) i uvećan za zbroj iznosa troškova na razini dokumenta (BT-99) koje NE ulaze u poreznu osnovicu</assert>
            
            <let name="payableAmount" value="
          		if (/ubl-invoice:Invoice) then
            		cac:LegalMonetaryTotal/cbc:PayableAmount
          		else
            		cac:LegalMonetaryTotal/cbc:PayableAmount * -1"/>
            <assert test="($payableAmount &gt; 0) and (exists(cbc:DueDate) or exists(cac:PaymentMeans/cbc:PaymentDueDate)) or (($payableAmount &lt;= 0))"
            	flag="fatal"
            	id="HR-BR-4">[HR-BR-4] - U slučaju pozitivnog iznosa koji dospijeva na plaćanje (BT-115), datum dospijeća plaćanja (BT-9) mora biti naveden</assert>
            <let name="dueDate" value="
          		if (/ubl-invoice:Invoice) then
            		cbc:DueDate
          		else
            		cac:PaymentMeans/cbc:PaymentDueDate"/>
            <assert test="(xs:date($dueDate) &lt;= xs:date('2100-01-01')) or ($payableAmount &lt;= 0)"
            	flag="fatal"
            	id="HR-BR-41">[HR-BR-41] - Datum dospijeća plaćanja (BT-9) -(<value-of select="$dueDate"/>) - mora biti manji od 01.01.2100.</assert>
            
		</rule>
		
		<rule context="/ubl-invoice:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /ubl-creditnote:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]">
			
			<assert test="((cac:TaxCategory[normalize-space(cbc:ID) = 'E'] or cac:TaxCategory[normalize-space(cbc:ID) = 'O']) and exists(cac:TaxCategory/cbc:Name)) or (cac:TaxCategory[normalize-space(cbc:ID) != 'E'] and cac:TaxCategory[normalize-space(cbc:ID) != 'O'])"
                 flag="fatal"
                 id="HR-BR-11">[HR-BR-11] - Svaki troškak na razini dokumenta (BG-21) koji ne podliježe PDV-u ili je oslobođen PDV-a mora imati oznaku kategorije PDV-a troška na razini dokumenta (HR-BT-6)</assert>
            
            <assert test="((cac:TaxCategory[normalize-space(cbc:ID) = 'E'] or cac:TaxCategory[normalize-space(cbc:ID) = 'O']) and (exists(cac:TaxCategory/cbc:TaxExemptionReason) or exists(cac:TaxCategory/cbc:TaxExemptionReasonCode))) or (cac:TaxCategory[normalize-space(cbc:ID) != 'E'] and cac:TaxCategory[normalize-space(cbc:ID) != 'O'])"
                 flag="fatal"
                 id="HR-BR-13">[HR-BR-13] - Svaki troškak na razini dokumenta (BG-21) koji ne podliježe PDV-u ili je oslobođen mora imati razlog oslobođenja PDV-a troška na razini dokumenta (HR-BT-6) ili kod razloga oslobođenja PDV-a a troška na razini dokumenta (HR-BT-7)</assert>
            
		</rule>
		
		<!-- Billing reference -->
		<rule context="cac:BillingReference">
			<assert 
				test="exists(cac:InvoiceDocumentReference/cbc:ID) and exists(cac:InvoiceDocumentReference/cbc:IssueDate)" 
				flag="fatal"
				id="HR-BR-6">[HR-BR-6] - Svaka referenca prethodnog računa (BG-3) mora imati datum izdavanja prethodnog računa (BT-26)</assert>
			<assert test="xs:date(cac:InvoiceDocumentReference/cbc:IssueDate) &lt;= xs:date('2100-01-01')"
				flag="fatal"
				id="HR-BR-45">[HR-BR-45] - Datum izdavanja prethodnog računa (BT-26) mora biti manji od 01.01.2100.</assert>
		</rule>
		
		<!-- Accounting supplier -->
		<rule context="cac:AccountingSupplierParty">
			<assert test="cac:Party/cbc:EndpointID" 
				flag="fatal"
				id="HR-BR-7">[HR-BR-7] - Elektronička adresa Prodavatelja (BT-34) mora biti navedena</assert>
			<assert test="cac:SellerContact/cbc:Name" 
				flag="fatal"
				id="HR-BR-37">[HR-BR-37] - Račun mora sadržavati oznaku operatera (HR-BT-4)</assert>
			<assert test="cac:SellerContact/cbc:ID and matches(cac:SellerContact/cbc:ID, '^[0-9]{11}$')" 
				flag="fatal"
				id="HR-BR-9">[HR-BR-9] - Račun mora sadržavati OIB operatera (HR-BT-5)</assert>
		</rule>
		
		<!-- Accounting customer -->
		<rule context="cac:AccountingCustomerParty/cac:Party">
			<assert id="HR-BR-10" test="cbc:EndpointID" flag="fatal">[HR-BR-10] - Elektronička adresa Kupca (BT-49) mora biti navedena</assert>
		</rule>
		
		<rule context="cac:InvoiceLine | cac:CreditNoteLine">
			<let name="hasOrderReference" value="../cac:OrderReference/cbc:ID"/>
			<assert test="(exists(cac:OrderLineReference/cac:OrderReference/cbc:ID) and not($hasOrderReference)) or (not(exists(cac:OrderLineReference/cac:OrderReference/cbc:ID)) and ($hasOrderReference)) or (not(exists(cac:OrderLineReference/cac:OrderReference/cbc:ID)) and not($hasOrderReference))"
				flag="fatal"
				id="HR-BR-17">[HR-BR-17] - Ako se koristi referenca narudžbenice na stavci računa (HR-BT-9), zabranjeno je koristiti BT-13 Referencu narudžbenice na razini računa</assert>
			<let name="hasDespatchDocumentReference" value="../cac:DespatchDocumentReference/cbc:ID"/>
			<assert test="(exists(cac:DespatchLineReference/cac:DocumentReference/cbc:ID) and not($hasDespatchDocumentReference)) or (not(exists(cac:DespatchLineReference/cac:DocumentReference/cbc:ID)) and ($hasDespatchDocumentReference)) or (not(exists(cac:DespatchLineReference/cac:DocumentReference/cbc:ID)) and not($hasDespatchDocumentReference))"
				flag="fatal"
				id="HR-BR-18">[HR-BR-18] - Ako se koristi referenca otpremnice na stavci računa (HR-BT-10), zabranjeno je koristiti BT-16 Referencu otpremnice na razini računa</assert>
			<let name="hasReceiptDocumentReference" value="../cac:ReceiptDocumentReference/cbc:ID"/>
			<assert test="(exists(cac:ReceiptLineReference/cac:DocumentReference/cbc:ID) and not($hasReceiptDocumentReference)) or (not(exists(cac:ReceiptLineReference/cac:DocumentReference/cbc:ID)) and ($hasReceiptDocumentReference)) or (not(exists(cac:ReceiptLineReference/cac:DocumentReference/cbc:ID)) and not($hasReceiptDocumentReference))"
				flag="fatal"
				id="HR-BR-19">[HR-BR-19] - Ako se koristi referenca primke na stavci računa (HR-BT-11), zabranjeno je koristiti BT-15 Referencu primke na razini računa</assert>
			
			<assert test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) &gt; 0" 
				flag="fatal"
				id="HR-BR-20">[HR-BR-20] - Jedinična količina za cijenu artikla, ako je iskazana, MORA biti pozitivan broj veći od nule</assert>
			
		</rule>
		
		<rule context="cac:Price/cbc:BaseQuantity[@unitCode]">
			<let name="hasQuantity" value="../../cbc:InvoicedQuantity or ../../cbc:CreditedQuantity"/>
			<let name="lineID" value="../../cbc:ID"/>
			<let name="quantity" value="
          if (/ubl-invoice:Invoice) then
            ../../cbc:InvoicedQuantity
          else
            ../../cbc:CreditedQuantity"/>
			<assert test="not($hasQuantity) or @unitCode = $quantity/@unitCode" 
				flag="fatal"
				id="HR-BR-21">[HR-BR-21] - Stavka <value-of select="$lineID"/>: Jedinica mjere jedinične količine cijene artikla, ako je iskazan, MORA biti jednaka jedinici mjere obračunate količine (BT-130)</assert>
		</rule>
		
		<rule context="cac:Item">
			<let name="lineID" value="../cbc:ID"/>
			<let name="documentTypeCode" value="
			if (/ubl-invoice:Invoice) then
				../../cbc:InvoiceTypeCode
			else
				../../cbc:CreditNoteTypeCode"/>
			
			<assert test="((exists(cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E']) or exists(cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'])) and exists(cac:ClassifiedTaxCategory/cbc:Name)) or (exists(cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'E']) and exists(cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'O']))"
                 flag="fatal"
                 id="HR-BR-16">[HR-BR-16] - Stavka <value-of select="$lineID"/>: Svaka stavka računa (BG-25) koja ne podliježe PDV-u ili je oslobođena od PDV-a mora imati oznaku kategorije PDV-a obračunate stavke HR-BT-12</assert>
			
			<assert test="(exists(cac:CommodityClassification/cbc:ItemClassificationCode) and (cac:CommodityClassification/cbc:ItemClassificationCode/@listID = 'CG')) or (not(exists(cac:CommodityClassification/cbc:ItemClassificationCode)) and $documentTypeCode[contains(' 386 81 83 261 262 296 308 381 396 420 458 532 ', concat(' ', normalize-space(.), ' '))]) or ($documentTypeCode[contains(' 386 81 83 261 262 296 308 381 396 420 458 532 ', concat(' ', normalize-space(.), ' '))] and (cac:CommodityClassification/cbc:ItemClassificationCode/@listID != 'CG'))"
				flag="fatal"
				id="HR-BR-25">[HR-BR-25] - Stavka <value-of select="$lineID"/>: Svaki artikl MORA imati identifikator klasifikacije artikla iz sheme Klasifikacija proizvoda po djelatnostima: KPD (CPA) – listID „CG“, osim u slučaju računa za predujam i odobrenja.</assert>
			
			<assert test="(exists(cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'] or exists(cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'])) and (exists(cac:ClassifiedTaxCategory/cbc:TaxExemptionReason) or exists(cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode))) or ((cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'E']) and (cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'O']))"
                 flag="fatal"
                 id="HR-BR-36">[HR-BR-36] - Stavka <value-of select="$lineID"/>: Svaka stavka računa (BG-25) koja ne podliježe PDV-u ili je oslobođena od PDV-a mora imati razlog oslobođenja PDV-a (HR-BT-13) ili kod razloga oslobođenja PDV-a (HR-BT-14)</assert>
            
            <assert test="string-length(cbc:Name) &lt;= 1024"
                 flag="fatal"
                 id="HR-BR-46">[HR-BR-46] - Stavka <value-of select="$lineID"/>: Naziv artikla (BT-153) mora imati manje od 1024 znakova</assert>
            
            <assert test="(string-length(cbc:Description) &lt;= 4096) or (not(exists(cbc:Description)))"
                 flag="fatal"
                 id="HR-BR-47">[HR-BR-47] - Stavka <value-of select="$lineID"/>: Opis artikla (BT-154) mora imati manje od 4096 znakova</assert>
		</rule>
		
		<rule context="ext:UBLExtensions/ext:UBLExtension/ext:ExtensionContent/hrextac:HRFISK20Data/hrextac:HRTaxTotal/hrextac:HRTaxSubtotal">
			
			<assert test="(((exists(hrextac:HRTaxCategory/cbc:ID)) or (hrextac:HRTaxCategory/cbc:ID = 'E') or (hrextac:HRTaxCategory/cbc:ID = 'O')) and (xs:decimal(cbc:TaxAmount) = 0)) or ((hrextac:HRTaxCategory/cbc:ID != 'E') and (hrextac:HRTaxCategory/cbc:ID != 'O'))"
				 flag="fatal"
				 id="HR-BR-28">[HR-BR-28] - Za cac:TaxScheme = „VAT“ i kod porezne kategorije „E“ ili „O“ HR iznos porezne kategorije mora biti 0</assert>
			
			<assert test="(exists(hrextac:HRTaxCategory/cbc:ID)) and (hrextac:HRTaxCategory/cbc:ID = 'S') and (hrextac:HRTaxCategory/cbc:Percent &gt; 0) or (hrextac:HRTaxCategory/cbc:ID != 'S')"
                 flag="fatal"
                 id="HR-BR-S-10">[HR-BR-S-10] - Za svaku HR raspodjelu PDV u kojoj je kategorija PDV-a (HR-BT-18) "Standard rated" stopa PDV mora biti veća od 0</assert>
             
            <assert test="(exists(hrextac:HRTaxCategory/cbc:ID)) and (hrextac:HRTaxCategory/cbc:ID = 'Z') and (hrextac:HRTaxCategory/cbc:Percent = 0) or (hrextac:HRTaxCategory/cbc:ID != 'Z')"
                 flag="fatal"
                 id="HR-BR-Z-10">[HR-BR-Z-10] - Za svaku HR raspodjelu PDV u kojoj je kategorija PDV-a (HR-BT-18) "Zero rated" stopa PDV mora biti 0</assert>
            
            <assert test="(exists(hrextac:HRTaxCategory/cbc:ID)) and (hrextac:HRTaxCategory/cbc:ID = 'E') and (hrextac:HRTaxCategory/cbc:Percent = 0) or (hrextac:HRTaxCategory/cbc:ID != 'E')"
                 flag="fatal"
                 id="HR-BR-E-10">[HR-BR-E-10] - Za svaku HR raspodjelu PDV u kojoj je kategorija PDV-a (HR-BT-18) "Exempted - Oslobodjeno PDV" stopa PDV mora biti 0</assert>
			
			<assert test="(exists(hrextac:HRTaxCategory/cbc:ID)) and (hrextac:HRTaxCategory/cbc:ID = 'AE') and (hrextac:HRTaxCategory/cbc:Percent = 0) or (hrextac:HRTaxCategory/cbc:ID != 'AE')"
                 flag="fatal"
                 id="HR-BR-AE-10">[HR-BR-AE-10] - Za svaku HR raspodjelu PDV u kojoj je kategorija PDV-a (HR-BT-18) "Prijenos porezne obveze" stopa PDV mora biti 0</assert>
			
		</rule>
		
	</pattern>
	
	<include href="codelist/HR-CIUS-EXT-EN16931-UBL-codes.sch"/>
	
</schema>