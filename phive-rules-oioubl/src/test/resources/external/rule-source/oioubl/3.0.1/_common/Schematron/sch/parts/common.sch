<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:u="utils"
        schemaVersion="iso" queryBinding="xslt2">

  <title>Common PEPPOL rules for Post-Award</title>

  <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
  <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
  <ns uri="utils" prefix="u"/>

  <include href="function/gln.xml"/>
  <include href="function/mod11.xml"/>
  <include href="function/addPIVA.xml"/>
  <include href="function/checkCF.xml"/>
  <include href="function/checkCF16.xml"/>
  <include href="function/checkPIVA.xml"/>
  <include href="function/checkPIVAseIT.xml"/>
  <include href="function/mod97-0208.xml"/>
  <include href="function/checkCodiceIPA.xml"/>
  <include href="function/abn.xml"/>  
  <include href="function/checkSEOrgnr.xml"/>

  <include href="common/empty-elements.sch"/>
  <include href="common/rules.sch"/>

 </schema>
