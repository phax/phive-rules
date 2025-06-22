<?xml version="1.0" encoding="UTF-8"?>
<!--

    Licensed under European Union Public Licence (EUPL) version 1.2.

-->
<!--Schematron version 1.3.10 - Last update: 2023-04-08-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
	<ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
	<ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
	<ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
	<ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
	<ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
	<ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
	<ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
	<ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
	<title>Regole di business EN16931 modellate su UBL</title>
	<phase id="EN16931model_phase">
		<active pattern="UBL-model"/>
	</phase>
	<phase id="codelist_phase">
		<active pattern="Codesmodel"/>
	</phase>
	<include href="./CEN-EN16931-UBL-syntax.inc"/>
	<include href="./CEN-EN16931-UBL-model.inc"/>
	<include href="./CEN-EN16931-UBL-codelist.inc"/>

</schema>
