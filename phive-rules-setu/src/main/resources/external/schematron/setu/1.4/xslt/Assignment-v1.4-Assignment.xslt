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
    <svrl:schematron-output schemaVersion="nl.setu.200801.businessrules.assignment" title="Business rules voor het controleren van een assignment bericht (SETU Standard for Assignment versie 1.4.1).">
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
      <xsl:apply-templates mode="M14" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M15" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M16" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M17" select="/" />
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
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Business rules voor het controleren van een assignment bericht (SETU Standard for Assignment versie 1.4.1).</svrl:text>
  <xsl:param name="AssignmentStatus" select="',active,revised,cancelled,x:rejected,'" />
  <xsl:param name="IdOwner" select="',StaffingCustomer,StaffingCompany,KvK,OIN,BTW,Fi,'" />
  <xsl:param name="RateType" select="',pay,bill,'" />
  <xsl:param name="Class" select="',TimeInterval,Allowance,Expense,'" />
  <xsl:param name="StaffingShift" select="',weekly,monthly,daily,1,2,3,4,5,6,7,'" />
  <xsl:param name="StaffingShiftAddition" select="',1,2,3,4,5,6,7,daily,weekly,monthly,4weekly,quarterly,yearly,'" />
  <xsl:param name="EmployeePhase" select="',A,B,C,1,2,3,4,'" />
  <xsl:param name="Amount" select="',hourly,x:hourlysplit,x:hourlyconsolidated,daily,weekly,x:4weekly,monthly,yearly,perunit,flatfee,'" />
  <xsl:param name="PositionType" select="',recruitment and selection,secondment,temporary staffing,payroll,'" />
  <xsl:param name="SETU_CL_HourTypes" select="',Additional wage dispensation,Adoption leave,Child-birth sick time,Internship,Overtime wage dispensation,Pregnancy sick time,Regular wage dispensation,Shift wage dispensation,Transition allowance,Vacation additional,Additionalplus,Regular canceled,Shift canceled,Shiftplus canceled,Additional canceled,Additionalplus canceled,Regular complemented,Additional complemented,Shift complemented,Overtime complemented,Overtime canceled,Overtimeplus canceled,Regular,Overtime,Overtimeplus,Shift,Shiftplus,Attendance,Travel,Additional,Internal,Time for time hour build-up,Time for time overtime hour build-up,Special Leave,Short leave,Holiday,Unpaid leave,Training,Vacation,Reduction of working hours,Sick time,Work underload,Care Leave,WTR (work time reduction),Compensation leave,Funeral,Maternity Leave,Withdrawal time for time hours,Contract hours,Standby,Break,'" />
  <xsl:param name="SETU_CL_ExpenseAllowanceTypes" select="',100,100B,100O,101,101B,101O,102,102B,102O,103,103B,103O,104,104B,104O,105,105B,105O,106,106B,106O,107,107B,107O,201,201B,201O,202,202B,202O,203,203B,203O,300,300B,300O,301,301B,301O,302,302B,302O,303,303B,303O,304,304B,304O,400,400B,400O,501,501B,501O,502,502B,502O,503,503B,503O,600,600B,600O,601,601B,601O,602,602B,602O,603,603B,603O,604,604B,604O,701,701B,701O,702,702B,702O,703,703B,703O,801,801B,801O,802,802B,802O,803,803B,803O,900,900B,900O,901,901B,901O,903,903B,903O,904,904B,904O,905,905B,905O,906,906B,906O,907,907B,907O,908,908B,908O,909,909B,909O,910,910B,910O,911,911B,911O,912,912B,912O,913,913B,913O,914,914B,914O,'" />

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.AssignmentStatus.1-->
<xsl:template match="/setu:Assignment" mode="M14" priority="1000">
    <svrl:fired-rule context="/setu:Assignment" id="nl.setu.200801.businessrules.assignment.businessrule.AssignmentStatus.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($AssignmentStatus, concat(',', @assignmentStatus, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($AssignmentStatus, concat(',', @assignmentStatus, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute assignmentStatus of the element Assignment must contain one of the following values: <xsl:text />
            <xsl:value-of select="$AssignmentStatus" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@assignmentStatus" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.AssignmentId.1-->
<xsl:template match="/setu:Assignment" mode="M15" priority="1000">
    <svrl:fired-rule context="/setu:Assignment" id="nl.setu.200801.businessrules.assignment.businessrule.AssignmentId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:AssignmentId)= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:AssignmentId)= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element AssignmentId of Assignment must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M15" priority="-1" />
  <xsl:template match="@*|node()" mode="M15" priority="-2">
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.AssignmentId.2-->
<xsl:template match="/setu:Assignment/setu:AssignmentId" mode="M16" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:AssignmentId" id="nl.setu.200801.businessrules.assignment.businessrule.AssignmentId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)= 1) and (normalize-space(@idOwner) = 'StaffingCompany') " />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)= 1) and (normalize-space(@idOwner) = 'StaffingCompany')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of AssignmentId must exist exactly once and should have a valid value: 'StaffingCompany'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M16" priority="-1" />
  <xsl:template match="@*|node()" mode="M16" priority="-2">
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.AssignmentId.3-->
<xsl:template match="/setu:Assignment/setu:AssignmentId" mode="M17" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:AssignmentId" id="nl.setu.200801.businessrules.assignment.businessrule.AssignmentId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)= 1) and (normalize-space(setu:IdValue) != '') " />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)= 1) and (normalize-space(setu:IdValue) != '')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element IdValue of AssignmentId must exist exactly once and may not be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M17" priority="-1" />
  <xsl:template match="@*|node()" mode="M17" priority="-2">
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.ReferenceInformation.1-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation" mode="M18" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation" id="nl.setu.200801.businessrules.assignment.businessrule.ReferenceInformation.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IntermediaryId)=0) and (count(setu:BillToEntityId)=0) and (count(setu:TimeCardId)=0) and (count(setu:InvoiceId)=0) and (count(setu:StaffingOrganizationId)=0) and (count(setu:UserArea)=0) and (count(setu:MasterOrderId)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IntermediaryId)=0) and (count(setu:BillToEntityId)=0) and (count(setu:TimeCardId)=0) and (count(setu:InvoiceId)=0) and (count(setu:StaffingOrganizationId)=0) and (count(setu:UserArea)=0) and (count(setu:MasterOrderId)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element ReferenceInformation contains (a) subelement(s) that is/are not allowed.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M18" priority="-1" />
  <xsl:template match="@*|node()" mode="M18" priority="-2">
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerId.1-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation" mode="M19" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerId.1" />

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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M19" priority="-1" />
  <xsl:template match="@*|node()" mode="M19" priority="-2">
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerId.2-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation" mode="M20" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingCustomerId) >=1" />
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M20" priority="-1" />
  <xsl:template match="@*|node()" mode="M20" priority="-2">
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerId.3-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation//setu:StaffingCustomerId" mode="M21" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation//setu:StaffingCustomerId" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerId.3" />

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
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M21" priority="-1" />
  <xsl:template match="@*|node()" mode="M21" priority="-2">
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerId.4-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation//setu:StaffingCustomerId" mode="M22" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation//setu:StaffingCustomerId" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerId.4" />

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
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M22" priority="-1" />
  <xsl:template match="@*|node()" mode="M22" priority="-2">
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerOrgUnitId.1-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation" mode="M23" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerOrgUnitId.1" />

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
    <xsl:apply-templates mode="M23" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M23" priority="-1" />
  <xsl:template match="@*|node()" mode="M23" priority="-2">
    <xsl:apply-templates mode="M23" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerOrgUnitId.3-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" mode="M24" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerOrgUnitId.3" />

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
    <xsl:apply-templates mode="M24" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M24" priority="-1" />
  <xsl:template match="@*|node()" mode="M24" priority="-2">
    <xsl:apply-templates mode="M24" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerOrgUnitId.4-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" mode="M25" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingCustomerOrgUnitId.4" />

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
    <xsl:apply-templates mode="M25" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M25" priority="-1" />
  <xsl:template match="@*|node()" mode="M25" priority="-2">
    <xsl:apply-templates mode="M25" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.OrderId.1-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation" mode="M26" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation" id="nl.setu.200801.businessrules.assignment.businessrule.OrderId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:OrderId) &lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:OrderId) &lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element OrderId may exist at most once. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M26" priority="-1" />
  <xsl:template match="@*|node()" mode="M26" priority="-2">
    <xsl:apply-templates mode="M26" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.OrderId.2-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation/setu:OrderId" mode="M27" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation/setu:OrderId" id="nl.setu.200801.businessrules.assignment.businessrule.OrderId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element OrderId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M27" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M27" priority="-1" />
  <xsl:template match="@*|node()" mode="M27" priority="-2">
    <xsl:apply-templates mode="M27" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.HumanResourceId.1-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation" mode="M28" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation" id="nl.setu.200801.businessrules.assignment.businessrule.HumanResourceId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:HumanResourceId) = count(setu:HumanResourceId[not(@idOwner = preceding-sibling::setu:HumanResourceId/@idOwner)])" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:HumanResourceId) = count(setu:HumanResourceId[not(@idOwner = preceding-sibling::setu:HumanResourceId/@idOwner)])">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The idOwner attributes of the HumanResourceId elements are not unique. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M28" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M28" priority="-1" />
  <xsl:template match="@*|node()" mode="M28" priority="-2">
    <xsl:apply-templates mode="M28" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.HumanResourceId.2-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation" mode="M29" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation" id="nl.setu.200801.businessrules.assignment.businessrule.HumanResourceId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:HumanResourceId) >=1) and (count(setu:HumanResourceId) &lt;=2) " />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:HumanResourceId) >=1) and (count(setu:HumanResourceId) &lt;=2)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element HumanResourceId must exist at least once and at most twice. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M29" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M29" priority="-1" />
  <xsl:template match="@*|node()" mode="M29" priority="-2">
    <xsl:apply-templates mode="M29" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.HumanResourceId.3-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation//setu:HumanResourceId" mode="M30" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation//setu:HumanResourceId" id="nl.setu.200801.businessrules.assignment.businessrule.HumanResourceId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and        ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany')) " />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element HumanResourceId must exist exactly once and should have a valid value, either 'StaffingCustomer' or 'StaffingCompany'. 
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M30" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M30" priority="-1" />
  <xsl:template match="@*|node()" mode="M30" priority="-2">
    <xsl:apply-templates mode="M30" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.HumanResourceId.4-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation//setu:HumanResourceId" mode="M31" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation//setu:HumanResourceId" id="nl.setu.200801.businessrules.assignment.businessrule.HumanResourceId.4" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element HumanResourceId must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M31" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M31" priority="-1" />
  <xsl:template match="@*|node()" mode="M31" priority="-2">
    <xsl:apply-templates mode="M31" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.PositionId.1-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation//setu:PositionId" mode="M32" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation//setu:PositionId" id="nl.setu.200801.businessrules.assignment.businessrule.PositionId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(normalize-space(setu:IdValue)='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(normalize-space(setu:IdValue)='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element PositionId must be empty.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M32" priority="-1" />
  <xsl:template match="@*|node()" mode="M32" priority="-2">
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingSupplierId.1-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation" mode="M33" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingSupplierId.1" />

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
    <xsl:apply-templates mode="M33" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M33" priority="-1" />
  <xsl:template match="@*|node()" mode="M33" priority="-2">
    <xsl:apply-templates mode="M33" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingSupplierId.3-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation//setu:StaffingSupplierId" mode="M34" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation//setu:StaffingSupplierId" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingSupplierId.3" />

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
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M34" priority="-1" />
  <xsl:template match="@*|node()" mode="M34" priority="-2">
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingSupplierId.4-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation//setu:StaffingSupplierId" mode="M35" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation//setu:StaffingSupplierId" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingSupplierId.4" />

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
    <xsl:apply-templates mode="M35" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M35" priority="-1" />
  <xsl:template match="@*|node()" mode="M35" priority="-2">
    <xsl:apply-templates mode="M35" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingSupplierOrgUnitId.1-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation" mode="M36" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingSupplierOrgUnitId.1" />

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
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M36" priority="-1" />
  <xsl:template match="@*|node()" mode="M36" priority="-2">
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingSupplierOrgUnitId.3-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" mode="M37" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingSupplierOrgUnitId.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and contains($IdOwner, concat(',', @idOwner, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element StaffingSupplierOrgUnitId must exist exactly once and should have a valid value:  <xsl:text />
            <xsl:value-of select="$IdOwner" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@idOwner" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M37" priority="-1" />
  <xsl:template match="@*|node()" mode="M37" priority="-2">
    <xsl:apply-templates mode="M37" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingSupplierOrgUnitId.4-->
<xsl:template match="/setu:Assignment/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" mode="M38" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingSupplierOrgUnitId.4" />

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
    <xsl:apply-templates mode="M38" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M38" priority="-1" />
  <xsl:template match="@*|node()" mode="M38" priority="-2">
    <xsl:apply-templates mode="M38" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.CustomerReportingRequirements.1-->
<xsl:template match="/setu:Assignment/setu:CustomerReportingRequirements" mode="M39" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:CustomerReportingRequirements" id="nl.setu.200801.businessrules.assignment.businessrule.CustomerReportingRequirements.1" />

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
    <xsl:apply-templates mode="M39" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M39" priority="-1" />
  <xsl:template match="@*|node()" mode="M39" priority="-2">
    <xsl:apply-templates mode="M39" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.AdditionalRequirement.1-->
<xsl:template match="/setu:Assignment/setu:CustomerReportingRequirements//setu:AdditionalRequirement" mode="M40" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:CustomerReportingRequirements//setu:AdditionalRequirement" id="nl.setu.200801.businessrules.assignment.businessrule.AdditionalRequirement.1" />

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
    <xsl:apply-templates mode="M40" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M40" priority="-1" />
  <xsl:template match="@*|node()" mode="M40" priority="-2">
    <xsl:apply-templates mode="M40" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.RateType.1-->
<xsl:template match="/setu:Assignment//setu:Rates" mode="M41" priority="1000">
    <svrl:fired-rule context="/setu:Assignment//setu:Rates" id="nl.setu.200801.businessrules.assignment.businessrule.RateType.1" />

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
    <xsl:apply-templates mode="M41" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M41" priority="-1" />
  <xsl:template match="@*|node()" mode="M41" priority="-2">
    <xsl:apply-templates mode="M41" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.RateStatus.1-->
<xsl:template match="/setu:Assignment//setu:Rates" mode="M42" priority="1000">
    <svrl:fired-rule context="/setu:Assignment//setu:Rates" id="nl.setu.200801.businessrules.assignment.businessrule.RateStatus.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(normalize-space(@rateStatus) = 'agreed') " />
      <xsl:otherwise>
        <svrl:failed-assert test="(normalize-space(@rateStatus) = 'agreed')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute rateStatus of Rates should have a valid value: 'agreed'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M42" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M42" priority="-1" />
  <xsl:template match="@*|node()" mode="M42" priority="-2">
    <xsl:apply-templates mode="M42" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.ExternalRateSetId.1-->
<xsl:template match="/setu:Assignment//setu:Rates/setu:ExternalRateSetId" mode="M43" priority="1000">
    <svrl:fired-rule context="/setu:Assignment//setu:Rates/setu:ExternalRateSetId" id="nl.setu.200801.businessrules.assignment.businessrule.ExternalRateSetId.1" />

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
    <xsl:apply-templates mode="M43" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M43" priority="-1" />
  <xsl:template match="@*|node()" mode="M43" priority="-2">
    <xsl:apply-templates mode="M43" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.Amount.1-->
<xsl:template match="/setu:Assignment//setu:Rates/setu:Amount" mode="M44" priority="1000">
    <svrl:fired-rule context="/setu:Assignment//setu:Rates/setu:Amount" id="nl.setu.200801.businessrules.assignment.businessrule.Amount.1" />

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
    <xsl:apply-templates mode="M44" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M44" priority="-1" />
  <xsl:template match="@*|node()" mode="M44" priority="-2">
    <xsl:apply-templates mode="M44" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.Class.1-->
<xsl:template match="/setu:Assignment//setu:Rates/setu:Class" mode="M45" priority="1000">
    <svrl:fired-rule context="/setu:Assignment//setu:Rates/setu:Class" id="nl.setu.200801.businessrules.assignment.businessrule.Class.1" />

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
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M45" priority="-1" />
  <xsl:template match="@*|node()" mode="M45" priority="-2">
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.Multiplier.1-->
<xsl:template match="/setu:Assignment//setu:Rates" mode="M46" priority="1000">
    <svrl:fired-rule context="/setu:Assignment//setu:Rates" id="nl.setu.200801.businessrules.assignment.businessrule.Multiplier.1" />

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
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M46" priority="-1" />
  <xsl:template match="@*|node()" mode="M46" priority="-2">
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.RatesId.1-->
<xsl:template match="/setu:Assignment//setu:Rates/setu:RatesId" mode="M47" priority="1000">
    <svrl:fired-rule context="/setu:Assignment//setu:Rates/setu:RatesId" id="nl.setu.200801.businessrules.assignment.businessrule.RatesId.1" />

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
    <xsl:apply-templates mode="M47" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M47" priority="-1" />
  <xsl:template match="@*|node()" mode="M47" priority="-2">
    <xsl:apply-templates mode="M47" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.CustomerRateClassification.1-->
<xsl:template match="/setu:Assignment//setu:Rates/setu:CustomerRateClassification" mode="M48" priority="1000">
    <svrl:fired-rule context="/setu:Assignment//setu:Rates/setu:CustomerRateClassification" id="nl.setu.200801.businessrules.assignment.businessrule.CustomerRateClassification.1" />

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
    <xsl:apply-templates mode="M48" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M48" priority="-1" />
  <xsl:template match="@*|node()" mode="M48" priority="-2">
    <xsl:apply-templates mode="M48" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingShift.1-->
<xsl:template match="/setu:Assignment" mode="M49" priority="1000">
    <svrl:fired-rule context="/setu:Assignment" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingShift.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingShift)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingShift)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element StaffingShift must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M49" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M49" priority="-1" />
  <xsl:template match="@*|node()" mode="M49" priority="-2">
    <xsl:apply-templates mode="M49" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingShift.3-->
<xsl:template match="/setu:Assignment/setu:StaffingShift" mode="M50" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:StaffingShift" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingShift.3" />

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
    <xsl:apply-templates mode="M50" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M50" priority="-1" />
  <xsl:template match="@*|node()" mode="M50" priority="-2">
    <xsl:apply-templates mode="M50" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.StaffingShift.4-->
<xsl:template match="/setu:Assignment/setu:StaffingShift/setu:Id//setu:IdValue" mode="M51" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:StaffingShift/setu:Id//setu:IdValue" id="nl.setu.200801.businessrules.assignment.businessrule.StaffingShift.4" />

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
    <xsl:apply-templates mode="M51" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M51" priority="-1" />
  <xsl:template match="@*|node()" mode="M51" priority="-2">
    <xsl:apply-templates mode="M51" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.UserArea.1-->
<xsl:template match="/setu:Assignment" mode="M52" priority="1000">
    <svrl:fired-rule context="/setu:Assignment" id="nl.setu.200801.businessrules.assignment.businessrule.UserArea.1" />

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
    <xsl:apply-templates mode="M52" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M52" priority="-1" />
  <xsl:template match="@*|node()" mode="M52" priority="-2">
    <xsl:apply-templates mode="M52" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.AssignmentAdditionalNL.1-->
<xsl:template match="/setu:Assignment/setu:UserArea" mode="M53" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:UserArea" id="nl.setu.200801.businessrules.assignment.businessrule.AssignmentAdditionalNL.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(nl:AssignmentAdditionalNL)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(nl:AssignmentAdditionalNL)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element AssignmentAdditionalNL must exist exactly once.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M53" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M53" priority="-1" />
  <xsl:template match="@*|node()" mode="M53" priority="-2">
    <xsl:apply-templates mode="M53" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.SETUVersionId.1-->
<xsl:template match="/setu:Assignment/setu:UserArea/nl:AssignmentAdditionalNL" mode="M54" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:UserArea/nl:AssignmentAdditionalNL" id="nl.setu.200801.businessrules.assignment.businessrule.SETUVersionId.1" />

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
    <xsl:apply-templates mode="M54" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M54" priority="-1" />
  <xsl:template match="@*|node()" mode="M54" priority="-2">
    <xsl:apply-templates mode="M54" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.InclusiveRate.1-->
<xsl:template match="/setu:Assignment" mode="M55" priority="1000">
    <svrl:fired-rule context="/setu:Assignment" id="nl.setu.200801.businessrules.assignment.businessrule.InclusiveRate.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:Rates) = 0) or (count(setu:UserArea/nl:AssignmentAdditionalNL/nl:InclusiveRate) = 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:Rates) = 0) or (count(setu:UserArea/nl:AssignmentAdditionalNL/nl:InclusiveRate) = 1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element InclusiveRate must exist when an element Rates is present.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M55" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M55" priority="-1" />
  <xsl:template match="@*|node()" mode="M55" priority="-2">
    <xsl:apply-templates mode="M55" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.EmployeePhase.1-->
<xsl:template match="/setu:Assignment/setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:EmployeePhase" mode="M56" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:EmployeePhase" id="nl.setu.200801.businessrules.assignment.businessrule.EmployeePhase.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($EmployeePhase, concat(',', ., ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($EmployeePhase, concat(',', ., ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element EmployeePhase must contain one of the following values: <xsl:text />
            <xsl:value-of select="$EmployeePhase" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="current()" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M56" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M56" priority="-1" />
  <xsl:template match="@*|node()" mode="M56" priority="-2">
    <xsl:apply-templates mode="M56" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.RecruitedBy.1-->
<xsl:template match="/setu:Assignment/setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:RecruitedBy" mode="M57" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:RecruitedBy" id="nl.setu.200801.businessrules.assignment.businessrule.RecruitedBy.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(normalize-space(.) = 'StaffingCustomer') or (normalize-space(.) = 'StaffingCompany') " />
      <xsl:otherwise>
        <svrl:failed-assert test="(normalize-space(.) = 'StaffingCustomer') or (normalize-space(.) = 'StaffingCompany')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element Recruitedby should have a valid value, either 'StaffingCustomer' or 'StaffingCompany'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M57" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M57" priority="-1" />
  <xsl:template match="@*|node()" mode="M57" priority="-2">
    <xsl:apply-templates mode="M57" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.202001.businessrules.assignment.businessrule.StaffingShiftAddition.1-->
<xsl:template match="/setu:Assignment/setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:StaffingShiftAddition" mode="M58" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:StaffingShiftAddition" id="nl.setu.202001.businessrules.assignment.businessrule.StaffingShiftAddition.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($StaffingShiftAddition, concat(',', @shiftPeriod, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($StaffingShiftAddition, concat(',', @shiftPeriod, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute shiftPeriod must contain one of the following values: <xsl:text />
            <xsl:value-of select="$StaffingShiftAddition" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@shiftPeriod" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M58" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M58" priority="-1" />
  <xsl:template match="@*|node()" mode="M58" priority="-2">
    <xsl:apply-templates mode="M58" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.202001.businessrules.assignment.businessrule.ContractStaffingShift.1-->
<xsl:template match="/setu:Assignment/setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:ContractStaffingShift" mode="M59" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:ContractStaffingShift" id="nl.setu.202001.businessrules.assignment.businessrule.ContractStaffingShift.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($StaffingShiftAddition, concat(',', @contractShiftPeriod, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($StaffingShiftAddition, concat(',', @contractShiftPeriod, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute contractShiftPeriod must contain one of the following values: <xsl:text />
            <xsl:value-of select="$StaffingShiftAddition" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@contractShiftPeriod" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M59" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M59" priority="-1" />
  <xsl:template match="@*|node()" mode="M59" priority="-2">
    <xsl:apply-templates mode="M59" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.assignment.businessrule.PositionType.1-->
<xsl:template match="/setu:Assignment/setu:UserArea/nl:AssignmentAdditionalNL/nl:PositionType" mode="M60" priority="1000">
    <svrl:fired-rule context="/setu:Assignment/setu:UserArea/nl:AssignmentAdditionalNL/nl:PositionType" id="nl.setu.200801.businessrules.assignment.businessrule.PositionType.1" />

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
    <xsl:apply-templates mode="M60" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M60" priority="-1" />
  <xsl:template match="@*|node()" mode="M60" priority="-2">
    <xsl:apply-templates mode="M60" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.businessrule.279-->
<xsl:template match="//nl:ContractStaffingShift" mode="M61" priority="1000">
    <svrl:fired-rule context="//nl:ContractStaffingShift" id="nl.setu.businessrule.279" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(nl:Hours) > 0) and not(count(nl:MinimumHours) > 0 or count(nl:MaximumHours) > 0))                                      or (not(count(nl:Hours) > 0) and (count(nl:MinimumHours) > 0 or count(nl:MaximumHours) > 0))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(nl:Hours) > 0) and not(count(nl:MinimumHours) > 0 or count(nl:MaximumHours) > 0)) or (not(count(nl:Hours) > 0) and (count(nl:MinimumHours) > 0 or count(nl:MaximumHours) > 0))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                If you specify Hours, do not use MinimumHours and MaximumHours. If you specify MinimumHours and/or MaximumHours, do no use Hours.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M61" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M61" priority="-1" />
  <xsl:template match="@*|node()" mode="M61" priority="-2">
    <xsl:apply-templates mode="M61" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.businessrule.280-->
<xsl:template match="/setu:Assignment[not(setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:ContractStaffingShift)]" mode="M62" priority="1000">
    <svrl:fired-rule context="/setu:Assignment[not(setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:ContractStaffingShift)]" id="nl.setu.businessrule.280" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(setu:StaffingShift/setu:Hours) > 0) and not(count(setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:StaffingShiftAddition) > 0))                                      or (not(count(setu:StaffingShift/setu:Hours) > 0) and (count(setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:StaffingShiftAddition) > 0))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(setu:StaffingShift/setu:Hours) > 0) and not(count(setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:StaffingShiftAddition) > 0)) or (not(count(setu:StaffingShift/setu:Hours) > 0) and (count(setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:StaffingShiftAddition) > 0))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                If you specify Hours, do not use MinimumHours and MaximumHours. If you specify MinimumHours and/or MaximumHours, do no use Hours. This only holds when the container element ContractStaffingShift is not specified.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M62" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M62" priority="-1" />
  <xsl:template match="@*|node()" mode="M62" priority="-2">
    <xsl:apply-templates mode="M62" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.businessrule.281-->
<xsl:template match="/setu:Assignment[not(setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:ContractStaffingShift[@contractShiftPeriod])]" mode="M63" priority="1000">
    <svrl:fired-rule context="/setu:Assignment[not(setu:UserArea/nl:AssignmentAdditionalNL/nl:HumanResourceInformation/nl:ContractStaffingShift[@contractShiftPeriod])]" id="nl.setu.businessrule.281" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:StaffingShift[@shiftPeriod]) > 0)                      or (count(setu:CustomerReportingRequirements/setu:AdditionalRequirement[@requirementTitle = 'shiftPeriodExtension']) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:StaffingShift[@shiftPeriod]) > 0) or (count(setu:CustomerReportingRequirements/setu:AdditionalRequirement[@requirementTitle = 'shiftPeriodExtension']) > 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                If the attribute contractShiftPeriod is not specified, you must specify the shiftPeriod
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M63" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M63" priority="-1" />
  <xsl:template match="@*|node()" mode="M63" priority="-2">
    <xsl:apply-templates mode="M63" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.2022.businessrules.assignment.businessrule.CustomerRateClassification.1-->
<xsl:template match="//setu:Rates/setu:CustomerRateClassification/setu:IdValue" mode="M64" priority="1000">
    <svrl:fired-rule context="//setu:Rates/setu:CustomerRateClassification/setu:IdValue" id="nl.setu.2022.businessrules.assignment.businessrule.CustomerRateClassification.1" />

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
    <xsl:apply-templates mode="M64" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M64" priority="-1" />
  <xsl:template match="@*|node()" mode="M64" priority="-2">
    <xsl:apply-templates mode="M64" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
