<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:UBL="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2" queryBinding="xslt2">
  <title>BIIRULES  T58 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <phase id="BIIRULEST58_phase">
    <active pattern="UBL-T58"/>
  </phase>
  
  
  <!--Suppressed abstract pattern T58 was here-->
  
  
  <!--Start pattern based on abstract T58--><pattern id="UBL-T58">
  <rule context="/ubl:ApplicationResponse">
    <assert test="(cbc:ProfileID)" flag="fatal" id="BII2-T58-R001">[BII2-T58-R001]-A catalogue rejection MUST have a profile identifier</assert>
    <assert test="(cbc:CustomizationID)" flag="fatal" id="BII2-T58-R002">[BII2-T58-R002]-A catalogue rejection MUST have a customization identifier</assert>
    <assert test="(cbc:IssueDate)" flag="fatal" id="BII2-T58-R003">[BII2-T58-R003]-A catalogue rejection MUST contain the date of issue</assert>
    <assert test="(cbc:ID)" flag="fatal" id="BII2-T58-R004">[BII2-T58-R004]-A catalogue rejection MUST contain the response identifier</assert>
    <assert test="(cac:SenderParty)" flag="fatal" id="BII2-T58-R005">[BII2-T58-R005]-The party sending the catalogue rejection MUST be specified</assert>
    <assert test="(cac:ReceiverParty)" flag="fatal" id="BII2-T58-R006">[BII2-T58-R006]-The party receiving the catalogue rejection MUST be specified</assert>
    <assert test="(cac:DocumentResponse/cac:Response/cbc:ResponseCode)" flag="fatal" id="BII2-T58-R009">[BII2-T58-R009]-A catalogue rejection MUST contain a response decision</assert>
    <assert test="(//cac:DocumentReference/cbc:ID)" flag="fatal" id="BII2-T58-R010">[BII2-T58-R010]-A catalogue rejection MUST contain a document reference</assert>
  </rule>
  <rule context="//cac:ReceiverParty">
    <assert test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)" flag="fatal" id="BII2-T58-R008">[BII2-T58-R008]-A catalogue rejection receiving party MUST contain the full name or an identifier</assert>
  </rule>
  <rule context="//cac:SenderParty">
    <assert test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)" flag="fatal" id="BII2-T58-R007">[BII2-T58-R007]-A catalogue rejection sending party MUST contain the full name or an identifier</assert>
  </rule>
</pattern>
</schema>