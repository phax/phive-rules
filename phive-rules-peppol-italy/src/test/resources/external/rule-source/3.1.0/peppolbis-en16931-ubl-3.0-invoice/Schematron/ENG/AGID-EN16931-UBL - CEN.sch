<?xml version="1.0" encoding="UTF-8"?>
<!--

    Licensed under European Union Public Licence (EUPL) version 1.2.
	This schematron uses business terms defined the CEN/EN16931-1 and is reproduced with permission from CEN. CEN bears no liability from the use of the content and implementation of this schematron and gives no warranties expressed or implied for any purpose.
	
	Peppol BIS Billing 3.0.14
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
	
	
	<!-- EN16931 UBL Validation -->
	<include href="CEN/CEN-EN16931-UBL-syntax.inc"/>
	<include href="CEN/CEN-EN16931-UBL-model.inc"/>
	<include href="CEN/CEN-EN16931-UBL-codelist.inc"/>
	
</schema>