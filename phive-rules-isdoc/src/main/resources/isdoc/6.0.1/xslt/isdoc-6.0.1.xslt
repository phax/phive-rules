<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:isdoc="http://isdoc.cz/namespace/2013" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
    <svrl:schematron-output schemaVersion="" title="Kontrola vybraných pravidel ISDOC">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="isdoc" uri="http://isdoc.cz/namespace/2013" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="name">Vazba na původní doklad</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M2" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="name">Konzistentní uvádění cizí měny</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M3" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="name">Konzistentní uvádění tuzemské měny</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M4" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="name">Tuzemská a zahraniční měna musí být rozdílná</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M5" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Kontrola vybraných pravidel ISDOC</svrl:text>

<!--PATTERN Vazba na původní doklad-->
<svrl:text>Vazba na původní doklad</svrl:text>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:DocumentType = (2,3,6)]" mode="M2" priority="1000">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:DocumentType = (2,3,6)]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:OriginalDocumentReferences/*" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:OriginalDocumentReferences/*">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Pro typ dokladu 2, 3 a 6 musí existovat vazba na původní doklad. Konkrétně tedy pro DocumentType = 2, 3, 6 musí existovat element OriginalDocumentReference a musí byt neprázdný.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M2" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M2" priority="-1" />
  <xsl:template match="@*|node()" mode="M2" priority="-2">
    <xsl:apply-templates mode="M2" select="*" />
  </xsl:template>

<!--PATTERN Konzistentní uvádění cizí měny-->
<svrl:text>Konzistentní uvádění cizí měny</svrl:text>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:LineExtensionAmount]" mode="M3" priority="1019">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:LineExtensionAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:LineExtensionAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:LineExtensionAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:LineExtensionAmountTaxInclusive]" mode="M3" priority="1018">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:LineExtensionAmountTaxInclusive]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:LineExtensionAmountTaxInclusiveCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:LineExtensionAmountTaxInclusiveCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:DepositAmount]" mode="M3" priority="1017">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:DepositAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:DepositAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:DepositAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:TaxableDepositAmount]" mode="M3" priority="1016">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:TaxableDepositAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:TaxableDepositAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:TaxableDepositAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:TaxInclusiveDepositAmount]" mode="M3" priority="1015">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:TaxInclusiveDepositAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:TaxInclusiveDepositAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:TaxInclusiveDepositAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:TaxAmount]" mode="M3" priority="1014">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:TaxAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:TaxAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:TaxAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:TaxableAmount]" mode="M3" priority="1013">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:TaxableAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:TaxableAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:TaxableAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:TaxInclusiveAmount]" mode="M3" priority="1012">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:TaxInclusiveAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:TaxInclusiveAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:TaxInclusiveAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:AlreadyClaimedTaxableAmount]" mode="M3" priority="1011">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:AlreadyClaimedTaxableAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:AlreadyClaimedTaxableAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:AlreadyClaimedTaxableAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:AlreadyClaimedTaxAmount]" mode="M3" priority="1010">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:AlreadyClaimedTaxAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:AlreadyClaimedTaxAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:AlreadyClaimedTaxAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:AlreadyClaimedTaxInclusiveAmount]" mode="M3" priority="1009">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:AlreadyClaimedTaxInclusiveAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:AlreadyClaimedTaxInclusiveAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:AlreadyClaimedTaxInclusiveAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:DifferenceTaxableAmount]" mode="M3" priority="1008">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:DifferenceTaxableAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:DifferenceTaxableAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:DifferenceTaxableAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:DifferenceTaxAmount]" mode="M3" priority="1007">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:DifferenceTaxAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:DifferenceTaxAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:DifferenceTaxAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:DifferenceTaxInclusiveAmount]" mode="M3" priority="1006">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:DifferenceTaxInclusiveAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:DifferenceTaxInclusiveAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:DifferenceTaxInclusiveAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:TaxExclusiveAmount]" mode="M3" priority="1005">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:TaxExclusiveAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:TaxExclusiveAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:TaxExclusiveAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:AlreadyClaimedTaxExclusiveAmount]" mode="M3" priority="1004">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:AlreadyClaimedTaxExclusiveAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:AlreadyClaimedTaxExclusiveAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:AlreadyClaimedTaxExclusiveAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:DifferenceTaxExclusiveAmount]" mode="M3" priority="1003">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:DifferenceTaxExclusiveAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:DifferenceTaxExclusiveAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:DifferenceTaxExclusiveAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:PayableRoundingAmount]" mode="M3" priority="1002">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:PayableRoundingAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:PayableRoundingAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:PayableRoundingAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:PaidDepositsAmount]" mode="M3" priority="1001">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:PaidDepositsAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:PaidDepositsAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:PaidDepositsAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:PayableAmount]" mode="M3" priority="1000">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]//*[isdoc:PayableAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:PayableAmountCurr" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:PayableAmountCurr">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v cizí měně musí obsahovat v cizí měně i všechny finanční elementy. Konkrétně: pokud existuje element ForeignCurrencyCode, pak musí existovat všechny elementy s částkami pro cizí měnu tj. ty končící na Curr.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M3" priority="-1" />
  <xsl:template match="@*|node()" mode="M3" priority="-2">
    <xsl:apply-templates mode="M3" select="*" />
  </xsl:template>

<!--PATTERN Konzistentní uvádění tuzemské měny-->
<svrl:text>Konzistentní uvádění tuzemské měny</svrl:text>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[not(isdoc:ForeignCurrencyCode)]" mode="M4" priority="1001">
    <svrl:fired-rule context="isdoc:Invoice[not(isdoc:ForeignCurrencyCode)]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:CurrRate = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:CurrRate = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:RefCurrRate = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:RefCurrRate = 1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M4" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[not(isdoc:ForeignCurrencyCode)]" mode="M4" priority="1000">
    <svrl:fired-rule context="isdoc:Invoice[not(isdoc:ForeignCurrencyCode)]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:LineExtensionAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:LineExtensionAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:LineExtensionAmountTaxInclusiveCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:LineExtensionAmountTaxInclusiveCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:DepositAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:DepositAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:TaxableDepositAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:TaxableDepositAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:TaxInclusiveDepositAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:TaxInclusiveDepositAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:TaxAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:TaxAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:TaxableAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:TaxableAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:TaxInclusiveAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:TaxInclusiveAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:AlreadyClaimedTaxableAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:AlreadyClaimedTaxableAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:AlreadyClaimedTaxAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:AlreadyClaimedTaxAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:AlreadyClaimedTaxInclusiveAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:AlreadyClaimedTaxInclusiveAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:DifferenceTaxableAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:DifferenceTaxableAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:DifferenceTaxAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:DifferenceTaxAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:DifferenceTaxInclusiveAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:DifferenceTaxInclusiveAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:TaxExclusiveAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:TaxExclusiveAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:AlreadyClaimedTaxExclusiveAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:AlreadyClaimedTaxExclusiveAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:DifferenceTaxExclusiveAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:DifferenceTaxExclusiveAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:PayableRoundingAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:PayableRoundingAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:PaidDepositsAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:PaidDepositsAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//isdoc:PayableAmountCurr)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//isdoc:PayableAmountCurr)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Doklad vystavený v tuzemské měně nesmí obsahovat žádný element v cizí měně. Pokud neexistuje element ForeignCurrencyCode, pak nesmí existovat žádný element pro cizí měnu, tj. element končící na Curr. Položky s kursem (CurrRate i RefCurrRate) musí být rovny hodnotě 1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M4" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M4" priority="-1" />
  <xsl:template match="@*|node()" mode="M4" priority="-2">
    <xsl:apply-templates mode="M4" select="*" />
  </xsl:template>

<!--PATTERN Tuzemská a zahraniční měna musí být rozdílná-->
<svrl:text>Tuzemská a zahraniční měna musí být rozdílná</svrl:text>

	<!--RULE -->
<xsl:template match="isdoc:Invoice[isdoc:ForeignCurrencyCode]" mode="M5" priority="1000">
    <svrl:fired-rule context="isdoc:Invoice[isdoc:ForeignCurrencyCode]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="isdoc:ForeignCurrencyCode != isdoc:LocalCurrencyCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="isdoc:ForeignCurrencyCode != isdoc:LocalCurrencyCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>U dokladu v zahraniční měně nesmí být měna lokální a zahraniční shodné. Konkrétně hodnota povinné položky LocalCurrencyCode se nesmí rovnat hodnotě nepovinné položky ForeignCurrencyCode.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M5" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M5" priority="-1" />
  <xsl:template match="@*|node()" mode="M5" priority="-2">
    <xsl:apply-templates mode="M5" select="*" />
  </xsl:template>
</xsl:stylesheet>
