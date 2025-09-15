<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:nl="http://ns.setu.nl/2020-01" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:setu="http://ns.hr-xml.org/2007-04-15" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
        <xsl:variable name="p_1" select="1+    count(preceding-sibling::*[name()=name(current())])" />
        <xsl:if test="$p_1>1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1" />]</xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>']</xsl:text>
        <xsl:variable name="p_2" select="1+   count(preceding-sibling::*[local-name()=local-name(current())])" />
        <xsl:if test="$p_2>1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2" />]</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
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
    <svrl:schematron-output schemaVersion="nl.setu.200801.businessrules.staffingorder" title="Business rules voor het controleren van een staffingorder bericht (SETU Standard for Ordering &amp; Selection versie 1.4).">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="setu" uri="http://ns.hr-xml.org/2007-04-15" />
      <svrl:ns-prefix-in-attribute-values prefix="nl" uri="http://ns.setu.nl/2020-01" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M18" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M19" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M20" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M21" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M22" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M23" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M24" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M25" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M26" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M27" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M28" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M29" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M30" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M31" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M32" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M33" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M34" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M35" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M36" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M37" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M38" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M39" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M40" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M41" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M42" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M43" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M44" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M45" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M46" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M47" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M48" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M49" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M50" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M51" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M52" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M53" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M54" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M55" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M56" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M57" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M58" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M59" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M60" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M61" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M62" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M63" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M64" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M65" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M66" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M67" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M68" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M69" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M70" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M71" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M72" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M73" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M74" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M75" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M76" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M77" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M78" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M79" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M80" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M81" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M82" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M83" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M84" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M85" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M86" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M87" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M88" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M89" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M90" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M91" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M92" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M93" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M94" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M95" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M96" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M97" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M98" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M99" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M100" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M101" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M102" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M103" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M104" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M105" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M106" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M107" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Business rules voor het controleren van een staffingorder bericht (SETU Standard for Ordering &amp; Selection versie 1.4).</svrl:text>
  <xsl:param name="OrderType" select="',RFQ,order,'" />
  <xsl:param name="OrderStatus" select="',new,closed,'" />
  <xsl:param name="OrderContact" select="',created by,authorized by,first day contact,placed by,placed on behalf of,supervisor,submitted by,'" />
  <xsl:param name="PositionType" select="',recruitment and selection,secondment,temporary staffing,payroll,'" />
  <xsl:param name="PositionReason" select="',Illness,Peak,Project,Reorganisation,Position,Vacation,Maternity,Season,Replacement,Recruitment,Structural,Other,'" />
  <xsl:param name="RateType" select="',bill,pay,minPayRate,maxPayRate,minBillRate,maxBillRate,'" />
  <xsl:param name="RateStatus" select="',proposed,agreed,'" />
  <xsl:param name="Amount" select="',hourly,x:hourlysplit,x:hourlyconsolidated,daily,weekly,x:4weekly,monthly,yearly,flatfee,'" />
  <xsl:param name="Class" select="',TimeInterval,Allowance,Expense,'" />
  <xsl:param name="StaffingShift" select="',daily,weekly,monthly,'" />
  <xsl:param name="Degree" select="',1,2,3,4,5,6,'" />
  <xsl:param name="IdOwner" select="',StaffingCustomer,StaffingCompany,KvK,OIN,BTW,Fi,'" />
  <xsl:param name="Affix" select="',aristocraticTitle,formOfAddress,generation,qualification,'" />
  <xsl:param name="SETU_CL_HourTypes" select="',Additional wage dispensation,Adoption leave,Child-birth sick time,Internship,Overtime wage dispensation,Pregnancy sick time,Regular wage dispensation,Shift wage dispensation,Transition allowance,Vacation additional,Additionalplus,Regular canceled,Shift canceled,Shiftplus canceled,Additional canceled,Additionalplus canceled,Regular complemented,Additional complemented,Shift complemented,Overtime complemented,Overtime canceled,Overtimeplus canceled,Regular,Overtime,Overtimeplus,Shift,Shiftplus,Attendance,Travel,Additional,Internal,Time for time hour build-up,Time for time overtime hour build-up,Special Leave,Short leave,Holiday,Unpaid leave,Training,Vacation,Reduction of working hours,Sick time,Work underload,Care Leave,WTR (work time reduction),Compensation leave,Funeral,Maternity Leave,Withdrawal time for time hours,Contract hours,Standby,Break,'" />
  <xsl:param name="SETU_CL_ExpenseAllowanceTypes" select="',100,100B,100O,101,101B,101O,102,102B,102O,103,103B,103O,104,104B,104O,105,105B,105O,106,106B,106O,107,107B,107O,201,201B,201O,202,202B,202O,203,203B,203O,300,300B,300O,301,301B,301O,302,302B,302O,303,303B,303O,304,304B,304O,400,400B,400O,501,501B,501O,502,502B,502O,503,503B,503O,600,600B,600O,601,601B,601O,602,602B,602O,603,603B,603O,604,604B,604O,701,701B,701O,702,702B,702O,703,703B,703O,801,801B,801O,802,802B,802O,803,803B,803O,900,900B,900O,901,901B,901O,903,903B,903O,904,904B,904O,905,905B,905O,906,906B,906O,907,907B,907O,908,908B,908O,909,909B,909O,910,910B,910O,911,911B,911O,912,912B,912O,913,913B,913O,914,914B,914O,'" />

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.OrderId.1-->
<xsl:template match="/setu:StaffingOrder/setu:OrderId" mode="M18" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:OrderId" id="nl.setu.200801.businessrules.staffingorder.businessrule.OrderId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)= 1) and ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)= 1) and ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of OrderId may exist exactly once and should have a valid value, either 'StaffingCustomer' or 'StaffingCompany'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M18" priority="-1" />
  <xsl:template match="@*|node()" mode="M18" priority="-2">
    <xsl:apply-templates mode="M18" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.OrderId.2-->
<xsl:template match="/setu:StaffingOrder/setu:OrderId" mode="M19" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:OrderId" id="nl.setu.200801.businessrules.staffingorder.businessrule.OrderId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)= 1) and (normalize-space(setu:IdValue) != '') " />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)= 1) and (normalize-space(setu:IdValue) != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element IdValue of OrderId may exist exactly once and should have a valid value.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M19" priority="-1" />
  <xsl:template match="@*|node()" mode="M19" priority="-2">
    <xsl:apply-templates mode="M19" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.ValidFrom.1-->
<xsl:template match="/setu:StaffingOrder" mode="M20" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.200801.businessrules.staffingorder.businessrule.ValidFrom.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((normalize-space(setu:OrderClassification/setu:OrderType) = 'order') and (count(setu:OrderId/@validFrom)= 0)) or not(normalize-space(setu:OrderClassification/setu:OrderType) = 'order')" />
      <xsl:otherwise>
        <svrl:failed-assert test="((normalize-space(setu:OrderClassification/setu:OrderType) = 'order') and (count(setu:OrderId/@validFrom)= 0)) or not(normalize-space(setu:OrderClassification/setu:OrderType) = 'order')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute validFrom may not exist when OrderType='order'. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M20" priority="-1" />
  <xsl:template match="@*|node()" mode="M20" priority="-2">
    <xsl:apply-templates mode="M20" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.ValidTo.1-->
<xsl:template match="/setu:StaffingOrder" mode="M21" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.200801.businessrules.staffingorder.businessrule.ValidTo.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((normalize-space(setu:OrderClassification/setu:OrderType) = 'order') and (count(setu:OrderId/@validTo)= 0)) or not (normalize-space(setu:OrderClassification/setu:OrderType) = 'order')" />
      <xsl:otherwise>
        <svrl:failed-assert test="((normalize-space(setu:OrderClassification/setu:OrderType) = 'order') and (count(setu:OrderId/@validTo)= 0)) or not (normalize-space(setu:OrderClassification/setu:OrderType) = 'order')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute validTo may not exist when OrderType='order'. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M21" priority="-1" />
  <xsl:template match="@*|node()" mode="M21" priority="-2">
    <xsl:apply-templates mode="M21" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PositionQuantity.1-->
<xsl:template match="/setu:StaffingOrder/setu:PositionQuantity" mode="M22" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:PositionQuantity" id="nl.setu.200801.businessrules.staffingorder.businessrule.PositionQuantity.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test=". > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The value of the element PositionQuantity must be larger than 0. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M22" priority="-1" />
  <xsl:template match="@*|node()" mode="M22" priority="-2">
    <xsl:apply-templates mode="M22" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.MultiVendorDistribution.1-->
<xsl:template match="/setu:StaffingOrder" mode="M23" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.200801.businessrules.staffingorder.businessrule.MultiVendorDistribution.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((normalize-space(setu:OrderClassification/setu:OrderType)='order') and (normalize-space(setu:MultiVerdorDistribution)='false')) or not(normalize-space(setu:OrderClassification/setu:OrderType)='order')" />
      <xsl:otherwise>
        <svrl:failed-assert test="((normalize-space(setu:OrderClassification/setu:OrderType)='order') and (normalize-space(setu:MultiVerdorDistribution)='false')) or not(normalize-space(setu:OrderClassification/setu:OrderType)='order')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element MultiVendorDistribution must contain the value 'false' whenever the element OrderType has value 'order'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M23" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M23" priority="-1" />
  <xsl:template match="@*|node()" mode="M23" priority="-2">
    <xsl:apply-templates mode="M23" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.ReferenceInformation.1-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation" mode="M24" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation" id="nl.setu.200801.businessrules.staffingorder.businessrule.ReferenceInformation.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IntermediaryId)=0) and (count(setu:BillToEntityId)=0) and (count(setu:TimeCardId)=0) and (count(setu:InvoiceId)=0) and (count(setu:AssignmentId)=0) and (count(setu:HumanResourceId)=0) and (count(setu:StaffingOrganizationId)=0) and (count(setu:UserArea)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IntermediaryId)=0) and (count(setu:BillToEntityId)=0) and (count(setu:TimeCardId)=0) and (count(setu:InvoiceId)=0) and (count(setu:AssignmentId)=0) and (count(setu:HumanResourceId)=0) and (count(setu:StaffingOrganizationId)=0) and (count(setu:UserArea)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element ReferenceInformation contains (a) subelement(s) that is/are not allowed.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M24" priority="-1" />
  <xsl:template match="@*|node()" mode="M24" priority="-2">
    <xsl:apply-templates mode="M24" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerId.1-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation" mode="M25" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingCustomerId) = count(setu:StaffingCustomerId[not(@idOwner = preceding-sibling::setu:StaffingCustomerId/@idOwner)])" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingCustomerId) = count(setu:StaffingCustomerId[not(@idOwner = preceding-sibling::setu:StaffingCustomerId/@idOwner)])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The idOwner attributes of the StaffingCustomerId elements are not unique. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M25" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M25" priority="-1" />
  <xsl:template match="@*|node()" mode="M25" priority="-2">
    <xsl:apply-templates mode="M25" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerId.2-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation" mode="M26" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingCustomerId) >=1  " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingCustomerId) >=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element StaffingCustomerId must exist at least once. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M26" priority="-1" />
  <xsl:template match="@*|node()" mode="M26" priority="-2">
    <xsl:apply-templates mode="M26" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerId.3-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingCustomerId" mode="M27" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingCustomerId" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element StaffingCustomerId must exist exactly once and should have a valid value: <xsl:text />
            <xsl:value-of select="$IdOwner" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@idOwner" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M27" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M27" priority="-1" />
  <xsl:template match="@*|node()" mode="M27" priority="-2">
    <xsl:apply-templates mode="M27" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerId.4-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingCustomerId" mode="M28" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingCustomerId" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerId.4" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element StaffingCustomerId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M28" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M28" priority="-1" />
  <xsl:template match="@*|node()" mode="M28" priority="-2">
    <xsl:apply-templates mode="M28" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerOrgUnitId.1-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation" mode="M29" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerOrgUnitId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingCustomerOrgUnitId) = count(setu:StaffingCustomerOrgUnitId[not(@idOwner = preceding-sibling::setu:StaffingCustomerOrgUnitId/@idOwner)])" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingCustomerOrgUnitId) = count(setu:StaffingCustomerOrgUnitId[not(@idOwner = preceding-sibling::setu:StaffingCustomerOrgUnitId/@idOwner)])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The idOwner attributes of the StaffingCustomerOrgUnitId elements are not unique. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M29" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M29" priority="-1" />
  <xsl:template match="@*|node()" mode="M29" priority="-2">
    <xsl:apply-templates mode="M29" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerOrgUnitId.3-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" mode="M30" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerOrgUnitId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element StaffingCustomerOrgUnitId must exist exactly once and should have a valid value: <xsl:text />
            <xsl:value-of select="$IdOwner" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@idOwner" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M30" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M30" priority="-1" />
  <xsl:template match="@*|node()" mode="M30" priority="-2">
    <xsl:apply-templates mode="M30" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerOrgUnitId.4-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" mode="M31" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingCustomerOrgUnitId.4" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element StaffingCustomerOrgUnitId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M31" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M31" priority="-1" />
  <xsl:template match="@*|node()" mode="M31" priority="-2">
    <xsl:apply-templates mode="M31" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingSupplierId.1-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation" mode="M32" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingSupplierId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingSupplierId) = count(setu:StaffingSupplierId[not(@idOwner = preceding-sibling::setu:StaffingSupplierId/@idOwner)])" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingSupplierId) = count(setu:StaffingSupplierId[not(@idOwner = preceding-sibling::setu:StaffingSupplierId/@idOwner)])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The idOwner attributes of the StaffingSupplierId elements are not unique. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M32" priority="-1" />
  <xsl:template match="@*|node()" mode="M32" priority="-2">
    <xsl:apply-templates mode="M32" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingSupplierId.3-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingSupplierId" mode="M33" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingSupplierId" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingSupplierId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element StaffingSupplierId must exist exactly once and should have a valid value: <xsl:text />
            <xsl:value-of select="$IdOwner" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@idOwner" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M33" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M33" priority="-1" />
  <xsl:template match="@*|node()" mode="M33" priority="-2">
    <xsl:apply-templates mode="M33" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingSupplierId.4-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingSupplierId" mode="M34" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingSupplierId" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingSupplierId.4" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element StaffingSupplierId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M34" priority="-1" />
  <xsl:template match="@*|node()" mode="M34" priority="-2">
    <xsl:apply-templates mode="M34" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingSupplierOrgUnitId.1-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation" mode="M35" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingSupplierOrgUnitId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingSupplierOrgUnitId) = count(setu:StaffingSupplierOrgUnitId[not(@idOwner = preceding-sibling::setu:StaffingSupplierOrgUnitId/@idOwner)])" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingSupplierOrgUnitId) = count(setu:StaffingSupplierOrgUnitId[not(@idOwner = preceding-sibling::setu:StaffingSupplierOrgUnitId/@idOwner)])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The idOwner attributes of the StaffingSupplierOrgUnitId elements are not unique. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M35" priority="-1" />
  <xsl:template match="@*|node()" mode="M35" priority="-2">
    <xsl:apply-templates mode="M35" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingSupplierOrgUnitId.3-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" mode="M36" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingSupplierOrgUnitId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element StaffingSupplierOrgUnitId must exist exactly once and should have a valid value: <xsl:text />
            <xsl:value-of select="$IdOwner" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@idOwner" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M36" priority="-1" />
  <xsl:template match="@*|node()" mode="M36" priority="-2">
    <xsl:apply-templates mode="M36" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingSupplierOrgUnitId.4-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" mode="M37" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingSupplierOrgUnitId.4" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element StaffingSupplierOrgUnitId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M37" priority="-1" />
  <xsl:template match="@*|node()" mode="M37" priority="-2">
    <xsl:apply-templates mode="M37" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.CustomerReportingRequirements.1-->
<xsl:template match="//setu:CustomerReportingRequirements" mode="M38" priority="1000">
    <svrl:fired-rule context="//setu:CustomerReportingRequirements" id="nl.setu.200801.businessrules.staffingorder.businessrule.CustomerReportingRequirements.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:SupervisorName)=0) and (count(setu:LocationCode)=0) and (count(setu:LocationName)=0) and (count(setu:CustomerJobCode)=0) and (count(setu:CustomerJobDescription)=0) and (count(setu:AccountCode)=0) and (count(setu:ExternalOrderNumber)=0) and (count(setu:ExternalReqNumber)=0) and (count(setu:Entity)=0) and (count(setu:SubEntity)=0) and (count(setu:Shift)=0) and (count(setu:PurchaseOrderLineItem)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:SupervisorName)=0) and (count(setu:LocationCode)=0) and (count(setu:LocationName)=0) and (count(setu:CustomerJobCode)=0) and (count(setu:CustomerJobDescription)=0) and (count(setu:AccountCode)=0) and (count(setu:ExternalOrderNumber)=0) and (count(setu:ExternalReqNumber)=0) and (count(setu:Entity)=0) and (count(setu:SubEntity)=0) and (count(setu:Shift)=0) and (count(setu:PurchaseOrderLineItem)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element CustomerReportingRequirements contains (a) subelement(s) that is/are not allowed.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M38" priority="-1" />
  <xsl:template match="@*|node()" mode="M38" priority="-2">
    <xsl:apply-templates mode="M38" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.AdditionalRequirement.1-->
<xsl:template match="/setu:StaffingOrder/setu:ReferenceInformation//setu:AdditionalRequirement" mode="M39" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:ReferenceInformation//setu:AdditionalRequirement" id="nl.setu.200801.businessrules.staffingorder.businessrule.AdditionalRequirement.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(@requirementTitle)=1 and normalize-space(@requirementTitle)!=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(@requirementTitle)=1 and normalize-space(@requirementTitle)!=''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                For each AdditionalRequirement the attribute requirementTitle must exist exactly once and may not be empty .
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M39" priority="-1" />
  <xsl:template match="@*|node()" mode="M39" priority="-2">
    <xsl:apply-templates mode="M39" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.OrderStatus.1-->
<xsl:template match="/setu:StaffingOrder/setu:OrderClassification" mode="M40" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:OrderClassification" id="nl.setu.200801.businessrules.staffingorder.businessrule.OrderStatus.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($OrderStatus, concat(',', @orderStatus, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($OrderStatus, concat(',', @orderStatus, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute orderStatus of the element OrderClassification must contain one of the following values: <xsl:text />
            <xsl:value-of select="$OrderStatus" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@orderStatus" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M40" priority="-1" />
  <xsl:template match="@*|node()" mode="M40" priority="-2">
    <xsl:apply-templates mode="M40" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.OrderType.1-->
<xsl:template match="/setu:StaffingOrder/setu:OrderClassification" mode="M41" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:OrderClassification" id="nl.setu.200801.businessrules.staffingorder.businessrule.OrderType.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($OrderType, concat(',', @orderType, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($OrderType, concat(',', @orderType, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute orderType of the element OrderClassification must contain one of the following values: <xsl:text />
            <xsl:value-of select="$OrderType" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@orderType" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M41" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M41" priority="-1" />
  <xsl:template match="@*|node()" mode="M41" priority="-2">
    <xsl:apply-templates mode="M41" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.OrderContact.1-->
<xsl:template match="/setu:StaffingOrder" mode="M42" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.200801.businessrules.staffingorder.businessrule.OrderContact.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:OrderContact) = count(setu:OrderContact[not(@contactType = preceding-sibling::setu:OrderContact/@contactType)])" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:OrderContact) = count(setu:OrderContact[not(@contactType = preceding-sibling::setu:OrderContact/@contactType)])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The contactType attributes of the OrderContact elements are not unique. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M42" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M42" priority="-1" />
  <xsl:template match="@*|node()" mode="M42" priority="-2">
    <xsl:apply-templates mode="M42" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.OrderContact.2-->
<xsl:template match="/setu:StaffingOrder" mode="M43" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.200801.businessrules.staffingorder.businessrule.OrderContact.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:OrderContact) &lt;=7 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:OrderContact) &lt;=7">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element OrderContact may exist at most seven times. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M43" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M43" priority="-1" />
  <xsl:template match="@*|node()" mode="M43" priority="-2">
    <xsl:apply-templates mode="M43" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.OrderContact.3-->
<xsl:template match="/setu:StaffingOrder//setu:OrderContact" mode="M44" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder//setu:OrderContact" id="nl.setu.200801.businessrules.staffingorder.businessrule.OrderContact.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($OrderContact, concat(',', @contactType, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($OrderContact, concat(',', @contactType, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute contactType of the element OrderContact must exist exactly once and should have a valid value: <xsl:text />
            <xsl:value-of select="$OrderContact" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@contactType" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M44" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M44" priority="-1" />
  <xsl:template match="@*|node()" mode="M44" priority="-2">
    <xsl:apply-templates mode="M44" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PersonName.1-->
<xsl:template match="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:PersonName" mode="M45" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:PersonName" id="nl.setu.200801.businessrules.staffingorder.businessrule.PersonName.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:FormattedName)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:FormattedName)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element PersonName must contain a FormattedName element.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M45" priority="-1" />
  <xsl:template match="@*|node()" mode="M45" priority="-2">
    <xsl:apply-templates mode="M45" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.OrderContact.1-->
<xsl:template match="/setu:StaffingOrder" mode="M46" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.200801.businessrules.staffingorder.businessrule.OrderContact.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:OrderContact)>= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:OrderContact)>= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The contactType attributes of the OrderContact elements are not unique. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M46" priority="-1" />
  <xsl:template match="@*|node()" mode="M46" priority="-2">
    <xsl:apply-templates mode="M46" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.ContactMethod.1-->
<xsl:template match="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo" mode="M47" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo" id="nl.setu.200801.businessrules.staffingorder.businessrule.ContactMethod.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:ContactMethod)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:ContactMethod)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element ContactMethod must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M47" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M47" priority="-1" />
  <xsl:template match="@*|node()" mode="M47" priority="-2">
    <xsl:apply-templates mode="M47" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.ContactMethod.2-->
<xsl:template match="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod" mode="M48" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod" id="nl.setu.200801.businessrules.staffingorder.businessrule.ContactMethod.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:Use)=0) and (count(setu:Location)=0) and (count(setu:WhenAvailable)=0) and (count(setu:Pager)=0) and (count(setu:TTYTDD)=0) and (count(setu:InternetMailAddress)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:Use)=0) and (count(setu:Location)=0) and (count(setu:WhenAvailable)=0) and (count(setu:Pager)=0) and (count(setu:TTYTDD)=0) and (count(setu:InternetMailAddress)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element ContactMethod contains (a) subelement(s) that is/are not allowed.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M48" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M48" priority="-1" />
  <xsl:template match="@*|node()" mode="M48" priority="-2">
    <xsl:apply-templates mode="M48" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Telephone.1-->
<xsl:template match="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod/setu:Telephone" mode="M49" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod/setu:Telephone" id="nl.setu.200801.businessrules.staffingorder.businessrule.Telephone.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:InternationalCountryCode)=0) and (count(setu:NationalNumber)=0) and (count(setu:AreaCityCode)=0) and (count(setu:SubscriberNumber)=0) and (count(setu:Extension)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:InternationalCountryCode)=0) and (count(setu:NationalNumber)=0) and (count(setu:AreaCityCode)=0) and (count(setu:SubscriberNumber)=0) and (count(setu:Extension)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element Telephone contains (a) subelement(s) that is/are not allowed.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M49" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M49" priority="-1" />
  <xsl:template match="@*|node()" mode="M49" priority="-2">
    <xsl:apply-templates mode="M49" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Telephone.2-->
<xsl:template match="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod/setu:Telephone" mode="M50" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod/setu:Telephone" id="nl.setu.200801.businessrules.staffingorder.businessrule.Telephone.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:FormattedNumber)=1) and (normalize-space(setu:FormattedNumber) != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:FormattedNumber)=1) and (normalize-space(setu:FormattedNumber) != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element Telephone must contain exactly 1 FormattedNumber element, which must not be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M50" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M50" priority="-1" />
  <xsl:template match="@*|node()" mode="M50" priority="-2">
    <xsl:apply-templates mode="M50" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Mobile.1-->
<xsl:template match="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod/setu:Mobile" mode="M51" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod/setu:Mobile" id="nl.setu.200801.businessrules.staffingorder.businessrule.Mobile.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:InternationalCountryCode)=0) and (count(setu:NationalNumber)=0) and (count(setu:AreaCityCode)=0) and (count(setu:SubscriberNumber)=0) and (count(setu:Extension)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:InternationalCountryCode)=0) and (count(setu:NationalNumber)=0) and (count(setu:AreaCityCode)=0) and (count(setu:SubscriberNumber)=0) and (count(setu:Extension)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element Mobile contains (a) subelement(s) that is/are not allowed.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M51" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M51" priority="-1" />
  <xsl:template match="@*|node()" mode="M51" priority="-2">
    <xsl:apply-templates mode="M51" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Mobile.2-->
<xsl:template match="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod/setu:Mobile" mode="M52" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod/setu:Mobile" id="nl.setu.200801.businessrules.staffingorder.businessrule.Mobile.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:FormattedNumber)=1) and (normalize-space(setu:FormattedNumber) != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:FormattedNumber)=1) and (normalize-space(setu:FormattedNumber) != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element Mobile must contain exactly 1 FormattedNumber element, which must not be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M52" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M52" priority="-1" />
  <xsl:template match="@*|node()" mode="M52" priority="-2">
    <xsl:apply-templates mode="M52" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Fax.1-->
<xsl:template match="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod/setu:Fax" mode="M53" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod/setu:Fax" id="nl.setu.200801.businessrules.staffingorder.businessrule.Fax.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:InternationalCountryCode)=0) and (count(setu:NationalNumber)=0) and (count(setu:AreaCityCode)=0) and (count(setu:SubscriberNumber)=0) and (count(setu:Extension)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:InternationalCountryCode)=0) and (count(setu:NationalNumber)=0) and (count(setu:AreaCityCode)=0) and (count(setu:SubscriberNumber)=0) and (count(setu:Extension)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element Fax contains (a) subelement(s) that is/are not allowed.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M53" priority="-1" />
  <xsl:template match="@*|node()" mode="M53" priority="-2">
    <xsl:apply-templates mode="M53" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Fax.2-->
<xsl:template match="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod/setu:Fax" mode="M54" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:ContactMethod/setu:Fax" id="nl.setu.200801.businessrules.staffingorder.businessrule.Fax.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:FormattedNumber)=1) and (normalize-space(setu:FormattedNumber) != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:FormattedNumber)=1) and (normalize-space(setu:FormattedNumber) != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element Fax must contain exactly 1 FormattedNumber element, which must not be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M54" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M54" priority="-1" />
  <xsl:template match="@*|node()" mode="M54" priority="-2">
    <xsl:apply-templates mode="M54" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingPosition.1-->
<xsl:template match="/setu:StaffingOrder" mode="M55" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingPosition.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingPosition)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingPosition)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element StaffingPosition must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M55" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M55" priority="-1" />
  <xsl:template match="@*|node()" mode="M55" priority="-2">
    <xsl:apply-templates mode="M55" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PositionId.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:PositionId" mode="M56" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:PositionId" id="nl.setu.200801.businessrules.staffingorder.businessrule.PositionId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(@Id)=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(@Id)=''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute Id of the element PositionId must be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M56" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M56" priority="-1" />
  <xsl:template match="@*|node()" mode="M56" priority="-2">
    <xsl:apply-templates mode="M56" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PositionType.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:PositionType" mode="M57" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:PositionType" id="nl.setu.200801.businessrules.staffingorder.businessrule.PositionType.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($PositionType, concat(',', ., ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($PositionType, concat(',', ., ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element PositionType must contain one of the following values: <xsl:text />
            <xsl:value-of select="$PositionType" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M57" priority="-1" />
  <xsl:template match="@*|node()" mode="M57" priority="-2">
    <xsl:apply-templates mode="M57" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.RequestedPerson.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader" mode="M58" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader" id="nl.setu.200801.businessrules.staffingorder.businessrule.RequestedPerson.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:RequestedPerson) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:RequestedPerson) &lt;= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element RequestedPerson may exist at most 1 time.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M58" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M58" priority="-1" />
  <xsl:template match="@*|node()" mode="M58" priority="-2">
    <xsl:apply-templates mode="M58" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.FamilyName.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:RequestedPerson/setu:PersonName" mode="M59" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:RequestedPerson/setu:PersonName" id="nl.setu.200801.businessrules.staffingorder.businessrule.FamilyName.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:FamilyName) &lt;= 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:FamilyName) &lt;= 2">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element FamilyName may exist at most 2 times.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M59" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M59" priority="-1" />
  <xsl:template match="@*|node()" mode="M59" priority="-2">
    <xsl:apply-templates mode="M59" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.FamilyName.2-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:RequestedPerson/setu:PersonName//setu:FamilyName" mode="M60" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:RequestedPerson/setu:PersonName//setu:FamilyName" id="nl.setu.200801.businessrules.staffingorder.businessrule.FamilyName.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(normalize-space(@primary)='true') or (normalize-space(@primary)='false')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(normalize-space(@primary)='true') or (normalize-space(@primary)='false')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute primary of the element FamilyName must contain one of the following values: true, false.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M60" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M60" priority="-1" />
  <xsl:template match="@*|node()" mode="M60" priority="-2">
    <xsl:apply-templates mode="M60" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Affix.1-->
<xsl:template match="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:PersonName/setu:Affix" mode="M61" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder//setu:OrderContact/setu:ContactInfo/setu:PersonName/setu:Affix" id="nl.setu.200801.businessrules.staffingorder.businessrule.Affix.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@type)=1) and contains($Affix, concat(',', @type, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@type)=1) and contains($Affix, concat(',', @type, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute primary of the element FamilyName must contain one of the following values: <xsl:text />
            <xsl:value-of select="$Affix" />
            <xsl:text />
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M61" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M61" priority="-1" />
  <xsl:template match="@*|node()" mode="M61" priority="-2">
    <xsl:apply-templates mode="M61" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PersonId.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:RequestedPerson" mode="M62" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:RequestedPerson" id="nl.setu.200801.businessrules.staffingorder.businessrule.PersonId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:PersonId) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:PersonId) &lt;= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element PersonId may exist at most 2 times.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M62" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M62" priority="-1" />
  <xsl:template match="@*|node()" mode="M62" priority="-2">
    <xsl:apply-templates mode="M62" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PersonId.2-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:RequestedPerson" mode="M63" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:RequestedPerson" id="nl.setu.200801.businessrules.staffingorder.businessrule.PersonId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(setu:PersonName)=0) and (count(setu:PersonId) >= 0)) or not(count(setu:PersonName)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(setu:PersonName)=0) and (count(setu:PersonId) >= 0)) or not(count(setu:PersonName)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element PersonId must exist in case the element PersonName does not exist.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M63" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M63" priority="-1" />
  <xsl:template match="@*|node()" mode="M63" priority="-2">
    <xsl:apply-templates mode="M63" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PersonId.3-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:RequestedPerson//setu:PersonId" mode="M64" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:RequestedPerson//setu:PersonId" id="nl.setu.200801.businessrules.staffingorder.businessrule.PersonId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner) = 1) and ((normalize-space(@idOwner)='StaffingCustomer') or (normalize-space(@idOwner)='StaffingCompany'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner) = 1) and ((normalize-space(@idOwner)='StaffingCustomer') or (normalize-space(@idOwner)='StaffingCompany'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of OrderId may exist exactly once and should have a valid value, either 'StaffingCustomer' or 'StaffingCompany'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M64" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M64" priority="-1" />
  <xsl:template match="@*|node()" mode="M64" priority="-2">
    <xsl:apply-templates mode="M64" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PersonId.4-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:RequestedPerson//setu:PersonId" mode="M65" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:RequestedPerson//setu:PersonId" id="nl.setu.200801.businessrules.staffingorder.businessrule.PersonId.4" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:IdValue) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:IdValue) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element PersonId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M65" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M65" priority="-1" />
  <xsl:template match="@*|node()" mode="M65" priority="-2">
    <xsl:apply-templates mode="M65" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.ShiftWork.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:ShiftWork" mode="M66" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:ShiftWork" id="nl.setu.200801.businessrules.staffingorder.businessrule.ShiftWork.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(@haveShiftWork)='true'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(@haveShiftWork)='true'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute haveShiftWork of the element ShiftWork must contain the following value: true.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M66" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M66" priority="-1" />
  <xsl:template match="@*|node()" mode="M66" priority="-2">
    <xsl:apply-templates mode="M66" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.ShiftWork.2-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:ShiftWork" mode="M67" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionHeader/setu:ShiftWork" id="nl.setu.200801.businessrules.staffingorder.businessrule.ShiftWork.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:Description)=1) and (normalize-space(setu:Description)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:Description)=1) and (normalize-space(setu:Description)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement Description of the element ShiftWork must exist exactly once and may not be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M67" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M67" priority="-1" />
  <xsl:template match="@*|node()" mode="M67" priority="-2">
    <xsl:apply-templates mode="M67" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.CustomerReportingRequirements.2-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:CustomerReportingRequirements" mode="M68" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:CustomerReportingRequirements" id="nl.setu.200801.businessrules.staffingorder.businessrule.CustomerReportingRequirements.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(*)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(*)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element CustomerReportingRequirements of the element StaffingPosition may not contain any subelements.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M68" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M68" priority="-1" />
  <xsl:template match="@*|node()" mode="M68" priority="-2">
    <xsl:apply-templates mode="M68" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PositionReason.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionReason" mode="M69" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionReason" id="nl.setu.200801.businessrules.staffingorder.businessrule.PositionReason.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($PositionReason, concat(',', ., ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($PositionReason, concat(',', ., ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element PositionReason must contain one of the following values: <xsl:text />
            <xsl:value-of select="$PositionReason" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M69" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M69" priority="-1" />
  <xsl:template match="@*|node()" mode="M69" priority="-2">
    <xsl:apply-templates mode="M69" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PositionDateRange.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionDateRange" mode="M70" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:PositionDateRange" id="nl.setu.200801.businessrules.staffingorder.businessrule.PositionDateRange.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:ActualEndDate)=0) and (count(setu:MaxStartDate)=0) and (count(setu:StartAsSoonAsPossible)=0) and (count(setu:MaxNeedEndDate)=0) and (count(setu:PositionDuration)=0) and (count(setu:ExtensionParameters)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:ActualEndDate)=0) and (count(setu:MaxStartDate)=0) and (count(setu:StartAsSoonAsPossible)=0) and (count(setu:MaxNeedEndDate)=0) and (count(setu:PositionDuration)=0) and (count(setu:ExtensionParameters)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element PositionDateRange contains (a) subelement(s) that is/are not allowed.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M70" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M70" priority="-1" />
  <xsl:template match="@*|node()" mode="M70" priority="-2">
    <xsl:apply-templates mode="M70" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.RateType.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates" mode="M71" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates" id="nl.setu.200801.businessrules.staffingorder.businessrule.RateType.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($RateType, concat(',', @rateType, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($RateType, concat(',', @rateType, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute rateType of the element Rates must contain one of the following values: <xsl:text />
            <xsl:value-of select="$RateType" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@rateType" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M71" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M71" priority="-1" />
  <xsl:template match="@*|node()" mode="M71" priority="-2">
    <xsl:apply-templates mode="M71" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.RateStatus.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates" mode="M72" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates" id="nl.setu.200801.businessrules.staffingorder.businessrule.RateStatus.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($RateStatus, concat(',', @rateStatus, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($RateStatus, concat(',', @rateStatus, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute rateStatus of the element Rates ust contain one of the following values: <xsl:text />
            <xsl:value-of select="$RateStatus" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@rateType" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M72" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M72" priority="-1" />
  <xsl:template match="@*|node()" mode="M72" priority="-2">
    <xsl:apply-templates mode="M72" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.ExternalRateSetId.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates/setu:ExternalRateSetId" mode="M73" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates/setu:ExternalRateSetId" id="nl.setu.200801.businessrules.staffingorder.businessrule.ExternalRateSetId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:IdValue)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:IdValue)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element ExternalRateSetId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M73" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M73" priority="-1" />
  <xsl:template match="@*|node()" mode="M73" priority="-2">
    <xsl:apply-templates mode="M73" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Amount.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates/setu:Amount" mode="M74" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates/setu:Amount" id="nl.setu.200801.businessrules.staffingorder.businessrule.Amount.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($Amount, concat(',', @rateAmountPeriod, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($Amount, concat(',', @rateAmountPeriod, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute rateAmountPeriod of the element Amount must contain one of the following values: <xsl:text />
            <xsl:value-of select="$Amount" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@rateAmountPeriod" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M74" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M74" priority="-1" />
  <xsl:template match="@*|node()" mode="M74" priority="-2">
    <xsl:apply-templates mode="M74" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Class.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates/setu:Class" mode="M75" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates/setu:Class" id="nl.setu.200801.businessrules.staffingorder.businessrule.Class.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($Class, concat(',', ., ',')) or (. = '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($Class, concat(',', ., ',')) or (. = '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element Class must be empty or contain one of the following values: <xsl:text />
            <xsl:value-of select="$Class" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M75" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M75" priority="-1" />
  <xsl:template match="@*|node()" mode="M75" priority="-2">
    <xsl:apply-templates mode="M75" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Multiplier.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates" mode="M76" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates" id="nl.setu.200801.businessrules.staffingorder.businessrule.Multiplier.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:Multiplier) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:Multiplier) &lt;= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement Multiplier of the element Rates may exist at most once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M76" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M76" priority="-1" />
  <xsl:template match="@*|node()" mode="M76" priority="-2">
    <xsl:apply-templates mode="M76" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.RatesId.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates/setu:RatesId" mode="M77" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates/setu:RatesId" id="nl.setu.200801.businessrules.staffingorder.businessrule.RatesId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:IdValue)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:IdValue)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element RatesId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M77" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M77" priority="-1" />
  <xsl:template match="@*|node()" mode="M77" priority="-2">
    <xsl:apply-templates mode="M77" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.CustomerRateClassification.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates/setu:CustomerRateClassification" mode="M78" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition//setu:Rates/setu:CustomerRateClassification" id="nl.setu.200801.businessrules.staffingorder.businessrule.CustomerRateClassification.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:IdValue)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:IdValue)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element CustomerRateClassification must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M78" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M78" priority="-1" />
  <xsl:template match="@*|node()" mode="M78" priority="-2">
    <xsl:apply-templates mode="M78" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PostalAddress.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:WorkSite/setu:PostalAddress/setu:DeliveryAddress" mode="M79" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:WorkSite/setu:PostalAddress/setu:DeliveryAddress" id="nl.setu.200801.businessrules.staffingorder.businessrule.PostalAddress.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:AddressLine)=0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:AddressLine)=0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element AddressLine of the element DeliveryAddress may not exist.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M79" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M79" priority="-1" />
  <xsl:template match="@*|node()" mode="M79" priority="-2">
    <xsl:apply-templates mode="M79" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PostalAddress.2-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:WorkSite/setu:PostalAddress/setu:DeliveryAddress" mode="M80" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:WorkSite/setu:PostalAddress/setu:DeliveryAddress" id="nl.setu.200801.businessrules.staffingorder.businessrule.PostalAddress.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./*) >= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./*) >= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element DeliveryAddress must contain at least one sub-element.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M80" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M80" priority="-1" />
  <xsl:template match="@*|node()" mode="M80" priority="-2">
    <xsl:apply-templates mode="M80" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingShift.1-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition" mode="M81" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingShift.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingShift)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingShift)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element StaffingShift must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M81" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M81" priority="-1" />
  <xsl:template match="@*|node()" mode="M81" priority="-2">
    <xsl:apply-templates mode="M81" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingShift.3-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:StaffingShift" mode="M82" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:StaffingShift" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingShift.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($StaffingShift, concat(',', @shiftPeriod, ',')) or not(@shiftPeriod)" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($StaffingShift, concat(',', @shiftPeriod, ',')) or not(@shiftPeriod)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute shiftPeriod of the element StaffingShift must contain one of the following values: <xsl:text />
            <xsl:value-of select="$StaffingShift" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@shiftPeriod" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M82" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M82" priority="-1" />
  <xsl:template match="@*|node()" mode="M82" priority="-2">
    <xsl:apply-templates mode="M82" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingShift.4-->
<xsl:template match="/setu:StaffingOrder/setu:StaffingPosition/setu:StaffingShift/setu:Id//setu:IdValue" mode="M83" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:StaffingPosition/setu:StaffingShift/setu:Id//setu:IdValue" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingShift.4" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.)=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.)=''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element Id of the element StaffingShift must be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M83" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M83" priority="-1" />
  <xsl:template match="@*|node()" mode="M83" priority="-2">
    <xsl:apply-templates mode="M83" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.UserArea.1-->
<xsl:template match="/setu:StaffingOrder" mode="M84" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.200801.businessrules.staffingorder.businessrule.UserArea.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:UserArea) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:UserArea) > 0">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element UserArea must exist at least once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M84" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M84" priority="-1" />
  <xsl:template match="@*|node()" mode="M84" priority="-2">
    <xsl:apply-templates mode="M84" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.StaffingOrderAdditionalNL.1-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea" mode="M85" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea" id="nl.setu.200801.businessrules.staffingorder.businessrule.StaffingOrderAdditionalNL.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(nl:StaffingOrderAdditionalNL)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(nl:StaffingOrderAdditionalNL)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element StaffingOrderAdditionalNL must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M85" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M85" priority="-1" />
  <xsl:template match="@*|node()" mode="M85" priority="-2">
    <xsl:apply-templates mode="M85" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.SETUVersionId.1-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL" mode="M86" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL" id="nl.setu.200801.businessrules.staffingorder.businessrule.SETUVersionId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(nl:SETUVersionId)='1.4'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(nl:SETUVersionId)='1.4'">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element SETUVersionId must contain the following value: 1.4.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M86" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M86" priority="-1" />
  <xsl:template match="@*|node()" mode="M86" priority="-2">
    <xsl:apply-templates mode="M86" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.OfferId.1-->
<xsl:template match="/setu:StaffingOrder" mode="M87" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.200801.businessrules.staffingorder.businessrule.OfferId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:OfferId)=1) and (normalize-space(setu:OrderClassification/@orderType) = 'order')) or not(count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:OfferId)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:OfferId)=1) and (normalize-space(setu:OrderClassification/@orderType) = 'order')) or not(count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:OfferId)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element OfferId may only be used when orderType='order'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M87" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M87" priority="-1" />
  <xsl:template match="@*|node()" mode="M87" priority="-2">
    <xsl:apply-templates mode="M87" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.OfferId.2-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:OfferId" mode="M88" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:OfferId" id="nl.setu.200801.businessrules.staffingorder.businessrule.OfferId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and (normalize-space(@idOwner) = 'StaffingCompany')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and (normalize-space(@idOwner) = 'StaffingCompany')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element OfferId must exist exactly once and contain the following value: StaffingCompany.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M88" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M88" priority="-1" />
  <xsl:template match="@*|node()" mode="M88" priority="-2">
    <xsl:apply-templates mode="M88" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.OfferId.3-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:OfferId" mode="M89" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:OfferId" id="nl.setu.200801.businessrules.staffingorder.businessrule.OfferId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue) != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue) != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element OfferId must exist exactly once and may not be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M89" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M89" priority="-1" />
  <xsl:template match="@*|node()" mode="M89" priority="-2">
    <xsl:apply-templates mode="M89" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PreviousOrderId.1-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:PreviousOrderId" mode="M90" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:PreviousOrderId" id="nl.setu.200801.businessrules.staffingorder.businessrule.PreviousOrderId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of PreviousOrderId may exist exactly once and should have a valid value, either 'StaffingCustomer' or 'StaffingCompany'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M90" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M90" priority="-1" />
  <xsl:template match="@*|node()" mode="M90" priority="-2">
    <xsl:apply-templates mode="M90" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.PreviousOrderId.2-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:PreviousOrderId" mode="M91" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:PreviousOrderId" id="nl.setu.200801.businessrules.staffingorder.businessrule.PreviousOrderId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue) != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue) != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element PreviousOrderId must exist exactly once and may not be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M91" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M91" priority="-1" />
  <xsl:template match="@*|node()" mode="M91" priority="-2">
    <xsl:apply-templates mode="M91" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.RFQOrderId.1-->
<xsl:template match="/setu:StaffingOrder" mode="M92" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.200801.businessrules.staffingorder.businessrule.RFQOrderId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:RFQOrderId)=1) and (normalize-space(setu:OrderClassification/@orderType) = 'order')) or not(count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:RFQOrderId)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:RFQOrderId)=1) and (normalize-space(setu:OrderClassification/@orderType) = 'order')) or not(count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:RFQOrderId)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element RFQOrderId may only be used when orderType='order'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M92" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M92" priority="-1" />
  <xsl:template match="@*|node()" mode="M92" priority="-2">
    <xsl:apply-templates mode="M92" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.RFQOrderId.2-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:RFQOrderId" mode="M93" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:RFQOrderId" id="nl.setu.200801.businessrules.staffingorder.businessrule.RFQOrderId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of RFQOrderId may exist exactly once and should have a valid value, either 'StaffingCustomer' or 'StaffingCompany'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M93" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M93" priority="-1" />
  <xsl:template match="@*|node()" mode="M93" priority="-2">
    <xsl:apply-templates mode="M93" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.RFQOrderId.3-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:RFQOrderId" mode="M94" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:RFQOrderId" id="nl.setu.200801.businessrules.staffingorder.businessrule.RFQOrderId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue) != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue) != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element RFQOrderId must exist exactly once and may not be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M94" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M94" priority="-1" />
  <xsl:template match="@*|node()" mode="M94" priority="-2">
    <xsl:apply-templates mode="M94" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Degree.1-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution/setu:Degree" mode="M95" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution/setu:Degree" id="nl.setu.200801.businessrules.staffingorder.businessrule.Degree.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($Degree, concat(',', @degreeType, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($Degree, concat(',', @degreeType, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute degreeType of the element Degree must contain one of the following values: <xsl:text />
            <xsl:value-of select="$Degree" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@degreeType" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M95" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M95" priority="-1" />
  <xsl:template match="@*|node()" mode="M95" priority="-2">
    <xsl:apply-templates mode="M95" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.LocalInstitutionClassification.1-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution" mode="M96" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution" id="nl.setu.200801.businessrules.staffingorder.businessrule.LocalInstitutionClassification.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:LocalInstitutionClassification) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:LocalInstitutionClassification) &lt;= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element LocalInstitutionClassification may exist at most 1 time.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M96" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M96" priority="-1" />
  <xsl:template match="@*|node()" mode="M96" priority="-2">
    <xsl:apply-templates mode="M96" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.LocalInstitutionClassification.2-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution/setu:LocalInstitutionClassification/setu:Id" mode="M97" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution/setu:LocalInstitutionClassification/setu:Id" id="nl.setu.200801.businessrules.staffingorder.businessrule.LocalInstitutionClassification.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:IdValue)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:IdValue)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement Id/IdValue of the element LocalInstitutionClassification must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M97" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M97" priority="-1" />
  <xsl:template match="@*|node()" mode="M97" priority="-2">
    <xsl:apply-templates mode="M97" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.LocalInstitutionClassification.3-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution/setu:LocalInstitutionClassification/setu:Id" mode="M98" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution/setu:LocalInstitutionClassification/setu:Id" id="nl.setu.200801.businessrules.staffingorder.businessrule.LocalInstitutionClassification.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner) = 1) and (normalize-space(@idOwner)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner) = 1) and (normalize-space(@idOwner)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element LocalInstitutionClassification must exist exactly once and may not be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M98" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M98" priority="-1" />
  <xsl:template match="@*|node()" mode="M98" priority="-2">
    <xsl:apply-templates mode="M98" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.LocalInstitutionClassification.4-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution" mode="M99" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution" id="nl.setu.200801.businessrules.staffingorder.businessrule.LocalInstitutionClassification.4" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:Degree) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:Degree) &lt;= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement Degree of the element LocalInstitutionClassification may exist at most 1 time.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M99" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M99" priority="-1" />
  <xsl:template match="@*|node()" mode="M99" priority="-2">
    <xsl:apply-templates mode="M99" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.WorkingAndThinkingLevel.1-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:Qualitifications//setu:Competency" mode="M100" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:Qualitifications//setu:Competency" id="nl.setu.200801.businessrules.staffingorder.businessrule.WorkingAndThinkingLevel.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((normalize-space(@name)='WorkingAndThinkingLevel') and contains($Degree, concat(',', @description, ','))) or not((normalize-space(@name)='WorkingAndThinkingLevel'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((normalize-space(@name)='WorkingAndThinkingLevel') and contains($Degree, concat(',', @description, ','))) or not((normalize-space(@name)='WorkingAndThinkingLevel'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute description of the element Compentency must contain one of the following values when name = 'WorkingAndThinkingLevel': <xsl:text />
            <xsl:value-of select="$Degree" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@description" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M100" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M100" priority="-1" />
  <xsl:template match="@*|node()" mode="M100" priority="-2">
    <xsl:apply-templates mode="M100" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Competency.1-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:Qualitifications//setu:Competency" mode="M101" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:Qualitifications//setu:Competency" id="nl.setu.200801.businessrules.staffingorder.businessrule.Competency.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@name) = 1) and (normalize-space(@name)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@name) = 1) and (normalize-space(@name)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute name of the element Competency must exist exactly once and may not be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M101" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M101" priority="-1" />
  <xsl:template match="@*|node()" mode="M101" priority="-2">
    <xsl:apply-templates mode="M101" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.Competency.2-->
<xsl:template match="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:Qualitifications//setu:Competency" mode="M102" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder/setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StructuredXMLResume/setu:Qualitifications//setu:Competency" id="nl.setu.200801.businessrules.staffingorder.businessrule.Competency.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@description) = 1) and (normalize-space(@description)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@description) = 1) and (normalize-space(@description)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute description of the element Competency must exist exactly once and may not be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M102" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M102" priority="-1" />
  <xsl:template match="@*|node()" mode="M102" priority="-2">
    <xsl:apply-templates mode="M102" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.CLAReference.1-->
<xsl:template match="//nl:CLAReference" mode="M103" priority="1000">
    <svrl:fired-rule context="//nl:CLAReference" id="nl.setu.200801.businessrules.staffingorder.businessrule.CLAReference.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(nl:Description) = 1) or (count(nl:CLAId) = 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(nl:Description) = 1) or (count(nl:CLAId) = 1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element CLAReference must at least contain either Description or CLAId. Both is allowed as well.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M103" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M103" priority="-1" />
  <xsl:template match="@*|node()" mode="M103" priority="-2">
    <xsl:apply-templates mode="M103" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.staffingorder.businessrule.InclusiveRate.1-->
<xsl:template match="/setu:StaffingOrder" mode="M104" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.200801.businessrules.staffingorder.businessrule.InclusiveRate.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(setu:StaffingPosition/setu:Rates) > 0) and  (count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:InclusiveRate) = 1)) or not(count(setu:StaffingPosition/setu:Rates) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(setu:StaffingPosition/setu:Rates) > 0) and (count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:InclusiveRate) = 1)) or not(count(setu:StaffingPosition/setu:Rates) > 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element InclusiveRate must exist when an element Rates is present.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M104" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M104" priority="-1" />
  <xsl:template match="@*|node()" mode="M104" priority="-2">
    <xsl:apply-templates mode="M104" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.businessrule.320-->
<xsl:template match="/setu:StaffingOrder" mode="M105" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.businessrule.320" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(setu:StaffingPosition/setu:StaffingShift/setu:Hours) > 0) and not(count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StaffingShiftAddition) > 0))                                      or (not(count(setu:StaffingPosition/setu:StaffingShift/setu:Hours) > 0) and (count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StaffingShiftAddition) > 0))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(setu:StaffingPosition/setu:StaffingShift/setu:Hours) > 0) and not(count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StaffingShiftAddition) > 0)) or (not(count(setu:StaffingPosition/setu:StaffingShift/setu:Hours) > 0) and (count(setu:UserArea/nl:StaffingOrderAdditionalNL/nl:StaffingShiftAddition) > 0))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                If you specify Hours, do not use MinimumHours and MaximumHours. If you specify MinimumHours and/or MaximumHours, do no use Hours.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M105" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M105" priority="-1" />
  <xsl:template match="@*|node()" mode="M105" priority="-2">
    <xsl:apply-templates mode="M105" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.businessrule.321-->
<xsl:template match="/setu:StaffingOrder" mode="M106" priority="1000">
    <svrl:fired-rule context="/setu:StaffingOrder" id="nl.setu.businessrule.321" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:StaffingPosition/setu:StaffingShift[@shiftPeriod]) > 0)                      or (count(setu:CustomerReportingRequirements/setu:AdditionalRequirement[@requirementTitle = 'shiftPeriodExtension']) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:StaffingPosition/setu:StaffingShift[@shiftPeriod]) > 0) or (count(setu:CustomerReportingRequirements/setu:AdditionalRequirement[@requirementTitle = 'shiftPeriodExtension']) > 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                You must specify the shiftPeriod
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M106" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M106" priority="-1" />
  <xsl:template match="@*|node()" mode="M106" priority="-2">
    <xsl:apply-templates mode="M106" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2022.businessrules.staffingorder.businessrule.CustomerRateClassification.1-->
<xsl:template match="//setu:Rates/setu:CustomerRateClassification/setu:IdValue" mode="M107" priority="1000">
    <svrl:fired-rule context="//setu:Rates/setu:CustomerRateClassification/setu:IdValue" id="nl.setu.2022.businessrules.staffingorder.businessrule.CustomerRateClassification.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($SETU_CL_HourTypes, concat(',', ., ',')) or contains($SETU_CL_ExpenseAllowanceTypes, concat(',', ., ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($SETU_CL_HourTypes, concat(',', ., ',')) or contains($SETU_CL_ExpenseAllowanceTypes, concat(',', ., ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
            Value '
            <xsl:text />
            <xsl:value-of select="." />
            <xsl:text />
            ' is not part of codelist Hour types or Expense and Allowance types.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M107" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M107" priority="-1" />
  <xsl:template match="@*|node()" mode="M107" priority="-2">
    <xsl:apply-templates mode="M107" select="*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
