<?xml version="1.0" encoding="UTF-8"?>
<!--

    Licensed under European Union Public Licence (EUPL) version 1.2.

    Serbian SRBDT CIUS and Extension (srbdtext) rules taken from
    https://github.com/vasiljevic/en16931-srbdt-va

    This variant only contains the Serbia specific rules. The underlying
    EN 16931 rules are applied separately via the phive EN 16931 validation
    artefacts, so the EN 16931 base patterns are intentionally NOT included
    here (to avoid running the EN 16931 rules twice).

-->
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:UBL="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" queryBinding="xslt2">
  <title>Serbian SRBDT CIUS and Extension rules bound to UBL</title>
  <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
  <ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
  <ns prefix="cn"  uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
  <ns prefix="xs"  uri="http://www.w3.org/2001/XMLSchema"/>
  <ns prefix="sbt" uri="http://mfin.gov.rs/srbdt/srbdtext"/>

  <!-- SRBDT CIUS/ES rules -->
  <!-- =================== -->
  <include href="EN16931-UBL-srbdt.sch"/>
  <include href="EN16931-UBL-srbdt-pdvcat-gen.sch"/>
  <include href="EN16931-UBL-srbdt-pdvcat-r.sch"/>
  <include href="EN16931-UBL-srbdt-pdvcat-oe.sch"/>
  <include href="EN16931-UBL-srbdt-pdvcat-ss.sch"/>
  <include href="EN16931-UBL-srbdt-pdvcat-n.sch"/>
</schema>
