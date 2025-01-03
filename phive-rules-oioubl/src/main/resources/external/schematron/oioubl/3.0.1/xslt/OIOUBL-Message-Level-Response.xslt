<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:u="utils" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2" xmlns:ubl-creditnote="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:ubl-invoice="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
<xsl:function as="xs:boolean" name="u:gln">
    <xsl:param name="val" />
    <xsl:variable name="length" select="string-length($val) - 1" />
    <xsl:variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)" />
    <xsl:variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))" />
    <xsl:value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))" />
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
      <svrl:ns-prefix-in-attribute-values prefix="ubl-creditnote" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl-invoice" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="u" uri="utils" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M9" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M10" select="/" />
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
        <xsl:attribute name="id">profile</xsl:attribute>
        <xsl:attribute name="name">profile</xsl:attribute>
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
        <xsl:attribute name="id">message_level_response_network</xsl:attribute>
        <xsl:attribute name="name">message_level_response_network</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M14" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->


<!--PATTERN -->


	<!--RULE -->
<xsl:template match="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0184'] | cbc:EndpointID[@schemeID eq '0184'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0184']" mode="M9" priority="1030">
    <svrl:fired-rule context="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0184'] | cbc:EndpointID[@schemeID eq '0184'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0184']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^\d{8}$')">
          <xsl:attribute name="id">OIOUBL-COMMON-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The DK:CVR (0184) must be stated in the correct format (8
                        digits) - Value found: '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AdditionalDocumentReference/cbc:ID[@schemeID eq 'ARR']" mode="M9" priority="1029">
    <svrl:fired-rule context="cac:AdditionalDocumentReference/cbc:ID[@schemeID eq 'ARR']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(matches(normalize-space(.), '^\d{10}$')) and (../cbc:DocumentTypeCode eq '130')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(matches(normalize-space(.), '^\d{10}$')) and (../cbc:DocumentTypeCode eq '130')">
          <xsl:attribute name="id">OIOUBL-COMMON-002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> When 'cac:AdditionalDocumentReference/cbc:ID schemaID' equals 'ARR' The
                        value in ID must equal 10 digits - Value found: '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' The
                        value in DocumentTypeCode must equal '130' - Value found: '<xsl:text />
            <xsl:value-of select="../cbc:DocumentTypeCode" />
            <xsl:text />' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0096'] | cbc:EndpointID[@schemeID eq '0096'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0096']" mode="M9" priority="1028">
    <svrl:fired-rule context="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0096'] | cbc:EndpointID[@schemeID eq '0096'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0096']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^\d{10}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^\d{10}$')">
          <xsl:attribute name="id">OIOUBL-COMMON-003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The DK:P (0096) value must be stated in the correct format (10
                        digits) - Value found: '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0198'] | cbc:EndpointID[@schemeID eq '0198'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0198'] | cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID eq '0198']" mode="M9" priority="1027">
    <svrl:fired-rule context="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0198'] | cbc:EndpointID[@schemeID eq '0198'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0198'] | cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID eq '0198']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^DK\d{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^DK\d{8}$')">
          <xsl:attribute name="id">OIOUBL-COMMON-004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The DK:SE (0198) value must be stated in the correct format (DK
                        followed by 8 digits) - Value found: '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0237'] | cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID eq '0237'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0237']" mode="M9" priority="1026">
    <svrl:fired-rule context="cac:Party/cac:PartyIdentification/cbc:ID[@schemeID eq '0237'] | cac:Party/cac:PartyTaxScheme/cbc:CompanyID[@schemeID eq '0237'] | cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID eq '0237']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^\d{10}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^\d{10}$')">
          <xsl:attribute name="id">OIOUBL-COMMON-013</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The DK:CPR (0237)value must be stated in the correct format (10
                        digits) - Value found: '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:UUID" mode="M9" priority="1025">
    <svrl:fired-rule context="cbc:UUID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')">
          <xsl:attribute name="id">OIOUBL-COMMON-005</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The element must contain a valid UUID - Value found: '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ext:UBLExtensions" mode="M9" priority="1024">
    <svrl:fired-rule context="ext:UBLExtensions" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ext:UBLExtension/ext:ExtensionAgencyID = 'ERST'                                 and (number(ext:UBLExtension/cbc:ID) >= 1001 and number(ext:UBLExtension/cbc:ID) &lt;= 1999)" />
      <xsl:otherwise>
        <svrl:failed-assert test="ext:UBLExtension/ext:ExtensionAgencyID = 'ERST' and (number(ext:UBLExtension/cbc:ID) >= 1001 and number(ext:UBLExtension/cbc:ID) &lt;= 1999)">
          <xsl:attribute name="id">OIOUBL-COMMON-006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Invalid UBLExtension/ID when UBLExtension/ExtensionAgencyID is
                        equal to 'ERST'. ID must be an assigned value between '1001' and '1999' -
                        Value found: '<xsl:text />
            <xsl:value-of select="ext:UBLExtension/cbc:ID" />
            <xsl:text />'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:SequenceNumeric" mode="M9" priority="1023">
    <svrl:fired-rule context="cbc:SequenceNumeric" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(starts-with(., '-'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(starts-with(., '-'))">
          <xsl:attribute name="id">OIOUBL-COMMON-007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>SequenceNumeric must not be negative - Value found: '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Address | cac:DespatchAddress | cac:JurisdictionRegionAddress | cac:OriginAddress | cac:PostalAddress | cac:RegistrationAddress | cac:ReturnAddress" mode="M9" priority="1022">
    <svrl:fired-rule context="cac:Address | cac:DespatchAddress | cac:JurisdictionRegionAddress | cac:OriginAddress | cac:PostalAddress | cac:RegistrationAddress | cac:ReturnAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cbc:CityName) = 1 and count(./cbc:PostalZone) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cbc:CityName) = 1 and count(./cbc:PostalZone) = 1">
          <xsl:attribute name="id">OIOUBL-COMMON-008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>CityName AND PostalZone MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cbc:Postbox) = 1 or                                 (count(./cbc:StreetName) = 1 and count(./cbc:BuildingNumber) = 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cbc:Postbox) = 1 or (count(./cbc:StreetName) = 1 and count(./cbc:BuildingNumber) = 1)">
          <xsl:attribute name="id">OIOUBL-COMMON-009</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>IF Postbox does not exist, StreetName AND BuildingNumber MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cbc:Floor) = 0 or                                 (count(./cbc:Floor) = 1 and count(./cbc:StreetName) = 1 and count(./cbc:BuildingNumber) = 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cbc:Floor) = 0 or (count(./cbc:Floor) = 1 and count(./cbc:StreetName) = 1 and count(./cbc:BuildingNumber) = 1)">
          <xsl:attribute name="id">OIOUBL-COMMON-010</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>IF Floor is present, StreetName and BuildingNumber MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cbc:Room) = 0 or                                 (count(./cbc:Room) = 1 and count(./cbc:StreetName) = 1 and count(./cbc:BuildingNumber) = 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cbc:Room) = 0 or (count(./cbc:Room) = 1 and count(./cbc:StreetName) = 1 and count(./cbc:BuildingNumber) = 1)">
          <xsl:attribute name="id">OIOUBL-COMMON-011</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>IF Room is present, StreetName and BuildingNumber MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(./cbc:BuildingNumber) = 0 and count(./cbc:StreetName) = 0) or                                 (count(./cbc:BuildingNumber) = 1 and count(./cbc:StreetName) = 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(./cbc:BuildingNumber) = 0 and count(./cbc:StreetName) = 0) or (count(./cbc:BuildingNumber) = 1 and count(./cbc:StreetName) = 1)">
          <xsl:attribute name="id">OIOUBL-COMMON-012</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>IF BuildingNumber is present, StreetName MUST be present. IF StreetName is present, BuildingNumber MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge" mode="M9" priority="1021">
    <svrl:fired-rule context="cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:AllowanceChargeReasonCode = 'ZZZ') or cbc:AllowanceChargeReason" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:AllowanceChargeReasonCode = 'ZZZ') or cbc:AllowanceChargeReason">
          <xsl:attribute name="id">OIOUBL-COMMON-150</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>When AllowanceChargeReasonCode = ZZZ is used, then AllowanceChargeReason must be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:AllowanceChargeReasonCode = 'ZZZ') or                                 ((cbc:AllowanceChargeReason and contains(cbc:AllowanceChargeReason, '#')                                 and not(starts-with(cbc:AllowanceChargeReason, '#'))                                 and not(ends-with(cbc:AllowanceChargeReason, '#'))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:AllowanceChargeReasonCode = 'ZZZ') or ((cbc:AllowanceChargeReason and contains(cbc:AllowanceChargeReason, '#') and not(starts-with(cbc:AllowanceChargeReason, '#')) and not(ends-with(cbc:AllowanceChargeReason, '#'))))">
          <xsl:attribute name="id">OIOUBL-COMMON-014</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>AllowanceChargeReason must include a #, but the # is not allowed as first and last character
                </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty" mode="M9" priority="1020">
    <svrl:fired-rule context="cac:AccountingSupplierParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID = '0237'])                                 or (ancestor::*/cbc:ProfileID = 'urn:fdc:oioubl.dk:bis:billing_private_without_response:3')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Party/cac:PartyLegalEntity/cbc:CompanyID[@schemeID = '0237']) or (ancestor::*/cbc:ProfileID = 'urn:fdc:oioubl.dk:bis:billing_private_without_response:3')">
          <xsl:attribute name="id">OIOUBL-COMMON-102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>SchemaID = '0237' is only allowed when ProfileID='urn:fdc:oioubl.dk:bis:billing_private_without_response:3'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M9" priority="1019">
    <svrl:fired-rule context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Item/cac:ManufacturersItemIdentification) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Item/cac:ManufacturersItemIdentification) &lt;= 1">
          <xsl:attribute name="id">OIOUBL-COMMON-103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>No more than one ManufacturersItemIdentification class may be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Item/cac:Certificate/cac:CertificateTypeCode/cbc:ID) or (some $val in $PackagingMarkedLabelAccreditationCode                         satisfies (cac:Item/cac:Certificate/cac:CertificateTypeCode/cbc:ID = $val))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Item/cac:Certificate/cac:CertificateTypeCode/cbc:ID) or (some $val in $PackagingMarkedLabelAccreditationCode satisfies (cac:Item/cac:Certificate/cac:CertificateTypeCode/cbc:ID = $val))">
          <xsl:attribute name="id">OIOUBL-COMMON-104</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The value of CertificateTypeCode must be one of the PackagingMarkedLabelAccreditationCode from GS1 Global Data Dictionary - Value found: '<xsl:text />
            <xsl:value-of select="cac:Item/cac:Certificate/cac:CertificateTypeCode/cbc:ID" />
            <xsl:text />' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Party" mode="M9" priority="1018">
    <svrl:fired-rule context="cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyLegalEntity" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyLegalEntity">
          <xsl:attribute name="id">OIOUBL-COMMON-100</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The element 'PartyLegalEntity' is mandatory in the 'Party'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyLegalEntity/cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyLegalEntity/cbc:CompanyID">
          <xsl:attribute name="id">OIOUBL-COMMON-101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The element 'CompanyID' is mandatory in the 'PartyLegalEntity'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cac:PartyName/cbc:Name) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cac:PartyName/cbc:Name) = 1">
          <xsl:attribute name="id">OIOUBL-COMMON-106</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Party/cac:PartyName/cbc:Name must be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cac:PartyLegalEntity) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cac:PartyLegalEntity) = 1">
          <xsl:attribute name="id">OIOUBL-COMMON-107</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Party/cac:PartyLegalEntity must be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cac:PartyLegalEntity/cbc:CompanyID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cac:PartyLegalEntity/cbc:CompanyID) = 1">
          <xsl:attribute name="id">OIOUBL-COMMON-108</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Party/cac:PartyLegalEntity/cbc:CompanyID must be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" mode="M9" priority="1017">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cbc:ID) = 1">
          <xsl:attribute name="id">OIOUBL-COMMON-105</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID must be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme | cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme | cac:TaxRepresentativeParty/cac:PartyTaxScheme" mode="M9" priority="1016">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme | cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme | cac:TaxRepresentativeParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID or not(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID != 'O')" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID or not(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID != 'O')">
          <xsl:attribute name="id">OIOUBL-COMMON-109</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:PartyTaxScheme/cbc:CompanyID must be present when cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID differ from 'O'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxScheme/cbc:ID or not(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID != 'O')" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxScheme/cbc:ID or not(/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID != 'O')">
          <xsl:attribute name="id">OIOUBL-COMMON-110</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:PartyTaxScheme/cac:TaxScheme/cbc:ID mmust be present when cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID differ from 'O'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Party/cbc:EndpointID" mode="M9" priority="1015">
    <svrl:fired-rule context="cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">OIOUBL-COMMON-111</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Party/cbc:EndpointID must have a @schemeID attribute.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Party/cac:PartyIdentification/cbc:ID" mode="M9" priority="1014">
    <svrl:fired-rule context="cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">OIOUBL-COMMON-112</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Party/cac:PartyIdentification/cbc:ID must have a @schemeID attribute.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Party/cac:PartyLegalEntity/cbc:CompanyID" mode="M9" priority="1013">
    <svrl:fired-rule context="cac:Party/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">OIOUBL-COMMON-113</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:Party/cac:PartyLegalEntity/cbc:CompanyID must have a @schemeID attribute.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PartyTaxScheme/cbc:CompanyID" mode="M9" priority="1012">
    <svrl:fired-rule context="cac:PartyTaxScheme/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">OIOUBL-COMMON-114</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>cac:PartyTaxScheme/cbc:CompanyID must have a @schemeID attribute.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="some $code in $DK-ISO-6523-ICD                                         satisfies @schemeID = $code" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $code in $DK-ISO-6523-ICD satisfies @schemeID = $code">
          <xsl:attribute name="id">OIOUBL-COMMON-115</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>@schemeID must be in ISO 6523 ICD code list or have the special DK value 'ZZZ'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Signature" mode="M9" priority="1011">
    <svrl:fired-rule context="cac:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cac:DigitalSignatureAttachment) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cac:DigitalSignatureAttachment) = 1">
          <xsl:attribute name="id">OIOUBL-COMMON-116</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The element 'DigitalSignatureAttachment' is mandatory in 'Signature'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cac:OriginalDocumentReference) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cac:OriginalDocumentReference) = 1">
          <xsl:attribute name="id">OIOUBL-COMMON-117</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The element 'OriginalDocumentReference' is mandatory in 'Signature'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cac:SignatoryParty) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cac:SignatoryParty) = 1">
          <xsl:attribute name="id">OIOUBL-COMMON-118</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The element 'SignatoryParty' is mandatory in 'Signature'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cbc:CanonicalizationMethod) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cbc:CanonicalizationMethod) = 1">
          <xsl:attribute name="id">OIOUBL-COMMON-119</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The element 'CanonicalizationMethod' is mandatory in 'Signature'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cbc:SignatureMethod) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cbc:SignatureMethod) = 1">
          <xsl:attribute name="id">OIOUBL-COMMON-120</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The element 'SignatureMethod' is mandatory in 'Signature'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:ActivityPeriod | cac:ApplicablePeriod | cac:ConstitutionPeriod | cac:ContractAcceptancePeriod | cac:ContractFormalizationPeriod | cac:DeliveryPeriod | cac:DocumentAvailabilityPeriod | cac:DurationPeriod | cac:EffectivePeriod | cac:EstimatedDeliveryPeriod | cac:EstimatedDespatchPeriod | cac:EstimatedDurationPeriod | cac:EstimatedTransitPeriod | cac:ExceptionObservationPeriod | cac:ForecastPeriod | cac:FrequencyPeriod | cac:InventoryPeriod | cac:InvitationSubmissionPeriod | cac:InvoicePeriod | cac:LineValidityPeriod | cac:MainPeriod | cac:NominationPeriod | cac:NotificationPeriod | cac:OptionValidityPeriod | cac:ParticipationRequestReceptionPeriod | cac:PaymentReversalPeriod | cac:PenaltyPeriod | cac:Period | cac:PlannedPeriod | cac:PresentationPeriod | cac:PromisedDeliveryPeriod | cac:ReminderPeriod | cac:RequestedDeliveryPeriod | cac:RequestedDespatchPeriod | cac:RequestedStatusPeriod | cac:RequestedValidityPeriod | cac:ServiceEndTimePeriod | cac:ServiceStartTimePeriod | cac:SettlementPeriod | cac:StatementPeriod | cac:StatusPeriod | cac:TenderSubmissionDeadlinePeriod | cac:TenderValidityPeriod | cac:TransitPeriod | cac:TransportServiceProviderResponseDeadlinePeriod | cac:TransportServiceProviderResponseRequiredPeriod | cac:TransportUserResponseRequiredPeriod | cac:UsabilityPeriod | cac:ValidityPeriod | cac:WarrantyValidityPeriod" mode="M9" priority="1010">
    <svrl:fired-rule context="cac:ActivityPeriod | cac:ApplicablePeriod | cac:ConstitutionPeriod | cac:ContractAcceptancePeriod | cac:ContractFormalizationPeriod | cac:DeliveryPeriod | cac:DocumentAvailabilityPeriod | cac:DurationPeriod | cac:EffectivePeriod | cac:EstimatedDeliveryPeriod | cac:EstimatedDespatchPeriod | cac:EstimatedDurationPeriod | cac:EstimatedTransitPeriod | cac:ExceptionObservationPeriod | cac:ForecastPeriod | cac:FrequencyPeriod | cac:InventoryPeriod | cac:InvitationSubmissionPeriod | cac:InvoicePeriod | cac:LineValidityPeriod | cac:MainPeriod | cac:NominationPeriod | cac:NotificationPeriod | cac:OptionValidityPeriod | cac:ParticipationRequestReceptionPeriod | cac:PaymentReversalPeriod | cac:PenaltyPeriod | cac:Period | cac:PlannedPeriod | cac:PresentationPeriod | cac:PromisedDeliveryPeriod | cac:ReminderPeriod | cac:RequestedDeliveryPeriod | cac:RequestedDespatchPeriod | cac:RequestedStatusPeriod | cac:RequestedValidityPeriod | cac:ServiceEndTimePeriod | cac:ServiceStartTimePeriod | cac:SettlementPeriod | cac:StatementPeriod | cac:StatusPeriod | cac:TenderSubmissionDeadlinePeriod | cac:TenderValidityPeriod | cac:TransitPeriod | cac:TransportServiceProviderResponseDeadlinePeriod | cac:TransportServiceProviderResponseRequiredPeriod | cac:TransportUserResponseRequiredPeriod | cac:UsabilityPeriod | cac:ValidityPeriod | cac:WarrantyValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(./cbc:StartDate, '^\d{4}-\d{2}-\d{2}$'))                                 or not(matches(./cbc:StartTime, '^\d{2}:\d{2}:\d{2}$'))                                 or not(matches(./cbc:EndDate, '^\d{4}-\d{2}-\d{2}$'))                                 or not(matches(./cbc:EndTime, '^\d{2}:\d{2}:\d{2}$'))                                 or not(xs:dateTime(concat(./cbc:StartDate, 'T', ./cbc:StartTime)) gt xs:dateTime(concat(./cbc:EndDate, 'T', ./cbc:EndTime)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(./cbc:StartDate, '^\d{4}-\d{2}-\d{2}$')) or not(matches(./cbc:StartTime, '^\d{2}:\d{2}:\d{2}$')) or not(matches(./cbc:EndDate, '^\d{4}-\d{2}-\d{2}$')) or not(matches(./cbc:EndTime, '^\d{2}:\d{2}:\d{2}$')) or not(xs:dateTime(concat(./cbc:StartDate, 'T', ./cbc:StartTime)) gt xs:dateTime(concat(./cbc:EndDate, 'T', ./cbc:EndTime)))">
          <xsl:attribute name="id">OIOUBL-COMMON-121</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>StartDate + StartTime must be before or the same as EndDate + EndTime</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cbc:StartTime) = 0 or (count(./cbc:StartDate) = 1 and count(./cbc:StartTime) = 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cbc:StartTime) = 0 or (count(./cbc:StartDate) = 1 and count(./cbc:StartTime) = 1)">
          <xsl:attribute name="id">OIOUBL-COMMON-122</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>If StartTime exists, StartDate must be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(./cbc:EndTime) = 0 or (count(./cbc:EndDate) = 1 and count(./cbc:EndTime) = 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(./cbc:EndTime) = 0 or (count(./cbc:EndDate) = 1 and count(./cbc:EndTime) = 1)">
          <xsl:attribute name="id">OIOUBL-COMMON-123</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>If EndTime exists, EndDate must be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:StartTime | cbc:EndTime" mode="M9" priority="1009">
    <svrl:fired-rule context="cbc:StartTime | cbc:EndTime" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(., '^\d{2}:\d{2}:\d{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(., '^\d{2}:\d{2}:\d{2}$')">
          <xsl:attribute name="id">OIOUBL-COMMON-124</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>IF StartTime exists or EndTime exists, format must follow time format (without date format)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Contact" mode="M9" priority="1008">
    <svrl:fired-rule context="cac:Contact" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(matches(./cbc:ID, '^\d{6}-?\d{4}$'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(matches(./cbc:ID, '^\d{6}-?\d{4}$'))">
          <xsl:attribute name="id">OIOUBL-COMMON-125</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ID must not be a CPR number (must not have format XXXXXXXXXX or XXXXXX-XXXX)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(./cbc:Telephone, '^(?:\+|00).*$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(./cbc:Telephone, '^(?:\+|00).*$')">
          <xsl:attribute name="id">OIOUBL-COMMON-126</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Telephone must include country code (must start with '+' or '00')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(./cbc:ElectronicMail, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(./cbc:ElectronicMail, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+$')">
          <xsl:attribute name="id">OIOUBL-COMMON-127</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ElectronicMail must have valid format (like 'user123@example.com')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Attachment" mode="M9" priority="1007">
    <svrl:fired-rule context="cac:Attachment" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(count(./cbc:EmbeddedDocumentBinaryObject) = 1 and count(./cac:ExternalReference) = 1)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(count(./cbc:EmbeddedDocumentBinaryObject) = 1 and count(./cac:ExternalReference) = 1)">
          <xsl:attribute name="id">OIOUBL-COMMON-128</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Must not have both embedded document and external reference.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Attachment/cbc:EmbeddedDocumentBinaryObject" mode="M9" priority="1006">
    <svrl:fired-rule context="cac:Attachment/cbc:EmbeddedDocumentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@filename" />
      <xsl:otherwise>
        <svrl:failed-assert test="@filename">
          <xsl:attribute name="id">OIOUBL-COMMON-129</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>EmbeddedDocumentBinaryObject must have filename attribute</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="some $code in $OpenPEPPOL-IANA-MimeCode                                         satisfies @mimeCode = $code" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $code in $OpenPEPPOL-IANA-MimeCode satisfies @mimeCode = $code">
          <xsl:attribute name="id">OIOUBL-COMMON-130</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute mimeCode must be a value from the code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Attachment/cac:ExternalReference" mode="M9" priority="1005">
    <svrl:fired-rule context="cac:Attachment/cac:ExternalReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(./cbc:URI, '^.+$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(./cbc:URI, '^.+$')">
          <xsl:attribute name="id">OIOUBL-COMMON-131</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>When using ExternalReference, URI is mandatory</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(./cbc:DocumentHash) = 1 and count(./cbc:HashAlgorithmMethod) = 1)                                 or (count(./cbc:DocumentHash) = 0 and count(./cbc:HashAlgorithmMethod) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(./cbc:DocumentHash) = 1 and count(./cbc:HashAlgorithmMethod) = 1) or (count(./cbc:DocumentHash) = 0 and count(./cbc:HashAlgorithmMethod) = 0)">
          <xsl:attribute name="id">OIOUBL-COMMON-132</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>If DocumentHash or HashAlgorithmMethod is present, the other must also be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(./cbc:ExpiryTime) = 1 and count(./cbc:ExpiryDate) = 1)                                 or count(./cbc:ExpiryTime) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(./cbc:ExpiryTime) = 1 and count(./cbc:ExpiryDate) = 1) or count(./cbc:ExpiryTime) = 0">
          <xsl:attribute name="id">OIOUBL-COMMON-133</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>If ExpiryTime is present, ExpiryDate MUST be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:DocumentReference" mode="M9" priority="1004">
    <svrl:fired-rule context="cac:DocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(count(./cbc:IssueTime) = 1 and count(./cbc:IssueDate) = 1)                                 or count(./cbc:IssueTime) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(count(./cbc:IssueTime) = 1 and count(./cbc:IssueDate) = 1) or count(./cbc:IssueTime) = 0">
          <xsl:attribute name="id">OIOUBL-COMMON-134</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>If IssueTime is present, IssueDate must be present</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxExchangeRate | cac:PricingExchangeRate | cac:PaymentExchangeRate | cac:PaymentAlternativeExchangeRate" mode="M9" priority="1003">
    <svrl:fired-rule context="cac:TaxExchangeRate | cac:PricingExchangeRate | cac:PaymentExchangeRate | cac:PaymentAlternativeExchangeRate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CalculationRate > 0 and matches(cbc:CalculationRate, '^[0-9]+(\.[0-9]{4})?$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CalculationRate > 0 and matches(cbc:CalculationRate, '^[0-9]+(\.[0-9]{4})?$')">
          <xsl:attribute name="id">OIOUBL-COMMON-140</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>CalculationRate must be greater than zero and have exactly 4 decimal places - Value found:  <xsl:text />
            <xsl:value-of select="cbc:CalculationRate" />
            <xsl:text /> </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:MathematicOperatorCode = 'multiply' or cbc:MathematicOperatorCode = 'divide'" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:MathematicOperatorCode = 'multiply' or cbc:MathematicOperatorCode = 'divide'">
          <xsl:attribute name="id">OIOUBL-COMMON-141</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>MathematicOperatorCode must be either 'multiply' or 'divide'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:variable name="PackagingMarkedLabelAccreditationCode" select="tokenize('100_PERCENT_CANADIAN_MILK,100_PERCENT_VEGANSKT,3PMSF,ACMI,ADCCPA,AFIA_PET_FOOD_FACILITY,AGENCE_BIO,AGRI_CONFIANCE,AGRI_NATURA,AGRICULTURE_BIOLOGIQUE,AHAM,AISE,AISE_2005,AISE_2010,AISE_2020_BRAND,AISE_2020_COMPANY,AKC_PEACH_KOSHER,ALENTEJO_SUSTAINABILITY_PROGRAMME,ALIMENTATION_DU_TOUT_PETIT,ALIMENTS_BIO_PREPARES_AU_QUEBEC,ALIMENTS_DU_QUEBEC,ALIMENTS_DU_QUEBEC_BIO,ALIMENTS_PREPARES_AU_QUEBEC,ALPINAVERA,ALUMINIUM_GESAMTVERBAND_DER_ALUMINIUMINDUSTRIE,AMA_GENUSSREGION,AMA_ORGANIC_SEAL,AMA_ORGANIC_SEAL_BLACK,AMA_SEAL_OF_APPROVAL,AMERICAN_DENTAL_ASSOCIATION,AMERICAN_HEART_ASSOCIATION_CERTIFIED,ANIMAL_WELFARE_APPROVED_GRASSFED,AOP,APPELLATION_ORIGINE_CONTROLEE,APPROVED_BY_ASTHMA_AND_ALLERGY_ASSOC,AQUA_GAP,AQUACULTURE_STEWARDSHIP_COUNCIL,ARGE_GENTECHNIK_FREI,ARGENCERT,ARLA_FARMER_OWNED,ASCO,ASMI,ASTHMA_AND_ALLERGY_FOUNDATION_OF_AMERICA,ATG,AUS_KAUP_ESTONIA,AUSTRALIAN_CERTIFIED_ORGANIC,AUSTRIA_BIO_GARANTIE,AUSTRIAN_ECO_LABEL,BCARA_ORGANIC,BDIH_LOGO,BEBAT,BEDRE_DYREVELFAERD_1HEART,BEDRE_DYREVELFAERD_2HEART,BEDRE_DYREVELFAERD_3HEART,BEE_FRIENDLY,BELGAQUA,BENOR,BERCHTESGADENER_LAND,BEST_AQUACULTURE_PRACTICES,BEST_AQUACULTURE_PRACTICES_2_STARS,BEST_AQUACULTURE_PRACTICES_3_STARS,BEST_AQUACULTURE_PRACTICES_4_STARS,BETER_LEVEN_1_STER,BETER_LEVEN_2_STER,BETER_LEVEN_3_STER,BETTER_BUSINESS_BUREAU_ACCREDITED,BETTER_COTTON_INITIATIVE,BEVEG,BEWUSST_TIROL,BEWUSTE_KEUZE,BIKO_TIROL,BIO_AUSTRIA_LABEL,BIO_BAYERN_WITH_CERTIFICATE_PROVENANCE,BIO_BAYERN_WITHOUT_CERTIFICATE_PROVENANCE,BIO_BUD_SEAL,BIO_BUD_SEAL_TRANSITION,BIO_CZECH_LABEL,BIO_FISCH,BIO_GOURMET_BUD,BIO_LABEL_BADEN_WURTTENBERG,BIO_LABEL_GERMAN,BIO_LABEL_HESSEN,BIO_PARTENAIRE,BIO_RING_ALLGAEU,BIO_SOLIDAIRE,BIO_SUISSE_BUD_SEAL,BIO_SUISSE_BUD_SEAL_TRANSITION,BIOCHECKED_NON_GLYPHOSATE_CERTIFIED,BIOCHECKED_NON_GMO_VERIFIED,BIODEGRADABLE,BIODEGRADABLE_PRODUCTS_INSTITUTE,BIODYNAMIC_CERTIFICATION,BIODYNAMISCH,BIOGARANTIE,BIOKREIS,BIOLAND,BIOLAND_ENNSTAL,BIOPARK,BIOS_KONTROLLE,BIRD_FRIENDLY_COFFEE_SMITHSONIAN_CERTIFICATION,BK_CHECK_VAAD_HAKASHRUS_OF_BUFFALO,BLEU_BLANC_COEUR,BLUE_ANGEL,BLUE_RIBBON_KOSHER,BLUESIGN,BODEGAS_ARGENTINA_SUSTAINABILITY_PROTOCOL,BONSUCRO,BORD_BIA_APPROVED,BORD_BIA_APPROVED_MEAT,BRA_MILJOVAL_LABEL_SWEDISH,BRC_GLOBAL_STANDARDS,BREATHEWAY,BRITISH_DENTAL_HEALTH,BRITISH_RETAIL_CONSORTIUM_CERTIFICATION,BSCI,BULLFROG,CA_BEEF,CA_BOTH_DOM_IMPORT,CA_BULK,CA_CANNED,CA_DISTILLED,CA_IMPORT,CA_INGREDIENT,CA_MADE,CA_MUSTARD_SEEDS,CA_OATS,CA_PREPARED,CA_PROCESSED,CA_PRODUCT,CA_PROUD,CA_REFINED,CA_ROASTED_BLENDED,CAC_ABSENCE_EGG_MILK,CAC_ABSENCE_EGG_MILK_PEANUTS,CAC_ABSENCE_OF_ALMOND,CAC_ABSENCE_OF_EGG,CAC_ABSENCE_OF_MILK,CAC_ABSENCE_OF_PEANUT,CAC_ABSENCE_PEANUT_ALMOND,CAFE_PRACTICES,CAN_BNQ_CERTIFIED,CANADA_GAP,CANADIAN_AGRICULTURAL_PRODUCTS,CANADIAN_ASSOCIATION_FIRE_CHIEFS_APPROVED,CANADIAN_CERTIFIED_COMPOSTABLE,CANADIAN_DERMATOLOGY_ASSOCIATION_SKIN_HEALTH,CANADIAN_DERMATOLOGY_ASSOCIATION_SUN_PROTECTION,CARBON_FOOTPRINT_STANDARD,CARBON_NEUTRAL,CARBON_NEUTRAL_NCOS_CERTIFIED,CARBON_NEUTRAL_PACKAGING,CARIBBEAN_KOSHER,CCA_GLUTEN_FREE,CCC,CCF_RABBIT,CCOF,CCSW,CEBEC,CEL,CELIAC_SPRUE_ASSOCIATION,CENTRAL_RABBINICAL_CONGRESS_KOSHER,CERTIFIE_TERROIR_CHARLEVOIX,CERTIFIED_ANGUS_BEEF,CERTIFIED_B_CORPORATION,CERTIFIED_CARBON_FREE,CERTIFIED_HUMANE_ORGANISATION,CERTIFIED_NATURALLY_GROWN,CERTIFIED_OE_100,CERTIFIED_ORGANIC_BAYSTATE_ORGANIC_CERTIFIERS,CERTIFIED_ORGANIC_BY_ORGANIC_CERTIFIERS,CERTIFIED_PALEO,CERTIFIED_PALEO_FRIENDLY,CERTIFIED_PLANT_BASED,CERTIFIED_SUSTAINABLE_WINE_CHILE,CERTIFIED_WBENC,CERTIFIED_WILDLIFE_FRIENDLY,CFG_PROCESSED_EGG,CFIA,CFIA_DAIRY,CFIA_FISH,CFIA_GRADE_A,CFIA_GRADE_C,CFIA_ORGANIC,CFIA_UTILITY_POULTRY_EGG,CHASSEURS_DE_FRANCE,CHEESE_WORLD_CHAMPION_CHEESE_CONTEST,CHES_K,CHICAGO_RABBINICAL_COUNCIL,CINCINNATI_KOSHER,CLARO_FAIR_TRADE,CLIMATE_NEUTRAL,CLIMATE_NEUTRAL_PARTNER,CNG,CO2_REDUCERET_EMBALLAGE,CO2LOGIC_CO2_NEUTRAL_CERTIFIED,COCOA_HORIZONS,COCOA_LIFE,COMPOSTABLE_DIN_CERTCO,COMTE_GREEN_BELL,CONFORMITE_EUROPEENNE,CONSUMER_CHOICE_AWARD,COR_DETROIT,COR_KOSHER,CORRUGATED_RECYCLES,COSMEBIO,COSMEBIO_COSMOS_NATURAL,COSMEBIO_COSMOS_ORGANIC,COTTON_MADE_IN_AFRICA,CPE_SCHARREL_EIEREN,CPE_VRIJE_UITLOOP_EIEREN,CRADLE_TO_CRADLE,CROSSED_GRAIN_SYMBOL,CROWN_CHK,CRUELTY_FREE_PETA,CSA_INTERNATIONAL,CSA_NCA_GLUTEN_FREE,CSI,CULINARIUM,CULTIVUP_EXIGENCE,CULTIVUP_RESPONSABLE,CZECH_FOOD,DALLAS_KOSHER,DANSK_IP_KVALITET,DANSK_MAELK,DEBIO,DELINAT,DEMETER_LABEL,DESIGN_FOR_THE_ENVIRONMENT,DESIGN_FROM_FINLAND,DIAMOND_K,DIAMOND_KA_KASHRUT_AUTHORITY_OF_AUSTRALIA_AND_NZ,DIRECT_TRADE,DK_ECO,DLG_AWARD,DLG_CERTIFIED_ALLERGEN_MANAGEMENT ,DNV_BUSINESS_ASSURANCE,DOLPHIN_SAFE,DONAU_SOYA_STANDARD,DRP,DUURZAAM_VARKENSVLEES,DVF_VEGAN,DVF_VEGETARIAN,DYRENES_BESKYTTELSE,DZG_GLUTEN_FREE,EARTHKOSHER_KOSHER,EARTHSURE,ECARF_SEAL,ECO_KREIS,ECO_LABEL_CZECH,ECO_LABEL_LADYBUG,ECO_LOGO,ECOCERT_CERTIFICATE,ECOCERT_COSMOS_NATURAL,ECOCERT_COSMOS_ORGANIC,ECOCERT_ORGANIC,ECOGARANTIE,ECOLAND,ECOLOGO_CERTIFIED,ECOLOGO_CERTIFIED_2,ECOVIN,ECZEMA_SOCIETY_OF_CANADA,EESTI_OKOMARK,EESTI_PARIM_TOIDUAINE,EKO,ENEC,ENERGY_LABEL_A,ENERGY_LABEL_A+,ENERGY_LABEL_A++,ENERGY_LABEL_A+++,ENERGY_LABEL_B,ENERGY_LABEL_C,ENERGY_LABEL_D,ENERGY_LABEL_E,ENERGY_LABEL_F,ENERGY_LABEL_G,ENERGY_STAR,ENTREPRISE_DU_PATRIMOINE_VIVANT,ENTWINE_AUSTRALIA,EPA_DFE,EPEAT_BRONZE,EPEAT_GOLD,EPEAT_SILVER,EQUAL_EXCHANGE_FAIRLY_TRADED,EQUALITAS_SUSTAINABLE_WINE,ERDE_SAAT,ERKEND_STREEK_PRODUCT,ETP,EU_ECO_LABEL,EU_ENERGY_LABEL,EU_ORGANIC_FARMING,EUROPE_SOYA_STANDARD,EUROPEAN_V_LABEL_VEGAN,EUROPEAN_V_LABEL_VEGETARIAN,EUROPEAN_VEGETARIAN_UNION,EWG_VERIFIED,FAIR_FLOWERS_FAIR_PLANTS,FAIR_FOOD_PROGRAM_LABEL,FAIR_FOR_LIFE,FAIR_N_GREEN,FAIR_TRADE_MARK,FAIR_TRADE_USA,FAIR_TRADE_USA,FAIR_TRADE_USA_INGREDIENTS,FAIR_TSA,FAIRTRADE_CASHEW_NUTS,FAIRTRADE_COCOA,FAIRTRADE_COCONUT,FAIRTRADE_COTTON,FAIRTRADE_DRIED_APRICOTS,FAIRTRADE_GREEN_TEA,FAIRTRADE_HONEY,FAIRTRADE_LIME_JUICE,FAIRTRADE_MANGO_JUICE,FAIRTRADE_OLIVE_OIL,FAIRTRADE_PEPPER,FAIRTRADE_QUINOA,FAIRTRADE_RICE,FAIRTRADE_ROSES,FAIRTRADE_SUGAR,FAIRTRADE_TEA,FAIRTRADE_VANILLA,FALKEN,FCC,FEDERALLY_REGISTERED_INSPECTED_CANADA,FIDELIO,FINNISH_HEART_SYMBOL,FISH_WISE_CERTIFCATION,FLAMME_VERTE,FLANDRIA,FLEURS_DE_FRANCE,FODMAP,FODMAP_FRIENDLY,FOOD_ALLIANCE_CERTIFIED,FOOD_JUSTICE_CERTIFIED,FOOD_SAFETY_SYSTEM_CERTIFICATION_22000,FOODLAND_ONTARIO,FOR_LIFE,FOREST_PRODUCTS_Z809,FOREST_STEWARDSHIP_COUNCIL_100_PERCENT,FOREST_STEWARDSHIP_COUNCIL_LABEL,FOREST_STEWARDSHIP_COUNCIL_MIX,FOREST_STEWARDSHIP_COUNCIL_RECYCLED,FOUNDATION_ART,FRAN_SVERIGE,FRANCE_LIMOUSIN_MEAT,FREILAND,FRESHCARE,FRIEND_OF_THE_SEA,FRUITS_ET_LEGUMES_DE_FRANCE,GAEA,GANEDEN_BC30_PROBIOTIC,GAP_1,GAP_2,GAP_3,GAP_4,GAP_5,GAP_5_PLUS,GASKEUR,GASTEC,GCP,GEBANA,GENUSS_REGION_AUSTRIA,GENUSS_REGION_AUSTRIA,GEPRUEFTE_SICHERHEIT,GEZONDERE_KEUZE,GFCO,GFCO,GFCP,GIG_GLUTEN_FREE_FOODSERVICE,GLOBAL_CARE,GLOBAL_GAP,GLOBAL_ORGANIC_LATEX_STANDARD,GLOBAL_ORGANIC_TEXTILE_STANDARD,GLOBAL_RECYCLED_STANDARD,GLYCAMIC_INDEX_FOUNDATION,GLYCAMIC_RESEARCH_INSTITUTE,GMO_GUARD_FROM_NATURAL_FOOD_CERTIFIERS,GMO_MARKED,GMP_CERTIFIED,GMP_ISO_22716,GOA_ORGANIC,GODKAND_FOR_EKOLOGISK_ODLING_KRAV,GOOD_HOUSEKEEPING,GOODS_FROM_FINLAND_BLUE_SWAN,GOODWEAVE,GRASKEURMERK,GRASP,GREEN_AMERICA_CERTIFIED_BUSINESS,GREEN_DOT,GREEN_E_ENERGY_CERT,GREEN_E_ORG,GREEN_RESTAURANT_ASSOCIATION_ENDORSED,GREEN_SEAL,GREEN_SEAL_CERTIFIED,GREEN_SHIELD_CERTIFIED,GREEN_STAR_CERTIFIED,GREENCHOICE,GROEN_LABEL_KAS,GRUYERE_FRANCE,GUARANTEED_IRISH,HALAL_AUSTRALIA,HALAL_CERTIFICATION_SERVICES,HALAL_CERTIFICATION_SERVICES_CH,HALAL_CORRECT,HALAL_FOOD_COUNCIL_OF_SOUTH_EAST_ASIA_THAILAND,HALAL_HIC,HALAL_HPDS,HALAL_INDIA,HALAL_ISLAMIC_FOOD_CANADA,HALAL_ISLAMIC_SOCIETY_OF_NORTH_AMERICA,HALAL_PLUS,HAUTE_VALEUR_ENVIRONNEMENTALE,HAZARD_ANALYSIS_CRITICAL_CONTROL_POINT,HEALTH_CHECK,HEALTH_FOOD_BLUE_HAT_SIGN,HEUMILCH,HFAC_HUMANE,HMCA_HALAL_MONTREAL_CERTIFICATION_AUTHORITY,HOCHSTAMM_SUISSE,HOW_2_RECYCLE,HUMANE_HEARTLAND,HYPERTENSION_CANADA_MEDICAL_DEVICE,ICADA,ICEA,ICELAND_RESPONSIBLE_FISHERIES,ICS_ORGANIC,IFANCA_HALAL,IFOAM,IFS_HPC,IGP,IHTK_SEAL,IKB_EIEREN,IKB_KIP,IKB_VARKEN,INDEKLIMA_MAERKET,INSTITUT_FRESENIUS,INT_PROTECTION,INTEGRITY_AND_SUSTAINABILITY_CERTIFIED,INTERNATIONAL_ALOE_SCIENCE_COUNCIL_CERTIFICATE,INTERNATIONAL_KOSHER_COUNCIL,INTERNATIONAL_TASTE_QUALITY,INTERTEK_CERTIFICATE,INTERTEK_ETL,IP_SUISSE,ISCC,ISCC_SUPPORTING_THE_BIOECONOMY,ISEAL_ALLIANCE,ISO_QUALITY,IVN_NATURAL_LEATHER,IVN_NATURAL_TEXTILES_BEST,IVO_OMEGA3,JAS_ORGANIC,JAY_KOSHER_PAREVE,JODSALZ_BZGA,KABELKEUR,KAGFREILAND,KEHILLA_KOSHER_CALIFORNIA_K,KEHILLA_KOSHER_HEART_K,KEMA_KEUR,KIWA,KLASA,KOF_K_KOSHER,KOMO,KOSHER_AUSTRALIA,KOSHER_BDMC,KOSHER_CERTIFICATION_SERVICE,KOSHER_CHECK,KOSHER_CHICAGO_RABBINICAL_COUNCIL_DAIRY,KOSHER_CHICAGO_RABBINICAL_COUNCIL_PAREVE,KOSHER_COR_DAIRY,KOSHER_COR_DAIRY_EQUIPMENT,KOSHER_COR_FISH,KOSHER_EIDAH_HACHAREIDIS,KOSHER_GRAND_RABBINATE_OF_QUEBEC_PARVE,KOSHER_GREECE,KOSHER_INSPECTION_SERVICE_INDIA,KOSHER_KW_YOUNG_ISRAEL_OF_WEST_HEMPSTEAD,KOSHER_MADRID_SPAIN,KOSHER_OK_DAIRY,KOSHER_ORGANICS,KOSHER_ORTHODOX_JEWISH_CONGREGATION_PARVE,KOSHER_OTTAWA_VAAD_HAKASHRUT_CANADA,KOSHER_PARVE_BKA,KOSHER_PARVE_NATURAL_FOOD_CERTIFIER,KOSHER_PERU,KOSHER_RAV_LANDAU,KOSHER_STAR_K_PARVE,KOSHER_STAR_K_PARVE_PASSOVER,KOSHER_STAR_S_P_KITNIYOT,KOSHERMEX,KOTT_FRAN_SVERIGE,KRAV_MARK,KSA_KOSHER,KSA_KOSHER_DAIRY,KVBG_APPROVED,LAATUVASTUU,LABEL_OF_THE_ALLERGY_AND_ASTHMA_FEDERATION,LABEL_ROUGE,LACON,LAENDLE_QUALITAET,LAIT_COLLECTE_ET_CONDITIONNE_EN_FRANCE,LAIT_COLLECTE_ET_TRANSFORME_EN_FRANCE,LAPIN_DE_FRANCE,LE_PORC_FRANCAIS,LEAPING_BUNNY,LEGUMES_DE_FRANCE,LETIS_ORGANIC,LGA,LOCALIZE,LODI_RULES_CODE,LONDON_BETH_DIN_KOSHER,LOODUSSOBRALIK_TOODE_ESTONIA,LOVE_IRISH_FOOD,LVA,MADE_GREEN_IN_ITALY,MADE_IN_FINLAND_FLAG_WITH_KEY,MADE_OF_PLASTIC_BEVERAGE_CUPS,MADE_WITH_CANADIAN_BEEF,MAITRE_ARTISAN,MARINE_STEWARDSHIP_COUNCIL_LABEL,MAX_HAVELAAR,MCIA_ORGANIC,MEHR_WEG,MIDWEST_KOSHER,MILIEUKEUR,MINNESOTA_KOSHER_COUNCIL,MJOLK_FRAN_SVERIGE,MOMS_CHOICE_AWARD,MONTREAL_VAAD_HAIR_MK_PAREVE,MORTADELLA_BOLOGNA,MPS_A,MUNDUSVINI_GOLD,MUNDUSVINI_SILVER,MUSLIM_JUDICIAL_COUNCIL_HALAAL_TRUST,MY_CLIMATE,NAOOA_CERTIFIED_QUALITY,NASAA_CERTIFIED_ORGANIC,NATRUE_LABEL,NATURA_BEEF,NATURA_VEAL,NATURE_CARE_PRODUCT,NATURE_ET_PROGRES,NATUREPLUS,NATURLAND,NATURLAND_FAIR_TRADE,NATURLAND_WILDFISH,NC_NATURAL_COSMETICS_STANDARD,NC_NATURAL_COSMETICS_STANDARD_ORGANIC_QUALITY,NC_VEGAN_NATURAL_COSMETICS,NC_VEGAN_NATURAL_COSMETICS_STANDARD_ORGANIC_QUALITY,NCA_GLUTEN_FREE,NDOA,NEA,NEULAND,NEW_ZEALAND_SUSTAINABLE_WINEGROWING,NF_MARQUE,NFCA_GLUTEN_FREE,NIX18,NMX,NOM,NON_GMO_BY_EARTHKOSHER,NON_GMO_PROJECT,NPA,NSF,NSF_CERTIFIED_FOR_SPORT,NSF_GLUTEN_FREE,NSF_NON_GMO_TRUE_NORTH,NSF_SUSTAINABILITY_CERTIFIED,NSM,NYCKELHALET,OCEAN_WISE,OCIA,OCQV_ORGANIC,OECD_BIO_INGREDIENTS,OEKO_CONTROL,OEKO_KREISLAUF,OEKO_QUALITY_GUARANTEE_BAVARIA,OEKO_TEX_LABEL,OEKO_TEX_MADE_IN_GREEN,OEUFS_DE_FRANCE,OFF_ORGANIC,OFFICIAL_ECO_LABEL_SUN,OFG_ORGANIC,OHNE_GEN_TECHNIK,OK_COMPOST_HOME,OK_COMPOST_INDUSTRIAL ,OK_COMPOST_VINCOTTE,OK_KOSHER,OKOTEST,ON_THE_WAY_TO_PLANETPROOF,ONE_PERCENT_FOR_THE_PLANET,ONTARIO_APPROVED,ONTARIO_PORK,ORB,ORBI,OREGON_KOSHER,OREGON_LIVE,OREGON_TILTH,ORGANIC_100_CONTENT_STANDARD,ORGANIC_COTTON,ORGANIC_TRADE_ASSOCIATION,ORIGIN_OF_EGGS,ORIGINE_FRANCE_GARANTIE,ORTHODOX_UNION,OTCO_ORGANIC,OU_KOSHER,OU_KOSHER_DAIRY,OU_KOSHER_FISH,OU_KOSHER_MEAT,OU_KOSHER_PASSOVER,OZONE_FRIENDLY_GENERAL_CLAIM,PACS_ORGANIC,PALEO_APPROVED,PALEO_BY_EARTHKOSHER,PARENT_TESTED_PARENT_APPROVED,PAVILLON_FRANCE,PCO,PEFC,PEFC_CERTIFIED,PEFC_RECYCLED,PET_TO_PET,PGI_CNIPA,PGI_GAQSIQ,PGI_MARA,PGI_TO_SAIC,PLASTIC_FREE_TRUST_MARK,PLASTIC_IN_FILTER_TOBACCO,PLASTIC_IN_PRODUCT_BEVERAGE_CUPS,PLASTIC_IN_PRODUCT_TAMPONS,PLASTIC_IN_PRODUCT_WIPES_SANITARY_PADS,PLASTIC_NEUTRAL,POMMES_DE_TERRES_DE_FRANCE,PREGNANCY_WARNING,PRO_SPECIE_RARA,PRO_TERRA_NON-GMO_CERTIFICATION,PROCERT_ORGANIC,PRODERM,PRODUCT_OF_THE_YEAR_CONSUMER_SURVEY,PRODUIT_EN_BRETAGNE,PROTECTED_DESIGNATION_OF_ORIGIN,PROTECTED_GEOGRAPHICAL_INDICATION,PROTECTED_HARVEST_CERTIFIED,PROVEN_QUALITY_BAVARIA,PUHTAASTI_KOTIMAINEN,QAI,QCS_ORGANIC,QS,QS_PRODUCTION_PERMIT,QUALENVI,QUALITAET_TIROL,QUALITY_CONFORMANCE_MARKING_CN,QUALITY_MARK_IRELAND,QUALITY_RHOEN,RABBINICAL_COUNCIL_OF_BRITISH_COLUMBIA,RABBINICAL_COUNCIL_OF_CALIFORNIA_(RCC),RABBINICAL_COUNCIL_OF_NEW_ENGLAND,RAINFOREST_ALLIANCE,RAINFOREST_ALLIANCE_PEOPLE_NATURE,RAL_QUALITY_CANDLES,REAL_CALIFORNIA_CHEESE,REAL_CALIFORNIA_MILK,REAL_FOOD_SEAL,RECUPEL,RECYCLABLE_GENERAL_CLAIM,REGIONAL_FOOD_CZECH,REGIONALFENSTER,REGIONALTHEKE_FRANKEN,RETURNABLE_PET_BOTTLE_NL,RHP,ROQUEFORT_RED_EWE,ROUNDTABLE_ON_RESPONSIBLE_SOY,RSB,RUP_GUADELOUPE,RUP_GUYANE,RUP_MARTINIQUE,RUP_MAYOTTE,RUP_REUNION,RUP_SAINT_MARTIN,SA8000,SAFE_FEED_SAFE_FOOD,SAFE_QUALITY_FOOD,SAFER_CHOICE,SALMON_SAFE_CERTIFICATION,SALZBURGER_LAND_HERKUNFT,SCHARRELVLEES,SCHLESWIG_HOLSTEIN_QUALITY,SCROLL_K,SCS_RECYCLED_CONTENT_CERTIFICATION,SCS_SUSTAINABLY_GROWN,SEACHOICE,SFC_MEMBER_SEAL,SFC_MEMBER_SEAL_GOLD,SFC_MEMBER_SEAL_PLATINUM,SFC_MEMBER_SEAL_SILVER,SGS_ORGANIC,SHOPPER_ARMY,SIP,SKG_CERTIFICATE,SKG_CERTIFICATE_1_STAR,SKG_CERTIFICATE_2_STAR,SKG_CERTIFICATE_3_STAR,SLG_CHILD_SAFETY,SLG_TYPE_TESTED,SLK_BIO,SOCIETY_PLASTICS_INDUSTRY,SOIL_ASSOCIATION_ORGANIC_SYMBOL,SOIL_COSMOS_NATURAL,SOIL_ORGANIC_COSMOS,SOSTAIN,SPCA_BC,STAR_D_KOSHER,STAR_K_KOSHER,STEEL_RECYCLING,STELLAR_CERTIFICATION_SERVICES,STIFTUNG_WARENTEST,STOP_CLIMATE_CHANGE,STREEKPRODUCT_BE,STRICTLY_KOSHER_NORWAY,SUISSE_GARANTIE,SUNSHINE_STATE_KOSHER,SUOMEN_HAMMASLAAKARILIITTO_SUOSITTELEE_KSYLITOLIA,SUS,SUSTAINABLE_AUSTRALIA_WINEGROWING,SUSTAINABLE_AUSTRIA,SUSTAINABLE_FORESTRY_INITIATIVE,SUSTAINABLE_PALM_OIL_RSPO,SUSTAINABLE_PALM_OIL_RSPO_CREDITS,SUSTAINABLE_PALM_OIL_RSPO_MIXED,SVANEN,SVENSK_FAGEL,SVENSKT_KOTT,SVENSKT_SIGILL_KLIMATCERTIFIERAD,SVENSKT_SIGILL_NATURBETESKOTT,SWEDISH_SEAL_OF_QUALITY,SWISS_ALLERGY_LABEL,SWISS_ALPS_PRODUCT,SWISS_MOUNTAIN_PRODUCT,SWISSGAP,SWISSMILK_GREEN,SWISSPRIMGOURMET,TARNOPOL_KASHRUS_KOSHER,TCO_DEVELOPMENT,TCO_ORGANIC,TERRA_VITIS,TERRACYCLE,THE_FAIR_RUBBER_ASSOCIATION,THE_NATURAL_AND_ORGANIC_AWARDS,THREE_LINE_KOSHER,TIERSCHUTZBUND,TNO_APPROVED,TOOTHFRIENDLY,TRADITIONAL_SPECIALTY_GUARANTEED,TRIANGLE_K,TRIMAN,TRUE_FOODS_CANADA_TRUSTMARK,TRUE_SOURCE_CERTIFIED,TUEV_GEPRUEFT,TUNNUSTATUD_EESTI_MAITSE,TUNNUSTATUD_MAITSE,UDEN_GMO_FODER,UMWELTBAUM,UNDERWRITERS_LABORATORY,UNDERWRITERS_LABORATORY_CERTIFIED_CANADA_US,UNIQUELY_FINNISH,UNITED_EGG_PRODUCERS_CERTIFIED,UNSER_LAND,URDINKEL,USDA,USDA_CERTIFIED_BIOBASED,USDA_GRADE_A,USDA_GRADE_AA,USDA_INSPECTION,USDA_ORGANIC,UTZ_CERTIFIED,UTZ_CERTIFIED_COCOA,VAAD_HOEIR_KOSHER,VAELG_FULDKORN_FORST,VDE,VDS_CERTIFICATE,VEGAN_AWARENESS_FOUNDATION,VEGAN_BY_EARTHKOSHER,VEGAN_NATURAL_FOOD_CERTIFIERS,VEGAN_SOCIETY_VEGAN_LOGO,VEGAPLAN,VEGATARIAN_SOCIETY_V_LOGO,VEGECERT,VEILIG_WONEN_POLITIE_KEURMERK,VERBUND_OEKOHOEFE,VIANDE_AGNEAU_FRANCAIS,VIANDE_BOVINE_FRANCAISE,VIANDE_CHEVALINE_FRANCAISE,VIANDE_DE_CHEVRE_FRANCAISE,VIANDE_DE_CHEVREAU_FRANCAISE,VIANDE_DE_VEAU_FRANCAISE,VIANDE_OVINE_FRANCAISE,VIANDES_DE_FRANCE,VIGNERONS_EN_DEVELOPPEMENT_DURABLE,VIM_CO_JIM,VINATURA,VINHO_VERDE,VITICULTURE_DURABLE_EN_CHAMPAGNE,VIVA,VOLAILLE_FRANCAISE,WARRANT_HOLDER_OF_THE_COURT_OF_BELGIUM,WEIDEMELK,WEIGHT_WATCHERS_ENDORSED,WESTERN_KOSHER,WHOLE_GRAIN_100_PERCENT_STAMP,WHOLE_GRAIN_BASIC_STAMP,WHOLE_GRAIN_COUNCIL_STAMP,WHOLE_GRAINS_50_PERCENT_STAMP,WIETA (Wine and Agricultural Ethical Trading Association),WINERIES_FOR_CLIMATE_PROTECTION,WISCONSIN_K,WQA_TESTED_CERTIFIED_WATER,WSDA,WWF_PANDA_LABEL,ZELDZAAM_LEKKER,ZERO_WASTE_BUSINESS_COUNCIL_CERTIFIED', ',')" />
  <xsl:variable name="DK-ISO-6523-ICD" select="tokenize('ZZZ 0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230', '\s')" />
  <xsl:variable name="OpenPEPPOL-IANA-MimeCode" select="tokenize('text/csv application/pdf image/png image/jpeg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')" />
  <xsl:template match="text()" mode="M9" priority="-1" />
  <xsl:template match="@*|node()" mode="M9" priority="-2">
    <xsl:apply-templates mode="M9" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/" mode="M10" priority="1000">
    <svrl:fired-rule context="/" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="local-name(*) = 'ApplicationResponse'" />
      <xsl:otherwise>
        <svrl:failed-assert test="local-name(*) = 'ApplicationResponse'">
          <xsl:attribute name="id">OIOUBL-AR-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                        Root element must be ApplicationResponse
                </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="namespace-uri(*) = 'urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2'" />
      <xsl:otherwise>
        <svrl:failed-assert test="namespace-uri(*) = 'urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2'">
          <xsl:attribute name="id">OIOUBL-AR-002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                        The documenttype does not match an OIOUBL ApplicationResponse and can not be validated by this schematron.
                </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/" mode="M11" priority="1001">
    <svrl:fired-rule context="/" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:Signature/cac:SignatoryParty/cac:PostalAddress)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:Signature/cac:SignatoryParty/cac:PostalAddress)">
          <xsl:attribute name="id">OIOUBL-COMMON-020</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Signature/cac:SignatoryParty/cac:PostalAddress'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:OrderReference/cac:DocumentReference)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:OrderReference/cac:DocumentReference)">
          <xsl:attribute name="id">OIOUBL-COMMON-021</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:OrderReference/cac:DocumentReference'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment)">
          <xsl:attribute name="id">OIOUBL-COMMON-022</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:BillingReference/cac:SelfBilledInvoiceDocumentReference)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:BillingReference/cac:SelfBilledInvoiceDocumentReference)">
          <xsl:attribute name="id">OIOUBL-COMMON-023</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:BillingReference/cac:SelfBilledInvoiceDocumentReference'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference)">
          <xsl:attribute name="id">OIOUBL-COMMON-024</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:BillingReference/cac:SelfBilledCreditNoteDocumentReference'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:BillingReference/cac:DebitNoteDocumentReference)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:BillingReference/cac:DebitNoteDocumentReference)">
          <xsl:attribute name="id">OIOUBL-COMMON-025</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:BillingReference/cac:DebitNoteDocumentReference'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:BillingReference/cac:ReminderDocumentReference/cac:Attachment)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:BillingReference/cac:ReminderDocumentReference/cac:Attachment)">
          <xsl:attribute name="id">OIOUBL-COMMON-026</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:BillingReference/cac:ReminderDocumentReference/cac:Attachment'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:Delivery/cac:DeliveryAddress)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:Delivery/cac:DeliveryAddress)">
          <xsl:attribute name="id">OIOUBL-COMMON-027</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:DeliveryAddress'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:Delivery/cac:CarrierParty)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:Delivery/cac:CarrierParty)">
          <xsl:attribute name="id">OIOUBL-COMMON-028</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:CarrierParty'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:BillingReference/cac:CreditNoteDocumentReference/cac:Attachment)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:BillingReference/cac:CreditNoteDocumentReference/cac:Attachment)">
          <xsl:attribute name="id">OIOUBL-COMMON-029</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:BillingReference/cac:CreditNoteDocumentReference/cac:Attachment'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:Delivery/cac:Shipment/cac:FreightAllowanceCharge)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:Delivery/cac:Shipment/cac:FreightAllowanceCharge)">
          <xsl:attribute name="id">OIOUBL-COMMON-030</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:FreightAllowanceCharge'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:BillingReference/cac:AdditionalDocumentReference)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:BillingReference/cac:AdditionalDocumentReference)">
          <xsl:attribute name="id">OIOUBL-COMMON-031</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:BillingReference/cac:AdditionalDocumentReference'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity)">
          <xsl:attribute name="id">OIOUBL-COMMON-032</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode)">
          <xsl:attribute name="id">OIOUBL-COMMON-033</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:PaymentMeans/cbc:PaymentDueDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:PaymentMeans/cbc:PaymentDueDate)">
          <xsl:attribute name="id">OIOUBL-COMMON-034</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:PaymentMeans/cbc:PaymentDueDate'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:AllowanceCharge/cac:PaymentMeans)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:AllowanceCharge/cac:PaymentMeans)">
          <xsl:attribute name="id">OIOUBL-COMMON-035</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:AllowanceCharge/cac:PaymentMeans'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:AllowanceCharge/cac:Taxtotal)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:AllowanceCharge/cac:Taxtotal)">
          <xsl:attribute name="id">OIOUBL-COMMON-037</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:AllowanceCharge/cac:Taxtotal'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:TaxTotal/cac:TaxSubtotal/cbc:Percent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:TaxTotal/cac:TaxSubtotal/cbc:Percent)">
          <xsl:attribute name="id">OIOUBL-COMMON-038</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:TaxTotal/cac:TaxSubtotal/cbc:Percent'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure)">
          <xsl:attribute name="id">OIOUBL-COMMON-039</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount)">
          <xsl:attribute name="id">OIOUBL-COMMON-040</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:Person)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:Person)">
          <xsl:attribute name="id">OIOUBL-COMMON-041</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Person'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(.//cac:Item/cac:Certificate/cac:DocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(.//cac:Item/cac:Certificate/cac:DocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject)">
          <xsl:attribute name="id">OIOUBL-COMMON-043</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Item/cac:Certificate/cac:DocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M11" priority="1000">
    <svrl:fired-rule context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cbc:LatestDeliveryDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cbc:LatestDeliveryDate)">
          <xsl:attribute name="id">OIOUBL-COMMON-052</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cbc:LatestDeliveryDate'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cbc:LatestDeliveryTime)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cbc:LatestDeliveryTime)">
          <xsl:attribute name="id">OIOUBL-COMMON-053</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cbc:LatestDeliveryTime'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cac:DeliveryAddress)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cac:DeliveryAddress)">
          <xsl:attribute name="id">OIOUBL-COMMON-054</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:DeliveryAddress'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:DeliveryTerms)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:DeliveryTerms)">
          <xsl:attribute name="id">OIOUBL-COMMON-055</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:DeliveryTerms'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:PaymentTerms)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:PaymentTerms)">
          <xsl:attribute name="id">OIOUBL-COMMON-056</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:PaymentTerms'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:CollectPaymentTerms)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:CollectPaymentTerms)">
          <xsl:attribute name="id">OIOUBL-COMMON-057</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:CollectPaymentTerms'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:DisbursementPaymentTerms)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:DisbursementPaymentTerms)">
          <xsl:attribute name="id">OIOUBL-COMMON-058</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:DisbursementPaymentTerms'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:PrepaidPaymentTerms)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:PrepaidPaymentTerms)">
          <xsl:attribute name="id">OIOUBL-COMMON-059</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:PrepaidPaymentTerms'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:FreightAllowanceCharge)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:FreightAllowanceCharge)">
          <xsl:attribute name="id">OIOUBL-COMMON-060</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:FreightAllowanceCharge'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:ExtraAllowanceCharge)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cac:Shipment/cac:Consignment/cac:ExtraAllowanceCharge)">
          <xsl:attribute name="id">OIOUBL-COMMON-061</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Delivery/cac:Shipment/cac:Consignment/cac:ExtraAllowanceCharge'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PaymentTerms)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PaymentTerms)">
          <xsl:attribute name="id">OIOUBL-COMMON-062</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:PaymentTerms'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Item/cac:TransactionConditions)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Item/cac:TransactionConditions)">
          <xsl:attribute name="id">OIOUBL-COMMON-063</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Item/cac:TransactionConditions'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Price/cac:AllowanceCharge/cac:PaymentMeans)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Price/cac:AllowanceCharge/cac:PaymentMeans)">
          <xsl:attribute name="id">OIOUBL-COMMON-064</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The use of element is not allowed - <xsl:text />
            <xsl:value-of select="replace(concat(path(), '/cac:Price/cac:AllowanceCharge/cac:PaymentMeans'), '(/Q\{[^}]+\})', '/')" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M11" priority="-1" />
  <xsl:template match="@*|node()" mode="M11" priority="-2">
    <xsl:apply-templates mode="M11" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode |                 cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" mode="M12" priority="1003">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode |                 cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@listID = 'TST') or (@listVersionID = '19.05.01' or @listVersionID = '19.0501' or @listVersionID = '26.08.01' or @listVersionID = '26.0801')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@listID = 'TST') or (@listVersionID = '19.05.01' or @listVersionID = '19.0501' or @listVersionID = '26.08.01' or @listVersionID = '26.0801')">
          <xsl:attribute name="id">OIOUBL-Common-GP001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>When @listID is "TST", the value of @listVersionID must be on of the following: "19.05.01", "19.0501", "26.08.01", or "26.0801" - Value
                        found: '<xsl:text />
            <xsl:value-of select="@listVersionID" />
            <xsl:text />' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@listID = 'TST') or (matches(., '^\d{8}$'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@listID = 'TST') or (matches(., '^\d{8}$'))">
          <xsl:attribute name="id">OIOUBL-Common-GP002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>When ItemClassificationCodevalue/listID = 'TST' then the value must be 8 digits - Value found: '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />' </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:AdditionalItemProperty |                         cac:CreditNoteLine/cac:Item/cac:AdditionalItemProperty" mode="M12" priority="1002">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:AdditionalItemProperty |                         cac:CreditNoteLine/cac:Item/cac:AdditionalItemProperty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Name = 'EmissionFactor') or (number(cbc:Value) = number(cbc:Value))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Name = 'EmissionFactor') or (number(cbc:Value) = number(cbc:Value))">
          <xsl:attribute name="id">OIOUBL-Common-GP004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>If AdditionalItemProperty/Name is 'EmissionFactor', then the AdditionalItemProperty/Value must be a valid numeric value</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Name = 'NetEmissionQuantity') or                         (                         round(number(../cac:AdditionalItemProperty[cbc:Name = 'EmissionFactor']/cbc:Value) * number(../../cbc:InvoicedQuantity) * 10000) div 10000 = round(number(cbc:Value)*10000) div 10000 or                         round(number(../cac:AdditionalItemProperty[cbc:Name = 'EmissionFactor']/cbc:Value) * number(../../cbc:CreditedQuantity) * 10000) div 10000 = round(number(cbc:Value)*10000) div 10000)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Name = 'NetEmissionQuantity') or ( round(number(../cac:AdditionalItemProperty[cbc:Name = 'EmissionFactor']/cbc:Value) * number(../../cbc:InvoicedQuantity) * 10000) div 10000 = round(number(cbc:Value)*10000) div 10000 or round(number(../cac:AdditionalItemProperty[cbc:Name = 'EmissionFactor']/cbc:Value) * number(../../cbc:CreditedQuantity) * 10000) div 10000 = round(number(cbc:Value)*10000) div 10000)">
          <xsl:attribute name="id">OIOUBL-Common-GP005</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>if Name is 'NetEmissionQuantity', then its Value must equal EmissionFactor * Quantity (InvoicedQuantity / CreditedQuantity)"
                        Values found
                        - NetEmissionQuantity value  <xsl:text />
            <xsl:value-of select="number(cbc:Value)" />
            <xsl:text />
                        - NetEmissionFactor value <xsl:text />
            <xsl:value-of select="number(../cac:AdditionalItemProperty[cbc:Name = 'EmissionFactor']/cbc:Value)" />
            <xsl:text />
                        - Quantity: <xsl:text />
            <xsl:value-of select="number(../../cbc:InvoicedQuantity)" />
            <xsl:text />
</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Name = 'EmissionFactorSource') or                                 (cbc:Value = 'Database' or cbc:Value = 'Internal')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Name = 'EmissionFactorSource') or (cbc:Value = 'Database' or cbc:Value = 'Internal')">
          <xsl:attribute name="id">OIOUBL-Common-GP006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>If AdditionalItemProperty/Name is 'EmissionFactorSource', then AdditionalItemProperty/Value must be either 'Database' or
                        'Internal'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Name = 'EmissionFactor') or                         (../cac:AdditionalItemProperty[cbc:Name = 'EmissionFactorSource'])" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Name = 'EmissionFactor') or (../cac:AdditionalItemProperty[cbc:Name = 'EmissionFactorSource'])">
          <xsl:attribute name="id">OIOUBL-Common-GP007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>If AdditionalItemProperty/Name is 'EmissionFactor', then another AdditionalItemProperty/Name = 'EmissionFactorSource' must exist </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:Name = 'EmissionFactorCalculationUnit') or                                 (some $val in $UNECERec20-11e                                         satisfies (cbc:Value = $val))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:Name = 'EmissionFactorCalculationUnit') or (some $val in $UNECERec20-11e satisfies (cbc:Value = $val))">
          <xsl:attribute name="id">OIOUBL-Common-GP008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>If AdditionalItemProperty/Name equal
                        'EmissionFactorCalculationUnit' then AdditionalItemProperty/Value must have a valid UnitCode value from the codelist UNECERec20-11e</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:variable name="UNCL7143" select="tokenize('AA,AB,AC,AD,AE,AF,AG,AH,AI,AJ,AK,AL,AM,AN,AO,AP,AQ,AR,AS,AT,AU,AV,AW,AX,AY,AZ,BA,BB,BC,BD,BE,BF,BG,BH,BI,BJ,BK,BL,BM,BN,BO,BP,BQ,BR,BS,BT,BU,BV,BW,BX,BY,BZ,CC,CG,CL,CR,CV,DR,DW,EC,EF,EMD,EN,FS,GB,GMN,GN,GS,HS,IB,IN,IS,IT,IZ,MA,MF,MN,MP,NB,ON,PD,PL,PO,PV,QS,RC,RN,RU,RY,SA,SG,SK,SN,SRS,SRT,SRU,SRV,SRW,SRX,SRY,SRZ,SS,SSA,SSB,SSC,SSD,SSE,SSF,SSG,SSH,SSI,SSJ,SSK,SSL,SSM,SSN,SSO,SSP,SSQ,SSR,SSS,SST,SSU,SSV,SSW,SSX,SSY,SSZ,ST,STA,STB,STC,STD,STE,STF,STG,STH,STI,STJ,STK,STL,STM,STN,STO,STP,STQ,STR,STS,STT,STU,STV,STW,STX,STY,STZ,SUA,SUB,SUC,SUD,SUE,SUF,SUG,SUH,SUI,SUJ,SUK,SUL,SUM,TG,TSN,TSO,TSP,TSQ,TSR,TSS,TST,TSU,UA,UP,VN,VP,VS,VX,ZZZ', ',')" />
  <xsl:variable name="UNECERec20-11e" select="tokenize('10,11,13,14,15,20,21,22,23,24,25,27,28,33,34,35,37,38,40,41,56,57,58,59,60,61,74,77,80,81,85,87,89,91,1I,2A,2B,2C,2G,2H,2I,2J,2K,2L,2M,2N,2P,2Q,2R,2U,2X,2Y,2Z,3B,3C,4C,4G,4H,4K,4L,4M,4N,4O,4P,4Q,4R,4T,4U,4W,4X,5A,5B,5E,5J,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A2,A20,A21,A22,A23,A24,A26,A27,A28,A29,A3,A30,A31,A32,A33,A34,A35,A36,A37,A38,A39,A4,A40,A41,A42,A43,A44,A45,A47,A48,A49,A5,A53,A54,A55,A56,A59,A6,A68,A69,A7,A70,A71,A73,A74,A75,A76,A8,A84,A85,A86,A87,A88,A89,A9,A90,A91,A93,A94,A95,A96,A97,A98,A99,AA,AB,ACR,ACT,AD,AE,AH,AI,AK,AL,AMH,AMP,ANN,APZ,AQ,AS,ASM,ASU,ATM,AWG,AY,AZ,B1,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B3,B30,B31,B32,B33,B34,B35,B4,B41,B42,B43,B44,B45,B46,B47,B48,B49,B50,B52,B53,B54,B55,B56,B57,B58,B59,B60,B61,B62,B63,B64,B66,B67,B68,B69,B7,B70,B71,B72,B73,B74,B75,B76,B77,B78,B79,B8,B80,B81,B82,B83,B84,B85,B86,B87,B88,B89,B90,B91,B92,B93,B94,B95,B96,B97,B98,B99,BAR,BB,BFT,BHP,BIL,BLD,BLL,BP,BPM,BQL,BTU,BUA,BUI,C0,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C20,C21,C22,C23,C24,C25,C26,C27,C28,C29,C3,C30,C31,C32,C33,C34,C35,C36,C37,C38,C39,C40,C41,C42,C43,C44,C45,C46,C47,C48,C49,C50,C51,C52,C53,C54,C55,C56,C57,C58,C59,C60,C61,C62,C63,C64,C65,C66,C67,C68,C69,C7,C70,C71,C72,C73,C74,C75,C76,C78,C79,C8,C80,C81,C82,C83,C84,C85,C86,C87,C88,C89,C9,C90,C91,C92,C93,C94,C95,C96,C97,C99,CCT,CDL,CEL,CEN,CG,CGM,CKG,CLF,CLT,CMK,CMQ,CMT,CNP,CNT,COU,CTG,CTM,CTN,CUR,CWA,CWI,D03,D04,D1,D10,D11,D12,D13,D15,D16,D17,D18,D19,D2,D20,D21,D22,D23,D24,D25,D26,D27,D29,D30,D31,D32,D33,D34,D36,D41,D42,D43,D44,D45,D46,D47,D48,D49,D5,D50,D51,D52,D53,D54,D55,D56,D57,D58,D59,D6,D60,D61,D62,D63,D65,D68,D69,D73,D74,D77,D78,D80,D81,D82,D83,D85,D86,D87,D88,D89,D91,D93,D94,D95,DAA,DAD,DAY,DB,DBM,DBW,DD,DEC,DG,DJ,DLT,DMA,DMK,DMO,DMQ,DMT,DN,DPC,DPR,DPT,DRA,DRI,DRL,DT,DTN,DWT,DZN,DZP,E01,E07,E08,E09,E10,E12,E14,E15,E16,E17,E18,E19,E20,E21,E22,E23,E25,E27,E28,E30,E31,E32,E33,E34,E35,E36,E37,E38,E39,E4,E40,E41,E42,E43,E44,E45,E46,E47,E48,E49,E50,E51,E52,E53,E54,E55,E56,E57,E58,E59,E60,E61,E62,E63,E64,E65,E66,E67,E68,E69,E70,E71,E72,E73,E74,E75,E76,E77,E78,E79,E80,E81,E82,E83,E84,E85,E86,E87,E88,E89,E90,E91,E92,E93,E94,E95,E96,E97,E98,E99,EA,EB,EQ,F01,F02,F03,F04,F05,F06,F07,F08,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19,F20,F21,F22,F23,F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,F36,F37,F38,F39,F40,F41,F42,F43,F44,F45,F46,F47,F48,F49,F50,F51,F52,F53,F54,F55,F56,F57,F58,F59,F60,F61,F62,F63,F64,F65,F66,F67,F68,F69,F70,F71,F72,F73,F74,F75,F76,F77,F78,F79,F80,F81,F82,F83,F84,F85,F86,F87,F88,F89,F90,F91,F92,F93,F94,F95,F96,F97,F98,F99,FAH,FAR,FBM,FC,FF,FH,FIT,FL,FNU,FOT,FP,FR,FS,FTK,FTQ,G01,G04,G05,G06,G08,G09,G10,G11,G12,G13,G14,G15,G16,G17,G18,G19,G2,G20,G21,G23,G24,G25,G26,G27,G28,G29,G3,G30,G31,G32,G33,G34,G35,G36,G37,G38,G39,G40,G41,G42,G43,G44,G45,G46,G47,G48,G49,G50,G51,G52,G53,G54,G55,G56,G57,G58,G59,G60,G61,G62,G63,G64,G65,G66,G67,G68,G69,G70,G71,G72,G73,G74,G75,G76,G77,G78,G79,G80,G81,G82,G83,G84,G85,G86,G87,G88,G89,G90,G91,G92,G93,G94,G95,G96,G97,G98,G99,GB,GBQ,GDW,GE,GF,GFI,GGR,GIA,GIC,GII,GIP,GJ,GL,GLD,GLI,GLL,GM,GO,GP,GQ,GRM,GRN,GRO,GV,GWH,H03,H04,H05,H06,H07,H08,H09,H10,H11,H12,H13,H14,H15,H16,H18,H19,H20,H21,H22,H23,H24,H25,H26,H27,H28,H29,H30,H31,H32,H33,H34,H35,H36,H37,H38,H39,H40,H41,H42,H43,H44,H45,H46,H47,H48,H49,H50,H51,H52,H53,H54,H55,H56,H57,H58,H59,H60,H61,H62,H63,H64,H65,H66,H67,H68,H69,H70,H71,H72,H73,H74,H75,H76,H77,H79,H80,H81,H82,H83,H84,H85,H87,H88,H89,H90,H91,H92,H93,H94,H95,H96,H98,H99,HA,HAD,HBA,HBX,HC,HDW,HEA,HGM,HH,HIU,HKM,HLT,HM,HMO,HMQ,HMT,HPA,HTZ,HUR,IA,IE,INH,INK,INQ,ISD,IU,IUG,IV,J10,J12,J13,J14,J15,J16,J17,J18,J19,J2,J20,J21,J22,J23,J24,J25,J26,J27,J28,J29,J30,J31,J32,J33,J34,J35,J36,J38,J39,J40,J41,J42,J43,J44,J45,J46,J47,J48,J49,J50,J51,J52,J53,J54,J55,J56,J57,J58,J59,J60,J61,J62,J63,J64,J65,J66,J67,J68,J69,J70,J71,J72,J73,J74,J75,J76,J78,J79,J81,J82,J83,J84,J85,J87,J90,J91,J92,J93,J95,J96,J97,J98,J99,JE,JK,JM,JNT,JOU,JPS,JWL,K1,K10,K11,K12,K13,K14,K15,K16,K17,K18,K19,K2,K20,K21,K22,K23,K26,K27,K28,K3,K30,K31,K32,K33,K34,K35,K36,K37,K38,K39,K40,K41,K42,K43,K45,K46,K47,K48,K49,K50,K51,K52,K53,K54,K55,K58,K59,K6,K60,K61,K62,K63,K64,K65,K66,K67,K68,K69,K70,K71,K73,K74,K75,K76,K77,K78,K79,K80,K81,K82,K83,K84,K85,K86,K87,K88,K89,K90,K91,K92,K93,K94,K95,K96,K97,K98,K99,KA,KAT,KB,KBA,KCC,KDW,KEL,KGM,KGS,KHY,KHZ,KI,KIC,KIP,KJ,KJO,KL,KLK,KLX,KMA,KMH,KMK,KMQ,KMT,KNI,KNM,KNS,KNT,KO,KPA,KPH,KPO,KPP,KR,KSD,KSH,KT,KTN,KUR,KVA,KVR,KVT,KW,KWH,KWN,KWO,KWS,KWT,KWY,KX,L10,L11,L12,L13,L14,L15,L16,L17,L18,L19,L2,L20,L21,L23,L24,L25,L26,L27,L28,L29,L30,L31,L32,L33,L34,L35,L36,L37,L38,L39,L40,L41,L42,L43,L44,L45,L46,L47,L48,L49,L50,L51,L52,L53,L54,L55,L56,L57,L58,L59,L60,L63,L64,L65,L66,L67,L68,L69,L70,L71,L72,L73,L74,L75,L76,L77,L78,L79,L80,L81,L82,L83,L84,L85,L86,L87,L88,L89,L90,L91,L92,L93,L94,L95,L96,L98,L99,LA,LAC,LBR,LBT,LD,LEF,LF,LH,LK,LM,LN,LO,LP,LPA,LR,LS,LTN,LTR,LUB,LUM,LUX,LY,M1,M10,M11,M12,M13,M14,M15,M16,M17,M18,M19,M20,M21,M22,M23,M24,M25,M26,M27,M29,M30,M31,M32,M33,M34,M35,M36,M37,M38,M39,M4,M40,M41,M42,M43,M44,M45,M46,M47,M48,M49,M5,M50,M51,M52,M53,M55,M56,M57,M58,M59,M60,M61,M62,M63,M64,M65,M66,M67,M68,M69,M7,M70,M71,M72,M73,M74,M75,M76,M77,M78,M79,M80,M81,M82,M83,M84,M85,M86,M87,M88,M89,M9,M90,M91,M92,M93,M94,M95,M96,M97,M98,M99,MAH,MAL,MAM,MAR,MAW,MBE,MBF,MBR,MC,MCU,MD,MGM,MHZ,MIK,MIL,MIN,MIO,MIU,MKD,MKM,MKW,MLD,MLT,MMK,MMQ,MMT,MND,MNJ,MON,MPA,MQD,MQH,MQM,MQS,MQW,MRD,MRM,MRW,MSK,MTK,MTQ,MTR,MTS,MTZ,MVA,MWH,N1,N10,N11,N12,N13,N14,N15,N16,N17,N18,N19,N20,N21,N22,N23,N24,N25,N26,N27,N28,N29,N3,N30,N31,N32,N33,N34,N35,N36,N37,N38,N39,N40,N41,N42,N43,N44,N45,N46,N47,N48,N49,N50,N51,N52,N53,N54,N55,N56,N57,N58,N59,N60,N61,N62,N63,N64,N65,N66,N67,N68,N69,N70,N71,N72,N73,N74,N75,N76,N77,N78,N79,N80,N81,N82,N83,N84,N85,N86,N87,N88,N89,N90,N91,N92,N93,N94,N95,N96,N97,N98,N99,NA,NAR,NCL,NEW,NF,NIL,NIU,NL,NM3,NMI,NMP,NPT,NT,NTU,NU,NX,OA,ODE,ODG,ODK,ODM,OHM,ON,ONZ,OPM,OT,OZA,OZI,P1,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P2,P20,P21,P22,P23,P24,P25,P26,P27,P28,P29,P30,P31,P32,P33,P34,P35,P36,P37,P38,P39,P40,P41,P42,P43,P44,P45,P46,P47,P48,P49,P5,P50,P51,P52,P53,P54,P55,P56,P57,P58,P59,P60,P61,P62,P63,P64,P65,P66,P67,P68,P69,P70,P71,P72,P73,P74,P75,P76,P77,P78,P79,P80,P81,P82,P83,P84,P85,P86,P87,P88,P89,P90,P91,P92,P93,P94,P95,P96,P97,P98,P99,PAL,PD,PFL,PGL,PI,PLA,PO,PQ,PR,PS,PTD,PTI,PTL,PTN,Q10,Q11,Q12,Q13,Q14,Q15,Q16,Q17,Q18,Q19,Q20,Q21,Q22,Q23,Q24,Q25,Q26,Q27,Q28,Q29,Q30,Q31,Q32,Q33,Q34,Q35,Q36,Q37,Q38,Q39,Q40,Q41,Q42,Q3,QA,QAN,QB,QR,QTD,QTI,QTL,QTR,R1,R9,RH,RM,ROM,RP,RPM,RPS,RT,S3,S4,SAN,SCO,SCR,SEC,SET,SG,SIE,SM3,SMI,SQ,SQR,SR,STC,STI,STK,STL,STN,STW,SW,SX,SYR,T0,T3,TAH,TAN,TI,TIC,TIP,TKM,TMS,TNE,TP,TPI,TPR,TQD,TRL,TST,TTS,U1,U2,UB,UC,VA,VLT,VP,W2,WA,WB,WCD,WE,WEB,WEE,WG,WHR,WM,WSD,WTT,X1,YDK,YDQ,YRD,Z11,Z9,ZP,ZZ,X1A,X1B,X1D,X1F,X1G,X1W,X2C,X3A,X3H,X43,X44,X4A,X4B,X4C,X4D,X4F,X4G,X4H,X5H,X5L,X5M,X6H,X6P,X7A,X7B,X8A,X8B,X8C,XAA,XAB,XAC,XAD,XAE,XAF,XAG,XAH,XAI,XAJ,XAL,XAM,XAP,XAT,XAV,XB4,XBA,XBB,XBC,XBD,XBE,XBF,XBG,XBH,XBI,XBJ,XBK,XBL,XBM,XBN,XBO,XBP,XBQ,XBR,XBS,XBT,XBU,XBV,XBW,XBX,XBY,XBZ,XCA,XCB,XCC,XCD,XCE,XCF,XCG,XCH,XCI,XCJ,XCK,XCL,XCM,XCN,XCO,XCP,XCQ,XCR,XCS,XCT,XCU,XCV,XCW,XCX,XCY,XCZ,XDA,XDB,XDC,XDG,XDH,XDI,XDJ,XDK,XDL,XDM,XDN,XDP,XDR,XDS,XDT,XDU,XDV,XDW,XDX,XDY,XEC,XED,XEE,XEF,XEG,XEH,XEI,XEN,XFB,XFC,XFD,XFE,XFI,XFL,XFO,XFP,XFR,XFT,XFW,XFX,XGB,XGI,XGL,XGR,XGU,XGY,XGZ,XHA,XHB,XHC,XHG,XHN,XHR,XIA,XIB,XIC,XID,XIE,XIF,XIG,XIH,XIK,XIL,XIN,XIZ,XJB,XJC,XJG,XJR,XJT,XJY,XKG,XKI,XLE,XLG,XLT,XLU,XLV,XLZ,XMA,XMB,XMC,XME,XMR,XMS,XMT,XMW,XMX,XNA,XNE,XNF,XNG,XNS,XNT,XNU,XNV,XO1,XO2,XO3,XO4,XO5,XO6,XO7,XO8,XO9,XOA,XOB,XOC,XOD,XOE,XOF,XOG,XOH,XOI,XOK,XOJ,XOL,XOM,XON,XOP,XOQ,XOR,XOS,XOV,XOW,XOT,XOU,XOX,XOY,XOZ,XP1,XP2,XP3,XP4,XPA,XPB,XPC,XPD,XPE,XPF,XPG,XPH,XPI,XPJ,XPK,XPL,XPN,XPO,XPP,XPR,XPT,XPU,XPV,XPX,XPY,XPZ,XQA,XQB,XQC,XQD,XQF,XQG,XQH,XQJ,XQK,XQL,XQM,XQN,XQP,XQQ,XQR,XQS,XRD,XRG,XRJ,XRK,XRL,XRO,XRT,XRZ,XSA,XSB,XSC,XSD,XSE,XSH,XSI,XSK,XSL,XSM,XSO,XSP,XSS,XST,XSU,XSV,XSW,XSX,XSY,XSZ,XT1,XTB,XTC,XTD,XTE,XTG,XTI,XTK,XTL,XTN,XTO,XTR,XTS,XTT,XTU,XTV,XTW,XTY,XTZ,XUC,XUN,XVA,XVG,XVI,XVK,XVL,XVO,XVP,XVQ,XVN,XVR,XVS,XVY,XWA,XWB,XWC,XWD,XWF,XWG,XWH,XWJ,XWK,XWL,XWM,XWN,XWP,XWQ,XWR,XWS,XWT,XWU,XWV,XWW,XWX,XWY,XWZ,XXA,XXB,XXC,XXD,XXF,XXG,XXH,XXJ,XXK,XYA,XYB,XYC,XYD,XYF,XYG,XYH,XYJ,XYK,XYL,XYM,XYN,XYP,XYQ,XYR,XYS,XYT,XYV,XYW,XYX,XYY,XYZ,XZA,XZB,XZC,XZD,XZF,XZG,XZH,XZJ,XZK,XZL,XZM,XZN,XZP,XZQ,XZR,XZS,XZT,XZU,XZV,XZW,XZX,XZY,XZZ', ',')" />
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN profile-->


	<!--RULE -->
<xsl:template match="/ubl:ApplicationResponse/cbc:ProfileID" mode="M13" priority="1001">
    <svrl:fired-rule context="/ubl:ApplicationResponse/cbc:ProfileID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) = 'urn:fdc:oioubl.dk:bis:message_level_response:3' or normalize-space(text()) = 'urn:fdc:oioubl.dk:bis:message_level_response_network:3'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) = 'urn:fdc:oioubl.dk:bis:message_level_response:3' or normalize-space(text()) = 'urn:fdc:oioubl.dk:bis:message_level_response_network:3'">
          <xsl:attribute name="id">OIOUBL-MLR-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                Element 'cbc:ProfileID' MUST contain value 'urn:fdc:oioubl.dk:bis:message_level_response:3' or 'urn:fdc:oioubl.dk:bis:message_level_response_network:3'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:ApplicationResponse/cbc:CustomizationID" mode="M13" priority="1000">
    <svrl:fired-rule context="/ubl:ApplicationResponse/cbc:CustomizationID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(.) = 'urn:fdc:peppol.eu:poacc:trns:mlr:3@urn:fdc:oioubl.dk:trns:message_level_response:3.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(.) = 'urn:fdc:peppol.eu:poacc:trns:mlr:3@urn:fdc:oioubl.dk:trns:message_level_response:3.0'">
          <xsl:attribute name="id">OIOUBL-MLR-002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:peppol.eu:poacc:trns:mlr:3@urn:fdc:oioubl.dk:trns:message_level_response:3.0'.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN message_level_response_network-->


	<!--RULE -->
<xsl:template match="/ubl:ApplicationResponse" mode="M14" priority="1000">
    <svrl:fired-rule context="/ubl:ApplicationResponse" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:ProfileID = 'urn:fdc:oioubl.dk:bis:message_level_response_network:3' and cac:DocumentResponse/cac:Response/cbc:ResponseCode = 'RE') or cbc:ProfileID != 'urn:fdc:oioubl.dk:bis:message_level_response_network:3'" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:ProfileID = 'urn:fdc:oioubl.dk:bis:message_level_response_network:3' and cac:DocumentResponse/cac:Response/cbc:ResponseCode = 'RE') or cbc:ProfileID != 'urn:fdc:oioubl.dk:bis:message_level_response_network:3'">
          <xsl:attribute name="id">OIOUBL-MLR-003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				If ProfileID is 'urn:fdc:oioubl.dk:bis:message_level_response_network:3' then ResponseCode MUST be 'RE'
			</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
