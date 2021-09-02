<?xml version="1.0" encoding="UTF-8"?>
<!--
     These are the NLCIUS-specific validation rules for UN/CEFACT CII D16B documents
     
     The validation rules include the validation files from CEN, validating EN-16931,
     as published on https://github.com/ConnectingEurope/eInvoicing-EN16931
     
     Release 1.0.3.1
     
     Authors:
     - Wouter van den Berg (TNO)
     - Robin de Veer (TNO)
     
     Additional changes by
     - Jelte Jansen (Simplerinvoicing) 
     
     Changelog: see Changelog file in repository root
-->
<schema
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns="http://purl.oclc.org/dsdl/schematron"
    queryBinding="xslt2"
>
  <title>NLCIUS-CII validation, version 1.0.3.1</title>
  <ns prefix="ccts" uri="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2" />
  <ns prefix="qdt" uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" />
  <ns prefix="ram" uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" />
  <ns prefix="rsm" uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" />
  <ns prefix="udt" uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" />
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />


  <!-- EN-16931 rules for UN/CEFACT CII -->
  <include href="nlcius-cii/CenPC434/abstract/EN16931-CII-model.sch"/>
  <include href="nlcius-cii/CenPC434/abstract/EN16931-CII-syntax.sch"/>
  <include href="nlcius-cii/CenPC434/CII/EN16931-CII-model.sch"/>
  <include href="nlcius-cii/CenPC434/CII/EN16931-CII-syntax.sch"/>
  <include href="nlcius-cii/CenPC434/codelist/EN16931-CII-codes.sch"/>


  <!-- NLCIUS rules -->
  <include href="nlcius-cii/NLCIUS-CII-validation.sch"/>

</schema>
