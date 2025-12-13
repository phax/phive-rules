<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:u="utils" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:udt="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
<xsl:function as="xs:boolean" name="u:slack">
    <xsl:param as="xs:decimal" name="exp" />
    <xsl:param as="xs:decimal" name="val" />
    <xsl:param as="xs:decimal" name="slack" />
    <xsl:value-of select="xs:decimal($exp + $slack) >= $val and xs:decimal($exp - $slack) &lt;= $val" />
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
    <svrl:schematron-output schemaVersion="" title="">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2" />
      <svrl:ns-prefix-in-attribute-values prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
      <svrl:ns-prefix-in-attribute-values prefix="u" uri="utils" />
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">UBL-modelaligned</xsl:attribute>
        <xsl:attribute name="name">UBL-modelaligned</xsl:attribute>
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
        <xsl:attribute name="id">Codesmodelaligned</xsl:attribute>
        <xsl:attribute name="name">Codesmodelaligned</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M13" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->


<!--PATTERN UBL-modelaligned-->


	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" mode="M12" priority="1024">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID = 'O') and not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent))) or (exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) and exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID = 'O') and not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent))) or (exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) and exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent))">
          <xsl:attribute name="id">aligned-ibrp-032-jp</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-032jp]-Each Document level allowance (ibg-20) MUST have a Document level allowance tax category code (ibt-095) and Document level allowance tax rate (ibt-096), except if the allowance is outside the scope of tax.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" mode="M12" priority="1023">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID = 'O') and not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent))) or (exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) and exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID = 'O') and not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent))) or (exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) and exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent))">
          <xsl:attribute name="id">aligned-ibrp-037-jp</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-037-jp]-Each Document level charge (ibg-21) MUST have a Document level charge tax category code (ibt-102) and Document level charge tax rate (ibt-103), except if the charge is outside the scope of tax.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:InvoiceLine | /cn:CreditNoteLine" mode="M12" priority="1022">
    <svrl:fired-rule context="/ubl:InvoiceLine | /cn:CreditNoteLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID) and (cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID) and (cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:Percent)">
          <xsl:attribute name="id">aligned-ibrp-050-jp</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-050-jp]-Each Invoice line (ibg-25) MUST be categorized with an Invoiced item tax category code (ibt-151) and Invoiced item tax rate (ibt-152).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M12" priority="1021">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:fdc:peppol:jp:billing:3.0') or starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:peppol:pint:billing-1@jp-1')" />
      <xsl:otherwise>
        <svrl:failed-assert test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:fdc:peppol:jp:billing:3.0') or starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:peppol:pint:billing-1@jp-1')">
          <xsl:attribute name="id">aligned-ibrp-001-jp</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-001-jp]-Specification identifier MUST start with the value 'urn:fdc:peppol:jp:billing:3.0' or 'urn:peppol:pint:billing-1@jp-1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/*/cbc:ProfileID and (matches(normalize-space(/*/cbc:ProfileID), 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0') or matches(normalize-space(/*/cbc:ProfileID), 'urn:peppol:bis:billing'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="/*/cbc:ProfileID and (matches(normalize-space(/*/cbc:ProfileID), 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0') or matches(normalize-space(/*/cbc:ProfileID), 'urn:peppol:bis:billing'))">
          <xsl:attribute name="id">aligned-ibrp-002-jp</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-002-jp]-Business process MUST be in the format 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0' or 'urn:peppol:bis:billing'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='VAT']/cbc:CompanyID) &lt;= 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='VAT']/cbc:CompanyID) &lt;= 1)">
          <xsl:attribute name="id">aligned-ibrp-009</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-009]-Seller tax identifier (ibt-031) MUST occur maximum once.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(//cbc:PaymentID[not(preceding::cbc:PaymentID/. = .)]) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(//cbc:PaymentID[not(preceding::cbc:PaymentID/. = .)]) &lt;= 1">
          <xsl:attribute name="id">aligned-ibrp-014</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-014]-Remittance information (ibt-083) MUST occur maximum once.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(//cac:InvoicePeriod)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(//cac:InvoicePeriod)">
          <xsl:attribute name="id">aligned-ibrp-052</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-052]-An Invoice MUST have an invoice period (ibg-14) or an Invoice line period (ibg-26).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']))">
          <xsl:attribute name="id">aligned-ibrp-e-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the tax category code (ibt-151, ibt-95 or ibt-102) is "Exempt from tax" MUST contain exactly one tax breakdown (ibg-23) with the tax category code (ibt-118) equal to "Exempt from tax".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']))">
          <xsl:attribute name="id">aligned-ibrp-g-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-g-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the tax category code (ibt-151, ibt-95 or ibt-102) is "Export" MUST contain in the tax breakdown (ibg-23) exactly one tax category code (ibt-118) equal with "Export".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))">
          <xsl:attribute name="id">aligned-ibrp-o-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the tax category code (ibt-151, ibt-95 or ibt-102) is "Not subject to tax" MUST contain exactly one tax breakdown group (ibg-23) with the tax category code (ibt-118) equal to "Not subject to tax".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='VAT']/cbc:CompanyID) &lt;= 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='VAT']/cbc:CompanyID) &lt;= 1)">
          <xsl:attribute name="id">aligned-ibrp-sr-12</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-sr-12]-Seller VAT identifier (ibt-031) MUST occur maximum once</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)!='VAT']/cbc:CompanyID) &lt;= 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)!='VAT']/cbc:CompanyID) &lt;= 1)">
          <xsl:attribute name="id">aligned-ibrp-sr-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-sr-13]-Seller tax registration (ibt-032) MUST occur maximum once</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)">
          <xsl:attribute name="id">aligned-ibr-jp-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibr-jp-04]-An Invoice shall have the Seller tax identifier (ibt-031).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cbc:TaxCurrencyCode)) or cbc:TaxCurrencyCode = 'JPY'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cbc:TaxCurrencyCode)) or cbc:TaxCurrencyCode = 'JPY'">
          <xsl:attribute name="id">aligned-ibr-jp-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibr-jp-05]-If Tax accounting currency (ibt-006) is present, it shall be coded using JPY in ISO code list of 4217 a-3.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(cac:TaxTotal/cbc:TaxAmount[@currencyID=/*/cbc:DocumentCurrencyCode])) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(cac:TaxTotal/cbc:TaxAmount[@currencyID=/*/cbc:DocumentCurrencyCode])) &lt;= 1">
          <xsl:attribute name="id">aligned-ibrp-053-jp</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-053-jp]-Only one Invoice total tax amount may be present in the document currency (ibt-110).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxSubtotal[cbc:TaxAmount/@currencyID=/ubl:Invoice/cbc:DocumentCurrencyCode/text()]" mode="M12" priority="1020">
    <svrl:fired-rule context="cac:TaxSubtotal[cbc:TaxAmount/@currencyID=/ubl:Invoice/cbc:DocumentCurrencyCode/text()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxableAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxableAmount)">
          <xsl:attribute name="id">aligned-ibrp-045</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-045]-Each tax breakdown (ibg-23) MUST have a tax category taxable amount (ibt-116).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((cac:TaxCategory/normalize-space(upper-case(cbc:ID)) != 'O') and ((round(cac:TaxCategory/xs:decimal(cbc:Percent)) != 0 and ( xs:decimal(cbc:TaxAmount) >= floor(xs:decimal(cbc:TaxableAmount) * (cac:TaxCategory/xs:decimal(cbc:Percent) div 100))) and ( xs:decimal(cbc:TaxAmount) &lt;= ceiling(xs:decimal(cbc:TaxableAmount) * (cac:TaxCategory/xs:decimal(cbc:Percent) div 100)))) or (round(cac:TaxCategory/xs:decimal(cbc:Percent)) = 0 and (xs:decimal(cbc:TaxAmount) = 0)))) or (not(cac:TaxCategory/cbc:Percent) and (cac:TaxCategory/normalize-space(upper-case(cbc:ID)) = 'O') and  (xs:decimal(cbc:TaxAmount) = 0))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((cac:TaxCategory/normalize-space(upper-case(cbc:ID)) != 'O') and ((round(cac:TaxCategory/xs:decimal(cbc:Percent)) != 0 and ( xs:decimal(cbc:TaxAmount) >= floor(xs:decimal(cbc:TaxableAmount) * (cac:TaxCategory/xs:decimal(cbc:Percent) div 100))) and ( xs:decimal(cbc:TaxAmount) &lt;= ceiling(xs:decimal(cbc:TaxableAmount) * (cac:TaxCategory/xs:decimal(cbc:Percent) div 100)))) or (round(cac:TaxCategory/xs:decimal(cbc:Percent)) = 0 and (xs:decimal(cbc:TaxAmount) = 0)))) or (not(cac:TaxCategory/cbc:Percent) and (cac:TaxCategory/normalize-space(upper-case(cbc:ID)) = 'O') and (xs:decimal(cbc:TaxAmount) = 0))">
          <xsl:attribute name="id">aligned-ibrp-051-jp</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-051-jp]-Tax category tax amount (ibt-117) = tax category taxable amount (ibt-116) x (tax category rate (ibt-119) / 100), rounded to integer. The rounded result amount shall be between the floor and the ceiling.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxSubtotal" mode="M12" priority="1019">
    <svrl:fired-rule context="cac:TaxSubtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxAmount)">
          <xsl:attribute name="id">aligned-ibrp-046</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-046]-Each tax breakdown (ibg-23) MUST have a tax category tax amount (ibt-117).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">
          <xsl:attribute name="id">aligned-ibrp-047</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-047]-Each tax breakdown (ibg-23) MUST be defined through a tax category code (ibt-118).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O')" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O')">
          <xsl:attribute name="id">aligned-ibrp-048</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-048]-Each tax breakdown (ibg-23) MUST have a tax category rate (ibt-119), except if the Invoice is not subject to tax.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(contains(cbc:TaxAmount[@currencyID='JPY'], '.'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(contains(cbc:TaxAmount[@currencyID='JPY'], '.'))">
          <xsl:attribute name="id">aligned-ibr-jp-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibr-jp-06]-Tax category tax amount (ibt-117) with currency code JPY and tax category tax amount in accounting currency (ibt-190) shall not have decimal.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxRepresentativeParty" mode="M12" priority="1018">
    <svrl:fired-rule context="cac:TaxRepresentativeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(cac:PartyTaxScheme/cbc:CompanyID) &lt;= 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(cac:PartyTaxScheme/cbc:CompanyID) &lt;= 1)">
          <xsl:attribute name="id">aligned-ibrp-010</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-010]-Seller tax representative tax identifier (ibt-063) MUST occur maximum once, if the Seller has a tax representative (ibg-11).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount" mode="M12" priority="1017">
    <svrl:fired-rule context="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:ID) != ''">
          <xsl:attribute name="id">aligned-ibrp-016</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-016]-A Payment account identifier (ibt-84) MUST be present if Credit transfer (ibg-17) information is provided in the invoice.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans/cac:CardAccount" mode="M12" priority="1016">
    <svrl:fired-rule context="cac:PaymentMeans/cac:CardAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(cbc:PrimaryAccountNumberID)>=4 and string-length(cbc:PrimaryAccountNumberID)&lt;=6" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(cbc:PrimaryAccountNumberID)>=4 and string-length(cbc:PrimaryAccountNumberID)&lt;=6">
          <xsl:attribute name="id">aligned-ibrp-017</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-017]-The last 4 to 6 digits of the Payment card primary account number (ibt-87) MUST be present if Payment card information (ibg-18) is provided in the Invoice.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans" mode="M12" priority="1015">
    <svrl:fired-rule context="cac:PaymentMeans" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:PaymentMeansCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:PaymentMeansCode)">
          <xsl:attribute name="id">aligned-ibrp-049</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-049]-A Payment instruction (ibg-16) MUST specify the Payment means type code (ibt-81).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans[(cbc:PaymentMeansCode='49' or cbc:PaymentMeansCode='59')]" mode="M12" priority="1014">
    <svrl:fired-rule context="cac:PaymentMeans[(cbc:PaymentMeansCode='49' or cbc:PaymentMeansCode='59')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PaymentMandate/cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PaymentMandate/cbc:ID">
          <xsl:attribute name="id">aligned-ibrp-019</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-019]-Mandate reference (ibt-089) MUST be provided for direct debit.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1013">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-e-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-05]-In an Invoice line (ibg-25) where the Invoiced item tax category code (ibt-151) is "Exempt from tax", the Invoiced item tax rate (ibt-152) MUST be 0 (zero). </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1012">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-e-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-06]-In a Document level allowance (ibg-20) where the Document level allowance tax category code (ibt-95) is "Exempt from tax", the Document level allowance tax rate (ibt-96) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1011">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-e-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-07]-In a Document level charge (ibg-21) where the Document level charge tax category code (ibt-102) is "Exempt from tax", the Document level charge tax rate (ibt-103) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1010">
    <svrl:fired-rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">aligned-ibrp-e-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-09]-The tax category tax amount (ibt-117) In a tax breakdown (ibg-23) where the tax category code (ibt-118) equals "Exempt from tax" MUST equal 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1009">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-g-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-g-05]-In an Invoice line (ibg-25) where the Invoiced item tax category code (ibt-151) is "Export" the Invoiced item tax rate (ibt-152) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1008">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-g-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-g-06]-In a Document level allowance (ibg-20) where the Document level allowance tax category code (ibt-95) is "Export" the Document level allowance tax rate (ibt-96) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1007">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-g-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-g-07]-In a Document level charge (ibg-21) where the Document level charge tax category code (ibt-102) is "Export" the Document level charge tax rate (ibt-103) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1006">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">aligned-ibrp-g-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-g-09]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where the tax category code (ibt-118) is "Export" MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1005">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Percent)">
          <xsl:attribute name="id">aligned-ibrp-o-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-05]-An Invoice line (ibg-25) where the tax category code (ibt-151) is "Not subject to tax" MUST not contain an Invoiced item tax rate (ibt-152).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1004">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Percent)">
          <xsl:attribute name="id">aligned-ibrp-o-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-06]-A Document level allowance (ibg-20) where tax category code (ibt-95) is "Not subject to tax" MUST not contain a Document level allowance tax rate (ibt-96).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1003">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Percent)">
          <xsl:attribute name="id">aligned-ibrp-o-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-07]-A Document level charge (ibg-21) where the tax category code (ibt-102) is "Not subject to tax" MUST not contain a Document level charge tax rate (ibt-103).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1002">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">aligned-ibrp-o-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-09]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where the tax category code (ibt-118) is "Not subject to tax" MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1001">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(((//cbc:StartDate >= '2023-10-01') or (//cbc:EndDate >= '2023-10-01'))  and matches(normalize-space(cbc:CompanyID),'^T[0-9]{13}$')) or not((//cbc:StartDate >= '2023-10-01') or (//cbc:EndDate >= '2023-10-01'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(((//cbc:StartDate >= '2023-10-01') or (//cbc:EndDate >= '2023-10-01')) and matches(normalize-space(cbc:CompanyID),'^T[0-9]{13}$')) or not((//cbc:StartDate >= '2023-10-01') or (//cbc:EndDate >= '2023-10-01'))">
          <xsl:attribute name="id">aligned-ibr-jp-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibr-jp-01]-If a date of an invoice period (ibg-14) or an invoice line period (ibg-26) is on and after October 1st 2023, Seller Tax Identifier shall be coded by using a Registration Number for Qualified Invoice purpose in Japan, which consists of 14 digits that start with T.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxCategory/cac:TaxScheme/cbc:ID | cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID" mode="M12" priority="1000">
    <svrl:fired-rule context="cac:TaxCategory/cac:TaxScheme/cbc:ID | cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(.),'VAT')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(.),'VAT')">
          <xsl:attribute name="id">aligned-ibr-jp-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibr-jp-03]-Tax scheme shall use VAT from UNECE 5153 code list. VAT means Consumption Tax in Japan.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

<!--PATTERN Codesmodelaligned-->


	<!--RULE -->
<xsl:template match="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID" mode="M13" priority="1001">
    <svrl:fired-rule context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AA E S G O ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AA E S G O ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">aligned-ibrp-cl-01-jp</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-cl-01-jp]-Japanese invoice tax categories MUST be coded using UNCL5305 code list.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:InvoiceTypeCode" mode="M13" priority="1000">
    <svrl:fired-rule context="cbc:InvoiceTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="self::cbc:InvoiceTypeCode and (not(contains(normalize-space(.), ' ')) and contains(' 380 ', concat(' ', normalize-space(.), ' ')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="self::cbc:InvoiceTypeCode and (not(contains(normalize-space(.), ' ')) and contains(' 380 ', concat(' ', normalize-space(.), ' ')))">
          <xsl:attribute name="id">aligned-ibrp-cl-02-jp</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-cl-02-jp]-The document type code  (ibt-003) MUST be 380.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
