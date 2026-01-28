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
<xsl:template match="cac:AccountingCustomerParty/cac:Party" mode="M12" priority="1039">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID) or not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = &quot;PAS&quot;) or (cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID=&quot;PAS&quot; and cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyName  and matches(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyName, &quot;^(AF|AX|AL|DZ|AS|AD|AO|AI|AQ|AG|AR|AM|AW|AU|AT|AZ|BS|BH|BD|BB|BY|BE|BZ|BJ|BM|BT|BO|BQ|BA|BW|BV|BR|IO|BN|BG|BF|BI|CV|KH|CM|CA|KY|CF|TD|CL|CN|CX|CC|CO|KM|CG|CD|CK|CR|CI|HR|CU|CW|CY|CZ|DK|DJ|DM|DO|EC|EG|SV|GQ|ER|EE|SZ|ET|FK|FO|FJ|FI|FR|GF|PF|TF|GA|GM|GE|DE|GH|GI|GR|GL|GD|GP|GU|GT|GG|GN|GW|GY|HT|HM|VA|HN|HK|HU|IS|IN|ID|IR|IQ|IE|IM|IL|IT|JM|JP|JE|JO|KZ|KE|KI|KP|KR|KW|KG|LA|LV|LB|LS|LR|LY|LI|LT|LU|MO|MG|MW|MY|MV|ML|MT|MH|MQ|MR|MU|YT|MX|FM|MD|MC|MN|ME|MS|MA|MZ|MM|NA|NR|NP|NL|NC|NZ|NI|NE|NG|NU|NF|MP|NO|OM|PK|PW|PS|PA|PG|PY|PE|PH|PN|PL|PT|PR|QA|MK|RO|RU|RW|RE|BL|SH|KN|LC|MF|PM|VC|WS|SM|ST|SA|SN|RS|SC|SL|SG|SX|SK|SI|SB|SO|ZA|GS|SS|ES|LK|SD|SR|SJ|SE|CH|SY|TW|TJ|TZ|TH|TL|TG|TK|TO|TT|TN|TR|TM|TC|TV|UG|UA|AE|GB|US|UM|UY|UZ|VU|VE|VN|VG|VI|WF|EH|YE|ZM|ZW)$&quot;))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID) or not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = &quot;PAS&quot;) or (cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID=&quot;PAS&quot; and cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyName and matches(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyName, &quot;^(AF|AX|AL|DZ|AS|AD|AO|AI|AQ|AG|AR|AM|AW|AU|AT|AZ|BS|BH|BD|BB|BY|BE|BZ|BJ|BM|BT|BO|BQ|BA|BW|BV|BR|IO|BN|BG|BF|BI|CV|KH|CM|CA|KY|CF|TD|CL|CN|CX|CC|CO|KM|CG|CD|CK|CR|CI|HR|CU|CW|CY|CZ|DK|DJ|DM|DO|EC|EG|SV|GQ|ER|EE|SZ|ET|FK|FO|FJ|FI|FR|GF|PF|TF|GA|GM|GE|DE|GH|GI|GR|GL|GD|GP|GU|GT|GG|GN|GW|GY|HT|HM|VA|HN|HK|HU|IS|IN|ID|IR|IQ|IE|IM|IL|IT|JM|JP|JE|JO|KZ|KE|KI|KP|KR|KW|KG|LA|LV|LB|LS|LR|LY|LI|LT|LU|MO|MG|MW|MY|MV|ML|MT|MH|MQ|MR|MU|YT|MX|FM|MD|MC|MN|ME|MS|MA|MZ|MM|NA|NR|NP|NL|NC|NZ|NI|NE|NG|NU|NF|MP|NO|OM|PK|PW|PS|PA|PG|PY|PE|PH|PN|PL|PT|PR|QA|MK|RO|RU|RW|RE|BL|SH|KN|LC|MF|PM|VC|WS|SM|ST|SA|SN|RS|SC|SL|SG|SX|SK|SI|SB|SO|ZA|GS|SS|ES|LK|SD|SR|SJ|SE|CH|SY|TW|TJ|TZ|TH|TL|TG|TK|TO|TT|TN|TR|TM|TC|TV|UG|UA|AE|GB|US|UM|UY|UZ|VU|VE|VN|VG|VI|WF|EH|YE|ZM|ZW)$&quot;))">
          <xsl:attribute name="id">ibr-010-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-010-ae]-Passport issuing country code (BTAE-19) MUST be there when Buyer legal registration identifier type (BTAE-16)  is 'Passport'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = &quot;TL&quot; and cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyName) or not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = &quot;TL&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = &quot;TL&quot; and cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyName) or not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = &quot;TL&quot;)">
          <xsl:attribute name="id">ibr-101-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-101-ae]-Authority name (BTAE-11) MUST be there when Buyer legal registration identifier type (BTAE-16) is Commercial/Trade license.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(((cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;480&quot; or (cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;81&quot;) and cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) or not((cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;480&quot; or (cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;81&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(((cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;480&quot; or (cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;81&quot;) and cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID) or not((cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;480&quot; or (cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;81&quot;)">
          <xsl:attribute name="id">ibr-136-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-136-ae]-Buyer legal registration identifier (IBT-047) must be present when Invoice type code [IBT-003] is 'Out of scope of VAT' or 'Credit note related to goods or services'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Party/cbc:EndpointID/@schemeID = &quot;0235&quot; and cac:Party/cbc:EndpointID != &quot;1XXXXXXXXX&quot; and not(cac:Party/cac:PartyTaxScheme/cbc:CompanyID))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Party/cbc:EndpointID/@schemeID = &quot;0235&quot; and cac:Party/cbc:EndpointID != &quot;1XXXXXXXXX&quot; and not(cac:Party/cac:PartyTaxScheme/cbc:CompanyID))">
          <xsl:attribute name="id">ibr-149-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-149-ae]-The buyer legal registration identifier (IBT-047) MUST be provided when the scheme identifier (IBT-049-1) is '0235' and buyer electronic address (IBT-049) is not '1XXXXXXXXX'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyTaxScheme/cbc:CompanyID) &lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyTaxScheme/cbc:CompanyID) &lt;=1">
          <xsl:attribute name="id">ibr-179-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-179-ae]-Buyer VAT identifier (IBT-048) MUST occur maximum once</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((cac:PartyIdentification/cbc:ID or cac:PartyTaxScheme/cbc:CompanyID) and (not(matches(../../cbc:ProfileExecutionID, &quot;^[01]{7}1$&quot;)) and cbc:EndpointID/@schemeID = &quot;0235&quot; and not(matches(cbc:EndpointID, &quot;^1\d{9}$&quot;)))) or not(not(matches(../../cbc:ProfileExecutionID, &quot;^[01]{7}1$&quot;)) and cbc:EndpointID/@schemeID = &quot;0235&quot; and not(matches(cbc:EndpointID, &quot;^1\d{9}$&quot;)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((cac:PartyIdentification/cbc:ID or cac:PartyTaxScheme/cbc:CompanyID) and (not(matches(../../cbc:ProfileExecutionID, &quot;^[01]{7}1$&quot;)) and cbc:EndpointID/@schemeID = &quot;0235&quot; and not(matches(cbc:EndpointID, &quot;^1\d{9}$&quot;)))) or not(not(matches(../../cbc:ProfileExecutionID, &quot;^[01]{7}1$&quot;)) and cbc:EndpointID/@schemeID = &quot;0235&quot; and not(matches(cbc:EndpointID, &quot;^1\d{9}$&quot;)))">
          <xsl:attribute name="id">ibr-135-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-135-ae]-Either Buyer identifier (IBT-046) or Buyer VAT identifier (IBT-048 ) MUST be present when the Invoice transaction type code [BTAE-02]  is other than XXXXXXX1 (Exports) and scheme identifier (IBT-049-1) is '0235' and buyer electronic address (IBT-049) is not '1XXXXXXXXX'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:EndpointID[@schemeID = &quot;0235&quot;] and cac:PartyLegalEntity/cbc:CompanyID) or cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:EndpointID[@schemeID = &quot;0235&quot;] and cac:PartyLegalEntity/cbc:CompanyID) or cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID">
          <xsl:attribute name="id">ibr-180-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-180-ae]-When Scheme identifier (IBT-049-1) is '0235' and Buyer legal registration identifier (ibt-047) is provided, then Buyer legal registration identifier type (BTAE-16) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:DeliveryTerms" mode="M12" priority="1038">
    <svrl:fired-rule context="cac:DeliveryTerms" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:ID)">
          <xsl:attribute name="id">ibr-196-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-196-ae]- The Incoterms (BTAE-22) must be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" mode="M12" priority="1037">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:StreetName) and (cbc:CityName) and (cbc:CountrySubentity)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:StreetName) and (cbc:CityName) and (cbc:CountrySubentity)">
          <xsl:attribute name="id">ibr-144-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-144-ae]-In Buyer postal address (IBG-08), Address line 1 (IBT-050), Buyer city (IBT-052) and Buyer country subdivision (IBT-054) must be provided</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingBuyerParty/cac:Party/cac:PostalAddress" mode="M12" priority="1036">
    <svrl:fired-rule context="cac:AccountingBuyerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:StreetName) and (cbc:CityName) and (cbc:CountrySubentity)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:StreetName) and (cbc:CityName) and (cbc:CountrySubentity)">
          <xsl:attribute name="id">ibr-143-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-143-ae]-In Seller postal address (IBG-05), Seller address line 1 (IBT-035),  Seller city (IBT-037) and Seller to country subdivision (IBT-039) must be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party" mode="M12" priority="1035">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID) or not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = &quot;PAS&quot;) or (cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID=&quot;PAS&quot; and cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyName  and matches(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyName, &quot;^(AF|AX|AL|DZ|AS|AD|AO|AI|AQ|AG|AR|AM|AW|AU|AT|AZ|BS|BH|BD|BB|BY|BE|BZ|BJ|BM|BT|BO|BQ|BA|BW|BV|BR|IO|BN|BG|BF|BI|CV|KH|CM|CA|KY|CF|TD|CL|CN|CX|CC|CO|KM|CG|CD|CK|CR|CI|HR|CU|CW|CY|CZ|DK|DJ|DM|DO|EC|EG|SV|GQ|ER|EE|SZ|ET|FK|FO|FJ|FI|FR|GF|PF|TF|GA|GM|GE|DE|GH|GI|GR|GL|GD|GP|GU|GT|GG|GN|GW|GY|HT|HM|VA|HN|HK|HU|IS|IN|ID|IR|IQ|IE|IM|IL|IT|JM|JP|JE|JO|KZ|KE|KI|KP|KR|KW|KG|LA|LV|LB|LS|LR|LY|LI|LT|LU|MO|MG|MW|MY|MV|ML|MT|MH|MQ|MR|MU|YT|MX|FM|MD|MC|MN|ME|MS|MA|MZ|MM|NA|NR|NP|NL|NC|NZ|NI|NE|NG|NU|NF|MP|NO|OM|PK|PW|PS|PA|PG|PY|PE|PH|PN|PL|PT|PR|QA|MK|RO|RU|RW|RE|BL|SH|KN|LC|MF|PM|VC|WS|SM|ST|SA|SN|RS|SC|SL|SG|SX|SK|SI|SB|SO|ZA|GS|SS|ES|LK|SD|SR|SJ|SE|CH|SY|TW|TJ|TZ|TH|TL|TG|TK|TO|TT|TN|TR|TM|TC|TV|UG|UA|AE|GB|US|UM|UY|UZ|VU|VE|VN|VG|VI|WF|EH|YE|ZM|ZW)$&quot;))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID) or not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = &quot;PAS&quot;) or (cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID=&quot;PAS&quot; and cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyName and matches(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyName, &quot;^(AF|AX|AL|DZ|AS|AD|AO|AI|AQ|AG|AR|AM|AW|AU|AT|AZ|BS|BH|BD|BB|BY|BE|BZ|BJ|BM|BT|BO|BQ|BA|BW|BV|BR|IO|BN|BG|BF|BI|CV|KH|CM|CA|KY|CF|TD|CL|CN|CX|CC|CO|KM|CG|CD|CK|CR|CI|HR|CU|CW|CY|CZ|DK|DJ|DM|DO|EC|EG|SV|GQ|ER|EE|SZ|ET|FK|FO|FJ|FI|FR|GF|PF|TF|GA|GM|GE|DE|GH|GI|GR|GL|GD|GP|GU|GT|GG|GN|GW|GY|HT|HM|VA|HN|HK|HU|IS|IN|ID|IR|IQ|IE|IM|IL|IT|JM|JP|JE|JO|KZ|KE|KI|KP|KR|KW|KG|LA|LV|LB|LS|LR|LY|LI|LT|LU|MO|MG|MW|MY|MV|ML|MT|MH|MQ|MR|MU|YT|MX|FM|MD|MC|MN|ME|MS|MA|MZ|MM|NA|NR|NP|NL|NC|NZ|NI|NE|NG|NU|NF|MP|NO|OM|PK|PW|PS|PA|PG|PY|PE|PH|PN|PL|PT|PR|QA|MK|RO|RU|RW|RE|BL|SH|KN|LC|MF|PM|VC|WS|SM|ST|SA|SN|RS|SC|SL|SG|SX|SK|SI|SB|SO|ZA|GS|SS|ES|LK|SD|SR|SJ|SE|CH|SY|TW|TJ|TZ|TH|TL|TG|TK|TO|TT|TN|TR|TM|TC|TV|UG|UA|AE|GB|US|UM|UY|UZ|VU|VE|VN|VG|VI|WF|EH|YE|ZM|ZW)$&quot;))">
          <xsl:attribute name="id">ibr-012-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-012-ae]-Passport issuing country code (BTAE-18) MUST be there when Seller legal registration identifier type (BTAE-15)  is 'Passport'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = &quot;TL&quot; and (cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyName)) or not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = &quot;TL&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = &quot;TL&quot; and (cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyName)) or not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = &quot;TL&quot;)">
          <xsl:attribute name="id">ibr-172-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-172-ae]-Authority name (BTAE-12) MUST be there when the value in Seller legal registration identifier type (BTAE-15) is Commercial/Trade license.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(cbc:ProfileExecutionID, &quot;^[01]{5}1[01]{2}$&quot;)) or cac:PartyTaxScheme/cbc:CompanyID != cac:PartyIdentification/cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(cbc:ProfileExecutionID, &quot;^[01]{5}1[01]{2}$&quot;)) or cac:PartyTaxScheme/cbc:CompanyID != cac:PartyIdentification/cbc:ID">
          <xsl:attribute name="id">ibr-177-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-177-ae]-Either Seller tax registration identifier (IBT-032) or Seller VAT identifier (IBT-031) MUST be provided</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(cac:PartyTaxScheme) = 2 and count(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = &quot;VAT&quot;]) = 1) or count(cac:PartyTaxScheme) &lt; 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(cac:PartyTaxScheme) = 2 and count(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = &quot;VAT&quot;]) = 1) or count(cac:PartyTaxScheme) &lt; 2">
          <xsl:attribute name="id">ibr-178-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-178-ae]-Tax scheme code, if provided in (IBT-031-1) shall be '!VAT' when Seller tax registration identifier (IBT-032) is provided</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Party/cbc:EndpointID/@schemeID = &quot;0235&quot; and not(cac:Party/cac:PartyLegalEntity/cbc:CompanyID))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Party/cbc:EndpointID/@schemeID = &quot;0235&quot; and not(cac:Party/cac:PartyLegalEntity/cbc:CompanyID))">
          <xsl:attribute name="id">ibr-150-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-150-ae]-The Seller legal registration identifier (IBT-030) MUST be provided when the scheme identifier (IBT-034-1) is '0235'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyLegalEntity/cbc:CompanyID and  cbc:EndpointID/@schemeID = &quot;0235&quot; and cac:PostalAddress/cac:Country/cbc:IdentificationCode = &quot;AE&quot; and  not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = (&quot;TL&quot;, &quot;EID&quot;, &quot;PAS&quot;, &quot;CD&quot;)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyLegalEntity/cbc:CompanyID and cbc:EndpointID/@schemeID = &quot;0235&quot; and cac:PostalAddress/cac:Country/cbc:IdentificationCode = &quot;AE&quot; and not(cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = (&quot;TL&quot;, &quot;EID&quot;, &quot;PAS&quot;, &quot;CD&quot;)))">
          <xsl:attribute name="id">ibr-173-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-173-ae]-The value in Seller legal registration identifier type [BTAE-15] Scheme identifier [IBT-030-1] should either be 'Commercial/Trade license' or 'Emirates ID' or 'Passport' or 'Cabinet decision' when the value in Seller legal registration identifier (IBT-030) is provided and scheme identifier (IBT-034-1) is '0235' and the Seller country code (IBT-055) is AE.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:EndpointID[@schemeID = &quot;0235&quot;]) or not(cac:PartyLegalEntity/cbc:CompanyID) or  cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:EndpointID[@schemeID = &quot;0235&quot;]) or not(cac:PartyLegalEntity/cbc:CompanyID) or cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID">
          <xsl:attribute name="id">ibr-181-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-181-ae]-When Scheme identifier (IBT-034-1) is '0235' and Seller legal registration identifier (ibt-030) is provided, then Seller legal registration identifier type (BTAE-15) MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Price/cac:AllowanceCharge" mode="M12" priority="1034">
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
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Price" mode="M12" priority="1033">
    <svrl:fired-rule context="cac:Price" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="boolean(cbc:BaseQuantity) and boolean(cac:AllowanceCharge/cbc:BaseAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(cbc:BaseQuantity) and boolean(cac:AllowanceCharge/cbc:BaseAmount)">
          <xsl:attribute name="id">ibr-126-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-126-ae]-In Price Details (IBG-29), Item price base quantity (IBT-149) and Item Gross Price (IBT-148) MUST be there.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PaymentMeans" mode="M12" priority="1032">
    <svrl:fired-rule context="cac:PaymentMeans" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:PaymentMeansTypeCode = &quot;30&quot;) or cac:PayeeFinancialAccount/cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:PaymentMeansTypeCode = &quot;30&quot;) or cac:PayeeFinancialAccount/cbc:ID">
          <xsl:attribute name="id">ibr-192-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-192-ae]- when Payment means type code (ibt-081) is 'credit transfer' then Payment account identifier (ibt-084) must be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PostalAddress" mode="M12" priority="1031">
    <svrl:fired-rule context="cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Country/cbc:IdentificationCode=&quot;AE&quot; and cbc:CountrySubentity = (&quot;AUH&quot;, &quot;DXB&quot;, &quot;SHJ&quot;, &quot;UAQ&quot;, &quot;FUJ&quot;, &quot;AJM&quot;, &quot;RAK&quot;)) or not(cac:Country/cbc:IdentificationCode=&quot;AE&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Country/cbc:IdentificationCode=&quot;AE&quot; and cbc:CountrySubentity = (&quot;AUH&quot;, &quot;DXB&quot;, &quot;SHJ&quot;, &quot;UAQ&quot;, &quot;FUJ&quot;, &quot;AJM&quot;, &quot;RAK&quot;)) or not(cac:Country/cbc:IdentificationCode=&quot;AE&quot;)">
          <xsl:attribute name="id">ibr-128-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-128-ae]-When Country code (IBT-040, IBT-055, IBT-069, IBT-080) is AE, then country subdivision (IBT-039, IBT-054, IBT-068, IBT-079) should be one among one of these (AUH, DXB, SHJ, UAQ, FUJ, AJM, RAK).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = false()]" mode="M12" priority="1030">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator = false()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(parent::ubl:Invoice|parent::cn:CreditNote) or exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(parent::ubl:Invoice|parent::cn:CreditNote) or exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">
          <xsl:attribute name="id">aligned-ibrp-032</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-032]-Each Document level allowance (ibg-20) MUST have a Document level allowance VAT category code (ibt-095).</svrl:text>
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

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cbc:BaseAmount) and exists(cbc:MultiplierFactorNumeric)) or (cbc:Amount = round(cbc:BaseAmount * cbc:MultiplierFactorNumeric) div 100)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cbc:BaseAmount) and exists(cbc:MultiplierFactorNumeric)) or (cbc:Amount = round(cbc:BaseAmount * cbc:MultiplierFactorNumeric) div 100)">
          <xsl:attribute name="id">ibr-131-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-131-ae]-Allowance amount (IBT-092, IBT-136) must equal base amount (IBT-093, IBT-137) * percentage (IBT-094, IBT-138) /100 if base amount and percentage exists</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:CategoryCode/cbc:ID = &quot;N&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:CategoryCode/cbc:ID = &quot;N&quot;)">
          <xsl:attribute name="id">ibr-115-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-115-ae]-Document level allowance tax category code (IBT-095) cannot be 'Standard rate additional VAT'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:TaxCategory/cbc:ID = &quot;E&quot; and not(exists(cbc:AllowanceChargeReasonCode)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:TaxCategory/cbc:ID = &quot;E&quot; and not(exists(cbc:AllowanceChargeReasonCode)))">
          <xsl:attribute name="id">ibr-168-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-168-ae]-Document level allowances (IBG-20) with Document level allowance VAT category code (IBT-095) as 'Exempt from VAT' MUST have a Document level allowance VAT exemption reason code (IBT-196)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = true()]" mode="M12" priority="1029">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator = true()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(parent::ubl:Invoice|parent::cn:CreditNote) or exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(parent::ubl:Invoice|parent::cn:CreditNote) or exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID)">
          <xsl:attribute name="id">aligned-ibrp-037</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-037]-Each Document level charge (ibg-21) MUST have a Document level charge VAT category code (ibt-102).</svrl:text>
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

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cbc:BaseAmount) and exists(cbc:MultiplierFactorNumeric)) or (cbc:Amount = (cbc:BaseAmount * cbc:MultiplierFactorNumeric) div 100)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cbc:BaseAmount) and exists(cbc:MultiplierFactorNumeric)) or (cbc:Amount = (cbc:BaseAmount * cbc:MultiplierFactorNumeric) div 100)">
          <xsl:attribute name="id">ibr-146-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-146-ae]-Charge amount (IBT-099, IBT-141) must equal base amount (IBT-100, IBT-142) * percentage (IBT-101, IBT-143) /100 if base amount and percentage exists</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:CategoryCode/cbc:ID = &quot;N&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:CategoryCode/cbc:ID = &quot;N&quot;)">
          <xsl:attribute name="id">ibr-114-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-114-ae]-Document level charge VAT category code (IBT-102) cannot be 'Standard rate additional VAT'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:TaxCategory/cbc:ID = &quot;E&quot; and not(exists(cbc:AllowanceChargeReasonCode)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:TaxCategory/cbc:ID = &quot;E&quot; and not(exists(cbc:AllowanceChargeReasonCode)))">
          <xsl:attribute name="id">ibr-169-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-169-ae]-Document level charge (IBG-21) with Document level charge VAT category code (IBT-102) as 'Exempt from VAT' MUST have a Document level charge VAT exemption reason code (IBT-198).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:CalculationRate" mode="M12" priority="1028">
    <svrl:fired-rule context="cbc:CalculationRate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(., &quot;^\d+(\.\d{7})?$&quot;))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(., &quot;^\d+(\.\d{7})?$&quot;))">
          <xsl:attribute name="id">ibr-002-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-002-ae]-Currency exchange rate [BTAE-04] should contain the values till maximum of 6 decimal places.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M12" priority="1027">
    <svrl:fired-rule context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cac:Item/cac:ClassifiedTaxCategory)) or (exists(cac:Item/cac:ClassifiedTaxCategory) and exists(cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount) and exists(cac:ItemPriceExtension/cbc:Amount))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cac:Item/cac:ClassifiedTaxCategory)) or (exists(cac:Item/cac:ClassifiedTaxCategory) and exists(cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount) and exists(cac:ItemPriceExtension/cbc:Amount))">
          <xsl:attribute name="id">ibr-104-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-104-ae]-An Invoice line (IBG-25), where Line VAT Information (IBG-30) is present then Invoice line amount in AED (BTAE-10) and VAT Line amount in AED (BTAE-08) must be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Item/cac:ClassifiedTaxCategory/cbc:ID=&quot;N&quot; and cac:Item/cac:ClassifiedTaxCategory/cbc:Percent > 0) or not(cac:Item/cac:ClassifiedTaxCategory/cbc:ID=&quot;N&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Item/cac:ClassifiedTaxCategory/cbc:ID=&quot;N&quot; and cac:Item/cac:ClassifiedTaxCategory/cbc:Percent > 0) or not(cac:Item/cac:ClassifiedTaxCategory/cbc:ID=&quot;N&quot;)">
          <xsl:attribute name="id">ibr-111-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-111-ae]-An Invoice line (IBG-25) where the VAT category code (IBT-151) is 'Standard rate additional VAT' the Invoiced item VAT rate (IBT-152) should not be zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Item/cac:ClassifiedTaxCategory)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Item/cac:ClassifiedTaxCategory)">
          <xsl:attribute name="id">ibr-145-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-145-ae]-Each Invoice line (IBG-25) MUST be categorized with an Invoiced item VAT category code (IBT-151)..</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="round(cbc:LineExtensionAmount * 100) div 100 = round((((cbc:InvoicedQuantity | cbc:CreditedQuantity) * (cac:Price/cbc:PriceAmount div cac:Price/cbc:BaseQuantity)) + sum(cac:AllowanceCharge[cbc:ChargeIndicator=&quot;true&quot;]/cbc:Amount) - sum(cac:AllowanceCharge[cbc:ChargeIndicator=&quot;false&quot;]/cbc:Amount)) * 100) div 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="round(cbc:LineExtensionAmount * 100) div 100 = round((((cbc:InvoicedQuantity | cbc:CreditedQuantity) * (cac:Price/cbc:PriceAmount div cac:Price/cbc:BaseQuantity)) + sum(cac:AllowanceCharge[cbc:ChargeIndicator=&quot;true&quot;]/cbc:Amount) - sum(cac:AllowanceCharge[cbc:ChargeIndicator=&quot;false&quot;]/cbc:Amount)) * 100) div 100">
          <xsl:attribute name="id">ibr-147-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-147-ae]-Invoice line net amount (IBT-131) MUST equal (Invoiced quantity (IBT-129) * (Item net price (IBT-146)/item price base quantity (IBT-149)) + Sum of invoice line charge amount (IBT-141) - sum of invoice line allowance amount (IBT-136).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Item/cac:ClassifiedTaxCategory/cbc:ID = &quot;E&quot; and not(exists(cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Item/cac:ClassifiedTaxCategory/cbc:ID = &quot;E&quot; and not(exists(cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode)))">
          <xsl:attribute name="id">ibr-167-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-167-ae]-Line VAT information (IBG-30) with Invoiced item VAT category code (IBT-151) as 'Exempt from VAT' MUST have a VAT exemption reason code (IBT-186).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((../cbc:InvoiceTypeCode = &quot;81&quot; or ../cbc:InvoiceTypeCode = &quot;480&quot;) and count(cac:Item/cac:ClassifiedTaxCategory) = 1) or not(../cbc:InvoiceTypeCode = &quot;81&quot; or ../cbc:InvoiceTypeCode = &quot;480&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((../cbc:InvoiceTypeCode = &quot;81&quot; or ../cbc:InvoiceTypeCode = &quot;480&quot;) and count(cac:Item/cac:ClassifiedTaxCategory) = 1) or not(../cbc:InvoiceTypeCode = &quot;81&quot; or ../cbc:InvoiceTypeCode = &quot;480&quot;)">
          <xsl:attribute name="id">ibr-123-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-123-ae]- Line VAT Information (IBG - 30) MUST be there and can occur maximum once except in case when invoice type code is 'Out of scope of VAT' or 'Credit note related to goods or services'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:ItemPriceExtension/cbc:Amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:ItemPriceExtension/cbc:Amount)">
          <xsl:attribute name="id">ibr-194-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-194-ae]- Invoice line Amount payable (BTAE-10) must be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M12" priority="1026">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:peppol:pint:billing-1@ae-1') or starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:peppol:pint:selfbilling-1@ae-1')" />
      <xsl:otherwise>
        <svrl:failed-assert test="starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:peppol:pint:billing-1@ae-1') or starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:peppol:pint:selfbilling-1@ae-1')">
          <xsl:attribute name="id">aligned-ibrp-001-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-001-ae]-Specification identifier (ibt-024) MUST start with the value 'urn:peppol:pint:billing-1@ae-1' or 'urn:peppol:pint:selfbilling-1@ae-1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="/*/cbc:ProfileID and (matches(normalize-space(/*/cbc:ProfileID), 'urn:peppol:bis:billing') or matches(normalize-space(/*/cbc:ProfileID), 'urn:peppol:bis:selfbilling'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="/*/cbc:ProfileID and (matches(normalize-space(/*/cbc:ProfileID), 'urn:peppol:bis:billing') or matches(normalize-space(/*/cbc:ProfileID), 'urn:peppol:bis:selfbilling'))">
          <xsl:attribute name="id">aligned-ibrp-002-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-002-ae]-Business process (ibt-023) MUST be in the format 'urn:peppol:bis:billing' or 'urn:peppol:bis:selfbilling'.</svrl:text>
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
          <svrl:text>[aligned-ibrp-e-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the VAT category code (ibt-151, ibt-95 or ibt-102) is "Exempt from VAT" MUST contain exactly one VAT breakdown (ibg-23) with the VAT category code (ibt-118) equal to "Exempt from VAT".</svrl:text>
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
          <svrl:text>[aligned-ibrp-o-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the VAT category code (ibt-151, ibt-95 or ibt-102) is "Not subject to VAT" MUST contain exactly one VAT breakdown group (ibg-23) with the VAT category code (ibt-118) equal to "Not subject to VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) > 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) > 0) or ((count(//cac:AllowanceCharge/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) + count(//cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'])) = 0 and count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S']) = 0)">
          <xsl:attribute name="id">aligned-ibrp-s-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the VAT category code (ibt-151, ibt-95 or ibt-102) is "Standard rated" MUST contain in the VAT breakdown (ibg-23) at least one VAT category code (ibt-118) equal with "Standard rated".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'Z']))">
          <xsl:attribute name="id">aligned-ibrp-z-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-01]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the VAT category code (ibt-151, ibt-95 or ibt-102) is "Zero rated" MUST contain in the VAT breakdown (ibg-23) exactly one VAT category code (ibt-118) equal with "Zero rated".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) >= 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) >= 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'AE']))">
          <xsl:attribute name="id">aligned-ibrp-ae-01-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-ae-01-ae]-An Invoice that contains an Invoice line (ibg-25), a Document level allowance (ibg-20) or a Document level charge (ibg-21) where the VAT category code (ibt-151, ibt-095 or ibt-102) is "Reverse charge" MUST contain in the VAT Breakdown (ibg-23) at least  one VAT category code (ibt-118) equal with "VAT reverse charge".</svrl:text>
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
          <svrl:text>[aligned-ibrp-sr-12]-Seller tax identifier (ibt-031) MUST occur maximum once</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(cbc:ProfileExecutionID, &quot;^1[01]{7}$&quot;)) or cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(cbc:ProfileExecutionID, &quot;^1[01]{7}$&quot;)) or cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
          <xsl:attribute name="id">ibr-007-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-007-ae]-When Invoice Transaction-type code (BTAE-02) has value 1XXXXXXX (Free trade zone), then providing value in Beneficiary ID (BTAE-01) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(not((cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;480&quot; or (cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;81&quot;) and cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = &quot;VAT&quot;]/cbc:CompanyID) or ((cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;480&quot; or (cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;81&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(not((cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;480&quot; or (cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;81&quot;) and cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = &quot;VAT&quot;]/cbc:CompanyID) or ((cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;480&quot; or (cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;81&quot;)">
          <xsl:attribute name="id">ibr-134-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-134-ae]-Seller VAT Identifier (IBT-031) MUST be there, except when the Invoice type code (IBT-003) is 'Out of scope of VAT' or 'Credit note related to goods or services'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(matches(cbc:ProfileExecutionID, &quot;^[01]{5}1[01]{2}$&quot;) and cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) or not(matches(cbc:ProfileExecutionID, &quot;^[01]{5}1[01]{2}$&quot;))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(matches(cbc:ProfileExecutionID, &quot;^[01]{5}1[01]{2}$&quot;) and cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) or not(matches(cbc:ProfileExecutionID, &quot;^[01]{5}1[01]{2}$&quot;))">
          <xsl:attribute name="id">ibr-137-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-137-ae]-Principle ID (BTAE-14) is MUST, where Invoice transaction type code [BTAE-02] is XXXXX1XX (Disclosed Agent billing).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(matches(cbc:ProfileExecutionID, &quot;^[01]{3}1[01]{4}$&quot;) and cac:InvoicePeriod) or not(matches(cbc:ProfileExecutionID, &quot;^[01]{3}1[01]{4}$&quot;))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(matches(cbc:ProfileExecutionID, &quot;^[01]{3}1[01]{4}$&quot;) and cac:InvoicePeriod) or not(matches(cbc:ProfileExecutionID, &quot;^[01]{3}1[01]{4}$&quot;))">
          <xsl:attribute name="id">ibr-138-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-138-ae]-Invoicing period [IBG-14] is MUST, where Invoice transaction type code [BTAE-02] is XXX1XXXX (Summary invoice).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxPointDate) or cbc:TaxPointDate &lt; cbc:IssueDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxPointDate) or cbc:TaxPointDate &lt; cbc:IssueDate">
          <xsl:attribute name="id">ibr-141-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-141-ae]-When, VAT point date [IBT-007] is present, it should be before the Invoice issue date [IBT-002].</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((cbc:InvoiceTypeCode = &quot;381&quot; or cbc:InvoiceTypeCode = &quot;81&quot;) and (((cac:BillingReference) and  (cac:DiscrepancyResponse/cbc:ResponseCode != &quot;VD&quot;)) or (not(cac:BillingReference) and  (cac:DiscrepancyResponse/cbc:ResponseCode = &quot;VD&quot;))))  or not(cbc:InvoiceTypeCode = &quot;381&quot; or cbc:InvoiceTypeCode = &quot;81&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((cbc:InvoiceTypeCode = &quot;381&quot; or cbc:InvoiceTypeCode = &quot;81&quot;) and (((cac:BillingReference) and (cac:DiscrepancyResponse/cbc:ResponseCode != &quot;VD&quot;)) or (not(cac:BillingReference) and (cac:DiscrepancyResponse/cbc:ResponseCode = &quot;VD&quot;)))) or not(cbc:InvoiceTypeCode = &quot;381&quot; or cbc:InvoiceTypeCode = &quot;81&quot;)">
          <xsl:attribute name="id">ibr-055-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-055-ae]-Preceding invoice reference (IBG-03) is must when invoice type code (IBT-003) is 381 (Credit note) or 81 (Credit note related to goods or services) except when the [BTAE-03] Credit note reason code is 'VD'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(cbc:ProfileExecutionID, &quot;^[01]{6}1[01]$&quot;)) or (cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName and  cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(cbc:ProfileExecutionID, &quot;^[01]{6}1[01]$&quot;)) or (cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity)">
          <xsl:attribute name="id">ibr-142-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-142-ae]-In Delivery Information (ibg-13), Deliver to address line 1 (IBT-075), Deliver to city (IBT-077), Deliver to country subdivision (IBT-079) MUST be there, in case the Invoice transaction type code [BTAE-02] is XXXXXX1X (E-commerce supplies).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))=&quot;VAT&quot;]/cbc:ID[normalize-space(.) = &quot;N&quot;]) and (count(//cac:TaxTotal/cac:TaxSubtotal) = 1)) or not(exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))=&quot;VAT&quot;]/cbc:ID[normalize-space(.) = &quot;N&quot;]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))=&quot;VAT&quot;]/cbc:ID[normalize-space(.) = &quot;N&quot;]) and (count(//cac:TaxTotal/cac:TaxSubtotal) = 1)) or not(exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))=&quot;VAT&quot;]/cbc:ID[normalize-space(.) = &quot;N&quot;]))">
          <xsl:attribute name="id">ibr-105-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-105-ae]-An Invoice that contains an Invoice line (IBG-25), where the VAT category code (IBT-151) is 'Standard rate additional VAT' shall contain exactly one VAT breakdown group (IBG-23) with the VAT category code (IBT-118) equal to 'Standard rate additional VAT'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((cbc:InvoiceTypeCode = &quot;81&quot; or cbc:InvoiceTypeCode = &quot;480&quot;) and (//cac:TaxCategory/cbc:ID = &quot;E&quot; or //cac:TaxCategory/cbc:ID = &quot;O&quot; or //cac:TaxCategory/cbc:ID = &quot;Z&quot;) and (//cac:ClassifiedTaxCategory/cbc:ID = &quot;E&quot; or //cac:ClassifiedTaxCategory/cbc:ID = &quot;O&quot;  or //cac:ClassifiedTaxCategory/cbc:ID = &quot;Z&quot;)) or not(cbc:InvoiceTypeCode = &quot;81&quot; or cbc:InvoiceTypeCode = &quot;480&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="((cbc:InvoiceTypeCode = &quot;81&quot; or cbc:InvoiceTypeCode = &quot;480&quot;) and (//cac:TaxCategory/cbc:ID = &quot;E&quot; or //cac:TaxCategory/cbc:ID = &quot;O&quot; or //cac:TaxCategory/cbc:ID = &quot;Z&quot;) and (//cac:ClassifiedTaxCategory/cbc:ID = &quot;E&quot; or //cac:ClassifiedTaxCategory/cbc:ID = &quot;O&quot; or //cac:ClassifiedTaxCategory/cbc:ID = &quot;Z&quot;)) or not(cbc:InvoiceTypeCode = &quot;81&quot; or cbc:InvoiceTypeCode = &quot;480&quot;)">
          <xsl:attribute name="id">ibr-122-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-122-ae]-When Invoice type code (IBT-003) is 'Out of scope of VAT' or 'Credit note related to goods or services', then the Document level allowance VAT category code (IBT-095), Document level charge VAT category code (IBT-102), Invoiced item VAT category code (IBT-151) MUST be either 'Exempt from VAT' and/or 'Not subject to VAT' and/or 'Zero rated'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:InvoiceTypeCode = &quot;381&quot; or cbc:InvoiceTypeCode = &quot;81&quot;) or not(cbc:TaxPointDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:InvoiceTypeCode = &quot;381&quot; or cbc:InvoiceTypeCode = &quot;81&quot;) or not(cbc:TaxPointDate)">
          <xsl:attribute name="id">ibr-124-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-124-ae]-VAT point date [IBT-007] MUST not be there when invoice type code (IBT-003) is 'credit note' or 'Credit note related to goods or services'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;381&quot; or (cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;81&quot; or (cbc:CreditNoteTypeCode) = &quot;261&quot;) or (matches(cbc:ProfileExecutionID, &quot;^[01]1[01]{6}$&quot;)) or (cac:LegalMonetaryTotal/cbc:PayableAmount > 0 and (cbc:DueDate))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;381&quot; or (cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode) = &quot;81&quot; or (cbc:CreditNoteTypeCode) = &quot;261&quot;) or (matches(cbc:ProfileExecutionID, &quot;^[01]1[01]{6}$&quot;)) or (cac:LegalMonetaryTotal/cbc:PayableAmount > 0 and (cbc:DueDate))">
          <xsl:attribute name="id">ibr-127-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-127-ae]-Payment due date [IBT-009] MUST be present when the amount due for payment (IBT-115) greater than 0, except when invoice type code (IBT-003) is 'Credit note' or 'Credit note related to goods or services' or Invoice transaction-type code (BTAE-002) is X1XXXXXX (Deemed supply) .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(cbc:ProfileExecutionID, &quot;^[01]{2}1[01]{5}$&quot;)) or not(//cac:TaxCategoryCode/cbc:ID = &quot;N&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(cbc:ProfileExecutionID, &quot;^[01]{2}1[01]{5}$&quot;)) or not(//cac:TaxCategoryCode/cbc:ID = &quot;N&quot;)">
          <xsl:attribute name="id">ibr-116-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-116-ae]-When Invoice transaction-type code (BTAE-02) has value XX1XXXXX (Margin scheme), then the tax category code (IBT-151) should have 'Standard rate additional VAT '.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cbc:InvoiceTypeCode = &quot;380&quot; or cbc:InvoiceTypeCode = &quot;381&quot;) and not(cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID != &quot;E&quot; and cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID != &quot;O&quot;))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cbc:InvoiceTypeCode = &quot;380&quot; or cbc:InvoiceTypeCode = &quot;381&quot;) and not(cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID != &quot;E&quot; and cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID != &quot;O&quot;))">
          <xsl:attribute name="id">ibr-151-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-151-ae]-When Invoice type code (IBT-003) is 'Commercial invoice' or 'Credit note',  Invoiced item VAT category code (IBT-151) should not only contain 'Exempt from VAT' and/or 'Not subject to VAT'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(cbc:ProfileExecutionID, &quot;^[01]{7}1$&quot;)) or (cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName and  cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(cbc:ProfileExecutionID, &quot;^[01]{7}1$&quot;)) or (cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity)">
          <xsl:attribute name="id">ibr-152-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-152-ae]-In Delivery Information (IBG-13), Deliver to address line 1 (IBT-075), deliver to city (IBT-077), deliver to country subdivision (IBT-079) MUST be there, in case the Invoice transaction type code [BTAE-02] is XXXXXXX1 (Exports) and the deliver to country code [IBT-080] should not be 'AE'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxCurrencyCode = &quot;AED&quot; and cbc:DocumentCurrencyCode != &quot;AED&quot; and (not(cac:TaxExchangeRate/cbc:SourceCurrencyCode = cbc:DocumentCurrencyCode) or not(cac:TaxExchangeRate/cbc:TargetCurrencyCode = cbc:TaxCurrencyCode) or not(cac:TaxExchangeRate/cbc:CalculationRate)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxCurrencyCode = &quot;AED&quot; and cbc:DocumentCurrencyCode != &quot;AED&quot; and (not(cac:TaxExchangeRate/cbc:SourceCurrencyCode = cbc:DocumentCurrencyCode) or not(cac:TaxExchangeRate/cbc:TargetCurrencyCode = cbc:TaxCurrencyCode) or not(cac:TaxExchangeRate/cbc:CalculationRate)))">
          <xsl:attribute name="id">ibr-153-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-153-ae]-When the Tax accounting currency (IBT-006) is set to AED and the invoice currency code (IBT-005) differs from AED, the source currency must be designated as the invoice currency code (IBT-005), and the target currency must be specified as the Tax accounting currency (IBT-006), provided that the currency exchange rate (BTAE-04) is available</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cbc:InvoiceTypeCode = &quot;480&quot; or cbc:InvoiceTypeCode = &quot;81&quot;) and  matches(cbc:ProfileExecutionID, &quot;^[01]{2}1[01]{5}$|^[01]1[01]{6}$|^[01]{3}1[01]{4}$&quot;))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cbc:InvoiceTypeCode = &quot;480&quot; or cbc:InvoiceTypeCode = &quot;81&quot;) and matches(cbc:ProfileExecutionID, &quot;^[01]{2}1[01]{5}$|^[01]1[01]{6}$|^[01]{3}1[01]{4}$&quot;))">
          <xsl:attribute name="id">ibr-157-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-157-ae]-Invoice Transaction-type code (BTAE-02) cannot be XXX1XXXX (Summary invoice) or X1XXXXXX (Deemed supply) or XX1XXXXX (Margin scheme) when the invoice type code (IBT-003) is 'Out of scope of VAT' or 'Credit note related to goods or services'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:InvoiceTypeCode = &quot;381&quot; and not(exists(cac:DiscrepancyResponse/cbc:ResponseCode)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:InvoiceTypeCode = &quot;381&quot; and not(exists(cac:DiscrepancyResponse/cbc:ResponseCode)))">
          <xsl:attribute name="id">ibr-158-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-158-ae]-Where the Invoice type code [IBT-003] is 'Credit note', Credit note reason code [BTAE-03] MUST be there .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:DocumentCurrencyCode != &quot;AED&quot; and (exists(//cbc:CalculationRate))) or cbc:DocumentCurrencyCode = &quot;AED&quot;" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:DocumentCurrencyCode != &quot;AED&quot; and (exists(//cbc:CalculationRate))) or cbc:DocumentCurrencyCode = &quot;AED&quot;">
          <xsl:attribute name="id">ibr-159-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-159-ae]-Currency exchange rate [BTAE-04] is MUST when then Invoice currency code [IBT-005] is different from 'AED'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:InvoicePeriod/cbc:DescriptionCode = &quot;OTH&quot; and not(exists(cbc:Note)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:InvoicePeriod/cbc:DescriptionCode = &quot;OTH&quot; and not(exists(cbc:Note)))">
          <xsl:attribute name="id">ibr-160-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-160-ae]-When Frequency of billing (BTAE-06) value is 'Others', then value should be provided in Invoice note (IBT-022).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:DocumentCurrencyCode = &quot;AED&quot; or (cbc:DocumentCurrencyCode != &quot;AED&quot; and cbc:TaxCurrencyCode = &quot;AED&quot; and exists(cac:TaxTotal/cbc:TaxAmount[@currencyID = &quot;AED&quot;]) and exists(cac:AdditionalDocumentReference[cbc:DocumentTypeCode = &quot;aedtotal-incl-vat&quot;]/cbc:DocumentDescription))" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:DocumentCurrencyCode = &quot;AED&quot; or (cbc:DocumentCurrencyCode != &quot;AED&quot; and cbc:TaxCurrencyCode = &quot;AED&quot; and exists(cac:TaxTotal/cbc:TaxAmount[@currencyID = &quot;AED&quot;]) and exists(cac:AdditionalDocumentReference[cbc:DocumentTypeCode = &quot;aedtotal-incl-vat&quot;]/cbc:DocumentDescription))">
          <xsl:attribute name="id">ibr-175-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-175-ae]-When Invoice currency code [IBT-005] is other than 'AED' and Tax accounting currency [IBT-006] is 'AED', then the value in Invoice total VAT amount in tax accounting currency [IBT-111] and Invoice (or CreditNote) total amount with VAT in AED [BTAE-20] MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(matches(cbc:ProfileExecutionID, &quot;^[01]{5}1[01]{2}$&quot;) and cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID !=  cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) or not(matches(cbc:ProfileExecutionID, &quot;^[01]{5}1[01]{2}$&quot;))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(matches(cbc:ProfileExecutionID, &quot;^[01]{5}1[01]{2}$&quot;) and cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID != cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID) or not(matches(cbc:ProfileExecutionID, &quot;^[01]{5}1[01]{2}$&quot;))">
          <xsl:attribute name="id">ibr-176-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-176-ae]-When Invoice transaction type code [BTAE-02] is XXXXX1XX (Disclosed agent billing), then the value in field Seller VAT Identifier [IBT-031] and Principle ID [BTAE-14] should not be the same.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PartyLegalEntity/cbc:CompanyID) or not(cbc:EndpointID[@schemeID = &quot;0235&quot;]) or  starts-with(cbc:EndpointID, &quot;1&quot;) or cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = (&quot;CL&quot;, &quot;EID&quot;, &quot;PAS&quot;, &quot;CD&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PartyLegalEntity/cbc:CompanyID) or not(cbc:EndpointID[@schemeID = &quot;0235&quot;]) or starts-with(cbc:EndpointID, &quot;1&quot;) or cac:PartyLegalEntity/cbc:CompanyID/@schemeAgencyID = (&quot;CL&quot;, &quot;EID&quot;, &quot;PAS&quot;, &quot;CD&quot;)">
          <xsl:attribute name="id">ibr-183-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-183-ae]-The value in Buyer legal registration identifier type [BTAE-16] should either be 'Commercial/Trade license' or 'Emirates ID' or 'Passport' or 'Cabinet decision' when Buyer legal registration identifier (IBT-047) is provided and scheme identifier (IBT-049-1) is '0235' and buyer electronic address (IBT-049) is not '1XXXXXXXXX'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(//cac:TaxCategory/cbc:ID = &quot;S&quot;) or //cac:TaxCategory[cbc:ID = &quot;S&quot;]/cbc:Percent = 5.00" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(//cac:TaxCategory/cbc:ID = &quot;S&quot;) or //cac:TaxCategory[cbc:ID = &quot;S&quot;]/cbc:Percent = 5.00">
          <xsl:attribute name="id">ibr-190-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-190-ae]- When the Invoiced item VAT category code (ibt-151), Document level allowance VAT category code (ibt-095), Document level charge VAT category code (ibt-102) is Standard rated then Invoiced item VAT rate (ibt-152), Document level allowance VAT rate (ibt-096), Document level charge VAT rate (ibt-103) must be 5.00.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:PaymentMeans/cbc:PaymentMeansCode) = not((cbc:InvoiceTypeCode|cbc:CreditNoteTypeCode) = &quot;81&quot; or (cbc:InvoiceTypeCode|cbc:CreditNoteTypeCode) = &quot;381&quot; or  (cbc:InvoiceTypeCode|cbc:CreditNoteTypeCode) = &quot;261&quot;or matches(cbc:ProfileExecutionID, &quot;^[01]1[01]{7}$&quot;))" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:PaymentMeans/cbc:PaymentMeansCode) = not((cbc:InvoiceTypeCode|cbc:CreditNoteTypeCode) = &quot;81&quot; or (cbc:InvoiceTypeCode|cbc:CreditNoteTypeCode) = &quot;381&quot; or (cbc:InvoiceTypeCode|cbc:CreditNoteTypeCode) = &quot;261&quot;or matches(cbc:ProfileExecutionID, &quot;^[01]1[01]{7}$&quot;))">
          <xsl:attribute name="id">ibr-191-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-191-ae]- Payment means type code (ibt-081) must be provided except when the invoice type code (ibt-003) is 'Credit note' or 'Credit note related to goods or Invoice transaction-type code (BTAE-002) is X1XXXXXX (Deemed supply) .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(matches(cbc:ProfileExecutionID, &quot;^[01]{8}$&quot;))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(matches(cbc:ProfileExecutionID, &quot;^[01]{8}$&quot;))">
          <xsl:attribute name="id">ibr-154-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-154-ae]-Invoice Transaction-type code (BTAE-02) must be provided from the Invoice Transaction Type Code List. It should be a string consisting of no more than 8 characters, exclusively comprising of 0 and 1. The value in this field should be based on the sequence of transaction present in the invoice (as per list order), If applicable '1', and if not applicable '0' .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxCurrencyCode) or cbc:TaxCurrencyCode = &quot;AED&quot;" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxCurrencyCode) or cbc:TaxCurrencyCode = &quot;AED&quot;">
          <xsl:attribute name="id">ibr-140-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-140-ae]-When VAT accounting currency (IBT-006) is present, it shall be AED.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:UUID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:UUID)">
          <xsl:attribute name="id">ibr-193-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-193-ae]- The unique identifier number (BTAE-07) must be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Item" mode="M12" priority="1025">
    <svrl:fired-rule context="cac:Item" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="boolean(cbc:Description)" />
      <xsl:otherwise>
        <svrl:failed-assert test="boolean(cbc:Description)">
          <xsl:attribute name="id">ibr-125-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-125-ae]-In Item Information(IBG-31), Item description (IBT-154) MUST be there.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:ClassifiedTaxCategory/cbc:ID = &quot;AE&quot; and (exists(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:NatureCode))) or cac:ClassifiedTaxCategory/cbc:ID != &quot;AE&quot;" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:ClassifiedTaxCategory/cbc:ID = &quot;AE&quot; and (exists(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:NatureCode))) or cac:ClassifiedTaxCategory/cbc:ID != &quot;AE&quot;">
          <xsl:attribute name="id">ibr-166-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-166-ae]-In Item information (IBG-31) where Invoiced VAT category code (IBT-151) is 'Reverse charge', Type of goods or services (BTAE-09) MUST be there.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:CommodityClassification/cbc:CommodityCode = &quot;G&quot;) or cac:CommodityClassification/cbc:ItemClassificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:CommodityClassification/cbc:CommodityCode = &quot;G&quot;) or cac:CommodityClassification/cbc:ItemClassificationCode">
          <xsl:attribute name="id">ibr-184-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-184-ae]-When the Item type [BTAE-13] is 'Goods' then Item classification identifier (ibt-158) must be provided. .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:CommodityClassification/cbc:CommodityCode = &quot;S&quot;) or cac:AdditionalItemIdentification/cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:CommodityClassification/cbc:CommodityCode = &quot;S&quot;) or cac:AdditionalItemIdentification/cbc:ID">
          <xsl:attribute name="id">ibr-185-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-185-ae]-When the Item type [BTAE-13] is 'Services' then Service accounting code (BTAE-17) must be provided. .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:CommodityClassification/cbc:CommodityCode = &quot;B&quot;) or cac:CommodityClassification/cbc:ItemClassificationCode or cac:AdditionalItemIdentification/cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:CommodityClassification/cbc:CommodityCode = &quot;B&quot;) or cac:CommodityClassification/cbc:ItemClassificationCode or cac:AdditionalItemIdentification/cbc:ID">
          <xsl:attribute name="id">ibr-186-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-186-ae]-When the Item type [BTAE-13] is 'Both' then Item classification identifier (ibt-158) and Service accounting code (BTAE-17) must be provided. .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="true()" />
      <xsl:otherwise>
        <svrl:failed-assert test="true()">
          <xsl:attribute name="id">ibr-187-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-187-ae]- The minimum number of digits to be provided should be 'X' in Item classification identifier (ibt-158) and Service accounting code (BTAE-17).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:CommodityClassification/cbc:ItemClassificationCode) or cac:CommodityClassification/cbc:ItemClassificationCode/@listID = &quot;HS&quot;" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:CommodityClassification/cbc:ItemClassificationCode) or cac:CommodityClassification/cbc:ItemClassificationCode/@listID = &quot;HS&quot;">
          <xsl:attribute name="id">ibr-188-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-188-ae]- The scheme identifier (ibt-158-1) MUST be HS when Item classification identifier (ibt-158) is provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:AdditionalItemIdentification/cbc:ID) or cac:AdditionalItemIdentification/cbc:ID/@schemeID = &quot;SAC&quot;" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:AdditionalItemIdentification/cbc:ID) or cac:AdditionalItemIdentification/cbc:ID/@schemeID = &quot;SAC&quot;">
          <xsl:attribute name="id">ibr-189-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-189-ae]- The scheme identifier (BTAE-17-1) MUST be SAC when Service accounting code (BTAE-17) is provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxSubtotal" mode="M12" priority="1024">
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
          <svrl:text>[aligned-ibrp-045]-Each VAT breakdown (ibg-23) MUST have a VAT category taxable amount (ibt-116).</svrl:text>
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
          <svrl:text>[aligned-ibrp-046]-Each VAT breakdown (ibg-23) MUST have a VAT category tax amount (ibt-117).</svrl:text>
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
          <svrl:text>[aligned-ibrp-047]-Each VAT breakdown (ibg-23) MUST be defined through a VAT category code (ibt-118).</svrl:text>
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
          <svrl:text>[aligned-ibrp-048]-Each VAT breakdown (ibg-23) MUST have a VAT category rate (ibt-119), except if the Invoice is not subject to VAT.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:TaxCategory/cbc:ID = &quot;O&quot;) and not(cac:TaxCategory/cbc:Percent) or  (not(cac:TaxCategory/cbc:ID = &quot;O&quot;)) and cac:TaxCategory/cbc:Percent" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:TaxCategory/cbc:ID = &quot;O&quot;) and not(cac:TaxCategory/cbc:Percent) or (not(cac:TaxCategory/cbc:ID = &quot;O&quot;)) and cac:TaxCategory/cbc:Percent">
          <xsl:attribute name="id">ibr-119-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-119-ae]-Each VAT breakdown (IBG-23) shall have a VAT category rate (IBT-119), except if the Invoice is not subject to VAT and Exempt from Tax.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1023">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) > 0)">
          <xsl:attribute name="id">aligned-ibrp-s-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-05]-In an Invoice line (ibg-25) where the Invoiced item VAT category code (ibt-151) is "Standard rated" the Invoiced item VAT rate (ibt-152) MUST be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1022">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) > 0)">
          <xsl:attribute name="id">aligned-ibrp-s-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-06]-In a Document level allowance (ibg-20) where the Document level allowance VAT category code (ibt-95) is "Standard rated" the Document level allowance VAT rate (ibt-96) MUST be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1021">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) > 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) > 0)">
          <xsl:attribute name="id">aligned-ibrp-s-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-07]-In a Document level charge (ibg-21) where the Document level charge VAT category code (ibt-102) is "Standard rated" the Document level charge VAT rate (ibt-103) MUST be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1020">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'S'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in xs:decimal(cbc:Percent) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)),0.02))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)),0.02))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in xs:decimal(cbc:Percent) satisfies (((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)),0.02))) or ((exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = 'S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) or exists(//cac:AllowanceCharge[cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate])) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='S'][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='S'][cac:TaxCategory/xs:decimal(cbc:Percent) = $rate]/xs:decimal(cbc:Amount)),0.02))))">
          <xsl:attribute name="id">aligned-ibrp-s-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-08]-For each different value of VAT category rate (ibt-119) where the VAT category code (ibt-118) is "Standard rated", the VAT category taxable amount (ibt-116) in a VAT breakdown (ibg-23) MUST equal the sum of Invoice line net amounts (ibt-131) plus the sum of document level charge amounts (ibt-99) minus the sum of document level allowance amounts (ibt-92) where the VAT category code (ibt-151, ibt-102, ibt-95) is "Standard rated" and the VAT rate (ibt-152, ibt-103, ibt-96) equals the VAT category rate (ibt-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ,0.02 )" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:slack(abs(xs:decimal(../cbc:TaxAmount)) , round((abs(xs:decimal(../cbc:TaxableAmount)) * (xs:decimal(cbc:Percent) div 100)) * 10 * 10) div 100 ,0.02 )">
          <xsl:attribute name="id">aligned-ibrp-s-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-09]-The VAT category tax amount (ibt-117) in a VAT breakdown (ibg-23) where VAT category code (ibt-118) is "Standard rated" MUST equal the VAT category taxable amount (ibt-116) multiplied by the VAT category rate (ibt-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxExemptionReason) and not(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">aligned-ibrp-s-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-s-10]-A VAT breakdown (ibg-23) with VAT Category code (ibt-118) "Standard rate" MUST not have a VAT exemption reason code (ibt-121) or VAT exemption reason text (ibt-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'N'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1019">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'N'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = &quot;N&quot;][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) and  (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)=&quot;N&quot;][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)),0.02))) or (exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = &quot;N&quot;][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate])  and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)=&quot;N&quot;][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) ,0.02))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="every $rate in xs:decimal(cbc:Percent) satisfies ((exists(//cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = &quot;N&quot;][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)=&quot;N&quot;][cac:Item/ cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)),0.02))) or (exists(//cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID) = &quot;N&quot;][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]) and (u:slack(../xs:decimal(cbc:TaxableAmount), sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)=&quot;N&quot;][cac:Item/cac:ClassifiedTaxCategory/xs:decimal(cbc:Percent) =$rate]/xs:decimal(cbc:LineExtensionAmount)) ,0.02))))">
          <xsl:attribute name="id">ibr-102-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-102-ae]-In a VAT Breakdown (IBG-23) where the VAT category code (IBT-118) is 'Standard rate additional VAT', for each different value of VAT category rate (IBT-119) the VAT category taxable amount (IBT-116) shall equal the sum of Invoice line net amounts (IBT-131) where the VAT category code (IBT-151) is 'Standard rate additional VAT' and the VAT rate (IBT-152) equals the VAT category rate (IBT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../cbc:TaxAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../cbc:TaxAmount = 0">
          <xsl:attribute name="id">ibr-108-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-108-ae]-In a VAT breakdown (IBG-23), where VAT category code (IBT-118) is 'Standard rate additional VAT', VAT category tax amount (IBT-117) MUST be equal to 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1018">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

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
          <svrl:text>[aligned-ibrp-e-08]-In a VAT breakdown (ibg-23) where the VAT category code (ibt-118) is "Exempt from VAT" the VAT category taxable amount (ibt-116) MUST equal the sum of Invoice line net amounts (ibt-131) minus the sum of Document level allowance amounts (ibt-92) plus the sum of Document level charge amounts (ibt-99) where the VAT category codes (ibt-151, ibt-95, ibt-102) are "Exempt from VAT".</svrl:text>
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
          <svrl:text>[aligned-ibrp-e-09]-The VAT category tax amount (ibt-117) In a VAT breakdown (ibg-23) where the VAT category code (ibt-118) equals "Exempt from VAT" MUST equal 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:TaxCategory)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:TaxCategory)">
          <xsl:attribute name="id">ibr-121-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-121-ae]-In a VAT breakdown (IBG-23) where VAT category code (IBT-118) is 'Exempt from VAT', VAT category Rate (IBT-119) shall not be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1017">
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
          <svrl:text>[aligned-ibrp-e-05]-In an Invoice line (ibg-25) where the Invoiced item VAT category code (ibt-151) is "Exempt from VAT", the Invoiced item VAT rate (ibt-152) MUST be 0 (zero). </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(../../cac:ItemPriceExtension/cac:TaxAmount/cbc:TaxAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(../../cac:ItemPriceExtension/cac:TaxAmount/cbc:TaxAmount)">
          <xsl:attribute name="id">ibr-163-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-163-ae]-In Line VAT information (IBG-30) where Invoiced item VAT category code (IBT-151) is 'Exempt', VAT Line amount [BTAE-08] shall not be there.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1016">
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
          <svrl:text>[aligned-ibrp-e-06]-In a Document level allowance (ibg-20) where the Document level allowance VAT category code (ibt-95) is "Exempt from VAT", the Document level allowance VAT rate (ibt-96) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='E'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1015">
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
          <svrl:text>[aligned-ibrp-e-07]-In a Document level charge (ibg-21) where the Document level charge VAT category code (ibt-102) is "Exempt from VAT", the Document level charge VAT rate (ibt-103) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1014">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-z-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-05]-In an Invoice line (ibg-25) where the Invoiced item VAT category code (ibt-151) is "Zero rated" the Invoiced item VAT rate (ibt-152) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../../cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../../cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount = 0">
          <xsl:attribute name="id">ibr-165-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-165-ae]-In Line VAT information (IBG-30) where Invoiced item VAT category code (IBT-151) is 'Zero Rated', VAT Line amount [BTAE-08] MUST be zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1013">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-z-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-06]-In a Document level allowance (ibg-20) where the Document level allowance VAT category code (ibt-95) is "Zero rated" the Document level allowance VAT rate (ibt-96) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1012">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-z-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-07]-In a Document level charge (ibg-21) where the Document level charge VAT category code (ibt-102) is "Zero rated" the Document level charge VAT rate (ibt-103) MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1011">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'Z'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='Z']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">aligned-ibrp-z-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-08]-In a VAT breakdown (ibg-23) where VAT category code (ibt-118) is "Zero rated" the VAT category taxable amount (ibt-116) MUST equal the sum of Invoice line net amount (ibt-131) minus the sum of Document level allowance amounts (ibt-92) plus the sum of Document level charge amounts (ibt-99) where the VAT category codes (ibt-151, ibt-95, ibt-102) are "Zero rated".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">aligned-ibrp-z-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-z-09]-The VAT category tax amount (ibt-117) in a VAT breakdown (ibg-23) where VAT category code (ibt-118) is "Zero rated" MUST equal 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../cbc:TaxAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../cbc:TaxAmount = 0">
          <xsl:attribute name="id">ibr-120-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-120-ae]-In a VAT breakdown (IBG-23) where VAT category code (IBT-118) is 'Zero Rated', VAT category Rate (IBT-119) shall equal to 0.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1010">
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
          <svrl:text>[aligned-ibrp-o-05]-An Invoice line (ibg-25) where the VAT category code (ibt-151) is "Not subject to VAT" MUST not contain an Invoiced item VAT rate (ibt-152).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1009">
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
          <svrl:text>[aligned-ibrp-o-06]-A Document level allowance (ibg-20) where VAT category code (ibt-95) is "Not subject to VAT" MUST not contain a Document level allowance VAT rate (ibt-96).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1008">
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
          <svrl:text>[aligned-ibrp-o-07]-A Document level charge (ibg-21) where the VAT category code (ibt-102) is "Not subject to VAT" MUST not contain a Document level charge VAT rate (ibt-103).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1007">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'O'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='O']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">aligned-ibrp-o-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-08]-In a VAT breakdown (ibg-23) where the VAT category code (ibt-118) is " Not subject to VAT" the VAT category taxable amount (ibt-116) MUST equal the sum of Invoice line net amounts (ibt-131) minus the sum of Document level allowance amounts (ibt-92) plus the sum of Document level charge amounts (ibt-99) where the VAT category codes (ibt-151, ibt-95, ibt-102) are "Not subject to VAT".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

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
          <svrl:text>[aligned-ibrp-o-09]-The VAT category tax amount (ibt-117) in a VAT breakdown (ibg-23) where the VAT category code (ibt-118) is "Not subject to VAT" MUST be 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:Percent))">
          <xsl:attribute name="id">aligned-ibrp-o-11-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-o-11-ae]-In a VAT breakdown (IBG-23) where VAT category code (IBT-118) is 'Not Subject to VAT', VAT category tax Rate (IBT-119) shall not be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1006">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] | cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent))">
          <xsl:attribute name="id">aligned-ibrp-ae-05-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-ae-05-ae]-In an Invoice line (ibg-25) where the Invoiced item VAT category code (ibt-151) is "Reverse charge" the Invoiced item VAT rate (ibt-152) MUST be there.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(../../../cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(../../../cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)">
          <xsl:attribute name="id">ibr-103-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-103-ae]-When the Invoiced item VAT category code (ibt-151) is VAT reverse charge, then Buyer VAT identifier (ibt-048) MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../../cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="../../cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount = 0">
          <xsl:attribute name="id">ibr-162-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-162-ae]-In Line VAT information (IBG-30) where Invoiced item VAT category code (IBT-151) is 'Reverse charge', VAT Line amount [BTAE-08] MUST be 'zero'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(not(exists(../cac:StandardItemIdentification/cbc:ID)) or ../cac:StandardItemIdentification/cbc:ID/@schemeID != &quot;0160&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(not(exists(../cac:StandardItemIdentification/cbc:ID)) or ../cac:StandardItemIdentification/cbc:ID/@schemeID != &quot;0160&quot;)">
          <xsl:attribute name="id">ibr-174-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-174-ae]-In Item Information (IBG-31) where Invoiced VAT category code (IBT-151) is 'Reverse charge',  the corresponding Item Standard Identifier (IBT-157) MUST be there and the Scheme Identifier (IBT-157-1) should  have the code 0160.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1005">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-ae-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-ae-06]-In a Document level allowance (ibg-20) where the Document level allowance VAT category code (ibt-95) is "Reverse charge" the Document level allowance VAT rate (ibt-96) MUST be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1004">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">aligned-ibrp-ae-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-ae-07]-In a Document level charge (ibg-21) where the Document level charge VAT category code (ibt-102) is "Reverse charge" the Document level charge VAT rate (ibt-103) MUST be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1003">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'AE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='AE']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">aligned-ibrp-ae-08-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-ae-08-ae]-In a VAT Breakdown (IBG-23) where the VAT category code (IBT-118) is 'Reverse Charge', for each different value of VAT category rate (IBT-119) the VAT category taxable amount (IBT-116) shall equal the sum of Invoice line net amounts (IBT-131) plus the sum of Document level charge amounts (IBT-99) minus the sum of Document level allowance amounts (IBT-92) where the VAT category code (IBT-151, IBT-102, IBT-095) is 'Reverse Charge' and the VAT rate (IBT-152, IBT-103, IBT-096) equals the VAT category rate (IBT-119).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">aligned-ibrp-ae-09-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[aligned-ibrp-ae-09-ae]-In a VAT breakdown (IBG-23) where the VAT category code (IBT-118) is 'Reverse charge', VAT category tax amount (IBT-117) MUST be equal to 0 (zero).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AE']/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']/cbc:CompanyID" mode="M12" priority="1002">
    <svrl:fired-rule context="cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'AE']/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID)) = 'VAT']/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., &quot;^1[a-zA-Z0-9]{12}03$&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., &quot;^1[a-zA-Z0-9]{12}03$&quot;)">
          <xsl:attribute name="id">ibr-132-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-132-ae]-VAT identifier [IBT-031, IBT-048, IBT-063, BTAE-14] should be TRN [VAT registration number] and must be 15 alphanumeric digits, starting with 1, ending with 03 .</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID)) != 'VAT']/cbc:CompanyID" mode="M12" priority="1001">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/normalize-space(upper-case(cbc:ID)) != 'VAT']/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., &quot;^1[0-9]{9}$&quot;)" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., &quot;^1[0-9]{9}$&quot;)">
          <xsl:attribute name="id">ibr-148-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-148-ae]-The Seller VAT registration identifier (IBT-032) should be TIN (tax identification number) and must be 10 numeric digits and should be of the format 1XXXXXXXXXX.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxScheme/cbc:ID" mode="M12" priority="1000">
    <svrl:fired-rule context="cac:TaxScheme/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". = &quot;VAT&quot; or not(exists(/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID))" />
      <xsl:otherwise>
        <svrl:failed-assert test=". = &quot;VAT&quot; or not(exists(/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID))">
          <xsl:attribute name="id">ibr-133-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-133-ae]-VAT scheme code, if provided in (IBT-095-01) or (IBT-031-1) or (IBT-048-1) or (IBT-063-1) or (IBT-102-1) or (IBT-118-1) shall be 'VAT' except when Seller tax registration identifier (IBT-032) is provided.</svrl:text>
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
<xsl:template match="cac:DiscrepancyResponse/cbc:ResponseCode" mode="M13" priority="1005">
    <svrl:fired-rule context="cac:DiscrepancyResponse/cbc:ResponseCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' DL8.61.1.A DL8.61.1.B DL8.61.1.C DL8.61.1.D DL8.61.1.E VD ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' DL8.61.1.A DL8.61.1.B DL8.61.1.C DL8.61.1.D DL8.61.1.E VD ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">ibr-001-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-001-ae]-Credit note reason code [BTAE-03] value should be from the Reasons for credit note code list.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeAgencyID='PAS']/@schemeAgencyName" mode="M13" priority="1004">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeAgencyID='PAS']/@schemeAgencyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">ibr-011-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-011-ae]-Passport issuing country code (BTAE-19) MUST be coded using ISO code list 3166-1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeAgencyID='PAS']/@schemeAgencyName" mode="M13" priority="1003">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeAgencyID='PAS']/@schemeAgencyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">ibr-013-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-013-ae]-Passport issuing country code (BTAE-18) MUST be coded using ISO code list 3166-1.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoicePeriod/cbc:DescriptionCode" mode="M13" priority="1002">
    <svrl:fired-rule context="cac:InvoicePeriod/cbc:DescriptionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' DLY WKY Q15 MTH Q45 Q60 QTR YRL HYR OTH ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' DLY WKY Q15 MTH Q45 Q60 QTR YRL HYR OTH ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">ibr-005-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-005-ae]-Frequency of billing (BTAE-06) should be taken from the frequency of billing code list.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID" mode="M13" priority="1001">
    <svrl:fired-rule context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' S E O AE Z N ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' S E O AE Z N ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">ibr-139-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-139-ae]-Document level allowance tax category code [IBT-095], Document level charge tax category code [IBT-102], Tax category code [IBT-118], Invoiced item tax category code [IBT-151] should be selected from the aligned tax category code.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:NatureCode" mode="M13" priority="1000">
    <svrl:fired-rule context="cbc:NatureCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' DL8.48.8.2 DL8.48.8.1 DL8.48.3.1 DL8.48.3.2 DL8.48.3.3 ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' DL8.48.8.2 DL8.48.8.1 DL8.48.3.1 DL8.48.3.2 DL8.48.3.3 ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">ibr-006-ae</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[ibr-006-ae]-In Item Information (IBG-31) where Invoiced tax category code (ibt-151) is 'VAT Reverse charge', Type of goods or services (BTAE-09) MUST be selected from the Goods or services subject to RCM Code list.</svrl:text>
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
