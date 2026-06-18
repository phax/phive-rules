<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2" xmlns:saxon="http://saxon.sf.net/" xmlns:sbt="http://mfin.gov.rs/srbdt/srbdtext" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:udt="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
    <svrl:schematron-output schemaVersion="" title="Serbian SRBDT CIUS and Extension rules bound to UBL">
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
      <svrl:ns-prefix-in-attribute-values prefix="sbt" uri="http://mfin.gov.rs/srbdt/srbdtext" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">UBL-srbdt</xsl:attribute>
        <xsl:attribute name="name">UBL-srbdt</xsl:attribute>
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
        <xsl:attribute name="id">pdvcat-r</xsl:attribute>
        <xsl:attribute name="name">pdvcat-r</xsl:attribute>
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
        <xsl:attribute name="id">pdvcat-oe</xsl:attribute>
        <xsl:attribute name="name">pdvcat-oe</xsl:attribute>
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
        <xsl:attribute name="id">pdvcat-ss</xsl:attribute>
        <xsl:attribute name="name">pdvcat-ss</xsl:attribute>
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
        <xsl:attribute name="id">pdvcat-n</xsl:attribute>
        <xsl:attribute name="name">pdvcat-n</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M14" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Serbian SRBDT CIUS and Extension rules bound to UBL</svrl:text>

<!--PATTERN UBL-srbdt-->


	<!--RULE -->
<xsl:template match="cbc:CustomizationID" mode="M10" priority="1034">
    <svrl:fired-rule context="cbc:CustomizationID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="starts-with(normalize-space(.), 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022')" />
      <xsl:otherwise>
        <svrl:failed-assert test="starts-with(normalize-space(.), 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022')">
          <xsl:attribute name="id">RSR-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-01]-Identifikator specifikacije (BT-24) treba da počinje sa 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="sbt:SrbDtExt" mode="M10" priority="1033">
    <svrl:fired-rule context="sbt:SrbDtExt" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="starts-with(normalize-space(.), 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022#conformant#urn:mfin.gov.rs:srbdtext:2022')" />
      <xsl:otherwise>
        <svrl:failed-assert test="starts-with(normalize-space(.), 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022#conformant#urn:mfin.gov.rs:srbdtext:2022')">
          <xsl:attribute name="id">RSR-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-02]-Identifikator specifikacije (BT-24) fakture koja koristi ekstenzije treba da počinje sa 'urn:cen.eu:en16931:2017#compliant#urn:mfin.gov.rs:srbdt:2022#conformant#urn:mfin.gov.rs:srbdtext:2022'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" mode="M10" priority="1032">
    <svrl:fired-rule context="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(self::cbc:InvoiceTypeCode and                  ( (not(contains(normalize-space(.), ' ')) and                     contains(' 380 383 386 ',                         concat(' ', normalize-space(.), ' '))))) or              (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and                      contains(' 381 ', concat(' ', normalize-space(.), ' ')))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(self::cbc:InvoiceTypeCode and ( (not(contains(normalize-space(.), ' ')) and contains(' 380 383 386 ', concat(' ', normalize-space(.), ' '))))) or (self::cbc:CreditNoteTypeCode and ((not(contains(normalize-space(.), ' ')) and contains(' 381 ', concat(' ', normalize-space(.), ' ')))))">
          <xsl:attribute name="id">RSR-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-03]-Šifra vrste fakture (BT-3) treba da bude jedna od: 380, 381, 383 ili 386</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M10" priority="1031">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(cbc:TaxPointDate))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(cbc:TaxPointDate))">
          <xsl:attribute name="id">RSR-04</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-04]-Faktura ne treba da sadrži element datum poreske obaveze (BT-7), umesto toga treba koristiti šifru datuma poreske obaveze (BT-8)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(/ubl:Invoice/cac:InvoicePeriod/cbc:DescriptionCode | /cn:CreditNote/cac:InvoicePeriod/cbc:DescriptionCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(/ubl:Invoice/cac:InvoicePeriod/cbc:DescriptionCode | /cn:CreditNote/cac:InvoicePeriod/cbc:DescriptionCode)">
          <xsl:attribute name="id">RSR-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-05]-Faktura treba da sadrži šifru datuma poreske obaveze (BT-8)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoicePeriod/cbc:DescriptionCode | /cn:CreditNote/cac:InvoicePeriod/cbc:DescriptionCode" mode="M10" priority="1030">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoicePeriod/cbc:DescriptionCode | /cn:CreditNote/cac:InvoicePeriod/cbc:DescriptionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(not(contains(normalize-space(.), ' ')) and                     contains(' 35 432 3 ', concat(' ', normalize-space(.), ' ')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(not(contains(normalize-space(.), ' ')) and contains(' 35 432 3 ', concat(' ', normalize-space(.), ' ')))">
          <xsl:attribute name="id">RSR-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-06]-Šifra datuma poreske obaveze (BT-8) treba da bude jedna od: 35 (prema datumu prometa), 432 (prema datumu plaćanja) ili 3 (prema datumu izdavanja fakture)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:BillingReference" mode="M10" priority="1029">
    <svrl:fired-rule context="cac:BillingReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:InvoiceDocumentReference/cbc:IssueDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:InvoiceDocumentReference/cbc:IssueDate)">
          <xsl:attribute name="id">RSR-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-07]-Referenca na prethodnu fakturu (BG-3) treba da sadrži datum izdavanja prethodne fakture (BT-26).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M10" priority="1028">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not (cac:InvoicePeriod/cbc:DescriptionCode = '432') or exists(/ubl:Invoice/cbc:DueDate | /cn:CreditNote/cac:PaymentMeans/cbc:PaymentDueDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not (cac:InvoicePeriod/cbc:DescriptionCode = '432') or exists(/ubl:Invoice/cbc:DueDate | /cn:CreditNote/cac:PaymentMeans/cbc:PaymentDueDate)">
          <xsl:attribute name="id">RSR-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-08]-Kada šifra datuma poreske obaveze (BT-8) određuje da poreska obaveza nastaje prema datumu plaćanja (šifra 432) tada treba da je naveden datum dospeća plaćanja (BT-9)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) = 'VAT']/cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) = 'VAT']/cbc:CompanyID)">
          <xsl:attribute name="id">RSR-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-09]-Faktura treba da sadrži PIB prodavca (BT-31)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) != 'VAT']/cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) != 'VAT']/cbc:CompanyID)">
          <xsl:attribute name="id">RSR-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-10]-Faktura treba da sadrži identifikator registracije poreza na strani prodavca (BT-32)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) = 'VAT']/cbc:CompanyID" mode="M10" priority="1027">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) = 'VAT']/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(matches(normalize-space(upper-case(.)),'^RS[0-9]+$')) and               (contains(' 9 13 ', concat(' ', string-length(substring(normalize-space(.),3)),' ')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(matches(normalize-space(upper-case(.)),'^RS[0-9]+$')) and (contains(' 9 13 ', concat(' ', string-length(substring(normalize-space(.),3)),' ')))">
          <xsl:attribute name="id">RSR-11</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-11]-PIB prodavca (BT-31) treba da ima prefiks RS i nakon toga 9 ili 13 cifara</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme[normalize-space(upper-case(cbc:ID)) != 'VAT']" mode="M10" priority="1026">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme[normalize-space(upper-case(cbc:ID)) != 'VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="upper-case(normalize-space(cbc:ID)) = 'RS-VAT-STATUS'" />
      <xsl:otherwise>
        <svrl:failed-assert test="upper-case(normalize-space(cbc:ID)) = 'RS-VAT-STATUS'">
          <xsl:attribute name="id">RSR-12</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-12]-Identifikatora registracije poreza na strani prodavca (BT-32) u UBL formatu treba da ima PartyTaxScheme ID sa vrednošću RS-VAT-STATUS</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M10" priority="1025">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingSupplierParty/cac:Party/cbc:EndpointID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingSupplierParty/cac:Party/cbc:EndpointID)">
          <xsl:attribute name="id">RSR-13</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-13]-Faktura treba da sadrži elektronsku adresu prodavca (BT-34)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" mode="M10" priority="1024">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(@schemeID) = '9948'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(@schemeID) = '9948'">
          <xsl:attribute name="id">RSR-14</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-14]-Elektronska adresa prodavca (BT-34) treba da ima identifikator šeme '9948'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" mode="M10" priority="1023">
    <svrl:fired-rule context="cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="concat('RS',normalize-space(.)) =               normalize-space(upper-case(../cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) = 'VAT']/cbc:CompanyID))" />
      <xsl:otherwise>
        <svrl:failed-assert test="concat('RS',normalize-space(.)) = normalize-space(upper-case(../cac:PartyTaxScheme[normalize-space(upper-case(cac:TaxScheme/cbc:ID)) = 'VAT']/cbc:CompanyID))">
          <xsl:attribute name="id">RSR-15</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-15]-Elektronska adresa prodavca (BT-34) treba da sadrži PIB prodavca (BT-31) bez prefiksa 'RS'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M10" priority="1022">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName)">
          <xsl:attribute name="id">RSR-16</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-16]-Faktura treba da sadrži mesto prodavca (BT-37)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M10" priority="1021">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID)">
          <xsl:attribute name="id">RSR-17</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-17]-Faktura treba da sadrži matični broj kupca (BT-47)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" mode="M10" priority="1020">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(exists(@schemeID))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(exists(@schemeID))">
          <xsl:attribute name="id">RSR-18</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-18]-Matični broj kupca (BT-47) ne treba da ima identifikator šeme</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(matches(normalize-space(.),'^[0-9]+$')) and               (contains(' 8 13 ', concat(' ', string-length(normalize-space(.)),' ')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(matches(normalize-space(.),'^[0-9]+$')) and (contains(' 8 13 ', concat(' ', string-length(normalize-space(.)),' ')))">
          <xsl:attribute name="id">RSR-19</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-19]-Matični broj kupca (BT-47) treba da ima 8 ili 13 cifara</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M10" priority="1019">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID)">
          <xsl:attribute name="id">RSR-20</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-20]-Faktura treba da sadrži PIB kupca (BT-48)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" mode="M10" priority="1018">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(matches(normalize-space(upper-case(.)),'^RS[0-9]+$')) and               (contains(' 9 13 ', concat(' ', string-length(substring(normalize-space(.),3)),' ')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(matches(normalize-space(upper-case(.)),'^RS[0-9]+$')) and (contains(' 9 13 ', concat(' ', string-length(substring(normalize-space(.),3)),' ')))">
          <xsl:attribute name="id">RSR-21</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-21]-PIB kupca (BT-48) treba da ima prefiks RS i nakon toga 9 ili 13 cifara</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M10" priority="1017">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingCustomerParty/cac:Party/cbc:EndpointID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingCustomerParty/cac:Party/cbc:EndpointID)">
          <xsl:attribute name="id">RSR-22</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-22]-Faktura treba da sadrži elektronsku adresu kupca (BT-49)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" mode="M10" priority="1016">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(@schemeID) = '9948'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(@schemeID) = '9948'">
          <xsl:attribute name="id">RSR-23</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-23]-Elektronska adresa kupca (BT-49) treba da ima identifikator šeme '9948'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" mode="M10" priority="1015">
    <svrl:fired-rule context="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="concat('RS',normalize-space(.)) =               normalize-space(upper-case(../cac:PartyTaxScheme/cbc:CompanyID))" />
      <xsl:otherwise>
        <svrl:failed-assert test="concat('RS',normalize-space(.)) = normalize-space(upper-case(../cac:PartyTaxScheme/cbc:CompanyID))">
          <xsl:attribute name="id">RSR-24</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-24]-Elektronska adresa kupca (BT-49) treba da sadrži PIB kupca (BT-48) bez prefiksa 'RS'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M10" priority="1014">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName)">
          <xsl:attribute name="id">RSR-25</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-25]-Faktura treba da sadrži mesto kupca (BT-52)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M10" priority="1013">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone)">
          <xsl:attribute name="id">RSR-26</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-26]-Faktura treba da sadrži poštanski broj kupca (BT-53)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty | /cn:CreditNote/cac:PayeeParty" mode="M10" priority="1012">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty | /cn:CreditNote/cac:PayeeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyLegalEntity/cbc:CompanyID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyLegalEntity/cbc:CompanyID) = 1">
          <xsl:attribute name="id">RSR-27</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-27]-Primalac plaćanja (BG-10) treba da ima tačno jedan matični broj primaoca plaćanja (BT-61)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M10" priority="1011">
    <svrl:fired-rule context="cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(matches(normalize-space(.),'^[0-9]+$')) and               (contains(' 8 13 ', concat(' ', string-length(normalize-space(.)),' ')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(matches(normalize-space(.),'^[0-9]+$')) and (contains(' 8 13 ', concat(' ', string-length(normalize-space(.)),' ')))">
          <xsl:attribute name="id">RSR-28</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-28]-Matični broj primaoca plaćanja (BT-61) treba da ima 8 ili 13 cifara</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty | /cn:CreditNote/cac:TaxRepresentativeParty" mode="M10" priority="1010">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty | /cn:CreditNote/cac:TaxRepresentativeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:PartyTaxScheme/cbc:CompanyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:PartyTaxScheme/cbc:CompanyID)">
          <xsl:attribute name="id">RSR-29</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-29]-Poreski punomoćnik prodavca (BG-11) treba da sadrži PIB poreskog punomoćnika (BT-63)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID" mode="M10" priority="1009">
    <svrl:fired-rule context="cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(matches(normalize-space(upper-case(.)),'^RS[0-9]+$')) and               (contains(' 9 13 ', concat(' ', string-length(substring(normalize-space(.),3)),' ')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(matches(normalize-space(upper-case(.)),'^RS[0-9]+$')) and (contains(' 9 13 ', concat(' ', string-length(substring(normalize-space(.),3)),' ')))">
          <xsl:attribute name="id">RSR-30</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-30]-PIB poreskog punomoćnika prodavca (BT-63) treba da ima prefiks RS i nakon toga 9 ili 13 cifara</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty | /cn:CreditNote/cac:TaxRepresentativeParty" mode="M10" priority="1008">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty | /cn:CreditNote/cac:TaxRepresentativeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:PostalAddress/cbc:CityName)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:PostalAddress/cbc:CityName)">
          <xsl:attribute name="id">RSR-31</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-31]-Poreski punomoćnik prodavca (BG-11) treba da sadrži mesto poreskog punomoćnika (BT-66)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty | /cn:CreditNote/cac:TaxRepresentativeParty" mode="M10" priority="1007">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty | /cn:CreditNote/cac:TaxRepresentativeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:PostalAddress/cbc:PostalZone)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:PostalAddress/cbc:PostalZone)">
          <xsl:attribute name="id">RSR-32</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-32]-Poreski punomoćnik prodavca (BG-11) treba da sadrži poštanski broj poreskog punomoćnika (BT-67)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M10" priority="1006">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:InvoicePeriod/cbc:DescriptionCode = '35') or exists(cac:Delivery/cbc:ActualDeliveryDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:InvoicePeriod/cbc:DescriptionCode = '35') or exists(cac:Delivery/cbc:ActualDeliveryDate)">
          <xsl:attribute name="id">RSR-33</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-33]-Kada šifra datuma poreske obaveze (BT-8) određuje da poreska obaveza nastaje prema datumu prometa (šifra 35) tada treba da je naveden datum prometa (BT-72)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:ID | /cn:CreditNote/cac:AllowanceCharge/cac:TaxCategory/cbc:ID" mode="M10" priority="1005">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:ID | /cn:CreditNote/cac:AllowanceCharge/cac:TaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">RSR-34</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-34]-Šifra kategorije PDV-a za popust/trošak na nivou dokumneta (BT-95/BT-102) treba da bude jedna od: S, AE, Z, E, O, R, OE, SS ili N</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID | /cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID" mode="M10" priority="1004">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID | /cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">RSR-35</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-35]-Šifra kategorije PDV-a (BT-118) treba da bude jedna od: S, AE, Z, E, O, R, OE, SS ili N</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:ClassifiedTaxCategory/cbc:ID" mode="M10" priority="1003">
    <svrl:fired-rule context="cac:ClassifiedTaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">RSR-36</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSR-36]-Šifra kategorije PDV-a za stavku (BT-151) treba da bude jedna od: S, AE, Z, E, O, R, OE, SS ili N</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="sbt:SrbDtExt/sbt:InvoicedPrepaymentAmmount/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID" mode="M10" priority="1002">
    <svrl:fired-rule context="sbt:SrbDtExt/sbt:InvoicedPrepaymentAmmount/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">RSE-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSE-01]-Šifra kategorije PDV-a na avansu (BT-Е4) treba da bude jedna od: S, AE, Z, E, O, R, OE, SS ili N</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="sbt:SrbDtExt/sbt:ReducedTotals/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID" mode="M10" priority="1001">
    <svrl:fired-rule context="sbt:SrbDtExt/sbt:ReducedTotals/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(.),' ')) and contains( ' S AE Z E O R OE SS N ',concat(' ',normalize-space(.),' ') ) ) )">
          <xsl:attribute name="id">RSE-02</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSE-02]-Šifra kategorije PDV-a na umanjenom iznosu (BT-Е8) treba da bude jedna od: S, AE, Z, E, O, R, OE, SS ili N</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="sbt:SrbDtExt/sbt:ReducedTotals" mode="M10" priority="1000">
    <svrl:fired-rule context="sbt:SrbDtExt/sbt:ReducedTotals" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(/ubl:Invoice) and (xs:decimal(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount) =                xs:decimal(/ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount) - xs:decimal(/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PrepaidAmount))) or             (exists(/cn:CreditNote) and (xs:decimal(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount) =                xs:decimal(/cn:CreditNote/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount) - xs:decimal(/cn:CreditNote/cac:LegalMonetaryTotal/cbc:PrepaidAmount)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(/ubl:Invoice) and (xs:decimal(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount) = xs:decimal(/ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount) - xs:decimal(/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PrepaidAmount))) or (exists(/cn:CreditNote) and (xs:decimal(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount) = xs:decimal(/cn:CreditNote/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount) - xs:decimal(/cn:CreditNote/cac:LegalMonetaryTotal/cbc:PrepaidAmount)))">
          <xsl:attribute name="id">RSE-03</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSE-03]-Umanjen ukupan iznos bez PDV-a (BT-Е10) treba da bude jednak razlici ukupnog iznosa sa PDV-om (BT-112) i plaćenog iznosa (BT-113)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M10" priority="-1" />
  <xsl:template match="@*|node()" mode="M10" priority="-2">
    <xsl:apply-templates mode="M10" select="*" />
  </xsl:template>

<!--PATTERN pdvcat-r-->


	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M11" priority="1004">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'R']) or                  exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'R'])) and                 (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'R']) = 1)) or                  (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'R']) and                    not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'R']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'R']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'R'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'R']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'R']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'R']))">
          <xsl:attribute name="id">RSK-X-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-R-01]-Faktura koja sadrži stavku fakture (BG-25), popust na nivou dokumenta (BG-20) ili troškove na nivou dokumenta (BG-21) sa šifrom PDV kategorije (BT-151, BT-95 odnosno BT-102) jednakom 'R' treba da sadrži tačno jedan poreski međuzbir (BG-23) sa šifrom kategorije PDV-a (BT-118) jednakom 'R'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'R'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] |                    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'R'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M11" priority="1003">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'R'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] |                    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'R'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">RSK-X-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-R-05]-Stavka fakture (BG-25) sa šifrom PDV kategorije (BT-151) jednakom 'R', treba da ima stopu PDV-a (BT-152) jednaku nuli.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='R'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M11" priority="1002">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='R'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">RSK-X-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-R-06]-U popustu na nivou dokumenta (BG-20) za šifru kategorije PDV-a (BT-95) jednaku 'R', stopa PDV-a (BT-96) treba da je nula.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='R'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M11" priority="1001">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='R'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">RSK-X-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-R-07]-U trošku na nivou dokumenta (BG-21) sa kategorijom PDV-a (BT-102) jednakom 'R', stopa PDV-a (BT-103) treba da je nula.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'R'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M11" priority="1000">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'R'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (               sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='R']/xs:decimal(cbc:LineExtensionAmount)) +                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) -                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or              (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (               sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) +                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) -                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = ( sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='R']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = ( sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">RSK-X-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-R-08]-U poreskom međuzbiru (BG-23) sa šifrom kategorije PDV-a (BT-118) jednakom 'R', iznos osnovice (BT-116) treba da je jednak zbiru neto iznosa stavki (BT-131) umanjenog za zbir popusta na nivou dokumenta (BT-92) i uvećanog za zbir troškova na nivou dokumenta (BT-99) gde je šifra kategorije PDV-a (BT-151, BT-95, BT-102) jednaka 'R'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">RSK-X-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-R-09]-Iznos poreza za kategoriju PDV-a 'R' (BT-117, BT-118) u poreskom međuzbiru (BG-23) treba da je jednak nuli.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">RSK-X-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-R-10]-Poreski međuzbir (BG-23) sa kategorijom PDV-a (BT-118) jednakom 'R' treba da sadrži šifru ili tekst osnova izuzeće od PDV (BT-121, BT-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M11" priority="-1" />
  <xsl:template match="@*|node()" mode="M11" priority="-2">
    <xsl:apply-templates mode="M11" select="*" />
  </xsl:template>

<!--PATTERN pdvcat-oe-->


	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M12" priority="1004">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'OE']) or                  exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'OE'])) and                 (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'OE']) = 1)) or                  (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'OE']) and                    not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'OE']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'OE']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'OE'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'OE']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'OE']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'OE']))">
          <xsl:attribute name="id">RSK-X-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-OE-01]-Faktura koja sadrži stavku fakture (BG-25), popust na nivou dokumenta (BG-20) ili troškove na nivou dokumenta (BG-21) sa šifrom PDV kategorije (BT-151, BT-95 odnosno BT-102) jednakom 'OE' treba da sadrži tačno jedan poreski međuzbir (BG-23) sa šifrom kategorije PDV-a (BT-118) jednakom 'OE'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'OE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] |                    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'OE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1003">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'OE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] |                    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'OE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">RSK-X-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-OE-05]-Stavka fakture (BG-25) sa šifrom PDV kategorije (BT-151) jednakom 'OE', treba da ima stopu PDV-a (BT-152) jednaku nuli.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='OE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1002">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='OE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">RSK-X-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-OE-06]-U popustu na nivou dokumenta (BG-20) za šifru kategorije PDV-a (BT-95) jednaku 'OE', stopa PDV-a (BT-96) treba da je nula.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='OE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1001">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='OE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">RSK-X-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-OE-07]-U trošku na nivou dokumenta (BG-21) sa kategorijom PDV-a (BT-102) jednakom 'OE', stopa PDV-a (BT-103) treba da je nula.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'OE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M12" priority="1000">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'OE'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (               sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='OE']/xs:decimal(cbc:LineExtensionAmount)) +                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) -                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or              (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (               sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) +                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) -                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = ( sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='OE']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = ( sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">RSK-X-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-OE-08]-U poreskom međuzbiru (BG-23) sa šifrom kategorije PDV-a (BT-118) jednakom 'OE', iznos osnovice (BT-116) treba da je jednak zbiru neto iznosa stavki (BT-131) umanjenog za zbir popusta na nivou dokumenta (BT-92) i uvećanog za zbir troškova na nivou dokumenta (BT-99) gde je šifra kategorije PDV-a (BT-151, BT-95, BT-102) jednaka 'OE'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">RSK-X-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-OE-09]-Iznos poreza za kategoriju PDV-a 'OE' (BT-117, BT-118) u poreskom međuzbiru (BG-23) treba da je jednak nuli.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">RSK-X-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-OE-10]-Poreski međuzbir (BG-23) sa kategorijom PDV-a (BT-118) jednakom 'OE' treba da sadrži šifru ili tekst osnova izuzeće od PDV (BT-121, BT-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M12" priority="-1" />
  <xsl:template match="@*|node()" mode="M12" priority="-2">
    <xsl:apply-templates mode="M12" select="*" />
  </xsl:template>

<!--PATTERN pdvcat-ss-->


	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M13" priority="1004">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'SS']) or                  exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'SS'])) and                 (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'SS']) = 1)) or                  (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'SS']) and                    not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'SS']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'SS']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'SS'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'SS']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'SS']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'SS']))">
          <xsl:attribute name="id">RSK-X-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-SS-01]-Faktura koja sadrži stavku fakture (BG-25), popust na nivou dokumenta (BG-20) ili troškove na nivou dokumenta (BG-21) sa šifrom PDV kategorije (BT-151, BT-95 odnosno BT-102) jednakom 'SS' treba da sadrži tačno jedan poreski međuzbir (BG-23) sa šifrom kategorije PDV-a (BT-118) jednakom 'SS'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'SS'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] |                    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'SS'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M13" priority="1003">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'SS'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] |                    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'SS'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">RSK-X-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-SS-05]-Stavka fakture (BG-25) sa šifrom PDV kategorije (BT-151) jednakom 'SS', treba da ima stopu PDV-a (BT-152) jednaku nuli.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='SS'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M13" priority="1002">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='SS'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">RSK-X-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-SS-06]-U popustu na nivou dokumenta (BG-20) za šifru kategorije PDV-a (BT-95) jednaku 'SS', stopa PDV-a (BT-96) treba da je nula.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='SS'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M13" priority="1001">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='SS'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">RSK-X-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-SS-07]-U trošku na nivou dokumenta (BG-21) sa kategorijom PDV-a (BT-102) jednakom 'SS', stopa PDV-a (BT-103) treba da je nula.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'SS'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M13" priority="1000">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'SS'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (               sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='SS']/xs:decimal(cbc:LineExtensionAmount)) +                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) -                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or              (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (               sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) +                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) -                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = ( sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='SS']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = ( sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">RSK-X-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-SS-08]-U poreskom međuzbiru (BG-23) sa šifrom kategorije PDV-a (BT-118) jednakom 'SS', iznos osnovice (BT-116) treba da je jednak zbiru neto iznosa stavki (BT-131) umanjenog za zbir popusta na nivou dokumenta (BT-92) i uvećanog za zbir troškova na nivou dokumenta (BT-99) gde je šifra kategorije PDV-a (BT-151, BT-95, BT-102) jednaka 'SS'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">RSK-X-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-SS-09]-Iznos poreza za kategoriju PDV-a 'SS' (BT-117, BT-118) u poreskom međuzbiru (BG-23) treba da je jednak nuli.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">RSK-X-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-SS-10]-Poreski međuzbir (BG-23) sa kategorijom PDV-a (BT-118) jednakom 'SS' treba da sadrži šifru ili tekst osnova izuzeće od PDV (BT-121, BT-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M13" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M13" priority="-1" />
  <xsl:template match="@*|node()" mode="M13" priority="-2">
    <xsl:apply-templates mode="M13" select="*" />
  </xsl:template>

<!--PATTERN pdvcat-n-->


	<!--RULE -->
<xsl:template match="/ubl:Invoice | /cn:CreditNote" mode="M14" priority="1004">
    <svrl:fired-rule context="/ubl:Invoice | /cn:CreditNote" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'N']) or                  exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'N'])) and                 (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'N']) = 1)) or                  (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'N']) and                    not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'N']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((exists(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'N']) or exists(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'N'])) and (count(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'N']) = 1)) or (not(//cac:TaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'N']) and not(//cac:ClassifiedTaxCategory[cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']/cbc:ID[normalize-space(.) = 'N']))">
          <xsl:attribute name="id">RSK-X-01</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-N-01]-Faktura koja sadrži stavku fakture (BG-25), popust na nivou dokumenta (BG-20) ili troškove na nivou dokumenta (BG-21) sa šifrom PDV kategorije (BT-151, BT-95 odnosno BT-102) jednakom 'N' treba da sadrži tačno jedan poreski međuzbir (BG-23) sa šifrom kategorije PDV-a (BT-118) jednakom 'N'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'N'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] |                    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'N'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M14" priority="1003">
    <svrl:fired-rule context="cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'N'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT'] |                    cac:CreditNoteLine/cac:Item/cac:ClassifiedTaxCategory[normalize-space(cbc:ID) = 'N'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">RSK-X-05</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-N-05]-Stavka fakture (BG-25) sa šifrom PDV kategorije (BT-151) jednakom 'N', treba da ima stopu PDV-a (BT-152) jednaku nuli.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='N'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M14" priority="1002">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=false()]/cac:TaxCategory[normalize-space(cbc:ID)='N'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">RSK-X-06</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-N-06]-U popustu na nivou dokumenta (BG-20) za šifru kategorije PDV-a (BT-95) jednaku 'N', stopa PDV-a (BT-96) treba da je nula.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='N'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M14" priority="1001">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator=true()]/cac:TaxCategory[normalize-space(cbc:ID)='N'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(xs:decimal(cbc:Percent) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(xs:decimal(cbc:Percent) = 0)">
          <xsl:attribute name="id">RSK-X-07</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-N-07]-U trošku na nivou dokumenta (BG-21) sa kategorijom PDV-a (BT-102) jednakom 'N', stopa PDV-a (BT-103) treba da je nula.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'N'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" mode="M14" priority="1000">
    <svrl:fired-rule context="/*/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[normalize-space(cbc:ID) = 'N'][cac:TaxScheme/normalize-space(upper-case(cbc:ID))='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = (               sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='N']/xs:decimal(cbc:LineExtensionAmount)) +                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) -                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or              (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = (               sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) +                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) -                sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(exists(//cac:InvoiceLine) and (xs:decimal(../cbc:TaxableAmount) = ( sum(../../../cac:InvoiceLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='N']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount))))) or (exists(//cac:CreditNoteLine) and (xs:decimal(../cbc:TaxableAmount) = ( sum(../../../cac:CreditNoteLine[cac:Item/cac:ClassifiedTaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:LineExtensionAmount)) + sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=true()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)) - sum(../../../cac:AllowanceCharge[cbc:ChargeIndicator=false()][cac:TaxCategory/normalize-space(cbc:ID)='E']/xs:decimal(cbc:Amount)))))">
          <xsl:attribute name="id">RSK-X-08</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-N-08]-U poreskom međuzbiru (BG-23) sa šifrom kategorije PDV-a (BT-118) jednakom 'N', iznos osnovice (BT-116) treba da je jednak zbiru neto iznosa stavki (BT-131) umanjenog za zbir popusta na nivou dokumenta (BT-92) i uvećanog za zbir troškova na nivou dokumenta (BT-99) gde je šifra kategorije PDV-a (BT-151, BT-95, BT-102) jednaka 'N'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:decimal(../cbc:TaxAmount) = 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:decimal(../cbc:TaxAmount) = 0">
          <xsl:attribute name="id">RSK-X-09</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-N-09]-Iznos poreza za kategoriju PDV-a 'N' (BT-117, BT-118) u poreskom međuzbiru (BG-23) treba da je jednak nuli.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:TaxExemptionReason) or exists(cbc:TaxExemptionReasonCode)">
          <xsl:attribute name="id">RSK-X-10</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[RSK-N-10]-Poreski međuzbir (BG-23) sa kategorijom PDV-a (BT-118) jednakom 'N' treba da sadrži šifru ili tekst osnova izuzeće od PDV (BT-121, BT-120).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M14" select="*" />
  </xsl:template>
  <xsl:template match="text()" mode="M14" priority="-1" />
  <xsl:template match="@*|node()" mode="M14" priority="-2">
    <xsl:apply-templates mode="M14" select="*" />
  </xsl:template>
</xsl:stylesheet>
