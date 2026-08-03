<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
  <!--Strip characters-->
  <xsl:template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<xsl:template match="/">
    <svrl:schematron-output schemaVersion="ISO19757-3" title="PPF — Flux 10 e-reporting — v1.8">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSMISSION-G1.104</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSMISSION-G1.104</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M1" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSMISSION-G7.53</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSMISSION-G7.53</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M2" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSMISSION-G8.01</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSMISSION-G8.01</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M3" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSMISSION-G6.29</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSMISSION-G6.29</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M4" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-EMETTEUR-G6.22</xsl:attribute>
        <xsl:attribute name="name">F10-EMETTEUR-G6.22</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M5" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-EMETTEUR-G7.51</xsl:attribute>
        <xsl:attribute name="name">F10-EMETTEUR-G7.51</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M6" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-DECLARANT-G6.26</xsl:attribute>
        <xsl:attribute name="name">F10-DECLARANT-G6.26</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M7" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-DECLARANT-G7.52</xsl:attribute>
        <xsl:attribute name="name">F10-DECLARANT-G7.52</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M8" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PERIODE-TX-G1.09a</xsl:attribute>
        <xsl:attribute name="name">F10-PERIODE-TX-G1.09a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M9" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PERIODE-TX-G1.09b</xsl:attribute>
        <xsl:attribute name="name">F10-PERIODE-TX-G1.09b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M10" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PERIODE-TX-G6.25</xsl:attribute>
        <xsl:attribute name="name">F10-PERIODE-TX-G6.25</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M11" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-G1.01</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-G1.01</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M12" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-G1.02</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-G1.02</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M13" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-G1.60</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-G1.60</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M14" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-S1.12</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-S1.12</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M15" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-G1.05a</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-G1.05a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M16" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-G1.09a</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-G1.09a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M17" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-G1.09b</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-G1.09b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M18" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-P1.11</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-P1.11</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M19" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-G6.21</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-G6.21</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M20" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-G1.32a</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-G1.32a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M21" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-G1.32b</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-G1.32b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M22" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-G6.28</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-G6.28</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M23" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-G1.09c</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-G1.09c</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M24" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-FACTURE-G1.05b</xsl:attribute>
        <xsl:attribute name="name">F10-FACTURE-G1.05b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M25" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-VENDEUR-G2.19a</xsl:attribute>
        <xsl:attribute name="name">F10-VENDEUR-G2.19a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M26" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-VENDEUR-G2.19b</xsl:attribute>
        <xsl:attribute name="name">F10-VENDEUR-G2.19b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M27" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-VENDEUR-G2.19c</xsl:attribute>
        <xsl:attribute name="name">F10-VENDEUR-G2.19c</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M28" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-VENDEUR-G2.19d</xsl:attribute>
        <xsl:attribute name="name">F10-VENDEUR-G2.19d</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M29" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-VENDEUR-G2.19e</xsl:attribute>
        <xsl:attribute name="name">F10-VENDEUR-G2.19e</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M30" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-VENDEUR-G2.19f</xsl:attribute>
        <xsl:attribute name="name">F10-VENDEUR-G2.19f</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M31" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-VENDEUR-G2.33a</xsl:attribute>
        <xsl:attribute name="name">F10-VENDEUR-G2.33a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M32" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-VENDEUR-G2.33b</xsl:attribute>
        <xsl:attribute name="name">F10-VENDEUR-G2.33b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M33" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-VENDEUR-G1.102</xsl:attribute>
        <xsl:attribute name="name">F10-VENDEUR-G1.102</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M34" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-VENDEUR-G2.01</xsl:attribute>
        <xsl:attribute name="name">F10-VENDEUR-G2.01</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M35" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-ACHETEUR-G2.19a</xsl:attribute>
        <xsl:attribute name="name">F10-ACHETEUR-G2.19a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M36" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-ACHETEUR-G2.19b</xsl:attribute>
        <xsl:attribute name="name">F10-ACHETEUR-G2.19b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M37" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-ACHETEUR-G2.19c</xsl:attribute>
        <xsl:attribute name="name">F10-ACHETEUR-G2.19c</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M38" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-ACHETEUR-G2.19d</xsl:attribute>
        <xsl:attribute name="name">F10-ACHETEUR-G2.19d</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M39" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-ACHETEUR-G2.19e</xsl:attribute>
        <xsl:attribute name="name">F10-ACHETEUR-G2.19e</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M40" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-ACHETEUR-G2.19f</xsl:attribute>
        <xsl:attribute name="name">F10-ACHETEUR-G2.19f</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M41" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-ACHETEUR-G2.33a</xsl:attribute>
        <xsl:attribute name="name">F10-ACHETEUR-G2.33a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M42" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-ACHETEUR-G2.33b</xsl:attribute>
        <xsl:attribute name="name">F10-ACHETEUR-G2.33b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M43" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-ACHETEUR-G2.01</xsl:attribute>
        <xsl:attribute name="name">F10-ACHETEUR-G2.01</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M44" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIVRAISON-G1.09</xsl:attribute>
        <xsl:attribute name="name">F10-LIVRAISON-G1.09</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M45" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIVRAISON-G2.01</xsl:attribute>
        <xsl:attribute name="name">F10-LIVRAISON-G2.01</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M46" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PERIODE-FAC-G1.09a</xsl:attribute>
        <xsl:attribute name="name">F10-PERIODE-FAC-G1.09a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M47" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PERIODE-FAC-G1.09b</xsl:attribute>
        <xsl:attribute name="name">F10-PERIODE-FAC-G1.09b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M48" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PERIODE-FAC-G6.25</xsl:attribute>
        <xsl:attribute name="name">F10-PERIODE-FAC-G6.25</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M49" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-REMISE-G2.31</xsl:attribute>
        <xsl:attribute name="name">F10-REMISE-G2.31</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M50" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-REMISE-G1.24</xsl:attribute>
        <xsl:attribute name="name">F10-REMISE-G1.24</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M51" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-REMISE-G1.14</xsl:attribute>
        <xsl:attribute name="name">F10-REMISE-G1.14</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M52" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TOTAL-G1.14a</xsl:attribute>
        <xsl:attribute name="name">F10-TOTAL-G1.14a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M53" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TOTAL-TAXAMOUNT</xsl:attribute>
        <xsl:attribute name="name">F10-TOTAL-TAXAMOUNT</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M54" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TOTAL-G1.53</xsl:attribute>
        <xsl:attribute name="name">F10-TOTAL-G1.53</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M55" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TVA-G2.31</xsl:attribute>
        <xsl:attribute name="name">F10-TVA-G2.31</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M56" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TVA-G1.24</xsl:attribute>
        <xsl:attribute name="name">F10-TVA-G1.24</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M57" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TVA-G1.40</xsl:attribute>
        <xsl:attribute name="name">F10-TVA-G1.40</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M58" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TVA-G1.14a</xsl:attribute>
        <xsl:attribute name="name">F10-TVA-G1.14a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M59" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TVA-G1.14b</xsl:attribute>
        <xsl:attribute name="name">F10-TVA-G1.14b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M60" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIGNE-G1.09a</xsl:attribute>
        <xsl:attribute name="name">F10-LIGNE-G1.09a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M61" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIGNE-G1.09b</xsl:attribute>
        <xsl:attribute name="name">F10-LIGNE-G1.09b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M62" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIGNE-G6.25</xsl:attribute>
        <xsl:attribute name="name">F10-LIGNE-G6.25</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M63" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIGNE-G2.01</xsl:attribute>
        <xsl:attribute name="name">F10-LIGNE-G2.01</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M64" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIGNE-G1.14</xsl:attribute>
        <xsl:attribute name="name">F10-LIGNE-G1.14</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M65" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIGNE-G1.15</xsl:attribute>
        <xsl:attribute name="name">F10-LIGNE-G1.15</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M66" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIGNE-G1.16a</xsl:attribute>
        <xsl:attribute name="name">F10-LIGNE-G1.16a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M67" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIGNE-G1.16b</xsl:attribute>
        <xsl:attribute name="name">F10-LIGNE-G1.16b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M68" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIGNE-G1.16c</xsl:attribute>
        <xsl:attribute name="name">F10-LIGNE-G1.16c</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M69" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIGNE-G1.55</xsl:attribute>
        <xsl:attribute name="name">F10-LIGNE-G1.55</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M70" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIGNE-G1.09c</xsl:attribute>
        <xsl:attribute name="name">F10-LIGNE-G1.09c</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M71" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-LIGNE-G1.05</xsl:attribute>
        <xsl:attribute name="name">F10-LIGNE-G1.05</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M72" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSAC-G1.09</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSAC-G1.09</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M73" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSAC-G1.68</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSAC-G1.68</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M74" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSAC-P1.11</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSAC-P1.11</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M75" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSAC-G1.24b</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSAC-G1.24b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M76" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSAC-G1.14a</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSAC-G1.14a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M77" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSAC-G1.14b</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSAC-G1.14b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M78" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSAC-G1.14c</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSAC-G1.14c</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M79" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSAC-G1.14d</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSAC-G1.14d</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M80" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TRANSAC-G1.53</xsl:attribute>
        <xsl:attribute name="name">F10-TRANSAC-G1.53</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M81" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PERIODE-PMT-G1.09a</xsl:attribute>
        <xsl:attribute name="name">F10-PERIODE-PMT-G1.09a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M82" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PERIODE-PMT-G1.09b</xsl:attribute>
        <xsl:attribute name="name">F10-PERIODE-PMT-G1.09b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M83" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PERIODE-PMT-G6.25</xsl:attribute>
        <xsl:attribute name="name">F10-PERIODE-PMT-G6.25</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M84" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PMT-FACTURE-G1.05</xsl:attribute>
        <xsl:attribute name="name">F10-PMT-FACTURE-G1.05</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M85" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PMT-FACTURE-G1.09</xsl:attribute>
        <xsl:attribute name="name">F10-PMT-FACTURE-G1.09</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M86" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PMT-ENCAISSEMENT-G1.09</xsl:attribute>
        <xsl:attribute name="name">F10-PMT-ENCAISSEMENT-G1.09</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M87" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PMT-ENCAISSEMENT-G1.24</xsl:attribute>
        <xsl:attribute name="name">F10-PMT-ENCAISSEMENT-G1.24</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M88" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PMT-ENCAISSEMENT-G6.27a</xsl:attribute>
        <xsl:attribute name="name">F10-PMT-ENCAISSEMENT-G6.27a</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M89" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PMT-ENCAISSEMENT-G1.16</xsl:attribute>
        <xsl:attribute name="name">F10-PMT-ENCAISSEMENT-G1.16</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M90" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PMT-AGREGE-G1.09</xsl:attribute>
        <xsl:attribute name="name">F10-PMT-AGREGE-G1.09</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M91" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PMT-AGREGE-G1.24</xsl:attribute>
        <xsl:attribute name="name">F10-PMT-AGREGE-G1.24</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M92" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PMT-AGREGE-G6.27b</xsl:attribute>
        <xsl:attribute name="name">F10-PMT-AGREGE-G6.27b</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M93" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PMT-AGREGE-G1.16</xsl:attribute>
        <xsl:attribute name="name">F10-PMT-AGREGE-G1.16</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M94" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-PMT-DEVISE-G1.10</xsl:attribute>
        <xsl:attribute name="name">F10-PMT-DEVISE-G1.10</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M95" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F10-TX-DEVISE-G1.10</xsl:attribute>
        <xsl:attribute name="name">F10-TX-DEVISE-G1.10</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M96" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>PPF — Flux 10 e-reporting — v1.8</svrl:text>

<!--PATTERN F10-TRANSMISSION-G1.104-->


	<!--RULE -->
<xsl:template match="/Report/ReportDocument/Id" mode="M1" priority="1000">
    <svrl:fired-rule context="/Report/ReportDocument/Id" />
    <xsl:variable name="v" select="string(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length($v) &lt;= 50" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length($v) &lt;= 50">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.104] L'identifiant de transmission ne peut pas dépasser 50 caractères. | Source : Annexe 7 v1.8 G1.104</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with($v, ' ') or ends-with($v, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with($v, ' ') or ends-with($v, ' '))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.104] L'identifiant de transmission ne peut pas commencer ni terminer par un espace. | Source : Annexe 7 v1.8 G1.104</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains($v, '  '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains($v, ' '))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.104] L'identifiant de transmission ne peut pas contenir d'espaces consécutifs. | Source : Annexe 7 v1.8 G1.104</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.104] L'identifiant de transmission contient des caractères non autorisés. | Source : Annexe 7 v1.8 G1.104</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M1" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M1" priority="-1" />
  <xsl:template match="@*|node()" mode="M1" priority="-2">
    <xsl:apply-templates mode="M1" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TRANSMISSION-G7.53-->


	<!--RULE -->
<xsl:template match="/Report/ReportDocument/IssueDateTime/DateTimeString" mode="M2" priority="1000">
    <svrl:fired-rule context="/Report/ReportDocument/IssueDateTime/DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{14}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{14}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G7.53] La date-heure de transmission doit être au format AAAAMMJJHHMMSS. | Source : Annexe 7 v1.8 G7.53</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{14}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{14}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date-heure de transmission doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M2" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M2" priority="-1" />
  <xsl:template match="@*|node()" mode="M2" priority="-2">
    <xsl:apply-templates mode="M2" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TRANSMISSION-G8.01-->


	<!--RULE -->
<xsl:template match="/Report/ReportDocument/TypeCode" mode="M3" priority="1000">
    <svrl:fired-rule context="/Report/ReportDocument/TypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('IN', 'RE')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('IN', 'RE')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G8.01] Le type de transmission doit être IN (initiale) ou RE (rectificative). | Source : Annexe 7 v1.8 G8.01</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M3" priority="-1" />
  <xsl:template match="@*|node()" mode="M3" priority="-2">
    <xsl:apply-templates mode="M3" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TRANSMISSION-G6.29-->


	<!--RULE -->
<xsl:template match="/Report/ReportDocument" mode="M4" priority="1000">
    <svrl:fired-rule context="/Report/ReportDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count((/Report/TransactionsReport, /Report/PaymentsReport)) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count((/Report/TransactionsReport, /Report/PaymentsReport)) = 1">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.29] La transmission doit contenir exactement un rapport : soit un rapport de transactions (TB-2), soit un rapport de paiements (TB-3), mais pas les deux. | Source : Annexe 7 v1.8 G6.29</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M4" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M4" priority="-1" />
  <xsl:template match="@*|node()" mode="M4" priority="-2">
    <xsl:apply-templates mode="M4" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-EMETTEUR-G6.22-->


	<!--RULE -->
<xsl:template match="/Report/ReportDocument/Sender/Id" mode="M5" priority="1000">
    <svrl:fired-rule context="/Report/ReportDocument/Sender/Id" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeId = '0238'" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeId = '0238'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.22] Le type d'identifiant de l'émetteur doit être 0238 (plateforme agréée). | Source : Annexe 7 v1.8 G6.22</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) = 4" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) = 4">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.22] Le matricule de la plateforme émettrice doit comporter exactement 4 caractères. | Source : Annexe 7 v1.8 G6.22</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M5" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M5" priority="-1" />
  <xsl:template match="@*|node()" mode="M5" priority="-2">
    <xsl:apply-templates mode="M5" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-EMETTEUR-G7.51-->


	<!--RULE -->
<xsl:template match="/Report/ReportDocument/Sender/RoleCode" mode="M6" priority="1000">
    <svrl:fired-rule context="/Report/ReportDocument/Sender/RoleCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = 'WK'" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = 'WK'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G7.51] Le code rôle de l'émetteur doit être WK (plateforme agréée). | Source : Annexe 7 v1.8 G7.51</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M6" priority="-1" />
  <xsl:template match="@*|node()" mode="M6" priority="-2">
    <xsl:apply-templates mode="M6" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-DECLARANT-G6.26-->


	<!--RULE -->
<xsl:template match="/Report/ReportDocument/Issuer/Id" mode="M7" priority="1000">
    <svrl:fired-rule context="/Report/ReportDocument/Issuer/Id" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeId = '0002'" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeId = '0002'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.26] Le type d'identifiant du déclarant doit être 0002 (SIREN). | Source : Annexe 7 v1.8 G6.26</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{9}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{9}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.26] Le SIREN du déclarant doit comporter exactement 9 caractères numériques. | Source : Annexe 7 v1.8 G6.26</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M7" priority="-1" />
  <xsl:template match="@*|node()" mode="M7" priority="-2">
    <xsl:apply-templates mode="M7" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-DECLARANT-G7.52-->


	<!--RULE -->
<xsl:template match="/Report/ReportDocument/Issuer/RoleCode" mode="M8" priority="1000">
    <svrl:fired-rule context="/Report/ReportDocument/Issuer/RoleCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('BY', 'SE')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('BY', 'SE')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G7.52] Le code rôle du déclarant doit être BY (acheteur) ou SE (vendeur). | Source : Annexe 7 v1.8 G7.52</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M8" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M8" priority="-1" />
  <xsl:template match="@*|node()" mode="M8" priority="-2">
    <xsl:apply-templates mode="M8" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PERIODE-TX-G1.09a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/ReportPeriod/StartDate" mode="M9" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/ReportPeriod/StartDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : la date de début de période de transmission doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : l'année doit être comprise entre 2000 et 2099 (début période transmission). | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M9" priority="-1" />
  <xsl:template match="@*|node()" mode="M9" priority="-2">
    <xsl:apply-templates mode="M9" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PERIODE-TX-G1.09b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/ReportPeriod/EndDate" mode="M10" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/ReportPeriod/EndDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : la date de fin de période de transmission doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : l'année doit être comprise entre 2000 et 2099 (fin période transmission). | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PERIODE-TX-G6.25-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/ReportPeriod[StartDate and EndDate]" mode="M11" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/ReportPeriod[StartDate and EndDate]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="EndDate > StartDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="EndDate > StartDate">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.25] La date de fin de période de transmission ne peut pas être antérieure ou égale à la date de début. | Source : Annexe 7 v1.8 G6.25</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M11" priority="-1" />
  <xsl:template match="@*|node()" mode="M11" priority="-2">
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-G1.01-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/TypeCode" mode="M12" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/TypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('261','380','381','384','386','389','393','396','471','472','473','500','501','502','503')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('261','380','381','384','386','389','393','396','471','472','473','500','501','502','503')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.01] Le type de facture n'est pas autorisé par le PPF. | Source : Annexe 7 v1.8 G1.01</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-G1.02-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/BusinessProcess/ID" mode="M13" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/BusinessProcess/ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('B1','S1','M1','B2','S2','M2','B4','S4','M4','S5','S6','B7','S7')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('B1','S1','M1','B2','S2','M2','B4','S4','M4','S5','S6','B7','S7')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.02] Le cadre de facturation n'est pas autorisé. | Source : Annexe 7 v1.8 G1.02</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-G1.60-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice" mode="M14" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(BusinessProcess/ID = ('B4','S4','M4') and                         TypeCode = ('386','500','503'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(BusinessProcess/ID = ('B4','S4','M4') and TypeCode = ('386','500','503'))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.60] Le type de facture est incompatible avec le cadre de facturation (acomptes interdits avec B4/S4/M4). | Source : Annexe 7 v1.8 G1.60</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-S1.12-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/BusinessProcess/TypeID" mode="M15" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/BusinessProcess/TypeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = 'urn.cpro.gouv.fr:1p0:ereporting'" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = 'urn.cpro.gouv.fr:1p0:ereporting'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[S1.12] L'identifiant de profil doit être urn.cpro.gouv.fr:1p0:ereporting. | Source : Annexe 7 v1.8 S1.12</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M15" priority="-1" />
  <xsl:template match="@*|node()" mode="M15" priority="-2">
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-G1.05a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/ID" mode="M16" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/ID" />
    <xsl:variable name="v" select="string(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length($v) &lt;= 35" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length($v) &lt;= 35">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de facture ne peut pas dépasser 35 caractères. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with($v, ' ') or ends-with($v, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with($v, ' ') or ends-with($v, ' '))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de facture ne peut pas commencer ni terminer par un espace. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains($v, '  '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains($v, ' '))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de facture ne peut pas contenir d'espaces consécutifs. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de facture contient des caractères non autorisés. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M16" priority="-1" />
  <xsl:template match="@*|node()" mode="M16" priority="-2">
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-G1.09a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/IssueDate" mode="M17" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/IssueDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date d'émission de la facture doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date d'émission de la facture doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M17" priority="-1" />
  <xsl:template match="@*|node()" mode="M17" priority="-2">
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-G1.09b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/DueDate" mode="M18" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/DueDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date d'échéance de la facture doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date d'échéance de la facture doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M18" priority="-1" />
  <xsl:template match="@*|node()" mode="M18" priority="-2">
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-P1.11-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/TaxDueDateTypeCode" mode="M19" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/TaxDueDateTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('5','29','72','3','35','432')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('5','29','72','3','35','432')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[P1.11] Le code d'exigibilité de la TVA doit appartenir à UNTDID 2475 (5, 29, 72) ou UNTDID 2005 (3, 35, 432). | Source : Annexe 7 v1.8 P1.11</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M19" priority="-1" />
  <xsl:template match="@*|node()" mode="M19" priority="-2">
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-G6.21-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice" mode="M20" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(TaxSubTotal/TaxCategory/TaxExemptionReasonCode = 'VATEX-FR-CNWVAT')                     or TypeCode = ('261','381','396')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(TaxSubTotal/TaxCategory/TaxExemptionReasonCode = 'VATEX-FR-CNWVAT') or TypeCode = ('261','381','396')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.21] Le code VATEX-FR-CNWVAT est réservé aux avoirs (types 261, 381, 396). | Source : Annexe 7 v1.8 G6.21</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M20" priority="-1" />
  <xsl:template match="@*|node()" mode="M20" priority="-2">
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-G1.32a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice[TypeCode = ('384','471','472','473')]" mode="M21" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice[TypeCode = ('384','471','472','473')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ReferencedDocument) = 1 and ReferencedDocument/IssueDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ReferencedDocument) = 1 and ReferencedDocument/IssueDate">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.32] Une facture rectificative doit comporter une et une seule référence de facture antérieure avec sa date. | Source : Annexe 7 v1.8 G1.32</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M21" priority="-1" />
  <xsl:template match="@*|node()" mode="M21" priority="-2">
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-G1.32b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice[TypeCode = ('261','381','396','502','503')]" mode="M22" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice[TypeCode = ('261','381','396','502','503')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(ReferencedDocument) >= 1 and ReferencedDocument/IssueDate)                     or (exists(Line) and                         (every $l in Line satisfies                            (exists($l/ReferencedDocument/ID) and                            exists($l/ReferencedDocument/IssueDate))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(ReferencedDocument) >= 1 and ReferencedDocument/IssueDate) or (exists(Line) and (every $l in Line satisfies (exists($l/ReferencedDocument/ID) and exists($l/ReferencedDocument/IssueDate))))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.32] Un avoir doit comporter au moins une référence de facture antérieure avec sa date, en entête ou sur chaque ligne. | Source : Annexe 7 v1.8 G1.32</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M22" priority="-1" />
  <xsl:template match="@*|node()" mode="M22" priority="-2">
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-G6.28-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice" mode="M23" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="Buyer/CompanyId" />
      <xsl:otherwise>
        <svrl:failed-assert test="Buyer/CompanyId">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.28] L'identifiant de l'acheteur est obligatoire pour une transmission B2B international. | Source : Annexe 7 v1.8 G6.28</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M23" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M23" priority="-1" />
  <xsl:template match="@*|node()" mode="M23" priority="-2">
    <xsl:apply-templates mode="M23" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-G1.09c-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/ReferencedDocument/IssueDate" mode="M24" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/ReferencedDocument/IssueDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date de la facture antérieure doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date de la facture antérieure doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M24" priority="-1" />
  <xsl:template match="@*|node()" mode="M24" priority="-2">
    <xsl:apply-templates mode="M24" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-FACTURE-G1.05b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/ReferencedDocument/ID" mode="M25" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/ReferencedDocument/ID" />
    <xsl:variable name="v" select="string(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length($v) &lt;= 35" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length($v) &lt;= 35">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de la facture antérieure ne peut pas dépasser 35 caractères. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with($v, ' ') or ends-with($v, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with($v, ' ') or ends-with($v, ' '))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de la facture antérieure ne peut pas commencer ni terminer par un espace. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains($v, '  '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains($v, ' '))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de la facture antérieure ne peut pas contenir d'espaces consécutifs. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de la facture antérieure contient des caractères non autorisés. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M25" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M25" priority="-1" />
  <xsl:template match="@*|node()" mode="M25" priority="-2">
    <xsl:apply-templates mode="M25" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-VENDEUR-G2.19a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Seller/CompanyId" mode="M26" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Seller/CompanyId" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeId = ('0002','0223','0227','0228','0229')" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeId = ('0002','0223','0227','0228','0229')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] Le type d'identifiant du vendeur doit être 0002, 0223, 0227, 0228 ou 0229. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M26" priority="-1" />
  <xsl:template match="@*|node()" mode="M26" priority="-2">
    <xsl:apply-templates mode="M26" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-VENDEUR-G2.19b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0002']" mode="M27" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0002']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{9}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{9}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant vendeur de type 0002 (SIREN) doit comporter exactement 9 chiffres. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M27" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M27" priority="-1" />
  <xsl:template match="@*|node()" mode="M27" priority="-2">
    <xsl:apply-templates mode="M27" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-VENDEUR-G2.19c-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0223']" mode="M28" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0223']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) &lt;= 18" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) &lt;= 18">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant vendeur de type 0223 (UE_HORS_FRANCE) ne peut pas dépasser 18 caractères. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M28" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M28" priority="-1" />
  <xsl:template match="@*|node()" mode="M28" priority="-2">
    <xsl:apply-templates mode="M28" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-VENDEUR-G2.19d-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0227']" mode="M29" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0227']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) &lt;= 18" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) &lt;= 18">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant vendeur de type 0227 (HORS_UE) ne peut pas dépasser 18 caractères. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M29" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M29" priority="-1" />
  <xsl:template match="@*|node()" mode="M29" priority="-2">
    <xsl:apply-templates mode="M29" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-VENDEUR-G2.19e-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0228']" mode="M30" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0228']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{9,10}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{9,10}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant vendeur de type 0228 (RIDET) doit comporter 9 ou 10 chiffres. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M30" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M30" priority="-1" />
  <xsl:template match="@*|node()" mode="M30" priority="-2">
    <xsl:apply-templates mode="M30" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-VENDEUR-G2.19f-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0229']" mode="M31" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Seller/CompanyId[@schemeId = '0229']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{9}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{9}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant vendeur de type 0229 (TAHITI) doit comporter exactement 9 chiffres. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M31" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M31" priority="-1" />
  <xsl:template match="@*|node()" mode="M31" priority="-2">
    <xsl:apply-templates mode="M31" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-VENDEUR-G2.33a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Seller[CompanyId/@schemeId = ('0002','0223')]" mode="M32" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Seller[CompanyId/@schemeId = ('0002','0223')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="TaxRegistrationId" />
      <xsl:otherwise>
        <svrl:failed-assert test="TaxRegistrationId">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.33] L'identifiant TVA du vendeur est obligatoire quand le type d'identifiant est 0002 ou 0223. | Source : Annexe 7 v1.8 G2.33</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M32" priority="-1" />
  <xsl:template match="@*|node()" mode="M32" priority="-2">
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-VENDEUR-G2.33b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Seller/TaxRegistrationId" mode="M33" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Seller/TaxRegistrationId" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@qualifyingId = 'VAT'" />
      <xsl:otherwise>
        <svrl:failed-assert test="@qualifyingId = 'VAT'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.33] Le qualifiant de l'identifiant TVA du vendeur doit être VAT. | Source : Annexe 7 v1.8 G2.33</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M33" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M33" priority="-1" />
  <xsl:template match="@*|node()" mode="M33" priority="-2">
    <xsl:apply-templates mode="M33" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-VENDEUR-G1.102-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice[TaxSubTotal/TaxCategory/Code = 'E']" mode="M34" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice[TaxSubTotal/TaxCategory/Code = 'E']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="Seller/TaxRegistrationId or                     SellerTaxRepresentative/TaxRegistrationId" />
      <xsl:otherwise>
        <svrl:failed-assert test="Seller/TaxRegistrationId or SellerTaxRepresentative/TaxRegistrationId">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.102] L'identifiant TVA du vendeur ou du représentant fiscal est obligatoire quand un code de catégorie TVA "E" est présent. | Source : Annexe 7 v1.8 G1.102</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M34" priority="-1" />
  <xsl:template match="@*|node()" mode="M34" priority="-2">
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-VENDEUR-G2.01-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Seller/PostalAddress/CountryId" mode="M35" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Seller/PostalAddress/CountryId" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^[A-Z]{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^[A-Z]{2}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.01] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit être au format ISO 3166 alpha-2 (existence dans le référentiel non contrôlée). | Source : Annexe 7 v1.8 G2.01</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M35" priority="-1" />
  <xsl:template match="@*|node()" mode="M35" priority="-2">
    <xsl:apply-templates mode="M35" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-ACHETEUR-G2.19a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Buyer/CompanyId" mode="M36" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Buyer/CompanyId" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeId = ('0002','0223','0227','0228','0229')" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeId = ('0002','0223','0227','0228','0229')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] Le type d'identifiant de l'acheteur doit être 0002, 0223, 0227, 0228 ou 0229. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M36" priority="-1" />
  <xsl:template match="@*|node()" mode="M36" priority="-2">
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-ACHETEUR-G2.19b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0002']" mode="M37" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0002']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{9}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{9}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant acheteur de type 0002 (SIREN) doit comporter exactement 9 chiffres. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M37" priority="-1" />
  <xsl:template match="@*|node()" mode="M37" priority="-2">
    <xsl:apply-templates mode="M37" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-ACHETEUR-G2.19c-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0223']" mode="M38" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0223']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) &lt;= 18" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) &lt;= 18">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant acheteur de type 0223 (UE_HORS_FRANCE) ne peut pas dépasser 18 caractères. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M38" priority="-1" />
  <xsl:template match="@*|node()" mode="M38" priority="-2">
    <xsl:apply-templates mode="M38" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-ACHETEUR-G2.19d-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0227']" mode="M39" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0227']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) &lt;= 18" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) &lt;= 18">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant acheteur de type 0227 (HORS_UE) ne peut pas dépasser 18 caractères. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M39" priority="-1" />
  <xsl:template match="@*|node()" mode="M39" priority="-2">
    <xsl:apply-templates mode="M39" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-ACHETEUR-G2.19e-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0228']" mode="M40" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0228']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{9,10}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{9,10}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant acheteur de type 0228 (RIDET) doit comporter 9 ou 10 chiffres. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M40" priority="-1" />
  <xsl:template match="@*|node()" mode="M40" priority="-2">
    <xsl:apply-templates mode="M40" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-ACHETEUR-G2.19f-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0229']" mode="M41" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Buyer/CompanyId[@schemeId = '0229']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{9}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{9}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant acheteur de type 0229 (TAHITI) doit comporter exactement 9 chiffres. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M41" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M41" priority="-1" />
  <xsl:template match="@*|node()" mode="M41" priority="-2">
    <xsl:apply-templates mode="M41" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-ACHETEUR-G2.33a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Buyer[CompanyId/@schemeId = ('0002','0223')]" mode="M42" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Buyer[CompanyId/@schemeId = ('0002','0223')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="TaxRegistrationId" />
      <xsl:otherwise>
        <svrl:failed-assert test="TaxRegistrationId">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.33] L'identifiant TVA de l'acheteur est obligatoire quand le type d'identifiant est 0002 ou 0223. | Source : Annexe 7 v1.8 G2.33</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M42" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M42" priority="-1" />
  <xsl:template match="@*|node()" mode="M42" priority="-2">
    <xsl:apply-templates mode="M42" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-ACHETEUR-G2.33b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Buyer/TaxRegistrationId" mode="M43" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Buyer/TaxRegistrationId" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@qualifyingId = 'VAT'" />
      <xsl:otherwise>
        <svrl:failed-assert test="@qualifyingId = 'VAT'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.33] Le qualifiant de l'identifiant TVA de l'acheteur doit être VAT. | Source : Annexe 7 v1.8 G2.33</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M43" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M43" priority="-1" />
  <xsl:template match="@*|node()" mode="M43" priority="-2">
    <xsl:apply-templates mode="M43" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-ACHETEUR-G2.01-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Buyer/PostalAddress/CountryId" mode="M44" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Buyer/PostalAddress/CountryId" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^[A-Z]{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^[A-Z]{2}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.01] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit être au format ISO 3166 alpha-2 (existence dans le référentiel non contrôlée). | Source : Annexe 7 v1.8 G2.01</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M44" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M44" priority="-1" />
  <xsl:template match="@*|node()" mode="M44" priority="-2">
    <xsl:apply-templates mode="M44" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIVRAISON-G1.09-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Delivery/Date" mode="M45" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Delivery/Date" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date de livraison doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date de livraison doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M45" priority="-1" />
  <xsl:template match="@*|node()" mode="M45" priority="-2">
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIVRAISON-G2.01-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Delivery/Location/CountryId" mode="M46" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Delivery/Location/CountryId" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^[A-Z]{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^[A-Z]{2}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.01] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit être au format ISO 3166 alpha-2 (existence dans le référentiel non contrôlée). | Source : Annexe 7 v1.8 G2.01</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M46" priority="-1" />
  <xsl:template match="@*|node()" mode="M46" priority="-2">
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PERIODE-FAC-G1.09a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/InvoicePeriod/StartDate" mode="M47" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/InvoicePeriod/StartDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date de début de période de facturation doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date de début de période de facturation doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M47" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M47" priority="-1" />
  <xsl:template match="@*|node()" mode="M47" priority="-2">
    <xsl:apply-templates mode="M47" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PERIODE-FAC-G1.09b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/InvoicePeriod/EndDate" mode="M48" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/InvoicePeriod/EndDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date de fin de période de facturation doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date de fin de période de facturation doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M48" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M48" priority="-1" />
  <xsl:template match="@*|node()" mode="M48" priority="-2">
    <xsl:apply-templates mode="M48" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PERIODE-FAC-G6.25-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/InvoicePeriod[StartDate and EndDate]" mode="M49" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/InvoicePeriod[StartDate and EndDate]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="EndDate > StartDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="EndDate > StartDate">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.25] La date de fin de période de facturation ne peut pas être antérieure ou égale à la date de début. | Source : Annexe 7 v1.8 G6.25</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M49" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M49" priority="-1" />
  <xsl:template match="@*|node()" mode="M49" priority="-2">
    <xsl:apply-templates mode="M49" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-REMISE-G2.31-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/AllowanceCharge/TaxCategoryCode" mode="M50" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/AllowanceCharge/TaxCategoryCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('S','E','AE','K','G','O','Z')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('S','E','AE','K','G','O','Z')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.31] Le code de catégorie TVA des remises/charges doit appartenir à UNTDID 5305 (S, E, AE, K, G, O, Z). | Source : Annexe 7 v1.8 G2.31</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M50" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M50" priority="-1" />
  <xsl:template match="@*|node()" mode="M50" priority="-2">
    <xsl:apply-templates mode="M50" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-REMISE-G1.24-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/AllowanceCharge/TaxPercent" mode="M51" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/AllowanceCharge/TaxPercent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.24] Le taux de TVA des remises/charges n'est pas dans la liste autorisée. | Source : Annexe 7 v1.8 G1.24</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M51" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M51" priority="-1" />
  <xsl:template match="@*|node()" mode="M51" priority="-2">
    <xsl:apply-templates mode="M51" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-REMISE-G1.14-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/AllowanceCharge/Amount" mode="M52" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/AllowanceCharge/Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^-?\d+(\.\d{1,2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^-?\d+(\.\d{1,2})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M52" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M52" priority="-1" />
  <xsl:template match="@*|node()" mode="M52" priority="-2">
    <xsl:apply-templates mode="M52" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TOTAL-G1.14a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/MonetaryTotal/TaxExclusiveAmount" mode="M53" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/MonetaryTotal/TaxExclusiveAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^-?\d+(\.\d{1,2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^-?\d+(\.\d{1,2})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M53" priority="-1" />
  <xsl:template match="@*|node()" mode="M53" priority="-2">
    <xsl:apply-templates mode="M53" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TOTAL-TAXAMOUNT-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/MonetaryTotal/TaxAmount" mode="M54" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/MonetaryTotal/TaxAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@CurrencyCode = 'EUR'" />
      <xsl:otherwise>
        <svrl:failed-assert test="@CurrencyCode = 'EUR'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.23] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : le montant de TVA de la facture doit être exprimé en euros. | Source : Annexe 7 v1.8 G6.23</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^-?\d+(\.\d{1,2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^-?\d+(\.\d{1,2})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M54" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M54" priority="-1" />
  <xsl:template match="@*|node()" mode="M54" priority="-2">
    <xsl:apply-templates mode="M54" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TOTAL-G1.53-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice[CurrencyCode = 'EUR']" mode="M55" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice[CurrencyCode = 'EUR']" />
    <xsl:variable name="totalHT" select="number(MonetaryTotal/TaxExclusiveAmount)" />
    <xsl:variable name="sommeBasesHT" select="sum(TaxSubTotal/TaxableAmount)" />
    <xsl:variable name="totalTVA" select="number(MonetaryTotal/TaxAmount)" />
    <xsl:variable name="sommeTVA" select="sum(TaxSubTotal/TaxAmount)" />
    <xsl:variable name="toleranceHT" select="0.01 * count(TaxSubTotal/TaxableAmount)" />
    <xsl:variable name="toleranceTVA" select="0.01 * count(TaxSubTotal/TaxAmount)" />
    <xsl:variable name="amountsHTValides" select="every $m in (MonetaryTotal/TaxExclusiveAmount, TaxSubTotal/TaxableAmount) satisfies (matches(string($m), '^-?\d+(\.\d{1,2})?$') and string-length(translate(string($m), '.', '')) &lt;= 19)" />
    <xsl:variable name="amountsTVAValides" select="every $m in (MonetaryTotal/TaxAmount, TaxSubTotal/TaxAmount) satisfies (matches(string($m), '^-?\d+(\.\d{1,2})?$') and string-length(translate(string($m), '.', '')) &lt;= 19)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(MonetaryTotal/TaxExclusiveAmount) or not($amountsHTValides) or (abs($totalHT - $sommeBasesHT) &lt;= $toleranceHT)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(MonetaryTotal/TaxExclusiveAmount) or not($amountsHTValides) or (abs($totalHT - $sommeBasesHT) &lt;= $toleranceHT)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.53] Le montant total hors taxe (<xsl:text />
            <xsl:value-of select="$totalHT" />
            <xsl:text />) doit être égal à la somme des bases d'imposition TVA (<xsl:text />
            <xsl:value-of select="$sommeBasesHT" />
            <xsl:text />), avec une tolérance de 0,01 EUR par montant HT additionné. | Source : Annexe 7 v1.8 G1.53</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(MonetaryTotal/TaxAmount) or not($amountsTVAValides) or (abs($totalTVA - $sommeTVA) &lt;= $toleranceTVA)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(MonetaryTotal/TaxAmount) or not($amountsTVAValides) or (abs($totalTVA - $sommeTVA) &lt;= $toleranceTVA)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.53] Le montant total de TVA (<xsl:text />
            <xsl:value-of select="$totalTVA" />
            <xsl:text />) doit être égal à la somme des montants de TVA par ventilation (<xsl:text />
            <xsl:value-of select="$sommeTVA" />
            <xsl:text />), avec une tolérance de 0,01 EUR par montant TVA additionné. | Source : Annexe 7 v1.8 G1.53</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M55" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M55" priority="-1" />
  <xsl:template match="@*|node()" mode="M55" priority="-2">
    <xsl:apply-templates mode="M55" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TVA-G2.31-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/TaxSubTotal/TaxCategory/Code" mode="M56" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/TaxSubTotal/TaxCategory/Code" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('S','E','AE','K','G','O','Z')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('S','E','AE','K','G','O','Z')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.31] Le code de catégorie TVA doit appartenir à UNTDID 5305 (S, E, AE, K, G, O, Z). | Source : Annexe 7 v1.8 G2.31</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M56" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M56" priority="-1" />
  <xsl:template match="@*|node()" mode="M56" priority="-2">
    <xsl:apply-templates mode="M56" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TVA-G1.24-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/TaxSubTotal/TaxCategory/Percent" mode="M57" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/TaxSubTotal/TaxCategory/Percent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.24] Le taux de TVA n'est pas dans la liste autorisée. | Source : Annexe 7 v1.8 G1.24</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M57" priority="-1" />
  <xsl:template match="@*|node()" mode="M57" priority="-2">
    <xsl:apply-templates mode="M57" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TVA-G1.40-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/TaxSubTotal[TaxCategory/Code = 'E']" mode="M58" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/TaxSubTotal[TaxCategory/Code = 'E']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="TaxCategory/TaxExemptionReasonCode and TaxCategory/TaxExemptionReason" />
      <xsl:otherwise>
        <svrl:failed-assert test="TaxCategory/TaxExemptionReasonCode and TaxCategory/TaxExemptionReason">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.40] Le code et le libellé du motif d'exonération sont obligatoires quand le code de catégorie TVA est "E". | Source : Annexe 7 v1.8 G1.40</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M58" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M58" priority="-1" />
  <xsl:template match="@*|node()" mode="M58" priority="-2">
    <xsl:apply-templates mode="M58" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TVA-G1.14a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/TaxSubTotal/TaxableAmount" mode="M59" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/TaxSubTotal/TaxableAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^-?\d+(\.\d{1,2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^-?\d+(\.\d{1,2})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M59" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M59" priority="-1" />
  <xsl:template match="@*|node()" mode="M59" priority="-2">
    <xsl:apply-templates mode="M59" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TVA-G1.14b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/TaxSubTotal/TaxAmount" mode="M60" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/TaxSubTotal/TaxAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^-?\d+(\.\d{1,2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^-?\d+(\.\d{1,2})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M60" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M60" priority="-1" />
  <xsl:template match="@*|node()" mode="M60" priority="-2">
    <xsl:apply-templates mode="M60" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIGNE-G1.09a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Line/InvoicePeriod/StartDate" mode="M61" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Line/InvoicePeriod/StartDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date de début de période de ligne doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date de début de période de ligne doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M61" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M61" priority="-1" />
  <xsl:template match="@*|node()" mode="M61" priority="-2">
    <xsl:apply-templates mode="M61" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIGNE-G1.09b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Line/InvoicePeriod/EndDate" mode="M62" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Line/InvoicePeriod/EndDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date de fin de période de ligne doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date de fin de période de ligne doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M62" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M62" priority="-1" />
  <xsl:template match="@*|node()" mode="M62" priority="-2">
    <xsl:apply-templates mode="M62" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIGNE-G6.25-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Line/InvoicePeriod[StartDate and EndDate]" mode="M63" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Line/InvoicePeriod[StartDate and EndDate]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="EndDate > StartDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="EndDate > StartDate">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.25] La date de fin de période de ligne ne peut pas être antérieure ou égale à la date de début. | Source : Annexe 7 v1.8 G6.25</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M63" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M63" priority="-1" />
  <xsl:template match="@*|node()" mode="M63" priority="-2">
    <xsl:apply-templates mode="M63" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIGNE-G2.01-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Line/Delivery/Location/CountryId" mode="M64" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Line/Delivery/Location/CountryId" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^[A-Z]{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^[A-Z]{2}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.01] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit être au format ISO 3166 alpha-2 (existence dans le référentiel non contrôlée). | Source : Annexe 7 v1.8 G2.01</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M64" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M64" priority="-1" />
  <xsl:template match="@*|node()" mode="M64" priority="-2">
    <xsl:apply-templates mode="M64" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIGNE-G1.14-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Line/AllowanceCharge/Amount" mode="M65" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Line/AllowanceCharge/Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^-?\d+(\.\d{1,2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^-?\d+(\.\d{1,2})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M65" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M65" priority="-1" />
  <xsl:template match="@*|node()" mode="M65" priority="-2">
    <xsl:apply-templates mode="M65" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIGNE-G1.15-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Line/BilledQuantity" mode="M66" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Line/BilledQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^-?\d+(\.\d{1,4})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^-?\d+(\.\d{1,4})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.15] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 4 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.15</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.15] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.15</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M66" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M66" priority="-1" />
  <xsl:template match="@*|node()" mode="M66" priority="-2">
    <xsl:apply-templates mode="M66" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIGNE-G1.16a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Line/Price/PriceAmount" mode="M67" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Line/Price/PriceAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d+(\.\d{1,6})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d+(\.\d{1,6})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 6 décimales, sans signe négatif, avec un séparateur point. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M67" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M67" priority="-1" />
  <xsl:template match="@*|node()" mode="M67" priority="-2">
    <xsl:apply-templates mode="M67" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIGNE-G1.16b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Line/Price/AllowanceChargeAmount" mode="M68" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Line/Price/AllowanceChargeAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d+(\.\d{1,6})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d+(\.\d{1,6})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 6 décimales, sans signe négatif, avec un séparateur point. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M68" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M68" priority="-1" />
  <xsl:template match="@*|node()" mode="M68" priority="-2">
    <xsl:apply-templates mode="M68" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIGNE-G1.16c-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Line/Price/AllowanceChargeBaseAmount" mode="M69" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Line/Price/AllowanceChargeBaseAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d+(\.\d{1,6})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d+(\.\d{1,6})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 6 décimales, sans signe négatif, avec un séparateur point. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M69" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M69" priority="-1" />
  <xsl:template match="@*|node()" mode="M69" priority="-2">
    <xsl:apply-templates mode="M69" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIGNE-G1.55-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Line/Price[PriceAmount and AllowanceChargeAmount and AllowanceChargeBaseAmount]" mode="M70" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Line/Price[PriceAmount and AllowanceChargeAmount and AllowanceChargeBaseAmount]" />
    <xsl:variable name="prixValides" select="every $m in (PriceAmount, AllowanceChargeAmount, AllowanceChargeBaseAmount) satisfies (matches(string($m), '^\d+(\.\d{1,6})?$') and string-length(translate(string($m), '.', '')) &lt;= 19)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($prixValides) or abs(number(PriceAmount) - (number(AllowanceChargeBaseAmount) - number(AllowanceChargeAmount))) &lt;= 0.01" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($prixValides) or abs(number(PriceAmount) - (number(AllowanceChargeBaseAmount) - number(AllowanceChargeAmount))) &lt;= 0.01">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.55] Le prix net doit être égal au prix brut diminué du rabais (tolérance 0,01). | Source : Annexe 7 v1.8 G1.55</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M70" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M70" priority="-1" />
  <xsl:template match="@*|node()" mode="M70" priority="-2">
    <xsl:apply-templates mode="M70" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIGNE-G1.09c-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Line/ReferencedDocument/IssueDate" mode="M71" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Line/ReferencedDocument/IssueDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date de la facture antérieure à la ligne doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date de la facture antérieure à la ligne doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M71" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M71" priority="-1" />
  <xsl:template match="@*|node()" mode="M71" priority="-2">
    <xsl:apply-templates mode="M71" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-LIGNE-G1.05-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/Line/ReferencedDocument/ID" mode="M72" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/Line/ReferencedDocument/ID" />
    <xsl:variable name="v" select="string(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length($v) &lt;= 35" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length($v) &lt;= 35">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de la facture antérieure à la ligne ne peut pas dépasser 35 caractères. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with($v, ' ') or ends-with($v, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with($v, ' ') or ends-with($v, ' '))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de la facture antérieure à la ligne ne peut pas commencer ni terminer par un espace. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains($v, '  '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains($v, ' '))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de la facture antérieure à la ligne ne peut pas contenir d'espaces consécutifs. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de la facture antérieure à la ligne contient des caractères non autorisés. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M72" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M72" priority="-1" />
  <xsl:template match="@*|node()" mode="M72" priority="-2">
    <xsl:apply-templates mode="M72" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TRANSAC-G1.09-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Transactions/Date" mode="M73" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Transactions/Date" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date des transactions doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date des transactions doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M73" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M73" priority="-1" />
  <xsl:template match="@*|node()" mode="M73" priority="-2">
    <xsl:apply-templates mode="M73" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TRANSAC-G1.68-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Transactions/CategoryCode" mode="M74" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Transactions/CategoryCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('TLB1','TPS1','TNT1','TMA1')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('TLB1','TPS1','TNT1','TMA1')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.68] La catégorie de transactions doit être TLB1, TPS1, TNT1 ou TMA1. | Source : Annexe 7 v1.8 G1.68</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M74" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M74" priority="-1" />
  <xsl:template match="@*|node()" mode="M74" priority="-2">
    <xsl:apply-templates mode="M74" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TRANSAC-P1.11-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Transactions/TaxDueDateTypeCode" mode="M75" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Transactions/TaxDueDateTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('5','29','72','3','35','432')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('5','29','72','3','35','432')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[P1.11] Le code d'exigibilité de la TVA doit appartenir à UNTDID 2475 (5, 29, 72) ou UNTDID 2005 (3, 35, 432). | Source : Annexe 7 v1.8 P1.11</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M75" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M75" priority="-1" />
  <xsl:template match="@*|node()" mode="M75" priority="-2">
    <xsl:apply-templates mode="M75" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TRANSAC-G1.24b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Transactions/TaxSubtotal/TaxPercent" mode="M76" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Transactions/TaxSubtotal/TaxPercent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.24] Le taux de TVA des transactions n'est pas dans la liste autorisée. | Source : Annexe 7 v1.8 G1.24</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M76" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M76" priority="-1" />
  <xsl:template match="@*|node()" mode="M76" priority="-2">
    <xsl:apply-templates mode="M76" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TRANSAC-G1.14a-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Transactions/TaxExclusiveAmount" mode="M77" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Transactions/TaxExclusiveAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^-?\d+(\.\d{1,2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^-?\d+(\.\d{1,2})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M77" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M77" priority="-1" />
  <xsl:template match="@*|node()" mode="M77" priority="-2">
    <xsl:apply-templates mode="M77" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TRANSAC-G1.14b-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Transactions/TaxTotal" mode="M78" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Transactions/TaxTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^-?\d+(\.\d{1,2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^-?\d+(\.\d{1,2})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M78" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M78" priority="-1" />
  <xsl:template match="@*|node()" mode="M78" priority="-2">
    <xsl:apply-templates mode="M78" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TRANSAC-G1.14c-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Transactions/TaxSubtotal/TaxableAmount" mode="M79" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Transactions/TaxSubtotal/TaxableAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^-?\d+(\.\d{1,2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^-?\d+(\.\d{1,2})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M79" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M79" priority="-1" />
  <xsl:template match="@*|node()" mode="M79" priority="-2">
    <xsl:apply-templates mode="M79" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TRANSAC-G1.14d-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Transactions/TaxSubtotal/TaxTotal" mode="M80" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Transactions/TaxSubtotal/TaxTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^-?\d+(\.\d{1,2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^-?\d+(\.\d{1,2})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 2 décimales avec un séparateur point. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M80" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M80" priority="-1" />
  <xsl:template match="@*|node()" mode="M80" priority="-2">
    <xsl:apply-templates mode="M80" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TRANSAC-G1.53-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Transactions[TransactionsCurrency = 'EUR']" mode="M81" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Transactions[TransactionsCurrency = 'EUR']" />
    <xsl:variable name="totalHT" select="number(TaxExclusiveAmount)" />
    <xsl:variable name="sommeBasesHT" select="sum(TaxSubtotal/TaxableAmount)" />
    <xsl:variable name="totalTVA" select="number(TaxTotal)" />
    <xsl:variable name="sommeTVA" select="sum(TaxSubtotal/TaxTotal)" />
    <xsl:variable name="toleranceHT" select="0.01 * count(TaxSubtotal/TaxableAmount)" />
    <xsl:variable name="toleranceTVA" select="0.01 * count(TaxSubtotal/TaxTotal)" />
    <xsl:variable name="amountsHTValides" select="every $m in (TaxExclusiveAmount, TaxSubtotal/TaxableAmount) satisfies (matches(string($m), '^-?\d+(\.\d{1,2})?$') and string-length(translate(string($m), '.', '')) &lt;= 19)" />
    <xsl:variable name="amountsTVAValides" select="every $m in (TaxTotal, TaxSubtotal/TaxTotal) satisfies (matches(string($m), '^-?\d+(\.\d{1,2})?$') and string-length(translate(string($m), '.', '')) &lt;= 19)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($amountsHTValides) or abs($totalHT - $sommeBasesHT) &lt;= $toleranceHT" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($amountsHTValides) or abs($totalHT - $sommeBasesHT) &lt;= $toleranceHT">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.53] TaxExclusiveAmount (<xsl:text />
            <xsl:value-of select="$totalHT" />
            <xsl:text />) doit être égal à la somme TaxableAmount (<xsl:text />
            <xsl:value-of select="$sommeBasesHT" />
            <xsl:text />), avec une tolérance de 0,01 EUR par montant HT additionné. | Source : Annexe 7 v1.8 G1.53</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($amountsTVAValides) or abs($totalTVA - $sommeTVA) &lt;= $toleranceTVA" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($amountsTVAValides) or abs($totalTVA - $sommeTVA) &lt;= $toleranceTVA">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.53] TaxTotal (<xsl:text />
            <xsl:value-of select="$totalTVA" />
            <xsl:text />) doit être égal à la somme TaxSubtotal/TaxTotal (<xsl:text />
            <xsl:value-of select="$sommeTVA" />
            <xsl:text />), avec une tolérance de 0,01 EUR par montant TVA additionné. | Source : Annexe 7 v1.8 G1.53</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M81" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M81" priority="-1" />
  <xsl:template match="@*|node()" mode="M81" priority="-2">
    <xsl:apply-templates mode="M81" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PERIODE-PMT-G1.09a-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/ReportPeriod/StartDate" mode="M82" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/ReportPeriod/StartDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date de début de période de paiements doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date de début de période de paiements doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M82" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M82" priority="-1" />
  <xsl:template match="@*|node()" mode="M82" priority="-2">
    <xsl:apply-templates mode="M82" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PERIODE-PMT-G1.09b-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/ReportPeriod/EndDate" mode="M83" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/ReportPeriod/EndDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date de fin de période de paiements doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date de fin de période de paiements doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M83" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M83" priority="-1" />
  <xsl:template match="@*|node()" mode="M83" priority="-2">
    <xsl:apply-templates mode="M83" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PERIODE-PMT-G6.25-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/ReportPeriod[StartDate and EndDate]" mode="M84" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/ReportPeriod[StartDate and EndDate]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="EndDate > StartDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="EndDate > StartDate">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.25] La date de fin de période de paiements ne peut pas être antérieure ou égale à la date de début. | Source : Annexe 7 v1.8 G6.25</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M84" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M84" priority="-1" />
  <xsl:template match="@*|node()" mode="M84" priority="-2">
    <xsl:apply-templates mode="M84" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PMT-FACTURE-G1.05-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/Invoice/InvoiceID" mode="M85" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/Invoice/InvoiceID" />
    <xsl:variable name="v" select="string(.)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length($v) &lt;= 35" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length($v) &lt;= 35">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de facture dans le rapport de paiements ne peut pas dépasser 35 caractères. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with($v, ' ') or ends-with($v, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with($v, ' ') or ends-with($v, ' '))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de facture dans le rapport de paiements ne peut pas commencer ni terminer par un espace. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains($v, '  '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains($v, ' '))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de facture dans le rapport de paiements ne peut pas contenir d'espaces consécutifs. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches($v, '^[a-zA-Z0-9 \-\+_/]+$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] L'identifiant de facture dans le rapport de paiements contient des caractères non autorisés. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M85" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M85" priority="-1" />
  <xsl:template match="@*|node()" mode="M85" priority="-2">
    <xsl:apply-templates mode="M85" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PMT-FACTURE-G1.09-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/Invoice/IssueDate" mode="M86" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/Invoice/IssueDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date d'émission de facture dans le rapport de paiements doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date d'émission de facture dans le rapport de paiements doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M86" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M86" priority="-1" />
  <xsl:template match="@*|node()" mode="M86" priority="-2">
    <xsl:apply-templates mode="M86" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PMT-ENCAISSEMENT-G1.09-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/Invoice/Payment/Date" mode="M87" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/Invoice/Payment/Date" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date d'encaissement doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date d'encaissement doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M87" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M87" priority="-1" />
  <xsl:template match="@*|node()" mode="M87" priority="-2">
    <xsl:apply-templates mode="M87" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PMT-ENCAISSEMENT-G1.24-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/Invoice/Payment/SubTotals/TaxPercent" mode="M88" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/Invoice/Payment/SubTotals/TaxPercent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.24] Le taux de TVA dans le rapport de paiements n'est pas dans la liste autorisée. | Source : Annexe 7 v1.8 G1.24</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M88" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M88" priority="-1" />
  <xsl:template match="@*|node()" mode="M88" priority="-2">
    <xsl:apply-templates mode="M88" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PMT-ENCAISSEMENT-G6.27a-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/Invoice/Payment/SubTotals[CurrencyCode]" mode="M89" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/Invoice/Payment/SubTotals[CurrencyCode]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(CurrencyCode, '^[A-Z]{3}$')) or CurrencyCode = 'EUR'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(CurrencyCode, '^[A-Z]{3}$')) or CurrencyCode = 'EUR'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.27] Le montant encaissé doit être exprimé en euros. | Source : Annexe 7 v1.8 G6.27</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M89" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M89" priority="-1" />
  <xsl:template match="@*|node()" mode="M89" priority="-2">
    <xsl:apply-templates mode="M89" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PMT-ENCAISSEMENT-G1.16-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/Invoice/Payment/SubTotals/Amount" mode="M90" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/Invoice/Payment/SubTotals/Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d+(\.\d{1,6})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d+(\.\d{1,6})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 6 décimales, sans signe négatif, avec un séparateur point. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M90" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M90" priority="-1" />
  <xsl:template match="@*|node()" mode="M90" priority="-2">
    <xsl:apply-templates mode="M90" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PMT-AGREGE-G1.09-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/Transactions/Payment/Date" mode="M91" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/Transactions/Payment/Date" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date d'encaissement agrégé doit être au format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or                     (number(substring(., 1, 4)) >= 2000 and                      number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de la date d'encaissement agrégé doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M91" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M91" priority="-1" />
  <xsl:template match="@*|node()" mode="M91" priority="-2">
    <xsl:apply-templates mode="M91" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PMT-AGREGE-G1.24-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/Transactions/Payment/SubTotals/TaxPercent" mode="M92" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/Transactions/Payment/SubTotals/TaxPercent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.24] Le taux de TVA de l'encaissement agrégé n'est pas dans la liste autorisée. | Source : Annexe 7 v1.8 G1.24</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M92" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M92" priority="-1" />
  <xsl:template match="@*|node()" mode="M92" priority="-2">
    <xsl:apply-templates mode="M92" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PMT-AGREGE-G6.27b-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/Transactions/Payment/SubTotals[CurrencyCode]" mode="M93" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/Transactions/Payment/SubTotals[CurrencyCode]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(CurrencyCode, '^[A-Z]{3}$')) or CurrencyCode = 'EUR'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(CurrencyCode, '^[A-Z]{3}$')) or CurrencyCode = 'EUR'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.27] Le montant encaissé agrégé doit être exprimé en euros. | Source : Annexe 7 v1.8 G6.27</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M93" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M93" priority="-1" />
  <xsl:template match="@*|node()" mode="M93" priority="-2">
    <xsl:apply-templates mode="M93" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PMT-AGREGE-G1.16-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/Transactions/Payment/SubTotals/Amount" mode="M94" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/Transactions/Payment/SubTotals/Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d+(\.\d{1,6})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d+(\.\d{1,6})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit comporter au maximum 6 décimales, sans signe négatif, avec un séparateur point. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(., '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(., '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : ne peut pas dépasser 19 chiffres hors séparateur. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M94" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M94" priority="-1" />
  <xsl:template match="@*|node()" mode="M94" priority="-2">
    <xsl:apply-templates mode="M94" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-PMT-DEVISE-G1.10-->


	<!--RULE -->
<xsl:template match="/Report/PaymentsReport/Invoice/Payment/SubTotals/CurrencyCode |                    /Report/PaymentsReport/Transactions/Payment/SubTotals/CurrencyCode" mode="M95" priority="1000">
    <svrl:fired-rule context="/Report/PaymentsReport/Invoice/Payment/SubTotals/CurrencyCode |                    /Report/PaymentsReport/Transactions/Payment/SubTotals/CurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^[A-Z]{3}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^[A-Z]{3}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.10] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit respecter le format ISO 4217 (3 lettres majuscules — existence dans le référentiel non contrôlée). | Source : Annexe 7 v1.8 G1.10</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M95" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M95" priority="-1" />
  <xsl:template match="@*|node()" mode="M95" priority="-2">
    <xsl:apply-templates mode="M95" select="@*|*" />
  </xsl:template>

<!--PATTERN F10-TX-DEVISE-G1.10-->


	<!--RULE -->
<xsl:template match="/Report/TransactionsReport/Invoice/CurrencyCode |                    /Report/TransactionsReport/Transactions/TransactionsCurrency" mode="M96" priority="1000">
    <svrl:fired-rule context="/Report/TransactionsReport/Invoice/CurrencyCode |                    /Report/TransactionsReport/Transactions/TransactionsCurrency" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^[A-Z]{3}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^[A-Z]{3}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.10] <xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> : doit respecter le format ISO 4217 (3 lettres majuscules — existence dans le référentiel non contrôlée). | Source : Annexe 7 v1.8 G1.10</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M96" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M96" priority="-1" />
  <xsl:template match="@*|node()" mode="M96" priority="-2">
    <xsl:apply-templates mode="M96" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
