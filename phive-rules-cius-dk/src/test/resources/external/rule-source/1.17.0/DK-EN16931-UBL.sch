<?xml version="1.0" encoding="UTF-8"?>
<!-- 
        Publisher:          NemHandel / Erhvervsstyrelsen
        Repository path:    $HeadURL$
        File version:       $Revision$
        Last changed by:    $Author$
        Last changed date:  $Date$
-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" schemaVersion="iso" queryBinding="xslt2">
    <title>Danish PEPPOL BIS 3.0 Billing Schematron</title>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" prefix="ubl-creditnote"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" prefix="ubl-invoice"/>

    <!-- Denmark specific rules -->
    <pattern>
        <!-- No rules yet implemented. -->
        <!--<rule context="ubl:Invoice/cac:PaymentMeans">-->
        <!--<report flag="fatal" id="DK-R-008" test="(cbc:PaymentMeansCode = '50') and not(cbc:PaymentID = '01' or cbc:PaymentID = '04' or cbc:PaymentID = '15')">If PaymentMeansCode = "50" (Giro) then PaymentID must be either "01", "04" or "15".</report>-->
        <!--<report flag="fatal" id="DK-R-009" test="(cbc:PaymentMeansCode = '93') and not(cbc:PaymentID = '71' or cbc:PaymentID = '73' or cbc:PaymentID = '75')">If PaymentMeansCode = "93" (FIK) then PaymentID must be either "71", "73" or "75".</report>-->
        <!--</rule>-->
    </pattern>
</schema>
