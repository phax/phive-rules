<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************************************

		OIOUBL Schematron

		publisher:          NemHandel / Erhvervsstyrelsen
        Repository path:    $HeadURL$
        File version:       $Revision$
        Last changed by:    $Author$
        Last changed date:  $Date$

		Description:        This document is produced as part of the OIOUBL3 schematron package

******************************************************************************************************************
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" prefix="ubl-invoice"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" prefix="ubl-creditnote"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" prefix="ext"/>
    <ns uri="utils" prefix="u"/>



    <!-- Functions -->
    <include href="_common/Schematron/sch/function/gln.xml"/>
    <include href="_common/Schematron/sch/function/slack.xml"/>
    <include href="_common/Schematron/sch/function/checkCF.xml"/>
    <include href="_common/Schematron/sch/function/mod11.xml"/>
    <include href="_common/Schematron/sch/function/mod97-0208.xml"/>
    <include href="_common/Schematron/sch/function/checkCodiceIPA.xml"/>
    <include href="_common/Schematron/sch/function/checkPIVAseIT.xml"/>
    <include href="_common/Schematron/sch/function/abn.xml"/>
    <include href="_common/Schematron/sch/function/checkCF16.xml"/>
    <include href="_common/Schematron/sch/function/checkPIVA.xml"/>
    <include href="_common/Schematron/sch/function/checkSEOrgnr.xml"/>
    <include href="_common/Schematron/sch/function/addPIVA.xml"/>

    <pattern>
        <title>OIOUBL 3 Invoice validation</title>

        <rule context="/">

            <assert id="OIOUBL-INV-001" flag="fatal" test="name(/*) eq 'Invoice'">The root element
                must be 'Invoice'.</assert>
        </rule>
    </pattern>


    <!-- Schematrons  -->
    <include href="_common/Schematron/sch/Excluded-Elements.sch"/>
    <include href="_common/Schematron/sch/Miscellaneous.sch"/>
    <include href="_common/Schematron/sch/Peppol-billing-EN16931-Main.sch"/>
    <include href="_common/Schematron/sch/Peppol-billing-EN16931-Common.sch"/>
    <include href="_common/Schematron/sch/common-OIOUBL-billing.sch"/>
    <include href="_common/Schematron/sch/common-OIOUBL-billing-PaymentMeans.sch"/>
    <include href="_common/Schematron/sch/common-OIOUBL.sch"/>
    <include href="_common/Schematron/sch/environmental-aspects.sch"/>



</schema>
