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
    <svrl:schematron-output schemaVersion="nl.setu.200801.businessrules.humanresource" title="Business rules voor het controleren van een human resource bericht (SETU Standard for Ordering &amp; Selection versie 1.4).">
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
      <xsl:apply-templates mode="M11" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M12" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M13" select="/" />
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
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Business rules voor het controleren van een human resource bericht (SETU Standard for Ordering &amp; Selection versie 1.4).</svrl:text>
  <xsl:param name="HumanResourceStatus" select="',new,revised,accepted,withdrawn,rejected,x:assigned,'" />
  <xsl:param name="RateType" select="',pay,bill,'" />
  <xsl:param name="Amount" select="',hourly,x:hourlysplit,x:hourlyconsolidated,daily,weekly,x:4weekly,monthly,yearly,flatfee,'" />
  <xsl:param name="Class" select="',TimeInterval,Allowance,Expense,'" />
  <xsl:param name="Degree" select="',1,2,3,4,5,6,'" />
  <xsl:param name="IdOwner" select="',StaffingCustomer,StaffingCompany,KvK,OIN,BTW,Fi,'" />
  <xsl:param name="SETU_CL_HourTypes" select="',Additional wage dispensation,Adoption leave,Child-birth sick time,Internship,Overtime wage dispensation,Pregnancy sick time,Regular wage dispensation,Shift wage dispensation,Transition allowance,Vacation additional,Additionalplus,Regular canceled,Shift canceled,Shiftplus canceled,Additional canceled,Additionalplus canceled,Regular complemented,Additional complemented,Shift complemented,Overtime complemented,Overtime canceled,Overtimeplus canceled,Regular,Overtime,Overtimeplus,Shift,Shiftplus,Attendance,Travel,Additional,Internal,Time for time hour build-up,Time for time overtime hour build-up,Special Leave,Short leave,Holiday,Unpaid leave,Training,Vacation,Reduction of working hours,Sick time,Work underload,Care Leave,WTR (work time reduction),Compensation leave,Funeral,Maternity Leave,Withdrawal time for time hours,Contract hours,Standby,Break,'" />
  <xsl:param name="SETU_CL_ExpenseAllowanceTypes" select="',100,100B,100O,101,101B,101O,102,102B,102O,103,103B,103O,104,104B,104O,105,105B,105O,106,106B,106O,107,107B,107O,201,201B,201O,202,202B,202O,203,203B,203O,300,300B,300O,301,301B,301O,302,302B,302O,303,303B,303O,304,304B,304O,400,400B,400O,501,501B,501O,502,502B,502O,503,503B,503O,600,600B,600O,601,601B,601O,602,602B,602O,603,603B,603O,604,604B,604O,701,701B,701O,702,702B,702O,703,703B,703O,801,801B,801O,802,802B,802O,803,803B,803O,900,900B,900O,901,901B,901O,903,903B,903O,904,904B,904O,905,905B,905O,906,906B,906O,907,907B,907O,908,908B,908O,909,909B,909O,910,910B,910O,911,911B,911O,912,912B,912O,913,913B,913O,914,914B,914O,'" />

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.HumanResourceId.1-->
<xsl:template match="/setu:HumanResource" mode="M11" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource" id="nl.setu.200801.businessrules.humanresource.businessrule.HumanResourceId.1" />

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
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M11" priority="-1" />
  <xsl:template match="@*|node()" mode="M11" priority="-2">
    <xsl:apply-templates mode="M11" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.HumanResourceId.2-->
<xsl:template match="/setu:HumanResource" mode="M12" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource" id="nl.setu.200801.businessrules.humanresource.businessrule.HumanResourceId.2" />

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
    <xsl:apply-templates mode="M12" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.HumanResourceId.3-->
<xsl:template match="/setu:HumanResource//setu:HumanResourceId" mode="M13" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource//setu:HumanResourceId" id="nl.setu.200801.businessrules.humanresource.businessrule.HumanResourceId.3" />

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
    <xsl:apply-templates mode="M13" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.HumanResourceId.4-->
<xsl:template match="/setu:HumanResource//setu:HumanResourceId" mode="M14" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource//setu:HumanResourceId" id="nl.setu.200801.businessrules.humanresource.businessrule.HumanResourceId.4" />

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
    <xsl:apply-templates mode="M14" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.HumanResourceStatus.1-->
<xsl:template match="/setu:HumanResource/setu:HumanResourceStatus" mode="M15" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:HumanResourceStatus" id="nl.setu.200801.businessrules.humanresource.businessrule.HumanResourceStatus.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains($HumanResourceStatus, concat(',', @status, ','))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains($HumanResourceStatus, concat(',', @status, ','))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute status of the element HumanResourceStatus must contain one of the following values: <xsl:text />
            <xsl:value-of select="$HumanResourceStatus" />
            <xsl:text />
                Currently '<xsl:text />
            <xsl:value-of select="@status" />
            <xsl:text />' is used.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M15" priority="-1" />
  <xsl:template match="@*|node()" mode="M15" priority="-2">
    <xsl:apply-templates mode="M15" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.ReferenceInformation.1-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation" mode="M16" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation" id="nl.setu.200801.businessrules.humanresource.businessrule.ReferenceInformation.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IntermediaryId)=0) and (count(setu:BillToEntityId)=0) and (count(setu:PositionId)=0) and (count(setu:AssignmentId)=0) and (count(setu:TimeCardId)=0) and (count(setu:InvoiceId)=0) and (count(setu:StaffingOrganizationId)=0) and (count(setu:UserArea)=0) and (count(setu:MasterOrderId)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IntermediaryId)=0) and (count(setu:BillToEntityId)=0) and (count(setu:PositionId)=0) and (count(setu:AssignmentId)=0) and (count(setu:TimeCardId)=0) and (count(setu:InvoiceId)=0) and (count(setu:StaffingOrganizationId)=0) and (count(setu:UserArea)=0) and (count(setu:MasterOrderId)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element ReferenceInformation contains (a) subelement(s) that is/are not allowed.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M16" priority="-1" />
  <xsl:template match="@*|node()" mode="M16" priority="-2">
    <xsl:apply-templates mode="M16" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierId.1-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation" mode="M17" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierId.1" />

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
    <xsl:apply-templates mode="M17" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M17" priority="-1" />
  <xsl:template match="@*|node()" mode="M17" priority="-2">
    <xsl:apply-templates mode="M17" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierId.2-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation" mode="M18" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StaffingSupplierId) >=1 " />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StaffingSupplierId) >=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element StaffingSupplierId must exist at least once. 
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierId.3-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingSupplierId" mode="M19" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingSupplierId" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierId.3" />

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
    <xsl:apply-templates mode="M19" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M19" priority="-1" />
  <xsl:template match="@*|node()" mode="M19" priority="-2">
    <xsl:apply-templates mode="M19" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierId.4-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingSupplierId" mode="M20" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingSupplierId" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierId.4" />

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
    <xsl:apply-templates mode="M20" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M20" priority="-1" />
  <xsl:template match="@*|node()" mode="M20" priority="-2">
    <xsl:apply-templates mode="M20" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerId.1-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation" mode="M21" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerId.1" />

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
    <xsl:apply-templates mode="M21" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M21" priority="-1" />
  <xsl:template match="@*|node()" mode="M21" priority="-2">
    <xsl:apply-templates mode="M21" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerId.2-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation" mode="M22" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerId.2" />

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
    <xsl:apply-templates mode="M22" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M22" priority="-1" />
  <xsl:template match="@*|node()" mode="M22" priority="-2">
    <xsl:apply-templates mode="M22" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerId.3-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingCustomerId" mode="M23" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingCustomerId" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerId.3" />

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
    <xsl:apply-templates mode="M23" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M23" priority="-1" />
  <xsl:template match="@*|node()" mode="M23" priority="-2">
    <xsl:apply-templates mode="M23" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerId.4-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingCustomerId" mode="M24" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingCustomerId" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerId.4" />

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
    <xsl:apply-templates mode="M24" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M24" priority="-1" />
  <xsl:template match="@*|node()" mode="M24" priority="-2">
    <xsl:apply-templates mode="M24" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.OrderId.1-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation" mode="M25" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation" id="nl.setu.200801.businessrules.humanresource.businessrule.OrderId.1" />

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
    <xsl:apply-templates mode="M25" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M25" priority="-1" />
  <xsl:template match="@*|node()" mode="M25" priority="-2">
    <xsl:apply-templates mode="M25" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.OrderId.2-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation/setu:OrderId" mode="M26" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation/setu:OrderId" id="nl.setu.200801.businessrules.humanresource.businessrule.OrderId.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@idOwner)=1) and ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@idOwner)=1) and ((normalize-space(@idOwner) = 'StaffingCustomer') or (normalize-space(@idOwner) = 'StaffingCompany'))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute idOwner of the element OrderId must exist exactly once and should have a valid value, either 'StaffingCustomer' or 'StaffingCompany'. 
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.OrderId.3-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation/setu:OrderId" mode="M27" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation/setu:OrderId" id="nl.setu.200801.businessrules.humanresource.businessrule.OrderId.3" />

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
    <xsl:apply-templates mode="M27" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M27" priority="-1" />
  <xsl:template match="@*|node()" mode="M27" priority="-2">
    <xsl:apply-templates mode="M27" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierOrgUnitId.1-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation" mode="M28" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierOrgUnitId.1" />

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
    <xsl:apply-templates mode="M28" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M28" priority="-1" />
  <xsl:template match="@*|node()" mode="M28" priority="-2">
    <xsl:apply-templates mode="M28" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierOrgUnitId.3-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" mode="M29" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierOrgUnitId.3" />

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
    <xsl:apply-templates mode="M29" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M29" priority="-1" />
  <xsl:template match="@*|node()" mode="M29" priority="-2">
    <xsl:apply-templates mode="M29" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierOrgUnitId.4-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" mode="M30" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingSupplierOrgUnitId" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingSupplierOrgUnitId.4" />

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
    <xsl:apply-templates mode="M30" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M30" priority="-1" />
  <xsl:template match="@*|node()" mode="M30" priority="-2">
    <xsl:apply-templates mode="M30" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerOrgUnitId.1-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation" mode="M31" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerOrgUnitId.1" />

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
    <xsl:apply-templates mode="M31" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M31" priority="-1" />
  <xsl:template match="@*|node()" mode="M31" priority="-2">
    <xsl:apply-templates mode="M31" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerOrgUnitId.3-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" mode="M32" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerOrgUnitId.3" />

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
    <xsl:apply-templates mode="M32" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M32" priority="-1" />
  <xsl:template match="@*|node()" mode="M32" priority="-2">
    <xsl:apply-templates mode="M32" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerOrgUnitId.4-->
<xsl:template match="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" mode="M33" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ReferenceInformation//setu:StaffingCustomerOrgUnitId" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingCustomerOrgUnitId.4" />

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
    <xsl:apply-templates mode="M33" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M33" priority="-1" />
  <xsl:template match="@*|node()" mode="M33" priority="-2">
    <xsl:apply-templates mode="M33" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.PersonName.1-->
<xsl:template match="/setu:HumanResource/setu:ResourceInformation/setu:PersonName" mode="M34" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ResourceInformation/setu:PersonName" id="nl.setu.200801.businessrules.humanresource.businessrule.PersonName.1" />

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
    <xsl:apply-templates mode="M34" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M34" priority="-1" />
  <xsl:template match="@*|node()" mode="M34" priority="-2">
    <xsl:apply-templates mode="M34" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.PersonName.2-->
<xsl:template match="//setu:PersonName" mode="M35" priority="1000">
    <svrl:fired-rule context="//setu:PersonName" id="nl.setu.200801.businessrules.humanresource.businessrule.PersonName.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:FormattedName) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:FormattedName) = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element FormattedName is a mandatory subelement of PersonName.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.FamilyName.1-->
<xsl:template match="/setu:HumanResource/setu:ResourceInformation/setu:PersonName//setu:FamilyName" mode="M36" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ResourceInformation/setu:PersonName//setu:FamilyName" id="nl.setu.200801.businessrules.humanresource.businessrule.FamilyName.1" />

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
    <xsl:apply-templates mode="M36" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M36" priority="-1" />
  <xsl:template match="@*|node()" mode="M36" priority="-2">
    <xsl:apply-templates mode="M36" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.ContactMethod.1-->
<xsl:template match="/setu:HumanResource/setu:ResourceInformation/setu:EntityContactInfo" mode="M37" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:ResourceInformation/setu:EntityContactInfo" id="nl.setu.200801.businessrules.humanresource.businessrule.ContactMethod.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:ContactMethod)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:ContactMethod)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element ContactMethod of the element EntityContactInfo must exist exactly once.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.RateType.1-->
<xsl:template match="/setu:HumanResource//setu:Rates" mode="M38" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource//setu:Rates" id="nl.setu.200801.businessrules.humanresource.businessrule.RateType.1" />

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
    <xsl:apply-templates mode="M38" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M38" priority="-1" />
  <xsl:template match="@*|node()" mode="M38" priority="-2">
    <xsl:apply-templates mode="M38" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.RateStatus.1-->
<xsl:template match="/setu:HumanResource//setu:Rates" mode="M39" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource//setu:Rates" id="nl.setu.200801.businessrules.humanresource.businessrule.RateStatus.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(normalize-space(@rateStatus) = 'proposed') or (normalize-space(@rateStatus) = 'agreed') " />
      <xsl:otherwise>
        <svrl:failed-assert test="(normalize-space(@rateStatus) = 'proposed') or (normalize-space(@rateStatus) = 'agreed')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute rateStatus of Rates should have a valid value: 'proposed'.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.ExternalRateSetId.1-->
<xsl:template match="/setu:HumanResource//setu:Rates/setu:ExternalRateSetId" mode="M40" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource//setu:Rates/setu:ExternalRateSetId" id="nl.setu.200801.businessrules.humanresource.businessrule.ExternalRateSetId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element ExternalRateSetId must exist exactly once.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.Amount.1-->
<xsl:template match="/setu:HumanResource//setu:Rates/setu:Amount" mode="M41" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource//setu:Rates/setu:Amount" id="nl.setu.200801.businessrules.humanresource.businessrule.Amount.1" />

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
    <xsl:apply-templates mode="M41" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M41" priority="-1" />
  <xsl:template match="@*|node()" mode="M41" priority="-2">
    <xsl:apply-templates mode="M41" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.Class.1-->
<xsl:template match="/setu:HumanResource//setu:Rates/setu:Class" mode="M42" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource//setu:Rates/setu:Class" id="nl.setu.200801.businessrules.humanresource.businessrule.Class.1" />

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
    <xsl:apply-templates mode="M42" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M42" priority="-1" />
  <xsl:template match="@*|node()" mode="M42" priority="-2">
    <xsl:apply-templates mode="M42" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.Multiplier.1-->
<xsl:template match="/setu:HumanResource//setu:Rates" mode="M43" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource//setu:Rates" id="nl.setu.200801.businessrules.humanresource.businessrule.Multiplier.1" />

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
    <xsl:apply-templates mode="M43" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M43" priority="-1" />
  <xsl:template match="@*|node()" mode="M43" priority="-2">
    <xsl:apply-templates mode="M43" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.RatesId.1-->
<xsl:template match="/setu:HumanResource//setu:Rates/setu:RatesId" mode="M44" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource//setu:Rates/setu:RatesId" id="nl.setu.200801.businessrules.humanresource.businessrule.RatesId.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element RatesId must exist exactly once.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.CustomerRateClassification.1-->
<xsl:template match="/setu:HumanResource//setu:Rates/setu:CustomerRateClassification" mode="M45" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource//setu:Rates/setu:CustomerRateClassification" id="nl.setu.200801.businessrules.humanresource.businessrule.CustomerRateClassification.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:IdValue)=1) and (normalize-space(setu:IdValue)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement IdValue of the element CustomerRateClassification must exist exactly once.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.Profile.1-->
<xsl:template match="//setu:HumanResource" mode="M46" priority="1000">
    <svrl:fired-rule context="//setu:HumanResource" id="nl.setu.200801.businessrules.humanresource.businessrule.Profile.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:Profile)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:Profile)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element Profile must exist exactly once.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.Resume.1-->
<xsl:template match="/setu:HumanResource//setu:Profile" mode="M47" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource//setu:Profile" id="nl.setu.200801.businessrules.humanresource.businessrule.Resume.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:Resume)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:Resume)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element Resume must exist exactly once.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StructuredXMLResume.1-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume" mode="M48" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume" id="nl.setu.200801.businessrules.humanresource.businessrule.StructuredXMLResume.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:StructuredXMLResume)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:StructuredXMLResume)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element StructuredXMLResume must exist exactly once.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.ContactMethod.2-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EmploymentHistory//setu:EmployerOrg/setu:EmployerContactInfo" mode="M49" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EmploymentHistory//setu:EmployerOrg/setu:EmployerContactInfo" id="nl.setu.200801.businessrules.humanresource.businessrule.ContactMethod.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:ContactMethod) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:ContactMethod) &lt;= 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element ContactMethod of the element EmployerContactInfo may exist at most once.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.PositionHistory.1-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EmploymentHistory//setu:EmployerOrg//setu:PositionHistory" mode="M50" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EmploymentHistory//setu:EmployerOrg//setu:PositionHistory" id="nl.setu.200801.businessrules.humanresource.businessrule.PositionHistory.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:EndDate/setu:AnyDate)=1) and (count(setu:StartDate/setu:AnyDate)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:EndDate/setu:AnyDate)=1) and (count(setu:StartDate/setu:AnyDate)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element AnyDate is a mandatory subelement of the StartDate and EndDate elements.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.Degree.1-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution" mode="M51" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution" id="nl.setu.200801.businessrules.humanresource.businessrule.Degree.1" />

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
    <xsl:apply-templates mode="M51" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M51" priority="-1" />
  <xsl:template match="@*|node()" mode="M51" priority="-2">
    <xsl:apply-templates mode="M51" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.DatesOfAttendance.1-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EducationHistoryHistory//setu:SchoolOrInstitution/setu:DatesOfAttendance" mode="M52" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EducationHistoryHistory//setu:SchoolOrInstitution/setu:DatesOfAttendance" id="nl.setu.200801.businessrules.humanresource.businessrule.DatesOfAttendance.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:EndDate/setu:AnyDate)=1) and (count(setu:StartDate/setu:AnyDate)=1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:EndDate/setu:AnyDate)=1) and (count(setu:StartDate/setu:AnyDate)=1)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element AnyDate is a mandatory subelement of the StartDate and EndDate elements.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.LocalInstitutionClassification.1-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution" mode="M53" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution" id="nl.setu.200801.businessrules.humanresource.businessrule.LocalInstitutionClassification.1" />

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
    <xsl:apply-templates mode="M53" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M53" priority="-1" />
  <xsl:template match="@*|node()" mode="M53" priority="-2">
    <xsl:apply-templates mode="M53" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.LocalInstitutionClassification.2-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution/setu:LocalInstitutionClassification/setu:Id" mode="M54" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution/setu:LocalInstitutionClassification/setu:Id" id="nl.setu.200801.businessrules.humanresource.businessrule.LocalInstitutionClassification.2" />

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
    <xsl:apply-templates mode="M54" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M54" priority="-1" />
  <xsl:template match="@*|node()" mode="M54" priority="-2">
    <xsl:apply-templates mode="M54" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.LocalInstitutionClassification.3-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution/setu:LocalInstitutionClassification/setu:Id" mode="M55" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:EducationHistory/setu:SchoolOrInstitution/setu:LocalInstitutionClassification/setu:Id" id="nl.setu.200801.businessrules.humanresource.businessrule.LocalInstitutionClassification.3" />

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
    <xsl:apply-templates mode="M55" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M55" priority="-1" />
  <xsl:template match="@*|node()" mode="M55" priority="-2">
    <xsl:apply-templates mode="M55" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.EffectiveDate.1-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:LicensesAndCertifications//setu:LicenseOrCertification/setu:EffectiveDate/*" mode="M56" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:LicensesAndCertifications//setu:LicenseOrCertification/setu:EffectiveDate/*" id="nl.setu.200801.businessrules.humanresource.businessrule.EffectiveDate.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:AnyDate)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:AnyDate)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element AnyDate is a mandatory subelement of the ValidFrom, ValidTo and FirstIssueDate elements.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.WorkingAndThinkingLevel.1-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:Qualitifications//setu:Competency" mode="M57" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:Qualitifications//setu:Competency" id="nl.setu.200801.businessrules.humanresource.businessrule.WorkingAndThinkingLevel.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((normalize-space(@name)='WorkingAndThinkingLevel') and contains($Degree, concat(',', @description, ','))) or not(normalize-space(@name)='WorkingAndThinkingLevel')" />
      <xsl:otherwise>
        <svrl:failed-assert test="((normalize-space(@name)='WorkingAndThinkingLevel') and contains($Degree, concat(',', @description, ','))) or not(normalize-space(@name)='WorkingAndThinkingLevel')">
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
    <xsl:apply-templates mode="M57" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M57" priority="-1" />
  <xsl:template match="@*|node()" mode="M57" priority="-2">
    <xsl:apply-templates mode="M57" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.Competency.1-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:Qualitifications//setu:Competency" mode="M58" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:Qualitifications//setu:Competency" id="nl.setu.200801.businessrules.humanresource.businessrule.Competency.1" />

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
    <xsl:apply-templates mode="M58" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M58" priority="-1" />
  <xsl:template match="@*|node()" mode="M58" priority="-2">
    <xsl:apply-templates mode="M58" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.Competency.2-->
<xsl:template match="//setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:Qualitifications//setu:Competency" mode="M59" priority="1000">
    <svrl:fired-rule context="//setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:Qualitifications//setu:Competency" id="nl.setu.200801.businessrules.humanresource.businessrule.Competency.2" />

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
    <xsl:apply-templates mode="M59" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M59" priority="-1" />
  <xsl:template match="@*|node()" mode="M59" priority="-2">
    <xsl:apply-templates mode="M59" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.AttachmentReference.1-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:SupportingMaterials" mode="M60" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:SupportingMaterials" id="nl.setu.200801.businessrules.humanresource.businessrule.AttachmentReference.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:AttachmentReference) = 1) and (normalize-space(setu:AttachmentReference)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:AttachmentReference) = 1) and (normalize-space(setu:AttachmentReference)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element AttachmentReference of the lement SupportingMaterials must exist exactly once and may not be empty.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.AttachmentReference.2-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:SupportingMaterials/setu:AttachmentReference" mode="M61" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:SupportingMaterials/setu:AttachmentReference" id="nl.setu.200801.businessrules.humanresource.businessrule.AttachmentReference.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@mimeType) = 1) and (normalize-space(@mimeType)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@mimeType) = 1) and (normalize-space(@mimeType)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute mimeType of the element AttachmentReference must exist exactly once and may not be empty.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.Description.1-->
<xsl:template match="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:SupportingMaterials" mode="M62" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Profile/setu:Resume/setu:StructuredXMLResume/setu:SupportingMaterials" id="nl.setu.200801.businessrules.humanresource.businessrule.Description.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:Description) = 1) and (normalize-space(setu:Description)!='')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:Description) = 1) and (normalize-space(setu:Description)!='')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element Description of the element SupportingMaterials must exist exactly once and may not be empty.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.Preferences.1-->
<xsl:template match="/setu:HumanResource/setu:Preferences" mode="M63" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:Preferences" id="nl.setu.200801.businessrules.humanresource.businessrule.Preferences.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(*)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(*)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element Preferences of the element HumanResource may not contain any subelements.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.UserArea.1-->
<xsl:template match="/setu:HumanResource" mode="M64" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource" id="nl.setu.200801.businessrules.humanresource.businessrule.UserArea.1" />

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
    <xsl:apply-templates mode="M64" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M64" priority="-1" />
  <xsl:template match="@*|node()" mode="M64" priority="-2">
    <xsl:apply-templates mode="M64" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.HumanResourceAdditionalNL.1-->
<xsl:template match="/setu:HumanResource/setu:UserArea" mode="M65" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:UserArea" id="nl.setu.200801.businessrules.humanresource.businessrule.HumanResourceAdditionalNL.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(nl:HumanResourceAdditionalNL)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(nl:HumanResourceAdditionalNL)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element HumanResourceAdditionalNL must exist exactly once.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.SETUVersionId.1-->
<xsl:template match="/setu:HumanResource/setu:UserArea/nl:HumanResourceAdditionalNL" mode="M66" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:UserArea/nl:HumanResourceAdditionalNL" id="nl.setu.200801.businessrules.humanresource.businessrule.SETUVersionId.1" />

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
    <xsl:apply-templates mode="M66" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M66" priority="-1" />
  <xsl:template match="@*|node()" mode="M66" priority="-2">
    <xsl:apply-templates mode="M66" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingShift.1-->
<xsl:template match="/setu:HumanResource/setu:UserArea/nl:HumanResourceAdditionalNL/nl:StaffingShift" mode="M67" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:UserArea/nl:HumanResourceAdditionalNL/nl:StaffingShift" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingShift.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(@shiftPeriod)=1) and (normalize-space(@shiftPeriod)='weekly')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(@shiftPeriod)=1) and (normalize-space(@shiftPeriod)='weekly')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The attribute shiftPeriod of the element StaffingShift must exist exactly once and contain the following value: 'weekly'.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.StaffingShift.2-->
<xsl:template match="/setu:HumanResource/setu:UserArea/nl:HumanResourceAdditionalNL/nl:StaffingShift" mode="M68" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:UserArea/nl:HumanResourceAdditionalNL/nl:StaffingShift" id="nl.setu.200801.businessrules.humanresource.businessrule.StaffingShift.2" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(setu:Id)=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(setu:Id)=''">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The subelement Id of the element StaffingShift must be empty.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.CustomerReportingRequirements.1-->
<xsl:template match="/setu:HumanResource/setu:UserArea/nl:HumanResourceAdditionalNL/nl:CustomerReportingRequirements" mode="M69" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:UserArea/nl:HumanResourceAdditionalNL/nl:CustomerReportingRequirements" id="nl.setu.200801.businessrules.humanresource.businessrule.CustomerReportingRequirements.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(setu:SupervisorName)=0) and (count(setu:LocationCode)=0) and (count(setu:PurchaseOrderLineItem)=0) and (count(setu:LocationName)=0) and (count(setu:CustomerJobCode)=0) and (count(setu:CustomerJobDescription)=0) and (count(setu:AccountCode)=0) and (count(setu:ExternalOrderNumber)=0) and (count(setu:ExternalReqNumber)=0) and (count(setu:Entity)=0) and (count(setu:SubEntity)=0) and (count(setu:Shift)=0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(setu:SupervisorName)=0) and (count(setu:LocationCode)=0) and (count(setu:PurchaseOrderLineItem)=0) and (count(setu:LocationName)=0) and (count(setu:CustomerJobCode)=0) and (count(setu:CustomerJobDescription)=0) and (count(setu:AccountCode)=0) and (count(setu:ExternalOrderNumber)=0) and (count(setu:ExternalReqNumber)=0) and (count(setu:Entity)=0) and (count(setu:SubEntity)=0) and (count(setu:Shift)=0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element CustomerReportingRequirements contains (a) subelement(s) that is/are not allowed.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.AdditionalRequirement.1-->
<xsl:template match="/setu:HumanResource/setu:UserArea/nl:HumanResourceAdditionalNL/nl:CustomerReportingRequirements//setu:AdditionalRequirement" mode="M70" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:UserArea/nl:HumanResourceAdditionalNL/nl:CustomerReportingRequirements//setu:AdditionalRequirement" id="nl.setu.200801.businessrules.humanresource.businessrule.AdditionalRequirement.1" />

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
    <xsl:apply-templates mode="M70" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M70" priority="-1" />
  <xsl:template match="@*|node()" mode="M70" priority="-2">
    <xsl:apply-templates mode="M70" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.ContactMethod.3-->
<xsl:template match="/setu:HumanResource/setu:UserArea/nl:HumanResourceAdditionalNL/nl:SupplierContactInfo" mode="M71" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource/setu:UserArea/nl:HumanResourceAdditionalNL/nl:SupplierContactInfo" id="nl.setu.200801.businessrules.humanresource.businessrule.ContactMethod.3" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(setu:ContactMethod)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(setu:ContactMethod)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element ContactMethod of the element SupplierContactInfo must exist exactly once.
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


	<!--RULE nl.setu.200801.businessrules.humanresource.businessrule.InclusiveRate.1-->
<xsl:template match="/setu:HumanResource" mode="M72" priority="1000">
    <svrl:fired-rule context="/setu:HumanResource" id="nl.setu.200801.businessrules.humanresource.businessrule.InclusiveRate.1" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(setu:Rates) > 0) and (count(setu:UserArea/nl:HumanResourceAdditionalNL/nl:InclusiveRate) = 1)) or not(count(setu:Rates) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(setu:Rates) > 0) and (count(setu:UserArea/nl:HumanResourceAdditionalNL/nl:InclusiveRate) = 1)) or not(count(setu:Rates) > 0)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The element InclusiveRate must exist when an element Rates is present.
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


	<!--RULE nl.setu.2022.businessrules.humanresource.businessrule.CustomerRateClassification.1-->
<xsl:template match="//setu:Rates/setu:CustomerRateClassification/setu:IdValue" mode="M73" priority="1000">
    <svrl:fired-rule context="//setu:Rates/setu:CustomerRateClassification/setu:IdValue" id="nl.setu.2022.businessrules.humanresource.businessrule.CustomerRateClassification.1" />

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
    <xsl:apply-templates mode="M73" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M73" priority="-1" />
  <xsl:template match="@*|node()" mode="M73" priority="-2">
    <xsl:apply-templates mode="M73" select="*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
