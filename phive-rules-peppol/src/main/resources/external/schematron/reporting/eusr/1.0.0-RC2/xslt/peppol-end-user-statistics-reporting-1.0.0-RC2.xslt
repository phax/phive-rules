<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:eusr="urn:fdc:peppol:end-user-statistics-report:1.0" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
    <svrl:schematron-output schemaVersion="ISO19757-3" title="OpenPeppol End User Statistics Report">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:text>
    This is the Schematron for the Peppol End User Statistics Reports.
    This is based on the "Internal Regulations" document,
      chapter 4.3 "Service Provider Reporting about End Users"

    Author:
      Philip Helger

    History:
      2022-11-14, Muhammet Yildiz, Philip Helger - updates after the first review
      2022-04-15, Philip Helger - initial version
  </svrl:text>
      <svrl:ns-prefix-in-attribute-values prefix="eusr" uri="urn:fdc:peppol:end-user-statistics-report:1.0" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">default</xsl:attribute>
        <xsl:attribute name="name">default</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M3" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>OpenPeppol End User Statistics Report</svrl:text>

<!--PATTERN default-->
<xsl:variable name="cl_spidtype" select="' CertSubjectCN '" />

	<!--RULE -->
<xsl:template match="/eusr:EndUserStatisticsReport" mode="M3" priority="1003">
    <svrl:fired-rule context="/eusr:EndUserStatisticsReport" />
    <xsl:variable name="total" select="eusr:Total/eusr:SendingEndUsers + eusr:Total/eusr:ReceivingEndUsers" />
    <xsl:variable name="empty" select="$total = 0" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(eusr:CustomizationID) = 'urn:fdc:peppol.eu:edec:trns:end-user-statistics-report:1.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(eusr:CustomizationID) = 'urn:fdc:peppol.eu:edec:trns:end-user-statistics-report:1.0'">
          <xsl:attribute name="id">SCH-EUSR-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:edec:trns:end-user-statistics-report:1.0'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(eusr:ProfileID) = 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(eusr:ProfileID) = 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'">
          <xsl:attribute name="id">SCH-EUSR-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$empty or eusr:Subtotal/eusr:SendingEndUsers[not(. &lt; ../../eusr:Subtotal/eusr:SendingEndUsers)][1] &lt;= eusr:Total/eusr:SendingEndUsers" />
      <xsl:otherwise>
        <svrl:failed-assert test="$empty or eusr:Subtotal/eusr:SendingEndUsers[not(. &lt; ../../eusr:Subtotal/eusr:SendingEndUsers)][1] &lt;= eusr:Total/eusr:SendingEndUsers">
          <xsl:attribute name="id">SCH-EUSR-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-03] The maximum of all subtotals of SendingEndUsers MUST be lower or equal to Totals/SendingEndUsers</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$empty or eusr:Subtotal/eusr:ReceivingEndUsers[not(. &lt; ../../eusr:Subtotal/eusr:ReceivingEndUsers)][1] &lt;= eusr:Total/eusr:ReceivingEndUsers" />
      <xsl:otherwise>
        <svrl:failed-assert test="$empty or eusr:Subtotal/eusr:ReceivingEndUsers[not(. &lt; ../../eusr:Subtotal/eusr:ReceivingEndUsers)][1] &lt;= eusr:Total/eusr:ReceivingEndUsers">
          <xsl:attribute name="id">SCH-EUSR-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-04] The maximum of all subtotals of ReceivingEndUsers MUST be lower or equal to Totals/ReceivingEndUsers</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="eusr:Total/eusr:DistinctEndUsers &lt;= $total" />
      <xsl:otherwise>
        <svrl:failed-assert test="eusr:Total/eusr:DistinctEndUsers &lt;= $total">
          <xsl:attribute name="id">SCH-EUSR-19</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-19] The total number of total DistinctEndUsers (<xsl:text />
            <xsl:value-of select="eusr:Total/eusr:DistinctEndUsers" />
            <xsl:text />) MUST be lower or equal to the sum of the total SendingEndUsers and total ReceivingEndUsers</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="eusr:Total/eusr:DistinctEndUsers >= eusr:Total/eusr:SendingEndUsers" />
      <xsl:otherwise>
        <svrl:failed-assert test="eusr:Total/eusr:DistinctEndUsers >= eusr:Total/eusr:SendingEndUsers">
          <xsl:attribute name="id">SCH-EUSR-20</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-20] The total number of total DistinctEndUsers (<xsl:text />
            <xsl:value-of select="eusr:Total/eusr:DistinctEndUsers" />
            <xsl:text />) MUST be greater or equal to number of total SendingEndUsers (<xsl:text />
            <xsl:value-of select="eusr:Total/eusr:SendingEndUsers" />
            <xsl:text />)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="eusr:Total/eusr:DistinctEndUsers >= eusr:Total/eusr:ReceivingEndUsers" />
      <xsl:otherwise>
        <svrl:failed-assert test="eusr:Total/eusr:DistinctEndUsers >= eusr:Total/eusr:ReceivingEndUsers">
          <xsl:attribute name="id">SCH-EUSR-21</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-21] The total number of total DistinctEndUsers (<xsl:text />
            <xsl:value-of select="eusr:Total/eusr:DistinctEndUsers" />
            <xsl:text />) MUST be greater or equal to number of total ReceivingEndUsers (<xsl:text />
            <xsl:value-of select="eusr:Total/eusr:ReceivingEndUsers" />
            <xsl:text />)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$empty or eusr:Subtotal[normalize-space(@type) = 'PerDT-PR']" />
      <xsl:otherwise>
        <svrl:failed-assert test="$empty or eusr:Subtotal[normalize-space(@type) = 'PerDT-PR']">
          <xsl:attribute name="id">SCH-EUSR-15</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-15] The subtotals per 'Dataset Type ID and Process ID' MUST exist</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $st in (eusr:Subtotal[normalize-space(@type) = 'PerDT-PR']),                                                         $stdt in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'DT']),                                                         $stpr in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'PR'])  satisfies                                                     count(eusr:Subtotal[normalize-space(@type) ='PerDT-PR'][every $dt in (eusr:Key[normalize-space(@metaSchemeID) = 'DT']),                                                                                                                   $pr in (eusr:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies                                                                                                             concat(normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',                                                                                                                    normalize-space($pr/@schemeID),'::',normalize-space($pr)) =                                                                                                             concat(normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',                                                                                                                    normalize-space($stpr/@schemeID),'::',normalize-space($stpr))]) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $st in (eusr:Subtotal[normalize-space(@type) = 'PerDT-PR']), $stdt in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'DT']), $stpr in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies count(eusr:Subtotal[normalize-space(@type) ='PerDT-PR'][every $dt in (eusr:Key[normalize-space(@metaSchemeID) = 'DT']), $pr in (eusr:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies concat(normalize-space($dt/@schemeID),'::',normalize-space($dt),'::', normalize-space($pr/@schemeID),'::',normalize-space($pr)) = concat(normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::', normalize-space($stpr/@schemeID),'::',normalize-space($stpr))]) = 1">
          <xsl:attribute name="id">SCH-EUSR-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-13] Each combination of 'Dataset Type ID and Process ID' MUST occur only once.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(eusr:Subtotal[normalize-space(@type) !='PerDT-PR']) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(eusr:Subtotal[normalize-space(@type) !='PerDT-PR']) = 0">
          <xsl:attribute name="id">SCH-EUSR-14</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-14] Only allowed subtotal types MUST be used.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/eusr:EndUserStatisticsReport/eusr:Header" mode="M3" priority="1002">
    <svrl:fired-rule context="/eusr:EndUserStatisticsReport/eusr:Header" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(eusr:ReportPeriod/eusr:StartDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(eusr:ReportPeriod/eusr:StartDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')">
          <xsl:attribute name="id">SCH-EUSR-16</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-16] The reporting period start date (<xsl:text />
            <xsl:value-of select="normalize-space(eusr:ReportPeriod/eusr:StartDate)" />
            <xsl:text />) MUST NOT contain timezone information</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(eusr:ReportPeriod/eusr:EndDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(eusr:ReportPeriod/eusr:EndDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')">
          <xsl:attribute name="id">SCH-EUSR-17</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-17] The reporting period end date (<xsl:text />
            <xsl:value-of select="normalize-space(eusr:ReportPeriod/eusr:EndDate)" />
            <xsl:text />) MUST NOT contain timezone information</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="eusr:ReportPeriod/eusr:EndDate >= eusr:ReportPeriod/eusr:StartDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="eusr:ReportPeriod/eusr:EndDate >= eusr:ReportPeriod/eusr:StartDate">
          <xsl:attribute name="id">SCH-EUSR-18</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-18] The report period start date (<xsl:text />
            <xsl:value-of select="normalize-space(eusr:ReportPeriod/eusr:StartDate)" />
            <xsl:text />) MUST NOT be after the report period end date (<xsl:text />
            <xsl:value-of select="normalize-space(eusr:ReportPeriod/eusr:EndDate)" />
            <xsl:text />)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/eusr:EndUserStatisticsReport/eusr:Header/eusr:ReporterID" mode="M3" priority="1001">
    <svrl:fired-rule context="/eusr:EndUserStatisticsReport/eusr:Header/eusr:ReporterID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) != ''">
          <xsl:attribute name="id">SCH-EUSR-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-06] The Reporter ID MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains(normalize-space(@schemeID), ' ')) and                                                   contains($cl_spidtype, concat(' ', normalize-space(@schemeID), ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains(normalize-space(@schemeID), ' ')) and contains($cl_spidtype, concat(' ', normalize-space(@schemeID), ' '))">
          <xsl:attribute name="id">SCH-EUSR-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-07] The Reporter ID scheme ID (<xsl:text />
            <xsl:value-of select="normalize-space(@schemeID)" />
            <xsl:text />) MUST be coded according to the code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(@schemeID='CertSubjectCN' and                                                    matches(normalize-space(.), '^P[A-Z]{2}[0-9]{6}$')) or                                                    not(@schemeID='CertSubjectCN')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(@schemeID='CertSubjectCN' and matches(normalize-space(.), '^P[A-Z]{2}[0-9]{6}$')) or not(@schemeID='CertSubjectCN')">
          <xsl:attribute name="id">SCH-EUSR-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-08] The layout of the certificate subject CN (<xsl:text />
            <xsl:value-of select="normalize-space(.)" />
            <xsl:text />) is not a valid Peppol Seat ID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/eusr:EndUserStatisticsReport/eusr:Subtotal[normalize-space(@type) = 'PerDT-PR']" mode="M3" priority="1000">
    <svrl:fired-rule context="/eusr:EndUserStatisticsReport/eusr:Subtotal[normalize-space(@type) = 'PerDT-PR']" />
    <xsl:variable name="name" select="'The subtotal per Dataset Type ID and Process ID'" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(eusr:Key) = 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(eusr:Key) = 2">
          <xsl:attribute name="id">SCH-EUSR-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-09] $name MUST have two Key elements</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(eusr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(eusr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1">
          <xsl:attribute name="id">SCH-EUSR-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-10] $name MUST have one Key element with the meta scheme ID 'DT'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(eusr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(eusr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1">
          <xsl:attribute name="id">SCH-EUSR-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-EUSR-11] $name MUST have one Key element with the meta scheme ID 'PR'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M3" priority="-1" />
  <xsl:template match="@*|node()" mode="M3" priority="-2">
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
