<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:pxc="urn:peppol:xslt:custom-function" xmlns:pxs="urn:peppol:schema:vida-taxdata:1.0" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
		
		<xsl:sequence select="         string-join(for $ancestor in $node/ancestor-or-self::node()                     return                       if ($ancestor instance of element())                       then concat('/',                                   name($ancestor),                                   if (   count($ancestor/preceding-sibling::*[name() = name($ancestor)]) >    0                                       or count($ancestor/following-sibling::*[name() = name($ancestor)]) > 0)                                   then concat('[', count($ancestor/preceding-sibling::*[name() = name($ancestor)]) + 1, ']')                                   else ''                                   )                       else                         if ($ancestor instance of attribute())                         then concat('/@', name($ancestor))                         else ''                     , '')     " />
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
    <svrl:schematron-output schemaVersion="" title="OpenPeppol TDD Schematron">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:text>These are the Schematron rules for the OpenPeppol TDD.

		Author:
      		Susheel Kumar
	</svrl:text>
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="pxs" uri="urn:peppol:schema:vida-taxdata:1.0" />
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
      <xsl:apply-templates mode="M7" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>OpenPeppol TDD Schematron</svrl:text>

<!--PATTERN default-->
<xsl:variable name="cl_dtc" select="' S R D '" />
  <xsl:variable name="cl_ds" select="' D IC INTL '" />
  <xsl:variable name="cl_rr" select="' C2 C3 '" />
  <xsl:variable name="cl_currency" select="' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLE SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UYW UZS VED VES VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA YER ZAR ZMW ZWG XXX CNH '" />
  <xsl:variable name="regex_pidscheme" select="'^[0-9]{4}$'" />

	<!--RULE -->
<xsl:template match="/pxs:TaxData" mode="M7" priority="1050">
    <svrl:fired-rule context="/pxs:TaxData" />
    <xsl:variable name="dtc" select="normalize-space(pxs:TaxDataTypeCode)" />
    <xsl:variable name="ds" select="normalize-space(pxs:DocumentScope)" />
    <xsl:variable name="rr" select="normalize-space(pxs:ReporterRole)" />
    <xsl:variable name="rtCount" select="count(pxs:ReportedTransaction)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:CustomizationID or self::cbc:ProfileID or self::cbc:UUID or self::cbc:IssueDate or self::cbc:IssueTime or self::pxs:TaxDataTypeCode or self::pxs:DocumentScope or self::pxs:TaxAuthority or self::pxs:ReporterRole or self::pxs:ReportingParty or self::pxs:ReceivingParty or self::pxs:ReportersRepresentative or self::pxs:ReportedTransaction or self::pxs:ReportedDocument)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:CustomizationID or self::cbc:ProfileID or self::cbc:UUID or self::cbc:IssueDate or self::cbc:IssueTime or self::pxs:TaxDataTypeCode or self::pxs:DocumentScope or self::pxs:TaxAuthority or self::pxs:ReporterRole or self::pxs:ReportingParty or self::pxs:ReceivingParty or self::pxs:ReportersRepresentative or self::pxs:ReportedTransaction or self::pxs:ReportedDocument)]) = 0">
          <xsl:attribute name="id">ibr-tdd-00</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-00] – The pxs:TaxData element MUST NOT contain elements other than cbc:CustomizationID (TDT-001), cbc:ProfileID (TDT-002), cbc:UUID (TDT-003), cbc:IssueDate (TDT-004), cbc:IssueTime (TDT-005), pxs:TaxDataTypeCode (TDT-007), pxs:DocumentScope (TDT-006), pxs:TaxAuthority (TDT-TDG-04), pxs:ReporterRole (TDT-012), pxs:ReportingParty (TDG-05), pxs:ReceivingParty (TDG-06), pxs:ReportersRepresentative (TDG-07), pxs:ReportedTransaction (TDG-01), and pxs:ReportedDocument (TDG-02).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CustomizationID) = 'urn:peppol:taxdata:vida-1'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CustomizationID) = 'urn:peppol:taxdata:vida-1'">
          <xsl:attribute name="id">ibr-tdd-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-01] – The cbc:CustomizationID (TDT-001) element MUST have the value 'urn:peppol:taxdata:vida-1'.</svrl:text>
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
          <svrl:text>[ibr-tdd-02] – The cbc:ProfileID (TDT-002) element MUST have the value 'urn:peppol:taxreporting'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:UUID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:UUID)">
          <xsl:attribute name="id">ibr-tdd-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-03] – The cbc:UUID (TDT-003) element MUST be present.</svrl:text>
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
          <svrl:text>[ibr-tdd-04] – The cbc:IssueDate (TDT-004) element MUST NOT contain timezone information.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(cbc:IssueTime), '^(?:([01]\d|2[0-3]):[0-5]\d:[0-5]\d|24:00:00)(\.\d+)?(?:Z|[+-]\d{2}:\d{2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(cbc:IssueTime), '^(?:([01]\d|2[0-3]):[0-5]\d:[0-5]\d|24:00:00)(\.\d+)?(?:Z|[+-]\d{2}:\d{2})?$')">
          <xsl:attribute name="id">ibr-tdd-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-05] – The cbc:IssueTime (TDT-005) element MUST contain timezone information.</svrl:text>
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
          <svrl:text>[ibr-tdd-06] – The pxs:TaxDataTypeCode (TDT-007) element MUST be coded according to the applicable code list.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains($ds, ' ')) and contains($cl_ds, concat(' ', $ds, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains($ds, ' ')) and contains($cl_ds, concat(' ', $ds, ' '))">
          <xsl:attribute name="id">ibr-tdd-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-08] – The pxs:DocumentScope (TDT-006) element MUST be coded according to the applicable code list.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains($rr, ' ')) and contains($cl_rr, concat(' ', $rr, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains($rr, ' ')) and contains($cl_rr, concat(' ', $rr, ' '))">
          <xsl:attribute name="id">ibr-tdd-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-09] – The pxs:ReporterRole (TDT-012) element MUST be coded according to the applicable code list.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(pxs:TaxAuthority)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(pxs:TaxAuthority)">
          <xsl:attribute name="id">ibr-tdd-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-10] – The pxs:TaxData element MUST contain a pxs:TaxAuthority (TDG-04) element.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(pxs:ReportedTransaction) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(pxs:ReportedTransaction) = 1">
          <xsl:attribute name="id">ibr-tdd-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-11] – Exactly one pxs:ReportedTransaction (TDG-01) element MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs:TaxData/pxs:TaxAuthority" mode="M7" priority="1049">
    <svrl:fired-rule context="pxs:TaxData/pxs:TaxAuthority" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID or self::cbc:Name)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID or self::cbc:Name)]) = 0">
          <xsl:attribute name="id">ibr-tdd-12</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-12] – The pxs:TaxAuthority (TDG-04) element MUST NOT contain elements other than cbc:ID (TDT-010) and cbc:Name (TDT-011).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:ID)">
          <xsl:attribute name="id">ibr-tdd-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-13] – The pxs:TaxAuthority (TDG-04) element MUST contain the cbc:ID (TDT-010) element.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportingParty" mode="M7" priority="1048">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportingParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:EndpointID)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:EndpointID)]) = 0">
          <xsl:attribute name="id">ibr-tdd-14</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-14] – The pxs:ReportingParty (TDG-05) element MUST NOT contain elements other than cbc:EndpointID (TDT-013).</svrl:text>
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
          <svrl:text>[ibr-tdd-15] – The cbc:EndpointID (TDT-013) element of pxs:ReportingParty (TDG-05) MUST be present.</svrl:text>
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
          <svrl:text>[ibr-tdd-16] – The scheme identifier (TDT-013-1) attribute of cbc:EndpointID (TDT-013) MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cbc:EndpointID/@schemeID)) or matches(cbc:EndpointID/@schemeID, $regex_pidscheme)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cbc:EndpointID/@schemeID)) or matches(cbc:EndpointID/@schemeID, $regex_pidscheme)">
          <xsl:attribute name="id">ibr-tdd-17</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-17] – The scheme identifier (TDT-013-1) attribute of cbc:EndpointID (TDT-013) MUST be a Peppol Participant Identifier Scheme.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReceivingParty" mode="M7" priority="1047">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReceivingParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:EndpointID)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:EndpointID)]) = 0">
          <xsl:attribute name="id">ibr-tdd-18</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-18] – The pxs:ReceivingParty (TDG-06) element MUST NOT contain elements other than cbc:EndpointID (TDT-014).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:EndpointID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:EndpointID)">
          <xsl:attribute name="id">ibr-tdd-19</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-19] – The cbc:EndpointID (TDT-014) element of pxs:ReceivingParty (TDG-06) MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:EndpointID/@schemeID) and cbc:EndpointID/@schemeID = '0242'" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:EndpointID/@schemeID) and cbc:EndpointID/@schemeID = '0242'">
          <xsl:attribute name="id">ibr-tdd-20</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-20] The scheme identifier (TDT-014-1) attribute of Receiving party (TDG-06) endpoint ID (TDT-014) MUST be present and MUST refer to an SPID ('0242').</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportersRepresentative" mode="M7" priority="1046">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportersRepresentative" />
    <xsl:variable name="pidCount" select="count(cac:PartyIdentification/cbc:ID)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cac:PartyIdentification)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cac:PartyIdentification)]) = 0">
          <xsl:attribute name="id">ibr-tdd-21</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-21] – The cac:ReportersRepresentative (TDG-07) element MUST NOT contain elements other than cac:PartyIdentification (TDG-08).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$pidCount = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="$pidCount = 1">
          <xsl:attribute name="id">ibr-tdd-22</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-22] – Exactly one cbc:ID (TDT-015) element MUST be present within cac:PartyIdentification (TDG-08) <xsl:text />
            <xsl:value-of select="$pidCount" />
            <xsl:text /> instead</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:PartyIdentification/cbc:ID/@schemeID) and cac:PartyIdentification/cbc:ID/@schemeID = '0242'" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:PartyIdentification/cbc:ID/@schemeID) and cac:PartyIdentification/cbc:ID/@schemeID = '0242'">
          <xsl:attribute name="id">ibr-tdd-23</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-23] – The scheme identifier(TDT-015-1) attribute of Reporter's Representative party (TDG-08) ID MUST be present and MUST refer to an SPID ('0242').</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction" mode="M7" priority="1045">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(pxs:ReportedDocument)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(pxs:ReportedDocument)">
          <xsl:attribute name="id">ibr-tdd-24</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-24] – The cac:ReportedDocument (TDG-02) element MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument" mode="M7" priority="1044">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:CustomizationID or self::cbc:ProfileID or self::cbc:ID or self::cbc:UUID or self::cbc:IssueDate or self::cbc:IssueTime or self::pxs:DocumentTypeCode or self::cbc:Note or self::cbc:TaxPointDate or self::cbc:DocumentCurrencyCode or self::cbc:TaxCurrencyCode or self::cac:InvoicePeriod or self::cac:BillingReference or self::cac:AccountingSupplierParty or self::cac:AccountingCustomerParty or self::cac:TaxRepresentativeParty or self::cac:Delivery or self::cac:PaymentMeans or self::cac:AllowanceCharge or self::cac:TaxTotal or self::pxs:MonetaryTotal or self::pxs:DocumentLine)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:CustomizationID or self::cbc:ProfileID or self::cbc:ID or self::cbc:UUID or self::cbc:IssueDate or self::cbc:IssueTime or self::pxs:DocumentTypeCode or self::cbc:Note or self::cbc:TaxPointDate or self::cbc:DocumentCurrencyCode or self::cbc:TaxCurrencyCode or self::cac:InvoicePeriod or self::cac:BillingReference or self::cac:AccountingSupplierParty or self::cac:AccountingCustomerParty or self::cac:TaxRepresentativeParty or self::cac:Delivery or self::cac:PaymentMeans or self::cac:AllowanceCharge or self::cac:TaxTotal or self::pxs:MonetaryTotal or self::pxs:DocumentLine)]) = 0">
          <xsl:attribute name="id">ibr-tdd-25</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-25] – The cac:ReportedDocument element MUST NOT contain elements other than cbc:CustomizationID (BT-024), cbc:ProfileID (BT-023), cbc:ID (BT-001), cbc:UUID (TDT-017), cbc:IssueDate (BT-002), cbc:IssueTime, pxs:DocumentTypeCode (BT-003), cbc:Note (BT-022), cbc:TaxPointDate (BT-007), cbc:DocumentCurrencyCode (BT-005), cbc:TaxCurrencyCode (BT-006), cac:InvoicePeriod (BG-14), cac:BillingReference (BG-03), cac:AccountingSupplierParty (BG-04), cac:AccountingCustomerParty (BG-07), cac:TaxRepresentativeParty (BG-11), cac:Delivery (BG-13), cac:PaymentMeans (BG-16), cac:AllowanceCharge (BG-20, BG-21), cac:TaxTotal (BT-110, BG-37), pxs:MonetaryTotal (BG-22), and pxs:DocumentLine (BG-25).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:UUID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:UUID)">
          <xsl:attribute name="id">ibr-tdd-86</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-86] – The UUID (TDT-017) MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:InvoicePeriod" mode="M7" priority="1043">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:InvoicePeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:StartDate or self::cbc:EndDate or self::cbc:DescriptionCode)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:StartDate or self::cbc:EndDate or self::cbc:DescriptionCode)]) = 0">
          <xsl:attribute name="id">ibr-tdd-26</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-26] – The cac:InvoicePeriod (BG-14) element MUST NOT contain elements other than cbc:StartDate (BT-073), cbc:EndDate (BT-074), and cbc:DescriptionCode (BT-008).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:InvoicePeriod" mode="M7" priority="1042">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:InvoicePeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:StartDate or self::cbc:EndDate)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:StartDate or self::cbc:EndDate)]) = 0">
          <xsl:attribute name="id">ibr-tdd-27</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-27] – The cac:InvoicePeriod (BG-14) element at line level, MUST NOT contain elements other than cbc:StartDate (BT-073) and cbc:EndDate (BT-074).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:BillingReference/cac:InvoiceDocumentReference" mode="M7" priority="1041">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:BillingReference/cac:InvoiceDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID or self::cbc:IssueDate)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID or self::cbc:IssueDate)]) = 0">
          <xsl:attribute name="id">ibr-tdd-28</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-28] – The cac:InvoiceDocumentReference element MUST NOT contain elements other than cbc:ID (BT-025) and cbc:IssueDate (BT-026).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty" mode="M7" priority="1040">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:Party)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Party)">
          <xsl:attribute name="id">ibr-tdd-29</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-29] – The SELLER (BG-04) MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party" mode="M7" priority="1039">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cac:PostalAddress or self::cac:PartyTaxScheme)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cac:PostalAddress or self::cac:PartyTaxScheme)]) = 0">
          <xsl:attribute name="id">ibr-tdd-30</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-30] – The cac:Party element MUST NOT contain elements other than cac:PostalAddress (BG-05) and optionally cac:PartyTaxScheme.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" mode="M7" priority="1038">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cac:Country)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cac:Country)]) = 0">
          <xsl:attribute name="id">ibr-tdd-31</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-31] – The cac:PostalAddress (BG-05) element MUST NOT contain elements other than cac:Country.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country" mode="M7" priority="1037">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:IdentificationCode)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:IdentificationCode)]) = 0">
          <xsl:attribute name="id">ibr-tdd-32</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-32] – The cac:Country element MUST NOT contain elements other than cbc:IdentificationCode (BT-040).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme" mode="M7" priority="1036">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxScheme/cbc:ID = 'VAT'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxScheme/cbc:ID = 'VAT'">
          <xsl:attribute name="id">ibr-tdd-33</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-33] – The value of cac:PartyTaxScheme/cac:TaxScheme/cbc:ID MUST be VAT.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:CompanyID or self::cac:TaxScheme)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:CompanyID or self::cac:TaxScheme)]) = 0">
          <xsl:attribute name="id">ibr-tdd-34</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-34] – The cac:PartyTaxScheme element MUST NOT contain elements other than cbc:CompanyID (BT-031) and cac:TaxScheme.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" mode="M7" priority="1035">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID)]) = 0">
          <xsl:attribute name="id">ibr-tdd-35</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-35] – The cac:TaxScheme element MUST NOT contain elements other than cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty" mode="M7" priority="1034">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:Party)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Party)">
          <xsl:attribute name="id">ibr-tdd-36</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-36] – The BUYER (BG-07) MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cac:Party)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cac:Party)]) = 0">
          <xsl:attribute name="id">ibr-tdd-37</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-37] – The cac:AccountingCustomerParty (BG-07) element MUST NOT contain elements other than cac:Party.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party" mode="M7" priority="1033">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cac:PostalAddress or self::cac:PartyTaxScheme or self::cac:PartyLegalEntity)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cac:PostalAddress or self::cac:PartyTaxScheme or self::cac:PartyLegalEntity)]) = 0">
          <xsl:attribute name="id">ibr-tdd-38</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-38] – The cac:Party element MUST NOT contain elements other than cac:PostalAddress (BG-08), cac:PartyLegalEntity, and optionally cac:PartyTaxScheme.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" mode="M7" priority="1032">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cac:Country)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cac:Country)]) = 0">
          <xsl:attribute name="id">ibr-tdd-39</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-39] – The cac:PostalAddress (BG-08) element MUST NOT contain elements other than cac:Country.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country" mode="M7" priority="1031">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:IdentificationCode)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:IdentificationCode)]) = 0">
          <xsl:attribute name="id">ibr-tdd-40</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-40] – The cac:Country element MUST NOT contain elements other than cbc:IdentificationCode (BT-055).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" mode="M7" priority="1030">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxScheme/cbc:ID = 'VAT'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxScheme/cbc:ID = 'VAT'">
          <xsl:attribute name="id">ibr-tdd-41</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-41] – The value of cac:PartyTaxScheme/cac:TaxScheme/cbc:ID MUST be 'VAT'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:CompanyID or self::cac:TaxScheme)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:CompanyID or self::cac:TaxScheme)]) = 0">
          <xsl:attribute name="id">ibr-tdd-42</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-42] – The cac:PartyTaxScheme element MUST NOT contain elements other than cbc:CompanyID (BT-048) and cac:TaxScheme.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" mode="M7" priority="1029">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID)]) = 0">
          <xsl:attribute name="id">ibr-tdd-43</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-43] – The cac:TaxScheme element MUST NOT contain elements other than cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:TaxRepresentativeParty" mode="M7" priority="1028">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AccountingCustomerParty/cac:TaxRepresentativeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cac:PostalAddress or self::cac:PartyTaxScheme)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cac:PostalAddress or self::cac:PartyTaxScheme)]) = 0">
          <xsl:attribute name="id">ibr-tdd-44</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-44] – The cac:TaxRepresentativeParty (BG-11) element MUST NOT contain elements other than cac:PostalAddress (BG-12) and optionally cac:PartyTaxScheme.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxRepresentativeParty/cac:PostalAddress" mode="M7" priority="1027">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxRepresentativeParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cac:Country)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cac:Country)]) = 0">
          <xsl:attribute name="id">ibr-tdd-45</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-45] – The cac:PostalAddress (BG-12) element MUST NOT contain elements other than cac:Country.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country" mode="M7" priority="1026">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:IdentificationCode)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:IdentificationCode)]) = 0">
          <xsl:attribute name="id">ibr-tdd-46</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-46] – The cac:Country element MUST NOT contain elements other than cbc:IdentificationCode (BT-069).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:Delivery" mode="M7" priority="1025">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:Delivery" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ActualDeliveryDate)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ActualDeliveryDate)]) = 0">
          <xsl:attribute name="id">ibr-tdd-85</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-85] – The cac:Delivery (BG-13) element MUST NOT contain elements other than cbc:ActualDeliveryDate (BT-072).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme" mode="M7" priority="1024">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxScheme/cbc:ID = 'VAT'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxScheme/cbc:ID = 'VAT'">
          <xsl:attribute name="id">ibr-tdd-47</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-47] – The value of cac:PartyTaxScheme/cac:TaxScheme/cbc:ID MUST be 'VAT'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:CompanyID or self::cac:TaxScheme)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:CompanyID or self::cac:TaxScheme)]) = 0">
          <xsl:attribute name="id">ibr-tdd-48</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-48] – The cac:PartyTaxScheme element MUST NOT contain elements other than cbc:CompanyID (BT-063) and cac:TaxScheme.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M7" priority="1023">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID)]) = 0">
          <xsl:attribute name="id">ibr-tdd-49</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-49] – The cac:TaxScheme element MUST NOT contain elements other than cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans" mode="M7" priority="1022">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:PaymentMeansCode or self::cbc:PaymentID or self::cac:CardAccount or self::cac:PayeeFinancialAccount or self::cac:PaymentMandate)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:PaymentMeansCode or self::cbc:PaymentID or self::cac:CardAccount or self::cac:PayeeFinancialAccount or self::cac:PaymentMandate)]) = 0">
          <xsl:attribute name="id">ibr-tdd-50</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-50] – The cac:PaymentMeans (BG-16) element MUST NOT contain elements other than cbc:PaymentMeansCode (BT-081), cbc:PaymentID (BT-083), cac:CardAccount (BG-18), cac:PayeeFinancialAccount (BG-17), and cac:PaymentMandate (BG-19).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans/cbc:PaymentMeansCode" mode="M7" priority="1021">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans/cbc:PaymentMeansCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(@*[not(local-name() = 'name')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(@*[not(local-name() = 'name')]) = 0">
          <xsl:attribute name="id">ibr-tdd-51</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-51] – The cbc:PaymentMeansCode (BT-081) element MUST NOT have attributes other than 'name' (BT-082).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans/cac:CardAccount" mode="M7" priority="1020">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans/cac:CardAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:PrimaryAccountNumberID or self::cbc:NetworkID or self::cbc:HolderName)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:PrimaryAccountNumberID or self::cbc:NetworkID or self::cbc:HolderName)]) = 0">
          <xsl:attribute name="id">ibr-tdd-52</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-52] – The cac:CardAccount (BG-18) element MUST NOT contain elements other than cbc:PrimaryAccountNumberID (BT-087), cbc:NetworkID, and cbc:HolderName (BT-088).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans/cac:PayeeFinancialAccount" mode="M7" priority="1019">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans/cac:PayeeFinancialAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID or self::cac:FinancialInstitutionBranch)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID or self::cac:FinancialInstitutionBranch)]) = 0">
          <xsl:attribute name="id">ibr-tdd-53</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-53] – The cac:PayeeFinancialAccount (BG-17) element MUST NOT contain elements other than cbc:ID (BT-084) and cac:FinancialInstitutionBranch.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch" mode="M7" priority="1018">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID)]) = 0">
          <xsl:attribute name="id">ibr-tdd-54</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-54] – The cac:FinancialInstitutionBranch element MUST NOT contain elements other than cbc:ID (BT-086).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans/cac:PaymentMandate" mode="M7" priority="1017">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans/cac:PaymentMandate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID or self::cac:PayerFinancialAccount)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID or self::cac:PayerFinancialAccount)]) = 0">
          <xsl:attribute name="id">ibr-tdd-55</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-55] – The cac:PaymentMandate (BG-19) element MUST NOT contain elements other than cbc:ID (BT-089) and cac:PayerFinancialAccount.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount" mode="M7" priority="1016">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID)]) = 0">
          <xsl:attribute name="id">ibr-tdd-56</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-56] – The cac:PayerFinancialAccount element MUST NOT contain elements other than cbc:ID (BT-091).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AllowanceCharge" mode="M7" priority="1015">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ChargeIndicator or self::cbc:AllowanceChargeReasonCode or self::cbc:AllowanceChargeReason or self::cbc:MultiplierFactorNumeric or self::cbc:Amount or self::cbc:BaseAmount or self::cac:TaxCategory)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ChargeIndicator or self::cbc:AllowanceChargeReasonCode or self::cbc:AllowanceChargeReason or self::cbc:MultiplierFactorNumeric or self::cbc:Amount or self::cbc:BaseAmount or self::cac:TaxCategory)]) = 0">
          <xsl:attribute name="id">ibr-tdd-57</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-57] – The cac:AllowanceCharge (Document level: BG-20, BG-21) element MUST NOT contain elements other than cbc:ChargeIndicator, cbc:AllowanceChargeReasonCode (BT-098, BT-105), cbc:AllowanceChargeReason (BT-097, BT-104), cbc:MultiplierFactorNumeric (BT-094, BT-101), cbc:Amount (BT-092, BT-099), cbc:BaseAmount (BT-093, BT-100), and cac:TaxCategory.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:Amount/@*[not(local-name() = 'currencyID')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:Amount/@*[not(local-name() = 'currencyID')]) = 0">
          <xsl:attribute name="id">ibr-tdd-58</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-58] – The cbc:Amount (BT-092, BT-099) element MUST have the attribute 'currencyID'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:BaseAmount/@*[not(local-name() = 'currencyID')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:BaseAmount/@*[not(local-name() = 'currencyID')]) = 0">
          <xsl:attribute name="id">ibr-tdd-59</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-59] – The cbc:BaseAmount (BT-093, BT-100) element MUST have the attribute 'currencyID'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:AllowanceCharge" mode="M7" priority="1014">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ChargeIndicator or self::cbc:AllowanceChargeReasonCode or self::cbc:AllowanceChargeReason or self::cbc:MultiplierFactorNumeric or self::cbc:Amount or self::cbc:BaseAmount)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ChargeIndicator or self::cbc:AllowanceChargeReasonCode or self::cbc:AllowanceChargeReason or self::cbc:MultiplierFactorNumeric or self::cbc:Amount or self::cbc:BaseAmount)]) = 0">
          <xsl:attribute name="id">ibr-tdd-60</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-60] – The cac:AllowanceCharge (Document line level: BG-27, BG-28) element MUST NOT contain elements other than cbc:ChargeIndicator, cbc:AllowanceChargeReasonCode (BT-140, BT-145), cbc:AllowanceChargeReason (BT-139, BT-144), cbc:MultiplierFactorNumeric (BT-138, BT-143), cbc:Amount (BT-136, BT-141), and cbc:BaseAmount (BT-137, BT-142).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:Amount/@*[not(local-name() = 'currencyID')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:Amount/@*[not(local-name() = 'currencyID')]) = 0">
          <xsl:attribute name="id">ibr-tdd-61</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-61] – The cbc:Amount (BT-136, BT-141) element MUST have the attribute 'currencyID'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:BaseAmount/@*[not(local-name() = 'currencyID')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:BaseAmount/@*[not(local-name() = 'currencyID')]) = 0">
          <xsl:attribute name="id">ibr-tdd-62</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-62] – The cbc:BaseAmount (BT-137, BT-142) element MUST have the attribute 'currencyID'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory" mode="M7" priority="1013">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID or self::cbc:Percent or self::cac:TaxScheme)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID or self::cbc:Percent or self::cac:TaxScheme)]) = 0">
          <xsl:attribute name="id">ibr-tdd-63</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-63] – The cac:TaxCategory element MUST NOT contain elements other than cbc:ID (BT-095, BT-102), cbc:Percent (BT-096, BT-103), and cac:TaxScheme.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" mode="M7" priority="1012">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID)]) = 0">
          <xsl:attribute name="id">ibr-tdd-64</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-64] – The cac:TaxScheme element MUST NOT contain elements other than cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal" mode="M7" priority="1011">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:TaxAmount or self::cac:TaxSubtotal)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:TaxAmount or self::cac:TaxSubtotal)]) = 0">
          <xsl:attribute name="id">ibr-tdd-65</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-65] – The cac:TaxTotal element MUST NOT contain elements other than cbc:TaxAmount (BT-110, BT-111) and cac:TaxSubtotal (BG-23).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TaxAmount/@*[not(local-name() = 'currencyID')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TaxAmount/@*[not(local-name() = 'currencyID')]) = 0">
          <xsl:attribute name="id">ibr-tdd-66</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-66] – The cbc:TaxAmount (BT-110, BT-111) element MUST have the attribute 'currencyID'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal" mode="M7" priority="1010">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:TaxableAmount or self::cbc:TaxAmount or self::cac:TaxCategory)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:TaxableAmount or self::cbc:TaxAmount or self::cac:TaxCategory)]) = 0">
          <xsl:attribute name="id">ibr-tdd-67</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-67] – The cac:TaxSubtotal (BG-23) element MUST NOT contain elements other than cbc:TaxableAmount (BT-116), cbc:TaxAmount (BT-117), and cac:TaxCategory.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TaxableAmount/@*[not(local-name() = 'currencyID')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TaxableAmount/@*[not(local-name() = 'currencyID')]) = 0">
          <xsl:attribute name="id">ibr-tdd-68</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-68] – The cbc:TaxableAmount (BT-116) element MUST have the attribute 'currencyID'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TaxAmount/@*[not(local-name() = 'currencyID')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TaxAmount/@*[not(local-name() = 'currencyID')]) = 0">
          <xsl:attribute name="id">ibr-tdd-69</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-69] – The cbc:TaxAmount (BT-117) element MUST have the attribute 'currencyID'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory" mode="M7" priority="1009">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID or self::cbc:Percent or self::cbc:TaxExemptionReasonCode or self::cbc:TaxExemptionReason or self::cac:TaxScheme)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID or self::cbc:Percent or self::cbc:TaxExemptionReasonCode or self::cbc:TaxExemptionReason or self::cac:TaxScheme)]) = 0">
          <xsl:attribute name="id">ibr-tdd-70</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-70] – The cac:TaxCategory element MUST NOT contain elements other than cbc:ID (BT-118), cbc:Percent (BT-119), cbc:TaxExemptionReasonCode (BT-121), cbc:TaxExemptionReason (BT-120), and cac:TaxScheme.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme" mode="M7" priority="1008">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID)]) = 0">
          <xsl:attribute name="id">ibr-tdd-71</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-71] – The cac:TaxScheme element MUST NOT contain elements other than cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:MonetaryTotal" mode="M7" priority="1007">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:MonetaryTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:LineExtensionAmount or self::cbc:TaxExclusiveAmount or self::cbc:TaxInclusiveAmount or self::cbc:AllowanceTotalAmount or self::cbc:ChargeTotalAmount or self::cbc:PrepaidAmount or self::cbc:PayableRoundingAmount or self::cbc:PayableAmount)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:LineExtensionAmount or self::cbc:TaxExclusiveAmount or self::cbc:TaxInclusiveAmount or self::cbc:AllowanceTotalAmount or self::cbc:ChargeTotalAmount or self::cbc:PrepaidAmount or self::cbc:PayableRoundingAmount or self::cbc:PayableAmount)]) = 0">
          <xsl:attribute name="id">ibr-tdd-72</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-72] – The pxs:MonetaryTotal (BG-22) element MUST NOT contain elements other than cbc:LineExtensionAmount (BT-106), cbc:TaxExclusiveAmount (BT-109), cbc:TaxInclusiveAmount (BT-112), cbc:AllowanceTotalAmount (BT-107), cbc:ChargeTotalAmount (BT-108), cbc:PrepaidAmount (BT-113), cbc:PayableRoundingAmount (BT-114), and cbc:PayableAmount (BT-115).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[self::cbc:LineExtensionAmount or self::cbc:TaxExclusiveAmount or self::cbc:TaxInclusiveAmount or self::cbc:AllowanceTotalAmount or self::cbc:ChargeTotalAmount or self::cbc:PrepaidAmount or self::cbc:PayableAmount]/@*[not(local-name() = 'currencyID')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[self::cbc:LineExtensionAmount or self::cbc:TaxExclusiveAmount or self::cbc:TaxInclusiveAmount or self::cbc:AllowanceTotalAmount or self::cbc:ChargeTotalAmount or self::cbc:PrepaidAmount or self::cbc:PayableAmount]/@*[not(local-name() = 'currencyID')]) = 0">
          <xsl:attribute name="id">ibr-tdd-73</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-73] – All amount (BT-106, BT-109, BT-112, BT-107, BT-108, BT-113, BT-114, BT-115) elements within pxs:MonetaryTotal (BG-22) MUST have the attribute 'currencyID'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine" mode="M7" priority="1006">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID or self::cbc:Note or self::cbc:InvoicedQuantity or self::cbc:LineExtensionAmount or self::cac:InvoicePeriod or self::cac:AllowanceCharge or self::cac:Item or self::cac:Price)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID or self::cbc:Note or self::cbc:InvoicedQuantity or self::cbc:LineExtensionAmount or self::cac:InvoicePeriod or self::cac:AllowanceCharge or self::cac:Item or self::cac:Price)]) = 0">
          <xsl:attribute name="id">ibr-tdd-74</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-74] – The pxs:DocumentLine (BG-25) element MUST NOT contain elements other than cbc:ID (BT-126), cbc:Note (BT-127), cbc:InvoicedQuantity (BT-129), cbc:LineExtensionAmount (BT-131), cac:InvoicePeriod (BG-26), cac:AllowanceCharge (BG-27, BG-28), cac:Item (BG-31), and cac:Price (BG-29).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:InvoicedQuantity/@*[not(local-name() = 'unitCode')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:InvoicedQuantity/@*[not(local-name() = 'unitCode')]) = 0">
          <xsl:attribute name="id">ibr-tdd-75</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-75] – The cbc:InvoicedQuantity (BT-129) element MUST have the attribute 'unitCode' (BT-130).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:LineExtensionAmount/@*[not(local-name() = 'currencyID')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:LineExtensionAmount/@*[not(local-name() = 'currencyID')]) = 0">
          <xsl:attribute name="id">ibr-tdd-76</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-76] – The cbc:LineExtensionAmount (BT-131) element MUST have the attribute 'currencyID'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:Item" mode="M7" priority="1005">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:Item" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:Description or self::cbc:Name or self::cac:CommodityClassification or self::cac:ClassifiedTaxCategory)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:Description or self::cbc:Name or self::cac:CommodityClassification or self::cac:ClassifiedTaxCategory)]) = 0">
          <xsl:attribute name="id">ibr-tdd-77</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-77] – The cac:Item (BG-31) element MUST NOT contain elements other than cbc:Description (BT-154), cbc:Name (BT-153), cac:CommodityClassification, and cac:ClassifiedTaxCategory (BG-30).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:Item/cac:CommodityClassification" mode="M7" priority="1004">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:Item/cac:CommodityClassification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ItemClassificationCode)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ItemClassificationCode)]) = 0">
          <xsl:attribute name="id">ibr-tdd-78</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-78] – The cac:CommodityClassification element MUST NOT contain elements other than cbc:ItemClassificationCode (BT-158).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ItemClassificationCode/@*[not(local-name() = 'listID')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ItemClassificationCode/@*[not(local-name() = 'listID')]) = 0">
          <xsl:attribute name="id">ibr-tdd-79</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-79] – The cbc:ItemClassificationCode (BT-158) element MUST have the attribute 'listID' (BT-158-1).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:Item/cac:ClassifiedTaxCategory" mode="M7" priority="1003">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:Item/cac:ClassifiedTaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID or self::cbc:Percent or self::cac:TaxScheme)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID or self::cbc:Percent or self::cac:TaxScheme)]) = 0">
          <xsl:attribute name="id">ibr-tdd-80</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-80] – The cac:ClassifiedTaxCategory (BG-30) element MUST NOT contain elements other than cbc:ID (BT-151), cbc:Percent (BT-152), and cac:TaxScheme.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme" mode="M7" priority="1002">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:ID)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:ID)]) = 0">
          <xsl:attribute name="id">ibr-tdd-81</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-81] – The cac:TaxScheme element MUST NOT contain elements other than cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:Price" mode="M7" priority="1001">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/pxs:DocumentLine/cac:Price" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cbc:PriceAmount or self::cbc:BaseQuantity)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cbc:PriceAmount or self::cbc:BaseQuantity)]) = 0">
          <xsl:attribute name="id">ibr-tdd-82</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-82] – The cac:Price (BG-29) element MUST NOT contain elements other than cbc:PriceAmount (BT-146).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:PriceAmount/@*[not(local-name() = 'currencyID')]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:PriceAmount/@*[not(local-name() = 'currencyID')]) = 0">
          <xsl:attribute name="id">ibr-tdd-83</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-83] – The cbc:PriceAmount (BT-146) element MUST have the attribute 'currencyID'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:BillingReference" mode="M7" priority="1000">
    <svrl:fired-rule context="/pxs:TaxData/pxs:ReportedTransaction/pxs:ReportedDocument/cac:BillingReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*[not(self::cac:InvoiceDocumentReference)]) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*[not(self::cac:InvoiceDocumentReference)]) = 0">
          <xsl:attribute name="id">ibr-tdd-84</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-tdd-84] – The cac:BillingReference (BG-03) element MUST NOT contain elements other than cac:InvoiceDocumentReference.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M7" priority="-1" />
  <xsl:template match="@*|node()" mode="M7" priority="-2">
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
