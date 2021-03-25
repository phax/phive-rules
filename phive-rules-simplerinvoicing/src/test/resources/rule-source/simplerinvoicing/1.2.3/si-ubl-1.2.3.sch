<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" queryBinding="xslt2" xmlns="http://purl.oclc.org/dsdl/schematron">
    <!--
        Release 1.2.3
        Date: 2020-09-01
        Author: Jelte Jansen (Ionite / headON / Simplerinvoicing)
        - Correctly mark the schema element as XSLT2
        - Renamed the BII pattern to avoid conflicts
        - Added a check for the existence of cbc:ID in cac:Item/cac:ClassifiedTaxCategory. The cardinality of cbc:ID here is 1..1, but this was not checked.
        - The same for cac:TaxRepresentativeParty/cac:PartyTaxScheme

        Release 1.2.2
        Date: 2020-03-30
        Author: Jelte Jansen (Ionite / headON / Simplerinvoicing)
        Changes since 1.2.1:
        - Fixed ISO6523 ICD code value for DK:DIGST


        Release 1.2.1
        Date: 2020-01-23
        Author: Jelte Jansen (Ionite / headON / Simplerinvoicing)
        Changes since 1.2:
        - Added new ISO6523 ICD Codes:
            AU:ABN (0151)
            CH:UIDB (0183)
            DE:LID (9958)
            DK:ERST (0198)
            EE:CC (0191)
            IS:KTNR (0196)
            LEI (0199)
            LT:LEC (0200)
            NAL (0130)
            NL:OINO (0190)
            NO:ORG (0192)
            NO:ORGNR (9908)
            SG:UEN (0195)
            UBLBE (0193)

        Release 1.2
        Author: Rik Ribbers, Jelte Jansen (SIDN)
        Email: support@simplerinvoicing.org
        Changes since 1.1.1:
        - SI-UBL version 1.2 rules included
        - XSLT 2.0 support

        Release 1.1.1
        Author: Jelte Jansen (SIDN Labs)
        Changes since 1.1:
        - SI-UBL version detection is now based on CustomizationID instead of UBLVersion
        - Split up schematron tree into versions (v1.0 and v1.1)
        - Added UBL Business rules to v1.0 checker

        Release 1.1
        Author: M.P. Diepstra (Innopay)
    -->
    <title>Simplerinvoicing invoice v1.2 bound to UBL 2.1 and OPENPEPPOL v2, version 1.2.3</title>
    <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
    <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
    <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>

    <!-- version check -->
    <pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="SI-UBL-VERSIONS">
        <rule context="/">
            <assert test="ubl:Invoice" flag="fatal">[SI-INV-R000]-This is NOT a UBL 2.x Invoice, validation cannot continue</assert>
        </rule>
        <rule context="ubl:Invoice">
            <assert test="cbc:CustomizationID" flag="fatal">[BII2-T10-R001] An invoice MUST have a customization identifier</assert>
        </rule>
        <rule context="cbc:CustomizationID">
            <assert test="contains(normalize-space(.), 'urn:www.cenbii.eu:transaction:biitrns010:ver2.0:extended:urn:www.peppol.eu:bis:peppol4a:ver2.0:extended:urn:www.simplerinvoicing.org:si:si-ubl:ver1.2')" flag="fatal">[SI-V12-INV-R200]-This XML instance is NOT tagged as an SI-UBL 1.2 invoice; please check the CustomizationID value</assert>
        </rule>
    </pattern>

    <!-- SimplerInvoicing Version 1.2 -->

    <include href="si-ubl-1.2/si-invoice/SI-UBL-INV-V12-WARNING.SCH" />
    <include href="si-ubl-1.2/si-invoice/SI-UBL-INV-V12-FATAL.SCH" />
    <include href="si-ubl-1.2/si-invoice/SI-UBL-INV-V12-Codes.SCH" />

    <include href="si-ubl-1.2/si-invoice/BII/abstract/BIIRULES-T10.sch"/>
    <include href="si-ubl-1.2/si-invoice/BII/UBL/BIIRULES-UBL-T10.sch"/>
    <include href="si-ubl-1.2/si-invoice/BII/codelist/BIIRULESCodesT10-UBL.sch"/>

    <include href="si-ubl-1.2/si-invoice/PEPPOL/abstract/OPENPEPPOL-T10.sch"/>
    <include href="si-ubl-1.2/si-invoice/PEPPOL/UBL/OPENPEPPOL-UBL-T10.sch"/>
    <include href="si-ubl-1.2/si-invoice/PEPPOL/codelist/OPENPEPPOLCodesT10-UBL.sch"/>

</schema>
