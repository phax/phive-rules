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
        <xsl:attribute name="id">UBL-modelaligned</xsl:attribute>
        <xsl:attribute name="name">UBL-modelaligned</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M14" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">Codesmodelaligned</xsl:attribute>
        <xsl:attribute name="name">Codesmodelaligned</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M15" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<xsl:param name="supplierCountry" select="       if  (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then             upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))           else             'XX'" />
  <xsl:param name="buyerCountry" select="   if (/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then   upper-case(normalize-space(/*/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))   else   'XX'" />

<!--PATTERN UBL-modelaligned-->


	<!--RULE -->
<xsl:template match="cac:AdditionalDocumentReference" mode="M14" priority="1030">
    <svrl:fired-rule context="cac:AdditionalDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((cbc:DocumentTypeCode='130') or ((local-name(/*) = 'CreditNote') and (cbc:DocumentTypeCode='50')) or (not(cbc:ID/@schemeID) and not(cbc:DocumentTypeCode)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((cbc:DocumentTypeCode='130') or ((local-name(/*) = 'CreditNote') and (cbc:DocumentTypeCode='50')) or (not(cbc:ID/@schemeID) and not(cbc:DocumentTypeCode)))">
          <xsl:attribute name="id">aligned-ibrp-sr-43</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-sr-43]-Scheme identifier shall only be used for invoiced object (ibt-018) (document type code with value 130)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Price/cac:AllowanceCharge" mode="M14" priority="1029">
    <svrl:fired-rule context="cac:Price/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)">
          <xsl:attribute name="id">aligned-ibrp-004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-004]-Item net price (ibt-146) MUST equal (Gross price (ibt-148) - Price discount (ibt-147)) when gross price is provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = false()]" mode="M14" priority="1028">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator = false()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)">
          <xsl:attribute name="id">aligned-ibrp-054</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-054]-Allowance amount (ibt-092, ibt-136) must equal base amount (ibt-093, ibt-137) * percentage (ibt-194, ibt-138) /100 if base amount and percentage exists.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID) or not(parent::ubl:Invoice|parent::cn:CreditNote)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID) or not(parent::ubl:Invoice|parent::cn:CreditNote)">
          <xsl:attribute name="id">aligned-ibrp-032-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-032-aunz]-Each Document level allowance (ibg-20) MUST have a Document level allowance tax category code (ibt-095).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:MultiplierFactorNumeric or cbc:BaseAmount) or (cbc:MultiplierFactorNumeric and cbc:BaseAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:MultiplierFactorNumeric or cbc:BaseAmount) or (cbc:MultiplierFactorNumeric and cbc:BaseAmount)">
          <xsl:attribute name="id">aligned-ibrp-057</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-057]-Either both or neither Allowance base amount (ibt-093) and percentage (ibt-094) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = true()]" mode="M14" priority="1027">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator = true()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)">
          <xsl:attribute name="id">aligned-ibrp-055</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-055]-Charge amount (ibt-099, ibt-141) must equal base amount (ibt-100, ibt-142) * percentage (ibt-101, ibt-143) /100 if base amount and percentage exists.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID) or not(parent::ubl:Invoice|parent::cn:CreditNote)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID) or not(parent::ubl:Invoice|parent::cn:CreditNote)">
          <xsl:attribute name="id">aligned-ibrp-037-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-037-aunz]-Each Document level charge (ibg-21) MUST have a Document level charge tax category code (ibt-102).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:MultiplierFactorNumeric or cbc:BaseAmount) or (cbc:MultiplierFactorNumeric and cbc:BaseAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:MultiplierFactorNumeric or cbc:BaseAmount) or (cbc:MultiplierFactorNumeric and cbc:BaseAmount)">
          <xsl:attribute name="id">aligned-ibrp-058</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-058]-Either both or neither Charge base amount (ibt-100) and percentage (ibt-101) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M14" priority="1026">
    <svrl:fired-rule context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='GST')]/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='GST')]/cbc:ID)">
          <xsl:attribute name="id">aligned-ibrp-050-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-050-aunz]-Each Invoice line (ibg-25) MUST be categorized with an Invoiced item tax category code (ibt-151).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:Price/cbc:BaseQuantity) and u:slack(xs:decimal(cbc:LineExtensionAmount), xs:decimal(((cbc:InvoicedQuantity|cbc:CreditedQuantity) * (cac:Price/cbc:PriceAmount div cac:Price/cbc:BaseQuantity)) + sum(cac:AllowanceCharge[cbc:ChargeIndicator = true()]/cbc:Amount) - sum(cac:AllowanceCharge[cbc:ChargeIndicator = false()]/cbc:Amount)), 0.02)) or (not(exists(cac:Price/cbc:BaseQuantity)) and u:slack(xs:decimal(cbc:LineExtensionAmount), xs:decimal(((cbc:InvoicedQuantity|cbc:CreditedQuantity) * cac:Price/cbc:PriceAmount) + sum(cac:AllowanceCharge[cbc:ChargeIndicator = true()]/cbc:Amount) - sum(cac:AllowanceCharge[cbc:ChargeIndicator = false()]/cbc:Amount)), 0.02))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:Price/cbc:BaseQuantity) and u:slack(xs:decimal(cbc:LineExtensionAmount), xs:decimal(((cbc:InvoicedQuantity|cbc:CreditedQuantity) * (cac:Price/cbc:PriceAmount div cac:Price/cbc:BaseQuantity)) + sum(cac:AllowanceCharge[cbc:ChargeIndicator = true()]/cbc:Amount) - sum(cac:AllowanceCharge[cbc:ChargeIndicator = false()]/cbc:Amount)), 0.02)) or (not(exists(cac:Price/cbc:BaseQuantity)) and u:slack(xs:decimal(cbc:LineExtensionAmount), xs:decimal(((cbc:InvoicedQuantity|cbc:CreditedQuantity) * cac:Price/cbc:PriceAmount) + sum(cac:AllowanceCharge[cbc:ChargeIndicator = true()]/cbc:Amount) - sum(cac:AllowanceCharge[cbc:ChargeIndicator = false()]/cbc:Amount)), 0.02))">
          <xsl:attribute name="id">aligned-ibrp-053</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-053]-Invoice line net amount (ibt-131) MUST equal (Invoiced quantity (ibt-129) * (Item net price (ibt-146)/item price base quantity (ibt-149)) + Sum of invoice line charge amount (ibt-141) - sum of invoice line allowance amount (ibt-136).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(cac:Item/cac:ClassifiedTaxCategory) = 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(cac:Item/cac:ClassifiedTaxCategory) = 1)">
          <xsl:attribute name="id">aligned-ibrp-059</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-059]-Invoice lines (ibg-25) MUST have one and only one classified tax category (ibt-151).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:DocumentReference) or (cac:DocumentReference/cbc:DocumentTypeCode='130')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:DocumentReference) or (cac:DocumentReference/cbc:DocumentTypeCode='130')">
          <xsl:attribute name="id">aligned-ibrp-060</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-060]-Line Document reference can only be used for Invoice line object (ibg-36)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M14" priority="1025">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:peppol:pint:selfbilling-1@aunz-1')" />
      <xsl:otherwise>
        <svrl:failed-assert test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:peppol:pint:selfbilling-1@aunz-1')">
          <xsl:attribute name="id">aligned-ibrp-001-aunz-sb</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-001-aunz-sb]-Specification identifier (ibt-024) MUST start with the value 'urn:peppol:pint:selfbilling-1@aunz-1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/*/cbc:ProfileID and matches(normalize-space(/*/cbc:ProfileID), 'urn:peppol:bis:selfbilling')" />
      <xsl:otherwise>
        <svrl:failed-assert test="/*/cbc:ProfileID and matches(normalize-space(/*/cbc:ProfileID), 'urn:peppol:bis:selfbilling')">
          <xsl:attribute name="id">aligned-ibrp-002-aunz-sb</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-002-aunz-sb]-Business process (ibt-023) MUST be in the format 'urn:peppol:bis:selfbilling'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:BuyerReference or cac:OrderReference/cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:BuyerReference or cac:OrderReference/cbc:ID">
          <xsl:attribute name="id">aligned-ibrp-003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-003]-A buyer reference (ibt-010) or purchase order reference (ibt-013) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and exists(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and exists(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode))">
          <xsl:attribute name="id">aligned-ibrp-006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-006]-Tax point date (ibt-007) and tax point date code (ibt-008) are mutually exclusive.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(cac:PaymentTerms) &lt;= 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(cac:PaymentTerms) &lt;= 1)">
          <xsl:attribute name="id">aligned-ibrp-008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-008]-Invoice terms (ibg-033) MUST occur maximum once.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:TaxTotal[cac:TaxSubtotal]) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:TaxTotal[cac:TaxSubtotal]) = 1">
          <xsl:attribute name="id">aligned-ibrp-021</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-021]-Only one tax total (ibg-38) with tax subtotals (ibg-23) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0)">
          <xsl:attribute name="id">aligned-ibrp-022</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-022]-Only one tax total without tax subtotals (ibg-37)  MUST be provided when tax currency code (ibt-006) is provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'E']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'E']))">
          <xsl:attribute name="id">aligned-ibrp-e-01-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-01-aunz]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the tax category code (ibt-151, ibt-095 or ibt-102) is "Exempt from tax" MUST contain exactly one tax breakdown (ibg-23) with the tax category code (ibt-118) equal to "Exempt from tax".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'G']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'G'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'G']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'G']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'G']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'G']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'G'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'G']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'G']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'G']))">
          <xsl:attribute name="id">aligned-ibrp-g-01-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-g-01-aunz]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the tax category code (ibt-151, ibt-095 or ibt-102) is "Export" MUST contain in the tax breakdown (ibg-23) exactly one tax category code (ibt-118) equal with "Export".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']))">
          <xsl:attribute name="id">aligned-ibrp-o-01-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-01-aunz]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the tax category code (ibt-151, ibt-095 or ibt-102) is "Not subject to tax" MUST contain exactly one tax breakdown group (ibg-23) with the tax category code (ibt-118) equal to "Not subject to tax".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O'])">
          <xsl:attribute name="id">aligned-ibrp-o-11-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-11-aunz]-An Invoice that contains a tax breakdown group (ibg-23) with a tax category code (ibt-118) "Not subject to tax" MUST not contain other tax breakdown groups (ibg-23).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O'])">
          <xsl:attribute name="id">aligned-ibrp-o-12-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-12-aunz]-An Invoice that contains a tax breakdown group (ibg-23) with a tax category code (ibt-118) "Not subject to tax" MUST not contain an Invoice line (ibg-25) where the Invoiced item tax category code (ibt-151) is not "Not subject to tax".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O'])">
          <xsl:attribute name="id">aligned-ibrp-o-13-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-13-aunz]-An Invoice that contains a tax breakdown group (ibg-23) with a tax category code (ibt-118) "Not subject to tax" MUST not contain Document level allowances (ibg-20) where Document level allowance tax category code (ibt-095) is not "Not subject to tax".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'O'])">
          <xsl:attribute name="id">aligned-ibrp-o-14-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-14-aunz]-An Invoice that contains a tax breakdown group (ibg-23) with a tax category code (ibt-118) "Not subject to tax" MUST not contain Document level charges (ibg-21) where Document level charge tax category code (ibt-102) is not "Not subject to tax".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) = 0)">
          <xsl:attribute name="id">aligned-ibrp-s-01-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-01-aunz]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the tax category code (ibt-151, ibt-095 or ibt-102) is "Standard rated" MUST contain in the tax breakdown (ibg-23) at least one tax category code (ibt-118) equal with "Standard rated".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'Z']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'Z']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'Z']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID[normalize-space(.) = 'Z']))">
          <xsl:attribute name="id">aligned-ibrp-z-01-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-01-aunz]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the tax category code (ibt-151, ibt-095 or ibt-102) is "Zero rated" MUST contain in the tax breakdown (ibg-23) exactly one tax category code (ibt-118) equal with "Zero rated".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='GST']/cbc:CompanyID) &lt;= 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)='GST']/cbc:CompanyID) &lt;= 1)">
          <xsl:attribute name="id">aligned-ibrp-sr-12-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-sr-12-aunz]-Seller tax identifier (ibt-031) MUST occur maximum once</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)!='GST']/cbc:CompanyID) &lt;= 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/upper-case(cbc:ID)!='GST']/cbc:CompanyID) &lt;= 1)">
          <xsl:attribute name="id">aligned-ibrp-sr-13-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-sr-13-aunz]-Seller tax registration (ibt-032) MUST occur maximum once</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[ends-with(name(), 'Amount') and not(ends-with(name(),'PriceAmount')) and not(ancestor::cac:Price/cac:AllowanceCharge)]" mode="M14" priority="1024">
    <svrl:fired-rule context="//*[ends-with(name(), 'Amount') and not(ends-with(name(),'PriceAmount')) and not(ancestor::cac:Price/cac:AllowanceCharge)]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(.,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(.,'.'))&lt;=2">
          <xsl:attribute name="id">aligned-ibrp-005</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-005]- Amounts MUST be decimal up to two fraction digits.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxSubtotal" mode="M14" priority="1023">
    <svrl:fired-rule context="cac:TaxSubtotal" />

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
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:ID)">
          <xsl:attribute name="id">aligned-ibrp-047-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-047-aunz]-Each tax breakdown (ibg-23) MUST be defined through a tax category code (ibt-118).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/normalize-space(cbc:ID)='O')" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/normalize-space(cbc:ID)='O')">
          <xsl:attribute name="id">aligned-ibrp-048-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-048-aunz]-Each tax breakdown (ibg-23) MUST have a tax category rate (ibt-119), except if the Invoice is not subject to tax.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent)) != 0 and (u:slack(abs(xs:decimal(cbc:TaxAmount)) , round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100, 1))) or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent)) != 0 and (u:slack(abs(xs:decimal(cbc:TaxAmount)) , round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100, 1))) or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))">
          <xsl:attribute name="id">aligned-ibrp-051-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-051-aunz]-Tax category tax amount (ibt-117) = tax category taxable amount (ibt-116) x (tax category rate (ibt-119) / 100), rounded to two decimals.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount" mode="M14" priority="1022">
    <svrl:fired-rule context="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="id">aligned-ibrp-016</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-016]-A Payment account identifier (ibt-084) MUST be present if Credit transfer (ibg-17) information is provided in the invoice.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal" mode="M14" priority="1021">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((cbc:PayableAmount > 0) and (exists(//cbc:DueDate) or exists(//cac:PaymentTerms/cbc:Note))) or (cbc:PayableAmount &lt;= 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((cbc:PayableAmount > 0) and (exists(//cbc:DueDate) or exists(//cac:PaymentTerms/cbc:Note))) or (cbc:PayableAmount &lt;= 0)">
          <xsl:attribute name="id">aligned-ibrp-061</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-061]-In case the Amount due for payment (ibt-115) is positive, either the Payment due date (ibt-009) or the Payment terms (ibt-020) shall be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans" mode="M14" priority="1020">
    <svrl:fired-rule context="cac:PaymentMeans" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:PayeeFinancialAccount/cbc:ID) and ((normalize-space(cbc:PaymentMeansCode) = '30') or (normalize-space(cbc:PaymentMeansCode) = '58') )) or ((normalize-space(cbc:PaymentMeansCode) != '30') and (normalize-space(cbc:PaymentMeansCode) != '58'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:PayeeFinancialAccount/cbc:ID) and ((normalize-space(cbc:PaymentMeansCode) = '30') or (normalize-space(cbc:PaymentMeansCode) = '58') )) or ((normalize-space(cbc:PaymentMeansCode) != '30') and (normalize-space(cbc:PaymentMeansCode) != '58'))">
          <xsl:attribute name="id">aligned-ibrp-018</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-018]-If the Payment means type code (ibt-081) means SEPA credit transfer, Local credit transfer or Non-SEPA international credit transfer, the Payment account identifier (ibt-084) MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(cbc:PaymentID) &lt;= 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(cbc:PaymentID) &lt;= 1)">
          <xsl:attribute name="id">aligned-ibrp-065</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-065]-Payment reference (ibt-083) MUST occur maximum once.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1019">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) > 0)">
          <xsl:attribute name="id">aligned-ibrp-s-05-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-05-aunz]-In an Invoice line (ibg-25) where the Invoiced item tax category code (ibt-151) is "Standard rated" the Invoiced item tax rate (ibt-152) MUST be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1018">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) > 0)">
          <xsl:attribute name="id">aligned-ibrp-s-06-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-06-aunz]-In a Document level allowance (ibg-20) where the Document level allowance tax category code (ibt-095) is "Standard rated" the Document level allowance tax rate (ibt-096) MUST be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1017">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) > 0)">
          <xsl:attribute name="id">aligned-ibrp-s-07-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-07-aunz]-In a Document level charge (ibg-21) where the Document level charge tax category code (ibt-102) is "Standard rated" the Document level charge tax rate (ibt-103) MUST be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1016">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in xs:decimal(cbc:Percent) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)),1))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)),1))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in xs:decimal(cbc:Percent) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)),1))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)),1))))">
          <xsl:attribute name="id">aligned-ibrp-s-08-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-08-aunz]-For each different value of tax category rate (ibt-119) where the tax category code (ibt-118) is "Standard rated", the tax category taxable amount (ibt-116) in a tax breakdown (ibg-23) MUST equal the sum of Invoice line net amounts (ibt-131) plus the sum of document level charge amounts (ibt-099) minus the sum of document level allowance amounts (ibt-092) where the tax category code (ibt-151, ibt-102, ibt-095) is "Standard rated" and the tax rate (ibt-152, ibt-103, ibt-096) equals the tax category rate (ibt-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ,1 )" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ,1 )">
          <xsl:attribute name="id">aligned-ibrp-s-09-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-09-aunz]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where tax category code (ibt-118) is "Standard rated" MUST equal the tax category taxable amount (ibt-116) multiplied by the tax category rate (ibt-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">aligned-ibrp-s-10-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-10-aunz]-A tax breakdown (ibg-23) with tax Category code (ibt-118) "Standard rate" MUST not have a tax exemption reason code (ibt-121) or tax exemption reason text (ibt-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1015">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-z-05-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-05-aunz]-In an Invoice line (ibg-25) where the Invoiced item tax category code (ibt-151) is "Zero rated" the Invoiced item tax rate (ibt-152) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1014">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-z-06-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-06-aunz]-In a Document level allowance (ibg-20) where the Document level allowance tax category code (ibt-095) is "Zero rated" the Document level allowance tax rate (ibt-096) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1013">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-z-07-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-07-aunz]-In a Document level charge (ibg-21) where the Document level charge tax category code (ibt-102) is "Zero rated" the Document level charge tax rate (ibt-103) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1012">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">aligned-ibrp-z-08-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-08-aunz]-In a tax breakdown (ibg-23) where tax category code (ibt-118) is "Zero rated" the tax category taxable amount (ibt-116) MUST equal the sum of Invoice line net amount (ibt-131) minus the sum of Document level allowance amounts (ibt-092) plus the sum of Document level charge amounts (ibt-099) where the tax category codes (ibt-151, ibt-095, ibt-102) are "Zero rated".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">aligned-ibrp-z-09-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-09-aunz]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where tax category code (ibt-118) is "Zero rated" MUST equal 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">aligned-ibrp-z-10-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-10-aunz]-A tax breakdown (ibg-23) with tax Category code (ibt-118) "Zero rated" MUST not have a tax exemption reason code (ibt-121) or tax exemption reason text (ibt-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1011">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-e-05-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-05-aunz]-In an Invoice line (ibg-25) where the Invoiced item tax category code (ibt-151) is "Exempt from tax", the Invoiced item tax rate (ibt-152) MUST be 0 (zero). </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1010">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-e-06-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-06-aunz]-In a Document level allowance (ibg-20) where the Document level allowance tax category code (ibt-095) is "Exempt from tax", the Document level allowance tax rate (ibt-096) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1009">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-e-07-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-07-aunz]-In a Document level charge (ibg-21) where the Document level charge tax category code (ibt-102) is "Exempt from tax", the Document level charge tax rate (ibt-103) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1008">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">aligned-ibrp-e-08-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-08-aunz]-In a tax breakdown (ibg-23) where the tax category code (ibt-118) is "Exempt from tax" the tax category taxable amount (ibt-116) MUST equal the sum of Invoice line net amounts (ibt-131) minus the sum of Document level allowance amounts (ibt-092) plus the sum of Document level charge amounts (ibt-099) where the tax category codes (ibt-151, ibt-095, ibt-102) are "Exempt from tax".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">aligned-ibrp-e-09-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-e-09-aunz]-The tax category tax amount (ibt-117) In a tax breakdown (ibg-23) where the tax category code (ibt-118) equals "Exempt from tax" MUST equal 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1007">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-g-05-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-g-05-aunz]-In an Invoice line (ibg-25) where the Invoiced item tax category code (ibt-151) is "Export" the Invoiced item tax rate (ibt-152) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1006">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-g-06-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-g-06-aunz]-In a Document level allowance (ibg-20) where the Document level allowance tax category code (ibt-095) is "Export" the Document level allowance tax rate (ibt-096) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1005">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-g-07-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-g-07-aunz]-In a Document level charge (ibg-21) where the Document level charge tax category code (ibt-102) is "Export" the Document level charge tax rate (ibt-103) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1004">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">aligned-ibrp-g-08-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-g-08-aunz]-In a tax breakdown (ibg-23) where the tax category code (ibt-118) is "Export" the tax category taxable amount (ibt-116) MUST equal the sum of Invoice line net amounts (ibt-131) minus the sum of Document level allowance amounts (ibt-092) plus the sum of Document level charge amounts (ibt-099) where the tax category codes (ibt-151, ibt-095, ibt-102) are "Export".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">aligned-ibrp-g-09-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-g-09-aunz]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where the tax category code (ibt-118) is "Export" MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1003">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Percent)">
          <xsl:attribute name="id">aligned-ibrp-o-05-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-05-aunz]-An Invoice line (ibg-25) where the tax category code (ibt-151) is "Not subject to tax" MUST not contain an Invoiced item tax rate (ibt-152).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1002">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Percent)">
          <xsl:attribute name="id">aligned-ibrp-o-06-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-06-aunz]-A Document level allowance (ibg-20) where tax category code (ibt-095) is "Not subject to tax" MUST not contain a Document level allowance tax rate (ibt-096).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1001">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Percent)">
          <xsl:attribute name="id">aligned-ibrp-o-07-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-07-aunz]-A Document level charge (ibg-21) where the tax category code (ibt-102) is "Not subject to tax" MUST not contain a Document level charge tax rate (ibt-103).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" mode="M14" priority="1000">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='GST']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">aligned-ibrp-o-08-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-08-aunz]-In a tax breakdown (ibg-23) where the tax category code (ibt-118) is " Not subject to tax" the tax category taxable amount (ibt-116) MUST equal the sum of Invoice line net amounts (ibt-131) minus the sum of Document level allowance amounts (ibt-092) plus the sum of Document level charge amounts (ibt-099) where the tax category codes (ibt-151, ibt-095, ibt-102) are "Not subject to tax".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">aligned-ibrp-o-09-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-09-aunz]-The tax category tax amount (ibt-117) in a tax breakdown (ibg-23) where the tax category code (ibt-118) is "Not subject to tax" MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

<!--PATTERN Codesmodelaligned-->


	<!--RULE -->
<xsl:template match="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID" mode="M15" priority="1006">
    <svrl:fired-rule context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' E S Z G O ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' E S Z G O ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">aligned-ibrp-cl-01-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-cl-01-aunz]-Invoice tax categories (ibt-095) (ibt-102) (ibt-118) (ibt-192) (ibt-151) MUST be coded using UNCL5305 code list.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoicePeriod/cbc:DescriptionCode" mode="M15" priority="1005">
    <svrl:fired-rule context="cac:InvoicePeriod/cbc:DescriptionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' 3 35 432 ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' 3 35 432 ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">aligned-ibrp-cl-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-cl-02]-Tax point date code (ibt-008) MUST be coded using a restriction of UNTDID 2005.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EmbeddedDocumentBinaryObject[@mimeCode]" mode="M15" priority="1004">
    <svrl:fired-rule context="cbc:EmbeddedDocumentBinaryObject[@mimeCode]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((@mimeCode = 'application/pdf' or @mimeCode = 'image/png' or @mimeCode = 'image/jpeg' or @mimeCode = 'text/csv' or @mimeCode = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or @mimeCode = 'application/vnd.oasis.opendocument.spreadsheet'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((@mimeCode = 'application/pdf' or @mimeCode = 'image/png' or @mimeCode = 'image/jpeg' or @mimeCode = 'text/csv' or @mimeCode = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or @mimeCode = 'application/vnd.oasis.opendocument.spreadsheet'))">
          <xsl:attribute name="id">aligned-ibrp-cl-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-cl-04]-Mime code (ibt-125-1) MUST be according to subset of IANA code list.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'AU']" mode="M15" priority="1003">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'AU']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string-length(cac:PartyLegalEntity/cbc:CompanyID)>=1 and cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0151')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string-length(cac:PartyLegalEntity/cbc:CompanyID)>=1 and cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0151')">
          <xsl:attribute name="id">aligned-ibr-001-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibr-001-aunz]-An invoice must contain the Seller's ABN (ibt-030) if Seller country (ibt-040) is Australia</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party[$buyerCountry = 'AU']" mode="M15" priority="1002">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party[$buyerCountry = 'AU']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string-length(cac:PartyLegalEntity/cbc:CompanyID)>=1 and cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0151')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string-length(cac:PartyLegalEntity/cbc:CompanyID)>=1 and cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0151')">
          <xsl:attribute name="id">aligned-ibr-004-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibr-004-aunz]-An invoice must contain the Buyer's ABN (ibt-047) if Buyer country (ibt-055) is Australia</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'NZ']" mode="M15" priority="1001">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'NZ']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string-length(cac:PartyLegalEntity/cbc:CompanyID)>=1 and cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0088')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string-length(cac:PartyLegalEntity/cbc:CompanyID)>=1 and cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0088')">
          <xsl:attribute name="id">aligned-ibr-002-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibr-002-aunz]-An invoice must contain the Seller's NZBN (ibt-030) if Seller country (ibt-040) is New Zealand</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party[$buyerCountry = 'NZ']" mode="M15" priority="1000">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party[$buyerCountry = 'NZ']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string-length(cac:PartyLegalEntity/cbc:CompanyID)>=1 and cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0088')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string-length(cac:PartyLegalEntity/cbc:CompanyID)>=1 and cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0088')">
          <xsl:attribute name="id">aligned-ibr-005-aunz</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibr-005-aunz]-An invoice must contain the Buyer's NZBN (ibt-047) if Buyer country (ibt-055) is New Zealand</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M15" priority="-1" />
  <xsl:template match="@*|node()" mode="M15" priority="-2">
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
