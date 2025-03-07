<?xml version="1.0" encoding="UTF-8"?>

<!--
******************************************************************************************************************

		OIOUBL Schematron

		publisher:          NemHandel / Erhvervsstyrelsen
        Repository path:    $HeadURL$
        File version:       $Revision$
        Last changed by:    $Author$
        Last changed date:  $Date$

		Description:        This document is produced as part of the OIOUBL schematron package

******************************************************************************************************************
-->

<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" 				  prefix="ubl-creditnote"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" 					 prefix="ubl-invoice"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"          prefix="ubl"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"    prefix="cac"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"        prefix="cbc"/>
	<ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" prefix="ext"/>
	<ns uri="utils" prefix="u"/>

	<p>Schematron for validating OIOUBL-3 documents.</p>
	<title>Checking OIOUBL-3 Message Level Response</title>


	<!-- Inclusion of OIOUBL codelist variables -->
<!--	<include href="OIOUBL_Codelist_Schematron.xml"/>-->


	<!-- Global variables -->


	<!-- The default phase to execute when validating -->
	<phase id="default">

		<active pattern="profile"/>

	</phase>

	<!-- Load functions -->
	<include href="_common/Schematron/sch/function/gln.xml"/>

	<!-- Excecute common rules -->
	<include href="_common/Schematron/sch/common-OIOUBL.sch"/>

	<!-- Excecute common rules for ApplicationResponse documents -->
	<include href="_common/Schematron/sch/common-application-response.sch"/>
	<include href="_common/Schematron/sch/Excluded-Elements.sch"/>
	<include href="_common/Schematron/sch/environmental-aspects.sch"/>

	<!-- - - - - - - - - - - -  Profile - - - - - - - - - - - - -  -->
	<pattern id="profile">
		<p>Pattern for validating Profile</p>
		<!-- Validate root element -->
        <rule context="/ubl:ApplicationResponse/cbc:ProfileID">
            <assert id="OIOUBL-MLR-001"
						test="normalize-space(.) = 'urn:fdc:oioubl.dk:bis:message_level_response:3' or normalize-space(text()) = 'urn:fdc:oioubl.dk:bis:message_level_response_network:3'"
						flag="fatal">
                Element 'cbc:ProfileID' MUST contain value 'urn:fdc:oioubl.dk:bis:message_level_response:3' or 'urn:fdc:oioubl.dk:bis:message_level_response_network:3'.
            </assert>
        </rule>
        <rule context="/ubl:ApplicationResponse/cbc:CustomizationID">
            <assert id="OIOUBL-MLR-002"
						test="normalize-space(.) = 'urn:fdc:peppol.eu:poacc:trns:mlr:3@urn:fdc:oioubl.dk:trns:message_level_response:3.0'"
						flag="fatal">
                Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:peppol.eu:poacc:trns:mlr:3@urn:fdc:oioubl.dk:trns:message_level_response:3.0'.
            </assert>
        </rule>
	</pattern>

	<!-- - - - - - - - - - - -  message_level_response_network constraint - - - - - - - - - - - - -  -->
	<pattern id="message_level_response_network">
		<p>Pattern for constraining message_level_response_network ResponseCode</p>
		<rule context="/ubl:ApplicationResponse">
			<assert id="OIOUBL-MLR-003"
						test="(cbc:ProfileID = 'urn:fdc:oioubl.dk:bis:message_level_response_network:3' and cac:DocumentResponse/cac:Response/cbc:ResponseCode = 'RE') or cbc:ProfileID != 'urn:fdc:oioubl.dk:bis:message_level_response_network:3'"
						flag="fatal">
				If ProfileID is 'urn:fdc:oioubl.dk:bis:message_level_response_network:3' then ResponseCode MUST be 'RE'
			</assert>
		</rule>
	</pattern>


</schema>
