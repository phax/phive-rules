<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        xmlns:u="utils"
        schemaVersion="iso"
        queryBinding="xslt2">

   <title>Norwegian rules for EHF Order</title>

   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
       prefix="cbc"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
       prefix="cac"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:Order-2" prefix="ubl"/>

   <pattern xmlns:ns2="http://www.schematron-quickfix.com/validator/process">
      <rule context="/ubl:Order">
         <assert test="cbc:UBLVersionID" flag="warning" id="EHF-T01-B00101">Element 'cbc:UBLVersionID' MUST be provided.</assert>
         <assert test="cbc:CustomizationID" flag="warning" id="EHF-T01-B00102">Element 'cbc:CustomizationID' MUST be provided.</assert>
         <assert test="cbc:ProfileID" flag="warning" id="EHF-T01-B00103">Element 'cbc:ProfileID' MUST be provided.</assert>
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B00104">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:IssueDate" flag="warning" id="EHF-T01-B00105">Element 'cbc:IssueDate' MUST be provided.</assert>
         <assert test="cbc:DocumentCurrencyCode" flag="warning" id="EHF-T01-B00106">Element 'cbc:DocumentCurrencyCode' MUST be provided.</assert>
         <assert test="cac:OrderLine" flag="warning" id="EHF-T01-B00107">Element 'cac:OrderLine' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cbc:UBLVersionID">
         <assert test="normalize-space(text()) = '2.1'"
                 flag="warning"
                 id="EHF-T01-B00201">Element 'cbc:UBLVersionID' MUST contain value '2.1'.</assert>
      </rule>
      <rule context="/ubl:Order/cbc:CustomizationID"/>
      <rule context="/ubl:Order/cbc:ProfileID"/>
      <rule context="/ubl:Order/cbc:ID"/>
      <rule context="/ubl:Order/cbc:IssueDate"/>
      <rule context="/ubl:Order/cbc:IssueTime"/>
      <rule context="/ubl:Order/cbc:OrderTypeCode">
         <assert test="@listID" flag="warning" id="EHF-T01-B00801">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cbc:Note"/>
      <rule context="/ubl:Order/cbc:DocumentCurrencyCode">
         <assert test="@listID" flag="warning" id="EHF-T01-B01101">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cbc:AccountingCost"/>
      <rule context="/ubl:Order/cac:ValidityPeriod"/>
      <rule context="/ubl:Order/cac:ValidityPeriod/cbc:EndDate"/>
      <rule context="/ubl:Order/cac:QuotationDocumentReference">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B01601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:QuotationDocumentReference/cbc:ID"/>
      <rule context="/ubl:Order/cac:OrderDocumentReference">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B01801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderDocumentReference/cbc:ID"/>
      <rule context="/ubl:Order/cac:OriginatorDocumentReference">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B02001">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OriginatorDocumentReference/cbc:ID"/>
      <rule context="/ubl:Order/cac:OriginatorDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:Order/cac:AdditionalDocumentReference">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B02301">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AdditionalDocumentReference/cbc:ID"/>
      <rule context="/ubl:Order/cac:AdditionalDocumentReference/cbc:DocumentType"/>
      <rule context="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment"/>
      <rule context="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject">
         <assert test="@mimeCode" flag="warning" id="EHF-T01-B02701">Attribute 'mimeCode' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference">
         <assert test="cbc:URI" flag="warning" id="EHF-T01-B02901">Element 'cbc:URI' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI"/>
      <rule context="/ubl:Order/cac:Contract">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B03101">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:Contract/cbc:ID"/>
      <rule context="/ubl:Order/cac:Contract/cbc:ContractType"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty">
         <assert test="cac:Party" flag="warning" id="EHF-T01-B03401">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B03601">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B03801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B03901">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="warning" id="EHF-T01-B04101">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="warning" id="EHF-T01-B04901">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="@listID" flag="warning" id="EHF-T01-B05001">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme">
         <assert test="cbc:CompanyID" flag="warning" id="EHF-T01-B05201">Element 'cbc:CompanyID' MUST be provided.</assert>
         <assert test="cac:TaxScheme" flag="warning" id="EHF-T01-B05202">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B05501">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="warning" id="EHF-T01-B06301">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="@listID" flag="warning" id="EHF-T01-B06401">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Contact"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Contact/cbc:ID"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Contact/cbc:Telefax"/>
      <rule context="/ubl:Order/cac:BuyerCustomerParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty">
         <assert test="cac:Party" flag="warning" id="EHF-T01-B07201">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cbc:EndpointID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B07401">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B07601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B07701">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="warning" id="EHF-T01-B07901">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="warning" id="EHF-T01-B08701">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="@listID" flag="warning" id="EHF-T01-B08801">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Contact"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Contact/cbc:Telefax"/>
      <rule context="/ubl:Order/cac:SellerSupplierParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:Order/cac:OriginatorCustomerParty">
         <assert test="cac:Party" flag="warning" id="EHF-T01-B09501">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party"/>
      <rule context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B09701">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B09801">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="warning" id="EHF-T01-B10001">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact"/>
      <rule context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Name"/>
      <rule context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Telefax"/>
      <rule context="/ubl:Order/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty">
         <assert test="cac:Party" flag="warning" id="EHF-T01-B10701">Element 'cac:Party' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party">
         <assert test="cac:PostalAddress" flag="warning" id="EHF-T01-B10801">Element 'cac:PostalAddress' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B10901">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B11101">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B11201">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyName">
         <assert test="cbc:Name" flag="warning" id="EHF-T01-B11401">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress">
         <assert test="cbc:CityName" flag="warning" id="EHF-T01-B11601">Element 'cbc:CityName' MUST be provided.</assert>
         <assert test="cbc:PostalZone" flag="warning" id="EHF-T01-B11602">Element 'cbc:PostalZone' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country">
         <assert test="cbc:IdentificationCode" flag="warning" id="EHF-T01-B12201">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode">
         <assert test="@listID" flag="warning" id="EHF-T01-B12301">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme">
         <assert test="cac:TaxScheme" flag="warning" id="EHF-T01-B12501">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B12701">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode">
         <assert test="@listID" flag="warning" id="EHF-T01-B13501">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:Contact"/>
      <rule context="/ubl:Order/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ID"/>
      <rule context="/ubl:Order/cac:Delivery"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:ID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B14201">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country">
         <assert test="cbc:IdentificationCode" flag="warning" id="EHF-T01-B14901">Element 'cbc:IdentificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode">
         <assert test="@listID" flag="warning" id="EHF-T01-B15001">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:RequestedDeliveryPeriod"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:RequestedDeliveryPeriod/cbc:StartDate"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:RequestedDeliveryPeriod/cbc:EndDate"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B15601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B15701">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty/cac:PartyName">
         <assert test="cbc:Name" flag="warning" id="EHF-T01-B15901">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty/cac:Contact">
         <assert test="cbc:ElectronicMail" flag="warning" id="EHF-T01-B16101">Element 'cbc:ElectronicMail' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty/cac:Contact/cbc:Name"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty/cac:Contact/cbc:Telephone"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty/cac:Contact/cbc:Telefax"/>
      <rule context="/ubl:Order/cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty/cac:Contact/cbc:ElectronicMail"/>
      <rule context="/ubl:Order/cac:DeliveryTerms"/>
      <rule context="/ubl:Order/cac:DeliveryTerms/cbc:ID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B16701">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:DeliveryTerms/cbc:SpecialTerms"/>
      <rule context="/ubl:Order/cac:DeliveryTerms/cac:DeliveryLocation"/>
      <rule context="/ubl:Order/cac:DeliveryTerms/cac:DeliveryLocation/cbc:ID"/>
      <rule context="/ubl:Order/cac:PaymentTerms"/>
      <rule context="/ubl:Order/cac:PaymentTerms/cbc:Note"/>
      <rule context="/ubl:Order/cac:AllowanceCharge">
         <assert test="cbc:ChargeIndicator" flag="warning" id="EHF-T01-B17401">Element 'cbc:ChargeIndicator' MUST be provided.</assert>
         <assert test="cbc:AllowanceChargeReason" flag="warning" id="EHF-T01-B17402">Element 'cbc:AllowanceChargeReason' MUST be provided.</assert>
         <assert test="cbc:Amount" flag="warning" id="EHF-T01-B17403">Element 'cbc:Amount' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AllowanceCharge/cbc:ChargeIndicator"/>
      <rule context="/ubl:Order/cac:AllowanceCharge/cbc:AllowanceChargeReason"/>
      <rule context="/ubl:Order/cac:AllowanceCharge/cbc:Amount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B17701">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:TaxTotal">
         <assert test="cbc:TaxAmount" flag="warning" id="EHF-T01-B17901">Element 'cbc:TaxAmount' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:TaxTotal/cbc:TaxAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B18001">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AnticipatedMonetaryTotal">
         <assert test="cbc:LineExtensionAmount" flag="warning" id="EHF-T01-B18201">Element 'cbc:LineExtensionAmount' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:LineExtensionAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B18301">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:TaxExclusionAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B18501">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:TaxInclusiveAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B18701">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:AllowanceTotalAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B18901">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:ChargeTotalAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B19101">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:PrepaidAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B19301">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:PayableRoundingAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B19501">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:AnticipatedMonetaryTotal/cbc:PayableAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B19701">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine">
         <assert test="cac:LineItem" flag="warning" id="EHF-T01-B19901">Element 'cac:LineItem' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cbc:Note"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B20101">Element 'cbc:ID' MUST be provided.</assert>
         <assert test="cbc:Quantity" flag="warning" id="EHF-T01-B20102">Element 'cbc:Quantity' MUST be provided.</assert>
         <assert test="cac:Item" flag="warning" id="EHF-T01-B20103">Element 'cac:Item' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:ID"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:Quantity">
         <assert test="@unitCode" flag="warning" id="EHF-T01-B20301">Attribute 'unitCode' MUST be present.</assert>
         <assert test="@unitCodeListID" flag="warning" id="EHF-T01-B20302">Attribute 'unitCodeListID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B20601">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:TotalTaxAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B20801">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cbc:PartialDeliveryIndicator"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartDate"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndDate"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B21601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification/cbc:ID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B21701">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyName">
         <assert test="cbc:Name" flag="warning" id="EHF-T01-B21901">Element 'cbc:Name' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyName/cbc:Name"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price">
         <assert test="cbc:PriceAmount" flag="warning" id="EHF-T01-B22101">Element 'cbc:PriceAmount' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cbc:PriceAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B22201">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cbc:BaseQuantity">
         <assert test="@unitCode" flag="warning" id="EHF-T01-B22401">Attribute 'unitCode' MUST be present.</assert>
         <assert test="@unitCodeListID" flag="warning" id="EHF-T01-B22402">Attribute 'unitCodeListID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge">
         <assert test="cbc:ChargeIndicator" flag="warning" id="EHF-T01-B22701">Element 'cbc:ChargeIndicator' MUST be provided.</assert>
         <assert test="cbc:Amount" flag="warning" id="EHF-T01-B22702">Element 'cbc:Amount' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:Amount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B22901">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:BaseAmount">
         <assert test="@currencyID" flag="warning" id="EHF-T01-B23101">Attribute 'currencyID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cbc:Description"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cbc:Name"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:SellerItemIdentification">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B23601">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:SellerItemIdentification/cbc:ID"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B23801">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B23901">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B24101">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification">
         <assert test="cbc:ItemClassificationCode"
                 flag="warning"
                 id="EHF-T01-B24301">Element 'cbc:ItemClassificationCode' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode">
         <assert test="@listID" flag="warning" id="EHF-T01-B24401">Attribute 'listID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory">
         <assert test="cac:TaxScheme" flag="warning" id="EHF-T01-B24601">Element 'cac:TaxScheme' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:ID">
         <assert test="@schemeID" flag="warning" id="EHF-T01-B24701">Attribute 'schemeID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme">
         <assert test="cbc:ID" flag="warning" id="EHF-T01-B25001">Element 'cbc:ID' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty">
         <assert test="cbc:Name" flag="warning" id="EHF-T01-B25201">Element 'cbc:Name' MUST be provided.</assert>
         <assert test="cbc:Value" flag="warning" id="EHF-T01-B25202">Element 'cbc:Value' MUST be provided.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:Name"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:Value"/>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cac:ValueQuantity">
         <assert test="@unitCode" flag="warning" id="EHF-T01-B25501">Attribute 'unitCode' MUST be present.</assert>
         <assert test="@unitCodeListID" flag="warning" id="EHF-T01-B25502">Attribute 'unitCodeListID' MUST be present.</assert>
      </rule>
      <rule context="/ubl:Order/cac:OrderLine/cac:LineItem/cac:Item/cbc:ValueQualifier"/>
   </pattern>
   <pattern>
      <rule context="/ubl:Order">
         <assert id="NOGOV-T01-R002"
                 test="cac:BuyerCustomerParty/cac:Party"
                 flag="fatal">[NOGOV-T01-R002]-An order MUST contain buyer information</assert>
         <assert id="NOGOV-T01-R018"
                 test="cac:SellerSupplierParty/cac:Party"
                 flag="fatal">[NOGOV-T01-R018]-An order MUST contain seller information</assert>
      </rule>
      <rule context="cac:LineItem">
         <assert id="NOGOV-T01-R005" test="cbc:Quantity" flag="fatal">[NOGOV-T01-R005]-An order line item MUST have a quantity</assert>
      </rule>
      <rule context="cac:BuyerCustomerParty">
         <assert id="NOGOV-T01-R001"
                 test="string-length(cac:Party/cac:Contact/cbc:ID) &gt;0"
                 flag="warning">[NOGOV-T01-R001]-Kundens referanse BØR fylles ut i henhold til norske krav -- Customer reference SHOULD have a value</assert>
      </rule>
      <rule context="cac:PartyLegalEntity/cbc:CompanyID[@schemeID]">
         <assert id="NOGOV-T01-R023" test="@schemeID = 'NO:ORGNR'" flag="warning">[NOGOV-T01-R023]-CompanyID for legal entity qualifier must have value 'NO:ORGNR' when provided.</assert>
      </rule>
      <rule context="cac:PartyTaxScheme/cbc:CompanyID[@schemeID]">
         <assert id="NOGOV-T01-R024" test="@schemeID = 'NO:VAT'" flag="warning">[NOGOV-T01-R024]-CompanyID for tax scheme qualifier must have value 'NO:VAT' when provided.</assert>
      </rule>
      <rule context="cac:Attachment/cac:ExternalReference">
         <assert id="NOGOV-T01-R013" test="cbc:URI" flag="fatal">[NOGOV-T01-R013]-URI MUST be specified when describing external reference documents.</assert>
      </rule>
      <rule context="cac:Contract">
         <assert id="NOGOV-T01-R014" test="cbc:ID" flag="fatal">[NOGOV-T01-R014]-Contract ID MUST be specified when referencing contracts.</assert>
      </rule>
      <rule context="cac:PartyTaxScheme">
         <assert id="NOGOV-T01-R016" test="cbc:CompanyID" flag="fatal">[NOGOV-T01-R016]-VAT identifier MUST be specified when VAT information is present</assert>
      </rule>
      <rule context="cac:TaxScheme">
         <assert id="NOGOV-T01-R017" test="cbc:ID" flag="fatal">[NOGOV-T01-R017]-Every tax scheme MUST be defined through an identifier.</assert>
      </rule>
      <rule context="cac:Country">
         <assert id="NOGOV-T01-R015" test="cbc:IdentificationCode" flag="fatal">[NOGOV-T01-R015]-Identification code MUST be specified when describing a country.</assert>
      </rule>
      <rule context="cac:OriginatorCustomerParty">
         <assert id="NOGOV-T01-R019" test="cac:Party" flag="fatal">[NOGOV-T01-R019]-If originator element is present, party must be specified</assert>
      </rule>
      <rule context="cac:AccountingCustomerParty">
         <assert id="NOGOV-T01-R020" test="cac:Party" flag="fatal">[NOGOV-T01-R020]-If invoicee element is present, party must be specified</assert>
      </rule>
      <rule context="cac:ClassifiedTaxCategory">
         <assert id="NOGOV-T01-R004" test="cbc:ID" flag="fatal">[NOGOV-T01-R004]-If classified tax category is present, VAT category code must be specified</assert>
      </rule>
      <rule context="cac:CommodityClassification">
         <assert id="NOGOV-T01-R003" test="cbc:ItemClassificationCode" flag="fatal">[NOGOV-T01-R003]-If product classification element is present, classification code must be specified</assert>
      </rule>
      <rule context="cbc:ProfileID">
         <assert id="EHFPROFILE-T01-R001"
                 test=". = 'urn:www.cenbii.eu:profile:bii28:ver2.0'"
                 flag="fatal">[EHFPROFILE-T01-R001]-An order must only be used in profile 28</assert>
      </rule>
   </pattern>

</schema>
