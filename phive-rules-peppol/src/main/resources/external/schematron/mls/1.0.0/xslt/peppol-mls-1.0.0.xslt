<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
    <svrl:schematron-output schemaVersion="" title="OpenPeppol eDEC MLS">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:text>
    This is the Schematron for the Peppol Message Level Status (MLS).

    Author:
      Philip Helger

    History
      v1.0.0 RC1
        2025-03-12, Philip Helger - initial version
  </svrl:text>
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2" />
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
      <xsl:apply-templates mode="M5" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>OpenPeppol eDEC MLS</svrl:text>

<!--PATTERN default-->
<xsl:variable name="cl_rc" select="' AP AB RE '" />
  <xsl:variable name="cl_src" select="' BV BW FD SV '" />
  <xsl:variable name="regex_spis" select="'^[0-9]{6}(-[0-9A-Z_]{3,12}(\.[0-9A-Z\-._~]{3,24})?)?$'" />

	<!--RULE -->
<xsl:template match="/ubl:ApplicationResponse" mode="M5" priority="1005">
    <svrl:fired-rule context="/ubl:ApplicationResponse" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CustomizationID) = 'urn:peppol:edec:mls:1.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CustomizationID) = 'urn:peppol:edec:mls:1.0'">
          <xsl:attribute name="id">SCH-MLS-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-01] The customization ID MUST use the value 'urn:peppol:edec:mls:1.0'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ProfileID) = 'urn:peppol:edec:mls'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ProfileID) = 'urn:peppol:edec:mls'">
          <xsl:attribute name="id">SCH-MLS-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-02] The profile ID MUST use the value 'urn:peppol:edec:mls'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="id">SCH-MLS-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-03] The ID MUST NOT be empty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:IssueDate)) = 10" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:IssueDate)) = 10">
          <xsl:attribute name="id">SCH-MLS-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-04] The Issue Date MUST NOT contain timezone information</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:IssueTime)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:IssueTime)">
          <xsl:attribute name="id">SCH-MLS-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-05] The Issue Time MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(cbc:IssueTime), '([+-]\d{2}:\d{2}|Z)$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(cbc:IssueTime), '([+-]\d{2}:\d{2}|Z)$')">
          <xsl:attribute name="id">SCH-MLS-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-06] The Issue Time MUST contain timezone information</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:SenderParty/cbc:EndpointID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:SenderParty/cbc:EndpointID)">
          <xsl:attribute name="id">SCH-MLS-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-07] The Sender Party Endpoint ID MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:SenderParty/cbc:EndpointID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:SenderParty/cbc:EndpointID) != ''">
          <xsl:attribute name="id">SCH-MLS-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-08] The Sender Party Endpoint ID MUST NOT be empty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(cac:SenderParty/cbc:EndpointID), $regex_spis)" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(cac:SenderParty/cbc:EndpointID), $regex_spis)">
          <xsl:attribute name="id">SCH-MLS-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-09] The Sender Party Endpoint ID (<xsl:text />
            <xsl:value-of select="normalize-space(cac:SenderParty/cbc:EndpointID)" />
            <xsl:text />) MUST be a valid Peppol Service Provider ID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:SenderParty/cbc:EndpointID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:SenderParty/cbc:EndpointID/@schemeID)">
          <xsl:attribute name="id">SCH-MLS-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-10] The Sender Party Endpoint ID scheme ID MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(cac:SenderParty/cbc:EndpointID/@schemeID), '^[0-9]{4}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(cac:SenderParty/cbc:EndpointID/@schemeID), '^[0-9]{4}$')">
          <xsl:attribute name="id">SCH-MLS-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-11] The Sender Party Endpoint ID scheme ID MUST be a valid Participant Identifier Scheme</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:ReceiverParty/cbc:EndpointID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:ReceiverParty/cbc:EndpointID)">
          <xsl:attribute name="id">SCH-MLS-12</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-12] The Receiver Party Endpoint ID MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:ReceiverParty/cbc:EndpointID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:ReceiverParty/cbc:EndpointID) != ''">
          <xsl:attribute name="id">SCH-MLS-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-13] The Receiver Party Endpoint ID MUST NOT be empty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(cac:ReceiverParty/cbc:EndpointID), $regex_spis)" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(cac:ReceiverParty/cbc:EndpointID), $regex_spis)">
          <xsl:attribute name="id">SCH-MLS-14</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-14] The Receiver Party Endpoint ID (<xsl:text />
            <xsl:value-of select="normalize-space(cac:ReceiverParty/cbc:EndpointID)" />
            <xsl:text />) MUST be a valid Peppol Service Provider ID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:ReceiverParty/cbc:EndpointID/@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:ReceiverParty/cbc:EndpointID/@schemeID)">
          <xsl:attribute name="id">SCH-MLS-15</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-15] The Receiver Party Endpoint ID scheme ID MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(cac:ReceiverParty/cbc:EndpointID/@schemeID), '^[0-9]{4}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(cac:ReceiverParty/cbc:EndpointID/@schemeID), '^[0-9]{4}$')">
          <xsl:attribute name="id">SCH-MLS-16</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-16] The Receiver Party Endpoint ID scheme ID MUST be a valid Participant Identifier Scheme</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:DocumentResponse) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:DocumentResponse) = 1">
          <xsl:attribute name="id">SCH-MLS-17</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-17] Exactly one Document Response MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M5" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse" mode="M5" priority="1004">
    <svrl:fired-rule context="/ubl:ApplicationResponse/cac:DocumentResponse" />
    <xsl:variable name="rc" select="normalize-space(cac:Response/cbc:ResponseCode)" />
    <xsl:variable name="has_bv" select="exists(cac:LineResponse[cac:Response[normalize-space(cac:Status/cbc:StatusReasonCode) = 'BV']])" />
    <xsl:variable name="has_fd" select="exists(cac:LineResponse[cac:Response[normalize-space(cac:Status/cbc:StatusReasonCode) = 'FD']])" />
    <xsl:variable name="has_sv" select="exists(cac:LineResponse[cac:Response[normalize-space(cac:Status/cbc:StatusReasonCode) = 'SV']])" />
    <xsl:variable name="has_failure" select="$has_bv or $has_fd or $has_sv" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:Response/cbc:ResponseCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Response/cbc:ResponseCode)">
          <xsl:attribute name="id">SCH-MLS-18</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-18] The Overall Response Code MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains($rc, ' ')) and contains($cl_rc, concat(' ', $rc, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains($rc, ' ')) and contains($cl_rc, concat(' ', $rc, ' '))">
          <xsl:attribute name="id">SCH-MLS-19</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-19] The Response Code (<xsl:text />
            <xsl:value-of select="$rc" />
            <xsl:text />) MUST be coded according to the code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$rc != 'RE' or                                                  exists(cac:Response/cbc:Description)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$rc != 'RE' or exists(cac:Response/cbc:Description)">
          <xsl:attribute name="id">SCH-MLS-20</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-20] A negative MLS MUST contain a Description</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$rc != 'RE' or                                                  normalize-space(cac:Response/cbc:Description) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="$rc != 'RE' or normalize-space(cac:Response/cbc:Description) != ''">
          <xsl:attribute name="id">SCH-MLS-21</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-21] A negative MLS MUST contain a non-empty Description</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:DocumentReference) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:DocumentReference) = 1">
          <xsl:attribute name="id">SCH-MLS-22</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-22] Exactly one Document Reference MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$rc != 'RE' or                                                   exists(cac:LineResponse)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$rc != 'RE' or exists(cac:LineResponse)">
          <xsl:attribute name="id">SCH-MLS-23</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-23] A negative MLS MUST contain at least one Issue</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$rc != 'RE' or $has_failure" />
      <xsl:otherwise>
        <svrl:failed-assert test="$rc != 'RE' or $has_failure">
          <xsl:attribute name="id">SCH-MLS-24</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-24] A negative MLS MUST contain at least one Issue with a failure</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$rc = 'RE' or not($has_failure)" />
      <xsl:otherwise>
        <svrl:failed-assert test="$rc = 'RE' or not($has_failure)">
          <xsl:attribute name="id">SCH-MLS-25</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-25] A positive MLS MUST NOT contain Issues with failures</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M5" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference" mode="M5" priority="1003">
    <svrl:fired-rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="id">SCH-MLS-26</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-26] The Referenced Document ID MUST NOT be empty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M5" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse" mode="M5" priority="1002">
    <svrl:fired-rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:LineReference/cbc:LineID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:LineReference/cbc:LineID) != ''">
          <xsl:attribute name="id">SCH-MLS-27</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-27] The Issue Location MUST NOT be empty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M5" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response" mode="M5" priority="1001">
    <svrl:fired-rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:Description)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:Description)">
          <xsl:attribute name="id">SCH-MLS-28</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-28] The Issue Description MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:Description) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:Description) != ''">
          <xsl:attribute name="id">SCH-MLS-29</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-29] The Issue Description MUST NOT be empty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:Status)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Status)">
          <xsl:attribute name="id">SCH-MLS-30</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-30] The Status element MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M5" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status" mode="M5" priority="1000">
    <svrl:fired-rule context="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status" />
    <xsl:variable name="src" select="normalize-space(cbc:StatusReasonCode)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains($src, ' ')) and contains($cl_src, concat(' ', $src, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains($src, ' ')) and contains($cl_src, concat(' ', $src, ' '))">
          <xsl:attribute name="id">SCH-MLS-31</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-MLS-31] The Status Reason Code (<xsl:text />
            <xsl:value-of select="$src" />
            <xsl:text />) MUST be coded according to the code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M5" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M5" priority="-1" />
  <xsl:template match="@*|node()" mode="M5" priority="-2">
    <xsl:apply-templates mode="M5" select="*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
