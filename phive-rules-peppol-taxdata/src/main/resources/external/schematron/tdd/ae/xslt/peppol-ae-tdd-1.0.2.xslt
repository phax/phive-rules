<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cec="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:inv="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:pxc="urn:peppol:xslt:custom-function" xmlns:pxs="urn:peppol:schema:taxdata:1.0" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

<xsl:param name="archiveDirParameter" />
  <xsl:param name="archiveNameParameter" />
  <xsl:param name="fileNameParameter" />
  <xsl:param name="fileDirParameter" />
  <xsl:variable name="document-uri">
    <xsl:value-of select="document-uri(/)" />
  </xsl:variable>

<!--PHASES-->


<!--PROLOG-->
<xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" />

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->
<xsl:function as="xs:string" name="pxc:genPath">
    <xsl:param as="node()" name="node" />
    
    <xsl:sequence select="         string-join(for $ancestor in $node/ancestor-or-self::node()                     return                       if ($ancestor instance of element())                       then concat('/',                                   name($ancestor),                                   if (   count($ancestor/preceding-sibling::*[name() = name($ancestor)]) > 0                                       or count($ancestor/following-sibling::*[name() = name($ancestor)]) > 0)                                   then concat('[', count($ancestor/preceding-sibling::*[name() = name($ancestor)]) + 1, ']')                                   else ''                                   )                       else                         if ($ancestor instance of attribute())                         then concat('/@', name($ancestor))                         else ''                     , '')     " />
  </xsl:function>

<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="." />
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">
        <xsl:value-of select="name()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*:</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>[namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])" />
    <xsl:text>[</xsl:text>
    <xsl:value-of select="1+ $preceding" />
    <xsl:text>]</xsl:text>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()" />
</xsl:when>
      <xsl:otherwise>
        <xsl:text>@*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>' and namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="parent::*">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path" />
  <xsl:template match="text()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')" />
  </xsl:template>
  <xsl:template match="comment()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')" />
  </xsl:template>
  <xsl:template match="processing-instruction()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.@', name())" />
  </xsl:template>
  <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:text>.</xsl:text>
    <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')" />
  </xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
  <xsl:template match="*" mode="generate-id-2" priority="2">
    <xsl:text>U</xsl:text>
    <xsl:number count="*" level="multiple" />
  </xsl:template>
  <xsl:template match="node()" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>n</xsl:text>
    <xsl:number count="node()" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="string-length(local-name(.))" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="translate(name(),':','.')" />
  </xsl:template>
<!--Strip characters-->  <xsl:template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<xsl:template match="/">
    <svrl:schematron-output schemaVersion="" title="OpenPeppol AE TDD Schematron">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:text>
    These are the Schematron rules for the OpenPeppol AE TDD.

    Author:
      Philip Helger

    History
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
  </svrl:text>
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cec" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="pxs" uri="urn:peppol:schema:taxdata:1.0" />
      <svrl:ns-prefix-in-attribute-values prefix="inv" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
      <svrl:ns-prefix-in-attribute-values prefix="pxc" uri="urn:peppol:xslt:custom-function" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">default</xsl:attribute>
        <xsl:attribute name="name">default</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M10" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>OpenPeppol AE TDD Schematron</svrl:text>

<!--PATTERN default-->
<xsl:variable name="cl_dtc" select="' S R W F '" />
  <xsl:variable name="cl_ds" select="' D IP INP '" />
  <xsl:variable name="cl_rr" select="' 01 02 '" />
  <xsl:variable name="cl_currency" select="' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNH CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLE SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UYW UZS VES VED VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWG '" />
  <xsl:variable name="regex_pidscheme" select="'^[0-9]{4}$'" />
  <xsl:variable name="checkForReportedDocument" select="normalize-space(/pxs:TaxData/pxs:DocumentTypeCode) != 'F'" />

	<!--RULE -->
<xsl:template match="/pxs:TaxData" mode="M10" priority="1018">
    <svrl:fired-rule context="/pxs:TaxData" />
    <xsl:variable name="dtc" select="normalize-space(pxs:DocumentTypeCode)" />
    <xsl:variable name="ds" select="normalize-space(pxs:DocumentScope)" />
    <xsl:variable name="rr" select="normalize-space(pxs:ReporterRole)" />
    <xsl:variable name="rtCount" select="count(pxs:ReportedTransaction)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CustomizationID) = 'urn:peppol:taxdata:ae-1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CustomizationID) = 'urn:peppol:taxdata:ae-1'">
          <xsl:attribute name="id">ibr-tdd-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-01] The Specification identifier (tdt-001) ID MUST use the value 'urn:peppol:taxdata:ae-1'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ProfileID) = 'urn:peppol:taxreporting'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ProfileID) = 'urn:peppol:taxreporting'">
          <xsl:attribute name="id">ibr-tdd-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-02] The Business process type (tdt-002) MUST use the value 'urn:peppol:taxreporting'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cbc:ID))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cbc:ID))">
          <xsl:attribute name="id">ibr-tdd-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-03] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:IssueDate)) = 10" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:IssueDate)) = 10">
          <xsl:attribute name="id">ibr-tdd-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-04] The Tax Data Document issue date (tdt-004) MUST NOT contain timezone information</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(cbc:IssueTime), '^(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d(.\d{1,9})?(?:Z|[+-](?:0\d|1[0-4]):[0-5]\d)$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(cbc:IssueTime), '^(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d(.\d{1,9})?(?:Z|[+-](?:0\d|1[0-4]):[0-5]\d)$')">
          <xsl:attribute name="id">ibr-tdd-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-05] The Tax Data Document issue time (tdt-005) MUST contain timezone information</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains($dtc, ' ')) and contains($cl_dtc, concat(' ', $dtc, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains($dtc, ' ')) and contains($cl_dtc, concat(' ', $dtc, ' '))">
          <xsl:attribute name="id">ibr-tdd-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-06] The Tax Data Document type code (tdt-006) (<xsl:text />
            <xsl:value-of select="$dtc" />
            <xsl:text />) MUST be coded according to the code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains($ds, ' ')) and contains($cl_ds, concat(' ', $ds, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains($ds, ' ')) and contains($cl_ds, concat(' ', $ds, ' '))">
          <xsl:attribute name="id">ibr-tdd-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-07] The Report scope (tdt-011) (<xsl:text />
            <xsl:value-of select="$ds" />
            <xsl:text />) MUST be coded according to the code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains($rr, ' ')) and contains($cl_rr, concat(' ', $rr, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains($rr, ' ')) and contains($cl_rr, concat(' ', $rr, ' '))">
          <xsl:attribute name="id">ibr-tdd-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-08] The Reporters role (tdt-010) (<xsl:text />
            <xsl:value-of select="$rr" />
            <xsl:text />) MUST be coded according to the code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$rtCount = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="$rtCount = 1">
          <xsl:attribute name="id">ibr-tdd-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-09] Exactly one REPORTED TRANSACTION (tdg-001) MUST be present but found <xsl:text />
            <xsl:value-of select="$rtCount" />
            <xsl:text /> instead</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportingParty" mode="M10" priority="1017">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportingParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'IndustryClassificationCode',                                                                   'PartyIdentification', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyTaxScheme',                                                                   'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount')                                                     satisfies count (*[local-name(.) = $child]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'IndustryClassificationCode', 'PartyIdentification', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyTaxScheme', 'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount') satisfies count (*[local-name(.) = $child]) = 0">
          <xsl:attribute name="id">ibr-tdd-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-10] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:EndpointID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:EndpointID)">
          <xsl:attribute name="id">ibr-tdd-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-11] Reporters Endpoint (tdt-007) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:EndpointID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:EndpointID/@schemeID)">
          <xsl:attribute name="id">ibr-tdd-12</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-12] Reporters Endpoint Scheme identifier (tdt-007-1) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cbc:EndpointID/@schemeID)) or matches(cbc:EndpointID/@schemeID, $regex_pidscheme)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cbc:EndpointID/@schemeID)) or matches(cbc:EndpointID/@schemeID, $regex_pidscheme)">
          <xsl:attribute name="id">ibr-tdd-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-13] Reporters Endpoint Scheme identifier (tdt-007-1) MUST be a Peppol Participant Identifier Scheme</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReceivingParty" mode="M10" priority="1016">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReceivingParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'IndustryClassificationCode',                                                                   'PartyIdentification', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyTaxScheme',                                                                   'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount')                                                     satisfies count (*[local-name(.) = $child]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'IndustryClassificationCode', 'PartyIdentification', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyTaxScheme', 'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount') satisfies count (*[local-name(.) = $child]) = 0">
          <xsl:attribute name="id">ibr-tdd-14</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-14] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:EndpointID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:EndpointID)">
          <xsl:attribute name="id">ibr-tdd-15</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-15] Receivers Endpoint (tdt-008) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:EndpointID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:EndpointID/@schemeID)">
          <xsl:attribute name="id">ibr-tdd-16</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-16] Receivers Endpoint Scheme identifier (tdt-008-1) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cbc:EndpointID/@schemeID)) or (cbc:EndpointID/@schemeID = '0242')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cbc:EndpointID/@schemeID)) or (cbc:EndpointID/@schemeID = '0242')">
          <xsl:attribute name="id">ibr-tdd-17</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-17] Receivers Endpoint Scheme identifier (tdt-008-1) MUST refer to an SPID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportersRepresentative" mode="M10" priority="1015">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportersRepresentative" />
    <xsl:variable name="pidCount" select="count(cac:PartyIdentification)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'EndpointID', 'LogoReferenceID',                                                                    'IndustryClassificationCode', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyTaxScheme',                                                                   'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount')                                                     satisfies count (*[local-name(.) = $child]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'EndpointID', 'LogoReferenceID', 'IndustryClassificationCode', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyTaxScheme', 'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount') satisfies count (*[local-name(.) = $child]) = 0">
          <xsl:attribute name="id">ibr-tdd-18</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-18] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$pidCount = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="$pidCount = 1">
          <xsl:attribute name="id">ibr-tdd-19</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-19] Exactly one Reporters Representative ID (tdt-009) MUST be present but found <xsl:text />
            <xsl:value-of select="$pidCount" />
            <xsl:text /> instead</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportersRepresentative/cac:PartyIdentification" mode="M10" priority="1014">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportersRepresentative/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:ID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:ID/@schemeID)">
          <xsl:attribute name="id">ibr-tdd-20</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-20] Reporters Representative ID Scheme identifier (tdt-009-1) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cbc:ID/@schemeID)) or                                                   (cbc:ID/@schemeID = '0242')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cbc:ID/@schemeID)) or (cbc:ID/@schemeID = '0242')">
          <xsl:attribute name="id">ibr-tdd-21</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-21] Reporters Representative ID Scheme identifier (tdt-009-1) MUST refer to an SPID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction" mode="M10" priority="1013">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction" />
    <xsl:variable name="ccCount" select="count(pxs:CustomContent)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(pxs:ReportedDocument) or not($checkForReportedDocument)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(pxs:ReportedDocument) or not($checkForReportedDocument)">
          <xsl:attribute name="id">ibr-tdd-22</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-22] The REPORTED DOCUMENT (tdg-02) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(pxs:SourceDocument)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(pxs:SourceDocument)">
          <xsl:attribute name="id">ibr-tdd-23</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-23] The SOURCE DOCUMENT (tdg-03) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument" mode="M10" priority="1012">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument" />
    <xsl:variable name="currentPath" select="pxc:genPath(.)" />
    <xsl:variable name="has_dcc" select="exists(cbc:DocumentCurrencyCode)" />
    <xsl:variable name="dcc" select="normalize-space(cbc:DocumentCurrencyCode)" />
    <xsl:variable name="has_tcc" select="exists(cbc:TaxCurrencyCode)" />
    <xsl:variable name="tcc" select="normalize-space(cbc:TaxCurrencyCode)" />
    <xsl:variable name="currencyCount" select="if ($has_tcc) then (2) else (1)" />
    <xsl:variable name="ttCount" select="count(cac:TaxTotal)" />
    <xsl:variable name="mtCount" select="count(pxs:MonetaryTotal)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:CustomizationID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:CustomizationID)">
          <xsl:attribute name="id">ibr-tdd-24</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-24] The Specification identifier (ibt-024) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:ProfileID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:ProfileID)">
          <xsl:attribute name="id">ibr-tdd-25</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-25] The Business process type (ibt-023) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:ID)">
          <xsl:attribute name="id">ibr-tdd-26</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-26] The Invoice number (ibt-001) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:UUID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:UUID)">
          <xsl:attribute name="id">ibr-tdd-27</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-27] The UUID (btae-07) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:IssueDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:IssueDate)">
          <xsl:attribute name="id">ibr-tdd-28</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-28] The Invoice issue date (ibt-002) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(pxs:DocumentTypeCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(pxs:DocumentTypeCode)">
          <xsl:attribute name="id">ibr-tdd-29</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-29] The Invoice type code (ibt-003) element MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:DocumentCurrencyCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:DocumentCurrencyCode)">
          <xsl:attribute name="id">ibr-tdd-30</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-30] The Document currency code (ibt-005) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($has_dcc) or (not(contains($dcc, ' ')) and contains($cl_currency, concat(' ', $dcc, ' ')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($has_dcc) or (not(contains($dcc, ' ')) and contains($cl_currency, concat(' ', $dcc, ' ')))">
          <xsl:attribute name="id">ibr-tdd-30-1</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-30-1] The Document currency code (idt-005) (<xsl:text />
            <xsl:value-of select="$dcc" />
            <xsl:text />) MUST be coded according to the code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($has_tcc) or $dcc != $tcc" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($has_tcc) or $dcc != $tcc">
          <xsl:attribute name="id">ibr-tdd-31</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-31] The Accounting currency code (ibt-006) (<xsl:text />
            <xsl:value-of select="$tcc" />
            <xsl:text />) MUST be different from Document currency code (ibt-005) (<xsl:text />
            <xsl:value-of select="$dcc" />
            <xsl:text />)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($has_tcc) or (not(contains($tcc, ' ')) and contains($cl_currency, concat(' ', $tcc, ' ')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($has_tcc) or (not(contains($tcc, ' ')) and contains($cl_currency, concat(' ', $tcc, ' ')))">
          <xsl:attribute name="id">ibr-tdd-31-1</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-31-1] The Accounting currency code (idt-006) (<xsl:text />
            <xsl:value-of select="$tcc" />
            <xsl:text />) MUST be coded according to the code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingSupplierParty)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingSupplierParty)">
          <xsl:attribute name="id">ibr-tdd-32</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-32] The SELLER (ibg-04) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingCustomerParty)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingCustomerParty)">
          <xsl:attribute name="id">ibr-tdd-33</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-33] The BUYER (ibg-07) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$ttCount = $currencyCount" />
      <xsl:otherwise>
        <svrl:failed-assert test="$ttCount = $currencyCount">
          <xsl:attribute name="id">ibr-tdd-34</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-34] An Invoice total TAX amount (ibt-110, ibt-111) MUST be provided for each currency used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:TaxTotal[cbc:TaxAmount/@currencyID = $dcc]) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:TaxTotal[cbc:TaxAmount/@currencyID = $dcc]) = 1">
          <xsl:attribute name="id">ibr-tdd-35</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-35] Exactly 1 Invoice total TAX amount (ibt-110) MUST be provided for Document currency code (ibt-005) (<xsl:text />
            <xsl:value-of select="$dcc" />
            <xsl:text />)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($has_tcc) or count(cac:TaxTotal[cbc:TaxAmount/@currencyID = $tcc]) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($has_tcc) or count(cac:TaxTotal[cbc:TaxAmount/@currencyID = $tcc]) = 1">
          <xsl:attribute name="id">ibr-tdd-36</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-36] Exactly 1 Invoice total TAX amount (ibt-111) MUST be provided for Accounting currency code (ibt-006) (<xsl:text />
            <xsl:value-of select="$tcc" />
            <xsl:text />)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$mtCount = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="$mtCount = 1">
          <xsl:attribute name="id">ibr-tdd-37</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-37] Exactly 1 <xsl:text />
            <xsl:value-of select="$currentPath" />
            <xsl:text />/pxs:MonetaryTotal element must be present but found <xsl:text />
            <xsl:value-of select="$mtCount" />
            <xsl:text /> elements</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$mtCount != 1 or count(pxs:MonetaryTotal[cbc:TaxExclusiveAmount/@currencyID = $dcc]) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="$mtCount != 1 or count(pxs:MonetaryTotal[cbc:TaxExclusiveAmount/@currencyID = $dcc]) = 1">
          <xsl:attribute name="id">ibr-tdd-38</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-38] Exactly 1 <xsl:text />
            <xsl:value-of select="$currentPath" />
            <xsl:text />/pxs:MonetaryTotal element with an amount using Document Currency <xsl:text />
            <xsl:value-of select="$dcc" />
            <xsl:text />  MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty" mode="M10" priority="1011">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty" />
    <xsl:variable name="currentPath" select="pxc:genPath(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $child in ('CustomerAssignedAccountID', 'AdditionalAccountID', 'DataSendingCapability',                                                                    'DespatchContact', 'AccountingContact', 'SellerContact')                                                     satisfies count (*[local-name(.) = $child]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $child in ('CustomerAssignedAccountID', 'AdditionalAccountID', 'DataSendingCapability', 'DespatchContact', 'AccountingContact', 'SellerContact') satisfies count (*[local-name(.) = $child]) = 0">
          <xsl:attribute name="id">ibr-tdd-39</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-39] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:Party)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Party)">
          <xsl:attribute name="id">ibr-tdd-40</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-40] The <xsl:text />
            <xsl:value-of select="$currentPath" />
            <xsl:text />/cac:Party element MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party" mode="M10" priority="1010">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party" />
    <xsl:variable name="currentPath" select="pxc:genPath(.)" />
    <xsl:variable name="ptsCount" select="count(cac:PartyTaxScheme)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'EndpointID',                                                                   'IndustryClassificationCode', 'PartyIdentification', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation',                                                                   'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount')                                                    satisfies count (*[local-name(.) = $child]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'EndpointID', 'IndustryClassificationCode', 'PartyIdentification', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount') satisfies count (*[local-name(.) = $child]) = 0">
          <xsl:attribute name="id">ibr-tdd-41</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-41] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$ptsCount = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="$ptsCount = 1">
          <xsl:attribute name="id">ibr-tdd-42</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-42] Exactly 1 <xsl:text />
            <xsl:value-of select="$currentPath" />
            <xsl:text />/cac:PartyTaxScheme element MUST be present but found <xsl:text />
            <xsl:value-of select="$ptsCount" />
            <xsl:text /> elements</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme" mode="M10" priority="1009">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme" />
    <xsl:variable name="isVATIN" select="normalize-space(cac:TaxScheme/cbc:ID) = 'VAT'" />
    <xsl:variable name="btID" select="if ($isVATIN) then ('ibt-031') else ('ibt-032')" />
    <xsl:variable name="btName" select="if ($isVATIN) then ('Seller VAT identifier') else ('Seller tax registration identifier')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $child in ('RegistrationName', 'TaxLevelCode', 'ExemptionReasonCode', 'ExemptionReason', 'RegistrationAddress')                                                    satisfies count (*[local-name(.) = $child]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $child in ('RegistrationName', 'TaxLevelCode', 'ExemptionReasonCode', 'ExemptionReason', 'RegistrationAddress') satisfies count (*[local-name(.) = $child]) = 0">
          <xsl:attribute name="id">ibr-tdd-43</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-43] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:CompanyID)">
          <xsl:attribute name="id">ibr-tdd-44</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-44] The <xsl:text />
            <xsl:value-of select="$btName" />
            <xsl:text /> (<xsl:text />
            <xsl:value-of select="$btID" />
            <xsl:text />) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxScheme/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxScheme/cbc:ID)">
          <xsl:attribute name="id">ibr-tdd-45</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-45] The <xsl:text />
            <xsl:value-of select="$btName" />
            <xsl:text /> Tax scheme code (<xsl:text />
            <xsl:value-of select="$btID" />
            <xsl:text />-1) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty" mode="M10" priority="1008">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty" />
    <xsl:variable name="currentPath" select="pxc:genPath(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $child in ('CustomerAssignedAccountID', 'SupplierAssignedAccountID', 'AdditionalAccountID',                                                                    'DeliveryContact', 'AccountingContact', 'BuyerContact')                                                     satisfies count (*[local-name(.) = $child]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $child in ('CustomerAssignedAccountID', 'SupplierAssignedAccountID', 'AdditionalAccountID', 'DeliveryContact', 'AccountingContact', 'BuyerContact') satisfies count (*[local-name(.) = $child]) = 0">
          <xsl:attribute name="id">ibr-tdd-46</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-46] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:Party)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Party)">
          <xsl:attribute name="id">ibr-tdd-47</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-47] The <xsl:text />
            <xsl:value-of select="$currentPath" />
            <xsl:text />/cac:Party element MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party" mode="M10" priority="1007">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'EndpointID',                                                                   'IndustryClassificationCode', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation',                                                                   'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount')                                                    satisfies count (*[local-name(.) = $child]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $child in ('MarkCareIndicator', 'MarkAttentionIndicator', 'WebsiteURI', 'LogoReferenceID', 'EndpointID', 'IndustryClassificationCode', 'PartyName', 'Language', 'PostalAddress', 'PhysicalLocation', 'PartyLegalEntity', 'Contact', 'Person', 'AgentParty', 'ServiceProviderParty', 'PowerOfAttorney', 'FinancialAccount') satisfies count (*[local-name(.) = $child]) = 0">
          <xsl:attribute name="id">ibr-tdd-48</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-48] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" mode="M10" priority="1006">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" />
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" mode="M10" priority="1005">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $child in ('RegistrationName', 'TaxLevelCode', 'ExemptionReasonCode', 'ExemptionReason', 'RegistrationAddress')                                                    satisfies count (*[local-name(.) = $child]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $child in ('RegistrationName', 'TaxLevelCode', 'ExemptionReasonCode', 'ExemptionReason', 'RegistrationAddress') satisfies count (*[local-name(.) = $child]) = 0">
          <xsl:attribute name="id">ibr-tdd-49</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-49] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:CompanyID)">
          <xsl:attribute name="id">ibr-tdd-50</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-50] The Buyer VAT identifier (ibt-048) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal" mode="M10" priority="1004">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $child in ('RoundingAmount', 'TaxEvidenceIndicator', 'TaxIncludedIndicator', 'TaxSubtotal')                                                     satisfies count (*[local-name(.) = $child]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $child in ('RoundingAmount', 'TaxEvidenceIndicator', 'TaxIncludedIndicator', 'TaxSubtotal') satisfies count (*[local-name(.) = $child]) = 0">
          <xsl:attribute name="id">ibr-tdd-51</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-51] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:MonetaryTotal" mode="M10" priority="1003">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:MonetaryTotal" />
    <xsl:variable name="dc" select="normalize-space(../cbc:DocumentCurrencyCode)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxExclusiveAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxExclusiveAmount)">
          <xsl:attribute name="id">ibr-tdd-52</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-52] The Invoice total amount without VAT (ibt-109) element must be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TaxExclusiveAmount/@currencyID = $dc" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TaxExclusiveAmount/@currencyID = $dc">
          <xsl:attribute name="id">ibr-tdd-53</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-53] The Invoice total amount without VAT (ibt-109) currency must match the Document currency code (ibt-005) (<xsl:text />
            <xsl:value-of select="$dc" />
            <xsl:text />)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cbc:TaxInclusiveAmount))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cbc:TaxInclusiveAmount))">
          <xsl:attribute name="id">ibr-tdd-54</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-54] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:CustomContent" mode="M10" priority="1002">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:CustomContent" />
    <xsl:variable name="currentPath" select="pxc:genPath(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:Value)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:Value)">
          <xsl:attribute name="id">ibr-tdd-55</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-55] The <xsl:text />
            <xsl:value-of select="$currentPath" />
            <xsl:text /> MUST use the simple cbc:Value element</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:SourceDocument" mode="M10" priority="1001">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:SourceDocument" />
    <xsl:variable name="currentPath" select="pxc:genPath(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $child in ('ID', 'Name', 'ExtensionAgencyID', 'ExtensionAgencyName', 'ExtensionVersionID', 'ExtensionAgencyURI',                                                                   'ExtensionURI', 'ExtensionReasonCode', 'ExtensionReason')                                                     satisfies count (*[local-name(.) = $child]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $child in ('ID', 'Name', 'ExtensionAgencyID', 'ExtensionAgencyName', 'ExtensionVersionID', 'ExtensionAgencyURI', 'ExtensionURI', 'ExtensionReasonCode', 'ExtensionReason') satisfies count (*[local-name(.) = $child]) = 0">
          <xsl:attribute name="id">ibr-tdd-56</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-56] Only XML elements defined in this specification are allowed to be used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:SourceDocument/cec:ExtensionContent" mode="M10" priority="1000">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:SourceDocument/cec:ExtensionContent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(inv:Invoice) or exists(cn:CreditNote)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(inv:Invoice) or exists(cn:CreditNote)">
          <xsl:attribute name="id">ibr-tdd-57</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-57] The Invoice XML (tdt-012) MUST contain either a UBL 2.1 Invoice or a UBL 2.1 Credit Note</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
