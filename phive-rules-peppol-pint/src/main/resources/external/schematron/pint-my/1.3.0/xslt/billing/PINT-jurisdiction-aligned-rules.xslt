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
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M12" priority="1009">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:peppol:pint:billing-1@my-1')" />
      <xsl:otherwise>
        <svrl:failed-assert test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:peppol:pint:billing-1@my-1')">
          <xsl:attribute name="id">aligned-ibrp-001-my</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-001-my]-Specification identifier (ibt-024) MUST start with the value 'urn:peppol:pint:billing-1@my-1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/*/cbc:ProfileID and matches(normalize-space(/*/cbc:ProfileID), 'urn:peppol:bis:billing')" />
      <xsl:otherwise>
        <svrl:failed-assert test="/*/cbc:ProfileID and matches(normalize-space(/*/cbc:ProfileID), 'urn:peppol:bis:billing')">
          <xsl:attribute name="id">aligned-ibrp-002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-002]-Business process (ibt-023) MUST be in the format 'urn:peppol:bis:billing'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID)">
          <xsl:attribute name="id">ibr-02-my</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-02-my]-An Invoice shall have the Supplier’s BRN Number  (ibt-030).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID)">
          <xsl:attribute name="id">ibr-03-my</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-03-my]-An Invoice shall have the Buyer's BRN Number  (ibt-047).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID != 'VAT']/cbc:CompanyID) or exists(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[not(@schemeID)])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID != 'VAT']/cbc:CompanyID) or exists(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[not(@schemeID)])">
          <xsl:attribute name="id">ibr-04-my</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-04-my]-An Invoice shall have the Supplier’s TIN (ibt-032).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxSubtotal" mode="M12" priority="1008">
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
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) or exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='AAL'][normalize-space(cbc:ID)='TTX'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID) or exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='AAL'][normalize-space(cbc:ID)='TTX'])">
          <xsl:attribute name="id">aligned-ibrp-047</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-047]-Each tax breakdown (ibg-23) MUST be defined through a tax category code (ibt-118). VAT subtotals need a code; AAL subtotals must use code 'TTX'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT' and (cbc:Percent or normalize-space(cbc:ID)='O')])) or (exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='AAL' and normalize-space(cbc:ID)='TTX' and not(cbc:Percent)]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT' and (cbc:Percent or normalize-space(cbc:ID)='O')])) or (exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='AAL' and normalize-space(cbc:ID)='TTX' and not(cbc:Percent)]))">
          <xsl:attribute name="id">aligned-ibrp-048</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-048]-VAT subtotals MUST have a tax rate (ibt-119) except when ID='O'. AAL/TTX subtotals MUST NOT contain a tax rate.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'SA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1007">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'SA'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in xs:decimal((cbc:Percent, 0)[1]) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'SA'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='SA'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='SA'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='SA'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='SA'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'SA'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='SA'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='SA'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='SA'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='SA'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in xs:decimal((cbc:Percent, 0)[1]) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'SA'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='SA'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='SA'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='SA'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='SA'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'SA'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='SA'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='SA'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='SA'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='SA'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))))">
          <xsl:attribute name="id">aligned-ibrp-sa-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-sa-08]-For each different value of tax category rate (ibt-119) where the tax category code (ibt-118) is "SA", the tax category taxable amount (ibt-116) in a tax breakdown (ibg-23) MUST equal the sum of Invoice line net amounts (ibt-131) plus the sum of document level charge amounts (ibt-99) minus the sum of document level allowance amounts (ibt-92) where the tax category code (ibt-151, ibt-102, ibt-95) is "SA" and the tax rate (ibt-152, ibt-103, ibt-96) equals the tax category rate (ibt-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal((cbc:Percent, 0)[1]) div 100)) * 10 * 10) div 100 ,0.02 )" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal((cbc:Percent, 0)[1]) div 100)) * 10 * 10) div 100 ,0.02 )">
          <xsl:attribute name="id">aligned-ibrp-sa-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-sa-09]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where tax category code (ibt-118) is "SA" MUST equal the tax category taxable amount (ibt-116) multiplied by the tax category rate (ibt-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">aligned-ibrp-sa-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-sa-10]-A tax breakdown (ibg-23) with tax Category code (ibt-118) "SA" MUST not have a tax exemption reason code (ibt-121) or tax exemption reason text (ibt-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'SE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1006">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'SE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in xs:decimal((cbc:Percent, 0)[1]) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'SE'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='SE'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='SE'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='SE'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='SE'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'SE'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='SE'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='SE'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='SE'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='SE'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in xs:decimal((cbc:Percent, 0)[1]) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'SE'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='SE'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='SE'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='SE'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='SE'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'SE'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='SE'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='SE'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='SE'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='SE'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))))">
          <xsl:attribute name="id">aligned-ibrp-se-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-se-08]-For each different value of tax category rate (ibt-119) where the tax category code (ibt-118) is "SE", the tax category taxable amount (ibt-116) in a tax breakdown (ibg-23) MUST equal the sum of Invoice line net amounts (ibt-131) plus the sum of document level charge amounts (ibt-99) minus the sum of document level allowance amounts (ibt-92) where the tax category code (ibt-151, ibt-102, ibt-95) is "SE" and the tax rate (ibt-152, ibt-103, ibt-96) equals the tax category rate (ibt-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal((cbc:Percent, 0)[1]) div 100)) * 10 * 10) div 100 ,0.02 )" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal((cbc:Percent, 0)[1]) div 100)) * 10 * 10) div 100 ,0.02 )">
          <xsl:attribute name="id">aligned-ibrp-se-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-se-09]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where tax category code (ibt-118) is "SE" MUST equal the tax category taxable amount (ibt-116) multiplied by the tax category rate (ibt-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">aligned-ibrp-se-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-se-10]-A tax breakdown (ibg-23) with tax Category code (ibt-118) "SE" MUST not have a tax exemption reason code (ibt-121) or tax exemption reason text (ibt-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'HVG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1005">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'HVG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in xs:decimal((cbc:Percent, 0)[1]) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'HVG'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='HVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='HVG'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='HVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='HVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'HVG'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='HVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='HVG'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='HVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='HVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in xs:decimal((cbc:Percent, 0)[1]) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'HVG'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='HVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='HVG'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='HVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='HVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'HVG'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='HVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='HVG'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='HVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='HVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))))">
          <xsl:attribute name="id">aligned-ibrp-hvg-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-hvg-08]-For each different value of tax category rate (ibt-119) where the tax category code (ibt-118) is "HVG", the tax category taxable amount (ibt-116) in a tax breakdown (ibg-23) MUST equal the sum of Invoice line net amounts (ibt-131) plus the sum of document level charge amounts (ibt-99) minus the sum of document level allowance amounts (ibt-92) where the tax category code (ibt-151, ibt-102, ibt-95) is "HVG" and the tax rate (ibt-152, ibt-103, ibt-96) equals the tax category rate (ibt-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal((cbc:Percent, 0)[1]) div 100)) * 10 * 10) div 100 ,0.02 )" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal((cbc:Percent, 0)[1]) div 100)) * 10 * 10) div 100 ,0.02 )">
          <xsl:attribute name="id">aligned-ibrp-hvg-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-hvg-09]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where tax category code (ibt-118) is "HVG" MUST equal the tax category taxable amount (ibt-116) multiplied by the tax category rate (ibt-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">aligned-ibrp-hvg-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-hvg-10]-A tax breakdown (ibg-23) with tax Category code (ibt-118) "HVG" MUST not have a tax exemption reason code (ibt-121) or tax exemption reason text (ibt-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'LVG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1004">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'LVG'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in xs:decimal((cbc:Percent, 0)[1]) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'LVG'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='LVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='LVG'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='LVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='LVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'LVG'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='LVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='LVG'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='LVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='LVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in xs:decimal((cbc:Percent, 0)[1]) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'LVG'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='LVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='LVG'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='LVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='LVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'LVG'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='LVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='LVG'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal((cbc:Percent, 0)[1]) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='LVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='LVG'][cac:TaxCategory/xs:decimal((cbc:Percent, 0)[1]) = $rate]/xs:decimal(cbc:Amount)),0.02))))">
          <xsl:attribute name="id">aligned-ibrp-lvg-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-lvg-08]-For each different value of tax category rate (ibt-119) where the tax category code (ibt-118) is "LVG", the tax category taxable amount (ibt-116) in a tax breakdown (ibg-23) MUST equal the sum of Invoice line net amounts (ibt-131) plus the sum of document level charge amounts (ibt-99) minus the sum of document level allowance amounts (ibt-92) where the tax category code (ibt-151, ibt-102, ibt-95) is "LVG" and the tax rate (ibt-152, ibt-103, ibt-96) equals the tax category rate (ibt-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal((cbc:Percent, 0)[1]) div 100)) * 10 * 10) div 100 ,0.02 )" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal((cbc:Percent, 0)[1]) div 100)) * 10 * 10) div 100 ,0.02 )">
          <xsl:attribute name="id">aligned-ibrp-lvg-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-lvg-09]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where tax category code (ibt-118) is "LVG" MUST equal the tax category taxable amount (ibt-116) multiplied by the tax category rate (ibt-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">aligned-ibrp-lvg-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-lvg-10]-A tax breakdown (ibg-23) with tax Category code (ibt-118) "LVG" MUST not have a tax exemption reason code (ibt-121) or tax exemption reason text (ibt-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='TTX'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='AAL']" mode="M12" priority="1003">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID)='TTX'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='AAL']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Percent)">
          <xsl:attribute name="id">aligned-ibrp-ttx-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-ttx-08] – Tourism Tax (TTX/AAL) MUST NOT include a tax percentage.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine)               and u:slack(                     abs(xs:decimal(../cbc:TaxAmount)),                     sum(../../../cac:InvoiceLine                           [cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='TTX']                           /cac:TaxTotal/xs:decimal(cbc:TaxAmount))                     + sum(../../../cac:AllowanceCharge                           [cbc:ChargeIndicator=true()]                           [cac:TaxCategory/normalize-space(cbc:ID)='TTX']                           /xs:decimal(cbc:Amount))                     - sum(../../../cac:AllowanceCharge                           [cbc:ChargeIndicator=false()]                           [cac:TaxCategory/normalize-space(cbc:ID)='TTX']                           /xs:decimal(cbc:Amount)),                     0.02                  )           )           or           (exists(//cac:CreditNoteLine)               and u:slack(                     abs(xs:decimal(../cbc:TaxAmount)),                     sum(../../../cac:CreditNoteLine                           [cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='TTX']                           /cac:TaxTotal/xs:decimal(cbc:TaxAmount))                     + sum(../../../cac:AllowanceCharge                           [cbc:ChargeIndicator=true()]                           [cac:TaxCategory/normalize-space(cbc:ID)='TTX']                           /xs:decimal(cbc:Amount))                     - sum(../../../cac:AllowanceCharge                           [cbc:ChargeIndicator=false()]                           [cac:TaxCategory/normalize-space(cbc:ID)='TTX']                           /xs:decimal(cbc:Amount)),                     0.02                  )           )" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and u:slack( abs(xs:decimal(../cbc:TaxAmount)), sum(../../../cac:InvoiceLine [cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='TTX'] /cac:TaxTotal/xs:decimal(cbc:TaxAmount)) + sum(../../../cac:AllowanceCharge [cbc:ChargeIndicator=true()] [cac:TaxCategory/normalize-space(cbc:ID)='TTX'] /xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge [cbc:ChargeIndicator=false()] [cac:TaxCategory/normalize-space(cbc:ID)='TTX'] /xs:decimal(cbc:Amount)), 0.02 ) ) or (exists(//cac:CreditNoteLine) and u:slack( abs(xs:decimal(../cbc:TaxAmount)), sum(../../../cac:CreditNoteLine [cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='TTX'] /cac:TaxTotal/xs:decimal(cbc:TaxAmount)) + sum(../../../cac:AllowanceCharge [cbc:ChargeIndicator=true()] [cac:TaxCategory/normalize-space(cbc:ID)='TTX'] /xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge [cbc:ChargeIndicator=false()] [cac:TaxCategory/normalize-space(cbc:ID)='TTX'] /xs:decimal(cbc:Amount)), 0.02 ) )">
          <xsl:attribute name="id">aligned-ibrp-ttx-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
    [aligned-ibrp-ttx-09] – Tourism Tax (TTX/AAL) amount MUST equal the sum of line-level TTX tax amounts and TTX amounts on document-level allowances/charges.
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1002">
    <svrl:fired-rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">aligned-ibrp-e-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-08]-In a tax breakdown (ibg-23) where the tax category code (ibt-118) is "Exempt from tax" the tax category taxable amount (ibt-116) MUST equal the sum of Invoice line net amounts (ibt-131) minus the sum of Document level allowance amounts (ibt-92) plus the sum of Document level charge amounts (ibt-99) where the tax category codes (ibt-151, ibt-95, ibt-102) are "Exempt from tax".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

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
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1001">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal((cbc:Percent, 0)[1]) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal((cbc:Percent, 0)[1]) = 0)">
          <xsl:attribute name="id">aligned-ibrp-e-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-05]-In an Invoice line (ibg-25) where the Invoiced item tax category code (ibt-151) is "Exempt from tax", the Invoiced item tax rate (ibt-152) MUST be 0 (zero). </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1000">
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
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

<!--PATTERN Codesmodelaligned-->


	<!--RULE -->
<xsl:template match="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID" mode="M13" priority="1001">
    <svrl:fired-rule context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' SA SE HVG LVG E O TTX ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' SA SE HVG LVG E O TTX ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">aligned-ibrp-cl-01-my</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-cl-01-my]-Malaysian invoice tax categories MUST be coded using Malaysian codes.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:TaxCurrencyCode" mode="M13" priority="1000">
    <svrl:fired-rule context="cbc:TaxCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' MYR ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' MYR ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">ibr-cl-05-my</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-cl-05-my]-If Tax accounting currency (ibt-006) is present, it shall be coded using MYR in ISO code list of 4217.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="*" />
  </xsl:template>
</xsl:stylesheet>
