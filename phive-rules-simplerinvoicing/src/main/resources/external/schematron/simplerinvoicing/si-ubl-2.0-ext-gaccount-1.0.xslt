<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:udt="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
    <svrl:schematron-output schemaVersion="" title="">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:ns-prefix-in-attribute-values prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2" />
      <svrl:ns-prefix-in-attribute-values prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">g-account-extension</xsl:attribute>
        <xsl:attribute name="name">g-account-extension</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M9" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">nlcius</xsl:attribute>
        <xsl:attribute name="name">nlcius</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M10" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">Codesmodel</xsl:attribute>
        <xsl:attribute name="name">Codesmodel</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M11" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">UBL-model</xsl:attribute>
        <xsl:attribute name="name">UBL-model</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M12" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->


<!--PATTERN g-account-extension-->


	<!--RULE -->
<xsl:template match="//cbc:CustomizationID" mode="M9" priority="1005">
    <svrl:fired-rule context="//cbc:CustomizationID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:nen.nl:nlcius:v1.0#conformant#urn:fdc:nen.nl:gaccount:v1.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:nen.nl:nlcius:v1.0#conformant#urn:fdc:nen.nl:gaccount:v1.0'">
          <xsl:attribute name="id">BR-GA-0</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
            When using the G-account extension, the CustomizationID must specify this.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice" mode="M9" priority="1004">
    <svrl:fired-rule context="/ubl:Invoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PaymentTerms) = 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PaymentTerms) = 2">
          <xsl:attribute name="id">BR-GA-1</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-GA-1] The number of Payment Terms (NL-GA-01) in each invoice MUST be two.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PaymentMeans) = 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PaymentMeans) = 2">
          <xsl:attribute name="id">BR-GA-2</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-GA-2] The number of Payment Instructions (BG-16) in each invoice MUST be two.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:LegalMonetaryTotal/xs:decimal(cbc:PayableAmount) = sum(cac:PaymentTerms/xs:decimal(cbc:Amount))" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:LegalMonetaryTotal/xs:decimal(cbc:PayableAmount) = sum(cac:PaymentTerms/xs:decimal(cbc:Amount))">
          <xsl:attribute name="id">BR-GA-3</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-GA-3] Sum of Amount due for payment (BT-115) = ∑ Payment Amount (NL-GA-03)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PaymentMeans/cbc:ID[text()='GACCOUNT']) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PaymentMeans/cbc:ID[text()='GACCOUNT']) = 1">
          <xsl:attribute name="id">BR-GA-7</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-GA-7] There MUST be a Payment Means identifier (NL-GA-04) with a value equal to 'GACCOUNT'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentTerms" mode="M9" priority="1003">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentTerms" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:PaymentMeansID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:PaymentMeansID) = 1">
          <xsl:attribute name="id">BR-GA-4</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-GA-4] Each Payment Terms (NL-GA-01) MUST include a Payment Means reference (NL-GA-02)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans" mode="M9" priority="1002">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ID) = 1">
          <xsl:attribute name="id">BR-GA-5</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-GA-5] Each Payment Instructions (BG-16) MUST include a Payment Means identifier (NL-GA-04)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="*" />
  </xsl:template>
  <xsl:variable name="payment-means-ids" select="/ubl:Invoice/cac:PaymentMeans/cbc:ID/text()" />

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentTerms/cbc:PaymentMeansID" mode="M9" priority="1000">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentTerms/cbc:PaymentMeansID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = $payment-means-ids" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = $payment-means-ids">
          <xsl:attribute name="id">BR-GA-6</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-GA-6] The value of each Payment Means reference (NL-GA-02) MUST correspond with one and only one Payment means identifier (NL-GA-04)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M9" priority="-1" />
  <xsl:template match="@*|node()" mode="M9" priority="-2">
    <xsl:apply-templates mode="M9" select="*" />
  </xsl:template>

<!--PATTERN nlcius-->
<xsl:variable name="customizationID" select="normalize-space(/*/cbc:CustomizationID)" />
  <xsl:variable name="is_SI-UBL-2.0" select="$customizationID = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:nen.nl:nlcius:v1.0'" />
  <xsl:variable name="is_SI-UBL-2.0-ext-gaccount" select="$customizationID = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:nen.nl:nlcius:v1.0#conformant#urn:fdc:nen.nl:gaccount:v1.0'" />
  <xsl:variable name="supplierCountry" select="if (/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then upper-case(normalize-space(/*/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) else 'XX'" />
  <xsl:variable name="supplierIsNL" select="$supplierCountry = 'NL'" />
  <xsl:variable name="si" select="($is_SI-UBL-2.0 or $is_SI-UBL-2.0-ext-gaccount)" />
  <xsl:variable name="s" select="$supplierIsNL and ($is_SI-UBL-2.0 or $is_SI-UBL-2.0-ext-gaccount)" />

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party[$s]" mode="M10" priority="1034">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(contains(concat(' ', string-join(cac:PartyLegalEntity/cbc:CompanyID/@schemeID, ' '), ' '), ' 0106 ') or contains(concat(' ', string-join(cac:PartyLegalEntity/cbc:CompanyID/@schemeID, ' '), ' '), ' 0190 ')) and (cac:PartyLegalEntity/cbc:CompanyID/normalize-space(.) != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(contains(concat(' ', string-join(cac:PartyLegalEntity/cbc:CompanyID/@schemeID, ' '), ' '), ' 0106 ') or contains(concat(' ', string-join(cac:PartyLegalEntity/cbc:CompanyID/@schemeID, ' '), ' '), ' 0190 ')) and (cac:PartyLegalEntity/cbc:CompanyID/normalize-space(.) != '')">
          <xsl:attribute name="id">BR-NL-1</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-1] For suppliers in the Netherlands the supplier MUST provide either a KVK or OIN number for its legal entity identifier (cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID with schemeID 0106 or 0190)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*[$s]" mode="M10" priority="1033">
    <svrl:fired-rule context="/*[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:BuyerReference) or (cac:OrderReference/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:BuyerReference) or (cac:OrderReference/cbc:ID)">
          <xsl:attribute name="id">BR-NL-2</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-2] For suppliers in the Netherlands, the invoice MUST contain either the buyer reference (cbc:BuyerReference) or the order reference (cac:OrderReference/cbc:ID)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress[$s]" mode="M10" priority="1032">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:StreetName and                     cbc:CityName and                     cbc:PostalZone" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:StreetName and cbc:CityName and cbc:PostalZone">
          <xsl:attribute name="id">BR-NL-3</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-3] For suppliers in the Netherlands the supplier's address (cac:AccountingSupplierParty/cac:Party/cac:PostalAddress) MUST contain street name (cbc:StreetName), city (cbc:CityName) and postal zone (cbc:PostalZone)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress[$s]" mode="M10" priority="1031">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country/cbc:IdentificationCode != 'NL' or (                     cbc:StreetName and                     cbc:CityName and                     cbc:PostalZone)" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country/cbc:IdentificationCode != 'NL' or ( cbc:StreetName and cbc:CityName and cbc:PostalZone)">
          <xsl:attribute name="id">BR-NL-4</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-4] For suppliers in the Netherlands, if the customer is in the Netherlands, the customer address (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress) MUST contain the street name (cbc:StreetName), the city (cbc:CityName) and the postal zone (cbc:PostalZone)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxRepresentativeParty/cac:PostalAddress[$s]" mode="M10" priority="1030">
    <svrl:fired-rule context="cac:TaxRepresentativeParty/cac:PostalAddress[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Country/cbc:IdentificationCode != 'NL') or                     (cbc:StreetName and                      cbc:CityName and                      cbc:PostalZone)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Country/cbc:IdentificationCode != 'NL') or (cbc:StreetName and cbc:CityName and cbc:PostalZone)">
          <xsl:attribute name="id">BR-NL-5</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-5] For suppliers in the Netherlands, if the fiscal representative is in the Netherlands, the representative's address (cac:TaxRepresentativeParty/cac:PostalAddress) MUST contain street name (cbc:StreetName), city (cbc:CityName) and postal zone (cbc:PostalZone)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:InvoiceTypeCode[$s]" mode="M10" priority="1029">
    <svrl:fired-rule context="cbc:InvoiceTypeCode[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = 380 or                     . = 381 or                     . = 384 or                     . = 389" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = 380 or . = 381 or . = 384 or . = 389">
          <xsl:attribute name="id">BR-NL-7</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-7] The invoice type code (cbc:InvoiceTypeCode) MUST have one of the following values: 380, 381, 384, 389</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". != 381 or                     /ubl:CreditNote" />
      <xsl:otherwise>
        <svrl:failed-assert test=". != 381 or /ubl:CreditNote">
          <xsl:attribute name="id">BR-NL-8</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-8] If the invoice type code (cbc:InvoiceTypeCode) is 381, the document MUST use the CreditNote scheme</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". != 381 or                     /ubl:Invoice" />
      <xsl:otherwise>
        <svrl:failed-assert test=". != 381 or /ubl:Invoice">
          <xsl:attribute name="id">BR-NL-8</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-8] If the invoice type code (cbc:InvoiceTypeCode) is 380, 384 or 389, the document MUST use the Invoice scheme</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(. != 384) or                     /*/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="(. != 384) or /*/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID">
          <xsl:attribute name="id">BR-NL-9</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-9] For suppliers in the Netherlands, if the document is a corrective invoice (cbc:InvoiceTypeCode = 384), the document MUST contain an invoice reference (cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity[$s]" mode="M10" priority="1028">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="         (not(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NL')          or          contains(concat(' ', string-join(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID, ' '), ' '), ' 0106 ')          or          contains(concat(' ', string-join(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID, ' '), ' '), ' 0190 ')         ) and (not(cbc:CompanyID) or (cbc:CompanyID/normalize-space(.) != ''))     " />
      <xsl:otherwise>
        <svrl:failed-assert test="(not(//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NL') or contains(concat(' ', string-join(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID, ' '), ' '), ' 0106 ') or contains(concat(' ', string-join(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID, ' '), ' '), ' 0190 ') ) and (not(cbc:CompanyID) or (cbc:CompanyID/normalize-space(.) != ''))">
          <xsl:attribute name="id">BR-NL-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-10] For suppliers in the Netherlands, if the customer is in the Netherlands, the customer's legal entity identifier (cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) MUST be either a KVK (schemeID=0106) or OIN number (schemeID=0190)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:LegalMonetaryTotal[$s]" mode="M10" priority="1027">
    <svrl:fired-rule context="cac:LegalMonetaryTotal[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(cbc:PayableAmount) &lt;= 0.0 or (//cac:PaymentMeans)" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(cbc:PayableAmount) &lt;= 0.0 or (//cac:PaymentMeans)">
          <xsl:attribute name="id">BR-NL-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-11] For suppliers in the Netherlands, the supplier MUST provide a means of payment (cac:PaymentMeans) if the payment is from customer to supplier</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans[$s]" mode="M10" priority="1026">
    <svrl:fired-rule context="cac:PaymentMeans[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:PaymentMeansCode = 30 or               cbc:PaymentMeansCode = 48 or               cbc:PaymentMeansCode = 49 or               cbc:PaymentMeansCode = 57 or               cbc:PaymentMeansCode = 58 or               cbc:PaymentMeansCode = 59" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:PaymentMeansCode = 30 or cbc:PaymentMeansCode = 48 or cbc:PaymentMeansCode = 49 or cbc:PaymentMeansCode = 57 or cbc:PaymentMeansCode = 58 or cbc:PaymentMeansCode = 59">
          <xsl:attribute name="id">BR-NL-12</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-12] For suppliers in the Netherlands, the payment means code (cac:PaymentMeans/cbc:PaymentMeansCode) MUST be one of 30, 48, 49, 57, 58 or 59</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cbc:PaymentMeansCode = 58 or cbc:PaymentMeansCode = 59)) or not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cbc:PaymentMeansCode = 58 or cbc:PaymentMeansCode = 59)) or not(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)">
          <xsl:attribute name="id">BR-NL-31</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-31] The use of a payment service provider identifier (cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) is not recommended for SEPA payments (cac:PaymentMeans/cbc:PaymentMeansCode = 58 or 59)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:OrderLineReference/cbc:LineID[$si]" mode="M10" priority="1025">
    <svrl:fired-rule context="cac:OrderLineReference/cbc:LineID[$si]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(/*/cac:OrderReference/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/*/cac:OrderReference/cbc:ID)">
          <xsl:attribute name="id">BR-NL-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-13] If an order line reference (BT-132) is used, there must be an order reference on the document level (BT-13)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:TaxCurrencyCode[$s]" mode="M10" priority="1024">
    <svrl:fired-rule context="cbc:TaxCurrencyCode[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-19</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-19] The use of a tax currency code (cbc:TaxCurrencyCode) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:TaxPointDate[$s]" mode="M10" priority="1023">
    <svrl:fired-rule context="cbc:TaxPointDate[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-20</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-20] The use of a tax point date (cbc:TaxPointDate) is not recommended, and its value will be ignored</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoicePeriod/cbc:DescriptionCode[$s]" mode="M10" priority="1022">
    <svrl:fired-rule context="cac:InvoicePeriod/cbc:DescriptionCode[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-21</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-21] The use of a tax point date code (cac:InvoicePeriod/cbc:DescriptionCode) is not recommended, and its value will be ignored</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate[$s]" mode="M10" priority="1021">
    <svrl:fired-rule context="cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-24</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-24] The use of a preceding invoice issue date (cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[$s]" mode="M10" priority="1020">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:CompanyID) or cac:TaxScheme/cbc:ID = 'VAT'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:CompanyID) or cac:TaxScheme/cbc:ID = 'VAT'">
          <xsl:attribute name="id">BR-NL-25</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-25] The use of a seller tax registration identifier (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) is not recommended when the tax scheme is not VAT, since this is not applicable to suppliers in the Netherlands</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm[$s]" mode="M10" priority="1019">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-26</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-26] The use of the seller additional legal information field (cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm) is not recommended, since this is not applicable for suppliers in the Netherlands</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line[$s]" mode="M10" priority="1018">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-27-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-27] The use of the seller address line 3 (cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line[$s]" mode="M10" priority="1017">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-27-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-27] The use of the customer address line 3 (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine/cbc:Line[$s]" mode="M10" priority="1016">
    <svrl:fired-rule context="cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine/cbc:Line[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-27-3</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-27] The use of the tax representative address line 3 (cac:TaxRepresentativePart/cac:PostalAddress/cac:AddressLine/cbc:Line) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line[$s]" mode="M10" priority="1015">
    <svrl:fired-rule context="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-27-4</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-27] The use of the delivery address line 3 (cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity[$s]" mode="M10" priority="1014">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-28-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-28] The use of a country subdivision (cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity[$s]" mode="M10" priority="1013">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-28-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-28] The use of a country subdivision (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CountrySubentity[$s]" mode="M10" priority="1012">
    <svrl:fired-rule context="cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CountrySubentity[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-28-3</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-28] The use of a country subdivision (cac:TaxRepresentativePart/cac:PostalAddress/cbc:CountrySubentity) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity[$s]" mode="M10" priority="1011">
    <svrl:fired-rule context="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-28-4</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-28] The use of a country subdivision (cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans/cbc:PaymentMeansCode[$s]" mode="M10" priority="1010">
    <svrl:fired-rule context="cac:PaymentMeans/cbc:PaymentMeansCode[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@name)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@name)">
          <xsl:attribute name="id">BR-NL-29</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-29] The use of a payment means text (cac:PaymentMeans/cbc:PaymentMeansCode/@name) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name[$s]" mode="M10" priority="1009">
    <svrl:fired-rule context="cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-30</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-30] The use of a payment account name (cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[$s]" mode="M10" priority="1008">
    <svrl:fired-rule context="cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-32-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-32] The use of an allowance reason code (cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[$s]" mode="M10" priority="1007">
    <svrl:fired-rule context="cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-32-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-32] The use of an allowance reason code (cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:CreditNoteLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[$s]" mode="M10" priority="1006">
    <svrl:fired-rule context="cac:CreditNoteLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-32-3</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-32] The use of an allowance reason code (cac:CreditNoteLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxTotal/cbc:TaxAmount[$s]" mode="M10" priority="1005">
    <svrl:fired-rule context="cac:TaxTotal/cbc:TaxAmount[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID = //cbc:DocumentCurrencyCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID = //cbc:DocumentCurrencyCode">
          <xsl:attribute name="id">BR-NL-33</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-33] The use of a tax total in accounting currency (cac:TaxTotal/cbc:TaxAmount/@currencyID different than DocumentCurrencyCode) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[$s]" mode="M10" priority="1004">
    <svrl:fired-rule context="cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-32-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-34] The use of a charge reason code (cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[$s]" mode="M10" priority="1003">
    <svrl:fired-rule context="cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-32-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-34] The use of a charge reason code (cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:CreditNoteLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[$s]" mode="M10" priority="1002">
    <svrl:fired-rule context="cac:CreditNoteLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-32-3</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-34] The use of a charge reason code (cac:CreditNoteLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode[$s]" mode="M10" priority="1001">
    <svrl:fired-rule context="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode[$s]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false" />
      <xsl:otherwise>
        <svrl:failed-assert test="false">
          <xsl:attribute name="id">BR-NL-35</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-NL-35] The use of a tax exemption reason code (cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode) is not recommended</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//*[not(*) and not(normalize-space())]" mode="M10" priority="1000">
    <svrl:fired-rule context="//*[not(*) and not(normalize-space())]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">SI-UBL-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document should not contain empty elements.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

<!--PATTERN Codesmodel-->


	<!--RULE -->
<xsl:template match="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" mode="M11" priority="1020">
    <svrl:fired-rule context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 80 82 84 130 202 203 204 211 295 325 326 380 383 384 385 386 387 388 389 390 393 394 395 456 457 527 575 623 633 751 780 935 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 81 83 261 262 296 308 381 396 420 458 532 ', concat(' ', normalize-space(.), ' ')))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 80 82 84 130 202 203 204 211 295 325 326 380 383 384 385 386 387 388 389 390 393 394 395 456 457 527 575 623 633 751 780 935 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 81 83 261 262 296 308 381 396 420 458 532 ', concat(' ', normalize-space(.), ' ')))))">
          <xsl:attribute name="id">BR-CL-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-01]-The document type code MUST be coded by the invoice and credit note related code lists of UNTDID 1001.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" mode="M11" priority="1019">
    <svrl:fired-rule context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(@currencyID), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(@currencyID), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(@currencyID), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(@currencyID), ' '))))">
          <xsl:attribute name="id">BR-CL-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-03]-currencyID MUST be coded using ISO code list 4217 alpha-3</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:DocumentCurrencyCode" mode="M11" priority="1018">
    <svrl:fired-rule context="cbc:DocumentCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">BR-CL-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-04]-Invoice currency code MUST be coded using ISO code list 4217 alpha-3</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:TaxCurrencyCode" mode="M11" priority="1017">
    <svrl:fired-rule context="cbc:TaxCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">BR-CL-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-05]-Tax currency code MUST be coded using ISO code list 4217 alpha-3</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoicePeriod/cbc:DescriptionCode" mode="M11" priority="1016">
    <svrl:fired-rule context="cac:InvoicePeriod/cbc:DescriptionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' 3 35 432 ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' 3 35 432 ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">BR-CL-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-06]-Value added tax point date code MUST be coded using a restriction of UNTDID 2005.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '130']/cbc:ID[@schemeID] | cac:DocumentReference[cbc:DocumentTypeCode = '130']/cbc:ID[@schemeID]" mode="M11" priority="1015">
    <svrl:fired-rule context="cac:AdditionalDocumentReference[cbc:DocumentTypeCode = '130']/cbc:ID[@schemeID] | cac:DocumentReference[cbc:DocumentTypeCode = '130']/cbc:ID[@schemeID]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABY ABZ AC ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACN ACO ACP ACQ ACR ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADT ADU ADV ADW ADX ADY ADZ AE AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AF AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB AJC AJD AJE AJF AJG AJH AJI AJJ AJK AJL AJM AJN AJO AJP AJQ AJR AJS AJT AJU AJV AJW AJX AJY AJZ AKA AKB AKC AKD AKE AKF AKG AKH AKI AKJ AKK AKL AKM AKN AKO AKP AKQ AKR AKS AKT AKU AKV AKW AKX AKY AKZ ALA ALB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ALR ALS ALT ALU ALV ALW ALX ALY ALZ AMA AMB AMC AMD AME AMF AMG AMH AMI AMJ AMK AML AMM AMN AMO AMP AMQ AMR AMS AMT AMU AMV AMW AMX AMY AMZ ANA ANB ANC AND ANE ANF ANG ANH ANI ANJ ANK ANL ANM ANN ANO ANP ANQ ANR ANS ANT ANU ANV ANW ANX ANY AOA AOD AOE AOF AOG AOH AOI AOJ AOK AOL AOM AON AOO AOP AOQ AOR AOS AOT AOU AOV AOW AOX AOY AOZ AP APA APB APC APD APE APF APG APH API APJ APK APL APM APN APO APP APQ APR APS APT APU APV APW APX APY APZ AQA AQB AQC AQD AQE AQF AQG AQH AQI AQJ AQK AQL AQM AQN AQO AQP AQQ AQR AQS AQT AQU AQV AQW AQX AQY AQZ ARA ARB ARC ARD ARE ARF ARG ARH ARI ARJ ARK ARL ARM ARN ARO ARP ARQ ARR ARS ART ARU ARV ARW ARX ARY ARZ ASA ASB ASC ASD ASE ASF ASG ASH ASI ASJ ASK ASL ASM ASN ASO ASP ASQ ASR ASS AST ASU ASV ASW ASX ASY ASZ ATA ATB ATC ATD ATE ATF ATG ATH ATI ATJ ATK ATL ATM ATN ATO ATP ATQ ATR ATS ATT ATU ATV ATW ATX ATY ATZ AU AUA AUB AUC AUD AUE AUF AUG AUH AUI AUJ AUK AUL AUM AUN AUO AUP AUQ AUR AUS AUT AUU AUV AUW AUX AUY AUZ AV AVA AVB AVC AVD AVE AVF AVG AVH AVI AVJ AVK AVL AVM AVN AVO AVP AVQ AVR AVS AVT AVU AVV AVW AVX AVY AVZ AWA AWB AWC AWD AWE AWF AWG AWH AWI AWJ AWK AWL AWM AWN AWO AWP AWQ AWR AWS AWT AWU AWV AWW AWX AWY AWZ AXA AXB AXC AXD AXE AXF AXG AXH AXI AXJ AXK AXL AXM AXN AXO AXP AXQ AXR AXS BA BC BD BE BH BM BN BO BR BT BTP BW CAS CAT CAU CAV CAW CAX CAY CAZ CBA CBB CD CEC CED CFE CFF CFO CG CH CK CKN CM CMR CN CNO COF CP CR CRN CS CST CT CU CV CW CZ DA DAN DB DI DL DM DQ DR EA EB ED EE EEP EI EN EQ ER ERN ET EX FC FF FI FLW FN FO FS FT FV FX GA GC GD GDN GN HS HWB IA IB ICA ICE ICO II IL INB INN INO IP IS IT IV JB JE LA LAN LAR LB LC LI LO LRC LS MA MB MF MG MH MR MRN MS MSS MWB NA NF OH OI ON OP OR PB PC PD PE PF PI PK PL POR PP PQ PR PS PW PY RA RC RCN RE REN RF RR RT SA SB SD SE SEA SF SH SI SM SN SP SQ SRN SS STA SW SZ TB TCR TE TF TI TIN TL TN TP UAR UC UCN UN UO URI VA VC VGR VM VN VON VOR VP VR VS VT VV WE WM WN WR WS WY XA XC XP ZZZ ', concat(' ', normalize-space(@schemeID), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABY ABZ AC ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACN ACO ACP ACQ ACR ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADT ADU ADV ADW ADX ADY ADZ AE AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AF AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB AJC AJD AJE AJF AJG AJH AJI AJJ AJK AJL AJM AJN AJO AJP AJQ AJR AJS AJT AJU AJV AJW AJX AJY AJZ AKA AKB AKC AKD AKE AKF AKG AKH AKI AKJ AKK AKL AKM AKN AKO AKP AKQ AKR AKS AKT AKU AKV AKW AKX AKY AKZ ALA ALB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ALR ALS ALT ALU ALV ALW ALX ALY ALZ AMA AMB AMC AMD AME AMF AMG AMH AMI AMJ AMK AML AMM AMN AMO AMP AMQ AMR AMS AMT AMU AMV AMW AMX AMY AMZ ANA ANB ANC AND ANE ANF ANG ANH ANI ANJ ANK ANL ANM ANN ANO ANP ANQ ANR ANS ANT ANU ANV ANW ANX ANY AOA AOD AOE AOF AOG AOH AOI AOJ AOK AOL AOM AON AOO AOP AOQ AOR AOS AOT AOU AOV AOW AOX AOY AOZ AP APA APB APC APD APE APF APG APH API APJ APK APL APM APN APO APP APQ APR APS APT APU APV APW APX APY APZ AQA AQB AQC AQD AQE AQF AQG AQH AQI AQJ AQK AQL AQM AQN AQO AQP AQQ AQR AQS AQT AQU AQV AQW AQX AQY AQZ ARA ARB ARC ARD ARE ARF ARG ARH ARI ARJ ARK ARL ARM ARN ARO ARP ARQ ARR ARS ART ARU ARV ARW ARX ARY ARZ ASA ASB ASC ASD ASE ASF ASG ASH ASI ASJ ASK ASL ASM ASN ASO ASP ASQ ASR ASS AST ASU ASV ASW ASX ASY ASZ ATA ATB ATC ATD ATE ATF ATG ATH ATI ATJ ATK ATL ATM ATN ATO ATP ATQ ATR ATS ATT ATU ATV ATW ATX ATY ATZ AU AUA AUB AUC AUD AUE AUF AUG AUH AUI AUJ AUK AUL AUM AUN AUO AUP AUQ AUR AUS AUT AUU AUV AUW AUX AUY AUZ AV AVA AVB AVC AVD AVE AVF AVG AVH AVI AVJ AVK AVL AVM AVN AVO AVP AVQ AVR AVS AVT AVU AVV AVW AVX AVY AVZ AWA AWB AWC AWD AWE AWF AWG AWH AWI AWJ AWK AWL AWM AWN AWO AWP AWQ AWR AWS AWT AWU AWV AWW AWX AWY AWZ AXA AXB AXC AXD AXE AXF AXG AXH AXI AXJ AXK AXL AXM AXN AXO AXP AXQ AXR AXS BA BC BD BE BH BM BN BO BR BT BTP BW CAS CAT CAU CAV CAW CAX CAY CAZ CBA CBB CD CEC CED CFE CFF CFO CG CH CK CKN CM CMR CN CNO COF CP CR CRN CS CST CT CU CV CW CZ DA DAN DB DI DL DM DQ DR EA EB ED EE EEP EI EN EQ ER ERN ET EX FC FF FI FLW FN FO FS FT FV FX GA GC GD GDN GN HS HWB IA IB ICA ICE ICO II IL INB INN INO IP IS IT IV JB JE LA LAN LAR LB LC LI LO LRC LS MA MB MF MG MH MR MRN MS MSS MWB NA NF OH OI ON OP OR PB PC PD PE PF PI PK PL POR PP PQ PR PS PW PY RA RC RCN RE REN RF RR RT SA SB SD SE SEA SF SH SI SM SN SP SQ SRN SS STA SW SZ TB TCR TE TF TI TIN TL TN TP UAR UC UCN UN UO URI VA VC VGR VM VN VON VOR VP VR VS VT VV WE WM WN WR WS WY XA XC XP ZZZ ', concat(' ', normalize-space(@schemeID), ' '))))">
          <xsl:attribute name="id">BR-CL-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-07]-Object identifier identification scheme identifier MUST be coded using a restriction of UNTDID 1153.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PartyIdentification/cbc:ID[@schemeID]" mode="M11" priority="1014">
    <svrl:fired-rule context="cac:PartyIdentification/cbc:ID[@schemeID]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 ', concat(' ', normalize-space(@schemeID), ' '))))  or ((not(contains(normalize-space(@schemeID), ' ')) and contains(' SEPA ', concat(' ', normalize-space(@schemeID), ' '))) and ((ancestor::cac:AccountingSupplierParty) or (ancestor::cac:PayeeParty)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 ', concat(' ', normalize-space(@schemeID), ' ')))) or ((not(contains(normalize-space(@schemeID), ' ')) and contains(' SEPA ', concat(' ', normalize-space(@schemeID), ' '))) and ((ancestor::cac:AccountingSupplierParty) or (ancestor::cac:PayeeParty)))">
          <xsl:attribute name="id">BR-CL-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-10]-Any identifier identification scheme identifier MUST be coded using one of the ISO 6523 ICD list.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PartyLegalEntity/cbc:CompanyID[@schemeID]" mode="M11" priority="1013">
    <svrl:fired-rule context="cac:PartyLegalEntity/cbc:CompanyID[@schemeID]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 ', concat(' ', normalize-space(@schemeID), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 ', concat(' ', normalize-space(@schemeID), ' '))))">
          <xsl:attribute name="id">BR-CL-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-11]-Any registration identifier identification scheme identifier MUST be coded using one of the ISO 6523 ICD list.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:CommodityClassification/cbc:ItemClassificationCode[@listID]" mode="M11" priority="1012">
    <svrl:fired-rule context="cac:CommodityClassification/cbc:ItemClassificationCode[@listID]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(@listID), ' ')) and contains(' AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EN FS GB GN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSQ TSR TSS TST UA UP VN VP VS VX ZZZ ', concat(' ', normalize-space(@listID), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(@listID), ' ')) and contains(' AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EN FS GB GN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSQ TSR TSS TST UA UP VN VP VS VX ZZZ ', concat(' ', normalize-space(@listID), ' '))))">
          <xsl:attribute name="id">BR-CL-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-13]-Item classification identifier identification scheme identifier MUST be
      coded using one of the UNTDID 7143 list.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Country/cbc:IdentificationCode" mode="M11" priority="1011">
    <svrl:fired-rule context="cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">BR-CL-14</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-14]-Country codes in an invoice MUST be coded using ISO code list 3166-1</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:OriginCountry/cbc:IdentificationCode" mode="M11" priority="1010">
    <svrl:fired-rule context="cac:OriginCountry/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">BR-CL-15</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-15]-Country codes in an invoice MUST be coded using ISO code list 3166-1</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans/cbc:PaymentMeansCode" mode="M11" priority="1009">
    <svrl:fired-rule context="cac:PaymentMeans/cbc:PaymentMeansCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">BR-CL-16</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-16]-Payment means in an invoice MUST be coded using UNCL4461 code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxCategory/cbc:ID" mode="M11" priority="1008">
    <svrl:fired-rule context="cac:TaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">BR-CL-17</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-17]-Invoice tax categories MUST be coded using UNCL5305 code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:ClassifiedTaxCategory/cbc:ID" mode="M11" priority="1007">
    <svrl:fired-rule context="cac:ClassifiedTaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE L M E S Z G O K ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">BR-CL-18</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-18]-Invoice tax categories MUST be coded using UNCL5305 code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = false()]/cbc:AllowanceChargeReasonCode" mode="M11" priority="1006">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator = false()]/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' 41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' 41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">BR-CL-19</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-19]-Coded allowance reasons MUST belong to the UNCL 5189 code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = true()]/cbc:AllowanceChargeReasonCode" mode="M11" priority="1005">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator = true()]/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAD DAC DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAD DAC DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">BR-CL-20</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-20]-Coded charge reasons MUST belong to the UNCL 7161 code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:StandardItemIdentification/cbc:ID[@schemeID]" mode="M11" priority="1004">
    <svrl:fired-rule context="cac:StandardItemIdentification/cbc:ID[@schemeID]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 ', concat(' ', normalize-space(@schemeID), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0001 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 ', concat(' ', normalize-space(@schemeID), ' '))))">
          <xsl:attribute name="id">BR-CL-21</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-21]-Item standard identifier scheme identifier MUST belong to the ISO 6523 ICD code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:TaxExemptionReasonCode" mode="M11" priority="1003">
    <svrl:fired-rule context="cbc:TaxExemptionReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' VATEX-EU-132 VATEX-EU-132-1A VATEX-EU-132-1B VATEX-EU-132-1C VATEX-EU-132-1D VATEX-EU-132-1E VATEX-EU-132-1F VATEX-EU-132-1G VATEX-EU-132-1H VATEX-EU-132-1I VATEX-EU-132-1J VATEX-EU-132-1K VATEX-EU-132-1L VATEX-EU-132-1M VATEX-EU-132-1N VATEX-EU-132-1O VATEX-EU-132-1P VATEX-EU-132-1Q VATEX-EU-143 VATEX-EU-143-1A VATEX-EU-143-1B VATEX-EU-143-1C VATEX-EU-143-1D VATEX-EU-143-1E VATEX-EU-143-1F VATEX-EU-143-1FA VATEX-EU-143-1G VATEX-EU-143-1H VATEX-EU-143-1I VATEX-EU-143-1J VATEX-EU-143-1K VATEX-EU-143-1L VATEX-EU-309 VATEX-EU-148 VATEX-EU-148-A VATEX-EU-148-B VATEX-EU-148-C VATEX-EU-148-D VATEX-EU-148-E VATEX-EU-148-F VATEX-EU-148-G VATEX-EU-151 VATEX-EU-151-1A VATEX-EU-151-1AA VATEX-EU-151-1B VATEX-EU-151-1C VATEX-EU-151-1D VATEX-EU-151-1E VATEX-EU-G VATEX-EU-O VATEX-EU-IC VATEX-EU-AE VATEX-EU-D VATEX-EU-F VATEX-EU-I VATEX-EU-J ', concat(' ', normalize-space(upper-case(.)), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' VATEX-EU-132 VATEX-EU-132-1A VATEX-EU-132-1B VATEX-EU-132-1C VATEX-EU-132-1D VATEX-EU-132-1E VATEX-EU-132-1F VATEX-EU-132-1G VATEX-EU-132-1H VATEX-EU-132-1I VATEX-EU-132-1J VATEX-EU-132-1K VATEX-EU-132-1L VATEX-EU-132-1M VATEX-EU-132-1N VATEX-EU-132-1O VATEX-EU-132-1P VATEX-EU-132-1Q VATEX-EU-143 VATEX-EU-143-1A VATEX-EU-143-1B VATEX-EU-143-1C VATEX-EU-143-1D VATEX-EU-143-1E VATEX-EU-143-1F VATEX-EU-143-1FA VATEX-EU-143-1G VATEX-EU-143-1H VATEX-EU-143-1I VATEX-EU-143-1J VATEX-EU-143-1K VATEX-EU-143-1L VATEX-EU-309 VATEX-EU-148 VATEX-EU-148-A VATEX-EU-148-B VATEX-EU-148-C VATEX-EU-148-D VATEX-EU-148-E VATEX-EU-148-F VATEX-EU-148-G VATEX-EU-151 VATEX-EU-151-1A VATEX-EU-151-1AA VATEX-EU-151-1B VATEX-EU-151-1C VATEX-EU-151-1D VATEX-EU-151-1E VATEX-EU-G VATEX-EU-O VATEX-EU-IC VATEX-EU-AE VATEX-EU-D VATEX-EU-F VATEX-EU-I VATEX-EU-J ', concat(' ', normalize-space(upper-case(.)), ' '))))">
          <xsl:attribute name="id">BR-CL-22</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-22]-Tax exemption reason code identifier scheme identifier MUST belong to the CEF VATEX code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:InvoicedQuantity[@unitCode] | cbc:BaseQuantity[@unitCode]" mode="M11" priority="1002">
    <svrl:fired-rule context="cbc:InvoicedQuantity[@unitCode] | cbc:BaseQuantity[@unitCode]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(@unitCode), ' ')) and contains(' 10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 64 66 74 76 77 78 80 81 84 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A1 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A25 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A50 A51 A52 A53 A54 A55 A56 A57 A58 A59 A6 A60 A61 A62 A63 A64 A65 A66 A67 A68 A69 A7 A70 A71 A73 A74 A75 A76 A77 A78 A79 A8 A80 A81 A82 A83 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ ARE AS ASM ASU ATM ATT AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B36 B37 B38 B39 B4 B40 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B51 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B65 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D35 D36 D37 D38 D39 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D70 D71 D72 D73 D74 D75 D76 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D9 D91 D93 D94 D95 DAA DAD DAY DB DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DU DWT DX DZN DZP E01 E07 E08 E09 E10 E11 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GRT GT GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H78 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAR HBA HBX HC HDW HEA HGM HH HIU HJ HKM HLT HM HMQ HMT HN HP HPA HTZ HUR IA IE INH INK INQ ISD IU IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J89 J90 J91 J92 J93 J94 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K24 K25 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K5 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWO KWT KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MLD MLT MMK MMQ MMT MND MON MPA MQH MQS MSK MTK MTQ MTR MTS MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NMI NMP NPR NPT NQ NR NT NTT NU NX OA ODE OHM ON ONZ OT OZ OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PT PTD PTI PTL Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q3 QA QAN QB QR QT QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SHT SIE SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPR TQD TRL TST TTS U1 U2 UA UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT WW X1 YDK YDQ YRD Z11 ZP ZZ X43 X44 X1A X1B X1D X1F X1G X1W X2C X3A X3H X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XOA XOB XOC XOD XOE XOF XOK XOT XOU XP2 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVN XVO XVP XVQ XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY XZZ ', concat(' ', normalize-space(@unitCode), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(@unitCode), ' ')) and contains(' 10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 64 66 74 76 77 78 80 81 84 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A1 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A25 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A50 A51 A52 A53 A54 A55 A56 A57 A58 A59 A6 A60 A61 A62 A63 A64 A65 A66 A67 A68 A69 A7 A70 A71 A73 A74 A75 A76 A77 A78 A79 A8 A80 A81 A82 A83 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ ARE AS ASM ASU ATM ATT AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B36 B37 B38 B39 B4 B40 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B51 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B65 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D35 D36 D37 D38 D39 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D70 D71 D72 D73 D74 D75 D76 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D9 D91 D93 D94 D95 DAA DAD DAY DB DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DU DWT DX DZN DZP E01 E07 E08 E09 E10 E11 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GRT GT GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H78 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAR HBA HBX HC HDW HEA HGM HH HIU HJ HKM HLT HM HMQ HMT HN HP HPA HTZ HUR IA IE INH INK INQ ISD IU IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J89 J90 J91 J92 J93 J94 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K24 K25 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K5 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWO KWT KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MLD MLT MMK MMQ MMT MND MON MPA MQH MQS MSK MTK MTQ MTR MTS MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NMI NMP NPR NPT NQ NR NT NTT NU NX OA ODE OHM ON ONZ OT OZ OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PT PTD PTI PTL Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q3 QA QAN QB QR QT QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SHT SIE SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPR TQD TRL TST TTS U1 U2 UA UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT WW X1 YDK YDQ YRD Z11 ZP ZZ X43 X44 X1A X1B X1D X1F X1G X1W X2C X3A X3H X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XOA XOB XOC XOD XOE XOF XOK XOT XOU XP2 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVN XVO XVP XVQ XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY XZZ ', concat(' ', normalize-space(@unitCode), ' '))))">
          <xsl:attribute name="id">BR-CL-23</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-23]-Unit code MUST be coded according to the UN/ECE Recommendation 20 with
      Rec 21 extension</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EmbeddedDocumentBinaryObject[@mimeCode]" mode="M11" priority="1001">
    <svrl:fired-rule context="cbc:EmbeddedDocumentBinaryObject[@mimeCode]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((@mimeCode = 'application/pdf' or @mimeCode = 'image/png' or @mimeCode = 'image/jpeg' or @mimeCode = 'text/csv' or @mimeCode = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or @mimeCode = 'application/vnd.oasis.opendocument.spreadsheet'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((@mimeCode = 'application/pdf' or @mimeCode = 'image/png' or @mimeCode = 'image/jpeg' or @mimeCode = 'text/csv' or @mimeCode = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' or @mimeCode = 'application/vnd.oasis.opendocument.spreadsheet'))">
          <xsl:attribute name="id">BR-CL-24</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-24]-For Mime code in attribute use MIMEMediaType.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID]" mode="M11" priority="1000">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0190 0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204 9901 9902 9904 9905 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9956 9957 9958 AN AQ AS AU EM ', concat(' ', normalize-space(@schemeID), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0190 0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204 9901 9902 9904 9905 9906 9907 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9956 9957 9958 AN AQ AS AU EM ', concat(' ', normalize-space(@schemeID), ' '))))">
          <xsl:attribute name="id">BR-CL-25</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-25]-Endpoint identifier scheme identifier MUST belong to the CEF EAS code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M11" priority="-1" />
  <xsl:template match="@*|node()" mode="M11" priority="-2">
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

<!--PATTERN UBL-model-->


	<!--RULE -->
<xsl:template match="cac:AdditionalDocumentReference" mode="M12" priority="1066">
    <svrl:fired-rule context="cac:AdditionalDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:ID) != ''">
          <xsl:attribute name="id">BR-52</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-52]-Each Additional supporting document (BG-24) shall contain a Supporting document reference (BT-122).    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount " mode="M12" priority="1065">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount " />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((. > 0) and (exists(//cbc:DueDate) or exists(//cac:PaymentTerms/cbc:Note))) or (. &lt;= 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((. > 0) and (exists(//cbc:DueDate) or exists(//cac:PaymentTerms/cbc:Note))) or (. &lt;= 0)">
          <xsl:attribute name="id">BR-CO-25</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-25]-In case the Amount due for payment (BT-115) is positive, either the Payment due date (BT-9) or the Payment terms (BT-20) shall be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" mode="M12" priority="1064">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(@schemeID)">
          <xsl:attribute name="id">BR-63</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-63]-The Buyer electronic address (BT-49) shall have a Scheme identifier.    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" mode="M12" priority="1063">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Country/cbc:IdentificationCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Country/cbc:IdentificationCode) != ''">
          <xsl:attribute name="id">BR-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-11]-The Buyer postal address shall contain a Buyer country code (BT-55).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans/cac:CardAccount" mode="M12" priority="1062">
    <svrl:fired-rule context="cac:PaymentMeans/cac:CardAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(cbc:PrimaryAccountNumberID)>=4 and string-length(cbc:PrimaryAccountNumberID)&lt;=6" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(cbc:PrimaryAccountNumberID)>=4 and string-length(cbc:PrimaryAccountNumberID)&lt;=6">
          <xsl:attribute name="id">BR-51</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-51]-The last 4 to 6 digits of the Payment card primary account number (BT-87) shall be present if Payment card information (BG-18) is provided in the Invoice.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Delivery/cac:DeliveryLocation/cac:Address" mode="M12" priority="1061">
    <svrl:fired-rule context="cac:Delivery/cac:DeliveryLocation/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:Country/cbc:IdentificationCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Country/cbc:IdentificationCode)">
          <xsl:attribute name="id">BR-57</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-57]-Each Deliver to address (BG-15) shall contain a Deliver to country code (BT-80).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" mode="M12" priority="1060">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:Amount) " />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:Amount)">
          <xsl:attribute name="id">BR-31</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-31]-Each Document level allowance (BG-20) shall have a Document level allowance amount (BT-92).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">
          <xsl:attribute name="id">BR-32</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-32]-Each Document level allowance (BG-20) shall have a Document level allowance VAT category code (BT-95).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <xsl:attribute name="id">BR-33</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-33]-Each Document level allowance (BG-20) shall have a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="true()">
          <xsl:attribute name="id">BR-CO-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-05]-Document level allowance reason code (BT-98) and Document level allowance reason (BT-97) shall indicate the same type of allowance.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <xsl:attribute name="id">BR-CO-21</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-21]-Each Document level allowance (BG-20) shall contain a Document level allowance reason (BT-97) or a Document level allowance reason code (BT-98), or both.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-01]-The allowed maximum number of decimals for the Document level allowance amount (BT-92) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-02]-The allowed maximum number of decimals for the Document level allowance base amount (BT-93) is 2.    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" mode="M12" priority="1059">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:Amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:Amount)">
          <xsl:attribute name="id">BR-36</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-36]-Each Document level charge (BG-21) shall have a Document level charge amount (BT-99).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">
          <xsl:attribute name="id">BR-37</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-37]-Each Document level charge (BG-21) shall have a Document level charge VAT category code (BT-102).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <xsl:attribute name="id">BR-38</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-38]-Each Document level charge (BG-21) shall have a Document level charge reason (BT-104) or a Document level charge reason code (BT-105).    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="true()">
          <xsl:attribute name="id">BR-CO-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-06]-Document level charge reason code (BT-105) and Document level charge reason (BT-104) shall indicate the same type of charge.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <xsl:attribute name="id">BR-CO-22</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-22]-Each Document level charge (BG-21) shall contain a Document level charge reason (BT-104) or a Document level charge reason code (BT-105), or both.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-05]-The allowed maximum number of decimals for the Document level charge amount (BT-99) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-06]-The allowed maximum number of decimals for the Document level charge base amount (BT-100) is 2.    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:LegalMonetaryTotal" mode="M12" priority="1058">
    <svrl:fired-rule context="cac:LegalMonetaryTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:LineExtensionAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:LineExtensionAmount)">
          <xsl:attribute name="id">BR-12</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-12]-An Invoice shall have the Sum of Invoice line net amount (BT-106).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxExclusiveAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxExclusiveAmount)">
          <xsl:attribute name="id">BR-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-13]-An Invoice shall have the Invoice total amount without VAT (BT-109).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxInclusiveAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxInclusiveAmount)">
          <xsl:attribute name="id">BR-14</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-14]-An Invoice shall have the Invoice total amount with VAT (BT-112).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:PayableAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:PayableAmount)">
          <xsl:attribute name="id">BR-15</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-15]-An Invoice shall have the Amount due for payment (BT-115).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:LineExtensionAmount) = (round(sum(//(cac:InvoiceLine|cac:CreditNoteLine)/xs:decimal(cbc:LineExtensionAmount)) * 10 * 10) div 100))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:LineExtensionAmount) = (round(sum(//(cac:InvoiceLine|cac:CreditNoteLine)/xs:decimal(cbc:LineExtensionAmount)) * 10 * 10) div 100))">
          <xsl:attribute name="id">BR-CO-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-10]-Sum of Invoice line net amount (BT-106) = Σ Invoice line net amount (BT-131).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(cbc:AllowanceTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or  (not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(cbc:AllowanceTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or (not(cbc:AllowanceTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=false()]))">
          <xsl:attribute name="id">BR-CO-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-11]-Sum of allowances on document level (BT-107) = Σ Document level allowance amount (BT-92).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(cbc:ChargeTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or (not(cbc:ChargeTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(cbc:ChargeTotalAmount) = (round(sum(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]/xs:decimal(cbc:Amount)) * 10 * 10) div 100) or (not(cbc:ChargeTotalAmount) and not(../cac:AllowanceCharge[cbc:ChargeIndicator=true()]))">
          <xsl:attribute name="id">BR-CO-12</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-12]-Sum of charges on document level (BT-108) = Σ Document level charge amount (BT-99).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = xs:decimal(cbc:LineExtensionAmount)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 )) or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) - xs:decimal(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = round((xs:decimal(cbc:LineExtensionAmount) + xs:decimal(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (xs:decimal(cbc:TaxExclusiveAmount) = xs:decimal(cbc:LineExtensionAmount)))">
          <xsl:attribute name="id">BR-CO-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-13]-Invoice total amount without VAT (BT-109) = Σ Invoice line net amount (BT-131) - Sum of allowances on document level (BT-107) + Sum of charges on document level (BT-108).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:PrepaidAmount) and not(xs:decimal(cbc:PayableRoundingAmount)) and (xs:decimal(cbc:PayableAmount) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(xs:decimal(cbc:PrepaidAmount)) and not(xs:decimal(cbc:PayableRoundingAmount)) and xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)) or (xs:decimal(cbc:PrepaidAmount) and xs:decimal(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(xs:decimal(cbc:PrepaidAmount)) and xs:decimal(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = xs:decimal(cbc:TaxInclusiveAmount))) " />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:PrepaidAmount) and not(xs:decimal(cbc:PayableRoundingAmount)) and (xs:decimal(cbc:PayableAmount) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(xs:decimal(cbc:PrepaidAmount)) and not(xs:decimal(cbc:PayableRoundingAmount)) and xs:decimal(cbc:PayableAmount) = xs:decimal(cbc:TaxInclusiveAmount)) or (xs:decimal(cbc:PrepaidAmount) and xs:decimal(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = (round((xs:decimal(cbc:TaxInclusiveAmount) - xs:decimal(cbc:PrepaidAmount)) * 10 * 10) div 100))) or (not(xs:decimal(cbc:PrepaidAmount)) and xs:decimal(cbc:PayableRoundingAmount) and ((round((xs:decimal(cbc:PayableAmount) - xs:decimal(cbc:PayableRoundingAmount)) * 10 * 10) div 100) = xs:decimal(cbc:TaxInclusiveAmount)))">
          <xsl:attribute name="id">BR-CO-16</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-16]-Amount due for payment (BT-115) = Invoice total amount with VAT (BT-112) -Paid amount (BT-113) +Rounding amount (BT-114).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-09]-The allowed maximum number of decimals for the Sum of Invoice line net amount (BT-106) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-10]-The allowed maximum number of decimals for the Sum of allowanced on document level (BT-107) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:ChargeTotalAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:ChargeTotalAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-11]-The allowed maximum number of decimals for the Sum of charges on document level (BT-108) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-12</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-12]-The allowed maximum number of decimals for the Invoice total amount without VAT (BT-109) is 2.    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-14</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-14]-The allowed maximum number of decimals for the Invoice total amount with VAT (BT-112) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-16</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-16]-The allowed maximum number of decimals for the Paid amount (BT-113) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:PayableRoundingAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:PayableRoundingAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-17</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-17]-The allowed maximum number of decimals for the Rounding amount (BT-114) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:PayableAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:PayableAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-18</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-18]-The allowed maximum number of decimals for the Amount due for payment (BT-115) is 2.  </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M12" priority="1057">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:CustomizationID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:CustomizationID) != ''">
          <xsl:attribute name="id">BR-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-01]-An Invoice shall have a Specification identifier (BT-24).   </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:ID) !=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:ID) !=''">
          <xsl:attribute name="id">BR-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-02]-An Invoice shall have an Invoice number (BT-1).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:IssueDate) !=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:IssueDate) !=''">
          <xsl:attribute name="id">BR-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-03]-An Invoice shall have an Invoice issue date (BT-2).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:InvoiceTypeCode) !='' or (cbc:CreditNoteTypeCode) !=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:InvoiceTypeCode) !='' or (cbc:CreditNoteTypeCode) !=''">
          <xsl:attribute name="id">BR-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-04]-An Invoice shall have an Invoice type code (BT-3).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:DocumentCurrencyCode) !=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:DocumentCurrencyCode) !=''">
          <xsl:attribute name="id">BR-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-05]-An Invoice shall have an Invoice currency code (BT-5).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''">
          <xsl:attribute name="id">BR-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-06]-An Invoice shall contain the Seller name (BT-27).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''">
          <xsl:attribute name="id">BR-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-07]-An Invoice shall contain the Buyer name (BT-44).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress)">
          <xsl:attribute name="id">BR-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-08]-An Invoice shall contain the Seller postal address. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress)">
          <xsl:attribute name="id">BR-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-10]-An Invoice shall contain the Buyer postal address (BG-8).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:InvoiceLine) or exists(cac:CreditNoteLine)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:InvoiceLine) or exists(cac:CreditNoteLine)">
          <xsl:attribute name="id">BR-16</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-16]-An Invoice shall have at least one Invoice line (BG-25)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency])" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency])">
          <xsl:attribute name="id">BR-53</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-53]-If the VAT accounting currency code (BT-6) is present, then the Invoice total VAT amount in accounting currency (BT-111) shall be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PaymentMeans/cac:CardAccount) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PaymentMeans/cac:CardAccount) &lt;= 1">
          <xsl:attribute name="id">BR-66</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-66]-An Invoice shall contain maximum one Payment Card account (BG-18).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PaymentMeans/cac:PaymentMandate) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PaymentMeans/cac:PaymentMandate) &lt;= 1">
          <xsl:attribute name="id">BR-67</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-67]-An Invoice shall contain maximum one Payment Mandate (BG-19).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']))">
          <xsl:attribute name="id">BR-AE-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-AE-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Reverse charge" shall contain in the VAT Breakdown (BG-23) exactly one VAT category code (BT-118) equal with "VAT reverse charge".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-AE-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-AE-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-AE-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-AE-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-AE-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-AE-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) and/or the Buyer legal registration identifier (BT-47).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and exists(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and exists(cac:InvoicePeriod/cbc:DescriptionCode)) or (not(cbc:TaxPointDate) and not(cac:InvoicePeriod/cbc:DescriptionCode))">
          <xsl:attribute name="id">BR-CO-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-03]-Value added tax point date (BT-7) and Value added tax point date code (BT-8) are mutually exclusive.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $Currency in cbc:DocumentCurrencyCode satisfies (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount) = round( (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount) + cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) * 10 * 10) div 100)" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $Currency in cbc:DocumentCurrencyCode satisfies (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxInclusiveAmount) = round( (cac:LegalMonetaryTotal/xs:decimal(cbc:TaxExclusiveAmount) + cac:TaxTotal/xs:decimal(cbc:TaxAmount[@currencyID=$Currency])) * 10 * 10) div 100)">
          <xsl:attribute name="id">BR-CO-15</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-15]-Invoice total amount with VAT (BT-112) = Invoice total amount without VAT (BT-109) + Invoice total VAT amount (BT-110).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxTotal/cac:TaxSubtotal)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxTotal/cac:TaxSubtotal)">
          <xsl:attribute name="id">BR-CO-18</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-18]-An Invoice shall at least have one VAT breakdown group (BG-23).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode]))">
          <xsl:attribute name="id">BR-DEC-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-13]-The allowed maximum number of decimals for the Invoice total VAT amount (BT-110) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode]))">
          <xsl:attribute name="id">BR-DEC-15</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-15]-The allowed maximum number of decimals for the Invoice total VAT amount in accounting currency (BT-111) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'E']))">
          <xsl:attribute name="id">BR-E-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-E-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Exempt from VAT" shall contain exactly one VAT breakdown (BG-23) with the VAT category code (BT-118) equal to "Exempt from VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-E-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-E-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-E-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-E-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-E-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-E-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'G']))">
          <xsl:attribute name="id">BR-G-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-G-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Export outside the EU" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Export outside the EU".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-G-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-G-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-G-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-G-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-G-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-G-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))">
          <xsl:attribute name="id">BR-IC-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IC-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Intra-community supply" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Intra-community supply".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])">
          <xsl:attribute name="id">BR-IC-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IC-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-IC-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IC-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)) and (exists(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-IC-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IC-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" shall contain the Seller VAT Identifier (BT-31) or the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K'])  and (string-length(cac:Delivery/cbc:ActualDeliveryDate) > 1 or (cac:InvoicePeriod/*))) or (not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) and (string-length(cac:Delivery/cbc:ActualDeliveryDate) > 1 or (cac:InvoicePeriod/*))) or (not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))">
          <xsl:attribute name="id">BR-IC-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IC-11]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Actual delivery date (BT-72) or the Invoicing period (BG-14) shall not be blank.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) and (string-length(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode) >1)) or (not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']) and (string-length(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode) >1)) or (not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'K']))">
          <xsl:attribute name="id">BR-IC-12</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IC-12]-In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Deliver to country code (BT-80) shall not be blank.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'L']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'L']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0)">
          <xsl:attribute name="id">BR-IG-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IG-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "IGIC" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IGIC".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-IG-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IG-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-IG-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IG-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[cbc:ID='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[cbc:ID='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-IG-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IG-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cbc:ID = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0)">
          <xsl:attribute name="id">BR-IP-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IP-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "IPSI" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "IPSI".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-IP-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IP-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-IP-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IP-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-IP-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IP-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" shall contain the Seller VAT Identifier (BT-31), the Seller Tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']))">
          <xsl:attribute name="id">BR-O-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Not subject to VAT" shall contain exactly one VAT breakdown group (BG-23) with the VAT category code (BT-118) equal to "Not subject to VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'])">
          <xsl:attribute name="id">BR-O-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Not subject to VAT" shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-O-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Not subject to VAT" shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (not(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID) and not(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists((/ubl:Invoice|/cn:CreditNote)/cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-O-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Not subject to VAT" shall not contain the Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) or the Buyer VAT identifier (BT-48).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])">
          <xsl:attribute name="id">BR-O-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-11]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain other VAT breakdown groups (BG-23).    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])">
          <xsl:attribute name="id">BR-O-12</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-12]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is not "Not subject to VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])">
          <xsl:attribute name="id">BR-O-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-13]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain Document level allowances (BG-20) where Document level allowance VAT category code (BT-95) is not "Not subject to VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O']) and count(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) != 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) = 0) or not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'O'])">
          <xsl:attribute name="id">BR-O-14</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-14]-An Invoice that contains a VAT breakdown group (BG-23) with a VAT category code (BT-118) "Not subject to VAT" shall not contain Document level charges (BG-21) where Document level charge VAT category code (BT-102) is not "Not subject to VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) = 0)">
          <xsl:attribute name="id">BR-S-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-S-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Standard rated" shall contain in the VAT breakdown (BG-23) at least one VAT category code (BT-118) equal with "Standard rated".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S']))">
          <xsl:attribute name="id">BR-S-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-S-02]-An Invoice that contains an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-S-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-S-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-S-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-S-04]-An Invoice that contains a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']))">
          <xsl:attribute name="id">BR-Z-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-Z-01]-An Invoice that contains an Invoice line (BG-25), a Document level allowance (BG-20) or a Document level charge (BG-21) where the VAT category code (BT-151, BT-95 or BT-102) is "Zero rated" shall contain in the VAT breakdown (BG-23) exactly one VAT category code (BT-118) equal with "Zero rated".    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-Z-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-Z-02]-An Invoice that contains an Invoice line where the Invoiced item VAT category code (BT-151) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-Z-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-Z-03]-An Invoice that contains a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']) and (exists(//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)or exists(//cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID))) or not(exists(//cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']))">
          <xsl:attribute name="id">BR-Z-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-Z-04]-An Invoice that contains a Document level charge where the Document level charge VAT category code (BT-102) is "Zero rated" shall contain the Seller VAT Identifier (BT-31), the Seller tax registration identifier (BT-32) and/or the Seller tax representative VAT identifier (BT-63).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M12" priority="1056">
    <svrl:fired-rule context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:ID) != ''">
          <xsl:attribute name="id">BR-21</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-21]-Each Invoice line (BG-25) shall have an Invoice line identifier (BT-126).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:InvoicedQuantity) or exists(cbc:CreditedQuantity)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:InvoicedQuantity) or exists(cbc:CreditedQuantity)">
          <xsl:attribute name="id">BR-22</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-22]-Each Invoice line (BG-25) shall have an Invoiced quantity (BT-129).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:InvoicedQuantity/@unitCode) or exists(cbc:CreditedQuantity/@unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:InvoicedQuantity/@unitCode) or exists(cbc:CreditedQuantity/@unitCode)">
          <xsl:attribute name="id">BR-23</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-23]-An Invoice line (BG-25) shall have an Invoiced quantity unit of measure code (BT-130).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:LineExtensionAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:LineExtensionAmount)">
          <xsl:attribute name="id">BR-24</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-24]-Each Invoice line (BG-25) shall have an Invoice line net amount (BT-131).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Item/cbc:Name) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Item/cbc:Name) != ''">
          <xsl:attribute name="id">BR-25</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-25]-Each Invoice line (BG-25) shall contain the Item name (BT-153).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:Price/cbc:PriceAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Price/cbc:PriceAmount)">
          <xsl:attribute name="id">BR-26</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-26]-Each Invoice line (BG-25) shall contain the Item net price (BT-146).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Price/cbc:PriceAmount) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Price/cbc:PriceAmount) >= 0">
          <xsl:attribute name="id">BR-27</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-27]-The Item net price (BT-146) shall NOT be negative.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Price/cac:AllowanceCharge/cbc:BaseAmount) >= 0 or not(exists(cac:Price/cac:AllowanceCharge/cbc:BaseAmount))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Price/cac:AllowanceCharge/cbc:BaseAmount) >= 0 or not(exists(cac:Price/cac:AllowanceCharge/cbc:BaseAmount))">
          <xsl:attribute name="id">BR-28</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-28]-The Item gross price (BT-148) shall NOT be negative.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/(normalize-space(upper-case(cbc:ID))='VAT')]/cbc:ID)">
          <xsl:attribute name="id">BR-CO-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-04]-Each Invoice line (BG-25) shall be categorized with an Invoiced item VAT category code (BT-151).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-23</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-23]-The allowed maximum number of decimals for the Invoice line net amount (BT-131) is 2.    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" mode="M12" priority="1055">
    <svrl:fired-rule context="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:Amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:Amount)">
          <xsl:attribute name="id">BR-41</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-41]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance amount (BT-136).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <xsl:attribute name="id">BR-42</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-42]-Each Invoice line allowance (BG-27) shall have an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="true()">
          <xsl:attribute name="id">BR-CO-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-07]-Invoice line allowance reason code (BT-140) and Invoice line allowance reason (BT-139) shall indicate the same type of allowance reason.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <xsl:attribute name="id">BR-CO-23</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-23]-Each Invoice line allowance (BG-27) shall contain an Invoice line allowance reason (BT-139) or an Invoice line allowance reason code (BT-140), or both.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-24</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-24]-The allowed maximum number of decimals for the Invoice line allowance amount (BT-136) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-25</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-25]-The allowed maximum number of decimals for the Invoice line allowance base amount (BT-137) is 2.    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" mode="M12" priority="1054">
    <svrl:fired-rule context="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:Amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:Amount)">
          <xsl:attribute name="id">BR-43</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-43]-Each Invoice line charge (BG-28) shall have an Invoice line charge amount (BT-141).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <xsl:attribute name="id">BR-44</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-44]-Each Invoice line charge shall have an Invoice line charge reason or an invoice line allowance reason code. </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="true()">
          <xsl:attribute name="id">BR-CO-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-08]-Invoice line charge reason code (BT-145) and Invoice line charge reason (BT144) shall indicate the same type of charge reason.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <xsl:attribute name="id">BR-CO-24</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-24]-Each Invoice line charge (BG-28) shall contain an Invoice line charge reason (BT-144) or an Invoice line charge reason code (BT-145), or both.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-27</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-27]-The allowed maximum number of decimals for the Invoice line charge amount (BT-141) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-28</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-28]-The allowed maximum number of decimals for the Invoice line charge base amount (BT-142) is 2.    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:InvoicePeriod | cac:CreditNoteLine/cac:InvoicePeriod" mode="M12" priority="1053">
    <svrl:fired-rule context="cac:InvoiceLine/cac:InvoicePeriod | cac:CreditNoteLine/cac:InvoicePeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) >= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) >= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))">
          <xsl:attribute name="id">BR-30</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-30]-If both Invoice line period start date (BT-134) and Invoice line period end date (BT-135) are given then the Invoice line period end date (BT-135) shall be later or equal to the Invoice line period start date (BT-134).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:StartDate) or exists(cbc:EndDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:StartDate) or exists(cbc:EndDate)">
          <xsl:attribute name="id">BR-CO-20</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-20]-If Invoice line period (BG-26) is used, the Invoice line period start date (BT-134) or the Invoice line period end date (BT-135) shall be filled, or both.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoicePeriod" mode="M12" priority="1052">
    <svrl:fired-rule context="cac:InvoicePeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) >= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cbc:EndDate) and exists(cbc:StartDate) and xs:date(cbc:EndDate) >= xs:date(cbc:StartDate)) or not(exists(cbc:StartDate)) or not(exists(cbc:EndDate))">
          <xsl:attribute name="id">BR-29</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-29]-If both Invoicing period start date (BT-73) and Invoicing period end date (BT-74) are given then the Invoicing period end date (BT-74) shall be later or equal to the Invoicing period start date (BT-73).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:StartDate) or exists(cbc:EndDate) or (exists(cbc:DescriptionCode) and not(exists(cbc:StartDate)) and not(exists(cbc:EndDate)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:StartDate) or exists(cbc:EndDate) or (exists(cbc:DescriptionCode) and not(exists(cbc:StartDate)) and not(exists(cbc:EndDate)))">
          <xsl:attribute name="id">BR-CO-19</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-19]-If Invoicing period (BG-14) is used, the Invoicing period start date (BT-73) or the Invoicing period end date (BT-74) shall be filled, or both.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:AdditionalItemProperty" mode="M12" priority="1051">
    <svrl:fired-rule context="//cac:AdditionalItemProperty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:Name) and exists(cbc:Value)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:Name) and exists(cbc:Value)">
          <xsl:attribute name="id">BR-54</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-54]-Each Item attribute (BG-32) shall contain an Item attribute name (BT-160) and an Item attribute value (BT-161).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode | cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode " mode="M12" priority="1050">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode | cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode " />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(@listID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(@listID)">
          <xsl:attribute name="id">BR-65</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-65]-The Item classification identifier (BT-158) shall have a Scheme identifier.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ID | cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:ID" mode="M12" priority="1049">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ID | cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(@schemeID)">
          <xsl:attribute name="id">BR-64</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-64]-The Item standard identifier (BT-157) shall have a Scheme identifier.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:Note | /cn:CreditNote/cbc:Note" mode="M12" priority="1048">
    <svrl:fired-rule context="/ubl:Invoice/cbc:Note | /cn:CreditNote/cbc:Note" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(contains(.,'#') and string-length(substring-before(substring-after(.,'#'),'#'))=3 and ( ( contains(' AAA AAB AAC AAD AAE AAF AAG AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABZ ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACM ACN ACO ACP ACQ ACR ACS ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADH ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADS ADT ADU ADV ADW ADX ADY ADZ AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHW AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ARR ARS AUT AUU AUV AUW AUX AUY AUZ AVA AVB AVC AVD AVE AVF BAG BAH BAI BAJ BAK BAL BAM BAN BAO BAP BAQ BAR BAS BLC BLD BLE BLF BLG BLH BLI BLJ BLK BLL BLM BLN BLO BLP BLQ BLR BLS BLT BLU BLV BLW BLX BLY BLZ BMA BMB BMC BMD BME CCI CEX CHG CIP CLP CLR COI CUR CUS DAR DCL DEL DIN DOC DUT EUR FBC GBL GEN GS7 HAN HAZ ICN IIN IMI IND INS INV IRP ITR ITS LAN LIN LOI MCO MDH MKS ORI OSI PAC PAI PAY PKG PKT PMD PMT PRD PRF PRI PUR QIN QQD QUT RAH REG RET REV RQR SAF SIC SIN SLR SPA SPG SPH SPP SPT SRN SSR SUR TCA TDT TRA TRR TXD WHI ZZZ ',substring-before(substring-after(.,'#'),'#') ) ) )) or not(contains(.,'#')) or not(string-length(substring-before(substring-after(.,'#'),'#'))=3)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(contains(.,'#') and string-length(substring-before(substring-after(.,'#'),'#'))=3 and ( ( contains(' AAA AAB AAC AAD AAE AAF AAG AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABZ ACA ACB ACC ACD ACE ACF ACG ACH ACI ACJ ACK ACL ACM ACN ACO ACP ACQ ACR ACS ACT ACU ACV ACW ACX ACY ACZ ADA ADB ADC ADD ADE ADF ADG ADH ADI ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADS ADT ADU ADV ADW ADX ADY ADZ AEA AEB AEC AED AEE AEF AEG AEH AEI AEJ AEK AEL AEM AEN AEO AEP AEQ AER AES AET AEU AEV AEW AEX AEY AEZ AFA AFB AFC AFD AFE AFF AFG AFH AFI AFJ AFK AFL AFM AFN AFO AFP AFQ AFR AFS AFT AFU AFV AFW AFX AFY AFZ AGA AGB AGC AGD AGE AGF AGG AGH AGI AGJ AGK AGL AGM AGN AGO AGP AGQ AGR AGS AGT AGU AGV AGW AGX AGY AGZ AHA AHB AHC AHD AHE AHF AHG AHH AHI AHJ AHK AHL AHM AHN AHO AHP AHQ AHR AHS AHT AHU AHV AHW AHX AHY AHZ AIA AIB AIC AID AIE AIF AIG AIH AII AIJ AIK AIL AIM AIN AIO AIP AIQ AIR AIS AIT AIU AIV AIW AIX AIY AIZ AJA AJB ALC ALD ALE ALF ALG ALH ALI ALJ ALK ALL ALM ALN ALO ALP ALQ ARR ARS AUT AUU AUV AUW AUX AUY AUZ AVA AVB AVC AVD AVE AVF BAG BAH BAI BAJ BAK BAL BAM BAN BAO BAP BAQ BAR BAS BLC BLD BLE BLF BLG BLH BLI BLJ BLK BLL BLM BLN BLO BLP BLQ BLR BLS BLT BLU BLV BLW BLX BLY BLZ BMA BMB BMC BMD BME CCI CEX CHG CIP CLP CLR COI CUR CUS DAR DCL DEL DIN DOC DUT EUR FBC GBL GEN GS7 HAN HAZ ICN IIN IMI IND INS INV IRP ITR ITS LAN LIN LOI MCO MDH MKS ORI OSI PAC PAI PAY PKG PKT PMD PMT PRD PRF PRI PUR QIN QQD QUT RAH REG RET REV RQR SAF SIC SIN SLR SPA SPG SPH SPP SPT SRN SSR SUR TCA TDT TRA TRR TXD WHI ZZZ ',substring-before(substring-after(.,'#'),'#') ) ) )) or not(contains(.,'#')) or not(string-length(substring-before(substring-after(.,'#'),'#'))=3)">
          <xsl:attribute name="id">BR-CL-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CL-08]-Invoiced note subject code shall be coded using UNCL4451</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PayeeParty" mode="M12" priority="1047">
    <svrl:fired-rule context="cac:PayeeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:PartyName/cbc:Name) and (not(cac:PartyName/cbc:Name = ../cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name) and not(cac:PartyIdentification/cbc:ID = ../cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:PartyName/cbc:Name) and (not(cac:PartyName/cbc:Name = ../cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name) and not(cac:PartyIdentification/cbc:ID = ../cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) )">
          <xsl:attribute name="id">BR-17</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-17]-The Payee name (BT-59) shall be provided in the Invoice, if the Payee (BG-10) is different from the Seller (BG-4)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount" mode="M12" priority="1046">
    <svrl:fired-rule context="cac:PaymentMeans[cbc:PaymentMeansCode='30' or cbc:PaymentMeansCode='58']/cac:PayeeFinancialAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:ID) != ''">
          <xsl:attribute name="id">BR-50</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-50]-A Payment account identifier (BT-84) shall be present if Credit transfer (BG-17) information is provided in the Invoice.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans" mode="M12" priority="1045">
    <svrl:fired-rule context="cac:PaymentMeans" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:PaymentMeansCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:PaymentMeansCode)">
          <xsl:attribute name="id">BR-49</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-49]-A Payment instruction (BG-16) shall specify the Payment means type code (BT-81).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(cac:PayeeFinancialAccount/cbc:ID) and ((normalize-space(cbc:PaymentMeansCode) = '30') or (normalize-space(cbc:PaymentMeansCode) = '58') )) or ((normalize-space(cbc:PaymentMeansCode) != '30') and (normalize-space(cbc:PaymentMeansCode) != '58'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(cac:PayeeFinancialAccount/cbc:ID) and ((normalize-space(cbc:PaymentMeansCode) = '30') or (normalize-space(cbc:PaymentMeansCode) = '58') )) or ((normalize-space(cbc:PaymentMeansCode) != '30') and (normalize-space(cbc:PaymentMeansCode) != '58'))">
          <xsl:attribute name="id">BR-61</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-61]-If the Payment means type code (BT-81) means SEPA credit transfer, Local credit transfer or Non-SEPA international credit transfer, the Payment account identifier (BT-84) shall be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:BillingReference" mode="M12" priority="1044">
    <svrl:fired-rule context="cac:BillingReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:InvoiceDocumentReference/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:InvoiceDocumentReference/cbc:ID)">
          <xsl:attribute name="id">BR-55</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-55]-Each Preceding Invoice reference (BG-3) shall contain a Preceding Invoice reference (BT-25).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty" mode="M12" priority="1043">
    <svrl:fired-rule context="cac:AccountingSupplierParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:CompanyID) or exists(cac:Party/cac:PartyIdentification/cbc:ID) or exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:CompanyID) or exists(cac:Party/cac:PartyIdentification/cbc:ID) or exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID)">
          <xsl:attribute name="id">BR-CO-26</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-26]-In order for the buyer to automatically identify a supplier, the Seller identifier (BT-29), the Seller legal registration identifier (BT-30) and/or the Seller VAT identifier (BT-31) shall be present.  </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" mode="M12" priority="1042">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(@schemeID)">
          <xsl:attribute name="id">BR-62</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-62]-The Seller electronic address (BT-34) shall have a Scheme identifier.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" mode="M12" priority="1041">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Country/cbc:IdentificationCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Country/cbc:IdentificationCode) != ''">
          <xsl:attribute name="id">BR-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-09]-The Seller postal address (BG-5) shall contain a Seller country code (BT-40).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxRepresentativeParty" mode="M12" priority="1040">
    <svrl:fired-rule context="cac:TaxRepresentativeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:PartyName/cbc:Name) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:PartyName/cbc:Name) != ''">
          <xsl:attribute name="id">BR-18</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-18]-The Seller tax representative name (BT-62) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:PostalAddress)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:PostalAddress)">
          <xsl:attribute name="id">BR-19</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-19]-The Seller tax representative postal address (BG-12) shall be provided in the Invoice, if the Seller (BG-4) has a Seller tax representative party (BG-11).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:PartyTaxScheme[cac:TaxScheme/(normalize-space(upper-case(cbc:ID)) = 'VAT')]/cbc:CompanyID)">
          <xsl:attribute name="id">BR-56</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-56]-Each Seller tax representative party (BG-11) shall have a Seller tax representative VAT identifier (BT-63).    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxRepresentativeParty/cac:PostalAddress" mode="M12" priority="1039">
    <svrl:fired-rule context="cac:TaxRepresentativeParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Country/cbc:IdentificationCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Country/cbc:IdentificationCode) != ''">
          <xsl:attribute name="id">BR-20</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-20]-The Seller tax representative postal address (BG-12) shall contain a Tax representative country code (BT-69), if the Seller (BG-4) has a Seller tax representative party (BG-11).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:Taxtotal" mode="M12" priority="1038">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal | /cn:CreditNote/cac:Taxtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(child::cbc:TaxAmount)= round((sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount)) * 10 * 10)) div 100) or not(cac:TaxSubtotal)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(child::cbc:TaxAmount)= round((sum(cac:TaxSubtotal/xs:decimal(cbc:TaxAmount)) * 10 * 10)) div 100) or not(cac:TaxSubtotal)">
          <xsl:attribute name="id">BR-CO-14</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-14]-Invoice total VAT amount (BT-110) = Σ VAT category tax amount (BT-117).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxTotal/cac:TaxSubtotal" mode="M12" priority="1037">
    <svrl:fired-rule context="cac:TaxTotal/cac:TaxSubtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxableAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxableAmount)">
          <xsl:attribute name="id">BR-45</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-45]-Each VAT breakdown (BG-23) shall have a VAT category taxable amount (BT-116).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxAmount)">
          <xsl:attribute name="id">BR-46</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-46]-Each VAT breakdown (BG-23) shall have a VAT category tax amount (BT-117).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">
          <xsl:attribute name="id">BR-47</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-47]-Each VAT breakdown (BG-23) shall be defined through a VAT category code (BT-118).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O')" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent) or (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/normalize-space(cbc:ID)='O')">
          <xsl:attribute name="id">BR-48</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-48]-Each VAT breakdown (BG-23) shall have a VAT category rate (BT-119), except if the Invoice is not subject to VAT.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) != 0 and ((abs(xs:decimal(cbc:TaxAmount)) - 1 &lt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(cbc:TaxAmount)) + 1 > round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 )))  or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) = 0 and (round(xs:decimal(cbc:TaxAmount)) = 0)) or (round(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent)) != 0 and ((abs(xs:decimal(cbc:TaxAmount)) - 1 &lt; round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ) and (abs(xs:decimal(cbc:TaxAmount)) + 1 > round(abs(xs:decimal(cbc:TaxableAmount)) * (cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent) div 100) * 10 * 10) div 100 ))) or (not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/xs:decimal(cbc:Percent))) and (round(xs:decimal(cbc:TaxAmount)) = 0))">
          <xsl:attribute name="id">BR-CO-17</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-17]-VAT category tax amount (BT-117) = VAT category taxable amount (BT-116) x (VAT category rate (BT-119) / 100), rounded to two decimals.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-19</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-19]-The allowed maximum number of decimals for the VAT category taxable amount (BT-116) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-20</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-DEC-20]-The allowed maximum number of decimals for the VAT category tax amount (BT-117) is 2.    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1036">
    <svrl:fired-rule context="//cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( contains( 'AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW',substring(cbc:CompanyID,1,2) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( contains( 'AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW',substring(cbc:CompanyID,1,2) ) )">
          <xsl:attribute name="id">BR-CO-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-CO-09]-The Seller VAT identifier (BT-31), the Seller tax representative VAT identifier (BT-63) and the Buyer VAT identifier (BT-48) shall have a prefix in accordance with ISO code ISO 3166-1 alpha-2 by which the country of issue may be identified. Nevertheless, Greece may use the prefix ‘EL’.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1035">
    <svrl:fired-rule context="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">BR-AE-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-AE-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Reverse charge".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../cbc:TaxAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../cbc:TaxAmount = 0">
          <xsl:attribute name="id">BR-AE-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-AE-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Reverse charge" shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )">
          <xsl:attribute name="id">BR-AE-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-AE-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Reverse charge" shall have a VAT exemption reason code (BT-121), meaning "Reverse charge" or the VAT exemption reason text (BT-120) "Reverse charge" (or the equivalent standard text in another language).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1034">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-AE-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-AE-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Reverse charge" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1033">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-AE-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-AE-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Reverse charge" the Document level charge VAT rate (BT-103) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1032">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-AE-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-AE-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Reverse charge" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1031">
    <svrl:fired-rule context="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">BR-E-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-E-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Exempt from VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Exempt from VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../cbc:TaxAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../cbc:TaxAmount = 0">
          <xsl:attribute name="id">BR-E-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-E-09]-The VAT category tax amount (BT-117) In a VAT breakdown (BG-23) where the VAT category code (BT-118) equals "Exempt from VAT" shall equal 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">BR-E-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-E-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Exempt from VAT" shall have a VAT exemption reason code (BT-121) or a VAT exemption reason text (BT-120).    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1030">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-E-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-E-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Exempt from VAT", the Document level allowance VAT rate (BT-96) shall be 0 (zero).    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1029">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-E-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-E-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Exempt from VAT", the Document level charge VAT rate (BT-103) shall be 0 (zero).    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1028">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-E-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-E-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Exempt from VAT", the Invoiced item VAT rate (BT-152) shall be 0 (zero).    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1027">
    <svrl:fired-rule context="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='G']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">BR-G-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-G-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Export outside the EU".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../cbc:TaxAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../cbc:TaxAmount = 0">
          <xsl:attribute name="id">BR-G-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-G-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Export outside the EU" shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )">
          <xsl:attribute name="id">BR-G-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-G-10]-A VAT breakdown (BG-23) with the VAT Category code (BT-118) "Export outside the EU" shall have a VAT exemption reason code (BT-121), meaning "Export outside the EU" or the VAT exemption reason text (BT-120) "Export outside the EU" (or the equivalent standard text in another language).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1026">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-G-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-G-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Export outside the EU" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1025">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-G-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-G-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Export outside the EU" the Document level charge VAT rate (BT-103) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1024">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'G'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-G-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-G-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Export outside the EU" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1023">
    <svrl:fired-rule context="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='K']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">BR-IC-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IC-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Intra-community supply".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../cbc:TaxAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../cbc:TaxAmount = 0">
          <xsl:attribute name="id">BR-IC-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IC-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )">
          <xsl:attribute name="id">BR-IC-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IC-10]-A VAT breakdown (BG-23) with the VAT Category code (BT-118) "Intra-community supply" shall have a VAT exemption reason code (BT-121), meaning "Intra-community supply" or the VAT exemption reason text (BT-120) "Intra-community supply" (or the equivalent standard text in another language).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1022">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-IC-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IC-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Intra-community supply" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1021">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-IC-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IC-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Intra-community supply" the Document level charge VAT rate (BT-103) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1020">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'K'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-IC-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IC-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Intracommunity supply" the Invoiced item VAT rate (BT-152) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1019">
    <svrl:fired-rule context="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='L'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='L'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))">
          <xsl:attribute name="id">BR-IG-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IG-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IGIC", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IGIC" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(abs(xs:decimal(../cbc:TaxAmount - 1))&lt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount + 1))>  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )" />
      <xsl:otherwise>
        <svrl:failed-assert test="(abs(xs:decimal(../cbc:TaxAmount - 1))&lt; round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount + 1))> round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )">
          <xsl:attribute name="id">BR-IG-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IG-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IGIC" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">BR-IG-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IG-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "IGIC" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1018">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent) >= 0">
          <xsl:attribute name="id">BR-IG-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IG-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IGIC" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1017">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent) >= 0">
          <xsl:attribute name="id">BR-IG-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IG-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IGIC" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']| cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1016">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']| cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'L'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent) >= 0">
          <xsl:attribute name="id">BR-IG-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IG-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IGIC" the invoiced item VAT rate (BT-152) shall be 0 (zero) or greater than zero.    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1015">
    <svrl:fired-rule context="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='M'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='M'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))))">
          <xsl:attribute name="id">BR-IP-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IP-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "IPSI", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "IPSI" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(abs(xs:decimal(../cbc:TaxAmount - 1))&lt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount + 1))>  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )" />
      <xsl:otherwise>
        <svrl:failed-assert test="(abs(xs:decimal(../cbc:TaxAmount - 1))&lt; round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount + 1))> round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )">
          <xsl:attribute name="id">BR-IP-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IP-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "IPSI" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">BR-IP-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IP-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "IPSI" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).     </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1014">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent) >= 0">
          <xsl:attribute name="id">BR-IP-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IP-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "IPSI" the Document level allowance VAT rate (BT-96) shall be 0 (zero) or greater than zero.      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1013">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent) >= 0">
          <xsl:attribute name="id">BR-IP-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IP-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "IPSI" the Document level charge VAT rate (BT-103) shall be 0 (zero) or greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']| cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1012">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']| cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'M'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent) >= 0">
          <xsl:attribute name="id">BR-IP-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-IP-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "IPSI" the Invoiced item VAT rate (BT-152) shall be 0 (zero) or greater than zero.    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1011">
    <svrl:fired-rule context="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">BR-O-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-08]-In a VAT breakdown (BG-23) where the VAT category code (BT-118) is " Not subject to VAT" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amounts (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Not subject to VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../cbc:TaxAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../cbc:TaxAmount = 0">
          <xsl:attribute name="id">BR-O-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Not subject to VAT" shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or (exists(cbc:TaxExemptionReasonCode) )">
          <xsl:attribute name="id">BR-O-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) " Not subject to VAT" shall have a VAT exemption reason code (BT-121), meaning " Not subject to VAT" or a VAT exemption reason text (BT-120) " Not subject to VAT" (or the equivalent standard text in another language).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1010">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Percent)">
          <xsl:attribute name="id">BR-O-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-06]-A Document level allowance (BG-20) where VAT category code (BT-95) is "Not subject to VAT" shall not contain a Document level allowance VAT rate (BT-96).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1009">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Percent)">
          <xsl:attribute name="id">BR-O-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-07]-A Document level charge (BG-21) where the VAT category code (BT-102) is "Not subject to VAT" shall not contain a Document level charge VAT rate (BT-103).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1008">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Percent)">
          <xsl:attribute name="id">BR-O-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-O-05]-An Invoice line (BG-25) where the VAT category code (BT-151) is "Not subject to VAT" shall not contain an Invoiced item VAT rate (BT-152).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1007">
    <svrl:fired-rule context="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in xs:decimal(cbc:Percent) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in xs:decimal(cbc:Percent) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))))) or (exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and ((../xs:decimal(cbc:TaxableAmount - 1) &lt; (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)))) and (../xs:decimal(cbc:TaxableAmount + 1) > (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount))))))">
          <xsl:attribute name="id">BR-S-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-S-08]-For each different value of VAT category rate (BT-119) where the VAT category code (BT-118) is "Standard rated", the VAT category taxable amount (BT-116) in a VAT breakdown (BG-23) shall equal the sum of Invoice line net amounts (BT-131) plus the sum of document level charge amounts (BT-99) minus the sum of document level allowance amounts (BT-92) where the VAT category code (BT-151, BT-102, BT-95) is "Standard rated" and the VAT rate (BT-152, BT-103, BT-96) equals the VAT category rate (BT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt;  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 >  round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )" />
      <xsl:otherwise>
        <svrl:failed-assert test="(abs(xs:decimal(../cbc:TaxAmount)) - 1 &lt; round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ) and (abs(xs:decimal(../cbc:TaxAmount)) + 1 > round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 )">
          <xsl:attribute name="id">BR-S-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-S-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Standard rated" shall equal the VAT category taxable amount (BT-116) multiplied by the VAT category rate (BT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">BR-S-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-S-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Standard rate" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1006">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent) > 0">
          <xsl:attribute name="id">BR-S-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-S-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Standard rated" the Document level allowance VAT rate (BT-96) shall be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1005">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent) > 0">
          <xsl:attribute name="id">BR-S-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-S-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Standard rated" the Document level charge VAT rate (BT-103) shall be greater than zero.  </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1004">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent) > 0">
          <xsl:attribute name="id">BR-S-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-S-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Standard rated" the Invoiced item VAT rate (BT-152) shall be greater than zero.    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1003">
    <svrl:fired-rule context="/ubl:*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">BR-Z-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-Z-08]-In a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" the VAT category taxable amount (BT-116) shall equal the sum of Invoice line net amount (BT-131) minus the sum of Document level allowance amounts (BT-92) plus the sum of Document level charge amounts (BT-99) where the VAT category codes (BT-151, BT-95, BT-102) are "Zero rated".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../cbc:TaxAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../cbc:TaxAmount = 0">
          <xsl:attribute name="id">BR-Z-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-Z-09]-The VAT category tax amount (BT-117) in a VAT breakdown (BG-23) where VAT category code (BT-118) is "Zero rated" shall equal 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cbc:TaxExemptionReason) or (cbc:TaxExemptionReasonCode))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cbc:TaxExemptionReason) or (cbc:TaxExemptionReasonCode))">
          <xsl:attribute name="id">BR-Z-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-Z-10]-A VAT breakdown (BG-23) with VAT Category code (BT-118) "Zero rated" shall not have a VAT exemption reason code (BT-121) or VAT exemption reason text (BT-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1002">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-Z-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-Z-06]-In a Document level allowance (BG-20) where the Document level allowance VAT category code (BT-95) is "Zero rated" the Document level allowance VAT rate (BT-96) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1001">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-Z-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-Z-07]-In a Document level charge (BG-21) where the Document level charge VAT category code (BT-102) is "Zero rated" the Document level charge VAT rate (BT-103) shall be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1000">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:Percent = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:Percent = 0)">
          <xsl:attribute name="id">BR-Z-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-Z-05]-In an Invoice line (BG-25) where the Invoiced item VAT category code (BT-151) is "Zero rated" the Invoiced item VAT rate (BT-152) shall be 0 (zero).    </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>
</xsl:stylesheet>
