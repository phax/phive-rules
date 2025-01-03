<?xml version="1.0" encoding="UTF-8"?>
<sch:rule xmlns:sch="http://purl.oclc.org/dsdl/schematron" context="cac:Party/cac:PartyIdentification/cbc:ID">
    <sch:assert test="(@schemeID eq '0192') and (matches(normalize-space(.), 'DK\d{8}'))">[F-INV????] When the schmemaID are '<sch:value-of select="@schemeID"/>' then 'cac:PartyIdentification/cbc:ID' must have the following syntax: DK######## - Value found: '<sch:value-of select="."/>'</sch:assert>
</sch:rule>