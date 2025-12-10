
<!--
     These G-account extension rules are based on the specification in
     https://stpe.nl/media/Dutch%20national%20EN%2016931%20extension%20-%20G-account%20version%201.0.pdf

     The rules include SI-UBL version 2.0.3.12, as well as a modified version of the CenPC-434, to allow for multiple
     PaymentMeans and PaymentTerms elements.

     version 1.0.2.12

     Authors:
     Michiel Stornebrink
     Jelte Jansen
-->
<schema xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
    xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
    xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">

    <title>SI-UBL G-Account extension validation, version 1.0.2.12</title>
    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>

    <!-- additional prefixes for EN-16931 -->
    <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
    <ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
    <ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
    <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>

    <!-- G-Account specific rules -->
    <pattern xmlns="http://purl.oclc.org/dsdl/schematron" abstract="false" id="g-account-extension">

        <!-- BR-GA-0 (not formally defined in the specification -->
        <rule context="//cbc:CustomizationID">
            <assert test="starts-with(normalize-space(.), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:nen.nl:nlcius:v1.0')" flag="fatal">[SI-V20-INV-R000]-This XML instance is NOT tagged as an SI-UBL 2.0 invoice or credit note; please check the CustomizationID value</assert>
            <assert id="BR-GA-0" test="contains(., '#conformant#urn:fdc:nen.nl:gaccount:v1.0')" flag="fatal">[BR-GA-0] When using the G-account extension, the CustomizationID must specify this.
            </assert>
        </rule>

        <rule context="/ubl:Invoice">
            <!-- BR-GA-1 The number of Payment Terms (NL-GA-01) in each invoice MUST be two. -->
            <assert id="BR-GA-1" test="count(cac:PaymentTerms) = 2" flag="fatal">[BR-GA-1] The number of Payment Terms (NL-GA-01) in each invoice MUST be two.</assert>
            <!-- BR-GA-2 The number of Payment Instructions (BG-16) in each invoice MUST be two. -->
            <assert id="BR-GA-2" test="count(cac:PaymentMeans) = 2" flag="fatal">[BR-GA-2] The number of Payment Instructions (BG-16) in each invoice MUST be two.</assert>
            <!-- BR-GA-3 Sum of Amount due for payment (BT-115) = ∑ Payment Amount (NL-GA-03) -->
            <assert id="BR-GA-3" test="cac:LegalMonetaryTotal/xs:decimal(cbc:PayableAmount) = sum(cac:PaymentTerms/xs:decimal(cbc:Amount))" flag="fatal">[BR-GA-3] Sum of Amount due for payment (BT-115) = ∑ Payment Amount (NL-GA-03)</assert>
            <!-- BR-GA-7 There MUST be a Payment Means identifier (NL-GA-04) with a value equal to 'GACCOUNT' -->
            <assert id="BR-GA-7" test="count(cac:PaymentMeans/cbc:ID[text()='GACCOUNT']) = 1" flag="fatal">[BR-GA-7] There MUST be a Payment Means identifier (NL-GA-04) with a value equal to 'GACCOUNT'</assert>
        </rule>

        <!-- BR-GA-4 Each Payment Terms (NL-GA-01) MUST include a Payment Means reference (NL-GA-02) -->
        <rule context="/ubl:Invoice/cac:PaymentTerms">
            <assert id="BR-GA-4" test="count(cbc:PaymentMeansID) = 1" flag="fatal">[BR-GA-4] Each Payment Terms (NL-GA-01) MUST include a Payment Means reference (NL-GA-02)</assert>
        </rule>

        <!-- BR-GA-5 Each Payment Instructions (BG-16) MUST include a Payment Means identifier (NL-GA-04) -->
        <rule context="/ubl:Invoice/cac:PaymentMeans">
            <assert id="BR-GA-5" test="count(cbc:ID) = 1" flag="fatal">[BR-GA-5] Each Payment Instructions (BG-16) MUST include a Payment Means identifier (NL-GA-04)</assert>
        </rule>

        <!-- BR-GA-6 The value of each Payment Means reference (NL-GA-02) MUST correspond with one and only one Payment means identifier (NL-GA-04) -->
        <!-- See https://dh.obdurodon.org/schematron-skyrim.xhtml for explenation of rule setup -->
        <let name="payment-means-ids" value="/ubl:Invoice/cac:PaymentMeans/cbc:ID/text()"/>
        <rule context="/ubl:Invoice/cac:PaymentTerms/cbc:PaymentMeansID">
            <assert id="BR-GA-6" test=". = $payment-means-ids" flag="fatal">[BR-GA-6] The value of each Payment Means reference (NL-GA-02) MUST correspond with one and only one Payment means identifier (NL-GA-04)</assert>
        </rule>

    </pattern>

    <!-- include the rules for SI-UBL 2.0 -->
    <include href="si-ubl-2.0/si-ubl-2.0-nlcius.sch"/>

    <!-- EN-16931 -->
    <!-- Modified version of the syntax, to allow for multiple PaymentMeans and PaymentTerms -->
    <include href="si-ubl-2.0/CenPC434/abstract/EN16931-model.sch"/>
    <include href="si-ubl-2.0-ext-gaccount/EN16931-syntax-modified.sch"/>

    <include href="si-ubl-2.0/CenPC434/codelist/EN16931-UBL-codes.sch"/>

    <include href="si-ubl-2.0/CenPC434/UBL/EN16931-UBL-model.sch"/>
    <include href="si-ubl-2.0/CenPC434/UBL/EN16931-UBL-syntax.sch"/>
</schema>
