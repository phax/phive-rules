<?xml version="1.0" encoding="utf-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:pxc="urn:peppol:xslt:custom-function"
        queryBinding='xslt2'>
  <title>OpenPeppol AE TDD Schematron</title>

  <p id="about">
    These are the Schematron rules for the OpenPeppol AE TDD.

    Author:
      Philip Helger

    History
      v1.0.0
        2025-11-25, Philip Helger
        * Reworded the rules to use the business terms and not the technical terms
        * Separate rules for /TaxData/ReportingParty and /TaxData/ReceivingParty
        * Fixed an error in the participant ID regular expression (missing ^ and $)
        * Added check that ReceivingParty/EndpointID/@schemeID must be an SPIS (0242)
        * Added check that ReportersRepresentative/PartyIdentification/ID/@schemeID must be an SPIS (0242)
        * Added new checks that provided currencies are contained in the ISO 4217 code list
      v1.0.0-RC
        2025-09-23, Philip Helger
        * disallow MonetaryTotal/TaxInclusiveAmount
        * requiring MonetaryTotal/TaxExclusiveAmount to use document currency
        * removed CustomContent limit of 0..1
        * removed CustomContent ID uppercase requirement
  </p>

  <xsl:function name="pxc:genPath" as="xs:string">
    <xsl:param name="node" as="node()"/>
    <!--
      1. Iterate from root to passed node
      2a. Emits a /currentPath segment
         Adds [n] if there are other siblings with the same name (to make path unique)
      2b. Emits /@attrName 
      3. Join all nodes together without a separator
    -->
    <xsl:sequence select="
        string-join(for $ancestor in $node/ancestor-or-self::node()
                    return
                      if ($ancestor instance of element())
                      then concat('/',
                                  name($ancestor),
                                  if (   count($ancestor/preceding-sibling::*[name() = name($ancestor)]) > 0
                                      or count($ancestor/following-sibling::*[name() = name($ancestor)]) > 0)
                                  then concat('[', count($ancestor/preceding-sibling::*[name() = name($ancestor)]) + 1, ']')
                                  else ''
                                  )
                      else
                        if ($ancestor instance of attribute())
                        then concat('/@', name($ancestor))
                        else ''
                    , '')
    "/>
  </xsl:function>
    
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cec" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
  <ns prefix="pxs" uri="urn:peppol:schema:taxdata:1.0"/>
  <ns prefix="inv" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
  <ns prefix="cn"  uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
  <ns prefix="pxc" uri="urn:peppol:xslt:custom-function"/>
  
  <pattern id="default">
    <!-- Code lists -->
    <let name="cl_dtc" value="' S R W F '" />
    <let name="cl_ds" value="' D IP INP '" />
    <let name="cl_rr" value="' 01 02 '" />
    <let name="cl_currency" value="' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNH CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLE SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UYW UZS VES VED VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWG '" />
    <let name="regex_pidscheme" value="'^[0-9]{4}$'" />

    <!-- Root element -->
    <rule context="/pxs:TaxData">
      <let name="dtc" value="normalize-space(pxs:DocumentTypeCode)" />
      <let name="ds"  value="normalize-space(pxs:DocumentScope)" />
      <let name="rr"  value="normalize-space(pxs:ReporterRole)" />
      <let name="rtCount" value="count(pxs:ReportedTransaction)" />

      <!-- CustmizationID is mandatory per XSD -->
      <assert id="ibr-tdd-01" flag="fatal" test="normalize-space(cbc:CustomizationID) = 'urn:peppol:taxdata:ae-1'"
      >[ibr-tdd-01] The Specification identifier (tdt-001) ID MUST use the value 'urn:peppol:taxdata:ae-1'</assert>

      <!-- ProfileID is mandatory per XSD -->
      <assert id="ibr-tdd-02" flag="fatal" test="normalize-space(cbc:ProfileID) = 'urn:peppol:taxreporting'"
      >[ibr-tdd-02] The Business process type (tdt-002) MUST use the value 'urn:peppol:taxreporting'</assert>

      <!-- ID is not allowed in UAE -->
      <assert id="ibr-tdd-03" flag="fatal" test="not(exists(cbc:ID))"
      >[ibr-tdd-03] Only XML elements defined in this specification are allowed to be used</assert>

      <!-- cbc:IssueDate is mandatory according to the XSD -->
      <assert id="ibr-tdd-04" flag="fatal" test="string-length(normalize-space(cbc:IssueDate)) = 10"
      >[ibr-tdd-04] The Tax Data Document issue date (tdt-004) MUST NOT contain timezone information</assert>

      <!-- cbc:IssueTime is mandatory according to the XSD -->
      <assert id="ibr-tdd-05" flag="fatal" test="matches(normalize-space(cbc:IssueTime), '([+-]\d{2}:\d{2}|Z)$')"
      >[ibr-tdd-05] The Tax Data Document issue time (tdt-005) MUST contain timezone information</assert>
      
      <!-- DocumentTypeCode is mandatory according to the XSD -->
      <assert id="ibr-tdd-06" flag="fatal" test="not(contains($dtc, ' ')) and contains($cl_dtc, concat(' ', $dtc, ' '))"
      >[ibr-tdd-06] The Tax Data Document type code (tdt-006) (<value-of select="$dtc"/>) MUST be coded according to the code list</assert>
      
      <!-- DocumentScope is mandatory according to the XSD -->
      <assert id="ibr-tdd-07" flag="fatal" test="not(contains($ds, ' ')) and contains($cl_ds, concat(' ', $ds, ' '))"
      >[ibr-tdd-07] The Report scope (tdt-011) (<value-of select="$ds"/>) MUST be coded according to the code list</assert>
      
      <!-- ReporterRole is mandatory according to the XSD -->
      <assert id="ibr-tdd-08" flag="fatal" test="not(contains($rr, ' ')) and contains($cl_rr, concat(' ', $rr, ' '))"
      >[ibr-tdd-08] The Reporters role (tdt-010) (<value-of select="$rr"/>) MUST be coded according to the code list</assert>
      
      <!-- pxs:ReportedTransaction must be exactly 1 for UAE -->
      <assert id="ibr-tdd-09" flag="fatal" test="$rtCount = 1"
      >[ibr-tdd-09] Exactly one REPORTED TRANSACTION (tdg-001) MUST be present but found <value-of select="$rtCount" /> instead</assert>
    </rule>
    
    <!-- ReportingParty is mandatory in XSD -->
    <!-- This rule basically checks that only the cbc:EndpointID element is present -->
    <rule context="/pxs:TaxData/pxs:ReportingParty">
      <!-- elements not allowed in UAE -->
      <assert id="ibr-tdd-10" flag="fatal" test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'IndustryClassificationCode',
                                                                  'PartyIdentification', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyTaxScheme',
                                                                  'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount') 
                                                   satisfies count (*[local-name(.) = $child]) = 0"
      >[ibr-tdd-10] Only XML elements defined in this specification are allowed to be used</assert>
      
      <!-- EndpointID is mandatory in UAE -->
      <assert id="ibr-tdd-11" flag="fatal" test="exists(cbc:EndpointID)"
      >[ibr-tdd-11] Reporters Endpoint (tdt-007) MUST be present</assert>
      
      <!-- EndpointID must have a schemeID attribute mandatory in UAE -->
      <assert id="ibr-tdd-12" flag="fatal" test="exists(cbc:EndpointID/@schemeID)"
      >[ibr-tdd-12] Reporters Endpoint Scheme identifier (tdt-007-1) MUST be present</assert>
      
      <!-- EndpointID schemeID must be a Peppol Participant Identifier Scheme -->
      <assert id="ibr-tdd-13" flag="fatal" test="not(exists(cbc:EndpointID/@schemeID)) or matches(cbc:EndpointID/@schemeID, $regex_pidscheme)"
      >[ibr-tdd-13] Reporters Endpoint Scheme identifier (tdt-007-1) MUST be a Peppol Participant Identifier Scheme</assert>
    </rule>

    <!-- ReceivingParty is mandatory in XSD -->
    <!-- This rule basically checks that only the cbc:EndpointID element is present -->
    <rule context="/pxs:TaxData/pxs:ReceivingParty">
      <!-- elements not allowed in UAE -->
      <assert id="ibr-tdd-14" flag="fatal" test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'IndustryClassificationCode',
                                                                  'PartyIdentification', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyTaxScheme',
                                                                  'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount') 
                                                   satisfies count (*[local-name(.) = $child]) = 0"
      >[ibr-tdd-14] Only XML elements defined in this specification are allowed to be used</assert>
      
      <!-- EndpointID is mandatory in UAE -->
      <assert id="ibr-tdd-15" flag="fatal" test="exists(cbc:EndpointID)"
      >[ibr-tdd-15] Receivers Endpoint (tdt-008) MUST be present</assert>
      
      <!-- EndpointID must have a schemeID attribute mandatory in UAE -->
      <assert id="ibr-tdd-16" flag="fatal" test="exists(cbc:EndpointID/@schemeID)"
      >[ibr-tdd-16] Receivers Endpoint Scheme identifier (tdt-008-1) MUST be present</assert>
      
      <!-- EndpointID schemeID must be 0242 for SPIS -->
      <assert id="ibr-tdd-17" flag="fatal" test="not(exists(cbc:EndpointID/@schemeID)) or (cbc:EndpointID/@schemeID = '0242')"
      >[ibr-tdd-17] Receivers Endpoint Scheme identifier (tdt-008-1) MUST refer to an SPID</assert>
    </rule>
    
    <!-- ReportersRepresentative is mandatory in XSD -->
    <!-- This rule basically checks that only the cac:PartyIdentification element is present -->
    <rule context="/pxs:TaxData/pxs:ReportersRepresentative">
      <let name="pidCount" value="count(cac:PartyIdentification)" />

      <!-- elements not allowed in UAE -->
      <assert id="ibr-tdd-18" flag="fatal" test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'EndpointID', 'LogoReferenceID', 
                                                                  'IndustryClassificationCode', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyTaxScheme',
                                                                  'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount') 
                                                   satisfies count (*[local-name(.) = $child]) = 0"
      >[ibr-tdd-18] Only XML elements defined in this specification are allowed to be used</assert>
      
      <!-- PartyIdentification is mandatory in UAE -->
      <assert id="ibr-tdd-19" flag="fatal" test="$pidCount = 1"
      >[ibr-tdd-19] Exactly one Reporters Representative ID (tdt-009) MUST be present but found <value-of select="$pidCount"/> instead</assert>
    </rule>
    
    <rule context="/pxs:TaxData/pxs:ReportersRepresentative/cac:PartyIdentification">
      <!-- ID is the only element and it is mandatory -->

      <!-- PartyIdentification/ID schemeID is mandatory in UAE -->
      <assert id="ibr-tdd-20" flag="fatal" test="exists(cbc:ID/@schemeID)"
      >[ibr-tdd-20] Reporters Representative ID Scheme identifier (tdt-009-1) MUST be present</assert>
      
      <!-- PartyIdentification/ID schemeID must be 0242 for SPIS -->
      <assert id="ibr-tdd-21" flag="fatal" test="not(exists(cbc:ID/@schemeID)) or 
                                                 (cbc:ID/@schemeID = '0242')"
      >[ibr-tdd-21] Reporters Representative ID Scheme identifier (tdt-009-1) MUST refer to an SPID</assert>
    </rule>
    
    <rule context="/pxs:TaxData/pxs:ReportedTransaction">
      <let name="ccCount" value="count(pxs:CustomContent)" />
      
      <!-- pxs:TransportHeaderID is optional for UAE -->
    
      <!-- ReportedDocument is required for UAE -->
      <assert id="ibr-tdd-22" flag="fatal" test="exists(pxs:ReportedDocument)"
      >[ibr-tdd-22] The REPORTED DOCUMENT (tdg-02) MUST be present</assert>
    
      <!-- CustomContent can appear zero, one or more times -->

      <!-- SourceDocument is required for UAE -->
      <assert id="ibr-tdd-23" flag="fatal" test="exists(pxs:SourceDocument)"
      >[ibr-tdd-23] The SOURCE DOCUMENT (tdg-03) MUST be present</assert>
    </rule>
    
    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument">
      <let name="currentPath" value="pxc:genPath(.)" />
      <let name="has_dcc" value="exists(cbc:DocumentCurrencyCode)" />
      <let name="dcc" value="normalize-space(cbc:DocumentCurrencyCode)" />
      <let name="has_tcc" value="exists(cbc:TaxCurrencyCode)" />
      <let name="tcc" value="normalize-space(cbc:TaxCurrencyCode)" />
      <let name="currencyCount" value="if ($has_tcc) then (2) else (1)" />
      <let name="ttCount" value="count(cac:TaxTotal)" />
      <let name="mtCount" value="count(pxs:MonetaryTotal)" />
    
      <!-- CustomizationID is mandatory in UAE -->
      <assert id="ibr-tdd-24" flag="fatal" test="exists(cbc:CustomizationID)"
      >[ibr-tdd-24] The Specification identifier (ibt-024) MUST be present</assert>
      
      <!-- ProfileID is mandatory in UAE -->
      <assert id="ibr-tdd-25" flag="fatal" test="exists(cbc:ProfileID)"
      >[ibr-tdd-25] The Business process type (ibt-023) MUST be present</assert>
      
      <!-- ID is mandatory in UAE -->
      <assert id="ibr-tdd-26" flag="fatal" test="exists(cbc:ID)"
      >[ibr-tdd-26] The Invoice number (ibt-001) MUST be present</assert>
      
      <!-- UUID is mandatory in UAE -->
      <assert id="ibr-tdd-27" flag="fatal" test="exists(cbc:UUID)"
      >[ibr-tdd-27] The UUID (btae-07) MUST be present</assert>
      
      <!-- IssueDate is mandatory in UAE -->
      <assert id="ibr-tdd-28" flag="fatal" test="exists(cbc:IssueDate)"
      >[ibr-tdd-28] The Invoice issue date (ibt-002) MUST be present</assert>
      
      <!-- IssueTime (ibt-168) is optional in UAE -->
      
      <!-- DocumentTypeCode is mandatory in UAE -->
      <assert id="ibr-tdd-29" flag="fatal" test="exists(pxs:DocumentTypeCode)"
      >[ibr-tdd-29] The Invoice type code (ibt-003) element MUST be present</assert>
      
      <!-- DocumentCurrencyCode is mandatory in UAE -->
      <assert id="ibr-tdd-30" flag="fatal" test="exists(cbc:DocumentCurrencyCode)"
      >[ibr-tdd-30] The Document currency code (ibt-005) MUST be present</assert>
      
      <assert id="ibr-tdd-30-1" flag="fatal" test="not($has_dcc) or (not(contains($dcc, ' ')) and contains($cl_currency, concat(' ', $dcc, ' ')))"
      >[ibr-tdd-30-1] The Document currency code (idt-005) (<value-of select="$dcc"/>) MUST be coded according to the code list</assert>
      
      <!-- TaxCurrencyCode is optional in UAE -->

      <!-- If TaxCurrencyCode is present, it must be different from DocumentCurrencyCode -->
      <assert id="ibr-tdd-31" flag="fatal" test="not($has_tcc) or $dcc != $tcc"
      >[ibr-tdd-31] The Accounting currency code (ibt-006) (<value-of select="$tcc" />) MUST be different from Document currency code (ibt-005) (<value-of select="$dcc" />)</assert>

      <assert id="ibr-tdd-31-1" flag="fatal" test="not($has_tcc) or (not(contains($tcc, ' ')) and contains($cl_currency, concat(' ', $tcc, ' ')))"
      >[ibr-tdd-31-1] The Accounting currency code (idt-006) (<value-of select="$tcc"/>) MUST be coded according to the code list</assert>
      
      <!-- AccountingSupplierParty is mandatory in UAE -->
      <assert id="ibr-tdd-32" flag="fatal" test="exists(cac:AccountingSupplierParty)"
      >[ibr-tdd-32] The SELLER (ibg-04) MUST be present</assert>

      
      <!-- AccountingCustomerParty is mandatory in UAE -->
      <assert id="ibr-tdd-33" flag="fatal" test="exists(cac:AccountingCustomerParty)"
      >[ibr-tdd-33] The BUYER (ibg-07) MUST be present</assert>

      
      <!-- TaxTotal is mandatory in UAE -->
      <assert id="ibr-tdd-34" flag="fatal" test="$ttCount = $currencyCount"
      >[ibr-tdd-34] An Invoice total TAX amount (ibt-110, ibt-111) MUST be provided for each currency used</assert>

      <!-- TaxTotal in DocumentCurrency must be present -->
      <assert id="ibr-tdd-35" flag="fatal" test="count(cac:TaxTotal[cbc:TaxAmount/@currencyID = $dcc]) = 1"
      >[ibr-tdd-35] Exactly 1 Invoice total TAX amount (ibt-110) MUST be provided for Document currency code (ibt-005) (<value-of select="$dcc" />)</assert>

      <!-- If TaxCurrency is present, a TaxTotal in TaxCurrency must exist as well -->
      <assert id="ibr-tdd-36" flag="fatal" test="not($has_tcc) or count(cac:TaxTotal[cbc:TaxAmount/@currencyID = $tcc]) = 1"
      >[ibr-tdd-36] Exactly 1 Invoice total TAX amount (ibt-111) MUST be provided for Accounting currency code (ibt-006) (<value-of select="$tcc" />)</assert>

      
      <!-- MonetaryTotal in DocumentCurrency is mandatory for UAE -->
      <assert id="ibr-tdd-37" flag="fatal" test="$mtCount = 1"
      >[ibr-tdd-37] Exactly 1 <value-of select="$currentPath"/>/pxs:MonetaryTotal element must be present but found <value-of select="$mtCount" /> elements</assert>

      <!-- MonetaryTotal currency must be document currency -->
      <assert id="ibr-tdd-38" flag="fatal" test="$mtCount != 1 or count(pxs:MonetaryTotal[cbc:TaxExclusiveAmount/@currencyID = $dcc]) = 1"
      >[ibr-tdd-38] Exactly 1 <value-of select="$currentPath"/>/pxs:MonetaryTotal element with an amount using Document Currency <value-of select="$dcc" />  MUST be present</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty">
      <let name="currentPath" value="pxc:genPath(.)" />

      <!-- Make sure only Party is present in UAE -->
      <assert id="ibr-tdd-39" flag="fatal" test="every $child in ('CustomerAssignedAccountID', 'AdditionalAccountID', 'DataSendingCapability', 
                                                                  'DespatchContact', 'AccountingContact', 'SellerContact') 
                                                   satisfies count (*[local-name(.) = $child]) = 0"
      >[ibr-tdd-39] Only XML elements defined in this specification are allowed to be used</assert>

      <!-- Party is mandatory in UAE -->
      <assert id="ibr-tdd-40" flag="fatal" test="exists(cac:Party)"
      >[ibr-tdd-40] The <value-of select="$currentPath"/>/cac:Party element MUST be present</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party">
      <let name="currentPath" value="pxc:genPath(.)" />
      <let name="ptsCount" value="count(cac:PartyTaxScheme)" />

      <!-- Make sure only PartyTaxScheme is present in UAE -->
      <assert id="ibr-tdd-41" flag="fatal" test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'EndpointID',
                                                                  'IndustryClassificationCode', 'PartyIdentification', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation',
                                                                  'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount')
                                                   satisfies count (*[local-name(.) = $child]) = 0"
      >[ibr-tdd-41] Only XML elements defined in this specification are allowed to be used</assert>

      <!-- PartyTaxScheme is mandatory in UAE -->
      <assert id="ibr-tdd-42" flag="fatal" test="$ptsCount = 1"
      >[ibr-tdd-42] Exactly 1 <value-of select="$currentPath"/>/cac:PartyTaxScheme element MUST be present but found <value-of select="$ptsCount" /> elements</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme">
      <let name="isVATIN" value="normalize-space(cac:TaxScheme/cbc:ID) = 'VAT'" />
      <let name="btID"   value="if ($isVATIN) then ('ibt-031') else ('ibt-032')" />
      <let name="btName" value="if ($isVATIN) then ('Seller VAT identifier') else ('Seller tax registration identifier')" />
    
      <!-- Make sure only CompanyID and TaxScheme are present in UAE -->
      <assert id="ibr-tdd-43" flag="fatal" test="every $child in ('RegistrationName', 'TaxLevelCode', 'ExemptionReasonCode', 'ExemptionReason', 'RegistrationAddress')
                                                   satisfies count (*[local-name(.) = $child]) = 0"
      >[ibr-tdd-43] Only XML elements defined in this specification are allowed to be used</assert>

      <!-- CompanyID is mandatory in UAE -->
      <assert id="ibr-tdd-44" flag="fatal" test="exists(cbc:CompanyID)"
      >[ibr-tdd-44] The <value-of select="$btName"/> (<value-of select="$btID"/>) MUST be present</assert>

      <!-- TaxScheme is mandatory -->
      
      <!-- TaxScheme/ID is mandatory in UAE -->
      <assert id="ibr-tdd-45" flag="fatal" test="exists(cac:TaxScheme/cbc:ID)"
      >[ibr-tdd-45] The <value-of select="$btName"/> Tax scheme code (<value-of select="$btID"/>-1) MUST be present</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty">
      <let name="currentPath" value="pxc:genPath(.)" />

      <!-- Make sure only Party is present in UAE -->
      <assert id="ibr-tdd-46" flag="fatal" test="every $child in ('CustomerAssignedAccountID', 'SupplierAssignedAccountID', 'AdditionalAccountID', 
                                                                  'DeliveryContact', 'AccountingContact', 'BuyerContact') 
                                                   satisfies count (*[local-name(.) = $child]) = 0"
      >[ibr-tdd-46] Only XML elements defined in this specification are allowed to be used</assert>

      <!-- Party is mandatory in UAE -->
      <assert id="ibr-tdd-47" flag="fatal" test="exists(cac:Party)"
      >[ibr-tdd-47] The <value-of select="$currentPath"/>/cac:Party element MUST be present</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party">
      <!-- Make sure only PartyIdentification or PartyTaxScheme or present in UAE -->
      <assert id="ibr-tdd-48" flag="fatal" test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'EndpointID',
                                                                  'IndustryClassificationCode', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation',
                                                                  'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount')
                                                   satisfies count (*[local-name(.) = $child]) = 0"
      >[ibr-tdd-48] Only XML elements defined in this specification are allowed to be used</assert>

      <!-- both cac:PartyIdentification and cac:PartyTaxScheme are optional -->
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification">
      <!-- ID element is mandatory -->
      <!-- ID/schemeID attribute is optional -->
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme">
      <!-- Make sure only CompanyID and TaxScheme are present in UAE -->
      <assert id="ibr-tdd-49" flag="fatal" test="every $child in ('RegistrationName', 'TaxLevelCode', 'ExemptionReasonCode', 'ExemptionReason', 'RegistrationAddress')
                                                   satisfies count (*[local-name(.) = $child]) = 0"
      >[ibr-tdd-49] Only XML elements defined in this specification are allowed to be used</assert>

      <!-- CompanyID is mandatory in UAE -->
      <assert id="ibr-tdd-50" flag="fatal" test="exists(cbc:CompanyID)"
      >[ibr-tdd-50] The Buyer VAT identifier (ibt-048) MUST be present</assert>

      <!-- TaxScheme is mandatory -->
      <!-- TaxScheme/ID is optional -->
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal">
      <!-- Make sure only TaxAmount is present in UAE -->
      <assert id="ibr-tdd-51" flag="fatal" test="every $child in ('RoundingAmount', 'TaxEvidenceIndicator', 'TaxIncludedIndicator', 'TaxSubtotal') 
                                                   satisfies count (*[local-name(.) = $child]) = 0"
      >[ibr-tdd-51] Only XML elements defined in this specification are allowed to be used</assert>
      
      <!-- TaxAmount element is mandatory -->
    </rule>

    <!-- Make sure only TaxExclusiveAmount and PayableAmount are present -->
    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:MonetaryTotal">
      <let name="dc" value="normalize-space(../cbc:DocumentCurrencyCode)" />

      <!-- TaxExclusiveAmount is mandatory in UAE -->
      <assert id="ibr-tdd-52" flag="fatal" test="exists(cbc:TaxExclusiveAmount)"
      >[ibr-tdd-52] The Invoice total amount without VAT (ibt-109) element must be present</assert>

      <!-- TaxExclusiveAmount currency must be the document currency -->
      <assert id="ibr-tdd-53" flag="fatal" test="cbc:TaxExclusiveAmount/@currencyID = $dc"
      >[ibr-tdd-53] The Invoice total amount without VAT (ibt-109) currency must match the Document currency code (ibt-005) (<value-of select="$dc"/>)</assert>
      
      <!-- TaxInclusiveAmount is forbidden in UAE -->
      <assert id="ibr-tdd-54" flag="fatal" test="not(exists(cbc:TaxInclusiveAmount))"
      >[ibr-tdd-54] Only XML elements defined in this specification are allowed to be used</assert>
    </rule>
    
    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:CustomContent">
      <let name="currentPath" value="pxc:genPath(.)" />
      
      <!-- cbc:ID is mandatory in XSD -->
      <!-- No normalization of ID is needed; IDs MUST not be distinct! -->
      
      <!-- UAE only allows the simple cbc:Value element
           As the XSD uses "choice" the existance of Value implicitly forbids ExtensionContent element existance
      -->
      <assert id="ibr-tdd-55" flag="fatal" test="exists(cbc:Value)"
      >[ibr-tdd-55] The <value-of select="$currentPath"/> MUST use the simple cbc:Value element</assert>
    </rule>
    
    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:SourceDocument">
      <let name="currentPath" value="pxc:genPath(.)" />

      <!-- elements not allowed in UAE -->
      <assert id="ibr-tdd-56" flag="fatal" test="every $child in ('ID', 'Name', 'ExtensionAgencyID', 'ExtensionAgencyName', 'ExtensionVersionID', 'ExtensionAgencyURI',
                                                                  'ExtensionURI', 'ExtensionReasonCode', 'ExtensionReason') 
                                                   satisfies count (*[local-name(.) = $child]) = 0"
      >[ibr-tdd-56] Only XML elements defined in this specification are allowed to be used</assert>
      
      <!-- The element ExtensionContent is mandatory in XSD -->
    </rule>
    
    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:SourceDocument/cec:ExtensionContent">
      <!-- In UAE it must be UBL Invoice or UBL CreditNote -->
      <assert id="ibr-tdd-57" flag="fatal" test="exists(inv:Invoice) or exists(cn:CreditNote)"
      >[ibr-tdd-57] The Invoice XML (tdt-012) MUST contain either a UBL 2.1 Invoice or a UBL 2.1 Credit Note</assert>
    </rule>
  </pattern>
</schema>
