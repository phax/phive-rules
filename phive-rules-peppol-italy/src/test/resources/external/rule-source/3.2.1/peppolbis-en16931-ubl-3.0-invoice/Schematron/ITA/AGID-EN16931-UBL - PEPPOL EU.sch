<?xml version="1.0" encoding="UTF-8"?>
<!--

    Licensed under European Union Public Licence (EUPL) version 1.2.
	This schematron uses business terms defined the CEN/EN16931-1 and is reproduced with permission from CEN. CEN bears no liability from the use of the content and implementation of this schematron and gives no warranties expressed or implied for any purpose.
	
	Peppol BIS Billing 3.0.17
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:u="utils" schemaVersion="iso" queryBinding="xslt2">
	<title>EN16931 model bound to UBL</title>
	<ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
	<ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
	<ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
	<ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
	<ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
	<ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
	<ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
	<ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
	<ns prefix="ubl-creditnote" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
	<ns prefix="ubl-invoice" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
	<ns uri="utils" prefix="u"/>
	<!--CEN phases-->
	<phase id="EN16931model_phase">
		<active pattern="UBL-model"/>
	</phase>
	<phase id="codelist_phase">
		<active pattern="Codesmodel"/>
	</phase>
	<!--OpenPEPPOL phases-->
	<phase id="OP_empty_check_phase">
		<active pattern="OP-empty-elements"/>
	</phase>
	<phase id="OP_transaction_phase">
		<active pattern="OP-transaction-rules"/>
	</phase>
	<phase id="OP_Norway_phase">
		<active pattern="OP-Norway-rules"/>
	</phase>
	<phase id="OP_Denmark_phase">
		<active pattern="OP-Denmark-rules"/>
	</phase>
	<phase id="OP_Italy_phase">
		<active pattern="OP-Italy-rules"/>
	</phase>
	<phase id="OP_Sweden_phase">
		<active pattern="OP-Sweden-rules"/>
	</phase>
	<phase id="OP_Greece_phase">
		<active pattern="OP-Greece-sender-rules"/>
		<active pattern="OP-Greece-sender-receiver-rules"/>
	</phase>
	<phase id="OP_Iceland_phase">
		<active pattern="OP-Iceland-rules"/>
	</phase>
	<phase id="OP_Netherlands_phase">
		<active pattern="OP-Netherlands-rules"/>
	</phase>
	<phase id="OP_Germnay_phase">
		<active pattern="OP-Germany-rules"/>
	</phase>
	<phase id="OP_codelist_phase">
		<active pattern="OP-cl-formatting-rules"/>
	</phase>
	
	
	<!-- OPENPEPPOL FUNCTIONS AND DEFINITIONS -->
	
	<!-- Parameters -->
	<let name="profile" value="
      if (/*/cbc:ProfileID and matches(normalize-space(/*/cbc:ProfileID), 'urn:fdc:peppol.eu:2017:poacc:billing:([0-9]{2}):1.0')) then
        tokenize(normalize-space(/*/cbc:ProfileID), ':')[7]
      else
        'Unknown'"/>
	<let name="supplierCountry" value="
      if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then
        upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))
      else
        if (/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then
          upper-case(normalize-space(/*/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))
        else
          if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then
            upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))
          else
            'XX'"/>
	<let name="customerCountry" value="
		if (/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then
		upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))
		else
		if (/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then
		upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))
		else
		'XX'"/>
	<!-- -->

	<!-- Functions -->
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:gln" as="xs:boolean">
		<param name="val"/>
		<variable name="length" select="string-length($val) - 1"/>
		<variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
		<variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
		<value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
	</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:slack" as="xs:boolean">
		<param name="exp" as="xs:decimal"/>
		<param name="val" as="xs:decimal"/>
		<param name="slack" as="xs:decimal"/>
		<value-of select="xs:decimal($exp + $slack) &gt;= $val and xs:decimal($exp - $slack) &lt;= $val"/>
	</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod11" as="xs:boolean">
		<param name="val"/>
		<variable name="length" select="string-length($val) - 1"/>
		<variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
		<variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
		<value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
	</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod97-0208" as="xs:boolean">
		<param name="val"/>
		<variable name="checkdigits" select="substring($val,9,2)"/>
		<variable name="calculated_digits" select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))"/>
		<value-of select="number($checkdigits) = number($calculated_digits)"/>
	</function>
	<function name="u:checkCodiceIPA" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</variable>
		<sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()"/>
	</function>
	<function name="u:checkCF" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="
		if ( (string-length($arg) = 16) or (string-length($arg) = 11) ) 		
		then 
		(
			if ((string-length($arg) = 16)) 
			then
			(
				if (u:checkCF16($arg)) 
				then
				(
					true()
				)
				else
				(
					false()
				)
			)
			else
			(
				if(($arg castable as xs:integer)) then true() else false()
		
			)
		)
		else
		(
			false()
		)
		"/>
	</function>
	<function name="u:checkCF16" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>
		<sequence select="
				if ( 	(string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and  
						(substring($arg,7,2) castable as xs:integer) and 
						(string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and 
						(substring($arg,10,2) castable as xs:integer) and  
						(substring($arg,12,3) castable as xs:string) and 
						(substring($arg,15,1) castable as xs:integer) and  
						(string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)
					) 
				then true()
				else false()
				"/>
	</function>
	<function name="u:checkPIVAseIT" as="xs:boolean" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string"/>
		<variable name="paese" select="substring($arg,1,2)"/>
		<variable name="codice" select="substring($arg,3)"/>
		<sequence select="

			if ( $paese = 'IT' or $paese = 'it' )
			then
			(
				if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))
				then
				(
					true()
				)
				else
				(
					false()
				)
			)
			else
			(
				true()
			)
		
		"/>
	</function>
	<function name="u:checkPIVA" as="xs:integer" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string?"/>
		<sequence select="
				if (not($arg castable as xs:integer)) 
					then 1
					else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
	</function>
	<function name="u:addPIVA" as="xs:integer" xmlns="http://www.w3.org/1999/XSL/Transform">
		<param name="arg" as="xs:string"/>
		<param name="pari" as="xs:integer"/>
		<variable name="tappo" select="if (not($arg castable as xs:integer)) then 0 else 1"/>
		<variable name="mapper" select="if ($tappo = 0) then 0 else 
																		( if ($pari = 1) 
																			then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) ) 
																			else ( xs:integer(substring($arg,1,1) ) )
																		)"/>
		<sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>
	</function>
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:abn" as="xs:boolean">
		<param name="val"/>
		<value-of select="(
((string-to-codepoints(substring($val,1,1)) - 49) * 10) +
((string-to-codepoints(substring($val,2,1)) - 48) * 1) +
((string-to-codepoints(substring($val,3,1)) - 48) * 3) +
((string-to-codepoints(substring($val,4,1)) - 48) * 5) +
((string-to-codepoints(substring($val,5,1)) - 48) * 7) +
((string-to-codepoints(substring($val,6,1)) - 48) * 9) +
((string-to-codepoints(substring($val,7,1)) - 48) * 11) +
((string-to-codepoints(substring($val,8,1)) - 48) * 13) +
((string-to-codepoints(substring($val,9,1)) - 48) * 15) +
((string-to-codepoints(substring($val,10,1)) - 48) * 17) +
((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0
"/>
	</function>
	<!-- Empty elements -->
	
	<!--
    Transaction rules

    R00X - Document level
    R01X - Accounting customer
    R02X - Accounting supplier
    R04X - Allowance/Charge (document and line)
    R05X - Tax
    R06X - Payment
    R08X - Additonal document reference
    R1XX - Line level
    R11X - Invoice period
  -->		
  
  <!-- GREECE -->
	<!-- General functions and variable for Greek Rules -->
	<function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:TinVerification" as="xs:boolean">
		<param name="val" as="xs:string"/>
		<variable name="digits" select="
			for $ch in string-to-codepoints($val)
			return codepoints-to-string($ch)"/>
		<variable name="checksum" select="
			(number($digits[8])*2) +
			(number($digits[7])*4) +
			(number($digits[6])*8) +
			(number($digits[5])*16) +
			(number($digits[4])*32) +
			(number($digits[3])*64) +
			(number($digits[2])*128) +
			(number($digits[1])*256) "/>
		<value-of select="($checksum  mod 11) mod 10 = number($digits[9])"/>
	</function>

	<let name="isGreekSender" value="($supplierCountry ='GR') or ($supplierCountry ='EL')"/>
	<let name="isGreekReceiver" value="($customerCountry ='GR') or ($customerCountry ='EL')"/>
	<let name="isGreekSenderandReceiver" value="$isGreekSender and $isGreekReceiver"/>
	<!-- Test only accounting Supplier Country -->
	<let name="accountingSupplierCountry" value="
    if (/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then
    upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))
    else
    if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then
    upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))
    else
    'XX'"/>
	
	<let name="supplierCountryIsDE" value="(upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'DE')"/>
	<let name="customerCountryIsDE" value="(upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'DE')"/>
	<let name="documentCurrencyCode" value="/*/cbc:DocumentCurrencyCode"/>
	
	
	
	<!-- EN16931 UBL Validation -->
	<include href="CEN/CEN-EN16931-UBL-syntax.inc"/>
	<include href="CEN/CEN-EN16931-UBL-model.inc"/>
	<include href="CEN/CEN-EN16931-UBL-codelist.inc"/>
	<!-- OpenPEPPOL UBL Validation -->
	<include href="OPENPEPPOL/1-PEPPOL-EN16931-UBL-emptyElements.inc"/>
	<include href="OPENPEPPOL/2-PEPPOL-EN16931-UBL-creditNote.inc"/>
	<include href="OPENPEPPOL/3-PEPPOL-EN16931-UBL-general.inc"/>
	
	<!-- National rules -->
	<include href="OPENPEPPOL/4-PEPPOL-EN16931-UBL-norway.inc"/>
	
	<!-- DENMARK -->
	<include href="OPENPEPPOL/5-PEPPOL-EN16931-UBL-denmark.inc"/>
	
	<!-- ITALY -->
	<include href="OPENPEPPOL/6-PEPPOL-EN16931-UBL-italy.inc"/>
	
	<!-- SWEDEN -->
	<include href="OPENPEPPOL/7-PEPPOL-EN16931-UBL-sweden.inc"/>

	<!-- Sender Rules -->
	<include href="OPENPEPPOL/8-PEPPOL-EN16931-UBL-greece-sender.inc"/>
	

	<!-- Greek Sender and Greek Receiver rules -->
	<include href="OPENPEPPOL/9-PEPPOL-EN16931-UBL-greece-senderreceiver.inc"/>
	
	<!-- ICELAND -->
	<include href="OPENPEPPOL/10-PEPPOL-EN16931-UBL-iceland.inc"/>
	
	<!-- NETHERLANDS -->
	<include href="OPENPEPPOL/11-PEPPOL-EN16931-UBL-netherlands.inc"/>
	
	<!-- GERMANY -->
	<include href="OPENPEPPOL/12-PEPPOL-EN16931-UBL-germany.inc"/>
	
	<!-- Restricted code lists and formatting -->
	<include href="OPENPEPPOL/13-PEPPOL-EN16931-UBL-codelists.inc"/>
	
</schema>