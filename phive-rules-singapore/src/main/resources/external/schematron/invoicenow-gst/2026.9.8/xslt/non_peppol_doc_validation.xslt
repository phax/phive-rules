<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:dh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:udt="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <!-- Created with ph-schematron version of ISO Schematron XSLTs. -->
<!-- Implementers: please note that overriding process-prolog or process-root is 
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
    <xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                       and namespace-uri() = namespace-uri(current())])" />
    <xsl:text>[</xsl:text>
    <xsl:value-of select="1 + $preceding" />
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
    <svrl:schematron-output schemaVersion="" title="Data submission to IRAS under InvoiceNow GST requirements v0.3.4">
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
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:ns-prefix-in-attribute-values prefix="dh" uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M10" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M11" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M12" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M13" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M14" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M15" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M16" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M17" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">credit_only</xsl:attribute>
        <xsl:attribute name="name">credit_only</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M18" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M19" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M20" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M21" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Data submission to IRAS under InvoiceNow GST requirements v0.3.4</svrl:text>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="dh:StandardBusinessDocumentHeader" mode="M10" priority="1000">
    <svrl:fired-rule context="dh:StandardBusinessDocumentHeader" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(dh:Sender/dh:Identifier) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(dh:Sender/dh:Identifier) != ''">
          <xsl:attribute name="id">IRASC5-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
      [IRASC5-001]-The SBDH envelope MUST have a Sender identifier.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(dh:Receiver/dh:Identifier) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(dh:Receiver/dh:Identifier) != ''">
          <xsl:attribute name="id">IRASC5-002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
      [IRASC5-002]-The SBDH envelope MUST have a Receiver identifier.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(dh:DocumentIdentification/dh:InstanceIdentifier) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(dh:DocumentIdentification/dh:InstanceIdentifier) != ''">
          <xsl:attribute name="id">IRASC5-003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        [IRASC5-003]-The SBDH envelope MUST have an Instance identifier.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(dh:DocumentIdentification/dh:CreationDateAndTime) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(dh:DocumentIdentification/dh:CreationDateAndTime) != ''">
          <xsl:attribute name="id">IRASC5-004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        [IRASC5-004]-The SBDH envelope MUST have a Creation date and time.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="ubl:Invoice | cn:CreditNote" mode="M11" priority="1000">
    <svrl:fired-rule context="ubl:Invoice | cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:CustomizationID) = 'urn:cen.eu:en16931:2017#conformant#urn:fdc:peppol.eu:2017:poacc:billing:international:sg:3.0' or normalize-space(cbc:CustomizationID) = 'urn:cen.eu:en16931:2017#conformant#urn:fdc:peppol.eu:2017:poacc:billing:LocalTaxInvoice:sg:1.0' or normalize-space(cbc:CustomizationID) = 'urn:peppol:pint:billing-1@sg-1' or normalize-space(cbc:CustomizationID) = 'urn:peppol:pint:billing-1@sg-1:LocalTaxInvoice:sg:1.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:CustomizationID) = 'urn:cen.eu:en16931:2017#conformant#urn:fdc:peppol.eu:2017:poacc:billing:international:sg:3.0' or normalize-space(cbc:CustomizationID) = 'urn:cen.eu:en16931:2017#conformant#urn:fdc:peppol.eu:2017:poacc:billing:LocalTaxInvoice:sg:1.0' or normalize-space(cbc:CustomizationID) = 'urn:peppol:pint:billing-1@sg-1' or normalize-space(cbc:CustomizationID) = 'urn:peppol:pint:billing-1@sg-1:LocalTaxInvoice:sg:1.0'">
          <xsl:attribute name="id">IRASC5-005</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-005]-An Invoice MUST have a valid Specification identifier (IBT-024).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M11" priority="-1" />
  <xsl:template match="@*|node()" mode="M11" priority="-2">
    <xsl:apply-templates mode="M11" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="ubl:Invoice | cn:CreditNote" mode="M12" priority="1001">
    <svrl:fired-rule context="ubl:Invoice | cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(lower-case(cbc:ProfileID)) = 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0' or normalize-space(lower-case(cbc:ProfileID)) = 'urn:fdc:peppol.eu:2017:poacc:payables:01:1.0' or normalize-space(lower-case(cbc:ProfileID)) = 'urn:peppol:bis:billing' or normalize-space(lower-case(cbc:ProfileID)) = 'urn:peppol:bis:payables'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(lower-case(cbc:ProfileID)) = 'urn:fdc:peppol.eu:2017:poacc:billing:01:1.0' or normalize-space(lower-case(cbc:ProfileID)) = 'urn:fdc:peppol.eu:2017:poacc:payables:01:1.0' or normalize-space(lower-case(cbc:ProfileID)) = 'urn:peppol:bis:billing' or normalize-space(lower-case(cbc:ProfileID)) = 'urn:peppol:bis:payables'">
          <xsl:attribute name="id">IRASC5-006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-006]-An Invoice MUST have a valid Business process type (IBT-023).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:ID)">
          <xsl:attribute name="id">IRASC5-007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-007]-An Invoice MUST have an Invoice number (IBT-001).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:UUID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:UUID)">
          <xsl:attribute name="id">IRASC5-008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-008]-An Invoice MUST have a UUID value (BT-SG-003).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:IssueDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:IssueDate)">
          <xsl:attribute name="id">IRASC5-009</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-009]-An Invoice MUST have an Invoice issue date (IBT-002).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:InvoiceTypeCode) or normalize-space(cbc:CreditNoteTypeCode) !=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:InvoiceTypeCode) or normalize-space(cbc:CreditNoteTypeCode) !=''">
          <xsl:attribute name="id">IRASC5-010</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-010]-An Invoice MUST have an Invoice type code (IBT-003).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" mode="M12" priority="1000">
    <svrl:fired-rule context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 380 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 381 ', concat(' ', normalize-space(.), ' ')))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(self::cbc:InvoiceTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 380 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 381 ', concat(' ', normalize-space(.), ' ')))))">
          <xsl:attribute name="id">IRASC5-011</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-011]-The Invoice type code (IBT-003) MUST be coded using valid code values.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="ubl:Invoice | cn:CreditNote" mode="M13" priority="1001">
    <svrl:fired-rule context="ubl:Invoice | cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:DocumentCurrencyCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:DocumentCurrencyCode)">
          <xsl:attribute name="id">IRASC5-012</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-012]-An Invoice MUST have an Invoice currency code (IBT-005).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:DocumentCurrencyCode" mode="M13" priority="1000">
    <svrl:fired-rule context="cbc:DocumentCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STD SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA XXX YER ZAR ZMW ZWL ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">IRASC5-013</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-013]-Invoice currency code  (IBT-005) MUST be coded using ISO code list 4217 alpha-3</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="ubl:Invoice | cn:CreditNote" mode="M14" priority="1004">
    <svrl:fired-rule context="ubl:Invoice | cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(normalize-space(cbc:DocumentCurrencyCode) = 'SGD' and not(cbc:TaxCurrencyCode)) or (normalize-space(cbc:DocumentCurrencyCode) != 'SGD' and normalize-space(cbc:TaxCurrencyCode) = 'SGD')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(normalize-space(cbc:DocumentCurrencyCode) = 'SGD' and not(cbc:TaxCurrencyCode)) or (normalize-space(cbc:DocumentCurrencyCode) != 'SGD' and normalize-space(cbc:TaxCurrencyCode) = 'SGD')">
          <xsl:attribute name="id">IRASC5-014</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-014]-An Invoice MUST have an Accounting currency code (IBT-006) with value 'SGD', if the Invoice currency code (IBT-005) is not 'SGD'. Otherwise, the Accounting currency code (IBT-006) MUST NOT be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:DocumentCurrencyCode) = 'SGD' or (count(cac:AdditionalDocumentReference/cbc:DocumentTypeCode = 'sgdtotal-excl-gst') = 1 and normalize-space(cac:AdditionalDocumentReference[normalize-space(cbc:DocumentTypeCode) = 'sgdtotal-excl-gst'] / cbc:ID) = 'SGD' and  normalize-space(cac:AdditionalDocumentReference[normalize-space(cbc:DocumentTypeCode) = 'sgdtotal-excl-gst'] / cbc:DocumentDescription) != '' )" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:DocumentCurrencyCode) = 'SGD' or (count(cac:AdditionalDocumentReference/cbc:DocumentTypeCode = 'sgdtotal-excl-gst') = 1 and normalize-space(cac:AdditionalDocumentReference[normalize-space(cbc:DocumentTypeCode) = 'sgdtotal-excl-gst'] / cbc:ID) = 'SGD' and normalize-space(cac:AdditionalDocumentReference[normalize-space(cbc:DocumentTypeCode) = 'sgdtotal-excl-gst'] / cbc:DocumentDescription) != '' )">
          <xsl:attribute name="id">IRASC5-015</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-015]-If the Invoice currency code (IBT-005) is not 'SGD', the Invoice MUST have exactly one Additional Supporting Document as follows: Document type code (BT-SG-001) MUST be 'sgdtotal-excl-gst', Supporting document description MUST be provided, Invoiced object identifier MUST be 'SGD'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:DocumentCurrencyCode) = 'SGD' or (count(cac:AdditionalDocumentReference/cbc:DocumentTypeCode = 'sgdtotal-incl-gst') = 1 and normalize-space(cac:AdditionalDocumentReference[normalize-space(cbc:DocumentTypeCode) = 'sgdtotal-incl-gst'] / cbc:ID) = 'SGD' and  normalize-space(cac:AdditionalDocumentReference[normalize-space(cbc:DocumentTypeCode) = 'sgdtotal-incl-gst'] / cbc:DocumentDescription) != '' )" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:DocumentCurrencyCode) = 'SGD' or (count(cac:AdditionalDocumentReference/cbc:DocumentTypeCode = 'sgdtotal-incl-gst') = 1 and normalize-space(cac:AdditionalDocumentReference[normalize-space(cbc:DocumentTypeCode) = 'sgdtotal-incl-gst'] / cbc:ID) = 'SGD' and normalize-space(cac:AdditionalDocumentReference[normalize-space(cbc:DocumentTypeCode) = 'sgdtotal-incl-gst'] / cbc:DocumentDescription) != '' )">
          <xsl:attribute name="id">IRASC5-016</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-016]-If the Invoice currency code (IBT-005) is not 'SGD', the Invoice MUST have exactly one Additional Supporting Document as follows: Document type code (BT-SG-002) MUST be 'sgdtotal-incl-gst', Supporting document description MUST be provided, Invoiced object identifier MUST be 'SGD'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party" mode="M14" priority="1003">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">IRASC5-017</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-017]-The Seller electronic address (IBT-049) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" mode="M14" priority="1002">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(@schemeID)">
          <xsl:attribute name="id">IRASC5-018</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-018]-The Seller electronic address (IBT-034) MUST have a Scheme identifier.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID]" mode="M14" priority="1001">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0147 0151 0170 0183 0184 0188 0190 0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204 0205 0208 0209 0210 0211 0212 0213 0215 0216 0217 0221 0230 9901 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959 ', concat(' ', normalize-space(@schemeID), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(@schemeID), ' ')) and contains(' 0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0147 0151 0170 0183 0184 0188 0190 0191 0192 0193 0194 0195 0196 0198 0199 0200 0201 0202 0203 0204 0205 0208 0209 0210 0211 0212 0213 0215 0216 0217 0221 0230 9901 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959 ', concat(' ', normalize-space(@schemeID), ' '))))">
          <xsl:attribute name="id">IRASC5-019</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-019]-Endpoint identifier scheme identifier (IBT-034-1), (IBT-049-1) MUST belong to the CEF EAS code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" mode="M14" priority="1000">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:StreetName) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:StreetName) != ''">
          <xsl:attribute name="id">IRASC5-020</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-020]-The Seller address line 1 (IBT-035) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:PostalZone) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:PostalZone) != ''">
          <xsl:attribute name="id">IRASC5-021</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-021]-The Seller post code (IBT-038) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:Country/cbc:IdentificationCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:Country/cbc:IdentificationCode) != ''">
          <xsl:attribute name="id">IRASC5-022</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-022]-The Seller postal address (IBG-05) MUST contain a Seller country code (IBT-040).</svrl:text>
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


	<!--RULE -->
<xsl:template match="ubl:Invoice | cn:CreditNote" mode="M15" priority="1003">
    <svrl:fired-rule context="ubl:Invoice | cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'GST'])=1 and normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) ='GST']/cbc:CompanyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'GST'])=1 and normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) ='GST']/cbc:CompanyID) != ''">
          <xsl:attribute name="id">IRASC5-023</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-023]-The Seller GST identifier (IBT-031) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID ) = 'GST'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID ) = 'GST'">
          <xsl:attribute name="id">IRASC5-024</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        [IRASC5-024]-The tax scheme identifier (IBT-031-1) of the Seller GST identifier (IBT-031) MUST be 'GST'.
      </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''">
          <xsl:attribute name="id">IRASC5-025</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-025]-An Invoice MUST contain the Seller name (IBT-027).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) !=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) !=''">
          <xsl:attribute name="id">IRASC5-026</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-026]-The Seller legal registration identifier (IBT-030) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party" mode="M15" priority="1002">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">IRASC5-027</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-027]-The Buyer electronic address (IBT-049) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" mode="M15" priority="1001">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(@schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(@schemeID)">
          <xsl:attribute name="id">IRASC5-028</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-028]-The Buyer electronic address (IBT-049) MUST have a Scheme identifier.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M15" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" mode="M15" priority="1000">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:StreetName) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:StreetName) != ''">
          <xsl:attribute name="id">IRASC5-029</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-029]-The Buyer address line 1 (IBT-050) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:PostalZone) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:PostalZone) != ''">
          <xsl:attribute name="id">IRASC5-030</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-030]-The Buyer post code (IBT-053) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:Country/cbc:IdentificationCode) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:Country/cbc:IdentificationCode) != ''">
          <xsl:attribute name="id">IRASC5-031</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-031]-The Buyer postal address (IBG-08) MUST contain a Buyer country code (IBT-055).</svrl:text>
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


	<!--RULE -->
<xsl:template match="ubl:Invoice | cn:CreditNote" mode="M16" priority="1006">
    <svrl:fired-rule context="ubl:Invoice | cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName) !=''">
          <xsl:attribute name="id">IRASC5-033</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-033]-An Invoice MUST contain the Buyer name (IBT-044).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) !=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) !=''">
          <xsl:attribute name="id">IRASC5-034</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-034]-The Seller legal registration identifier (IBT-047) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $Currency in cbc:DocumentCurrencyCode satisfies (cac:TaxTotal/cbc:TaxAmount[@currencyID = $Currency])" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $Currency in cbc:DocumentCurrencyCode satisfies (cac:TaxTotal/cbc:TaxAmount[@currencyID = $Currency])">
          <xsl:attribute name="id">IRASC5-035</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-035]-An Invoice MUST have an Invoice total GST amount (IBT-110).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:DocumentCurrencyCode) = 'SGD' or (every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:DocumentCurrencyCode) = 'SGD' or (every $taxcurrency in cbc:TaxCurrencyCode satisfies exists(//cac:TaxTotal/cbc:TaxAmount[@currencyID=$taxcurrency]))">
          <xsl:attribute name="id">IRASC5-037</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-037]-An Invoice MUST have an Invoice total GST amount in accounting currency (IBT-111), if the Invoice currency code (IBT-005) is not 'SGD'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] >= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] >= 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] >= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] >= 0)">
          <xsl:attribute name="id">IRASC5-039</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-039]-Invoice total tax amount (IBT-110) and Invoice total tax amount in accounting currency (IBT-111) MUST have the same operational sign.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:Invoice | cn:CreditNote" mode="M16" priority="1005">
    <svrl:fired-rule context="ubl:Invoice | cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:TaxTotal/cbc:TaxAmount/@currencyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:TaxTotal/cbc:TaxAmount/@currencyID) != ''">
          <xsl:attribute name="id">IRASC5-036</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-036]-The currency code MUST be provided for the Invoice total GST amount (IBT-110).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:Invoice | cn:CreditNote" mode="M16" priority="1004">
    <svrl:fired-rule context="ubl:Invoice | cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:DocumentCurrencyCode) = 'SGD' or (normalize-space(cac:TaxTotal/cbc:TaxAmount/@currencyID) = 'SGD' and normalize-space(cbc:DocumentCurrencyCode) != 'SGD')" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:DocumentCurrencyCode) = 'SGD' or (normalize-space(cac:TaxTotal/cbc:TaxAmount/@currencyID) = 'SGD' and normalize-space(cbc:DocumentCurrencyCode) != 'SGD')">
          <xsl:attribute name="id">IRASC5-038</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-038]-The currency code for the Invoice total GST amount in accounting currency (IBT-111) MUST be 'SGD', if the Invoice currency code (IBT-005) is not 'SGD'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxTotal/cac:TaxSubtotal" mode="M16" priority="1003">
    <svrl:fired-rule context="cac:TaxTotal/cac:TaxSubtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxableAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxableAmount)">
          <xsl:attribute name="id">IRASC5-040</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-040]-Each GST Breakdown (IBG-23) shall have a GST category taxable amount (BT-116-GST).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:TaxableAmount/@currencyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:TaxableAmount/@currencyID) != ''">
          <xsl:attribute name="id">IRASC5-041</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-041]-The currency code MUST be provided for the GST category taxable amount (IBT-116).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxAmount)">
          <xsl:attribute name="id">IRASC5-042</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-042]-Each GST Breakdown (IBG-23) shall have a GST category tax amount (IBT-117).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:TaxAmount/@currencyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:TaxAmount/@currencyID) != ''">
          <xsl:attribute name="id">IRASC5-043</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-043]-The currency code MUST be provided for the GST category tax amount (IBT-117).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)">
          <xsl:attribute name="id">IRASC5-044</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-044]-Each GST Breakdown (IBG-23) shall be defined through a GST category code (IBT-118).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(contains( ' SR SRCA-S SRCA-C SRLVG NA ZR TX TXCA TX-RE ', concat(' ',upper-case(normalize-space(cac:TaxCategory/cbc:ID)),' ')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(contains( ' SR SRCA-S SRCA-C SRLVG NA ZR TX TXCA TX-RE ', concat(' ',upper-case(normalize-space(cac:TaxCategory/cbc:ID)),' ')))">
          <xsl:attribute name="id">IRASC5-045</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-045]-At least one GST category code (IBT-118) within the GST Breakdown (IBG-23) MUST be within the scope of the GST InvoiceNow Requirement.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:Percent)">
          <xsl:attribute name="id">IRASC5-046</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-046]-Each GST Breakdown (IBG-23) MUST have a GST category rate (IBT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:TaxCategory/cac:TaxScheme/cbc:ID) = 'GST'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:TaxCategory/cac:TaxScheme/cbc:ID) = 'GST'">
          <xsl:attribute name="id">IRASC5-047</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-047]-Each GST Breakdown (IBG-23) MUST have a GST category tax scheme identifier (IBT-118-1) with value 'GST'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $taxCategoryCode in cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID satisfies (count (cac:TaxCategory/cbc:ID = $taxCategoryCode) = 1) " />
      <xsl:otherwise>
        <svrl:failed-assert test="every $taxCategoryCode in cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID satisfies (count (cac:TaxCategory/cbc:ID = $taxCategoryCode) = 1)">
          <xsl:attribute name="id">IRASC5-048</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-048]-All distinct values of the Invoiced item GST category codes (IBT-151) MUST tally with the values of the GST category codes (IBT-118).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(contains(normalize-space(lower-case(../../cbc:ProfileID)), 'payable' ) and contains( ' BL EP IGDS IM IM-ESS IM-N33 IM-RE ME NR OP TX TX-N33 TX-RE TXCA TXNA TX-ESS TXRC-TS TXRC-ESS TXRC-N33 TXRC-RE ZP ', concat(' ',upper-case(normalize-space(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)),' '))) or (  contains(normalize-space(lower-case(../../cbc:ProfileID)), 'billing' )  and contains( ' SR SRCA-S SRCA-C SRRC SROVR-RS SROVR-LVG SRLVG ZR ES33 ESN33 DS OS NG NA ', concat(' ',upper-case(normalize-space(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)),' ')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(contains(normalize-space(lower-case(../../cbc:ProfileID)), 'payable' ) and contains( ' BL EP IGDS IM IM-ESS IM-N33 IM-RE ME NR OP TX TX-N33 TX-RE TXCA TXNA TX-ESS TXRC-TS TXRC-ESS TXRC-N33 TXRC-RE ZP ', concat(' ',upper-case(normalize-space(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)),' '))) or ( contains(normalize-space(lower-case(../../cbc:ProfileID)), 'billing' ) and contains( ' SR SRCA-S SRCA-C SRRC SROVR-RS SROVR-LVG SRLVG ZR ES33 ESN33 DS OS NG NA ', concat(' ',upper-case(normalize-space(cac:TaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)),' ')))">
          <xsl:attribute name="id">IRASC5-049</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-049]-The GST category codes (IBT-118) on an Invoice MUST be valid values for the Business process type (IBT-023).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:LegalMonetaryTotal" mode="M16" priority="1002">
    <svrl:fired-rule context="cac:LegalMonetaryTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:LineExtensionAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:LineExtensionAmount)">
          <xsl:attribute name="id">IRASC5-050</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-050]-An Invoice MUST have the Sum of Invoice line net amount (IBT-106).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:LineExtensionAmount/@currencyID ) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:LineExtensionAmount/@currencyID ) != ''">
          <xsl:attribute name="id">IRASC5-051</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-051]-The currency code MUST be provided for the Sum of Invoice line net amount (IBT-106).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxExclusiveAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxExclusiveAmount)">
          <xsl:attribute name="id">IRASC5-052</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-052]-An Invoice MUST have the Invoice total amount without Tax (IBT-109).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:TaxExclusiveAmount) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:TaxExclusiveAmount) != ''">
          <xsl:attribute name="id">IRASC5-053</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-053]-The currency code MUST be provided for the Invoice total amount without GST (IBT-109)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxInclusiveAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxInclusiveAmount)">
          <xsl:attribute name="id">IRASC5-054</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-054]-An Invoice MUST have the Invoice total amount with Tax (IBT-112).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(cbc:TaxInclusiveAmount)>=0" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(cbc:TaxInclusiveAmount)>=0">
          <xsl:attribute name="id">IRASC5-055</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-055]-The Invoice total amount with GST (IBT-112) MUST not be negative.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:TaxInclusiveAmount ) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:TaxInclusiveAmount ) != ''">
          <xsl:attribute name="id">IRASC5-056</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-056]-The currency code MUST be provided for the Invoice total amount with GST (IBT-112).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:PayableAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:PayableAmount)">
          <xsl:attribute name="id">IRASC5-057</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-057]-An Invoice MUST have the Amount due for payment (IBT-115).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:PayableAmount) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:PayableAmount) != ''">
          <xsl:attribute name="id">IRASC5-058</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-058]-The currency code MUST be provided for the Amount due for payment (IBT-115).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M16" priority="1001">
    <svrl:fired-rule context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID) != ''">
          <xsl:attribute name="id">IRASC5-059</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-059]-Each Invoice line (ibg-25) MUST have an Invoice line identifier (IBT-126).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:InvoicedQuantity) or exists(cbc:CreditedQuantity)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:InvoicedQuantity) or exists(cbc:CreditedQuantity)">
          <xsl:attribute name="id">IRASC5-060</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-060]-Each Invoice line (ibg-25) MUST have an invoiced quantity (IBT-129)..</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:InvoicedQuantity/@unitCode) or exists(cbc:CreditedQuantity/@unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:InvoicedQuantity/@unitCode) or exists(cbc:CreditedQuantity/@unitCode)">
          <xsl:attribute name="id">IRASC5-061</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-061]-An Invoice line (ibg-25) MUST have an Invoiced quantity unit of measure code (IBT-130).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:LineExtensionAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:LineExtensionAmount)">
          <xsl:attribute name="id">IRASC5-062</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-062]-Each Invoice line (ibg-25) MUST have an Invoice line net amount (IBT-131).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:LineExtensionAmount) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:LineExtensionAmount) != ''">
          <xsl:attribute name="id">IRASC5-063</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-063]-The currency code MUST be provided for each Invoice line net amount (IBT-131).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:Item/cbc:Name) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:Item/cbc:Name) != ''">
          <xsl:attribute name="id">IRASC5-064</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-064]-Each Invoice line (ibg-25) MUST contain the Item name (IBT-153).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:ID)">
          <xsl:attribute name="id">IRASC5-065</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-065]-Each Invoice line (BG-25) shall be categorized with an Invoiced item GST category code (BT-151-GST).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M16" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:ClassifiedTaxCategory/cbc:ID" mode="M16" priority="1000">
    <svrl:fired-rule context="cac:ClassifiedTaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(( not(contains(normalize-space(.),' ')) and contains( ' SR SRCA-S SRCA-C SRRC SROVR-RS SROVR-LVG SRLVG ZR ES33 ESN33 DS OS NG NA TX TXCA TXNA ZP IM ME IGDS BL NR EP OP TXR-TS TX-ESS TXRC-ESS IM-ESS TX-N33 TXRC-N33 IM-N33 TX-RE TXRC-RE IM-RE ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="(( not(contains(normalize-space(.),' ')) and contains( ' SR SRCA-S SRCA-C SRRC SROVR-RS SROVR-LVG SRLVG ZR ES33 ESN33 DS OS NG NA TX TXCA TXNA ZP IM ME IGDS BL NR EP OP TXR-TS TX-ESS TXRC-ESS IM-ESS TX-N33 TXRC-N33 IM-N33 TX-RE TXRC-RE IM-RE ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">IRASC5-066</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-066]-Invoice tax categories MUST be coded using valid Singapore code values</svrl:text>
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


	<!--RULE -->
<xsl:template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M17" priority="1000">
    <svrl:fired-rule context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Item/cac:ClassifiedTaxCategory[cac:TaxScheme/cbc:ID='GST']/cbc:Percent)">
          <xsl:attribute name="id">IRASC5-067</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-067]-The Invoiced item GST rate (IBT-152) MUST be provided for each Line GST Information (IBG-30).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID) = 'GST' or normalize-space(cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID) = 'GST' " />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID) = 'GST' or normalize-space(cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID) = 'GST'">
          <xsl:attribute name="id">IRASC5-068</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-068]-The tax scheme identifier (IBT-167) MUST be provided for each Line GST Information (IBG-30).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:Price/cbc:PriceAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Price/cbc:PriceAmount)">
          <xsl:attribute name="id">IRASC5-069</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-069]-Each Invoice line (ibg-25) MUST contain the Item net price (IBT-146).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Price/cbc:PriceAmount) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Price/cbc:PriceAmount) >= 0">
          <xsl:attribute name="id">IRASC5-070</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-070]-The Item net price (IBT-146) MUST NOT be negative.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cac:Price/cbc:PriceAmount/@currencyID) != '' or normalize-space(cac:Price/cbc:PriceAmount/@currencyID) != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cac:Price/cbc:PriceAmount/@currencyID) != '' or normalize-space(cac:Price/cbc:PriceAmount/@currencyID) != ''">
          <xsl:attribute name="id">IRASC5-071</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-071]-The currency code MUST be provided for each Item net price (IBT-146).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M17" priority="-1" />
  <xsl:template match="@*|node()" mode="M17" priority="-2">
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>

<!--PATTERN credit_only-->


	<!--RULE -->
<xsl:template match="cn:CreditNote" mode="M18" priority="1000">
    <svrl:fired-rule context="cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:Note) !=''" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:Note) !=''">
          <xsl:attribute name="id">IRASC5-072</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-072]-An Invoice MUST have an Invoice note (IBT-022), if it is a Credit Note.</svrl:text>
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


	<!--RULE -->
<xsl:template match="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount | cac:TaxTotal[cbc:TaxAmount/@currencyID=/*/cbc:DocumentCurrencyCode]/cbc:TaxAmount | cac:TaxTotal[cbc:TaxAmount/@currencyID=/*/cbc:DocumentCurrencyCode]/cac:TaxSubtotal/cbc:TaxableAmount | cac:TaxTotal[cbc:TaxAmount/@currencyID=/*/cbc:DocumentCurrencyCode]/cac:TaxSubtotal/cbc:TaxAmount" mode="M19" priority="1005">
    <svrl:fired-rule context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount | cac:TaxTotal[cbc:TaxAmount/@currencyID=/*/cbc:DocumentCurrencyCode]/cbc:TaxAmount | cac:TaxTotal[cbc:TaxAmount/@currencyID=/*/cbc:DocumentCurrencyCode]/cac:TaxSubtotal/cbc:TaxableAmount | cac:TaxTotal[cbc:TaxAmount/@currencyID=/*/cbc:DocumentCurrencyCode]/cac:TaxSubtotal/cbc:TaxAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID = //cbc:DocumentCurrencyCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID = //cbc:DocumentCurrencyCode">
          <xsl:attribute name="id">IRASC5-075</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-075]- All currencyID attributes must have the same value as the Invoice currency code (IBT-005), except for amounts expected to be in Tax accounting currency (IBT-006).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = false()] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" mode="M19" priority="1004">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator = false()] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <xsl:attribute name="id">IRASC5-076</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-076]-The allowed maximum number of decimals for the Document level allowance amount (BT-92) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = true()] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" mode="M19" priority="1003">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator = true()] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <xsl:attribute name="id">IRASC5-077</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-077]-The allowed maximum number of decimals for the Document level charge amount (BT-99) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <xsl:attribute name="id">IRASC5-078</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-078]-The allowed maximum number of decimals for the Document level allowance base amount (BT-93) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <xsl:attribute name="id">IRASC5-079</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-079]-The allowed maximum number of decimals for the Document level charge base amount (BT-100) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M19" priority="1002">
    <svrl:fired-rule context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode]))">
          <xsl:attribute name="id">IRASC5-080</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-080]-The allowed maximum number of decimals for the Invoice total GST amount (BT-110-GST) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode]))">
          <xsl:attribute name="id">IRASC5-081</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-081]-The allowed maximum number of decimals for the Invoice total GST amount in accounting currency (BT-111-GST) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxTotal/cac:TaxSubtotal" mode="M19" priority="1001">
    <svrl:fired-rule context="cac:TaxTotal/cac:TaxSubtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2">
          <xsl:attribute name="id">IRASC5-082</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-082]-The allowed maximum number of decimals for the GST category taxable amount (BT-116-GST) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2">
          <xsl:attribute name="id">IRASC5-083</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-083]-The allowed maximum number of decimals for the GST category tax amount (IBT-117) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:LegalMonetaryTotal" mode="M19" priority="1000">
    <svrl:fired-rule context="cac:LegalMonetaryTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2">
          <xsl:attribute name="id">IRASC5-084</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-084]-The allowed maximum number of decimals for the Sum of Invoice line net amount (BT-106) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2">
          <xsl:attribute name="id">IRASC5-085</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-085]-The allowed maximum number of decimals for the Invoice total amount without GST (BT-109-GST) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:TaxInclusiveAmount, '.')) &lt;= 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:TaxInclusiveAmount, '.')) &lt;= 2">
          <xsl:attribute name="id">IRASC5-086</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-086]- Invoice total amount with TAX (IBT-112) MUST have no more than 2 decimals.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:AllowanceTotalAmount, '.')) &lt;= 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:AllowanceTotalAmount, '.')) &lt;= 2">
          <xsl:attribute name="id">IRASC5-087</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-087]-Document level allowance amount (IBT-107) MUST have no more than 2 decimals.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:ChargeTotalAmount, '.')) &lt;= 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:ChargeTotalAmount, '.')) &lt;= 2">
          <xsl:attribute name="id">IRASC5-088</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-088]-Document level charge amount (IBT-108) MUST have no more than 2 decimals.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2">
          <xsl:attribute name="id">IRASC5-089</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-089]-The allowed maximum number of decimals for the Paid amount (BT-113) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:PayableRoundingAmount, '.')) &lt;= 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:PayableRoundingAmount, '.')) &lt;= 2">
          <xsl:attribute name="id">IRASC5-090</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-090]-The Rounding amount (IBT-114), if provided, MUST have no more than 2 decimals.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:PayableAmount, '.')) &lt;= 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:PayableAmount, '.')) &lt;= 2">
          <xsl:attribute name="id">IRASC5-091</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-091]-Invoice amount due for payment (IBT-115) MUST have no more than 2 decimals.</svrl:text>
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


	<!--RULE -->
<xsl:template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M20" priority="1000">
    <svrl:fired-rule context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:LineExtensionAmount, '.')) &lt;= 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:LineExtensionAmount, '.')) &lt;= 2">
          <xsl:attribute name="id">IRASC5-092</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
      [IRASC5-092]-The Invoice line net amount (IBT-131) MUST have no more than 2 decimals.</svrl:text>
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


	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" mode="M21" priority="1002">
    <svrl:fired-rule context="cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:Amount, '.')) &lt;= 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:Amount, '.')) &lt;= 2">
          <xsl:attribute name="id">IRASC5-094</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-094]-The Line level charge amount (IBT-141), if provided, MUST have no more than 2 decimals.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:BaseAmount, '.')) &lt;= 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:BaseAmount, '.')) &lt;= 2">
          <xsl:attribute name="id">IRASC5-096</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-096]-The Line level charge base amount (IBT-142), if provided, MUST have no more than 2 decimals.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" mode="M21" priority="1001">
    <svrl:fired-rule context="cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:Amount, '.')) &lt;= 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:Amount, '.')) &lt;= 2">
          <xsl:attribute name="id">IRASC5-093</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-093]-The Line level allowance amount (IBT-136), if provided, MUST have no more than 2 decimals.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:BaseAmount, '.')) &lt;= 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:BaseAmount, '.')) &lt;= 2">
          <xsl:attribute name="id">IRASC5-095</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-095]-The Line level allowance base amount (IBT-137), if provided, MUST have no more than 2 decimals.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AdditionalDocumentReference[cbc:DocumentTypeCode]" mode="M21" priority="1000">
    <svrl:fired-rule context="cac:AdditionalDocumentReference[cbc:DocumentTypeCode]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:DocumentTypeCode='sgdtotal-excl-gst' and cbc:DocumentDescription castable as xs:decimal and string-length(substring-after(cbc:DocumentDescription,'.'))&lt;=2) or cbc:DocumentTypeCode != 'sgdtotal-excl-gst' " />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:DocumentTypeCode='sgdtotal-excl-gst' and cbc:DocumentDescription castable as xs:decimal and string-length(substring-after(cbc:DocumentDescription,'.'))&lt;=2) or cbc:DocumentTypeCode != 'sgdtotal-excl-gst'">
          <xsl:attribute name="id">IRASC5-100</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-100]- Total Amount excluding GST in SGD must be numeric and have maximum of 2 decimals</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:DocumentTypeCode='sgdtotal-incl-gst' and cbc:DocumentDescription castable as xs:decimal and string-length(substring-after(cbc:DocumentDescription,'.'))&lt;=2) or cbc:DocumentTypeCode != 'sgdtotal-incl-gst' " />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:DocumentTypeCode='sgdtotal-incl-gst' and cbc:DocumentDescription castable as xs:decimal and string-length(substring-after(cbc:DocumentDescription,'.'))&lt;=2) or cbc:DocumentTypeCode != 'sgdtotal-incl-gst'">
          <xsl:attribute name="id">IRASC5-101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IRASC5-101]- Total Amount including GST in SGD must be numeric and have maximum of 2 decimals</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M21" priority="-1" />
  <xsl:template match="@*|node()" mode="M21" priority="-2">
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
