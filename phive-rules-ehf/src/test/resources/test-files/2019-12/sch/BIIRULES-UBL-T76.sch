<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:UBL="urn:oasis:names:specification:ubl:schema:xsd:OrderResponse-2" queryBinding="xslt2">
  <title>BIIRULES  T76 bound to UBL</title>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:OrderResponse-2"/>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <phase id="BIIRULEST76_phase">
    <active pattern="UBL-T76"/>
  </phase>
  
  
  <!--Suppressed abstract pattern T76 was here-->
  
  
  <!--Start pattern based on abstract T76--><pattern id="UBL-T76">
  <rule context="/ubl:OrderResponse">
    <assert test="(cbc:CustomizationID)" flag="fatal" id="BII2-T76-R001">[BII2-T76-R001]-A order response MUST have a customization identifier</assert>
    <assert test="(cbc:ProfileID)" flag="fatal" id="BII2-T76-R002">[BII2-T76-R002]-A order response MUST have a profile identifier</assert>
  </rule>
  <rule context="//cac:OrderLine">
    <assert test="(cac:LineItem/cbc:ID)" flag="fatal" id="BII2-T76-R003">[BII2-T76-R003]-Each order response line MUST have a document line identifier that is unique within the order response</assert>
  </rule>
  <rule context="/ubl:OrderResponse">
    <assert test="(cbc:IssueDate)" flag="fatal" id="BII2-T76-R004">[BII2-T76-R004]-A order response MUST have a document issue date</assert>
    <assert test="(cbc:ID)" flag="fatal" id="BII2-T76-R006">[BII2-T76-R006]-A order response MUST have a document identifier</assert>
  </rule>
  <rule context="//cac:BuyerCustomerParty">
    <assert test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal" id="BII2-T76-R021">[BII2-T76-R021]-A order response MUST have the buyer party name or a buyer party identifier</assert>
  </rule>
  <rule context="//cac:SellerSupplierParty">
    <assert test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" flag="fatal" id="BII2-T76-R022">[BII2-T76-R022]-A order response MUST have the seller party name or a seller party identifier</assert>
  </rule>
  <rule context="/ubl:OrderResponse">
    <assert test="(cac:OrderReference/cbc:ID)" flag="fatal" id="BII2-T76-R032">[BII2-T76-R032]-A order response MUST have a reference to an order</assert>
    <assert test="(//cbc:OrderResponseCode)" flag="fatal" id="BII2-T76-R033">[BII2-T76-R033]-A order response MUST have a response code</assert>
  </rule>
  <rule context="//cac:OrderLine">
    <assert test="(//cac:OrderLineReference/cbc:LineID)" flag="fatal" id="BII2-T76-R034">[BII2-T76-R034]-An order response line MUST contain a reference to its corresponding order line.</assert>
  </rule>
</pattern>
</schema>