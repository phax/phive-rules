<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:tsr="urn:fdc:peppol:transaction-statistics-report:1.0" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
    <svrl:schematron-output schemaVersion="ISO19757-3" title="OpenPeppol Transaction Statistics Reporting">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:text>
    This is the Schematron for the Peppol Transaction Statistics Reporting
    This is based on the "Internal Regulations" document,
      chapter 4.4 "Service Provider Reporting on Transaction Statistics"

    Author:
      Philip Helger

    History:
      2022-11-14, Muhammet Yildiz, Philip Helger - updates after the review
      2022-04-21, Philip Helger - initial version
  </svrl:text>
      <svrl:ns-prefix-in-attribute-values prefix="tsr" uri="urn:fdc:peppol:transaction-statistics-report:1.0" />
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
<svrl:text>OpenPeppol Transaction Statistics Reporting</svrl:text>

<!--PATTERN default-->
<xsl:variable name="cl_iso3166" select="' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI XK YE YT ZA ZM ZW '" />
  <xsl:variable name="cl_spidtype" select="' CertSubjectCN '" />
  <xsl:variable name="cl_subtotalType" select="' PerTP PerSP-DT-PR PerSP-DT-PR-CC '" />
  <xsl:variable name="re_seatid" select="'^P[A-Z]{2}[0-9]{6}$'" />

	<!--RULE -->
<xsl:template match="/tsr:TransactionStatisticsReport" mode="M3" priority="1008">
    <svrl:fired-rule context="/tsr:TransactionStatisticsReport" />
    <xsl:variable name="total" select="tsr:Total/tsr:Incoming + tsr:Total/tsr:Outgoing" />
    <xsl:variable name="empty" select="$total = 0" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(tsr:CustomizationID) = 'urn:fdc:peppol.eu:edec:trns:transaction-statistics-reporting:1.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(tsr:CustomizationID) = 'urn:fdc:peppol.eu:edec:trns:transaction-statistics-reporting:1.0'">
          <xsl:attribute name="id">SCH-TSR-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:edec:trns:transaction-statistics-reporting:1.0'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(tsr:ProfileID) = 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(tsr:ProfileID) = 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'">
          <xsl:attribute name="id">SCH-TSR-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="name_tp" select="'Transport Protocol ID'" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$empty or tsr:Subtotal[normalize-space(@type) = 'PerTP']" />
      <xsl:otherwise>
        <svrl:failed-assert test="$empty or tsr:Subtotal[normalize-space(@type) = 'PerTP']">
          <xsl:attribute name="id">SCH-TSR-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-03] The subtotals per $name_tp MUST exist</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Incoming) = tsr:Total/tsr:Incoming" />
      <xsl:otherwise>
        <svrl:failed-assert test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Incoming) = tsr:Total/tsr:Incoming">
          <xsl:attribute name="id">SCH-TSR-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-04] The sum of all subtotals per $name_tp incoming MUST match the total incoming count</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Outgoing) = tsr:Total/tsr:Outgoing" />
      <xsl:otherwise>
        <svrl:failed-assert test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Outgoing) = tsr:Total/tsr:Outgoing">
          <xsl:attribute name="id">SCH-TSR-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-05] The sum of all subtotals per $name_tp outgoing MUST match the total outgoing count</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $key in (tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Key) satisfies                                                     count(tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Key[concat(normalize-space(@schemeID),'::',normalize-space(.)) =                                                                                                                  concat(normalize-space($key/@schemeID),'::',normalize-space($key))]) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $key in (tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Key) satisfies count(tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Key[concat(normalize-space(@schemeID),'::',normalize-space(.)) = concat(normalize-space($key/@schemeID),'::',normalize-space($key))]) = 1">
          <xsl:attribute name="id">SCH-TSR-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-06] Each $name_tp MUST occur only once.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="name_spdtpr" select="'Service Provider ID, Dataset Type ID and Process ID'" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$empty or tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']" />
      <xsl:otherwise>
        <svrl:failed-assert test="$empty or tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']">
          <xsl:attribute name="id">SCH-TSR-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-07] The subtotals per $name_spdtpr MUST exist</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']/tsr:Incoming) = tsr:Total/tsr:Incoming" />
      <xsl:otherwise>
        <svrl:failed-assert test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']/tsr:Incoming) = tsr:Total/tsr:Incoming">
          <xsl:attribute name="id">SCH-TSR-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-08] The sum of all subtotals per $name_spdtpr incoming MUST match the total incoming count</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']/tsr:Outgoing) = tsr:Total/tsr:Outgoing" />
      <xsl:otherwise>
        <svrl:failed-assert test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']/tsr:Outgoing) = tsr:Total/tsr:Outgoing">
          <xsl:attribute name="id">SCH-TSR-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-09] The sum of all subtotals per $name_spdtpr outgoing MUST match the total outgoing count</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $st in (tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']),                                                        $stsp in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'SP']),                                                        $stdt in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'DT']),                                                        $stpr in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'PR'])  satisfies                                                    count(tsr:Subtotal[normalize-space(@type) ='PerSP-DT-PR'][every $sp in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']),                                                                                                                    $dt in (tsr:Key[normalize-space(@metaSchemeID) = 'DT']),                                                                                                                    $pr in (tsr:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies                                                                                                              concat(normalize-space($sp/@schemeID),'::',normalize-space($sp),'::',                                                                                                                     normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',                                                                                                                     normalize-space($pr/@schemeID),'::',normalize-space($pr)) =                                                                                                              concat(normalize-space($stsp/@schemeID),'::',normalize-space($stsp),'::',                                                                                                                     normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',                                                                                                                     normalize-space($stpr/@schemeID),'::',normalize-space($stpr))]) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $st in (tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']), $stsp in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'SP']), $stdt in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'DT']), $stpr in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies count(tsr:Subtotal[normalize-space(@type) ='PerSP-DT-PR'][every $sp in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']), $dt in (tsr:Key[normalize-space(@metaSchemeID) = 'DT']), $pr in (tsr:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies concat(normalize-space($sp/@schemeID),'::',normalize-space($sp),'::', normalize-space($dt/@schemeID),'::',normalize-space($dt),'::', normalize-space($pr/@schemeID),'::',normalize-space($pr)) = concat(normalize-space($stsp/@schemeID),'::',normalize-space($stsp),'::', normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::', normalize-space($stpr/@schemeID),'::',normalize-space($stpr))]) = 1">
          <xsl:attribute name="id">SCH-TSR-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-10] Each combination of $name_spdtpr MUST occur only once.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="name_spdtprcc" select="'Service Provider ID, Dataset Type ID, Process ID, Sender Country and Receiver Country'" />
    <xsl:variable name="cc_exists" select="tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($cc_exists) or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']/tsr:Incoming) = tsr:Total/tsr:Incoming" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($cc_exists) or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']/tsr:Incoming) = tsr:Total/tsr:Incoming">
          <xsl:attribute name="id">SCH-TSR-12</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-12] The sum of all subtotals per $name_spdtprcc incoming MUST match the total incoming count</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($cc_exists) or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']/tsr:Outgoing) = tsr:Total/tsr:Outgoing" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($cc_exists) or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']/tsr:Outgoing) = tsr:Total/tsr:Outgoing">
          <xsl:attribute name="id">SCH-TSR-13</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-13] The sum of all subtotals per $name_spdtprcc outgoing MUST match the total outgoing count</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $st in (tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']),                                                        $stsp in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'SP']),                                                        $stdt in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'DT']),                                                        $stpr in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'PR']),                                                        $stsc in ($st/tsr:Key[normalize-space(@schemeID) = 'SenderCountry']),                                                        $strc in ($st/tsr:Key[normalize-space(@schemeID) = 'ReceiverCountry']) satisfies                                                     count(tsr:Subtotal[normalize-space(@type) ='PerSP-DT-PR-CC'][every $sp in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']),                                                                                                                       $dt in (tsr:Key[normalize-space(@metaSchemeID) = 'DT']),                                                                                                                       $pr in (tsr:Key[normalize-space(@metaSchemeID) = 'PR']),                                                                                                                       $sc in (tsr:Key[normalize-space(@schemeID) = 'SenderCountry']),                                                                                                                       $rc in (tsr:Key[normalize-space(@schemeID) = 'ReceiverCountry']) satisfies                                                                                                                 concat(normalize-space($sp/@schemeID),'::',normalize-space($sp),'::',                                                                                                                        normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',                                                                                                                        normalize-space($pr/@schemeID),'::',normalize-space($pr),'::',                                                                                                                        normalize-space($sc),'::',                                                                                                                        normalize-space($rc)) =                                                                                                                  concat(normalize-space($stsp/@schemeID),'::',normalize-space($stsp),'::',                                                                                                                        normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',                                                                                                                        normalize-space($stpr/@schemeID),'::',normalize-space($stpr),'::',                                                                                                                        normalize-space($stsc),'::',                                                                                                                        normalize-space($strc))]) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $st in (tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']), $stsp in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'SP']), $stdt in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'DT']), $stpr in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'PR']), $stsc in ($st/tsr:Key[normalize-space(@schemeID) = 'SenderCountry']), $strc in ($st/tsr:Key[normalize-space(@schemeID) = 'ReceiverCountry']) satisfies count(tsr:Subtotal[normalize-space(@type) ='PerSP-DT-PR-CC'][every $sp in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']), $dt in (tsr:Key[normalize-space(@metaSchemeID) = 'DT']), $pr in (tsr:Key[normalize-space(@metaSchemeID) = 'PR']), $sc in (tsr:Key[normalize-space(@schemeID) = 'SenderCountry']), $rc in (tsr:Key[normalize-space(@schemeID) = 'ReceiverCountry']) satisfies concat(normalize-space($sp/@schemeID),'::',normalize-space($sp),'::', normalize-space($dt/@schemeID),'::',normalize-space($dt),'::', normalize-space($pr/@schemeID),'::',normalize-space($pr),'::', normalize-space($sc),'::', normalize-space($rc)) = concat(normalize-space($stsp/@schemeID),'::',normalize-space($stsp),'::', normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::', normalize-space($stpr/@schemeID),'::',normalize-space($stpr),'::', normalize-space($stsc),'::', normalize-space($strc))]) = 1">
          <xsl:attribute name="id">SCH-TSR-14</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-14] Each combination of $name_spdtprcc MUST occur only once.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Subtotal[normalize-space(@type) !='PerTP' and                                                                      normalize-space(@type) !='PerSP-DT-PR' and                                                                      normalize-space(@type) !='PerSP-DT-PR-CC']) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Subtotal[normalize-space(@type) !='PerTP' and normalize-space(@type) !='PerSP-DT-PR' and normalize-space(@type) !='PerSP-DT-PR-CC']) = 0">
          <xsl:attribute name="id">SCH-TSR-39</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-39] Only allowed subtotal types MUST be used.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/tsr:TransactionStatisticsReport/tsr:Header" mode="M3" priority="1007">
    <svrl:fired-rule context="/tsr:TransactionStatisticsReport/tsr:Header" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(tsr:ReportPeriod/tsr:StartDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(tsr:ReportPeriod/tsr:StartDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')">
          <xsl:attribute name="id">SCH-TSR-40</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-40] The report period start date (<xsl:text />
            <xsl:value-of select="normalize-space(tsr:ReportPeriod/tsr:StartDate)" />
            <xsl:text />) MUST NOT contain timezone information</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(tsr:ReportPeriod/tsr:EndDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(tsr:ReportPeriod/tsr:EndDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')">
          <xsl:attribute name="id">SCH-TSR-41</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-41] The report period end date (<xsl:text />
            <xsl:value-of select="normalize-space(tsr:ReportPeriod/tsr:EndDate)" />
            <xsl:text />) MUST NOT contain timezone information</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="tsr:ReportPeriod/tsr:EndDate >= tsr:ReportPeriod/tsr:StartDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="tsr:ReportPeriod/tsr:EndDate >= tsr:ReportPeriod/tsr:StartDate">
          <xsl:attribute name="id">SCH-TSR-42</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-42] The report period start date (<xsl:text />
            <xsl:value-of select="normalize-space(tsr:ReportPeriod/tsr:StartDate)" />
            <xsl:text />) MUST NOT be after the report period end date (<xsl:text />
            <xsl:value-of select="normalize-space(tsr:ReportPeriod/tsr:EndDate)" />
            <xsl:text />)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/tsr:TransactionStatisticsReport/tsr:Header/tsr:ReporterID" mode="M3" priority="1006">
    <svrl:fired-rule context="/tsr:TransactionStatisticsReport/tsr:Header/tsr:ReporterID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) != ''">
          <xsl:attribute name="id">SCH-TSR-16</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-16] The reporter ID MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains(normalize-space(@schemeID), ' ')) and                                               contains($cl_spidtype, concat(' ', normalize-space(@schemeID), ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains(normalize-space(@schemeID), ' ')) and contains($cl_spidtype, concat(' ', normalize-space(@schemeID), ' '))">
          <xsl:attribute name="id">SCH-TSR-17</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-17] The Reporter ID scheme (<xsl:text />
            <xsl:value-of select="normalize-space(@schemeID)" />
            <xsl:text />) MUST be coded according to the code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(@schemeID='CertSubjectCN' and                                                    matches(normalize-space(.), $re_seatid)) or                                                   not(@schemeID='CertSubjectCN')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(@schemeID='CertSubjectCN' and matches(normalize-space(.), $re_seatid)) or not(@schemeID='CertSubjectCN')">
          <xsl:attribute name="id">SCH-TSR-18</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-18] The layout of the certificate subject CN (<xsl:text />
            <xsl:value-of select="normalize-space(.)" />
            <xsl:text />) is not a valid Peppol Seat ID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/tsr:TransactionStatisticsReport/tsr:Subtotal/tsr:Key[normalize-space(@schemeID) = 'CertSubjectCN']" mode="M3" priority="1005">
    <svrl:fired-rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal/tsr:Key[normalize-space(@schemeID) = 'CertSubjectCN']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(.), $re_seatid)" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(.), $re_seatid)">
          <xsl:attribute name="id">SCH-TSR-19</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-19] The layout of the certificate subject CN is not a valid Peppol Seat ID</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/tsr:TransactionStatisticsReport/tsr:Subtotal/tsr:Key[normalize-space(@schemeID) = 'SenderCountry' or                                                                           normalize-space(@schemeID) = 'ReceiverCountry']" mode="M3" priority="1004">
    <svrl:fired-rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal/tsr:Key[normalize-space(@schemeID) = 'SenderCountry' or                                                                           normalize-space(@schemeID) = 'ReceiverCountry']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains(normalize-space(.), ' ')) and                                                      contains($cl_iso3166, concat(' ', normalize-space(.), ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains(normalize-space(.), ' ')) and contains($cl_iso3166, concat(' ', normalize-space(.), ' '))">
          <xsl:attribute name="id">SCH-TSR-20</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-20] The country code MUST be coded with ISO code ISO 3166-1 alpha-2. Nevertheless, Greece may use the code 'EL', Kosovo may use the code 'XK' or '1A'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/tsr:TransactionStatisticsReport/tsr:Subtotal[normalize-space(@type) = 'PerTP']" mode="M3" priority="1003">
    <svrl:fired-rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[normalize-space(@type) = 'PerTP']" />
    <xsl:variable name="name" select="'The subtotal per Transport Protocol ID'" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key) = 1">
          <xsl:attribute name="id">SCH-TSR-21</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-21] $name MUST have one Key element</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key[normalize-space(@metaSchemeID) = 'TP']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key[normalize-space(@metaSchemeID) = 'TP']) = 1">
          <xsl:attribute name="id">SCH-TSR-22</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-22] $name MUST have one Key element with the meta scheme ID 'TP'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key[normalize-space(@schemeID) = 'Peppol']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key[normalize-space(@schemeID) = 'Peppol']) = 1">
          <xsl:attribute name="id">SCH-TSR-23</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-23] $name MUST have one Key element with the scheme ID 'Peppol'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/tsr:TransactionStatisticsReport/tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']" mode="M3" priority="1002">
    <svrl:fired-rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']" />
    <xsl:variable name="name" select="'The subtotal per Service Provider ID, Dataset Type ID and Process ID'" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key) = 3" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key) = 3">
          <xsl:attribute name="id">SCH-TSR-24</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-24] $name MUST have three Key elements</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key[normalize-space(@metaSchemeID) = 'SP']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key[normalize-space(@metaSchemeID) = 'SP']) = 1">
          <xsl:attribute name="id">SCH-TSR-25</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-25] $name MUST have one Key element with the meta scheme ID 'SP'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1">
          <xsl:attribute name="id">SCH-TSR-26</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-26] $name MUST have one Key element with the meta scheme ID 'DT'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1">
          <xsl:attribute name="id">SCH-TSR-27</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-27] $name MUST have one Key element with the meta scheme ID 'PR'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $x in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']) satisfies                                                    not(contains(normalize-space($x/@schemeID), ' ')) and                                                     contains($cl_spidtype, concat(' ', normalize-space($x/@schemeID), ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $x in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']) satisfies not(contains(normalize-space($x/@schemeID), ' ')) and contains($cl_spidtype, concat(' ', normalize-space($x/@schemeID), ' '))">
          <xsl:attribute name="id">SCH-TSR-28</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-28] $name MUST have one SP Key element with the scheme ID coded according to the code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/tsr:TransactionStatisticsReport/tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']" mode="M3" priority="1001">
    <svrl:fired-rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']" />
    <xsl:variable name="name" select="'The subtotal per Service Provider ID, Dataset Type ID, Sender Country and Receiver Country'" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key) = 5" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key) = 5">
          <xsl:attribute name="id">SCH-TSR-29</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-29] $name MUST have five Key elements</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key[normalize-space(@metaSchemeID) = 'SP']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key[normalize-space(@metaSchemeID) = 'SP']) = 1">
          <xsl:attribute name="id">SCH-TSR-30</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-30] $name MUST have one Key element with the meta scheme ID 'SP'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1">
          <xsl:attribute name="id">SCH-TSR-31</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-31] $name MUST have one Key element with the meta scheme ID 'DT'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1">
          <xsl:attribute name="id">SCH-TSR-32</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-32] $name MUST have one Key element with the meta scheme ID 'PR'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC']) = 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC']) = 2">
          <xsl:attribute name="id">SCH-TSR-33</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-33] $name MUST have two Key elements with the meta scheme ID 'CC'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $x in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']) satisfies                                                    not(contains(normalize-space($x/@schemeID), ' ')) and                                                     contains($cl_spidtype, concat(' ', normalize-space($x/@schemeID), ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $x in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']) satisfies not(contains(normalize-space($x/@schemeID), ' ')) and contains($cl_spidtype, concat(' ', normalize-space($x/@schemeID), ' '))">
          <xsl:attribute name="id">SCH-TSR-34</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-34] $name MUST have one SP Key element with the scheme ID coded according to the code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'SenderCountry']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'SenderCountry']) = 1">
          <xsl:attribute name="id">SCH-TSR-35</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-35] $name MUST have one CC Key element with the scheme ID 'SenderCountry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'ReceiverCountry']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'ReceiverCountry']) = 1">
          <xsl:attribute name="id">SCH-TSR-36</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-36] $name MUST have one CC Key element with the scheme ID 'ReceiverCountry'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/tsr:TransactionStatisticsReport/tsr:Subtotal" mode="M3" priority="1000">
    <svrl:fired-rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains(normalize-space(@type), ' ')) and                                                  contains($cl_subtotalType, concat(' ', normalize-space(@type), ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains(normalize-space(@type), ' ')) and contains($cl_subtotalType, concat(' ', normalize-space(@type), ' '))">
          <xsl:attribute name="id">SCH-TSR-37</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SCH-TSR-37] The Subtotal type (<xsl:text />
            <xsl:value-of select="normalize-space(@type)" />
            <xsl:text />) MUST be coded according to the code list</svrl:text>
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
