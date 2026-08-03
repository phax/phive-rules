<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
    <svrl:schematron-output schemaVersion="ISO19757-3" title="PPF — Flux 1 CII e-invoicing &amp; e-reporting — Profil de Base (Trajectoire DÉMARRAGE) - Extension FULL/CIBLE">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="rsm" uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" />
      <svrl:ns-prefix-in-attribute-values prefix="ram" uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" />
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:ns-prefix-in-attribute-values prefix="udt" uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" />
      <svrl:ns-prefix-in-attribute-values prefix="qdt" uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-FACTURE-ID-G1.05</xsl:attribute>
        <xsl:attribute name="name">F1-START-FACTURE-ID-G1.05</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M6" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-FACTURE-TYPE-G1.01</xsl:attribute>
        <xsl:attribute name="name">F1-START-FACTURE-TYPE-G1.01</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M7" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-FACTURE-DATE-G1.09</xsl:attribute>
        <xsl:attribute name="name">F1-START-FACTURE-DATE-G1.09</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M8" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-VENDEUR-ID-G2.19</xsl:attribute>
        <xsl:attribute name="name">F1-START-VENDEUR-ID-G2.19</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M9" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-VENDEUR-TVA-G2.33</xsl:attribute>
        <xsl:attribute name="name">F1-START-VENDEUR-TVA-G2.33</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M10" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-VENDEUR-PAYS-G2.01</xsl:attribute>
        <xsl:attribute name="name">F1-START-VENDEUR-PAYS-G2.01</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M11" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-ACHETEUR-ID-G2.19</xsl:attribute>
        <xsl:attribute name="name">F1-START-ACHETEUR-ID-G2.19</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M12" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-ACHETEUR-TVA-G2.33</xsl:attribute>
        <xsl:attribute name="name">F1-START-ACHETEUR-TVA-G2.33</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M13" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-ACHETEUR-PAYS-G2.01</xsl:attribute>
        <xsl:attribute name="name">F1-START-ACHETEUR-PAYS-G2.01</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M14" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-TAXE-TYPE-G1.103</xsl:attribute>
        <xsl:attribute name="name">F1-START-TAXE-TYPE-G1.103</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M15" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-PAIEMENT-CONDITIONS-P1.11</xsl:attribute>
        <xsl:attribute name="name">F1-START-PAIEMENT-CONDITIONS-P1.11</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M16" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-PAIEMENT-MOYEN-BT81</xsl:attribute>
        <xsl:attribute name="name">F1-START-PAIEMENT-MOYEN-BT81</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M17" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-LOGISTIQUE-TRANSPORT-BT80</xsl:attribute>
        <xsl:attribute name="name">F1-START-LOGISTIQUE-TRANSPORT-BT80</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M18" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-TVA-CATEGORIE-G2.31</xsl:attribute>
        <xsl:attribute name="name">F1-START-TVA-CATEGORIE-G2.31</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M19" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-TVA-TAUX-G1.24</xsl:attribute>
        <xsl:attribute name="name">F1-START-TVA-TAUX-G1.24</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M20" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-TOTAL-FORMATS-G1.14</xsl:attribute>
        <xsl:attribute name="name">F1-START-TOTAL-FORMATS-G1.14</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M21" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-TOTAL-COHERENCE-G1.53</xsl:attribute>
        <xsl:attribute name="name">F1-START-TOTAL-COHERENCE-G1.53</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M22" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-LIGNE-PRIX-G1.55</xsl:attribute>
        <xsl:attribute name="name">F1-START-LIGNE-PRIX-G1.55</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M23" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-START-LIGNE-QUANTITE-G1.15</xsl:attribute>
        <xsl:attribute name="name">F1-START-LIGNE-QUANTITE-G1.15</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M24" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G6.08-OBLIGATOIRES</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G6.08-OBLIGATOIRES</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M25" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-BG23-G6.08</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-BG23-G6.08</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M26" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G1.02-G1.60</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G1.02-G1.60</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M27" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G1.10-G1.12-DEVISES</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G1.10-G1.12-DEVISES</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M28" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G1.09-DATES</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G1.09-DATES</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M29" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G6.25-PERIODES</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G6.25-PERIODES</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M30" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G1.31-REFERENCES</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G1.31-REFERENCES</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M31" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G1.05-REF-ID</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G1.05-REF-ID</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M32" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G1.14-MONTANTS</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G1.14-MONTANTS</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M33" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G1.16-PRIX</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G1.16-PRIX</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M34" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G1.63-SIREN</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G1.63-SIREN</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M35" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-S1.14-ASSUJETTI-UNIQUE</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-S1.14-ASSUJETTI-UNIQUE</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M36" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-S1.17-QUALIFIANTS-TVA</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-S1.17-QUALIFIANTS-TVA</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M37" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-S1.13-DUE-DATE-TYPE</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-S1.13-DUE-DATE-TYPE</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M38" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G1.41-G1.47-G2.32-G6.21</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G1.41-G1.47-G2.32-G6.21</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M39" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G1.24-G2.31</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G1.24-G2.31</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M40" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-COMPLETE-CII-G1.53-COHERENCE</xsl:attribute>
        <xsl:attribute name="name">F1-COMPLETE-CII-G1.53-COHERENCE</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M41" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-FULL-CII-G6.09-LIGNES-OBLIGATOIRES</xsl:attribute>
        <xsl:attribute name="name">F1-FULL-CII-G6.09-LIGNES-OBLIGATOIRES</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M42" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-FULL-CII-G6.09-CONTENU-LIGNE</xsl:attribute>
        <xsl:attribute name="name">F1-FULL-CII-G6.09-CONTENU-LIGNE</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M43" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-CIBLE-CII-G1.31-REFERENCES-ANTERIEURES</xsl:attribute>
        <xsl:attribute name="name">F1-CIBLE-CII-G1.31-REFERENCES-ANTERIEURES</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M44" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-CIBLE-CII-BT26-DATE-FACTURE-ANTERIEURE</xsl:attribute>
        <xsl:attribute name="name">F1-CIBLE-CII-BT26-DATE-FACTURE-ANTERIEURE</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M45" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-CIBLE-CII-G6.16-ADRESSE-LIVRAISON</xsl:attribute>
        <xsl:attribute name="name">F1-CIBLE-CII-G6.16-ADRESSE-LIVRAISON</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M46" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-CIBLE-CII-DATES-LIGNE</xsl:attribute>
        <xsl:attribute name="name">F1-CIBLE-CII-DATES-LIGNE</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M47" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-CIBLE-CII-G6.25-PERIODES-LIGNE</xsl:attribute>
        <xsl:attribute name="name">F1-CIBLE-CII-G6.25-PERIODES-LIGNE</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M48" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-FULL-CII-ALLOWANCE-CHARGE-DOCUMENT</xsl:attribute>
        <xsl:attribute name="name">F1-FULL-CII-ALLOWANCE-CHARGE-DOCUMENT</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M49" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-FULL-CII-ALLOWANCE-CHARGE-LIGNE</xsl:attribute>
        <xsl:attribute name="name">F1-FULL-CII-ALLOWANCE-CHARGE-LIGNE</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M50" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">F1-FULL-CII-G1.16-PRIX-LIGNE</xsl:attribute>
        <xsl:attribute name="name">F1-FULL-CII-G1.16-PRIX-LIGNE</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M51" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>PPF — Flux 1 CII e-invoicing &amp; e-reporting — Profil de Base (Trajectoire DÉMARRAGE) - Extension FULL/CIBLE</svrl:text>

<!--PATTERN F1-START-FACTURE-ID-G1.05-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID" mode="M6" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID" />
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
    <xsl:apply-templates mode="M6" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M6" priority="-1" />
  <xsl:template match="@*|node()" mode="M6" priority="-2">
    <xsl:apply-templates mode="M6" select="*" />
  </xsl:template>

<!--PATTERN F1-START-FACTURE-TYPE-G1.01-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode" mode="M7" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('261','380','381','384','386','389','393','396','471','472','473','500','501','502','503')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('261','380','381','384','386','389','393','396','471','472','473','500','501','502','503')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.01] Le type de document / facture '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' n'est pas autorisé au démarrage de la réforme. | Source : Annexe 7 v1.8 G1.01</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M7" priority="-1" />
  <xsl:template match="@*|node()" mode="M7" priority="-2">
    <xsl:apply-templates mode="M7" select="*" />
  </xsl:template>

<!--PATTERN F1-START-FACTURE-DATE-G1.09-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString" mode="M8" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString" />
    <xsl:variable name="annee" select="number(substring(., 1, 4))" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date d'émission de la facture (<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />) doit respecter le format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or ($annee >= 2000 and $annee &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or ($annee >= 2000 and $annee &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'année de facturation (<xsl:text />
            <xsl:value-of select="xs:string($annee)" />
            <xsl:text />) doit être comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M8" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M8" priority="-1" />
  <xsl:template match="@*|node()" mode="M8" priority="-2">
    <xsl:apply-templates mode="M8" select="*" />
  </xsl:template>

<!--PATTERN F1-START-VENDEUR-ID-G2.19-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID" mode="M9" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID" />
    <xsl:variable name="scheme" select="string(@schemeID)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$scheme = ('0002','0223','0227','0228','0229')" />
      <xsl:otherwise>
        <svrl:failed-assert test="$scheme = ('0002','0223','0227','0228','0229')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] Le type d'identifiant (schemeID='<xsl:text />
            <xsl:value-of select="$scheme" />
            <xsl:text />') du vendeur n'est pas valide. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($scheme = '0002') or matches(., '^\d{9}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($scheme = '0002') or matches(., '^\d{9}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant de type 0002 (SIREN) du vendeur doit comporter exactement 9 chiffres numériques. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($scheme = '0223') or string-length(.) &lt;= 18" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($scheme = '0223') or string-length(.) &lt;= 18">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant de type 0223 du vendeur ne peut pas dépasser 18 caractères. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M9" priority="-1" />
  <xsl:template match="@*|node()" mode="M9" priority="-2">
    <xsl:apply-templates mode="M9" select="*" />
  </xsl:template>

<!--PATTERN F1-START-VENDEUR-TVA-G2.33-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty" mode="M10" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:SpecifiedLegalOrganization/ram:ID/@schemeID = ('0002','0223')) or string(ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:SpecifiedLegalOrganization/ram:ID/@schemeID = ('0002','0223')) or string(ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA'])">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.33] L'identifiant TVA du vendeur est obligatoire au démarrage si l'identifiant légal est un SIREN ou UE_HORS_FRANCE. | Source : Annexe 7 v1.8 G2.33</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

<!--PATTERN F1-START-VENDEUR-PAYS-G2.01-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID" mode="M11" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^[A-Z]{2}$') and not(. = 'EL')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^[A-Z]{2}$') and not(. = 'EL')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.01] Le code pays du vendeur (<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />) doit comporter 2 lettres majuscules ISO 3166-1 alpha-2 ('GR' requis pour la Grèce). | Source : Annexe 7 v1.8 G2.01</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M11" priority="-1" />
  <xsl:template match="@*|node()" mode="M11" priority="-2">
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

<!--PATTERN F1-START-ACHETEUR-ID-G2.19-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID" mode="M12" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID" />
    <xsl:variable name="scheme" select="string(@schemeID)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$scheme = ('0002','0223','0227','0228','0229')" />
      <xsl:otherwise>
        <svrl:failed-assert test="$scheme = ('0002','0223','0227','0228','0229')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] Le type d'identifiant (schemeID='<xsl:text />
            <xsl:value-of select="$scheme" />
            <xsl:text />') de l'acheteur n'est pas autorisé. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($scheme = '0002') or matches(., '^\d{9}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($scheme = '0002') or matches(., '^\d{9}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.19] L'identifiant de type 0002 (SIREN) de l'acheteur doit comporter exactement 9 chiffres numériques. | Source : Annexe 7 v1.8 G2.19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

<!--PATTERN F1-START-ACHETEUR-TVA-G2.33-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty" mode="M13" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:SpecifiedLegalOrganization/ram:ID/@schemeID = ('0002','0223')) or string(ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:SpecifiedLegalOrganization/ram:ID/@schemeID = ('0002','0223')) or string(ram:SpecifiedTaxRegistration/ram:ID[@schemeID='VA'])">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.33] L'identifiant TVA de l'acheteur est obligatoire au démarrage si son identifiant de structure est un SIREN ou UE_HORS_FRANCE. | Source : Annexe 7 v1.8 G2.33</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="*" />
  </xsl:template>

<!--PATTERN F1-START-ACHETEUR-PAYS-G2.01-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID" mode="M14" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^[A-Z]{2}$') and not(. = 'EL')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^[A-Z]{2}$') and not(. = 'EL')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.01] Le code pays de l'acheteur (<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />) doit comporter 2 lettres majuscules ISO 3166-1 alpha-2 ('GR' requis pour la Grèce). | Source : Annexe 7 v1.8 G2.01</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="*" />
  </xsl:template>

<!--PATTERN F1-START-TAXE-TYPE-G1.103-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode" mode="M15" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:TypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = 'VAT'" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = 'VAT'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.103] Le type de taxe doit obligatoirement être égal à 'VAT' (TVA) sur les flux de facturation. | Source : Annexe 7 v1.8 G1.103</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M15" priority="-1" />
  <xsl:template match="@*|node()" mode="M15" priority="-2">
    <xsl:apply-templates mode="M15" select="*" />
  </xsl:template>

<!--PATTERN F1-START-PAIEMENT-CONDITIONS-P1.11-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode" mode="M16" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:DueDateTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('5','29','72','3','35','432')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('5','29','72','3','35','432')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[P1.11] Le code de date d'exigibilite de la TVA (BT-8) doit appartenir aux nomenclatures UNTDID 2475 ou 2005. | Source : Annexe 7 v1.8 P1.11</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M16" priority="-1" />
  <xsl:template match="@*|node()" mode="M16" priority="-2">
    <xsl:apply-templates mode="M16" select="*" />
  </xsl:template>

<!--PATTERN F1-START-PAIEMENT-MOYEN-BT81-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode" mode="M17" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('10', '20', '30', '42', '48', '49', '97')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('10', '20', '30', '42', '48', '49', '97')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BT-81] Le code du moyen de paiement saisi ('<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />') n'est pas conforme à la nomenclature restreinte du démarrage. | Source : Codelist ISO/UNECE</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M17" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M17" priority="-1" />
  <xsl:template match="@*|node()" mode="M17" priority="-2">
    <xsl:apply-templates mode="M17" select="*" />
  </xsl:template>

<!--PATTERN F1-START-LOGISTIQUE-TRANSPORT-BT80-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:SpecifiedBorderTransportMeans/ram:ModeCode" mode="M18" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:SpecifiedBorderTransportMeans/ram:ModeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BT-80] Le code du mode de transport ('<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />') doit faire partie de la nomenclature de la Recommandation 19 de l'UNECE. | Source : UNECE Rec 19</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M18" priority="-1" />
  <xsl:template match="@*|node()" mode="M18" priority="-2">
    <xsl:apply-templates mode="M18" select="*" />
  </xsl:template>

<!--PATTERN F1-START-TVA-CATEGORIE-G2.31-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode" mode="M19" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = ('S','E','AE','K','G','O','Z')" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = ('S','E','AE','K','G','O','Z')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.31] Le code de catégorie TVA saisi ('<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />') doit appartenir à la nomenclature autorisée UNTDID 5305. | Source : Annexe 7 v1.8 G2.31</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M19" priority="-1" />
  <xsl:template match="@*|node()" mode="M19" priority="-2">
    <xsl:apply-templates mode="M19" select="*" />
  </xsl:template>

<!--PATTERN F1-START-TVA-TAUX-G1.24-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent" mode="M20" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:RateApplicablePercent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(.) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.24] Le taux de TVA appliqué (<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />%) n'est pas présent dans la liste des taux légaux français autorisés. | Source : Annexe 7 v1.8 G1.24</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M20" priority="-1" />
  <xsl:template match="@*|node()" mode="M20" priority="-2">
    <xsl:apply-templates mode="M20" select="*" />
  </xsl:template>

<!--PATTERN F1-START-TOTAL-FORMATS-G1.14-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/*[ends-with(local-name(), 'Amount')]" mode="M21" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/*[ends-with(local-name(), 'Amount')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(string(.), '^-?\d+(\.\d{1,2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(string(.), '^-?\d+(\.\d{1,2})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="local-name()" />
            <xsl:text /> : Le montant saisi ('<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />') comporte trop de décimales (2 maximum autorisées avec séparateur point). | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(string(.), '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(string(.), '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] <xsl:text />
            <xsl:value-of select="local-name()" />
            <xsl:text /> : La longueur totale dépasse la limite des 19 chiffres significatifs. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M21" priority="-1" />
  <xsl:template match="@*|node()" mode="M21" priority="-2">
    <xsl:apply-templates mode="M21" select="*" />
  </xsl:template>

<!--PATTERN F1-START-TOTAL-COHERENCE-G1.53-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement" mode="M22" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement" />
    <xsl:variable name="totalHT" select="ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxExclusiveAmount" />
    <xsl:variable name="sommeBasesHT" select="ram:ApplicableTradeTax/ram:BasisAmount" />
    <xsl:variable name="totalTVA" select="ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']" />
    <xsl:variable name="sommeTVA" select="ram:ApplicableTradeTax/ram:CalculatedAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($totalHT) or not($sommeBasesHT) or (abs(number($totalHT) - sum($sommeBasesHT)) &lt;= 0.01)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($totalHT) or not($sommeBasesHT) or (abs(number($totalHT) - sum($sommeBasesHT)) &lt;= 0.01)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.53] Écart sur le Total Hors Taxe global (<xsl:text />
            <xsl:value-of select="$totalHT" />
            <xsl:text />) vis-à-vis de la somme des bases ventilées (<xsl:text />
            <xsl:value-of select="sum($sommeBasesHT)" />
            <xsl:text />). Tolérance de 0,01 EUR. | Source : Annexe 7 v1.8 G1.53</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($totalTVA) or not($sommeTVA) or (abs(number($totalTVA) - sum($sommeTVA)) &lt;= 0.01)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($totalTVA) or not($sommeTVA) or (abs(number($totalTVA) - sum($sommeTVA)) &lt;= 0.01)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.53] Écart sur le Montant Total de TVA global (<xsl:text />
            <xsl:value-of select="$totalTVA" />
            <xsl:text />) vis-à-vis de la somme des lignes de TVA calculées (<xsl:text />
            <xsl:value-of select="sum($sommeTVA)" />
            <xsl:text />). Tolérance de 0,01 EUR. | Source : Annexe 7 v1.8 G1.53</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M22" priority="-1" />
  <xsl:template match="@*|node()" mode="M22" priority="-2">
    <xsl:apply-templates mode="M22" select="*" />
  </xsl:template>

<!--PATTERN F1-START-LIGNE-PRIX-G1.55-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice" mode="M23" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice" />
    <xsl:variable name="prixNet" select="number(ram:ChargeAmount)" />
    <xsl:variable name="nodePrixBrut" select="../ram:GrossPriceProductTradePrice/ram:ChargeAmount" />
    <xsl:variable name="prixBrut" select="if ($nodePrixBrut) then number($nodePrixBrut) else $prixNet" />
    <xsl:variable name="nodeRabais" select="../ram:GrossPriceProductTradePrice/ram:AppliedTradeAllowanceCharge/ram:ActualAmount" />
    <xsl:variable name="rabais" select="if (string($nodeRabais)) then number($nodeRabais) else 0" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not($nodePrixBrut) or (abs($prixNet - ($prixBrut - $rabais)) &lt;= 0.01)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($nodePrixBrut) or (abs($prixNet - ($prixBrut - $rabais)) &lt;= 0.01)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.55] Incohérence sur la ligne d'article : le prix net unitaire calculé (<xsl:text />
            <xsl:value-of select="$prixNet" />
            <xsl:text />) doit correspondre au prix brut unitaire (<xsl:text />
            <xsl:value-of select="$prixBrut" />
            <xsl:text />) moins les remises et rabais (<xsl:text />
            <xsl:value-of select="$rabais" />
            <xsl:text />). | Source : Annexe 7 v1.8 G1.55</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M23" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M23" priority="-1" />
  <xsl:template match="@*|node()" mode="M23" priority="-2">
    <xsl:apply-templates mode="M23" select="*" />
  </xsl:template>

<!--PATTERN F1-START-LIGNE-QUANTITE-G1.15-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity" mode="M24" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:BilledQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(string(.), '^-?\d+(\.\d{1,4})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(string(.), '^-?\d+(\.\d{1,4})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.15] La quantité facturée sur la ligne (<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />) possède un nombre de décimales invalide (maximum 4 décimales avec séparateur point). | Source : Annexe 7 v1.8 G1.15</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M24" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M24" priority="-1" />
  <xsl:template match="@*|node()" mode="M24" priority="-2">
    <xsl:apply-templates mode="M24" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G6.08-OBLIGATOIRES-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice" mode="M25" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:ExchangedDocument/ram:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:ExchangedDocument/ram:ID">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-1 Numero de facture obligatoire en trajectoire DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-2 Date d'emission obligatoire en trajectoire DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:ExchangedDocument/ram:TypeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:ExchangedDocument/ram:TypeCode">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-3 Type de facture obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-5 Devise obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-23 Cadre de facturation obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-24 Profil obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-30 SIREN vendeur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID/@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID/@schemeID">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-30-1 Qualifiant SIREN vendeur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-40 Pays vendeur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-47 SIREN acheteur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID/@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID/@schemeID">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-47-1 Qualifiant SIREN acheteur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress/ram:CountryID">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-55 Pays acheteur obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BG-22 Totaux document obligatoires. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-109 Total hors TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-110 Montant total TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BG-23 Ventilation TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M25" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M25" priority="-1" />
  <xsl:template match="@*|node()" mode="M25" priority="-2">
    <xsl:apply-templates mode="M25" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-BG23-G6.08-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" mode="M26" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:BasisAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:BasisAmount">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-116 Base d'imposition du type TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:CalculatedAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:CalculatedAmount">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-117 Montant TVA par type obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:CategoryCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:CategoryCode">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-118 Code type TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:TypeCode = 'VAT'" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:TypeCode = 'VAT'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[S1.17] BT-118-0 Qualifiant du code type TVA obligatoire et egal a VAT. | Source : Annexe 7 v1.8 S1.17</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:RateApplicablePercent" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:RateApplicablePercent">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.08] BT-119 Taux TVA obligatoire. | Source : Annexe 1 Flux 1 / Annexe 7 G6.08</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M26" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M26" priority="-1" />
  <xsl:template match="@*|node()" mode="M26" priority="-2">
    <xsl:apply-templates mode="M26" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G1.02-G1.60-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice" mode="M27" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = ('B1','S1','M1','B2','S2','M2','B4','S4','M4','S5','S6','B7','S7')" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = ('B1','S1','M1','B2','S2','M2','B4','S4','M4','S5','S6','B7','S7')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.02] Le cadre de facturation BT-23 doit appartenir a la liste autorisee. | Source : Annexe 7 v1.8 G1.02</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = ('B4','S4','M4') and rsm:ExchangedDocument/ram:TypeCode = ('386','500','503'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID = ('B4','S4','M4') and rsm:ExchangedDocument/ram:TypeCode = ('386','500','503'))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.60] Le type de facture est incompatible avec le cadre B4/S4/M4. | Source : Annexe 7 v1.8 G1.60</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M27" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M27" priority="-1" />
  <xsl:template match="@*|node()" mode="M27" priority="-2">
    <xsl:apply-templates mode="M27" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G1.10-G1.12-DEVISES-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice" mode="M28" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode, '^[A-Z]{3}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode, '^[A-Z]{3}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.10] BT-5 doit respecter le format ISO 4217. | Source : Annexe 7 v1.8 G1.10</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode != 'EUR') or rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode != 'EUR') or rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.12] Si BT-5 est different de EUR, BT-111 doit etre renseigne en EUR. | Source : Annexe 7 v1.8 G1.12</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M28" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M28" priority="-1" />
  <xsl:template match="@*|node()" mode="M28" priority="-2">
    <xsl:apply-templates mode="M28" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G1.09-DATES-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice//udt:DateTimeString" mode="M29" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice//udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] La date CII doit respecter le format AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or (number(substring(.,1,4)) >= 2000 and number(substring(.,1,4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(.,1,4)) >= 2000 and number(substring(.,1,4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'annee de la date doit etre comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M29" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M29" priority="-1" />
  <xsl:template match="@*|node()" mode="M29" priority="-2">
    <xsl:apply-templates mode="M29" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G6.25-PERIODES-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod[ram:StartDateTime/udt:DateTimeString and ram:EndDateTime/udt:DateTimeString]" mode="M30" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod[ram:StartDateTime/udt:DateTimeString and ram:EndDateTime/udt:DateTimeString]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:EndDateTime/udt:DateTimeString > ram:StartDateTime/udt:DateTimeString" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:EndDateTime/udt:DateTimeString > ram:StartDateTime/udt:DateTimeString">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.25] La date de fin de periode ne peut pas etre anterieure ou egale a la date de debut. | Source : Annexe 7 v1.8 G6.25</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M30" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M30" priority="-1" />
  <xsl:template match="@*|node()" mode="M30" priority="-2">
    <xsl:apply-templates mode="M30" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G1.31-REFERENCES-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice" mode="M31" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(rsm:ExchangedDocument/ram:TypeCode = ('384','471','472','473')) or count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID) = 1 or (count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID) = 0 and exists(rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem) and (every $l in rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem satisfies ($l/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID and $l/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(rsm:ExchangedDocument/ram:TypeCode = ('384','471','472','473')) or count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID) = 1 or (count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID) = 0 and exists(rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem) and (every $l in rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem satisfies ($l/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID and $l/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString)))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.31] Une facture rectificative doit comporter un unique numero de facture anterieure BT-25 en entete, ou le numero BT-25 et la date BT-26 sur toutes les lignes en profil FULL/CIBLE. | Source : Annexe 7 v1.8 G1.31</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(rsm:ExchangedDocument/ram:TypeCode = ('261','381','396','502','503')) or rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID or (count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID) = 0 and exists(rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem) and (every $l in rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem satisfies ($l/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID and $l/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(rsm:ExchangedDocument/ram:TypeCode = ('261','381','396','502','503')) or rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID or (count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID) = 0 and exists(rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem) and (every $l in rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem satisfies ($l/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID and $l/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString)))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.31] Un avoir doit comporter au moins un numero de facture anterieure BT-25 en entete, ou le numero BT-25 et la date BT-26 sur toutes les lignes en profil FULL/CIBLE. | Source : Annexe 7 v1.8 G1.31</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M31" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M31" priority="-1" />
  <xsl:template match="@*|node()" mode="M31" priority="-2">
    <xsl:apply-templates mode="M31" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G1.05-REF-ID-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID" mode="M32" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(.) &lt;= 35" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(.) &lt;= 35">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] BT-25 ne peut pas depasser 35 caracteres. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(., ' ') or ends-with(., ' ') or contains(., '  '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(., ' ') or ends-with(., ' ') or contains(., ' '))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] BT-25 ne peut pas commencer/terminer par un espace ni contenir deux espaces consecutifs. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^[a-zA-Z0-9 \-\+_/]+$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^[a-zA-Z0-9 \-\+_/]+$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.05] BT-25 contient des caracteres non autorises. | Source : Annexe 7 v1.8 G1.05</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M32" priority="-1" />
  <xsl:template match="@*|node()" mode="M32" priority="-2">
    <xsl:apply-templates mode="M32" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G1.14-MONTANTS-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice//*[local-name() = ('ActualAmount','BasisAmount','CalculatedAmount','TaxBasisTotalAmount','TaxTotalAmount','LineTotalAmount','GrandTotalAmount','AllowanceTotalAmount','ChargeTotalAmount','TotalPrepaidAmount','DuePayableAmount')][not(ancestor::ram:GrossPriceProductTradePrice)][not(ancestor::ram:NetPriceProductTradePrice)]" mode="M33" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice//*[local-name() = ('ActualAmount','BasisAmount','CalculatedAmount','TaxBasisTotalAmount','TaxTotalAmount','LineTotalAmount','GrandTotalAmount','AllowanceTotalAmount','ChargeTotalAmount','TotalPrepaidAmount','DuePayableAmount')][not(ancestor::ram:GrossPriceProductTradePrice)][not(ancestor::ram:NetPriceProductTradePrice)]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(string(.), '^-?\d+(\.\d{1,2})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(string(.), '^-?\d+(\.\d{1,2})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] Le montant doit comporter au maximum 2 decimales avec un point. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(string(.), '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(string(.), '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.14] Le montant ne peut pas depasser 19 chiffres hors separateur et signe. | Source : Annexe 7 v1.8 G1.14</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M33" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M33" priority="-1" />
  <xsl:template match="@*|node()" mode="M33" priority="-2">
    <xsl:apply-templates mode="M33" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G1.16-PRIX-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem//ram:SpecifiedLineTradeAgreement//*[ends-with(local-name(), 'Amount')]" mode="M34" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem//ram:SpecifiedLineTradeAgreement//*[ends-with(local-name(), 'Amount')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(string(.), '^\d+(\.\d{1,6})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(string(.), '^\d+(\.\d{1,6})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] Le prix doit comporter au maximum 6 decimales, sans signe negatif. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(string(.), '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(string(.), '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] Le prix ne peut pas depasser 19 chiffres hors separateur. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M34" priority="-1" />
  <xsl:template match="@*|node()" mode="M34" priority="-2">
    <xsl:apply-templates mode="M34" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G1.63-SIREN-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID | /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID" mode="M35" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID | /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID = '0002'" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID = '0002'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.63] Le vendeur et l'acheteur doivent etre identifies par un SIREN qualifie 0002 en Flux 1 DEMARRAGE. | Source : Annexe 1 Flux 1 / Annexe 7 G1.63</svrl:text>
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
          <svrl:text>[G1.63] Le SIREN vendeur/acheteur doit comporter exactement 9 chiffres. | Source : Annexe 7 v1.8 G1.63</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M35" priority="-1" />
  <xsl:template match="@*|node()" mode="M35" priority="-2">
    <xsl:apply-templates mode="M35" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-S1.14-ASSUJETTI-UNIQUE-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID" mode="M36" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID = '0231'" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID = '0231'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[S1.14] L'identifiant d'assujetti unique BT-29d doit utiliser le qualifiant 0231. | Source : Annexe 7 v1.8 S1.14</svrl:text>
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
          <svrl:text>[G1.101] Le SIREN de l'assujetti unique doit comporter 9 chiffres. | Source : Annexe 7 v1.8 G1.101</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M36" priority="-1" />
  <xsl:template match="@*|node()" mode="M36" priority="-2">
    <xsl:apply-templates mode="M36" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-S1.17-QUALIFIANTS-TVA-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice//ram:SpecifiedTaxRegistration/ram:ID" mode="M37" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice//ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID = 'VA'" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID = 'VA'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[S1.17] Le qualifiant d'identifiant TVA doit etre VA en CII pour BT-31/48/63. | Source : Annexe 7 v1.8 S1.17</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M37" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M37" priority="-1" />
  <xsl:template match="@*|node()" mode="M37" priority="-2">
    <xsl:apply-templates mode="M37" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-S1.13-DUE-DATE-TYPE-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement" mode="M38" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(distinct-values(ram:ApplicableTradeTax/ram:DueDateTypeCode)) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(distinct-values(ram:ApplicableTradeTax/ram:DueDateTypeCode)) &lt;= 1">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[S1.13] En CII, BT-8 doit avoir la meme valeur si BG-23 est repete. | Source : Annexe 7 v1.8 S1.13</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M38" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M38" priority="-1" />
  <xsl:template match="@*|node()" mode="M38" priority="-2">
    <xsl:apply-templates mode="M38" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G1.41-G1.47-G2.32-G6.21-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice" mode="M39" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'E') or (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E']/ram:ExemptionReasonCode and rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E']/ram:ExemptionReason)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'E') or (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E']/ram:ExemptionReasonCode and rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax[ram:CategoryCode='E']/ram:ExemptionReason)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.41] Une ventilation TVA de type E doit comprendre un code et un motif d'exoneration. | Source : Annexe 7 v1.8 G1.41</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'E') or rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID or rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode = 'E') or rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID or rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.47] Si une ventilation TVA est exoneree (E), l'identifiant TVA vendeur ou representant fiscal est obligatoire. | Source : Annexe 7 v1.8 G1.47</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode = 'VATEX-FR-CNWVAT') or rsm:ExchangedDocument/ram:TypeCode = ('261','381','396')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode = 'VATEX-FR-CNWVAT') or rsm:ExchangedDocument/ram:TypeCode = ('261','381','396')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.21] Le code VATEX-FR-CNWVAT est reserve aux avoirs 261, 381 ou 396. | Source : Annexe 7 v1.8 G6.21</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(every $c in rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode satisfies ($c = ('O','E')) and exists(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[. = ('VATEX-FR-CGI261-1','VATEX-FR-CGI261-2','VATEX-FR-CGI261-3','VATEX-FR-CGI261-4','VATEX-FR-CGI261-5','VATEX-FR-CGI261-7','VATEX-FR-CGI261-8','VATEX-FR-CGI261A','VATEX-FR-CGI261B','VATEX-FR-CGI261C-1','VATEX-FR-CGI261C-2','VATEX-FR-CGI261C-3','VATEX-FR-CGI261D-1','VATEX-FR-CGI261D-1BIS','VATEX-FR-CGI261D-2','VATEX-FR-CGI261D-3','VATEX-FR-CGI261D-4','VATEX-FR-CGI261E-1','VATEX-FR-CGI261E-2')]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(every $c in rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:CategoryCode satisfies ($c = ('O','E')) and exists(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax/ram:ExemptionReasonCode[. = ('VATEX-FR-CGI261-1','VATEX-FR-CGI261-2','VATEX-FR-CGI261-3','VATEX-FR-CGI261-4','VATEX-FR-CGI261-5','VATEX-FR-CGI261-7','VATEX-FR-CGI261-8','VATEX-FR-CGI261A','VATEX-FR-CGI261B','VATEX-FR-CGI261C-1','VATEX-FR-CGI261C-2','VATEX-FR-CGI261C-3','VATEX-FR-CGI261D-1','VATEX-FR-CGI261D-1BIS','VATEX-FR-CGI261D-2','VATEX-FR-CGI261D-3','VATEX-FR-CGI261D-4','VATEX-FR-CGI261E-1','VATEX-FR-CGI261E-2')]))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.32] Rejet si la facture comporte uniquement des codes TVA O/E avec un code d'exoneration hors champs liste. | Source : Annexe 7 v1.8 G2.32</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M39" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M39" priority="-1" />
  <xsl:template match="@*|node()" mode="M39" priority="-2">
    <xsl:apply-templates mode="M39" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G1.24-G2.31-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" mode="M40" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:CategoryCode = ('S','E','AE','K','G','O','Z')" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:CategoryCode = ('S','E','AE','K','G','O','Z')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.31] Le code de categorie TVA doit appartenir a la liste autorisee. | Source : Annexe 7 v1.8 G2.31</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(ram:RateApplicablePercent) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(ram:RateApplicablePercent) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.24] Le taux de TVA doit appartenir a la liste des taux autorises. | Source : Annexe 7 v1.8 G1.24</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M40" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M40" priority="-1" />
  <xsl:template match="@*|node()" mode="M40" priority="-2">
    <xsl:apply-templates mode="M40" select="*" />
  </xsl:template>

<!--PATTERN F1-COMPLETE-CII-G1.53-COHERENCE-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement" mode="M41" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount) or not(ram:ApplicableTradeTax/ram:BasisAmount) or abs(number(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount) - sum(ram:ApplicableTradeTax/ram:BasisAmount)) &lt;= 0.01" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount) or not(ram:ApplicableTradeTax/ram:BasisAmount) or abs(number(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount) - sum(ram:ApplicableTradeTax/ram:BasisAmount)) &lt;= 0.01">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.53] Le total hors TVA doit etre egal a la somme des bases d'imposition, tolerance 0,01. | Source : Annexe 7 v1.8 G1.53</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']) or not(ram:ApplicableTradeTax/ram:CalculatedAmount) or abs(number(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']) - sum(ram:ApplicableTradeTax/ram:CalculatedAmount)) &lt;= 0.01" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']) or not(ram:ApplicableTradeTax/ram:CalculatedAmount) or abs(number(ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID='EUR']) - sum(ram:ApplicableTradeTax/ram:CalculatedAmount)) &lt;= 0.01">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.53] Le total TVA EUR doit etre egal a la somme des TVA par ventilation, tolerance 0,01. | Source : Annexe 7 v1.8 G1.53</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M41" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M41" priority="-1" />
  <xsl:template match="@*|node()" mode="M41" priority="-2">
    <xsl:apply-templates mode="M41" select="*" />
  </xsl:template>

<!--PATTERN F1-FULL-CII-G6.09-LIGNES-OBLIGATOIRES-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice" mode="M42" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem" />
      <xsl:otherwise>
        <svrl:failed-assert test="rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.09] BG-25 Ligne de facture obligatoire en profil FULL/CIBLE. Extension du profil BASE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M42" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M42" priority="-1" />
  <xsl:template match="@*|node()" mode="M42" priority="-2">
    <xsl:apply-templates mode="M42" select="*" />
  </xsl:template>

<!--PATTERN F1-FULL-CII-G6.09-CONTENU-LIGNE-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem" mode="M43" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:SpecifiedLineTradeDelivery/ram:BilledQuantity" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:SpecifiedLineTradeDelivery/ram:BilledQuantity">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.09] BT-129 Quantite facturee obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:SpecifiedLineTradeDelivery/ram:BilledQuantity/@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:SpecifiedLineTradeDelivery/ram:BilledQuantity/@unitCode">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.09] BT-130 Unite de quantite obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:SpecifiedLineTradeAgreement" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:SpecifiedLineTradeAgreement">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.09] BG-29 Detail du prix obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:ChargeAmount">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.09] BT-146 Prix net unitaire obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:SpecifiedLineTradeAgreement/ram:GrossPriceProductTradePrice/ram:ChargeAmount">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.09] BT-148 Prix brut unitaire obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:SpecifiedTradeProduct" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:SpecifiedTradeProduct">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.09] BG-31 Article obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:SpecifiedTradeProduct/ram:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:SpecifiedTradeProduct/ram:Name">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.09] BT-153 Nom de l'article obligatoire en profil FULL/CIBLE. | Source : Annexe 1 Flux 1 / Annexe 7 G6.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M43" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M43" priority="-1" />
  <xsl:template match="@*|node()" mode="M43" priority="-2">
    <xsl:apply-templates mode="M43" select="*" />
  </xsl:template>

<!--PATTERN F1-CIBLE-CII-G1.31-REFERENCES-ANTERIEURES-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice" mode="M44" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID and rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID and rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.31] Les references a factures anterieures ne doivent pas etre renseignees simultanement en entete et en ligne en profil FULL/CIBLE. | Source : Annexe 7 v1.8 G1.31</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(rsm:ExchangedDocument/ram:TypeCode = ('261','381','384','396','471','472','473','502','503')) or (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID and rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString) or (every $l in rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem satisfies ($l/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID and $l/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(rsm:ExchangedDocument/ram:TypeCode = ('261','381','384','396','471','472','473','502','503')) or (rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID and rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString) or (every $l in rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem satisfies ($l/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID and $l/ram:SpecifiedLineTradeSettlement/ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.31] Pour un avoir ou une facture rectificative en FULL/CIBLE, la reference anterieure doit porter le numero et la date, soit en entete soit sur toutes les lignes. | Source : Annexe 7 v1.8 G1.31</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(rsm:ExchangedDocument/ram:TypeCode = ('384','471','472','473')) or count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(rsm:ExchangedDocument/ram:TypeCode = ('384','471','472','473')) or count(rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument/ram:IssuerAssignedID) &lt;= 1">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.31] Une facture rectificative doit pointer au plus une facture anterieure en entete. | Source : Annexe 7 v1.8 G1.31</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M44" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M44" priority="-1" />
  <xsl:template match="@*|node()" mode="M44" priority="-2">
    <xsl:apply-templates mode="M44" select="*" />
  </xsl:template>

<!--PATTERN F1-CIBLE-CII-BT26-DATE-FACTURE-ANTERIEURE-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice//ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M45" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice//ram:InvoiceReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] BT-26 Date de facture anterieure au format CII AAAAMMJJ. | Source : Annexe 1 Flux 1 / Annexe 7 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] BT-26 L'annee de la facture anterieure doit etre comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M45" priority="-1" />
  <xsl:template match="@*|node()" mode="M45" priority="-2">
    <xsl:apply-templates mode="M45" select="*" />
  </xsl:template>

<!--PATTERN F1-CIBLE-CII-G6.16-ADRESSE-LIVRAISON-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress | /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress" mode="M46" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress | /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:PostalTradeAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:LineOne" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:LineOne">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.16] BT-75 Ligne d'adresse de livraison obligatoire lorsque l'adresse de livraison est renseignee. | Source : Annexe 1 Flux 1 / Annexe 7 G6.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:CityName" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:CityName">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.16] BT-77 Ville de livraison obligatoire lorsque l'adresse de livraison est renseignee. | Source : Annexe 1 Flux 1 / Annexe 7 G6.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:PostcodeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:PostcodeCode">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.16] BT-78 Code postal de livraison obligatoire lorsque l'adresse de livraison est renseignee. | Source : Annexe 1 Flux 1 / Annexe 7 G6.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:CountryID" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:CountryID">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.16] BT-80 Code pays de livraison obligatoire lorsque l'adresse de livraison est renseignee. | Source : Annexe 1 Flux 1 / Annexe 7 G6.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:CountryID) or (matches(ram:CountryID, '^[A-Z]{2}$') and not(ram:CountryID = 'EL'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:CountryID) or (matches(ram:CountryID, '^[A-Z]{2}$') and not(ram:CountryID = 'EL'))">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G2.01] Le code pays de livraison doit etre au format ISO 3166-1 alpha-2, avec GR pour la Grece. | Source : Annexe 7 v1.8 G2.01</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M46" priority="-1" />
  <xsl:template match="@*|node()" mode="M46" priority="-2">
    <xsl:apply-templates mode="M46" select="*" />
  </xsl:template>

<!--PATTERN F1-CIBLE-CII-DATES-LIGNE-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString | /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString | /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" mode="M47" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString | /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString | /rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{8}$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.09] Les dates de ligne FULL/CIBLE doivent respecter le format CII AAAAMMJJ. | Source : Annexe 7 v1.8 G1.09</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., '^\d{8}$')) or (number(substring(., 1, 4)) >= 2000 and number(substring(., 1, 4)) &lt;= 2099)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.36] L'annee des dates de ligne FULL/CIBLE doit etre comprise entre 2000 et 2099. | Source : Annexe 7 v1.8 G1.36</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M47" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M47" priority="-1" />
  <xsl:template match="@*|node()" mode="M47" priority="-2">
    <xsl:apply-templates mode="M47" select="*" />
  </xsl:template>

<!--PATTERN F1-CIBLE-CII-G6.25-PERIODES-LIGNE-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod[ram:StartDateTime/udt:DateTimeString and ram:EndDateTime/udt:DateTimeString]" mode="M48" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:BillingSpecifiedPeriod[ram:StartDateTime/udt:DateTimeString and ram:EndDateTime/udt:DateTimeString]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:EndDateTime/udt:DateTimeString > ram:StartDateTime/udt:DateTimeString" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:EndDateTime/udt:DateTimeString > ram:StartDateTime/udt:DateTimeString">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.25] En ligne, la date de fin de periode ne peut pas etre anterieure ou egale a la date de debut. | Source : Annexe 7 v1.8 G6.25</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M48" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M48" priority="-1" />
  <xsl:template match="@*|node()" mode="M48" priority="-2">
    <xsl:apply-templates mode="M48" select="*" />
  </xsl:template>

<!--PATTERN F1-FULL-CII-ALLOWANCE-CHARGE-DOCUMENT-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/                  rsm:SupplyChainTradeTransaction/                  ram:ApplicableHeaderTradeSettlement/                  ram:SpecifiedTradeAllowanceCharge" mode="M49" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/                  rsm:SupplyChainTradeTransaction/                  ram:ApplicableHeaderTradeSettlement/                  ram:SpecifiedTradeAllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:ActualAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:ActualAmount">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
      [G6.09] BT-92/BT-99 Montant de remise ou charge document obligatoire lorsque BG-20/BG-21 est renseigné.
      | Source : Annexe 1 Flux 1
    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:CategoryTradeTax/ram:CategoryCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:CategoryTradeTax/ram:CategoryCode">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
      [G6.09] Code de catégorie TVA obligatoire sur remise/charge document.
      | Source : Annexe 1 Flux 1
    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:ChargeIndicator/udt:Indicator = ('true', '1')             or normalize-space(ram:CategoryTradeTax/ram:RateApplicablePercent) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:ChargeIndicator/udt:Indicator = ('true', '1') or normalize-space(ram:CategoryTradeTax/ram:RateApplicablePercent) != ''">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
      [G6.10] Le taux de TVA est obligatoire pour une remise au niveau du document.
      | Source : Annexe 7 v1.8 G6.10
    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:CategoryTradeTax/ram:TypeCode = 'VAT'" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:CategoryTradeTax/ram:TypeCode = 'VAT'">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
      [S1.17] Le qualifiant TVA des remises/charges document doit être VAT.
      | Source : Annexe 7 v1.8 S1.17
    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:CategoryTradeTax/ram:CategoryCode)             or ram:CategoryTradeTax/ram:CategoryCode =                ('S','E','AE','K','G','O','Z')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:CategoryTradeTax/ram:CategoryCode) or ram:CategoryTradeTax/ram:CategoryCode = ('S','E','AE','K','G','O','Z')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
      [G2.31] Le code de catégorie TVA des remises/charges document doit appartenir à la liste autorisée.
      | Source : Annexe 7 v1.8 G2.31
    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(ram:CategoryTradeTax/ram:RateApplicablePercent)             or number(ram:CategoryTradeTax/ram:RateApplicablePercent) =                (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(ram:CategoryTradeTax/ram:RateApplicablePercent) or number(ram:CategoryTradeTax/ram:RateApplicablePercent) = (0, 0.9, 1.05, 1.75, 2.1, 5.5, 7, 8.5, 9.2, 9.6, 10, 13, 19.6, 20, 20.6)">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
      [G1.24] Le taux de TVA des remises/charges document doit appartenir à la liste autorisée.
      | Source : Annexe 7 v1.8 G1.24
    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M49" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M49" priority="-1" />
  <xsl:template match="@*|node()" mode="M49" priority="-2">
    <xsl:apply-templates mode="M49" select="*" />
  </xsl:template>

<!--PATTERN F1-FULL-CII-ALLOWANCE-CHARGE-LIGNE-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge" mode="M50" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement/ram:SpecifiedTradeAllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ram:ActualAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="ram:ActualAmount">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G6.09] Montant de remise/charge de ligne obligatoire lorsque BG-27/BG-28 est renseigne. | Source : Annexe 1 Flux 1</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M50" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M50" priority="-1" />
  <xsl:template match="@*|node()" mode="M50" priority="-2">
    <xsl:apply-templates mode="M50" select="*" />
  </xsl:template>

<!--PATTERN F1-FULL-CII-G1.16-PRIX-LIGNE-->


	<!--RULE -->
<xsl:template match="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement//ram:*[local-name() = ('ChargeAmount','ActualAmount','BasisAmount')]" mode="M51" priority="1000">
    <svrl:fired-rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement//ram:*[local-name() = ('ChargeAmount','ActualAmount','BasisAmount')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(string(.), '^\d+(\.\d{1,6})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(string(.), '^\d+(\.\d{1,6})?$')">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] Le prix doit comporter au maximum 6 decimales, sans signe negatif. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(translate(string(.), '.', '')) &lt;= 19" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(translate(string(.), '.', '')) &lt;= 19">
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[G1.16] Le prix ne peut pas depasser 19 chiffres hors separateur. | Source : Annexe 7 v1.8 G1.16</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M51" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M51" priority="-1" />
  <xsl:template match="@*|node()" mode="M51" priority="-2">
    <xsl:apply-templates mode="M51" select="*" />
  </xsl:template>
</xsl:stylesheet>
