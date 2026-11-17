<?xml version="1.0" encoding="UTF-8"?><schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pxc="urn:peppol:xslt:custom-function" queryBinding="xslt2">
  <title>OpenPeppol AE TDD Schematron</title>

  <p id="about">
    These are the Schematron rules for the OpenPeppol AE TDD.

    Author:
      Philip Helger

    History
      v1.0.5
        2026-10-16, UAE Peppol Authority
        * ibr-tdd-03, -10, -14, -18, -39, -41, -43, -46, -48, -49, -51, -54, -56: messages now name the element path, the allowed child elements and the business terms (issue 242)
        * ibr-tdd-41 / ibr-tdd-48: cac:PartyLegalEntity is allowed in the Seller and Buyer party
        * ibr-tdd-42: the Seller tax identifier group may be omitted when the Invoice type code is 480 or 81, aligned with PINT AE rule ibr-134-ae (issues 250, 251)
        * ibr-tdd-42: the Seller tax identifier group may occur twice, once with tax scheme VAT (ibt-031) and once with another tax scheme (ibt-032), aligned with PINT AE rule ibr-178-ae (issue 250)
        * ibr-tdd-58 / ibr-tdd-59: new rules, Seller name (ibt-027) mandatory in cac:PartyLegalEntity/cbc:RegistrationName, no other element allowed in cac:PartyLegalEntity
        * ibr-tdd-60 / ibr-tdd-61: new rules, Buyer name (ibt-044) mandatory in cac:PartyLegalEntity/cbc:RegistrationName, no other element allowed in cac:PartyLegalEntity
        * ibr-tdd-30-1 / ibr-tdd-31-1: currency code list aligned with PINT AE Billing and Self-Billing (STN and XCG added; ANG, BGN and STD removed)
        * ibr-tdd-09: message refers to tdg-01 instead of tdg-001
        * ibr-tdd-44 / ibr-tdd-45: rule identifier in the message is written in lowercase
        * ibr-tdd-11, -12, -13, -15, -16, -17: messages use the term names Reporters electronic address (tdt-007) and Receivers electronic address (tdt-008)
        * ibr-tdd-01: the stray word "ID" is removed from the message
      v1.0.4
        2026-07-18, UAE Peppol Authority
        * ibr-tdd-17: schemeID attribute is now required to be present AND equal to '0242' (SPIS)
        * ibr-tdd-21: message clarified for the optional schemeID attribute ("if present")
        * ibr-tdd-22: renamed variable $checkForReportedDocument to $isFailedTransmission; message now states the 'F' (Failed transmission) exemption
        * ibr-tdd-33: added export exclusion aligned with PINT AE rule ibr-135-ae (BTAE-02 = XXXXXXX1)
        * ibr-tdd-40 / ibr-tdd-47: messages now name the business group and the concrete element path
        * ibr-tdd-44 / ibr-tdd-45: messages now open with a complete static sentence naming both candidate business terms and the element path
        * ibr-tdd-55: message now names the element and the supplied business term identifier and states that cec:ExtensionContent is not allowed
      v1.0.3
        2026-05-20, Georg Birgisson
        * Removed rule ibr-tdd-50, redundant
        * Corrected double negative in ibr-tdd-22
      v1.0.2
        2026-01-26, Philip Helger
        * Fixed the time regular expression check
      v1.0.1
        2025-12-22, Philip Helger
        * Removed the mandatory check for "pxs:ReportedDocument" in case of a failed TDD (TDS)
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
    
    <xsl:sequence select="         string-join(for $ancestor in $node/ancestor-or-self::node()                     return                       if ($ancestor instance of element())                       then concat('/',                                   name($ancestor),                                   if (   count($ancestor/preceding-sibling::*[name() = name($ancestor)]) &gt; 0                                       or count($ancestor/following-sibling::*[name() = name($ancestor)]) &gt; 0)                                   then concat('[', count($ancestor/preceding-sibling::*[name() = name($ancestor)]) + 1, ']')                                   else ''                                   )                       else                         if ($ancestor instance of attribute())                         then concat('/@', name($ancestor))                         else ''                     , '')     "/>
  </xsl:function>
    
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cec" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
  <ns prefix="pxs" uri="urn:peppol:schema:taxdata:1.0"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
  <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
  <ns prefix="pxc" uri="urn:peppol:xslt:custom-function"/>
  
  <pattern id="default">
    
    <let name="cl_dtc" value="' S R W F '"/>
    <let name="cl_ds" value="' D IP INP '"/>
    <let name="cl_rr" value="' 01 02 '"/>
    <let name="cl_currency" value="' AED AFN ALL AMD AOA ARS AUD AWG AZN BAM BBD BDT BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNH CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLE SOS SRD SSP STN SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UYW UZS VED VES VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XCG XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWG '"/>
    <let name="regex_pidscheme" value="'^[0-9]{4}$'"/>
    
    <let name="isFailedTransmission" value="normalize-space(/pxs:TaxData/pxs:DocumentTypeCode) = 'F'"/>

    
    <rule context="/pxs:TaxData">
      <let name="dtc" value="normalize-space(pxs:DocumentTypeCode)"/>
      <let name="ds" value="normalize-space(pxs:DocumentScope)"/>
      <let name="rr" value="normalize-space(pxs:ReporterRole)"/>
      <let name="rtCount" value="count(pxs:ReportedTransaction)"/>

      
      <assert id="ibr-tdd-01" flag="fatal" test="normalize-space(cbc:CustomizationID) = 'urn:peppol:taxdata:ae-1'">[ibr-tdd-01] The Specification identifier (tdt-001) MUST use the value 'urn:peppol:taxdata:ae-1'</assert>

      
      <assert id="ibr-tdd-02" flag="fatal" test="normalize-space(cbc:ProfileID) = 'urn:peppol:taxreporting'">[ibr-tdd-02] The Business process type (tdt-002) MUST use the value 'urn:peppol:taxreporting'</assert>

      
      <assert id="ibr-tdd-03" flag="fatal" test="not(exists(cbc:ID))">[ibr-tdd-03] The element cbc:ID MUST NOT be used in /pxs:TaxData. The UAE Tax Data Document has no Tax Data Document number</assert>

      
      <assert id="ibr-tdd-04" flag="fatal" test="string-length(normalize-space(cbc:IssueDate)) = 10">[ibr-tdd-04] The Tax Data Document issue date (tdt-004) MUST NOT contain timezone information</assert>

      
      <assert id="ibr-tdd-05" flag="fatal" test="matches(normalize-space(cbc:IssueTime), '^(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d(.\d{1,9})?(?:Z|[+-](?:0\d|1[0-4]):[0-5]\d)$')">[ibr-tdd-05] The Tax Data Document issue time (tdt-005) MUST contain timezone information</assert>
      
      
      <assert id="ibr-tdd-06" flag="fatal" test="not(contains($dtc, ' ')) and contains($cl_dtc, concat(' ', $dtc, ' '))">[ibr-tdd-06] The Tax Data Document type code (tdt-006) (<value-of select="$dtc"/>) MUST be coded according to the code list</assert>
      
      
      <assert id="ibr-tdd-07" flag="fatal" test="not(contains($ds, ' ')) and contains($cl_ds, concat(' ', $ds, ' '))">[ibr-tdd-07] The Report scope (tdt-011) (<value-of select="$ds"/>) MUST be coded according to the code list</assert>
      
      
      <assert id="ibr-tdd-08" flag="fatal" test="not(contains($rr, ' ')) and contains($cl_rr, concat(' ', $rr, ' '))">[ibr-tdd-08] The Reporters role (tdt-010) (<value-of select="$rr"/>) MUST be coded according to the code list</assert>
      
      
      <assert id="ibr-tdd-09" flag="fatal" test="$rtCount = 1">[ibr-tdd-09] Exactly one REPORTED TRANSACTION (tdg-01) MUST be present but found <value-of select="$rtCount"/> instead</assert>
    </rule>
    
    
    
    <rule context="/pxs:TaxData/pxs:ReportingParty">
      
      <assert id="ibr-tdd-10" flag="fatal" test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'IndustryClassificationCode',                                                                   'PartyIdentification', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyTaxScheme',                                                                   'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount')                                                     satisfies count (*[local-name(.) = $child]) = 0">[ibr-tdd-10] The element /pxs:TaxData/pxs:ReportingParty MUST contain only cbc:EndpointID, the Reporters electronic address (tdt-007). No other element is allowed</assert>
      
      
      <assert id="ibr-tdd-11" flag="fatal" test="exists(cbc:EndpointID)">[ibr-tdd-11] Reporters electronic address (tdt-007) MUST be present</assert>
      
      
      <assert id="ibr-tdd-12" flag="fatal" test="exists(cbc:EndpointID/@schemeID)">[ibr-tdd-12] Reporters electronic address Scheme identifier (tdt-007-1) MUST be present</assert>
      
      
      <assert id="ibr-tdd-13" flag="fatal" test="not(exists(cbc:EndpointID/@schemeID)) or matches(cbc:EndpointID/@schemeID, $regex_pidscheme)">[ibr-tdd-13] Reporters electronic address Scheme identifier (tdt-007-1) MUST be a Peppol Participant Identifier Scheme</assert>
    </rule>

    
    
    <rule context="/pxs:TaxData/pxs:ReceivingParty">
      
      <assert id="ibr-tdd-14" flag="fatal" test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'IndustryClassificationCode',                                                                   'PartyIdentification', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyTaxScheme',                                                                   'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount')                                                     satisfies count (*[local-name(.) = $child]) = 0">[ibr-tdd-14] The element /pxs:TaxData/pxs:ReceivingParty MUST contain only cbc:EndpointID, the Receivers electronic address (tdt-008). No other element is allowed</assert>
      
      
      <assert id="ibr-tdd-15" flag="fatal" test="exists(cbc:EndpointID)">[ibr-tdd-15] Receivers electronic address (tdt-008) MUST be present</assert>
      
      
      <assert id="ibr-tdd-16" flag="fatal" test="exists(cbc:EndpointID/@schemeID)">[ibr-tdd-16] Receivers electronic address Scheme identifier (tdt-008-1) MUST be present</assert>
      
      
      <assert id="ibr-tdd-17" flag="fatal" test="exists(cbc:EndpointID/@schemeID) and normalize-space(cbc:EndpointID/@schemeID) = '0242'">[ibr-tdd-17] Receivers electronic address Scheme identifier (tdt-008-1) MUST be present and MUST refer to an SPIS (0242)</assert>
    </rule>
    
    
    
    <rule context="/pxs:TaxData/pxs:ReportersRepresentative">
      <let name="pidCount" value="count(cac:PartyIdentification)"/>

      
      <assert id="ibr-tdd-18" flag="fatal" test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'EndpointID', 'LogoReferenceID',                                                                    'IndustryClassificationCode', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyTaxScheme',                                                                   'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount')                                                     satisfies count (*[local-name(.) = $child]) = 0">[ibr-tdd-18] The element /pxs:TaxData/pxs:ReportersRepresentative MUST contain only cac:PartyIdentification, the Reporters Representative ID (tdt-009). No other element is allowed</assert>
      
      
      <assert id="ibr-tdd-19" flag="fatal" test="$pidCount = 1">[ibr-tdd-19] Exactly one Reporters Representative ID (tdt-009) MUST be present but found <value-of select="$pidCount"/> instead</assert>
    </rule>
    
    <rule context="/pxs:TaxData/pxs:ReportersRepresentative/cac:PartyIdentification">
      

      
      <assert id="ibr-tdd-20" flag="fatal" test="exists(cbc:ID/@schemeID)">[ibr-tdd-20] Reporters Representative ID Scheme identifier (tdt-009-1) MUST be present</assert>
      
      
      <assert id="ibr-tdd-21" flag="fatal" test="not(exists(cbc:ID/@schemeID)) or                                                  (cbc:ID/@schemeID = '0242')">[ibr-tdd-21] Reporters Representative ID Scheme identifier (tdt-009-1), if present, MUST refer to an SPIS (0242)</assert>
    </rule>
    
    <rule context="/pxs:TaxData/pxs:ReportedTransaction">
      <let name="ccCount" value="count(pxs:CustomContent)"/>
      
      
    
      
      <assert id="ibr-tdd-22" flag="fatal" test="exists(pxs:ReportedDocument) or $isFailedTransmission">[ibr-tdd-22] The REPORTED DOCUMENT (tdg-02) MUST be present, except when the Tax Data Document type code (tdt-006) is 'F' (Failed transmission)</assert>
    
      

      
      <assert id="ibr-tdd-23" flag="fatal" test="exists(pxs:SourceDocument)">[ibr-tdd-23] The SOURCE DOCUMENT (tdg-03) MUST be present</assert>
    </rule>
    
    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument">
      <let name="currentPath" value="pxc:genPath(.)"/>
      <let name="has_dcc" value="exists(cbc:DocumentCurrencyCode)"/>
      <let name="dcc" value="normalize-space(cbc:DocumentCurrencyCode)"/>
      <let name="has_tcc" value="exists(cbc:TaxCurrencyCode)"/>
      <let name="tcc" value="normalize-space(cbc:TaxCurrencyCode)"/>
      <let name="currencyCount" value="if ($has_tcc) then (2) else (1)"/>
      <let name="ttCount" value="count(cac:TaxTotal)"/>
      <let name="mtCount" value="count(pxs:MonetaryTotal)"/>
    
      
      <assert id="ibr-tdd-24" flag="fatal" test="exists(cbc:CustomizationID)">[ibr-tdd-24] The Specification identifier (ibt-024) MUST be present</assert>
      
      
      <assert id="ibr-tdd-25" flag="fatal" test="exists(cbc:ProfileID)">[ibr-tdd-25] The Business process type (ibt-023) MUST be present</assert>
      
      
      <assert id="ibr-tdd-26" flag="fatal" test="exists(cbc:ID)">[ibr-tdd-26] The Invoice number (ibt-001) MUST be present</assert>
      
      
      <assert id="ibr-tdd-27" flag="fatal" test="exists(cbc:UUID)">[ibr-tdd-27] The UUID (btae-07) MUST be present</assert>
      
      
      <assert id="ibr-tdd-28" flag="fatal" test="exists(cbc:IssueDate)">[ibr-tdd-28] The Invoice issue date (ibt-002) MUST be present</assert>
      
      
      
      
      <assert id="ibr-tdd-29" flag="fatal" test="exists(pxs:DocumentTypeCode)">[ibr-tdd-29] The Invoice type code (ibt-003) element MUST be present</assert>
      
      
      <assert id="ibr-tdd-30" flag="fatal" test="exists(cbc:DocumentCurrencyCode)">[ibr-tdd-30] The Document currency code (ibt-005) MUST be present</assert>
      
      <assert id="ibr-tdd-30-1" flag="fatal" test="not($has_dcc) or (not(contains($dcc, ' ')) and contains($cl_currency, concat(' ', $dcc, ' ')))">[ibr-tdd-30-1] The Document currency code (ibt-005) (<value-of select="$dcc"/>) MUST be coded according to the code list</assert>
      
      

      
      <assert id="ibr-tdd-31" flag="fatal" test="not($has_tcc) or $dcc != $tcc">[ibr-tdd-31] The Accounting currency code (ibt-006) (<value-of select="$tcc"/>) MUST be different from Document currency code (ibt-005) (<value-of select="$dcc"/>)</assert>

      <assert id="ibr-tdd-31-1" flag="fatal" test="not($has_tcc) or (not(contains($tcc, ' ')) and contains($cl_currency, concat(' ', $tcc, ' ')))">[ibr-tdd-31-1] The Accounting currency code (ibt-006) (<value-of select="$tcc"/>) MUST be coded according to the code list</assert>
      
      
      <assert id="ibr-tdd-32" flag="fatal" test="exists(cac:AccountingSupplierParty)">[ibr-tdd-32] The SELLER (ibg-04) MUST be present</assert>

      
      
      <assert id="ibr-tdd-33" flag="fatal" test="exists(cac:AccountingCustomerParty) or matches(normalize-space(../pxs:SourceDocument/cec:ExtensionContent/*/cbc:ProfileExecutionID), '^[01]{7}1$')">[ibr-tdd-33] The BUYER (ibg-07) MUST be present when the Invoice transaction type code (BTAE-02) is other than XXXXXXX1 (Exports)</assert>

      
      
      <assert id="ibr-tdd-34" flag="fatal" test="$ttCount = $currencyCount">[ibr-tdd-34] An Invoice total TAX amount (ibt-110, ibt-111) MUST be provided for each currency used</assert>

      
      <assert id="ibr-tdd-35" flag="fatal" test="count(cac:TaxTotal[cbc:TaxAmount/@currencyID = $dcc]) = 1">[ibr-tdd-35] Exactly 1 Invoice total TAX amount (ibt-110) MUST be provided for Document currency code (ibt-005) (<value-of select="$dcc"/>)</assert>

      
      <assert id="ibr-tdd-36" flag="fatal" test="not($has_tcc) or count(cac:TaxTotal[cbc:TaxAmount/@currencyID = $tcc]) = 1">[ibr-tdd-36] Exactly 1 Invoice total TAX amount (ibt-111) MUST be provided for Accounting currency code (ibt-006) (<value-of select="$tcc"/>)</assert>

      
      
      <assert id="ibr-tdd-37" flag="fatal" test="$mtCount = 1">[ibr-tdd-37] Exactly 1 <value-of select="$currentPath"/>/pxs:MonetaryTotal element must be present but found <value-of select="$mtCount"/> elements</assert>

      
      <assert id="ibr-tdd-38" flag="fatal" test="$mtCount != 1 or count(pxs:MonetaryTotal[cbc:TaxExclusiveAmount/@currencyID = $dcc]) = 1">[ibr-tdd-38] Exactly 1 <value-of select="$currentPath"/>/pxs:MonetaryTotal element with an amount using Document Currency <value-of select="$dcc"/>  MUST be present</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty">
      
      <assert id="ibr-tdd-39" flag="fatal" test="every $child in ('CustomerAssignedAccountID', 'AdditionalAccountID', 'DataSendingCapability',                                                                    'DespatchContact', 'AccountingContact', 'SellerContact')                                                     satisfies count (*[local-name(.) = $child]) = 0">[ibr-tdd-39] The SELLER (ibg-04) element /pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty MUST contain only cac:Party. No other element is allowed</assert>

      
      <assert id="ibr-tdd-40" flag="fatal" test="exists(cac:Party)">[ibr-tdd-40] The SELLER (ibg-04) PARTY DETAILS element (cac:AccountingSupplierParty/cac:Party) MUST be present</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party">
      <let name="currentPath" value="pxc:genPath(.)"/>
      <let name="ptsCount" value="count(cac:PartyTaxScheme)"/>

      <let name="isOutOfScope" value="some $c in ../../pxs:DocumentTypeCode satisfies normalize-space($c) = ('480', '81')"/>

      
      <assert id="ibr-tdd-41" flag="fatal" test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'EndpointID',                                                                   'IndustryClassificationCode', 'PartyIdentification', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation',                                                                   'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount')                                                    satisfies count (*[local-name(.) = $child]) = 0">[ibr-tdd-41] The SELLER (ibg-04) element /pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party MUST contain only cac:PartyTaxScheme (ibt-031, ibt-032) and cac:PartyLegalEntity (ibt-027). No other element is allowed</assert>

      
      <assert id="ibr-tdd-42" flag="fatal" test="$ptsCount = 1 or ($ptsCount = 2 and count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']) = 1) or ($ptsCount = 0 and $isOutOfScope)">[ibr-tdd-42] The Seller tax identifier group (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme) MUST be present once, or twice when one group has the tax scheme VAT (ibt-031) and the other group has another tax scheme (ibt-032). It may be omitted when the Invoice type code (ibt-003) is 'Out of scope of VAT' (480) or 'Credit note related to goods or services' (81). Found <value-of select="$ptsCount"/> in <value-of select="$currentPath"/></assert>

      
      <assert id="ibr-tdd-58" flag="fatal" test="count(cac:PartyLegalEntity) = 1 and count(cac:PartyLegalEntity/cbc:RegistrationName) = 1 and normalize-space((cac:PartyLegalEntity/cbc:RegistrationName)[1]) != ''">[ibr-tdd-58] The Seller name (ibt-027) MUST be present exactly once in /pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity">
      
      <assert id="ibr-tdd-59" flag="fatal" test="count(*[not(self::cbc:RegistrationName)]) = 0">[ibr-tdd-59] The element /pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity MUST contain only cbc:RegistrationName, the Seller name (ibt-027). No other element is allowed</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme">
      <let name="isVATIN" value="normalize-space(cac:TaxScheme/cbc:ID) = 'VAT'"/>
      <let name="btID" value="if ($isVATIN) then ('ibt-031') else ('ibt-032')"/>
      <let name="btName" value="if ($isVATIN) then ('Seller VAT identifier') else ('Seller tax registration identifier')"/>
    
      
      <assert id="ibr-tdd-43" flag="fatal" test="every $child in ('RegistrationName', 'TaxLevelCode', 'ExemptionReasonCode', 'ExemptionReason', 'RegistrationAddress')                                                    satisfies count (*[local-name(.) = $child]) = 0">[ibr-tdd-43] The element /pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme MUST contain only cbc:CompanyID (ibt-031 or ibt-032) and cac:TaxScheme, which carries the Tax scheme code in cbc:ID (ibt-031-1 for the Seller VAT identifier). No other element is allowed</assert>

      
      <assert id="ibr-tdd-44" flag="fatal" test="exists(cbc:CompanyID)">[ibr-tdd-44] The cbc:CompanyID element MUST be present in cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme. Depending on the value of cac:TaxScheme/cbc:ID, this element represents either the Seller VAT identifier (IBT-031) when the tax scheme code is VAT, or the Seller tax registration identifier (IBT-032) for any other tax scheme code</assert>

      
      
      
      <assert id="ibr-tdd-45" flag="fatal" test="exists(cac:TaxScheme/cbc:ID)">[ibr-tdd-45] The cac:TaxScheme/cbc:ID element MUST be present in cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme. A value of VAT identifies the associated cbc:CompanyID as IBT-031 (Seller VAT identifier); any other value identifies it as IBT-032 (Seller tax registration identifier)</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty">
      
      <assert id="ibr-tdd-46" flag="fatal" test="every $child in ('CustomerAssignedAccountID', 'SupplierAssignedAccountID', 'AdditionalAccountID',                                                                    'DeliveryContact', 'AccountingContact', 'BuyerContact')                                                     satisfies count (*[local-name(.) = $child]) = 0">[ibr-tdd-46] The BUYER (ibg-07) element /pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty MUST contain only cac:Party. No other element is allowed</assert>

      
      <assert id="ibr-tdd-47" flag="fatal" test="exists(cac:Party)">[ibr-tdd-47] The BUYER (ibg-07) PARTY DETAILS element (cac:AccountingCustomerParty/cac:Party) MUST be present</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party">
      
      <assert id="ibr-tdd-48" flag="fatal" test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'EndpointID',                                                                   'IndustryClassificationCode', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation',                                                                   'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount')                                                    satisfies count (*[local-name(.) = $child]) = 0">[ibr-tdd-48] The BUYER (ibg-07) element /pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party MUST contain only cac:PartyIdentification (ibt-046), cac:PartyTaxScheme (ibt-048) and cac:PartyLegalEntity (ibt-044). No other element is allowed</assert>

      

      
      <assert id="ibr-tdd-60" flag="fatal" test="count(cac:PartyLegalEntity) = 1 and count(cac:PartyLegalEntity/cbc:RegistrationName) = 1 and normalize-space((cac:PartyLegalEntity/cbc:RegistrationName)[1]) != ''">[ibr-tdd-60] The Buyer name (ibt-044) MUST be present exactly once in /pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity">
      
      <assert id="ibr-tdd-61" flag="fatal" test="count(*[not(self::cbc:RegistrationName)]) = 0">[ibr-tdd-61] The element /pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity MUST contain only cbc:RegistrationName, the Buyer name (ibt-044). No other element is allowed</assert>
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification">
      
      
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme">
      
      <assert id="ibr-tdd-49" flag="fatal" test="every $child in ('RegistrationName', 'TaxLevelCode', 'ExemptionReasonCode', 'ExemptionReason', 'RegistrationAddress')                                                    satisfies count (*[local-name(.) = $child]) = 0">[ibr-tdd-49] The element /pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme MUST contain only cbc:CompanyID (ibt-048) and cac:TaxScheme, which carries the Tax scheme code (ibt-048-1) in cbc:ID. No other element is allowed</assert>

      


      
      
    </rule>

    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal">
      
      <assert id="ibr-tdd-51" flag="fatal" test="every $child in ('RoundingAmount', 'TaxEvidenceIndicator', 'TaxIncludedIndicator', 'TaxSubtotal')                                                     satisfies count (*[local-name(.) = $child]) = 0">[ibr-tdd-51] The element /pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal MUST contain only cbc:TaxAmount (ibt-110 or ibt-111). No other element is allowed</assert>
      
      
    </rule>

    
    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:MonetaryTotal">
      <let name="dc" value="normalize-space(../cbc:DocumentCurrencyCode)"/>

      
      <assert id="ibr-tdd-52" flag="fatal" test="exists(cbc:TaxExclusiveAmount)">[ibr-tdd-52] The Invoice total amount without VAT (ibt-109) element must be present</assert>

      
      <assert id="ibr-tdd-53" flag="fatal" test="cbc:TaxExclusiveAmount/@currencyID = $dc">[ibr-tdd-53] The Invoice total amount without VAT (ibt-109) currency must match the Document currency code (ibt-005) (<value-of select="$dc"/>)</assert>
      
      
      <assert id="ibr-tdd-54" flag="fatal" test="not(exists(cbc:TaxInclusiveAmount))">[ibr-tdd-54] The element cbc:TaxInclusiveAmount MUST NOT be used in /pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:MonetaryTotal. Only cbc:TaxExclusiveAmount, the Invoice total amount without VAT (ibt-109), is allowed</assert>
    </rule>
    
    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:CustomContent">
      
      

      
      <assert id="ibr-tdd-55" flag="fatal" test="exists(cbc:Value)">[ibr-tdd-55] The CUSTOM CONTENT (pxs:CustomContent) for the Invoice (or CreditNote) total amount with VAT in AED (BTAE-20) MUST contain the cbc:Value element (pxs:CustomContent/cbc:Value)</assert>
    </rule>
    
    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:SourceDocument">
      <let name="currentPath" value="pxc:genPath(.)"/>

      
      <assert id="ibr-tdd-56" flag="fatal" test="every $child in ('ID', 'Name', 'ExtensionAgencyID', 'ExtensionAgencyName', 'ExtensionVersionID', 'ExtensionAgencyURI',                                                                   'ExtensionURI', 'ExtensionReasonCode', 'ExtensionReason')                                                     satisfies count (*[local-name(.) = $child]) = 0">[ibr-tdd-56] The SOURCE DOCUMENT (tdg-03) element /pxs:TaxData/pxs:ReportedTransaction/pxs:SourceDocument MUST contain only cec:ExtensionContent, the Invoice XML (tdt-012). No other element is allowed</assert>
      
      
    </rule>
    
    <rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:SourceDocument/cec:ExtensionContent">
      
      <assert id="ibr-tdd-57" flag="fatal" test="exists(ubl:Invoice) or exists(cn:CreditNote)">[ibr-tdd-57] The Invoice XML (tdt-012) MUST contain either a UBL 2.1 Invoice or a UBL 2.1 Credit Note</assert>
    </rule>
  </pattern>
</schema>