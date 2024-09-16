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
    <svrl:schematron-output schemaVersion="" title="Schematron Version 1.0.9 - CIUS-RO version 1.0.1 compatible - UBL - Invoice">
      <xsl:attribute name="phase">romodel_phase</xsl:attribute>
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
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">ROmodel</xsl:attribute>
        <xsl:attribute name="name">ROmodel</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M10" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Schematron Version 1.0.9 - CIUS-RO version 1.0.1 compatible - UBL - Invoice</svrl:text>

<!--PATTERN ROmodel-->
<xsl:variable name="RO-MAJOR-MINOR-PATCH-VERSION" select="'1.0.1'" />
  <xsl:variable name="RO-CIUS-ID" select="concat('urn:cen.eu:en16931:2017#compliant#urn:efactura.mfinante.ro:CIUS-RO:', $RO-MAJOR-MINOR-PATCH-VERSION)" />
  <xsl:variable name="RO-EMAIL-REGEX" select="'^[0-9a-zA-Z]([0-9a-zA-Z\.]*)[^\.\s@]@[^\.\s@]([0-9a-zA-Z\.]*)[0-9a-zA-Z]$'" />
  <xsl:variable name="RO-TELEPHONE-REGEX" select="'.*([0-9].*){3,}.*'" />
  <xsl:variable name="ISO-3166-RO-CODES" select="('RO-AB','RO-AG','RO-AR','RO-B','RO-BC','RO-BH','RO-BN','RO-BR','RO-BT','RO-BV','RO-BZ','RO-CJ','RO-CL','RO-CS','RO-CT', 'RO-CV', 'RO-DB', 'RO-DJ', 'RO-GJ', 'RO-GL', 'RO-GR', 'RO-HD', 'RO-HR' , 'RO-IF', 'RO-IL', 'RO-IS', 'RO-MH', 'RO-MM', 'RO-MS', 'RO-NT', 'RO-OT', 'RO-PH', 'RO-SB', 'RO-SJ', 'RO-SM', 'RO-SV', 'RO-TL', 'RO-TM', 'RO-TR', 'RO-VL', 'RO-VN', 'RO-VS')" />
  <xsl:variable name="SECTOR-RO-CODES" select="('SECTOR1', 'SECTOR2', 'SECTOR3', 'SECTOR4', 'SECTOR5', 'SECTOR6')" />

	<!--RULE -->
<xsl:template match="cbc:IssueDate" mode="M10" priority="1028">
    <svrl:fired-rule context="cbc:IssueDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(text()) = 10 and (string(.) castable as xs:date)" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(text()) = 10 and (string(.) castable as xs:date)">
          <xsl:attribute name="id">BR-RO-DT001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-DT001]-Un element de tip data (BT-2, BT-27) trebuie sa respecte formatul YYYY-MM-DD
			#A date (BT-2, BT-27) MUST be formatted YYYY-MM-DD. (<xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> = '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:TaxPointDate" mode="M10" priority="1027">
    <svrl:fired-rule context="cbc:TaxPointDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(text()) = 10 and (string(.) castable as xs:date)" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(text()) = 10 and (string(.) castable as xs:date)">
          <xsl:attribute name="id">BR-RO-DT002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-DT002]-Un element de tip data (BT-7) trebuie sa respecte formatul YYYY-MM-DD
			#A date (BT-7) MUST be formatted YYYY-MM-DD. (<xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> = '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:DueDate" mode="M10" priority="1026">
    <svrl:fired-rule context="cbc:DueDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(text()) = 10 and (string(.) castable as xs:date)" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(text()) = 10 and (string(.) castable as xs:date)">
          <xsl:attribute name="id">BR-RO-DT003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-DT003]-Un element de tip data (BT-9) trebuie sa respecte formatul YYYY-MM-DD
			#A date (BT-9) MUST be formatted YYYY-MM-DD. (<xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> = '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:PaymentDueDate" mode="M10" priority="1025">
    <svrl:fired-rule context="cbc:PaymentDueDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(text()) = 10 and (string(.) castable as xs:date)" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(text()) = 10 and (string(.) castable as xs:date)">
          <xsl:attribute name="id">BR-RO-DT003_CN</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-DT003-CN]-Un element de tip data (BT-9) trebuie sa respecte formatul YYYY-MM-DD
			#A date (BT-9) MUST be formatted YYYY-MM-DD. (<xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> = '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:ActualDeliveryDate" mode="M10" priority="1024">
    <svrl:fired-rule context="cbc:ActualDeliveryDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(text()) = 10 and (string(.) castable as xs:date)" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(text()) = 10 and (string(.) castable as xs:date)">
          <xsl:attribute name="id">BR-RO-DT004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-DT004]-Un element de tip data (BT-72) trebuie sa respecte formatul YYYY-MM-DD
			#A date (BT-73, BT-134) MUST be formatted YYYY-MM-DD. (<xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> = '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:StartDate" mode="M10" priority="1023">
    <svrl:fired-rule context="cbc:StartDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(text()) = 10 and (string(.) castable as xs:date)" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(text()) = 10 and (string(.) castable as xs:date)">
          <xsl:attribute name="id">BR-RO-DT005</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-DT005]-Un element de tip data (BT-73, BT-134) trebuie sa respecte formatul YYYY-MM-DD
			#A date (BT-73, BT-134) MUST be formatted YYYY-MM-DD. (<xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> = '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndDate" mode="M10" priority="1022">
    <svrl:fired-rule context="cbc:EndDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(text()) = 10 and (string(.) castable as xs:date)" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(text()) = 10 and (string(.) castable as xs:date)">
          <xsl:attribute name="id">BR-RO-DT006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-DT006]-Un element de tip data (BT-74, BT-135) trebuie sa respecte formatul YYYY-MM-DD
			#A date (BT-74, BT-135) MUST be formatted YYYY-MM-DD. (<xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> = '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:PriceAmount" mode="M10" priority="1021">
    <svrl:fired-rule context="cbc:PriceAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(.) >=0" />
      <xsl:otherwise>
        <svrl:failed-assert test="(.) >=0">
          <xsl:attribute name="id">BR-27</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-27]-Preţul net al articolului (BT-146) trebuie să NU fie negativ.
			#The Item net price (BT-146) shall NOT be negative. (<xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> = '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />')</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:InvoiceTypeCode" mode="M10" priority="1020">
    <svrl:fired-rule context="cbc:InvoiceTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(. and ((not(contains(normalize-space(.), ' ')) and contains(' 380 384 389 751 ', concat(' ', normalize-space(.), ' ')))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(. and ((not(contains(normalize-space(.), ' ')) and contains(' 380 384 389 751 ', concat(' ', normalize-space(.), ' ')))))">
          <xsl:attribute name="id">BR-RO-020_1</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-020]-Codul tipului facturii (BT-3) trebuie sa fie unul dintre urmatoarele coduri din lista de coduri UNTDID 1001: 380 (Factura), 389 (Autofactura), 384 (Factura corectata), 381 (Nota de creditare), 751 (Factura — informatii în scopuri contabile).
			#The invoice type code (BT-3) must be one of the following codes in the UNTDID 1001 code list: 380 (Invoice), 389 (Self-invoice), 384 (Corrected invoice), 381 (Credit note), 751 (Invoice - information for accounting purposes).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:CreditNoteTypeCode" mode="M10" priority="1019">
    <svrl:fired-rule context="cbc:CreditNoteTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(. and ((not(contains(normalize-space(.), ' ')) and contains(' 381 ', concat(' ', normalize-space(.), ' ')))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(. and ((not(contains(normalize-space(.), ' ')) and contains(' 381 ', concat(' ', normalize-space(.), ' ')))))">
          <xsl:attribute name="id">BR-RO-020_2</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-020]-Codul tipului facturii (BT-3) trebuie sa fie unul dintre urmatoarele coduri din lista de coduri UNTDID 1001: 380 (Factura), 389 (Autofactura), 384 (Factura corectata), 381 (Nota de creditare), 751 (Factura — informatii în scopuri contabile).
			(<xsl:text />
            <xsl:value-of select="name(.)" />
            <xsl:text /> = '<xsl:text />
            <xsl:value-of select="." />
            <xsl:text />')
			#The invoice type code (BT-3) must be one of the following codes in the UNTDID 1001 code list: 380 (Invoice), 389 (Self-invoice), 384 (Corrected invoice), 381 (Credit note), 751 (Invoice - information for accounting purposes).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M10" priority="1018">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CustomizationID = $RO-CIUS-ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CustomizationID = $RO-CIUS-ID">
          <xsl:attribute name="id">BR-RO-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-001]-Identificatorul specificatie (BT-24) trebuie sa corespunda sintactic cu valoarea precizata in Specificatii tehnice și de utilizare a elementelor de baza ale facturii electronice - RO_CIUS - și a regulilor operationale specifice aplicabile la nivel national.
							#The specification identifier (BT-24) must syntactically correspond to the value specified in the Technical and Usage Specifications of the basic elements of the electronic invoice - RO_CIUS - and the specific operational rules applicable at national level(<xsl:text />
            <xsl:value-of select="$RO-CIUS-ID" />
            <xsl:text />).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:Note) &lt;= 20" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:Note) &lt;= 20">
          <xsl:attribute name="id">BR-RO-A020</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-A020]-O factura trebuie sa contina maximum 20 de aparitii ale grupului Comentariu in factura (BG-1).
							#The allowed maximum number of occurences of Invoice note (BG-1) is 20.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone)) &lt;=20" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone)) &lt;=20">
          <xsl:attribute name="id">BR-RO-L0201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L020]-Numarul maxim permis de caractere pentru Codul postal al Vanzatorului (BT-38) este 20.
							#The allowed maximum number of characters for the Seller post code (BT-38) is 20.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone)) &lt;=20" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone)) &lt;=20">
          <xsl:attribute name="id">BR-RO-L0202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L020]-Numarul maxim permis de caractere pentru Codul postal al Cumparatorului (BT-53) este 20.
							#The allowed maximum number of characters for the Buyer post code (BT-53) is 20.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:PostalZone)) &lt;= 20" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:PostalZone)) &lt;= 20">
          <xsl:attribute name="id">BR-RO-L0203</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L020]-Numarul maxim permis de caractere pentru Codul postal al reprezentantului fiscal (BT-67) este 20.
							#The allowed maximum number of characters for the Tax representative post code (BT-67) is 20.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone)) &lt;= 20" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone)) &lt;= 20">
          <xsl:attribute name="id">BR-RO-L0204</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L020]-Numarul maxim permis de caractere pentru Codul postal de livrare (BT-78) este 20.
							#The allowed maximum number of characters for the Deliver to post code (BT-78) is 20.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:ID)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:ID)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L155</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Numarul facturii (BT-1) este 200.
							#The allowed maximum number of characters for the Invoice number (BT-1) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:ContractDocumentReference/cbc:ID)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:ContractDocumentReference/cbc:ID)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L0302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Referinta contractului (BT-12) este 200.
							#The allowed maximum number of characters for the Contract reference(BT-12) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:OrderReference/cbc:ID)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:OrderReference/cbc:ID)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L0303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Referinta comenzii (BT-13) este 200.
							#The allowed maximum number of characters for the Purchase order reference(BT-13) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:OrderReference/cbc:SalesOrderID)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:OrderReference/cbc:SalesOrderID)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L0304</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Referinta dispozitiei de vanzare (BT-14) este 200.
							#The allowed maximum number of characters for the Sales order reference (BT-14) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:ReceiptDocumentReference/cbc:ID)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:ReceiptDocumentReference/cbc:ID)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L0305</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Referinta avizului de receptie (BT-15) este 200.
							#The allowed maximum number of characters for the Receiving advice reference (BT-15) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:DespatchDocumentReference/cbc:ID)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:DespatchDocumentReference/cbc:ID)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L0306</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Referinta avizului de expeditie (BT-16) este 200.
							#The allowed maximum number of characters for the Despatch advice reference (BT-16) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:OriginatorDocumentReference/cbc:ID)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:OriginatorDocumentReference/cbc:ID)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L0307</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Referinta cererii de oferta sau a lotului (BT-17) este 200.
							#The allowed maximum number of characters for the Tender or lot reference (BT-17) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName)) &lt;= 50" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName)) &lt;= 50">
          <xsl:attribute name="id">BR-RO-L0501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L050]-Numarul maxim permis de caractere pentru Localitatea Vanzatorului (BT-37) este 50.
							#The allowed maximum number of characters for the Seller city (BT-37) is 50.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName)) &lt;= 50" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName)) &lt;= 50">
          <xsl:attribute name="id">BR-RO-L0502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L050]-Numarul maxim permis de caractere pentru Localitatea Cumparatorului (BT-52) este 50.
							#The allowed maximum number of characters for the Buyer city (BT-52) is 50.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CityName)) &lt;= 50" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CityName)) &lt;= 50">
          <xsl:attribute name="id">BR-RO-L0503</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L050]-Numarul maxim permis de caractere pentru Localitatea reprezentantului fiscal (BT-66) este 50.
							#The allowed maximum number of characters for the Tax representative city (BT-66) is 50.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName)) &lt;= 50" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName)) &lt;= 50">
          <xsl:attribute name="id">BR-RO-L0504</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L050]-Numarul maxim permis de caractere pentru Localitatea de livrare (BT-77) este 50.
							#The allowed maximum number of characters for the Deliver to city (BT-77) is 50.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:AccountingCost)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:AccountingCost)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Referinta contabila a Cumparatorului (BT-19) este 100.
							#The allowed maximum number of characters for the Buyer accounting reference (BT-19) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Adresa Vanzatorului - Linia 2 (BT-36) este 100.
							#The allowed maximum number of characters for the Seller address line 2 (BT-36) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Adresa Vanzatorului - Linia 3 (BT-162) este 100.
							#The allowed maximum number of characters for the Seller address line 3 (BT-162) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Punctul de contact al Vanzatorului (BT-41) este 100.
							#The allowed maximum number of characters for the Seller contact point (BT-41) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1005</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Numarul de telefon al contactului Vanzatorului (BT-42) este 100.
							#The allowed maximum number of characters for the Seller contact telephone number (BT-42) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Adresa de email a contactului Vanzatorului (BT-43) este 100.
							#The allowed maximum number of characters for the Seller contact email address (BT-43) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Adresa Cumparatorului - Linia 2 (BT-51) este 100.
							#The allowed maximum number of characters for the Buyer address line 2 (BT-51) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Adresa Cumparatorului - Linia 3 (BT-163) este 100.
							#The allowed maximum number of characters for the Buyer address line 3 (BT-163) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1009</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Punctul de contact al Cumparatorului (BT-56) este 100.
							#The allowed maximum number of characters for the Buyer contact point (BT-56) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telephone)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telephone)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1010</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Numarul de telefon al contactului Cumparatorului (BT-57) este 100.
							#The allowed maximum number of characters for the Buyer contact telephone number (BT-57) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1011</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Adresa de email a contactului Cumparatorului (BT-58) este 100.
							#The allowed maximum number of characters for the Buyer contact email address (BT-58) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AdditionalStreetName)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AdditionalStreetName)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1012</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Adresa reprezentantului fiscal - Linia 2 (BT-65) este 100.
							#The allowed maximum number of characters for the Tax representative address line 2 (BT-65) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine/cbc:Line)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine/cbc:Line)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1013</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Adresa reprezentantului fiscal - Linia 3 (BT-164) este 100.
							#The allowed maximum number of characters for the Tax representative address line 3 (BT-164) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1014</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Adresa de livrare - Linia 2 (BT-76) este 100.
							#The allowed maximum number of characters for the Deliver to address line 2 (BT-76) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1015</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Adresa de livrare - Linia 3 (BT-165) este 100.
							#The allowed maximum number of characters for the Deliver to address line 3 (BT-165) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName)) &lt;= 150" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName)) &lt;= 150">
          <xsl:attribute name="id">BR-RO-L151</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L150]-Numarul maxim permis de caractere pentru Adresa Vanzatorului - Linia 1 (BT-35) este 150.
							#The allowed maximum number of characters for the Seller address line 1 (BT-35) is 150.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName)) &lt;= 150" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName)) &lt;= 150">
          <xsl:attribute name="id">BR-RO-L152</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L150]-Numarul maxim permis de caractere pentru Adresa Cumparatorului - Linia 1 (BT-50) este 150.
							#The allowed maximum number of characters for the Buyer address line 1 (BT-50) is 150.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:StreetName)) &lt;= 150" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:TaxRepresentativeParty/cac:PostalAddress/cbc:StreetName)) &lt;= 150">
          <xsl:attribute name="id">BR-RO-L153</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L150]-Numarul maxim permis de caractere pentru Adresa reprezentantului fiscal - Linia 1 (BT-64) este 150.
							#The allowed maximum number of characters for the Tax representative address line 1 (BT-64) is 150.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName)) &lt;= 150" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName)) &lt;= 150">
          <xsl:attribute name="id">BR-RO-L154</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L150]-Numarul maxim permis de caractere pentru Adresa de livrare - Linia(BT-75) 1 este 150.
							#The allowed maximum number of characters for the Deliver to address line 1(BT-75) is 150.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Numele Vanzatorului (BT-27) este 200.
							#The allowed maximum number of characters for the Seller name (BT-27) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Denumirea comerciala a Vanzatorului (BT-28), este 200.
							#The allowed maximum number of characters for the Seller trading name (BT-28) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L203</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Numele Cumparatorului (BT-44), este 200.
							#The allowed maximum number of characters for the Buyer name (BT-44) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L204</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Denumirea comerciala a Cumparatorului (BT-45), este 200.
							#The allowed maximum number of characters for the Buyer trading name (BT-45) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:PayeeParty/cac:PartyName/cbc:Name)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:PayeeParty/cac:PartyName/cbc:Name)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L205</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Numele Beneficiarului  (BT-59), este 200.
							#The allowed maximum number of characters for the Payee name (BT-59) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:TaxRepresentativeParty/cac:PartyName/cbc:Name)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:TaxRepresentativeParty/cac:PartyName/cbc:Name)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L206</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Numele reprezentantului fiscal al Vanzatorului (BT-62), este 200.
				#The allowed maximum number of characters for the Seller tax representative name (BT-62) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:Delivery/cac:DeliveryParty/cac:PartyName/cbc:Name)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:Delivery/cac:DeliveryParty/cac:PartyName/cbc:Name)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L207</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Numele partii catre care se face livrarea  (BT-70), este 200.
							#The allowed maximum number of characters for the Deliver to party name (BT-70) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:PaymentTerms/cbc:Note)) &lt;= 300" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:PaymentTerms/cbc:Note)) &lt;= 300">
          <xsl:attribute name="id">BR-RO-L301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L300]-Numarul maxim permis de caractere pentru Termeni de plata  (BT-20) este 300.
							#The allowed maximum number of characters for the Payment terms (BT-20) is 300.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm)) &lt;= 1000" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm)) &lt;= 1000">
          <xsl:attribute name="id">BR-RO-L1000</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L1000]-Numarul maxim permis de caractere pentru Informatii juridice suplimentare despre Vanzator (BT-33)) este 1000.
							#The allowed maximum number of characters for the Seller additional legal (BT-33) is 1000.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(cbc:ID), '([0-9])')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(cbc:ID), '([0-9])')">
          <xsl:attribute name="id">BR-RO-010</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-010]-Numarul facturii (BT-1) trebuie sa includa cel putin un caracter numeric (0—9).		
							#Invoice number (BT-1) must include at least one numeric character (0-9).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(normalize-space(cbc:TaxCurrencyCode) = 'RON' and normalize-space(cbc:DocumentCurrencyCode) != 'RON') or (normalize-space(cbc:TaxCurrencyCode) = 'RON' and normalize-space(cbc:DocumentCurrencyCode) = 'RON')  or (normalize-space(cbc:TaxCurrencyCode) != 'RON' and normalize-space(cbc:DocumentCurrencyCode) = 'RON') or (not(exists (cbc:TaxCurrencyCode)) and normalize-space(cbc:DocumentCurrencyCode) = 'RON')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(normalize-space(cbc:TaxCurrencyCode) = 'RON' and normalize-space(cbc:DocumentCurrencyCode) != 'RON') or (normalize-space(cbc:TaxCurrencyCode) = 'RON' and normalize-space(cbc:DocumentCurrencyCode) = 'RON') or (normalize-space(cbc:TaxCurrencyCode) != 'RON' and normalize-space(cbc:DocumentCurrencyCode) = 'RON') or (not(exists (cbc:TaxCurrencyCode)) and normalize-space(cbc:DocumentCurrencyCode) = 'RON')">
          <xsl:attribute name="id">BR-RO-030</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-030]-Daca Codul monedei facturii (BT-5) este altul decat RON, atunci Codul monedei de contabilizare a TVA (BT-6) trebuie sa fie RON.
							#If the Invoice currency code (BT-5) is other than RON, then the VAT accounting currency code(BT-6) must be RON.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and     following-sibling::cac:TaxScheme/cbc:ID = 'VAT'] = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or     (cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true'] = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or     (cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M'))) or     (cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID, cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[boolean(normalize-space(.))])" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and following-sibling::cac:TaxScheme/cbc:ID = 'VAT'] = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or (cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true'] = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or (cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M'))) or (cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID, cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[boolean(normalize-space(.))])">
          <xsl:attribute name="id">BR-RO-065</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-065]-Identificatorul de înregistrare fiscala a Vanzatorului (BT-32) si/sau Identificatorul de TVA al Vanzatorului (BT-31) si/sau Identificatorul de TVA al reprezentantului fiscal al Vanzatorului (BT-63) trebuie sa fie înscris.
							#The Seller tax registration identifier (BT-32) and/or the Seller VAT identifier (BT-31) and/or the Seller tax representative VAT identifier (BT-63) shall be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName[boolean(normalize-space(.))]" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName[boolean(normalize-space(.))]">
          <xsl:attribute name="id">BR-RO-081</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-080]-Adresa Vanzatorului - Linia 1 (BT-35) trebuie furnizata.
							#Seller address line 1(BT-35) must be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName[boolean(normalize-space(.))]" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName[boolean(normalize-space(.))]">
          <xsl:attribute name="id">BR-RO-082</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-080]-Adresa Cumparatorului - Linia 1 (BT-50) trebuie furnizata.
							#Buyer address line 1(BT-50) must be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName[boolean(normalize-space(.))]" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName[boolean(normalize-space(.))]">
          <xsl:attribute name="id">BR-RO-091</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-090]-Localitatea Vanzatorului (BT-37) trebuie furnizata.
							#Seller city(BT-37) must be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName[boolean(normalize-space(.))]" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName[boolean(normalize-space(.))]">
          <xsl:attribute name="id">BR-RO-092</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-090]-Localitatea Cumparatorului (BT-52) trebuie furnizata.
							#Buyer city(BT-37) must be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = 'RO' and normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) = 'RO-B' and not(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName) = $SECTOR-RO-CODES))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = 'RO' and normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) = 'RO-B' and not(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName) = $SECTOR-RO-CODES))">
          <xsl:attribute name="id">BR-RO-100</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-100]-Daca Codul tarii Vanzatorului (BT-40) este RO si Subdiviziunea tarii Vanzatorului (BT-39) este RO-B (corespunzator Municipiului Bucuresti), atunci Localitatea Vanzatorului (BT-37) trebuie sa fie codificata folosind lista de coduri SECTOR-RO.
				#If the Seller's country Code (BT-40) is RO and the Seller's country subdivision (BT-39) is RO-B (corresponding to Bucharest Municipality), then the Seller city (BT-37) must be coded using the code list SECTOR-RO(SECTOR1, SECTOR2, SECTOR3, SECTOR4, SECTOR5, SECTOR6).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = 'RO' and not(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) = $ISO-3166-RO-CODES))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = 'RO' and not(normalize-space(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) = $ISO-3166-RO-CODES))">
          <xsl:attribute name="id">BR-RO-110</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-110]-Daca Codul tarii Vanzatorului (BT-40) este RO, atunci Subdiviziunea tarii Vanzatorului (BT-39) trebuie sa fie codificata folosind lista de coduri ISO 3166-2:RO (ex. "RO-B" pentru Municipiul Bucuresti, "RO-AB" pentru judetul Alba...).
				#If the Seller's country Code (BT-40) is RO, then the Seller's country subdivision (BT-39) must be coded using the ISO 3166-2: RO code list (ex. "RO-B" for Bucharest, "RO-AB" for Alba County...).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = 'RO' and normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) = 'RO-B' and not(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) = $SECTOR-RO-CODES))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = 'RO' and normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) = 'RO-B' and not(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName) = $SECTOR-RO-CODES))">
          <xsl:attribute name="id">BR-RO-101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-100]-Daca Codul tarii Cumparatorului (BT-55) este RO si Subdiviziunea tarii Cumparatorului (BT-54) este RO-B (corespunzator Municipiului Bucuresti), atunci Localitatea Cumparatorului (BT-52) trebuie sa fie codificata folosind lista de coduri SECTOR-RO.
				#If the Buyer's country Code (BT-55) is RO and the Buyer's country subdivision (BT-54) is RO-B (corresponding to Bucharest Municipality), then the Buyer city (BT-52) must be coded using the code list SECTOR-RO(SECTOR1, SECTOR2, SECTOR3, SECTOR4, SECTOR5, SECTOR6).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = 'RO' and not(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) = $ISO-3166-RO-CODES))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = 'RO' and not(normalize-space(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity) = $ISO-3166-RO-CODES))">
          <xsl:attribute name="id">BR-RO-111</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-110]-Daca Codul tarii Cumparatorului (BT-55) este RO, atunci Subdiviziunea tarii Cumparatorului (BT-54) trebuie sa fie codificata folosind lista de coduri ISO 3166-2:RO (ex. "RO-B" pentru Municipiul Bucuresti, "RO-AB" pentru judetul Alba...).
				#If the Buyer's country Code (BT-55) is RO, then the Buyer's country subdivision (BT-54) must be coded using the ISO 3166-2: RO code list (ex. "RO-B" for Bucharest, "RO-AB" for Alba County...).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and     following-sibling::cac:TaxScheme/cbc:ID = 'VAT'] = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or     (cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true'] = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or     (cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M'))) or     (cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID, cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[boolean(normalize-space(.))])" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and following-sibling::cac:TaxScheme/cbc:ID = 'VAT'] = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or (cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true'] = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')) or (cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID = ('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M'))) or (cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID, cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[boolean(normalize-space(.))])">
          <xsl:attribute name="id">BR-RO-120</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-120]-Identificatorul de înregistrare legala a Cumparatorului (BT-47) si/sau Identificatorul de TVA al Cumparatorului (BT-48) trebuie sa fie înscris.
							#The Buyer legal registration identifier (BT-47) and/or the Buyer VAT identifier (BT-48) shall be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress | /ubl:CreditNote/cac:TaxRepresentativeParty/cac:PostalAddress" mode="M10" priority="1017">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress | /ubl:CreditNote/cac:TaxRepresentativeParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:StreetName[boolean(normalize-space(.))]" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:StreetName[boolean(normalize-space(.))]">
          <xsl:attribute name="id">BR-RO-140</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-140"]-Adresa poștala a reprezentantului fiscal al Vanzatorului (BG-12) trebuie sa contina Linia 1 (BT-64), daca Vanzatorul (BG-4) are un reprezentant fiscal al Vanzatorului (BG-11).
							#Tax representative address line 1 BT-64 ) must be provided, if the Seller (BG-4) has a Seller tax representative party (BG-11)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CityName[boolean(normalize-space(.))]" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CityName[boolean(normalize-space(.))]">
          <xsl:attribute name="id">BR-RO-150</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-150]-Adresa poștala a reprezentantului fiscal al Vanzatorului (BG-12) trebuie sa contina Localitatea reprezentantului fiscal (BT-66), daca Vanzatorul (BG-4) are un reprezentant fiscal al Vanzatorului (BG-11).
							#Tax representative city (BT-66 ) must be provided, if the Seller (BG-4) has a Seller tax representative party (BG-11),</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(cac:Country/cbc:IdentificationCode) = 'RO' and normalize-space(cbc:CountrySubentity) = 'RO-B' and not(normalize-space(cbc:CityName) = $SECTOR-RO-CODES))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(cac:Country/cbc:IdentificationCode) = 'RO' and normalize-space(cbc:CountrySubentity) = 'RO-B' and not(normalize-space(cbc:CityName) = $SECTOR-RO-CODES))">
          <xsl:attribute name="id">BR-RO-160</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-160]-Daca Codul tarii Reprezentantului fiscal al Vanzatorului (BT-69) este RO si Subdiviziunea tarii Reprezentantului fiscal al Vanzatorului (BT-68) este RO-B (corespunzator Municipiului Bucuresti), atunci Localitatea reprezentantului fiscal al Vanzatorului (BT-66) trebuie sa fie codificata folosind lista de coduri SECTOR-RO.
				#If the Tax representative country code (BT-69) is RO and the Tax representative country subdivision (BT-68) is RO-B (corresponding to Bucharest Municipality), then the Tax representative city(BT-66) must be coded using the code list SECTOR-RO(SECTOR1, SECTOR2, SECTOR3, SECTOR4, SECTOR5, SECTOR6).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(cac:Country/cbc:IdentificationCode) = 'RO' and not(normalize-space(cbc:CountrySubentity) = $ISO-3166-RO-CODES))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(cac:Country/cbc:IdentificationCode) = 'RO' and not(normalize-space(cbc:CountrySubentity) = $ISO-3166-RO-CODES))">
          <xsl:attribute name="id">BR-RO-170</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-170]-Daca Codul tarii Reprezentantului fiscal al Vanzatorului (BT-69) este RO, atunci Subdiviziunea tarii Reprezentantului fiscal al Vanzatorului (BT-68) trebuie sa fie codificata folosind lista de coduri ISO 3166-2:RO (ex. RO-B pentru Municipiul Bucuresti, RO-AB pentru judetul Alba...).
				#If the Seller's tax representative country code (BT-69) is RO, then the Seller's tax representative country subdivision (BT-68) must be coded using the ISO 3166-2: RO code list (ex. RO-B for Bucharest, RO-AB for Alba County...).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:PaymentMeans" mode="M10" priority="1016">
    <svrl:fired-rule context="//cac:PaymentMeans" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:PayeeFinancialAccount/cbc:Name)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:PayeeFinancialAccount/cbc:Name)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L208</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Numele contului de plata  (BT-85), este 200.
				#The allowed maximum number of characters for the Payment account name (BT-85) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:CardAccount/cbc:HolderName)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:CardAccount/cbc:HolderName)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L209</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Numele detinatorului cardului de plata  (BT-88), este 200.
				#The allowed maximum number of characters for the Payment card holder name(BT-88) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:PaymentMeansCode/@name)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:PaymentMeansCode/@name)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1016</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Explicatii privind instrumentul de plata (BT-82) este 100.
				#The allowed maximum number of characters for the Payment means text (BT-82) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:PaymentID)) &lt;= 140" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:PaymentID)) &lt;= 140">
          <xsl:attribute name="id">BR-RO-L140</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L140]-Numarul maxim permis de caractere pentru Aviz de plata (BT-83) este 140.
				#The allowed maximum number of characters for the Remittance information (BT-83) is 140.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address | /ubl:CreditNote/cac:Delivery/cac:DeliveryLocation/cac:Address" mode="M10" priority="1015">
    <svrl:fired-rule context="/ubl:Invoice/cac:Delivery/cac:DeliveryLocation/cac:Address | /ubl:CreditNote/cac:Delivery/cac:DeliveryLocation/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:StreetName[boolean(normalize-space(.))]" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:StreetName[boolean(normalize-space(.))]">
          <xsl:attribute name="id">BR-RO-180</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-180"-Daca Adresa de livrare (BG-15) exista, trebuie furnizata Adresa de livrare — linia 1 (BT-75).
							#If the Delivery to (BG-15) exists, the Deliver to address line 1 (BT-75) must exists.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CityName[boolean(normalize-space(.))]" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CityName[boolean(normalize-space(.))]">
          <xsl:attribute name="id">BR-RO-201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-200]-Daca Adresa de livrare (BG-15) exista, trebuie furnizata Localitatea de livrare (BT-77).
							#If the Delivery to (BG-15) exists, the Deliver to city (BT-77) must exists.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(cac:Country/cbc:IdentificationCode) = 'RO' and normalize-space(cbc:CountrySubentity) = 'RO-B' and not(normalize-space(cbc:CityName) = $SECTOR-RO-CODES))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(cac:Country/cbc:IdentificationCode) = 'RO' and normalize-space(cbc:CountrySubentity) = 'RO-B' and not(normalize-space(cbc:CityName) = $SECTOR-RO-CODES))">
          <xsl:attribute name="id">BR-RO-202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-200]-Daca Codul tarii de livrare (BT-80) este RO si Subdiviziunea tarii de livrare (BT-79) este "RO-B" (corespunzator Municipiului Bucuresti), atunci Localitatea de livrare (BT-77) trebuie sa fie codificata folosind lista de coduri SECTOR-RO.
				#If the Delivery to country code (BT-80) is RO and the Delivery to country subdivision (BT-79) is "RO-B" (corresponding to Bucharest Municipality), then the Delivery to city(BT-77) must be coded using the code list SECTOR-RO(SECTOR1, SECTOR2, SECTOR3, SECTOR4, SECTOR5, SECTOR6).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CountrySubentity[boolean(normalize-space(.))]" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CountrySubentity[boolean(normalize-space(.))]">
          <xsl:attribute name="id">BR-RO-211</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-210"]-Daca Adresa de livrare (BG-15) exista, trebuie furnizata Subdiviziunea tarii de livrare (BT-79).
							#If the Delivery to (BG-15) exists, the Deliver to country subdivision (BT-79) must exists.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(cac:Country/cbc:IdentificationCode) = 'RO' and not(normalize-space(cbc:CountrySubentity) = $ISO-3166-RO-CODES))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(cac:Country/cbc:IdentificationCode) = 'RO' and not(normalize-space(cbc:CountrySubentity) = $ISO-3166-RO-CODES))">
          <xsl:attribute name="id">BR-RO-212</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-210]-Daca Codul tarii de livrare (BT-80) este "RO", atunci Subdiviziunea tarii de livrare (BT-79) trebuie sa fie codificata folosind lista de coduri ISO 3166-2:RO (ex. "RO-B" pentru Municipiul Bucuresti, "RO-AB" pentru judetul Alba...).
				#If Delivery country code (BT-80) is "RO", then Delivery country subdivision (BT-79) must be coded using the ISO 3166-2: RO code list (ex. "RO-B" for Bucharest, "RO-AB" for Alba County...).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoicePeriod/cbc:DescriptionCode" mode="M10" priority="1014">
    <svrl:fired-rule context="cac:InvoicePeriod/cbc:DescriptionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' 3 35 432 ', concat(' ', normalize-space(.), ' '))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(contains(normalize-space(.), ' ')) and contains(' 3 35 432 ', concat(' ', normalize-space(.), ' '))))">
          <xsl:attribute name="id">BR-RO-040</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-040]-Codul datei de exigibilitate a taxei pe valoarea adaugata (BT-8) trebuie sa fie unul dintre urmatoarele coduri din lista de coduri UNTDID 2005: 3 (Data emiterii facturii), 35 (Data reala a livrarii), 432 (Suma platita în acea zi).
							#Value added tax point date code MUST be coded using a restriction of UNTDID 2005 (only 3, 35 and 432).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M10" priority="1013">
    <svrl:fired-rule context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:Item/cbc:Name)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:Item/cbc:Name)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1024</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Numele articolului (BT-153) este 100.
							#The allowed maximum number of characters for the Item name (BT-153) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:AccountingCost)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:AccountingCost)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1021</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Referinta contabila a Cumparatorului din linia facturii (BT-133) este 100.
							#The allowed maximum number of characters for the Invoice line Buyer accounting reference (BT-133) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:Item/cbc:Description)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:Item/cbc:Description)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L212</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Descrierea articolului (BT-154) este 200.
							#The allowed maximum number of characters for the Item description (BT-154) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:Note)) &lt;= 300" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:Note)) &lt;= 300">
          <xsl:attribute name="id">BR-RO-L303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L300]-Numarul maxim permis de caractere pentru Nota liniei facturii (BT-127) este 300.
				#The allowed maximum number of characters for the Invoice line note (BT-127) is 300.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:Item/cac:AdditionalItemProperty" mode="M10" priority="1012">
    <svrl:fired-rule context="//cac:Item/cac:AdditionalItemProperty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(.) &lt;= 50" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(.) &lt;= 50">
          <xsl:attribute name="id">BR-RO-A052</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-A050]-O factura trebuie sa contina maximum 50 de aparitii ale grupului Atributele articolului (BG-32).
			#The allowed maximum number of occurences of Item attributes (BG-32) is 50.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:Name)) &lt;= 50" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:Name)) &lt;= 50">
          <xsl:attribute name="id">BR-RO-L0505</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L050]-Numarul maxim permis de caractere pentru Numele atributului articolului (BT-160) este 50.
			#The allowed maximum number of characters for the Item attribute name (BT-160) is 50.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:Value)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:Value)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1025</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Valoarea atributului articolului (BT-161) este 100.
			#The allowed maximum number of characters for the Item attribute value (BT-161) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /ubl:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" mode="M10" priority="1011">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | /ubl:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea deducerilor la nivelul documentului (BT-92) este 2.
							#The allowed maximum number of decimals for the Document level allowance amount(BT-92) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea de baza a deducerii la nivelul documentului (BT-93) este 2.
							#The allowed maximum number of decimals for the Document level allowance base amount(BT-93) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:AllowanceChargeReasonCode)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:AllowanceChargeReasonCode)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1017</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Motivul deducerii la nivelul documentului (BT-97) este 100.
				#The allowed maximum number of characters for the Document level allowance reason (BT-97) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /ubl:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" mode="M10" priority="1010">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | /ubl:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea taxelor suplimentare la nivelul documentului (BT-99) este 2.
							#The allowed maximum number of decimals for the Document level charge amount (BT-99) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea de baza a taxelor suplimentare la nivelul documentului (BT-100) este 2.
							#The allowed maximum number of decimals for the Document level charge base amount (BT-100) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:AllowanceChargeReasonCode)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:AllowanceChargeReasonCode)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1018</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Motivul taxei suplimentare la nivelul documentului (BT-104) este 100.
				#The allowed maximum number of characters for the Document level charge reason (BT-104) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:LegalMonetaryTotal" mode="M10" priority="1009">
    <svrl:fired-rule context="cac:LegalMonetaryTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Suma valorilor nete ale liniilor facturii (BT-106) este 2.
							#The allowed maximum number of decimals for the Sum of Invoice line net amount (BT-106) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:AllowanceTotalAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Suma deducerilor la nivelul documentului (BT-107) este 2.
							#The allowed maximum number of decimals for the Sum of allowances on document level(BT-107) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:ChargeTotalAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:ChargeTotalAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Suma taxelor suplimentare la nivelul documentului (BT-108) este 2.
							#The allowed maximum number of decimals for the Sum of charges on document level(BT-108) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:TaxExclusiveAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-12</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea totala a facturii fara TVA (BT-109) este 2.
							#The allowed maximum number of decimals for the Invoice total amount without VAT (BT-109) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:TaxInclusiveAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-14</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea totala a facturii cu TVA (BT-112) este 2.
							#The allowed maximum number of decimals for the Invoice total amount with VAT (BT-112) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:PrepaidAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-16</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Suma platita (BT-113) este 2.
							#The allowed maximum number of decimals for the Paid amount(BT-113) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:PayableRoundingAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:PayableRoundingAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-17</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoare de rotunjire (BT-114) este 2.
							#The allowed maximum number of decimals for the Rounding amount(BT-114) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:PayableAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:PayableAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-18</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Suma de plata (BT-115) este 2.
							#The allowed maximum number of decimals for the Amount due for payment (BT-115) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | cac:CreditNote" mode="M10" priority="1008">
    <svrl:fired-rule context="/ubl:Invoice | cac:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:DocumentCurrencyCode]))">
          <xsl:attribute name="id">BR-DEC-RO-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea totala a TVA a facturii (BT-110) este 2.
							#The allowed maximum number of decimals for the Invoice total VAT amount (BT-110) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode]))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode] and (string-length(substring-after(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode],'.'))&lt;=2)) or (not(//cac:TaxTotal/cbc:TaxAmount[@currencyID = cbc:TaxCurrencyCode]))">
          <xsl:attribute name="id">BR-DEC-RO-15</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea TVA totala a facturii în moneda de contabilizare (BT-111) este 2.
							#The allowed maximum number of decimals for the Invoice total VAT amount in accounting currency (BT-111) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxTotal/cac:TaxSubtotal" mode="M10" priority="1007">
    <svrl:fired-rule context="cac:TaxTotal/cac:TaxSubtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:TaxableAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-1009</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Baza de calcul pentru categoria de TVA (BT-116) este 2.
							#The allowed maximum number of decimals for the VAT category taxable amount (BT-116) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:TaxAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-1010</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea TVA pentru fiecare categorie de TVA (BT-117) este 2.
							#The allowed maximum number of decimals for the VAT category tax amount (BT-117) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine | cac:CreditNoteLine" mode="M10" priority="1006">
    <svrl:fired-rule context="cac:InvoiceLine | cac:CreditNoteLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:LineExtensionAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-23</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea neta a liniei facturii (BT-131) este 2.
							#The allowed maximum number of decimals for the Invoice line net amount (BT-131) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" mode="M10" priority="1005">
    <svrl:fired-rule context="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = false()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-24</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea deducerii la linia facturii (BT-136) este 2.
							#The allowed maximum number of decimals for the Invoice line allowance amount (BT-136) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-25</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea de baza a deducerii la linia facturii (BT-137) este 2.
							#The allowed maximum number of decimals for the Invoice line allowance base amount (BT-137) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:AllowanceChargeReason)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:AllowanceChargeReason)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1022</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Motivul deducerii la linia facturii (BT-139) este 100.
				#The allowed maximum number of characters for the Invoice line allowance reason (BT-139) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" mode="M10" priority="1004">
    <svrl:fired-rule context="//cac:InvoiceLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()] | //cac:CreditNoteLine/cac:AllowanceCharge[cbc:ChargeIndicator = true()]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:Amount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:Amount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-27</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea taxei suplimentare la linia facturii (BT-141) este 2.
				#The allowed maximum number of decimals for the Invoice line charge amount (BT-141) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(substring-after(cbc:BaseAmount,'.'))&lt;=2">
          <xsl:attribute name="id">BR-DEC-RO-28</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
				[BR-RO-Z2]-Numarul maxim permis de zecimale pentru Valoarea de baza a taxei suplimentare la linia facturii (BT-142) este 2.
				#The allowed maximum number of decimals for the Invoice line charge base amount (BT-142) is 2.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:AllowanceChargeReason)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:AllowanceChargeReason)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1023</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Motivul taxei suplimentare la linia facturii (BT-144) este 100.
				#The allowed maximum number of characters for the Invoice line charge reason (BT-144) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:Note" mode="M10" priority="1003">
    <svrl:fired-rule context="cbc:Note" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(.)) &lt;= 300" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(.)) &lt;= 300">
          <xsl:attribute name="id">BR-RO-L302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L300]-Numarul maxim permis de caractere pentru Comentariu în factura (BT-22) este 300.
				#The allowed maximum number of characters for the Invoice note (BT-22) is 300.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:AdditionalDocumentReference" mode="M10" priority="1002">
    <svrl:fired-rule context="//cac:AdditionalDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(.) &lt;= 50" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(.) &lt;= 50">
          <xsl:attribute name="id">BR-RO-A051</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-A050]-O factura trebuie sa contina maximum 50 de aparitii ale grupului Documente justificative suplimentare (BG-24).
			#The allowed maximum number of occurences of Additional supporting documents (BG-24) is 50</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:ID)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:ID)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L0308</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Identificatorul obiectului facturat (BT-18) si Referinta documentului justificativ (BT-122) este 200.
			#The allowed maximum number of characters for the Invoiced object identifier (BT-18) and the Supporting document reference(BT-122)is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:DocumentDescription)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:DocumentDescription)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1020</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Descrierea documentului justificativ (BT-123) este 100.
			#The allowed maximum number of characters for the Supporting document description (BT-123) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:Attachment/cac:ExternalReference/cbc:URI)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:Attachment/cac:ExternalReference/cbc:URI)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L210</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Localizarea documentului extern  (BT-124), este 200.
			#The allowed maximum number of characters for the External document location (BT-124) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@filename)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L211</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Numele fisierului documentului atasat  (BT-125-2), este 200.
			#The allowed maximum number of characters for the Attached document Filename (BT-125-2) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:BillingReference" mode="M10" priority="1001">
    <svrl:fired-rule context="//cac:BillingReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:InvoiceDocumentReference) &lt;= 500" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:InvoiceDocumentReference) &lt;= 500">
          <xsl:attribute name="id">BR-RO-A500</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-A500]-O factura trebuie sa contina maximum 500 de aparitii ale grupului Referinta la o factura anterioara (BG-3).
			#The allowed maximum number of occurences of Preceding invoice reference (BG-3) is 500.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:InvoiceDocumentReference/cbc:ID)) &lt;= 200" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:InvoiceDocumentReference/cbc:ID)) &lt;= 200">
          <xsl:attribute name="id">BR-RO-L156</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L200]-Numarul maxim permis de caractere pentru Referinta la o factura anterioara (BT-25) este 200.
			#The allowed maximum number of characters for the Preceding Invoice number (BT-25) is 200.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal | /ubl:CreditNote/cac:TaxTotal/cac:TaxSubtotal" mode="M10" priority="1000">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal | /ubl:CreditNote/cac:TaxTotal/cac:TaxSubtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cbc:TaxExemptionReason)) &lt;= 100" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cbc:TaxExemptionReason)) &lt;= 100">
          <xsl:attribute name="id">BR-RO-L1019</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[BR-RO-L100]-Numarul maxim permis de caractere pentru Motivul scutirii de TVA (BT-120) este 100.
							#The allowed maximum number of characters for the VAT exemption reason text (BT-120) is 100.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>
</xsl:stylesheet>
