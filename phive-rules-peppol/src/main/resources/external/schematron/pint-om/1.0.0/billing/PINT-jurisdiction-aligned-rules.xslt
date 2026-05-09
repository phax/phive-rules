<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
                xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
                xmlns:u="utils"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>
   <!--PHASES-->
   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <!--XSD TYPES FOR XSLT2-->
   <!--KEYS AND FUNCTIONS-->
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="u:to-decimal"
                 as="xs:decimal">
      <xsl:param name="val"/>
      <xsl:sequence select="if (normalize-space(string($val)) castable as xs:decimal)                              then xs:decimal(normalize-space(string($val)))                              else 0.0"/>
   </xsl:function>
   <xsl:function xmlns="http://purl.oclc.org/dsdl/schematron"
                 name="u:slack"
                 as="xs:boolean">
      <xsl:param name="exp" as="xs:decimal?"/>
      <xsl:param name="val" as="xs:decimal?"/>
      <xsl:param name="slack" as="xs:decimal"/>
      <xsl:variable name="actualExp" select="if (empty($exp)) then 0.0 else $exp"/>
      <xsl:variable name="actualVal" select="if (empty($val)) then 0.0 else $val"/>
      <xsl:sequence select="abs($actualExp - $actualVal) &lt;= $slack"/>
   </xsl:function>
   <!--DEFAULT RULES-->
   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                              title="PINT Oman E-Invoice Validation Rules (IBR-OM)"
                              schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:text>

        * Author: Susheel Kumar (OpenPeppol)
        * Version: 1.0.0
        * Authority: Tax Authority Oman
        * Scope: Validation of VAT-compliant e-invoices under Oman regulations.
        * Notes: Includes business rules, tax validations, and calculation consistency checks.

        *** This Schematron has been designed to provide enhanced guidance for each validation error. 
        *** In addition to reporting the failure, it includes diagnostic information that helps explain the cause of the error and supports users in resolving it effectively.

        ======*****************************************************************************======

        Transaction Type: '<xsl:text/>
            <xsl:value-of select="$txnType"/>
            <xsl:text/>': '<xsl:text/>
            <xsl:value-of select="$txnTypeLabel"/>
            <xsl:text/>'

        ======*****************************************************************************======
    </svrl:text>
         <svrl:text>

        Change log:

    </svrl:text>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                                             prefix="cbc"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                                             prefix="cac"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
                                             prefix="cn"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
                                             prefix="ubl"/>
         <svrl:ns-prefix-in-attribute-values uri="utils" prefix="u"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">Aligned-om-rules</xsl:attribute>
            <xsl:attribute name="name">Aligned-om-rules</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">AlignedCodelists</xsl:attribute>
            <xsl:attribute name="name">AlignedCodelists</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
      </svrl:schematron-output>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">PINT Oman E-Invoice Validation Rules (IBR-OM)</svrl:text>
   <xsl:param name="doc"
              select="/*[local-name()='Invoice' or local-name()='CreditNote']"/>
   <xsl:param name="lines" select="$doc/cac:InvoiceLine | $doc/cac:CreditNoteLine"/>
   <xsl:param name="allowances"
              select="$doc/cac:AllowanceCharge[cbc:ChargeIndicator='false']"/>
   <xsl:param name="charges"
              select="$doc/cac:AllowanceCharge[cbc:ChargeIndicator='true']"/>
   <xsl:param name="invoiceType"
              select="normalize-space(($doc/cbc:InvoiceTypeCode | $doc/cbc:CreditNoteTypeCode)[1])"/>
   <xsl:param name="txnType"
              select="normalize-space(($doc/cbc:InvoiceTypeCode/@name | $doc/cbc:CreditNoteTypeCode/@name)[1])"/>
   <xsl:param name="isValidBitString" select="matches($txnType, '^[01]{20}$')"/>
   <xsl:param name="txnSafe"
              select="if ($isValidBitString) then $txnType else '00000000000000000000'"/>
   <xsl:param name="invoiceCurrency"
              select="normalize-space($doc/cbc:DocumentCurrencyCode)"/>
   <xsl:param name="taxCurrency" select="normalize-space($doc/cbc:TaxCurrencyCode)"/>
   <xsl:param name="exchangeRate"
              select="             if ($doc/cac:TaxExchangeRate/cbc:CalculationRate castable as xs:decimal)             then xs:decimal($doc/cac:TaxExchangeRate/cbc:CalculationRate)             else ()"/>
   <xsl:param name="isFullTax" select="substring($txnSafe,1,1)='1'"/>
   <xsl:param name="isSimplified" select="substring($txnSafe,2,1)='1'"/>
   <xsl:param name="isSelfBilled" select="substring($txnSafe,3,1)='1'"/>
   <xsl:param name="isThirdParty" select="substring($txnSafe,4,1)='1'"/>
   <xsl:param name="isSummary" select="substring($txnSafe,5,1)='1'"/>
   <xsl:param name="isContinuous" select="substring($txnSafe,6,1)='1'"/>
   <xsl:param name="isExport" select="substring($txnSafe,7,1)='1'"/>
   <xsl:param name="isDeemed" select="substring($txnSafe,8,1)='1'"/>
   <xsl:param name="isImportRCM" select="substring($txnSafe,9,1)='1'"/>
   <xsl:param name="isProfitMargin" select="substring($txnSafe,10,1)='1'"/>
   <xsl:param name="isProfitMarginSelf" select="substring($txnSafe,11,1)='1'"/>
   <xsl:param name="isEcommerce" select="substring($txnSafe,12,1)='1'"/>
   <xsl:param name="isImportGoods" select="substring($txnSafe,13,1)='1'"/>
   <xsl:param name="isSpecialZone" select="substring($txnSafe,14,1)='1'"/>
   <xsl:param name="isPrepayment" select="substring($txnSafe,15,1)='1'"/>
   <xsl:param name="baseType"
              select="if ($isFullTax) then 'Full Invoice' else if ($isSimplified) then 'Simplified Invoice' else 'Unknown Type'"/>
   <xsl:param name="subTypes"
              select="         string-join((             if ($isSelfBilled) then 'Self-Billed' else (),             if ($isThirdParty) then 'Third Party' else (),             if ($isSummary) then 'Summary' else (),             if ($isContinuous) then 'Continuous Supply' else (),             if ($isExport) then 'Export' else (),             if ($isDeemed) then 'Deemed Supply' else (),             if ($isImportRCM) then 'Import Reverse Charge' else (),             if ($isProfitMargin) then 'Profit Margin' else (),             if ($isProfitMarginSelf) then 'Profit Margin Self-Invoice' else (),             if ($isEcommerce) then 'E-Commerce' else (),             if ($isImportGoods) then 'Import of Goods' else (),             if ($isSpecialZone) then 'Special Zone' else (),             if ($isPrepayment) then 'Prepayment' else ()         ), ', ')     "/>
   <xsl:param name="txnTypeLabel"
              select="concat($baseType, if (normalize-space($subTypes) != '') then concat(' (', $subTypes, ')') else '')"/>
   <xsl:param name="invalidTxnCombo"
              select="             ($isSelfBilled and ($isThirdParty or $isExport or $isImportRCM or $isProfitMargin or $isImportGoods))             or ($isSummary and ($isContinuous or $isExport or $isProfitMargin))             or ($isExport and ($isSelfBilled or $isSummary or $isImportRCM))         "/>
   <xsl:param name="invalidTxnReason"
              select="             if ($isSelfBilled and ($isThirdParty or $isExport or $isImportRCM or $isProfitMargin or $isImportGoods))             then 'Self-Billed cannot be combined with Third Party / Export / Import RCM / Profit Margin / Import of Goods'                          else if ($isSummary and ($isContinuous or $isExport or $isProfitMargin))             then 'Summary cannot be combined with Continuous Supply / Export / Profit Margin'                          else if ($isExport and ($isSelfBilled or $isSummary or $isImportRCM))             then 'Export cannot be combined with Self-Billed / Summary / Import RCM'                          else ''         "/>
   <!--PATTERN Aligned-om-rules-->
   <!--RULE -->
   <xsl:template match="ubl:Invoice | cn:CreditNote" priority="1009" mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Invoice | cn:CreditNote"/>
      <!--REPORT information-->
      <xsl:if test="true()">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
            <xsl:attribute name="role">information</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>
                DEBUG INFO:
                - Root Element Found: <xsl:text/>
               <xsl:value-of select="local-name($doc)"/>
               <xsl:text/>
                
                [TECHNICAL DATA]
                - Status: Diagnostic Log Generated

                    - Transaction ID: [<xsl:text/>
               <xsl:value-of select="cbc:ID"/>
               <xsl:text/>]
                    - Type Code: [<xsl:text/>
               <xsl:value-of select="$txnType"/>
               <xsl:text/>]
                    - Invoice Type Code: [<xsl:text/>
               <xsl:value-of select="$invoiceType"/>
               <xsl:text/>]
                    - Line Count: <xsl:text/>
               <xsl:value-of select="count($lines)"/>
               <xsl:text/>
                    - Invoice Currency: [<xsl:text/>
               <xsl:value-of select="$invoiceCurrency"/>
               <xsl:text/>]
                    - Tax Currency: [<xsl:text/>
               <xsl:value-of select="$taxCurrency"/>
               <xsl:text/>]
                    - Active SubTypes: [<xsl:text/>
               <xsl:value-of select="$subTypes"/>
               <xsl:text/>]
                    - Invalid Combination: [<xsl:text/>
               <xsl:value-of select="$invalidTxnCombo"/>
               <xsl:text/>]
                    - Reason: [<xsl:text/>
               <xsl:value-of select="$invalidTxnReason"/>
               <xsl:text/>]
            </svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:variable name="customizationID" select="normalize-space(cbc:CustomizationID)"/>
      <xsl:variable name="profileID" select="normalize-space(cbc:ProfileID)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$txnType != ''"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$txnType != ''">
               <xsl:attribute name="id">ALIGNED-IBRP-000-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-000-OM] - Transaction type (BTOM-001) must be present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-000">

            Transaction Type (BTOM-001) is missing.
            
            Expected:
            A 20-digit binary string representing the invoice transaction type.
            
            Action:
            Provide the required transaction type in the Invoice/CreditNote TypeCode name attribute.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="starts-with($customizationID, 'urn:peppol:pint:billing-1@om-1')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with($customizationID, 'urn:peppol:pint:billing-1@om-1')">
               <xsl:attribute name="id">ALIGNED-IBRP-001-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-001-OM] - Specification identifier (IBT-024) MUST start with the value 'urn:peppol:pint:billing-1@om-1'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-001">

            Customization ID (cbc:CustomizationID)

            Found:
            '<xsl:text/>
                  <xsl:value-of select="cbc:CustomizationID"/>
                  <xsl:text/>'

            Expected:
            'urn:peppol:pint:billing-1@om-1'

            Action:
            Set CustomizationID to the expected value.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="starts-with($profileID, 'urn:peppol:pint:billing')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="starts-with($profileID, 'urn:peppol:pint:billing')">
               <xsl:attribute name="id">ALIGNED-IBRP-002-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-002-OM] - Business process (IBT-023) must follow the expected format 'urn:peppol:pint:billing'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-002">

            Profile ID (cbc:ProfileID)

            Found:
            '<xsl:text/>
                  <xsl:value-of select="cbc:ProfileID"/>
                  <xsl:text/>'

            Expected:
            'urn:peppol:pint:billing'

            Action:
            Set ProfileID to the expected value.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($taxCurrency != '') or $taxCurrency = 'OMR'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($taxCurrency != '') or $taxCurrency = 'OMR'">
               <xsl:attribute name="id">ALIGNED-IBRP-003-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-003-OM] - VAT accounting currency (IBT-006) must be 'OMR' for VAT reporting.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-003">

            Tax currency (cbc:TaxCurrencyCode)

            Found:
            '<xsl:text/>
                  <xsl:value-of select="cbc:TaxCurrencyCode"/>
                  <xsl:text/>'

            Expected:
            A valid ISO 4217 currency code.

            Action:
            Provide a valid ISO currency code.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:IssueTime)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(cbc:IssueTime)">
               <xsl:attribute name="id">ALIGNED-IBRP-016-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-016-OM] - An invoice must have an Invoice Issue Time (IBT-168).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-016">

            Issue time (cbc:IssueTime) is not present.

            Found:
            '<xsl:text/>
                  <xsl:value-of select="cbc:IssueTime"/>
                  <xsl:text/>'

            Expected:
            Issue time should be provided.

            Action:
            Provide IssueTime with a valid value.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($invoiceType = ('381','383','261'))                       or cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($invoiceType = ('381','383','261')) or cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID">
               <xsl:attribute name="id">ALIGNED-IBRP-028-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-028-OM] - Preceding invoice reference (IBG-03) MUST be provided when invoice type code (IBT-003) is 'Credit note' ('381') or 'Debit note' ('383') or 'Self billed credit note' ('261').</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-028">

            Document type code (cbc:InvoiceTypeCode / cbc:CreditNoteTypeCode)

            Found:
            '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode"/>
                  <xsl:text/>'

            Expected:
            A valid code from UNCL1001.

            Action:
            Use a valid UNCL1001 document type code.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(                         $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='E'] or                          $allowances[cac:TaxCategory/cbc:ID='E'] or                          $charges[cac:TaxCategory/cbc:ID='E']                     ) or (                         (not($isSimplified) and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='E']) = 1) or                         ($isSimplified and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='E']) &lt;= 1)                     )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not( $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='E'] or $allowances[cac:TaxCategory/cbc:ID='E'] or $charges[cac:TaxCategory/cbc:ID='E'] ) or ( (not($isSimplified) and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='E']) = 1) or ($isSimplified and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='E']) &lt;= 1) )">
               <xsl:attribute name="id">ALIGNED-IBRP-E-01-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-E-01-OM] - An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the VAT category code (IBT-151, IBT-95 or IBT-102) is "E" MUST contain exactly one VAT breakdown (IBG-23) with the VAT category code (IBT-118) equal to "E" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT breakdown is not required if VAT category code (IBT-118) equal to "E".</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-E-01">

            VAT Breakdown Error - Category 'E' (Exempt)

            Context:
            An invoice containing lines, allowances, or charges with VAT category 'E' must have exactly one VAT breakdown (IBG-23) for that category.

            Found:
            - Breakdown Count: '<xsl:text/>
                  <xsl:value-of select="count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='E'])"/>
                  <xsl:text/>'
            - Invoice Type: '<xsl:text/>
                  <xsl:value-of select="$txnTypeLabel"/>
                  <xsl:text/>'

            Expected:
            - Full Invoice: Exactly 1 breakdown.
            - Simplified Invoice: 0 or 1 breakdown (Must be unique).

            Action:
            If this is a Full Invoice, ensure a VAT breakdown for category 'E' is provided. If you provided multiple breakdowns for 'E', merge them into a single unique block.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(                         $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='O'] or                          $allowances[cac:TaxCategory/cbc:ID='O'] or                          $charges[cac:TaxCategory/cbc:ID='O']                     ) or (                         (not($isSimplified) and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='O']) = 1) or                         ($isSimplified and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='O']) &lt;= 1)                     )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not( $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='O'] or $allowances[cac:TaxCategory/cbc:ID='O'] or $charges[cac:TaxCategory/cbc:ID='O'] ) or ( (not($isSimplified) and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='O']) = 1) or ($isSimplified and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='O']) &lt;= 1) )">
               <xsl:attribute name="id">ALIGNED-IBRP-O-01-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-O-01-OM] - An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the VAT category code (IBT-151, IBT-95 or IBT-102) is "O" MUST contain exactly one VAT breakdown group (IBG-23) with the VAT category code (IBT-118) equal to "O" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT breakdown is not required if VAT category code (IBT-118) equal to "O".</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-O-01">

            VAT Breakdown Error - Category 'O' (Out of Scope)

            Context:
            Supplies classified as 'O' require a unique VAT breakdown entry to summarize the non-taxable taxable amounts.

            Found:
            - Breakdown Count: '<xsl:text/>
                  <xsl:value-of select="count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='O'])"/>
                  <xsl:text/>'
            - Invoice Type: '<xsl:text/>
                  <xsl:value-of select="$txnTypeLabel"/>
                  <xsl:text/>'

            Expected:
            Exactly 1 unique breakdown (except for Simplified Invoices where it is optional).

            Action:
            Verify that category 'O' is represented by exactly one unique subtotal block. Remove any duplicate 'O' breakdown entries.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $rate in distinct-values(($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='S']/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent,                                               $allowances[cac:TaxCategory/cbc:ID='S']/cac:TaxCategory/cbc:Percent,                                               $charges[cac:TaxCategory/cbc:ID='S']/cac:TaxCategory/cbc:Percent))               satisfies count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='S' and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal($rate)]) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $rate in distinct-values(($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='S']/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent, $allowances[cac:TaxCategory/cbc:ID='S']/cac:TaxCategory/cbc:Percent, $charges[cac:TaxCategory/cbc:ID='S']/cac:TaxCategory/cbc:Percent)) satisfies count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='S' and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal($rate)]) = 1">
               <xsl:attribute name="id">ALIGNED-IBRP-S-01-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-S-01-OM] - An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the VAT category code (IBT-151, IBT-95 or IBT-102) is "S" MUST contain in the VAT breakdown (IBG-23) at least one VAT category code (IBT-118) equal with "S".</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-S-01">

            VAT Breakdown Error - Category 'S' (Standard Rated)

            Context:
            Standard-rated items (5%) require a corresponding VAT breakdown. Each unique VAT rate used in the lines MUST have exactly one unique breakdown block.

            Found:
            - Breakdown Count for 'S': '<xsl:text/>
                  <xsl:value-of select="count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='S'])"/>
                  <xsl:text/>'

            Expected:
            For each distinct VAT rate (IBT-119), exactly one breakdown MUST exist.

            Action:
            Check for missing or duplicate 'S' category breakdowns. If you have multiple lines at the same 5% rate, they must all be summed into a single 'S' breakdown block.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = 'S']) or                          (every $line in $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = 'S'] satisfies                          ($line/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/normalize-space(.) castable as xs:decimal and                          xs:decimal($line/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) = 5))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = 'S']) or (every $line in $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = 'S'] satisfies ($line/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/normalize-space(.) castable as xs:decimal and xs:decimal($line/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) = 5))">
               <xsl:attribute name="id">ALIGNED-IBRP-S-05-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-S-05-OM] - In an Invoice line (IBG-25) where the Invoiced item VAT category code (IBT-151) is "S" the Invoiced item VAT rate (IBT-152) MUST be 5.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-S-05">

            Invoice line '<xsl:text/>
                  <xsl:value-of select="cbc:ID"/>
                  <xsl:text/>'

            VAT category (IBT-151): 'S' (Standard rated)

            Found:
            VAT rate (IBT-152): '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>
                  <xsl:text/>'

            Expected:
            VAT rate must be 5.

            Action:
            Set VAT rate to 5.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length($txnType) = 20 and matches($txnType, '^[01]{20}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string-length($txnType) = 20 and matches($txnType, '^[01]{20}$')">
               <xsl:attribute name="id">IBR-001-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-001-OM] - Invoice transaction type (BTOM-001) must be a 20-character binary string.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-001">

            Invoice transaction type (BTOM-001)

            Found:
            '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected:
            A 20-character binary string (only 0 and 1).

            Action:
            Provide a valid 20-character binary transaction type.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(cbc:UUID),'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(cbc:UUID),'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')">
               <xsl:attribute name="id">IBR-002-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-002-OM] - Invoice UUID (BTOM-002) must contain only letters, digits, and dashes.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-002">

            Invoice UUID (BTOM-002)

            Found:
            '<xsl:text/>
                  <xsl:value-of select="cbc:UUID"/>
                  <xsl:text/>'

            Expected:
            A valid identifier containing only letters, digits, and hyphens.

            Action:
            Correct the UUID format to include only allowed characters.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$invoiceCurrency = 'OMR' or exists($exchangeRate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$invoiceCurrency = 'OMR' or exists($exchangeRate)">
               <xsl:attribute name="id">IBR-004-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-004-OM] - Currency exchange rate (BTOM-003) MUST be provided when the Invoice currency code (IBT-005) is not equal to 'OMR'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-004">

            Currency exchange rate (BTOM-003)

            Found:
            - Invoice currency: '<xsl:text/>
                  <xsl:value-of select="cbc:DocumentCurrencyCode"/>
                  <xsl:text/>'

            Expected:
            Exchange rate must be provided when invoice currency differs from 'OMR'.

            Action:
            Provide the currency exchange rate when using a non-OMR invoice currency.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($taxCurrency='OMR' and $invoiceCurrency!='OMR')                         or (exists($exchangeRate)                             and $exchangeRate = round($exchangeRate * 10000000) div 10000000)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($taxCurrency='OMR' and $invoiceCurrency!='OMR') or (exists($exchangeRate) and $exchangeRate = round($exchangeRate * 10000000) div 10000000)">
               <xsl:attribute name="id">IBR-005-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-005-OM] - Currency exchange rate (BTOM-003) should contain the values till maximum of 7 decimal places when the VAT accounting currency (IBT-006) is set to OMR and the invoice currency code (IBT-005) differs from OMR.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-005">

            Currency exchange rate (BTOM-003)

            Found:
            '<xsl:text/>
                  <xsl:value-of select="cac:TaxExchangeRate/cbc:CalculationRate"/>
                  <xsl:text/>'

            Expected:
            Maximum of 7 decimal places.

            Action:
            Round or truncate the exchange rate to 7 decimal places.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$isImportGoods or $isImportRCM or $isProfitMarginSelf                   or cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$isImportGoods or $isImportRCM or $isProfitMarginSelf or cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID">
               <xsl:attribute name="id">IBR-006-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-006-OM] - Seller tax identifier (IBT-031) MUST be mandatory in all cases except when Invoice transaction type (BTOM-001) is an invoice for import of goods (XXXXXXXXXXXX1XXXXXXX), import of service RCM (XXXXXXXX1XXXXXXXXXXX) or profit margin self invoice (XXXXXXXXXX1XXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-006">

            Seller VAT identifier (IBT-031)

            Found:
            - Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected:
            VAT identifier must be provided unless exempted by the transaction type.

        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isImportGoods or $isImportRCM or $isProfitMarginSelf or $isSpecialZone) or cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isImportGoods or $isImportRCM or $isProfitMarginSelf or $isSpecialZone) or cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
               <xsl:attribute name="id">IBR-007-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-007-OM] - Seller identifier (IBT-029) Scheme identifier (IBT-029-1) must be provided when Invoice transaction type (BTOM-001) is an invoice for import of goods (XXXXXXXXXXXX1XXXXXXX) or import of service RCM (XXXXXXXX1XXXXXXXXXXX) or profit margin self invoice (XXXXXXXXXX1XXXXXXXXX) or Special zone supplies (XXXXXXXXXXXXX1XXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-007">

            TxnType: '<xsl:text/>
                  <xsl:value-of select="$txnType"/>
                  <xsl:text/>'

            Match result: '<xsl:text/>
                  <xsl:value-of select="matches(normalize-space(string($txnType)),'00000000000010000000|00000000100000000000|00000000001000000000|00000000000001000000')"/>
                  <xsl:text/>'

            Supplier ID exists: '<xsl:text/>
                  <xsl:value-of select="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID)"/>
                  <xsl:text/>'

            Supplier ID with scheme: '<xsl:text/>
                  <xsl:value-of select="exists(cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeID])"/>
                  <xsl:text/>'

        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName                   and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName                   and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName                   and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone                    and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line">
               <xsl:attribute name="id">IBR-010-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-010-OM] - In Seller postal address (IBG-05), Seller address line 1 (IBT-035), Seller address line 2 (IBT-036), Seller address line 3 (IBT-162) Seller city (IBT-037) and Seller postal code (IBT-038) must be provided.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-010">

            Seller postal address (IBG-05) is incomplete. 

            Found: 
            - address line 1: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
                  <xsl:text/>',
            - address line 2: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
                  <xsl:text/>', 
            - address line 3: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
                  <xsl:text/>', 
            - city: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
                  <xsl:text/>', 
            - postal code: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
                  <xsl:text/>'. 

            Expected: address lines, city, and postal code must be provided. 

            Action: complete seller postal address.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone">
               <xsl:attribute name="id">IBR-011-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-011-OM] - In Seller Contact (IBG-06), Seller contact telephone number (IBT-042) must be provided.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-011">

            Expected:
            Seller Telephone number must be provided, always.

            Action:
            Provide a Seller Telephone number.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isExport and $lines//cbc:TaxExemptionReasonCode = 'VATZR-OM-09')                   or cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode != 'OM'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isExport and $lines//cbc:TaxExemptionReasonCode = 'VATZR-OM-09') or cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode != 'OM'">
               <xsl:attribute name="id">IBR-012-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-012-OM] - Deliver to country code (IBT-080) must not be 'OM' if invoice transaction type (BTOM-001) is export invoice (XXXXXX1XXXXXXXXXXXXX) and atleast one VAT exemption reason code (IBT-121) is 'Export of service (VATZR-OM-09)'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-012">

            Deliver-to Country Code (IBT-080) conflict.
            
            Found: '<xsl:text/>
                  <xsl:value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode"/>
                  <xsl:text/>'
            Transaction Type: Export with Export of Service reason.
            
            Expected:
            Deliver-to country must not be 'OM' (Oman) for export of services.
            
            Action:
            Provide a valid destination country code other than 'OM'.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isExport and $lines//cbc:TaxExemptionReasonCode ='VATZR-OM-12')                          or (exists($doc/cac:AdditionalDocumentReference[not(cbc:DocumentTypeCode = '130')]/cbc:ID)                              and exists($doc/cac:AdditionalDocumentReference[not(cbc:DocumentTypeCode = '130')]/cbc:UUID))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isExport and $lines//cbc:TaxExemptionReasonCode ='VATZR-OM-12') or (exists($doc/cac:AdditionalDocumentReference[not(cbc:DocumentTypeCode = '130')]/cbc:ID) and exists($doc/cac:AdditionalDocumentReference[not(cbc:DocumentTypeCode = '130')]/cbc:UUID))">
               <xsl:attribute name="id">IBR-013-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-013-OM] - Supporting document reference (IBT-122) and Supporting document UUID (BTOM-023) must be provided if invoice transaction type (BTOM-001) is export invoice (XXXXXX1XXXXXXXXXXXXX) and atleast one VAT exemption reason code (IBT-121) is 'Re-export of goods (VATZR-OM-12)'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-013">

            Supporting document reference (IBT-122) and UUID (BTOM-023)

            Found:
            Missing supporting document reference and/or UUID

            Expected:
            Both IBT-122 (Document reference) and BTOM-023 (UUID) must be provided for re-export of goods.

            Action:
            Include both document reference and UUID for the re-export transaction.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isExport)                   or cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isExport) or cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode">
               <xsl:attribute name="id">IBR-014-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-014-OM] - Deliver to country code (ibt-080) must be provided if invoice transaction type (BTOM-001) is export invoice (XXXXXX1XXXXXXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-014">

            Deliver-to country code (IBT-080)

            Found:
            Not provided

            Expected:
            Deliver-to country code must be provided for export transactions.

            Action:
            Populate IBT-080 with the applicable country code.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                 not($isThirdParty)                 or (                     count(cac:AccountingSupplierParty/cac:Party/cac:AgentParty) = 1                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyName/cbc:Name                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:StreetName                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:AdditionalStreetName                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cac:AddressLine/cbc:Line                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:CityName                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:PostalZone                     and                     cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isThirdParty) or ( count(cac:AccountingSupplierParty/cac:Party/cac:AgentParty) = 1 and cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyName/cbc:Name and cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID and cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID and cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:StreetName and cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:AdditionalStreetName and cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cac:AddressLine/cbc:Line and cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:CityName and cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cbc:PostalZone and cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode)">
               <xsl:attribute name="id">IBR-015-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-015-OM] - Third Party Name (BTOM-005), Third Party VATIN (BTOM-006), VAT Scheme Code (BTOM-06-1), Third Party Address Line 1 (BTOM-007), Third Party Address Line 2 (BTOM-008), Third Party Address Line 3 (BTOM-009), Third party city (BTOM-010), Third party postal code (BTOM-011) and Third Party Country Code (BTOM-13) must be provided when Invoice transaction type (BTOM-001) is Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) and MUST occur only once.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-015">

            Third-party invoice configuration.

            Found:
            None or multiple third-party party structures

            Expected:
            Exactly one set of third-party details must be provided.
            Location: cac:AccountingSupplierParty/cac:Party/cac:AgentParty
            UBL 2.1 Spec: https://www.datypic.com/sc/ubl21/e-cac_Party.html or see PINT OM Web Spec.

            Action:
            Ensure one and only one third-party party structure is present.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isFullTax or $isThirdParty or $isSummary or $isContinuous or $isExport or $isProfitMargin or $isEcommerce)                   or (cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID                       or cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isFullTax or $isThirdParty or $isSummary or $isContinuous or $isExport or $isProfitMargin or $isEcommerce) or (cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID or cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)">
               <xsl:attribute name="id">IBR-016-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-016-OM] - Either Buyer identifier (IBT-046) or Buyer VATIN (IBT-048) MUST be present when the Invoice transaction type is (BTOM-001) a Full tax invoice (1XXXXXXXXXXXXXXXXXXX) and a Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) or Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Profit margin (XXXXXXXXX1XXXXXXXXXX) invoice or E-commerce supplies (XXXXXXXXXXX1XXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-016">

            Buyer identification (IBT-046 / IBT-048)

            Found:
            - Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'
            - Buyer identifier (IBT-046): '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID"/>
                  <xsl:text/>'
            - Buyer VATIN (IBT-048): '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>
                  <xsl:text/>'

            Expected:
            At least one of the following must be provided:
            - Buyer identifier (IBT-046)
            - Buyer VATIN (IBT-048)

            Action:
            Provide either IBT-046 or IBT-048.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isSelfBilled or $isImportRCM or $isProfitMargin or $isImportGoods)                   or cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isSelfBilled or $isImportRCM or $isProfitMargin or $isImportGoods) or cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID">
               <xsl:attribute name="id">IBR-017-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-017-OM] - Buyer VATIN (IBT-048) MUST be present when the Invoice transaction type (BTOM-001) is a Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Invoice for import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit Margin Self-Invoice ( 00000000001000000000) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-017">

            Buyer VATIN (IBT-048)

            Found:
            - Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'
            - Buyer VATIN (IBT-048): '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID"/>
                  <xsl:text/>'

            Expected:
            Buyer VATIN (IBT-048) must be provided for this transaction type.

            Action:
            Populate IBT-048 with a valid VAT identification number.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isFullTax or $isThirdParty or $isSelfBilled or $isExport or $isImportRCM or $isProfitMargin or $isImportGoods or $isSpecialZone or $isSummary)                   or (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName                        and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName                        and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName                       and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone                       and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isFullTax or $isThirdParty or $isSelfBilled or $isExport or $isImportRCM or $isProfitMargin or $isImportGoods or $isSpecialZone or $isSummary) or (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line)">
               <xsl:attribute name="id">IBR-019-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-019-OM] - Buyer address line 1 (IBT-050), Buyer address line 2 (IBT-051), Buyer address line 3 (IBT-163), Buyer city (IBT-052) and Buyer post code (IBT-053) MUST be present when the Invoice transaction type (BTOM-001) is a Full tax invoice (1XXXXXXXXXXXXXXXXXXX) AND/OR Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Invoice for import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX), or Profit margin (XXXXXXXXX1XXXXXXXXXX) invoice or Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Special zone supplies (XXXXXXXXXXXXX1XXXXXX) or summary invoice (XXXX1XXXXXXXXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-019">

            Buyer postal address (IBG-08)

            Found:
            - Address line 1: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName"/>
                  <xsl:text/>'
            - Address line 2: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName"/>
                  <xsl:text/>'
            - Address line 3: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line"/>
                  <xsl:text/>'
            - City: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName"/>
                  <xsl:text/>'
            - Postal code: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone"/>
                  <xsl:text/>'

            Expected:
            Buyer postal address must include at minimum: address lines, city, and postal code.

            Action:
            Complete the buyer postal address with all mandatory components.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isSelfBilled or $isImportRCM or $isProfitMargin or $isImportGoods)                   or cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='OM'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isSelfBilled or $isImportRCM or $isProfitMargin or $isImportGoods) or cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='OM'">
               <xsl:attribute name="id">IBR-020-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-020-OM] - Buyer country code (IBT-055) MUST be 'OM' when the Invoice transaction type (BTOM-001) is a Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Invoice for import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit Margin Self-Invoice ( 00000000001000000000) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-020">

            Buyer country validation

            Found:
            '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>
                  <xsl:text/>'

            Expected:
            Buyer country must be 'OM'.

            Action:
            Set the buyer country code to 'OM'.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($invoiceType='381' or $invoiceType='383' or $invoiceType='261')                   or cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentStatusCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($invoiceType='381' or $invoiceType='383' or $invoiceType='261') or cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentStatusCode">
               <xsl:attribute name="id">IBR-023-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-023-OM] - Where the Invoice type code [IBT-003] is '381' or '383' or '261', Credit Note or Debit Note reason code (BTOM-032) MUST be provided.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-023">

            Credit/Debit note reason (BTOM-032)

            Found:
            Invoice type: '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode | cbc:CreditNoteTypeCode"/>
                  <xsl:text/>'

            Expected:
            A valid adjustment reason must be provided for all credit and debit notes.

            Action:
            Populate BTOM-032 with a valid credit/debit note reason.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($invoiceType='381' or $invoiceType='383' or $invoiceType='261')                   or (cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID                       and cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate                       and cac:BillingReference/cac:InvoiceDocumentReference/cbc:UUID)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($invoiceType='381' or $invoiceType='383' or $invoiceType='261') or (cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID and cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate and cac:BillingReference/cac:InvoiceDocumentReference/cbc:UUID)">
               <xsl:attribute name="id">IBR-032-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-032-OM] - If Invoice type code (IBT-003) is '381' or '383' or '261', Preceding Invoice reference (IBT-025), and Preceding Invoice issue date (IBT-026), and Preceding invoice UUID (BTOM-031) MUST be present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-032">

            Preceding invoice reference (IBG-03)

            Found:
            Missing one or more preceding invoice reference components

            Expected:
            IBT-025 (reference), IBT-026 (issue date), and BTOM-031 (UUID) must all be present.

            Action:
            Provide complete preceding invoice reference details.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$invoiceCurrency = 'OMR' or ($taxCurrency != '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$invoiceCurrency = 'OMR' or ($taxCurrency != '')">
               <xsl:attribute name="id">IBR-034-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-034-OM] - VAT accounting currency (IBT-006) must be provided if invoice currency code (IBT-005) is not equal to 'OMR'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-034">

            VAT accounting currency (IBT-006)

            Found:
            '<xsl:text/>
                  <xsl:value-of select="cbc:TaxCurrencyCode"/>
                  <xsl:text/>'

            Expected:
            VAT accounting currency must be provided when invoice currency is not 'OMR'.

            Action:
            Populate IBT-006 with the correct VAT accounting currency.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isSummary)                   or (substring(cac:InvoicePeriod/cbc:StartDate,1,7)                       = substring(cac:InvoicePeriod/cbc:EndDate,1,7))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isSummary) or (substring(cac:InvoicePeriod/cbc:StartDate,1,7) = substring(cac:InvoicePeriod/cbc:EndDate,1,7))">
               <xsl:attribute name="id">IBR-036-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-036-OM] - Invoicing period Start date (IBT-073) and Invoicing period end date (IBT-074) provided must belong to the same calendar month where Invoice transaction type code (BTOM-001) is a summary invoice (XXXX1XXXXXXXXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-036">

            Invoicing period validation

            Found:
            - Start: '<xsl:text/>
                  <xsl:value-of select="cac:InvoicePeriod/cbc:StartDate"/>
                  <xsl:text/>'
            - End: '<xsl:text/>
                  <xsl:value-of select="cac:InvoicePeriod/cbc:EndDate"/>
                  <xsl:text/>'

            Expected:
            Start and end dates must be within the same calendar month.

            Action:
            Adjust invoicing period to a single month.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isSummary or $isContinuous)                   or (cac:InvoicePeriod/cbc:StartDate and cac:InvoicePeriod/cbc:EndDate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isSummary or $isContinuous) or (cac:InvoicePeriod/cbc:StartDate and cac:InvoicePeriod/cbc:EndDate)">
               <xsl:attribute name="id">IBR-037-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-037-OM] - Invoicing period start date (IBT-073) and the Invoicing period end date (IBT-074) must be provided where Invoice transaction type code (BTOM-001) is a summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-037">

            Invoicing period completeness

            Found:
            Missing start and/or end date

            Expected:
            Both start and end dates must be provided.

            Action:
            Populate cac:InvoicePeriod/cbc:StartDate and cac:InvoicePeriod/cbc:EndDate.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isEcommerce)                   or (cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName                       and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName                       and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName                       and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone                       and cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode                        and cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isEcommerce) or (cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName and cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone and cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode and cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line)">
               <xsl:attribute name="id">IBR-040-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-040-OM] - Deliver to address line 1 - Postal code (IBT-075), Deliver to address line 2 - Postal code area (ibt-076), Deliver to address line 3 - Area (IBT-165), Deliver to city (IBT-077), Deliver to post code - PO Box(IBT-078), Deliver to country code (IBT-080) MUST be present when the Invoice transaction type (BTOM-001) is E-commerce supplies (XXXXXXXXXXX1XXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-040">

            Delivery address validation (e-commerce supply)

            Found:
            - Address line 1: '<xsl:text/>
                  <xsl:value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName"/>
                  <xsl:text/>'
            - Address line 2: '<xsl:text/>
                  <xsl:value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName"/>
                  <xsl:text/>'
            - Address line 3: '<xsl:text/>
                  <xsl:value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line"/>
                  <xsl:text/>'
            - City: '<xsl:text/>
                  <xsl:value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName"/>
                  <xsl:text/>'
            - Postal code: '<xsl:text/>
                  <xsl:value-of select="cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone"/>
                  <xsl:text/>'

            Expected:
            Delivery address must include address lines, city, and postal code.

            Action:
            Complete the delivery postal address.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="substring($txnType,1,1)='1' or substring($txnType,2,1)='1'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring($txnType,1,1)='1' or substring($txnType,2,1)='1'">
               <xsl:attribute name="id">IBR-043-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-043-OM] - Either the first or second position of Invoice Transaction type (BTOM-001) must always be 1.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-043">

            Context: Transaction type encoding must follow BTOM bit pattern rules.

            Found: Transaction type = '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: The transaction type bit pattern must have either the first or second bit set to '1'.

            Action: Correct the transaction type value to comply with BTOM-001 bit-level encoding rules.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isPrepayment)                         or                         (                             exists(cac:LegalMonetaryTotal/cbc:PrepaidAmount)                             and                             exists(cac:OriginatorDocumentReference/cbc:ID)                             and                             exists(cac:OriginatorDocumentReference/cbc:UUID)                         )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isPrepayment) or ( exists(cac:LegalMonetaryTotal/cbc:PrepaidAmount) and exists(cac:OriginatorDocumentReference/cbc:ID) and exists(cac:OriginatorDocumentReference/cbc:UUID) )">
               <xsl:attribute name="id">IBR-058-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-058-OM] - Prepayment invoice number (BTOM-027) and Prepayment invoice UUID (BTOM-014) must be provided if Paid amount (IBT-180) is present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-058">

            Prepayment flag: '<xsl:text/>
                  <xsl:value-of select="$isPrepayment"/>
                  <xsl:text/>'

            Prepaid amount present: '<xsl:text/>
                  <xsl:value-of select="exists(cac:LegalMonetaryTotal/cbc:PrepaidAmount)"/>
                  <xsl:text/>'
            Value: '<xsl:text/>
                  <xsl:value-of select="cac:LegalMonetaryTotal/cbc:PrepaidAmount"/>
                  <xsl:text/>'

            Originator ID present: '<xsl:text/>
                  <xsl:value-of select="exists(cac:OriginatorDocumentReference/cbc:ID)"/>
                  <xsl:text/>'
            Value: '<xsl:text/>
                  <xsl:value-of select="cac:OriginatorDocumentReference/cbc:ID"/>
                  <xsl:text/>'

            Originator UUID present: '<xsl:text/>
                  <xsl:value-of select="exists(cac:OriginatorDocumentReference/cbc:UUID)"/>
                  <xsl:text/>'
            Value: '<xsl:text/>
                  <xsl:value-of select="cac:OriginatorDocumentReference/cbc:UUID"/>
                  <xsl:text/>'
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($exchangeRate)                   or (cac:TaxExchangeRate/cbc:SourceCurrencyCode=$invoiceCurrency                       and cac:TaxExchangeRate/cbc:TargetCurrencyCode=$taxCurrency)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($exchangeRate) or (cac:TaxExchangeRate/cbc:SourceCurrencyCode=$invoiceCurrency and cac:TaxExchangeRate/cbc:TargetCurrencyCode=$taxCurrency)">
               <xsl:attribute name="id">IBR-059-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-059-OM] - The source currency must be designated as the invoice currency code (IBT-005), and the target currency must be specified as the tax accounting currency (IBT-006), provided that the currency exchange rate (BTOM-003) is available.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-059">

            Exchange rate currency mismatch.

            Found:
            - TaxExchangeSourceCurrency: '<xsl:text/>
                  <xsl:value-of select="cac:TaxExchangeRate/cbc:SourceCurrencyCode"/>
                  <xsl:text/>'.
            - TaxExchangeTargetCurrency:  '<xsl:text/>
                  <xsl:value-of select="cac:TaxExchangeRate/cbc:TargetCurrencyCode"/>
                  <xsl:text/>'.
            - Invoice Currency:   '<xsl:text/>
                  <xsl:value-of select="$invoiceCurrency"/>
                  <xsl:text/>'.
            - Tax Currency:    '<xsl:text/>
                  <xsl:value-of select="$taxCurrency"/>
                  <xsl:text/>'.

            Expected: Source and target currencies must align with invoice and accounting currencies.

            Fix: Correct the exchange rate currencies to match the invoice and VAT accounting currencies.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($invoiceCurrency != 'OMR' and $taxCurrency = 'OMR')                         or (                             $exchangeRate castable as xs:decimal and                             u:slack(                                 xs:decimal((cac:TaxTotal[cbc:TaxAmount/@currencyID = $taxCurrency]/cbc:TaxAmount)[1]),                                 xs:decimal($exchangeRate * (cac:TaxTotal[cbc:TaxAmount/@currencyID = $invoiceCurrency]/cbc:TaxAmount)[1]),                                 0.02                             )                         )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($invoiceCurrency != 'OMR' and $taxCurrency = 'OMR') or ( $exchangeRate castable as xs:decimal and u:slack( xs:decimal((cac:TaxTotal[cbc:TaxAmount/@currencyID = $taxCurrency]/cbc:TaxAmount)[1]), xs:decimal($exchangeRate * (cac:TaxTotal[cbc:TaxAmount/@currencyID = $invoiceCurrency]/cbc:TaxAmount)[1]), 0.02 ) )">
               <xsl:attribute name="id">IBR-065-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-065-OM] - When Invoice currency code (IBT-005) is not equal to 'OMR' and Tax accounting currency [IBT-006] is 'OMR', then the value in Invoice total VAT amount in tax accounting currency [IBT-111] MUST be provided and must be Exchange rate (BTOM-003) multiplied by Invoice total tax amount (IBT-110).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-065">

            Context: Tax amount must be correctly converted into accounting currency using exchange rate rules.

            Found: Tax amount in accounting currency is inconsistent or incorrectly calculated.

            Expected: Tax amount must be derived using the applicable exchange rate and compliant rounding rules.

            Action: Recalculate tax amount using the correct exchange rate and ensure rounding aligns with accounting currency precision rules.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                 not($invoiceCurrency != 'OMR'                     and $doc//cac:TaxCategory/cbc:ID = 'S')                 or                 //cac:TaxTotal/cac:TaxSubtotal[                     cac:TaxCategory/cbc:ID = 'S'                     and cac:TaxAmount                     and cac:TaxCategory/cbc:Percent                 ]                 "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($invoiceCurrency != 'OMR' and $doc//cac:TaxCategory/cbc:ID = 'S') or //cac:TaxTotal/cac:TaxSubtotal[ cac:TaxCategory/cbc:ID = 'S' and cac:TaxAmount and cac:TaxCategory/cbc:Percent ]">
               <xsl:attribute name="id">IBR-066-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-066-OM] - TAX category tax amount in accounting currency (IBT-190), TAX category code for tax category tax amount in accounting currency (IBT-192) and TAX category rate for tax category tax amount in accounting currency (IBT-193) must be provided when Invoice currency code [IBT-005] is not equal to 'OMR' and atleast one TAX category code (IBT-118) is equal to 'S'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-066">

            Missing VAT breakdown details for foreign currency invoice.

            VAT Category: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: When invoice currency is not 'OMR' and VAT category is 'S', the VAT breakdown must include:
            - Tax amount in accounting currency
            - VAT category code
            - VAT rate

            Fix: Provide all required VAT breakdown elements for the applicable category.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isProfitMargin)                         or (                             cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription castable as xs:decimal                             and u:slack(                                 xs:decimal(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription),                                 xs:decimal(sum($lines/cac:ItemPriceExtension/cbc:Amount/xs:decimal(.))),                                 0.02                             )                         )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isProfitMargin) or ( cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription castable as xs:decimal and u:slack( xs:decimal(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription), xs:decimal(sum($lines/cac:ItemPriceExtension/cbc:Amount/xs:decimal(.))), 0.02 ) )">
               <xsl:attribute name="id">IBR-082-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-082-OM] - When Invoice transaction type (BTOM-001) is Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) , then Total Amount Due (BTOM-020), should be provided and is mandatory and must be the sum of Total amount including VAT (BTOM-017).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-082">

            Context: Invoice total consistency validation across all monetary components.

            Found: Total amount due does not match expected calculation.

            Value observed: '<xsl:text/>
                  <xsl:value-of select="cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription"/>
                  <xsl:text/>'
            Our Calculation: '<xsl:text/>
                  <xsl:value-of select="sum((cac:InvoiceLine | cac:CreditNoteLine)/cac:ItemPriceExtension/cbc:Amount)"/>
                  <xsl:text/>'
            Difference: '<xsl:text/>
                  <xsl:value-of select="xs:decimal(sum((cac:InvoiceLine | cac:CreditNoteLine)/cac:ItemPriceExtension/cbc:Amount) - cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:DocumentDescription)"/>
                  <xsl:text/>'

            Expected: Total amount due (BTOM-020) must equal Total amount including VAT (BTOM-017) adjusted for all applicable charges, allowances, and rounding rules.

            Action: Recalculate the total payable amount ensuring consistency across VAT, charges, allowances, and rounding rules.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                 not($isImportGoods)                 or                 (                     cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate                     and cac:Delivery/cac:Shipment/cbc:ID                     and cac:Delivery/cac:DeliveryTerms/cbc:ID                 )                 "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isImportGoods) or ( cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate and cac:Delivery/cac:Shipment/cbc:ID and cac:Delivery/cac:DeliveryTerms/cbc:ID )">
               <xsl:attribute name="id">IBR-085-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-085-OM] - If invoice transaction type (BTOM-001) is 'Import of Goods' (XXXXXXXXXXXX1XXXXXXX), import details (IBG-33-OM) MUST be present and must contain, Import date (BTOM-020), Custom Declaration number (BTOM-021) and Incoterms (BTOM-022).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-085">

            Import Goods flag: '<xsl:text/>
                  <xsl:value-of select="$isImportGoods"/>
                  <xsl:text/>'

            Shipment present: '<xsl:text/>
                  <xsl:value-of select="exists(cac:Delivery/cac:Shipment)"/>
                  <xsl:text/>'

            Import date (ActualDeliveryDate): '<xsl:text/>
                  <xsl:value-of select="exists(cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate)"/>
                  <xsl:text/>'
            Value: '<xsl:text/>
                  <xsl:value-of select="cac:Delivery/cac:Shipment/cbc:ActualDeliveryDate"/>
                  <xsl:text/>'

            Customs Declaration number (Shipment ID): '<xsl:text/>
                  <xsl:value-of select="exists(cac:Delivery/cac:Shipment/cbc:ID)"/>
                  <xsl:text/>'
            Value: '<xsl:text/>
                  <xsl:value-of select="cac:Delivery/cac:Shipment/cbc:ID"/>
                  <xsl:text/>'

            Incoterms (DeliveryTerms ID): '<xsl:text/>
                  <xsl:value-of select="exists(cac:Delivery/cac:DeliveryTerms/cbc:ID)"/>
                  <xsl:text/>'
            Value: '<xsl:text/>
                  <xsl:value-of select="cac:Delivery/cac:DeliveryTerms/cbc:ID"/>
                  <xsl:text/>'
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isProfitMargin)                 or cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='OM'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isProfitMargin) or cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode='OM'">
               <xsl:attribute name="id">IBR-087-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-087-OM] - In case Invoice transaction type (BTOM-001) is 'Profit Margin Self-Invoice' (XXXXXXXXXX1XXXXXXXXX), Seller Country Code (IBT-040) MUST be 'OM'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-087">

            Context: Seller country validation for profit margin self-invoices.

            Found: Seller country code = '<xsl:text/>
                  <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>
                  <xsl:text/>'

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Seller country code (IBT-040) must be 'OM' for profit margin self-invoice scenarios.

            Action: Correct the seller country code to 'OM' or verify transaction eligibility under profit margin self-invoice rules.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="vatTaxTotals" select="cac:TaxTotal"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($taxCurrency != '') or                          (some $total in cac:TaxTotal satisfies                              ($total/cbc:TaxAmount/@currencyID = $taxCurrency and                              (every $sub in $total/cac:TaxSubtotal/cbc:TaxAmount satisfies $sub/@currencyID = $taxCurrency))                         )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($taxCurrency != '') or (some $total in cac:TaxTotal satisfies ($total/cbc:TaxAmount/@currencyID = $taxCurrency and (every $sub in $total/cac:TaxSubtotal/cbc:TaxAmount satisfies $sub/@currencyID = $taxCurrency)) )">
               <xsl:attribute name="id">IBR-136-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-136-OM] - CurrencyID must match VAT accounting currency (IBT-006) for VAT accounting amounts.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-136">

            Invalid currency for VAT accounting amounts.

            VAT accounting currency (IBT-006): '<xsl:text/>
                  <xsl:value-of select="cbc:TaxCurrencyCode"/>
                  <xsl:text/>'

            Found VAT totals:
            - All TaxTotal currencies: '<xsl:text/>
                  <xsl:value-of select="string-join(cac:TaxTotal/cbc:TaxAmount/@currencyID, ', ')"/>
                  <xsl:text/>'
            - VAT breakdown currencies: '<xsl:text/>
                  <xsl:value-of select="string-join(cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/@currencyID, ', ')"/>
                  <xsl:text/>'

            Expected: One TaxTotal must use the VAT accounting currency (IBT-006), and all its VAT amounts must use the same currency.

            Fix:
            - Ensure a TaxTotal exists with currencyID = IBT-006
            - Ensure all related VAT breakdown amounts use the same currency.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                 not(                     //*[                         self::cbc:TaxExclusiveAmount or                         self::cbc:TaxInclusiveAmount or                         self::cbc:AllowanceTotalAmount or                         self::cbc:ChargeTotalAmount or                         self::cbc:PrepaidAmount or                         self::cbc:PayableAmount or                         self::cbc:Amount or                         self::cbc:PriceAmount or                         self::cbc:BaseAmount or                         self::cbc:Quantity or                         self::cbc:BaseQuantity or                         self::cbc:CreditedQuantity or                          self::cbc:TaxAmount or                          self::cbc:LineExtensionAmount                     ]                     [                         normalize-space(.) != ''                          and . castable as xs:decimal                          and xs:decimal(.) &lt; 0                     ]                 )             "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not( //*[ self::cbc:TaxExclusiveAmount or self::cbc:TaxInclusiveAmount or self::cbc:AllowanceTotalAmount or self::cbc:ChargeTotalAmount or self::cbc:PrepaidAmount or self::cbc:PayableAmount or self::cbc:Amount or self::cbc:PriceAmount or self::cbc:BaseAmount or self::cbc:Quantity or self::cbc:BaseQuantity or self::cbc:CreditedQuantity or self::cbc:TaxAmount or self::cbc:LineExtensionAmount ] [ normalize-space(.) != '' and . castable as xs:decimal and xs:decimal(.) &lt; 0 ] )">
               <xsl:attribute name="id">IBR-137-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-137-OM] - All the invoice amounts and quantities must be zero or positive.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-137">

            Negative value not allowed.

            Found negative values:
            '<xsl:text/>
                  <xsl:value-of select="string-join(//*[                  self::cbc:TaxExclusiveAmount or                 self::cbc:TaxInclusiveAmount or                 self::cbc:AllowanceTotalAmount or                 self::cbc:ChargeTotalAmount or                 self::cbc:PrepaidAmount or                 self::cbc:PayableAmount or                 self::cbc:Amount or                 self::cbc:PriceAmount or                 self::cbc:BaseAmount or                 self::cbc:Quantity or                 self::cbc:BaseQuantity or                 self::cbc:CreditedQuantity or                  self::cbc:TaxAmount or                  self::cbc:LineExtensionAmount             ][                 normalize-space(.) != ''                  and . castable as xs:decimal                  and xs:decimal(.) &lt; 0             ], ', ')"/>
                  <xsl:text/>'

            Expected: Amounts and quantities must be zero or positive.

            Fix: Ensure all monetary amounts and quantities are non-negative.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isSelfBilled and ($isThirdParty or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isSelfBilled and ($isThirdParty or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))">
               <xsl:attribute name="id">IBR-138-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-138-OM] - Invoice transaction type (BTOM-001) cannot be Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-138">

            Context: Self-billed invoices must follow strict transaction type isolation rules.

            Found: Self-billed invoice is combined with additional transaction types.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Self-billed invoices must not be combined with any other transaction classification or transaction modifier.

            Action: Use only the self-billed transaction type and remove all conflicting transaction flags.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isThirdParty and $isSelfBilled)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isThirdParty and $isSelfBilled)">
               <xsl:attribute name="id">IBR-139-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-139-OM] - Invoice transaction type (BTOM-001) cannot be Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-139">

            Context: Transaction type classification must be mutually exclusive at invoice level.

            Found: Invoice contains both self-billed and third-party indicators.

            Expected: An invoice must be classified as either self-billed or third-party, but not both.

            Action: Remove conflicting classification and retain only one valid transaction type.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isSummary and ($isContinuous or $isExport or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isSummary and ($isContinuous or $isExport or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))">
               <xsl:attribute name="id">IBR-140-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-140-OM] - Invoice transaction type (BTOM-001) cannot be Summary invoice (XXXX1XXXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX), Import of Goods (XXXXXXXXXXXX1XXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-140">

            Context: Summary invoices must not be combined with incompatible transaction categories.

            Found: Summary invoice combined with additional transaction types.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Summary invoices must not be combined with continuous supply, export, profit margin, or import of goods transaction types.

            Action: Remove incompatible transaction types and ensure summary invoice is used in isolation.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isContinuous and ($isSummary or $isDeemed or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isContinuous and ($isSummary or $isDeemed or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))">
               <xsl:attribute name="id">IBR-141-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-141-OM] - Invoice transaction type (BTOM-001) cannot be Continuous supply (XXXXX1XXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-141">

            Context: Continuous supply invoices require strict transaction type separation.

            Found: Continuous supply invoice combined with incompatible transaction types.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Continuous supply invoices must not be combined with summary invoices, deemed supply, or profit margin transaction types.

            Action: Remove incompatible transaction classifications and retain only valid continuous supply designation.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isExport and ($isSelfBilled or $isSummary or $isDeemed or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isExport and ($isSelfBilled or $isSummary or $isDeemed or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods))">
               <xsl:attribute name="id">IBR-142-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-142-OM] - Invoice transaction type (BTOM-001) cannot be Export Invoice (XXXXXX1XXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-142">

            Context: Export invoices must comply with defined transaction compatibility rules.

            Found: Export invoice combined with potentially incompatible transaction types.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Export invoices must only be used with transaction types that are explicitly compatible under export processing rules.

            Action: Ensure only valid export-compatible transaction classifications are applied.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isDeemed and ($isContinuous or $isExport or $isProfitMargin or $isProfitMarginSelf))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isDeemed and ($isContinuous or $isExport or $isProfitMargin or $isProfitMarginSelf))">
               <xsl:attribute name="id">IBR-143-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-143-OM] - Invoice transaction type (BTOM-001) cannot be Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-143">

            Context: Deemed supply transactions must follow strict transaction-type isolation rules.

            Found: Deemed supply transaction combined with additional transaction classifications.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Deemed supply must not be combined with any incompatible transaction types.

            Action: Ensure deemed supply is used as a standalone transaction classification without additional conflicting types.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isImportRCM and ($isExport or $isProfitMargin or $isProfitMarginSelf or $isImportGoods or $isSelfBilled))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isImportRCM and ($isExport or $isProfitMargin or $isProfitMarginSelf or $isImportGoods or $isSelfBilled))">
               <xsl:attribute name="id">IBR-144-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-144-OM] - Invoice transaction type (BTOM-001) cannot be Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-144">

            Context: Import of services (reverse charge mechanism) requires exclusive transaction classification.

            Found: Import of services (RCM) combined with other transaction types.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Import of services (RCM) must not be combined with incompatible transaction types.

            Action: Ensure RCM import of services is used as a standalone classification or correctly separated from other transaction types.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isProfitMargin and ($isSummary or $isContinuous or $isExport or $isDeemed or $isImportRCM or $isImportGoods or $isSelfBilled))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isProfitMargin and ($isSummary or $isContinuous or $isExport or $isDeemed or $isImportRCM or $isImportGoods or $isSelfBilled))">
               <xsl:attribute name="id">IBR-145-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-145-OM] - Invoice transaction type (BTOM-001) cannot be Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) if Invoice transaction type (BTOM-001) is Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-145">

            Context: Profit margin invoices require isolated transaction classification.

            Found: Profit margin invoice combined with other transaction types.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Profit margin invoices must not be combined with incompatible transaction types.

            Action: Ensure profit margin invoice is used as a standalone transaction classification.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isProfitMarginSelf and ($isSummary or $isContinuous or $isExport or $isDeemed or $isImportRCM or $isProfitMargin or $isImportGoods or $isSelfBilled))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isProfitMarginSelf and ($isSummary or $isContinuous or $isExport or $isDeemed or $isImportRCM or $isProfitMargin or $isImportGoods or $isSelfBilled))">
               <xsl:attribute name="id">IBR-146-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-146-OM] - Invoice transaction type (BTOM-001) cannot be Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) if Invoice transaction type (BTOM-001) Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Deemed Supply Invoice (XXXXXXX1XXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX), Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-146">

            Context: Profit margin self-invoices must follow strict exclusivity rules.

            Found: Profit margin self-invoice combined with additional transaction types.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Profit margin self-invoices must not be combined with any incompatible transaction types.

            Action: Ensure profit margin self-invoice is used as a standalone transaction classification.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isImportGoods and ($isSummary or $isContinuous or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isEcommerce or $isSelfBilled))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isImportGoods and ($isSummary or $isContinuous or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isEcommerce or $isSelfBilled))">
               <xsl:attribute name="id">IBR-147-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-147-OM] - Invoice transaction type (BTOM-001) cannot be Import of Goods (XXXXXXXXXXXX1XXXXXXX) if Invoice transaction type (BTOM-001) is Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Continuous supply (XXXXX1XXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or E-commerce supplies (XXXXXXXXXXX1XXXXXXXX) or Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-147">

            Context: Import of goods transactions require strict classification isolation.

            Found: Import of goods combined with other transaction types.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Import of goods must not be combined with incompatible transaction types.

            Action: Ensure import of goods is used as a standalone transaction classification.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isEcommerce and $isProfitMarginSelf)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isEcommerce and $isProfitMarginSelf)">
               <xsl:attribute name="id">IBR-148-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-148-OM] - Invoice transaction type (BTOM-001) cannot be E-commerce supplies (XXXXXXXXXXX1XXXXXXXX) if Invoice transaction type (BTOM-001) is Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-148">

            Context: E-commerce supplies have strict incompatibility rules with profit margin self-invoices.

            Found: E-commerce supply combined with profit margin self-invoice classification.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: E-commerce supplies must not be combined with profit margin self-invoice transaction types.

            Action: Remove conflicting classification and retain a single valid transaction type.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isSimplified and ($isSelfBilled or $isThirdParty or $isSummary or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods or $isSpecialZone))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isSimplified and ($isSelfBilled or $isThirdParty or $isSummary or $isExport or $isImportRCM or $isProfitMargin or $isProfitMarginSelf or $isImportGoods or $isSpecialZone))">
               <xsl:attribute name="id">IBR-149-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-149-OM] - Invoice transaction type (BTOM-001) cannot be Simplified Tax Invoice (X1XXXXXXXXXXXXXXXXXX) if Invoice transaction type (BTOM-001) is Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) or Third-party Invoice (XXX1XXXXXXXXXXXXXXXX) or Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Export Invoice (XXXXXX1XXXXXXXXXXXXX) or Import of services for RCM (XXXXXXXX1XXXXXXXXXXX) or Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) or Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) or Import of Goods (XXXXXXXXXXXX1XXXXXXX) or Special Zone Supplies (XXXXXXXXXXXXX1XXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-149">

            Context: Simplified tax invoices must remain a standalone transaction classification.

            Found: Simplified tax invoice combined with additional transaction types.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Simplified tax invoices must not be combined with any other transaction types.

            Action: Use only the simplified tax invoice type and remove all conflicting classifications.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isSpecialZone)                   or (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isSpecialZone) or (cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode)">
               <xsl:attribute name="id">IBR-150-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-150-OM] - If Invoice transaction type (BTOM-001) is Special Zone Supplies (XXXXXXXXXXXXX1XXXXXX) , buyer country subdivision code (BTOM-026) and Seller country subdivision code (BTOM-024) MUST be provided using the codelist for Country Subdivision (CL-13-OM).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-150">

            Missing subdivision codes for special zone supply.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'
            Buyer subdivision (BTOM-026): '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode"/>
                  <xsl:text/>'
            Seller subdivision (BTOM-024): '<xsl:text/>
                  <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode"/>
                  <xsl:text/>'

            Expected: When transaction type is Special Zone supply, both buyer and seller subdivision codes must be provided from code list CL-13-OM.

            Fix: Populate valid subdivision codes for both buyer and seller.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                     not($isSpecialZone and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode!='MO')                     or                     cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID                     "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isSpecialZone and cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode!='MO') or cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID">
               <xsl:attribute name="id">IBR-151-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-151-OM] - Seller identifier (IBT-029) is mandatory with Scheme identifier (IBT-029-1) 'Special Zone License Number' if Invoice transaction type (BTOM-001) is Special zone supplies (XXXXXXXXXXXXX1XXXXXX) and Seller country subdivision code (BTOM-024) is not equal to 'MO'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-151">

            Missing or invalid seller special zone identifier.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'
            Seller subdivision (BTOM-024): '<xsl:text/>
                  <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode"/>
                  <xsl:text/>'
            Found scheme: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID"/>
                  <xsl:text/>'

            Expected: When special zone applies and seller subdivision is not 'MO', seller identifier must use scheme 'Special Zone License Number'.

            Fix: Provide seller identifier with scheme 'Special Zone License Number'.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                     not($isSpecialZone and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode!='MO')                     or                     cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID                     "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isSpecialZone and cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode!='MO') or cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
               <xsl:attribute name="id">IBR-152-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-152-OM] - Buyer identifier (IBT-046) is mandatory with Scheme identifier (IBT-046-1) 'Special Zone License Number' if Invoice transaction type (BTOM-001) is Special zone supplies (XXXXXXXXXXXXX1XXXXXX) and Buyer country subdivision code (BTOM-026) is not equal to 'MO'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-152">

            Missing or invalid buyer special zone identifier.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'.
            Buyer subdivision (BTOM-026): '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode"/>
                  <xsl:text/>'.
            Found scheme: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID"/>
                  <xsl:text/>'.

            Expected: When special zone applies and buyer subdivision is not 'MO', buyer identifier must use scheme 'Special Zone License Number'.

            Fix: Provide buyer identifier with scheme 'Special Zone License Number'.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                     not($isImportGoods)                     or                     cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID                     "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isImportGoods) or cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
               <xsl:attribute name="id">IBR-153-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-153-OM] - Buyer identifier (IBT-046) is mandatory with Scheme identifier (IBT-046-1) 'Importer Customs ID' if Invoice transaction type (BTOM-001) is Import of Goods (XXXXXXXXXXXX1XXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-153">

            Missing or invalid buyer importer identifier.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'.
            Found scheme: '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/@schemeID"/>
                  <xsl:text/>'.

            Expected: For import of goods, buyer identifier must use scheme 'Importer Customs ID'.

            Fix: Provide buyer identifier with scheme 'Importer Customs ID'.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isExport and $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode ='VATZR-OM-09'])                   or $lines[cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isExport and $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode ='VATZR-OM-09']) or $lines[cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode]">
               <xsl:attribute name="id">IBR-155-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-155-OM] - If invoice transaction type (BTOM-001) is export invoice (XXXXXX1XXXXXXXXXXXXX) and atleast one VAT exemption reason code (IBT-121) is 'Export of service' then Service Type (BTOM-015) must be provided from the codelist for Type of Services (CL-12-OM).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-155">

            Context: Export of services requires mandatory service type classification for regulatory reporting.

            Found: Service type is missing or not provided (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode = '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode"/>
                  <xsl:text/>').

            Expected: Service type must be provided for export of services using a valid code from code list CL-12-OM.

            Action: Populate a valid service type code from CL-12-OM or verify correct classification of the exported service.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate) or matches(cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate,'^\d{4}-\d{2}-\d{2}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate) or matches(cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate,'^\d{4}-\d{2}-\d{2}$')">
               <xsl:attribute name="id">IBR-156-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-156-OM] - Import date (BTOM-020) MUST be formatted in YYYY-MM-DD.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-156">

            Context: Delivery date must comply with standardized ISO date format requirements.

            Found: Invalid date format in ActualDeliveryDate = '<xsl:text/>
                  <xsl:value-of select="cac:Delivery/cac:Shipment/cac:Delivery/cbc:ActualDeliveryDate"/>
                  <xsl:text/>'

            Expected: Date must conform to ISO 8601 format (YYYY-MM-DD).

            Action: Correct the date format to comply with ISO 8601 standard.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isImportRCM)                   or cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'OM'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isImportRCM) or cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode != 'OM'">
               <xsl:attribute name="id">IBR-160-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-160-OM] - Seller country code (IBT-040) MUST not be'OM' if Invoice transaction type (BTOM-001) is Import of services for RCM (XXXXXXXX1XXXXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-160">

            Context: Seller country validation for import of services under reverse charge mechanism (RCM).

            Found: Seller country code = '<xsl:text/>
                  <xsl:value-of select="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode"/>
                  <xsl:text/>'

            Expected: For import of services (RCM), the seller country must not be 'OM' as per jurisdictional classification rules.

            Action: Correct the seller country code to a valid non-'OM' country of establishment or verify whether the transaction is incorrectly classified as an import of services.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:ID) or cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:ID = 'OMR'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:ID) or cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:ID = 'OMR'">
               <xsl:attribute name="id">IBR-169-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-169-OM] - currencyID attribute for Total amount due (profit margin) (BTOM-030) MUST be 'OMR'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-169">

            Context: Profit margin invoices require a fixed accounting currency to ensure regulatory consistency and correct tax computation.

            Found: Currency value = '<xsl:text/>
                  <xsl:value-of select="cac:AdditionalDocumentReference[cbc:DocumentTypeCode='PM_TOTAL']/cbc:ID"/>
                  <xsl:text/>'.

            Expected: Total amount due currency must be 'OMR' for profit margin invoices.

            Action: Set the invoice currency (BT-5 / total amount due currency) to 'OMR' or correct the profit margin classification if a different currency is intended.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:IssueDate) or                          xs:date(cbc:IssueDate) &lt;= xs:date(substring(string(current-date()), 1, 10))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(cbc:IssueDate) or xs:date(cbc:IssueDate) &lt;= xs:date(substring(string(current-date()), 1, 10))">
               <xsl:attribute name="id">IBR-171-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-171-OM] - Invoice issue date (IBT-002) MUST NOT be a future date.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-171">

            Invoice issue date is in the future.

            Found:
            - Issue date (IBT-002): '<xsl:text/>
                  <xsl:value-of select="cbc:IssueDate"/>
                  <xsl:text/>'
            - Current date: '<xsl:text/>
                  <xsl:value-of select="current-date()"/>
                  <xsl:text/>'

            Expected:
            Issue date must be less than or equal to the current date.

            Fix:
            Ensure the invoice issue date is not set in the future.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($invoiceCurrency='OMR') or not(cac:TaxExchangeRate/cbc:CalculationRate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($invoiceCurrency='OMR') or not(cac:TaxExchangeRate/cbc:CalculationRate)">
               <xsl:attribute name="id">IBR-172-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-172-OM] - If Invoice currency code (IBT-005) is "OMR" then Exchange Rate (BTOM-003) MUST NOT be present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-172">

            Invalid exchange rate usage.
            Found:
            - Invoice currency: '<xsl:text/>
                  <xsl:value-of select="$invoiceCurrency"/>
                  <xsl:text/>'
            - Exchange rate: '<xsl:text/>
                  <xsl:value-of select="cac:TaxExchangeRate/cbc:CalculationRate"/>
                  <xsl:text/>'
            Expected: Exchange rate must not be provided when invoice currency is 'OMR'.

            Fix: Remove the exchange rate.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                     not(normalize-space(cac:AccountingCustomerParty/cac:Party/cbc:EndpointID) = '997770000099')                     or                     (                         normalize-space(cac:AccountingSupplierParty/cbc:AdditionalAccountID) != ''                         and                         matches(normalize-space(cac:AccountingSupplierParty/cbc:AdditionalAccountID), '^[A-Za-z0-9-]+$')                     )                     "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(cac:AccountingCustomerParty/cac:Party/cbc:EndpointID) = '997770000099') or ( normalize-space(cac:AccountingSupplierParty/cbc:AdditionalAccountID) != '' and matches(normalize-space(cac:AccountingSupplierParty/cbc:AdditionalAccountID), '^[A-Za-z0-9-]+$') )">
               <xsl:attribute name="id">IBR-173-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-173-OM] - If Buyer electronic address (IBT-049) is '997770000099', Seller UUID (BTOM-004) MUST be present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-173">

            Missing seller UUID.

            Found:
            - Buyer electronic address (IBT-049): '<xsl:text/>
                  <xsl:value-of select="cac:AccountingCustomerParty/cac:Party/cbc:EndpointID"/>
                  <xsl:text/>'
            - Seller UUID (BTOM-004): '<xsl:text/>
                  <xsl:value-of select="cac:AccountingSupplierParty/cbc:AdditionalAccountID"/>
                  <xsl:text/>'

            Expected:
            When buyer electronic address is '997770000099', seller UUID must be provided.

            Fix:
            Populate Seller UUID (BTOM-004) under cac:AccountingSupplierParty/cbc:AdditionalAccountID.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                     not($isProfitMargin)                     or                     exists(                         cac:BillingReference/cac:InvoiceDocumentReference[                             normalize-space(cbc:ID) != ''                             and normalize-space(cbc:UUID) != ''                         ]                     )                     "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isProfitMargin) or exists( cac:BillingReference/cac:InvoiceDocumentReference[ normalize-space(cbc:ID) != '' and normalize-space(cbc:UUID) != '' ] )">
               <xsl:attribute name="id">IBR-175-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-175-OM] - If Invoice transaction type (BTOM-003) is Profit margin invoice '00000000010000000000', Preceding Invoice reference (IBT-025), and Preceding invoice UUID (BTOM-031) MUST be present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-175">

            Missing or incomplete preceding invoice reference for profit margin invoice.

            Found:
            - Transaction type (BTOM-003): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'
            - Preceding invoice reference (IBT-025): '<xsl:text/>
                  <xsl:value-of select="string-join(cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID, ', ')"/>
                  <xsl:text/>'
            - Preceding invoice UUID (BTOM-031): '<xsl:text/>
                  <xsl:value-of select="string-join(cac:BillingReference/cac:InvoiceDocumentReference/cbc:UUID, ', ')"/>
                  <xsl:text/>'

            Expected:
            When transaction type is Profit margin invoice, at least one preceding invoice reference must include both:
            - IBT-025 (Invoice reference)
            - BTOM-031 (Invoice UUID)

            Fix:
            Provide a complete preceding invoice reference with both ID and UUID.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isPrepayment and ($isSummary or $isDeemed or $isProfitMarginSelf))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isPrepayment and ($isSummary or $isDeemed or $isProfitMarginSelf))">
               <xsl:attribute name="id">IBR-176-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-176-OM] - Invoice transaction type (BTOM-001) cannot be Prepayment Invoice (XXXXXXXXXXXXXXX1XXXX) if Invoice transaction type (BTOM-001) is Summary invoice (XXXX1XXXXXXXXXXXXXXX) or Deemed Supply (XXXXXXX1XXXXXXXXXXXX) or Profit Margin Self Invoice (XXXXXXXXXX1XXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-176">

            Context: Prepayment invoice must follow strict transaction type isolation rules.

            Found: Prepayment invoice combined with incompatible transaction types.

            Expected: Prepayment invoices must not be combined with summary invoices, deemed supply transactions, or profit margin self-invoice classifications.

            Action: Remove incompatible transaction types and ensure prepayment invoice is used as a standalone or correctly scoped transaction classification.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($invoiceType=('261','389'))                   or ($isSelfBilled or $isImportRCM or $isProfitMarginSelf or $isImportGoods)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($invoiceType=('261','389')) or ($isSelfBilled or $isImportRCM or $isProfitMarginSelf or $isImportGoods)">
               <xsl:attribute name="id">IBR-177-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-177-OM] - If Invoice Type code (IBT-003) is Self billed credit note '261' or Self billed invoice '389' then Invoice transaction type (BTOM-001) MUST be either Self-billed Invoice/credit note (XX1XXXXXXXXXXXXXXXXX) OR Invoice for import of services for RCM (XXXXXXXX1XXXXXXXXXXX) OR Profit Margin Self-Invoice (XXXXXXXXXX1XXXXXXXXX) OR Import of Goods (XXXXXXXXXXXX1XXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-177">

            Context: Invoice type and transaction type must follow a validated compatibility matrix.

            Found: Invoice type is not aligned with the configured transaction type classification rules.

            Expected: Invoice type must be compatible with its associated transaction types, such as self-billed, import of services (RCM), profit margin self-invoice, or import of goods.

            Action: Adjust either the invoice type or transaction classification to ensure compliance with the allowed compatibility matrix.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal | cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal"
                 priority="1008"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal | cn:CreditNote/cac:TaxTotal/cac:TaxSubtotal"/>
      <xsl:variable name="vatCategory" select="normalize-space(cac:TaxCategory/cbc:ID)"/>
      <xsl:variable name="rate"
                    select="if (cac:TaxCategory/cbc:Percent castable as xs:decimal)                         then xs:decimal(cac:TaxCategory/cbc:Percent)                         else ()"/>
      <xsl:variable name="cat" select="normalize-space(cac:TaxCategory/cbc:ID)"/>
      <xsl:variable name="isInvoiceCurrency"
                    select="cbc:TaxAmount/@currencyID = $invoiceCurrency"/>
      <xsl:variable name="isTaxCurrency" select="cbc:TaxAmount/@currencyID = $taxCurrency"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isInvoiceCurrency) or cbc:TaxableAmount"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isInvoiceCurrency) or cbc:TaxableAmount">
               <xsl:attribute name="id">ALIGNED-IBRP-045</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-045] - Each VAT breakdown (IBG-23) MUST have a VAT category taxable amount (IBT-116).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-045">

            VAT breakdown (IBG-23)

            Found:
            - Taxable amount (IBT-116): '<xsl:text/>
                  <xsl:value-of select="cbc:TaxableAmount"/>
                  <xsl:text/>'
            - VAT category (IBT-118): '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'
            - VAT rate (IBT-119): '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'
            - VAT amount (IBT-117): '<xsl:text/>
                  <xsl:value-of select="cbc:TaxAmount"/>
                  <xsl:text/>'
            - Currency: '<xsl:text/>
                  <xsl:value-of select="cbc:TaxAmount/@currencyID"/>
                  <xsl:text/>'

            Expected:
            VAT breakdown must be complete and consistent.

            Action:
            Verify VAT category, rate, taxable amount, and VAT amount.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isInvoiceCurrency) or cbc:TaxAmount"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isInvoiceCurrency) or cbc:TaxAmount">
               <xsl:attribute name="id">ALIGNED-IBRP-046</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-046] - Each VAT breakdown (IBG-23) MUST have a VAT category tax amount (IBT-117).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-046">

            VAT amount (IBT-117) is missing or invalid.

            Found:
            - VAT category: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'
            - Taxable amount: '<xsl:text/>
                  <xsl:value-of select="cbc:TaxableAmount"/>
                  <xsl:text/>'

            Expected:
            VAT amount must be present and correctly calculated.

            Action:
            Provide a valid VAT amount.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isInvoiceCurrency) or cac:TaxCategory/cbc:ID"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isInvoiceCurrency) or cac:TaxCategory/cbc:ID">
               <xsl:attribute name="id">ALIGNED-IBRP-047</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-047] - Each VAT breakdown (IBG-23) MUST be defined through a VAT category code (IBT-118).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-047">

            Context: VAT category (IBT-118) is required for tax classification of each applicable element.

            Found: VAT category (IBT-118) = '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: A valid VAT category code must be provided according to the VAT code list (e.g., S, Z, E, O, etc.).

            Action: Provide a valid VAT category code or correct the missing/invalid classification.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isInvoiceCurrency)                          or ($vatCategory = ('E', 'O', 'Z'))                          or exists(cac:TaxCategory/cbc:Percent)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isInvoiceCurrency) or ($vatCategory = ('E', 'O', 'Z')) or exists(cac:TaxCategory/cbc:Percent)">
               <xsl:attribute name="id">ALIGNED-IBRP-048</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-048] - Each VAT breakdown (IBG-23) MUST have a VAT category rate (IBT-119), except for categories 'E', 'O', or 'Z'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-048">

            Context: VAT category and VAT rate must be consistent to ensure correct tax calculation.

            Found:
            - VAT category (IBT-118) = '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'
            - VAT rate (IBT-119) = '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'

            Expected: VAT rate must align with the defined rules for the specified VAT category.

            Action: Correct the VAT rate or adjust the VAT category to match applicable tax rules.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isInvoiceCurrency and $vatCategory = 'E')           or           (               cbc:TaxableAmount castable as xs:decimal               and (not(exists($rate)) or $rate castable as xs:decimal)               and u:slack(                   xs:decimal(cbc:TaxableAmount),                    xs:decimal(                       round(                           (                               sum(                                   for $l in $lines[                                       cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory                                       and (if (exists($rate)) then (cac:Item/cac:ClassifiedTaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) = xs:decimal($rate)) else true())                                   ]                                   return xs:decimal($l/cbc:LineExtensionAmount)                               )                                -                                sum(                                   for $a in $allowances[                                       cac:TaxCategory/cbc:ID = $vatCategory                                       and (if (exists($rate)) then (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal($rate)) else true())                                   ]                                   return xs:decimal($a/cbc:Amount)                               )                                +                                sum(                                   for $c in $charges[                                       cac:TaxCategory/cbc:ID = $vatCategory                                       and (if (exists($rate)) then (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal($rate)) else true())                                   ]                                   return xs:decimal($c/cbc:Amount)                               )                           ) * 100                       ) div 100                   ),                    0.02               )           )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isInvoiceCurrency and $vatCategory = 'E') or ( cbc:TaxableAmount castable as xs:decimal and (not(exists($rate)) or $rate castable as xs:decimal) and u:slack( xs:decimal(cbc:TaxableAmount), xs:decimal( round( ( sum( for $l in $lines[ cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory and (if (exists($rate)) then (cac:Item/cac:ClassifiedTaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) = xs:decimal($rate)) else true()) ] return xs:decimal($l/cbc:LineExtensionAmount) ) - sum( for $a in $allowances[ cac:TaxCategory/cbc:ID = $vatCategory and (if (exists($rate)) then (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal($rate)) else true()) ] return xs:decimal($a/cbc:Amount) ) + sum( for $c in $charges[ cac:TaxCategory/cbc:ID = $vatCategory and (if (exists($rate)) then (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal($rate)) else true()) ] return xs:decimal($c/cbc:Amount) ) ) * 100 ) div 100 ), 0.02 ) )">
               <xsl:attribute name="id">ALIGNED-IBRP-E-08-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-E-08-OM] - In a VAT breakdown (IBG-23) where the VAT category code (IBT-118) is "E" the VAT category taxable amount (IBT-116) MUST be the VAT category taxable amount (IBT-116) must equal the sum of Invoice line net amounts (IBT-131) minus the sum of Document level allowance amounts (IBT-092) plus the sum of Document level charge amounts (IBT-099) where the VAT category codes (IBT-151,IBT-95, IBT-102) is “E" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category taxable amount (IBT-116) is not required if VAT category code (IBT-118) equal to "E".</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-E-08">

            VAT breakdown (IBG-23) – Category 'E' (Exempt)

            Found:
            - Taxable amount (IBT-116): '<xsl:text/>
                  <xsl:value-of select="cbc:TaxableAmount"/>
                  <xsl:text/>'

            Expected:
            Taxable amount must equal the sum of invoice line net amounts for VAT category 'E'.

            Action:
            Verify that all invoice lines with VAT category 'E' are correctly aggregated into the VAT breakdown.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$isSimplified                     or not($vatCategory='E')                     or (                             cbc:TaxAmount castable as xs:decimal                             and xs:decimal(cbc:TaxAmount) = 0                         )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$isSimplified or not($vatCategory='E') or ( cbc:TaxAmount castable as xs:decimal and xs:decimal(cbc:TaxAmount) = 0 )">
               <xsl:attribute name="id">ALIGNED-IBRP-E-09-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-E-09-OM] - The VAT category tax amount (ibt-117) In a VAT breakdown (ibg-23) where the VAT category code (ibt-118) equals "E" MUST equal 0 (zero) unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category tax amount (ibt-117) I is not required if VAT category code (ibt-118) equal to "E".</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-E-09">

            VAT breakdown (IBG-23) – Category 'E' (Exempt)

            Found:
            - VAT amount (IBT-117): '<xsl:text/>
                  <xsl:value-of select="cbc:TaxAmount"/>
                  <xsl:text/>'

            Expected:
            VAT amount must be 0 for exempt supplies.

            Action:
            Set VAT amount to 0 for VAT category 'E'.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$isSimplified         or not($vatCategory = 'O')         or (                 cbc:TaxableAmount castable as xs:decimal                 and u:slack(                     xs:decimal(cbc:TaxableAmount),                      xs:decimal(                         sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory]/cbc:LineExtensionAmount)                         -                         sum($allowances[cac:TaxCategory/cbc:ID = $vatCategory]/cbc:Amount)                         +                         sum($charges[cac:TaxCategory/cbc:ID = $vatCategory]/cbc:Amount)                     ),                      0.02                 )             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$isSimplified or not($vatCategory = 'O') or ( cbc:TaxableAmount castable as xs:decimal and u:slack( xs:decimal(cbc:TaxableAmount), xs:decimal( sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory]/cbc:LineExtensionAmount) - sum($allowances[cac:TaxCategory/cbc:ID = $vatCategory]/cbc:Amount) + sum($charges[cac:TaxCategory/cbc:ID = $vatCategory]/cbc:Amount) ), 0.02 ) )">
               <xsl:attribute name="id">ALIGNED-IBRP-O-08-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-O-08-OM] - In a VAT breakdown (IBG-23) where the VAT category code (IBT-118) is " O" the VAT category taxable amount (IBT-116) MUST be equal the sum of Invoice line net amounts (IBT-131) minus the sum of Document level allowance amounts (IBT-092) plus the sum of Document level charge amounts (IBT-99) where the VAT category codes (IBT-151, IBT-095, IBT-102) are “O" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category taxable amount (IBT-116) is not required if VAT category code (IBT-118) equal to "O".</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-O-08">

            VAT breakdown (IBG-23) – Category 'O' (Out of scope)

            Found:
            - Taxable amount (IBT-116): '<xsl:text/>
                  <xsl:value-of select="cbc:TaxableAmount"/>
                  <xsl:text/>'

            Expected:
            Taxable amount must equal the sum of invoice line net amounts for VAT category 'O'.

            Action:
            Verify that all invoice lines with VAT category 'O' are correctly aggregated into the VAT breakdown.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$isSimplified                     or not($vatCategory='O')                     or (                             cbc:TaxAmount castable as xs:decimal                             and xs:decimal(cbc:TaxAmount) = 0                         )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$isSimplified or not($vatCategory='O') or ( cbc:TaxAmount castable as xs:decimal and xs:decimal(cbc:TaxAmount) = 0 )">
               <xsl:attribute name="id">ALIGNED-IBRP-O-09-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-O-09-OM] - The VAT category tax amount (IBT-117) in a VAT breakdown (IBG-23) where the VAT category code (IBT-118) is "O" MUST be 0 (zero) unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category tax amount (IBT-117) is not required if VAT category code (IBT-118) equal to "O".</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-O-09">

            VAT breakdown (IBG-23) – Category 'O' (Out of scope)

            Found:
            - VAT amount (IBT-117): '<xsl:text/>
                  <xsl:value-of select="cbc:TaxAmount"/>
                  <xsl:text/>'

            Expected:
            VAT amount must be 0 for out-of-scope supplies.

            Action:
            Set VAT amount to 0 for VAT category 'O'.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(                         $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='Z'] or                          $allowances[cac:TaxCategory/cbc:ID='Z'] or                          $charges[cac:TaxCategory/cbc:ID='Z']                     ) or (                         (not($isSimplified) and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='Z']) = 1) or                         ($isSimplified and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='Z']) &lt;= 1)                     )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not( $lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='Z'] or $allowances[cac:TaxCategory/cbc:ID='Z'] or $charges[cac:TaxCategory/cbc:ID='Z'] ) or ( (not($isSimplified) and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='Z']) = 1) or ($isSimplified and count($doc/cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='Z']) &lt;= 1) )">
               <xsl:attribute name="id">ALIGNED-IBRP-Z-01-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-Z-01-OM] - An Invoice that contains an Invoice line (IBG-25), a Document level allowance (IBG-20) or a Document level charge (IBG-21) where the VAT category code (IBT-151, IBT-95 or IBT-102) is "Z" MUST contain in the VAT breakdown (IBG-23) exactly one VAT category code (IBT-118) equal with "Z" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT breakdown is not required if VAT category code (IBT-118) equal to "Z".</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-Z-01">

            VAT Breakdown Error - Category 'Z' (Zero Rated)

            Context:
            Zero-rated supplies must be summarized in exactly one VAT breakdown (IBG-23) to satisfy Oman Tax Authority reporting requirements.

            Found:
            - Breakdown Count: '<xsl:text/>
                  <xsl:value-of select="count(cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='Z'])"/>
                  <xsl:text/>'

            Expected:
            Exactly 1 breakdown for category 'Z' if zero-rated items exist in the lines.

            Action:
            Ensure a single VAT breakdown with Category 'Z' and Percent '0' is present. If duplicates exist, consolidate the amounts into one block.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                     count(                         .//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme                         [cac:TaxScheme/cbc:ID = 'VAT']                         /cbc:CompanyID                     ) &lt;= 1                 "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count( .//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme [cac:TaxScheme/cbc:ID = 'VAT'] /cbc:CompanyID ) &lt;= 1">
               <xsl:attribute name="id">ALIGNED-IBRP-SR-12</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-SR-12] - Seller VAT Identifier (IBT-031) must occur at most once.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-SR-12">

            Seller VAT Identifier (IBT-031): 
            found <xsl:text/>
                  <xsl:value-of select="                 count(                     .//cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme                     [cac:TaxScheme/cbc:ID = 'VAT']                     /cbc:CompanyID                 )             "/>
                  <xsl:text/> occurrence(s). 
            Expected: at most 1 occurrence. 
            Action: ensure only one VAT identifier is provided for the seller.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$isSimplified                     or not($vatCategory='Z')                     or cbc:TaxableAmount =                     (                         sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='Z']/cbc:LineExtensionAmount)                         -                         sum($allowances[cac:TaxCategory/cbc:ID='Z']/cbc:Amount)                         +                         sum($charges[cac:TaxCategory/cbc:ID='Z']/cbc:Amount)                     )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$isSimplified or not($vatCategory='Z') or cbc:TaxableAmount = ( sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID='Z']/cbc:LineExtensionAmount) - sum($allowances[cac:TaxCategory/cbc:ID='Z']/cbc:Amount) + sum($charges[cac:TaxCategory/cbc:ID='Z']/cbc:Amount) )">
               <xsl:attribute name="id">ALIGNED-IBRP-Z-08-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-Z-08-OM] - In a VAT breakdown (IBG-23) where VAT category code (IBT-118) is "Z" the VAT category taxable amount (IBT-116) MUST equal the sum of Invoice line net amount (IBT-131) minus the sum of Document level allowance amounts (IBT-92) plus the sum of Document level charge amounts (IBT-99) where the VAT category codes (IBT-151, IBT-95, IBT-102) are "Z" unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category taxable amount (IBT-116) is not required if VAT category code (IBT-118) equal to "Z".</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-Z-08">

            VAT breakdown (IBG-23) – Category 'Z' (Zero rated)

            Found:
            - Taxable amount (IBT-116): '<xsl:text/>
                  <xsl:value-of select="cbc:TaxableAmount"/>
                  <xsl:text/>'

            Expected:
            Taxable amount must equal the sum of invoice line net amounts for VAT category 'Z'.

            Action:
            Verify that all invoice lines with VAT category 'Z' are correctly aggregated into the VAT breakdown.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$isSimplified                     or not($vatCategory='Z')                     or (                             cbc:TaxAmount castable as xs:decimal                             and xs:decimal(cbc:TaxAmount) = 0                         )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$isSimplified or not($vatCategory='Z') or ( cbc:TaxAmount castable as xs:decimal and xs:decimal(cbc:TaxAmount) = 0 )">
               <xsl:attribute name="id">ALIGNED-IBRP-Z-09-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-Z-09-OM] - The VAT category tax amount (IBT-117) in a VAT breakdown (IBG-23) where VAT category code (IBT-118) is "Z" MUST equal 0 (zero) unless invoice transaction type is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX), where a VAT category tax amount (IBT-117) is not required if VAT category code (IBT-118) equal to "Z".</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-Z-09">

            VAT breakdown (IBG-23) – Category 'Z' (Zero rated)

            Found:
            - VAT amount (IBT-117): '<xsl:text/>
                  <xsl:value-of select="cbc:TaxAmount"/>
                  <xsl:text/>'

            Expected:
            VAT amount must be 0 for zero-rated supplies.

            Action:
            Set VAT amount to 0 for VAT category 'Z'.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory = 'S') or (                         cbc:TaxableAmount castable as xs:decimal and                          cac:TaxCategory/cbc:Percent castable as xs:decimal and                          u:slack(                             xs:decimal(cbc:TaxableAmount),                              xs:decimal(round((                                 sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory and xs:decimal(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) = xs:decimal(current()/cac:TaxCategory/cbc:Percent)]/cbc:LineExtensionAmount/xs:decimal(.)) +                                  sum($charges[cac:TaxCategory/cbc:ID = $vatCategory and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal(current()/cac:TaxCategory/cbc:Percent)]/cbc:Amount/xs:decimal(.)) -                                  sum($allowances[cac:TaxCategory/cbc:ID = $vatCategory and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal(current()/cac:TaxCategory/cbc:Percent)]/cbc:Amount/xs:decimal(.))                             ) * 100) div 100),                              0.02                         ))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory = 'S') or ( cbc:TaxableAmount castable as xs:decimal and cac:TaxCategory/cbc:Percent castable as xs:decimal and u:slack( xs:decimal(cbc:TaxableAmount), xs:decimal(round(( sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory and xs:decimal(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent) = xs:decimal(current()/cac:TaxCategory/cbc:Percent)]/cbc:LineExtensionAmount/xs:decimal(.)) + sum($charges[cac:TaxCategory/cbc:ID = $vatCategory and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal(current()/cac:TaxCategory/cbc:Percent)]/cbc:Amount/xs:decimal(.)) - sum($allowances[cac:TaxCategory/cbc:ID = $vatCategory and xs:decimal(cac:TaxCategory/cbc:Percent) = xs:decimal(current()/cac:TaxCategory/cbc:Percent)]/cbc:Amount/xs:decimal(.)) ) * 100) div 100), 0.02 ))">
               <xsl:attribute name="id">ALIGNED-IBRP-S-08-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-S-08-OM] - For each different value of VAT category rate (IBT-119) where the VAT category code (IBT-118) is "S", the VAT category taxable amount (IBT-116) in a VAT breakdown (IBG-23) MUST equal the sum of Invoice line net amounts (IBT-131) plus the sum of document level charge amounts (IBT-99) minus the sum of document level allowance amounts (IBT-92) where the VAT category code (IBT-151, IBT-102, IBT-095) is "S" and the VAT rate (IBT-152, IBT-103, IBT-096) equals the VAT category rate (IBT-119).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-S-08">

            VAT breakdown (IBG-23) – Category 'S' (Standard rated)

            Found:
            - Taxable amount (IBT-116): '<xsl:text/>
                  <xsl:value-of select="cbc:TaxableAmount"/>
                  <xsl:text/>'
            - VAT rate (IBT-119): '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'

            Expected:
            Taxable amount must equal the sum of invoice line net amounts for VAT category 'S'.

            Action:
            Verify that all invoice lines with VAT category 'S' are correctly aggregated into the VAT breakdown.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory = 'S') or (                         cbc:TaxAmount castable as xs:decimal and                          u:slack(                             xs:decimal(cbc:TaxAmount),                             xs:decimal(round((                                 sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory]/cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount/xs:decimal(.)) +                                  sum(for $c in $charges[cac:TaxCategory/cbc:ID = $vatCategory and cac:TaxCategory/cbc:Percent castable as xs:decimal] return xs:decimal($c/cbc:Amount) * xs:decimal($c/cac:TaxCategory/cbc:Percent) div 100) -                                  sum(for $a in $allowances[cac:TaxCategory/cbc:ID = $vatCategory and cac:TaxCategory/cbc:Percent castable as xs:decimal] return xs:decimal($a/cbc:Amount) * xs:decimal($a/cac:TaxCategory/cbc:Percent) div 100)                             ) * 100) div 100),                             0.02                         ))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory = 'S') or ( cbc:TaxAmount castable as xs:decimal and u:slack( xs:decimal(cbc:TaxAmount), xs:decimal(round(( sum($lines[cac:Item/cac:ClassifiedTaxCategory/cbc:ID = $vatCategory]/cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount/xs:decimal(.)) + sum(for $c in $charges[cac:TaxCategory/cbc:ID = $vatCategory and cac:TaxCategory/cbc:Percent castable as xs:decimal] return xs:decimal($c/cbc:Amount) * xs:decimal($c/cac:TaxCategory/cbc:Percent) div 100) - sum(for $a in $allowances[cac:TaxCategory/cbc:ID = $vatCategory and cac:TaxCategory/cbc:Percent castable as xs:decimal] return xs:decimal($a/cbc:Amount) * xs:decimal($a/cac:TaxCategory/cbc:Percent) div 100) ) * 100) div 100), 0.02 ))">
               <xsl:attribute name="id">ALIGNED-IBRP-S-09-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-S-09-OM] - The VAT category tax amount (IBT-117) in a VAT breakdown (IBG-23) where VAT category code (IBT-118) is "S" MUST equal the Σ Invoice line VAT amount (BTOM-016) where Invoiced item VAT category code (IBT-151) is "S"</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-S-09">

            VAT breakdown (IBG-23) – Category 'S' (Standard rated)

            Found:
            - VAT amount (IBT-117): '<xsl:text/>
                  <xsl:value-of select="cbc:TaxAmount"/>
                  <xsl:text/>'
            - VAT rate (IBT-119): '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'

            Expected:
            VAT amount must equal taxable amount multiplied by VAT rate, including correct rounding.

            Action:
            Recalculate VAT amount using (Taxable Amount × VAT Rate ÷ 100) and apply correct rounding.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory='S')                     or (not(cac:TaxCategory/cbc:TaxExemptionReasonCode)                         and not(cac:TaxCategory/cbc:TaxExemptionReason))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory='S') or (not(cac:TaxCategory/cbc:TaxExemptionReasonCode) and not(cac:TaxCategory/cbc:TaxExemptionReason))">
               <xsl:attribute name="id">ALIGNED-IBRP-S-10-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-S-10-OM] - A VAT breakdown (IBG-23) with VAT Category code (IBT-118) "S" MUST not have a VAT exemption reason code (IBT-121) or VAT exemption reason text (IBT-120).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-S-10">

            VAT category (IBT-118) – 'S' (Standard rated)

            Found:
            - VAT exemption reason: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:TaxExemptionReasonCode"/>
                  <xsl:text/>'

            Expected:
            VAT exemption reason must not be provided for standard-rated supplies.

            Action:
            Remove the VAT exemption reason for VAT category 'S'.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory='S')                     or (                         $rate castable as xs:decimal                         and xs:decimal($rate) = 5                     )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory='S') or ( $rate castable as xs:decimal and xs:decimal($rate) = 5 )">
               <xsl:attribute name="id">IBR-053-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-053-OM] - In a VAT breakdown (IBG-23) where the VAT category code (IBT-118) is 'S' (Standard rated), the VAT category rate (IBT-119) MUST be 5.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-053">

            Invalid VAT rate for standard VAT breakdown.

            Found: 
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT rate must be 5 for standard VAT breakdown.

            Fix: Set the VAT rate to 5%.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory='O') or not(cac:TaxCategory/cbc:Percent)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory='O') or not(cac:TaxCategory/cbc:Percent)">
               <xsl:attribute name="id">IBR-061-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-061-OM] - In a VAT breakdown (IBG-23) where VAT category code (IBT-118) is 'O', VAT category tax Rate (IBT-119) shall not be provided.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-061">

            Context: VAT category 'Not subject to VAT' must not carry a VAT rate.

            Found: VAT rate is present for VAT category 'Not subject to VAT'.

            Expected: VAT rate must be absent when VAT category indicates 'Not subject to VAT'.

            Action: Remove the VAT rate value or correct the VAT category if the transaction is taxable.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory='E') or not(cac:TaxCategory/cbc:Percent)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory='E') or not(cac:TaxCategory/cbc:Percent)">
               <xsl:attribute name="id">IBR-067-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-067-OM] - In a VAT breakdown (IBG-23) where VAT category code (IBT-118) is 'E', VAT category VAT Rate (IBT-119) shall not be provided.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-067">

            VAT rate must not be provided for exempt VAT category.

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT rate must be absent when VAT category is 'E' (Exempt).

            Fix: Remove the VAT rate value.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory='E' or $vatCategory='Z')                     or cac:TaxCategory/cbc:TaxExemptionReasonCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory='E' or $vatCategory='Z') or cac:TaxCategory/cbc:TaxExemptionReasonCode">
               <xsl:attribute name="id">IBR-069-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-069-OM] - A VAT breakdown (IBG-23) with VAT category code (IBT-118) 'E' (Exempt) or 'Z' (Zero rated) MUST have a VAT exemption reason code (IBT-121).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-069">

            Missing VAT exemption reason.

            Found:
            - ExemptionReasonCode: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:TaxExemptionReasonCode"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT exemption reason must be provided for categories 'E' (Exempt) or 'Z' (Zero-rated).

            Fix: Populate the exemption reason field.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory='O')                     or not(cac:TaxCategory/cbc:TaxExemptionReasonCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory='O') or not(cac:TaxCategory/cbc:TaxExemptionReasonCode)">
               <xsl:attribute name="id">IBR-070-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-070-OM] - A VAT breakdown (IBG-23) with VAT category code (IBT-118) 'O' (Not subject to VAT) MUST NOT have a VAT exemption reason code (IBT-121).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-070">

            Invalid VAT exemption for category 'O'.

            Found:
            - ExemptionReasonCode: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:TaxExemptionReasonCode"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT exemption details must not be provided for category 'O' (Outside scope).

            Fix: Remove any VAT exemption reason or code.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory='S')                     or (                         cac:TaxCategory/cbc:Percent castable as xs:decimal                         and xs:decimal(cac:TaxCategory/cbc:Percent) = 5                     )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory='S') or ( cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 5 )">
               <xsl:attribute name="id">IBR-104-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-104-OM] - In a VAT breakdown (IBG-23) for VAT accounting currency, where the VAT category code (IBT-118) is 'S', the VAT category rate (IBT-119) MUST be 5.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-104">

            Invalid VAT rate for standard-rated VAT category.

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT rate must be 5 when VAT category is 'S' (Standard-rated).

            Fix: Set the VAT rate to 5%.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($taxCurrency != '' and $isTaxCurrency and $cat='E') or not(cac:TaxCategory/cbc:Percent)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($taxCurrency != '' and $isTaxCurrency and $cat='E') or not(cac:TaxCategory/cbc:Percent)">
               <xsl:attribute name="id">IBR-095-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-095-OM] - If category is 'E' in accounting currency, rate MUST not be present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-095">

            Invalid VAT rate in accounting currency (VAT category 'E' – Exempt).

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT rate must not be provided for exempt VAT breakdown entries.

            Fix: Remove the VAT rate value.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($taxCurrency != '' and $isTaxCurrency and $cat='O')                     or not(cac:TaxCategory/cbc:Percent)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($taxCurrency != '' and $isTaxCurrency and $cat='O') or not(cac:TaxCategory/cbc:Percent)">
               <xsl:attribute name="id">IBR-096-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-096-OM] - If the TAX category code for tax category tax amount in accounting currency (IBT-192) is 'O', then the TAX category rate (IBT-193) MUST NOT be present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-096">

            Invalid VAT rate in accounting currency (VAT category 'O' – Outside scope).

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT rate must not be provided for VAT breakdown entries outside the scope of VAT.

            Fix: Remove the VAT rate value.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($taxCurrency != '' and $isTaxCurrency and $cat='O')                      or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($taxCurrency != '' and $isTaxCurrency and $cat='O') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 0)">
               <xsl:attribute name="id">IBR-097-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-097-OM] - If category is 'Z' in accounting currency, rate MUST be 0.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-097">

            Invalid VAT rate in accounting currency (VAT category 'Z' – Zero-rated).

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT rate must be 0 for zero-rated VAT breakdown entries.

            Fix: Set the VAT rate to 0.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'true'] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']"
                 priority="1007"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'true'] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = 'true']"/>
      <xsl:variable name="cat" select="normalize-space(cac:TaxCategory/cbc:ID)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                       or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric) or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))">
               <xsl:attribute name="id">ALIGNED-IBRP-058</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-058] - Either both or neither Charge base amount (IBT-100) and percentage (IBT-101) MUST be provided..</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-057">

            Context: Allowance/Charge calculation requires consistent parameters for correct invoice computation.

            Found:
            - Base amount (IBT-093) = '<xsl:text/>
                  <xsl:value-of select="cbc:BaseAmount"/>
                  <xsl:text/>'
            - Percentage (IBT-094) = '<xsl:text/>
                  <xsl:value-of select="cbc:MultiplierFactorNumeric"/>
                  <xsl:text/>'

            Expected: Either both base amount and percentage must be provided, or both must be absent.

            Action: Provide both values for calculation or remove both to avoid inconsistent allowance/charge logic.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cbc:AllowanceChargeReasonCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="cbc:AllowanceChargeReasonCode">
               <xsl:attribute name="id">IBR-042-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-042-OM] - If Document level charge (IBG-21) is present, document level charge reason code MUST be present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-042">

            Context: Charge reason classification requires a valid code from the UNCL7161 code list.

            Found: Missing charge reason code.

            Expected: A valid charge reason code must be present and conform to UNCL7161.

            Action: Populate the charge reason code using an appropriate value from UNCL7161 code list.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($cat='S') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 5)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($cat='S') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 5)">
               <xsl:attribute name="id">IBR-045-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-045-OM] - If Document level charge TAX category code (IBT-102) is 'S', Document level charge TAX rate (IBT-103) MUST be 5.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-045">

            Context: Standard-rated VAT charges must use a fixed VAT rate.

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'

            Expected: VAT rate must be exactly 5% for standard-rated charges.

            Action: Set VAT rate to 5% or revise tax category if misclassified.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($cat=('E','Z')) or cac:TaxCategory/cbc:TaxExemptionReasonCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($cat=('E','Z')) or cac:TaxCategory/cbc:TaxExemptionReasonCode">
               <xsl:attribute name="id">IBR-064-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-064-OM] - Document level charge (IBG-21) with Document level charge VAT category code (IBT-102) as 'E' or 'Z' MUST have a Document level charge VAT exemption reason code (IBT-198).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-064">

            Context: VAT exemption justification is required for exempt or zero-rated charges.

            Found: Missing VAT exemption reason for charge.

            Expected: VAT exemption reason must be provided when VAT category is 'E' (Exempt) or 'Z' (Zero-rated).

            Action: Populate a valid VAT exemption reason code or description for the charge.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($cat='E') or not(cac:TaxCategory/cbc:Percent)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($cat='E') or not(cac:TaxCategory/cbc:Percent)">
               <xsl:attribute name="id">IBR-098-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-098-OM] - If Document level charge TAX category code (IBT-102) is 'E', Document level charge TAX rate (IBT-103) MUST not be present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-098">

            Invalid VAT rate for charge (VAT category 'E' – Exempt).

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT rate must not be provided for exempt charges.

            Fix: Remove the VAT rate value.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($cat='O') or not(cac:TaxCategory/cbc:Percent)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($cat='O') or not(cac:TaxCategory/cbc:Percent)">
               <xsl:attribute name="id">IBR-099-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-099-OM] - If Document level charge TAX category code (IBT-102) is 'O', Document level charge TAX rate (IBT-103) MUST not be present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-099">

            Invalid VAT rate for charge (VAT category 'O' – Outside scope).

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT rate must not be provided for charges outside the scope of VAT.

            Fix: Remove the VAT rate value.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($cat='Z') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($cat='Z') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 0)">
               <xsl:attribute name="id">IBR-100-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-100-OM] - If Document level charge TAX category code (IBT-102) is 'Z', Document level charge TAX rate (IBT-103) MUST be 0.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-100">

            Invalid VAT rate for charge (VAT category 'Z' – Zero-rated).

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT rate must be 0 for zero-rated charges.

            Fix: Set the VAT rate to 0.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'false'] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']"
                 priority="1006"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator = 'false'] | cn:CreditNote/cac:AllowanceCharge[cbc:ChargeIndicator = 'false']"/>
      <xsl:variable name="cat" select="normalize-space(cac:TaxCategory/cbc:ID)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric) or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric) or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))">
               <xsl:attribute name="id">ALIGNED-IBRP-057</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-057] - Either both or neither Allowance base amount (IBT-093) and percentage (IBT-094) MUST be provided.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-057">

            Context: Allowance/Charge calculation requires consistent parameters for correct invoice computation.

            Found:
            - Base amount (IBT-093) = '<xsl:text/>
                  <xsl:value-of select="cbc:BaseAmount"/>
                  <xsl:text/>'
            - Percentage (IBT-094) = '<xsl:text/>
                  <xsl:value-of select="cbc:MultiplierFactorNumeric"/>
                  <xsl:text/>'

            Expected: Either both base amount and percentage must be provided, or both must be absent.

            Action: Provide both values for calculation or remove both to avoid inconsistent allowance/charge logic.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                         or                         (                             cbc:Amount castable as xs:decimal                             and cbc:BaseAmount castable as xs:decimal                             and cbc:MultiplierFactorNumeric castable as xs:decimal                             and                             u:slack(                                 xs:decimal(cbc:Amount),                                  xs:decimal(                                     round(                                         (                                             xs:decimal(cbc:BaseAmount)                                             * xs:decimal(cbc:MultiplierFactorNumeric)                                             div 100                                         ) * 100                                     ) div 100                                 ),                                  0.02                             )                         )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(cbc:BaseAmount and cbc:MultiplierFactorNumeric) or ( cbc:Amount castable as xs:decimal and cbc:BaseAmount castable as xs:decimal and cbc:MultiplierFactorNumeric castable as xs:decimal and u:slack( xs:decimal(cbc:Amount), xs:decimal( round( ( xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric) div 100 ) * 100 ) div 100 ), 0.02 ) )">
               <xsl:attribute name="id">IBR-033-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-033-OM] - Allowance amount (IBT-092, IBT-136) must equal base amount (IBT-093, IBT-137) * percentage (IBT-094, IBT-138) /100 if base amount and percentage exists.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-033">

            Allowance calculation validation

            Found:
            - Base: '<xsl:text/>
                  <xsl:value-of select="cbc:BaseAmount"/>
                  <xsl:text/>'
            - Percentage: '<xsl:text/>
                  <xsl:value-of select="cbc:MultiplierFactorNumeric"/>
                  <xsl:text/>'
            - Amount: '<xsl:text/>
                  <xsl:value-of select="cbc:Amount"/>
                  <xsl:text/>'

            Expected:
            Amount must equal Base × (Percentage / 100).

            Action:
            Recalculate allowance/charge amount using correct formula and rounding rules.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($cat='S') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 5)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($cat='S') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 5)">
               <xsl:attribute name="id">IBR-047-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-047-OM] - If Document level allowance TAX category code (IBT-095) is 'S', Document level allowance TAX rate (IBT-096) MUST be 5.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-047">

            Context: Standard-rated allowances must follow VAT rate consistency rules.

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'

            Expected: VAT rate must be exactly 5% for standard-rated allowances.

            Action: Set VAT rate to 5% or ensure allowance is correctly classified.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($cat=('E','Z')) or cac:TaxCategory/cbc:TaxExemptionReasonCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($cat=('E','Z')) or cac:TaxCategory/cbc:TaxExemptionReasonCode">
               <xsl:attribute name="id">IBR-062-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-062-OM] - Document level allowances (IBG-20) with Document level allowance VAT category code (IBT-095) as 'E' or 'Z' MUST have a Document level allowance VAT exemption reason code (IBT-196)</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-062">

            Context: VAT exemption justification is mandatory for exempt or zero-rated transactions.

            Found: Missing VAT exemption reason for allowance.

            Expected: VAT exemption reason must be provided when VAT category is 'E' (Exempt) or 'Z' (Zero-rated).

            Action: Populate a valid VAT exemption reason code or description for the allowance.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($cat='E') or not(cac:TaxCategory/cbc:Percent)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($cat='E') or not(cac:TaxCategory/cbc:Percent)">
               <xsl:attribute name="id">IBR-092-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-092-OM] - If Document level allowance TAX category code (IBT-095) is 'E', Document level allowance TAX rate (IBT-096) MUST not be present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-092">

            Invalid VAT rate for allowance (VAT category 'E' – Exempt).

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT rate must not be provided for exempt allowances.

            Fix: Remove the VAT rate value.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($cat='O') or not(cac:TaxCategory/cbc:Percent)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($cat='O') or not(cac:TaxCategory/cbc:Percent)">
               <xsl:attribute name="id">IBR-093-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-093-OM] - If Document level allowance TAX category code (IBT-095) is 'O', Document level allowance TAX rate (IBT-096) MUST not be present.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-093">

            Invalid VAT rate for allowance (VAT category 'O' – Outside scope).

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT rate must not be provided for allowances outside the scope of VAT.

            Fix: Remove the VAT rate value.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($cat='Z') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 0)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($cat='Z') or (cac:TaxCategory/cbc:Percent castable as xs:decimal and xs:decimal(cac:TaxCategory/cbc:Percent) = 0)">
               <xsl:attribute name="id">IBR-094-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-094-OM] - If Document level allowance TAX category code (IBT-095) is 'Z', Document level allowance TAX rate (IBT-096) MUST be 0.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-094">

            Invalid VAT rate for allowance (VAT category 'Z' – Zero-rated).

            Found:
            - Percent: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:TaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT rate must be 0 for zero-rated allowances.

            Fix: Set the VAT rate to 0.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="ubl:Invoice/cac:AllowanceCharge | cn:CreditNote/cac:AllowanceCharge"
                 priority="1005"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Invoice/cac:AllowanceCharge | cn:CreditNote/cac:AllowanceCharge"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:MultiplierFactorNumeric) or cbc:BaseAmount"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(cbc:MultiplierFactorNumeric) or cbc:BaseAmount">
               <xsl:attribute name="id">IBR-041-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-041-OM] - Document level allowance/charge base amount (IBT-093, IBT-100) must be provided when Invoice line allowance/charge percentage (IBT-094, IBT-101) is provided.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                             or                             (                                 cbc:Amount castable as xs:decimal                                 and cbc:BaseAmount castable as xs:decimal                                 and cbc:MultiplierFactorNumeric castable as xs:decimal                                 and                                 u:slack(                                     xs:decimal(cbc:Amount),                                      xs:decimal(                                         round(                                             (                                                 xs:decimal(cbc:BaseAmount)                                                 * xs:decimal(cbc:MultiplierFactorNumeric)                                                 div 100                                             ) * 100                                         ) div 100                                     ),                                      0.02                                 )                             )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(cbc:BaseAmount and cbc:MultiplierFactorNumeric) or ( cbc:Amount castable as xs:decimal and cbc:BaseAmount castable as xs:decimal and cbc:MultiplierFactorNumeric castable as xs:decimal and u:slack( xs:decimal(cbc:Amount), xs:decimal( round( ( xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric) div 100 ) * 100 ) div 100 ), 0.02 ) )">
               <xsl:attribute name="id">IBR-063-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-063-OM] - Charge amount (IBT-099, IBT-141) must equal base amount (IBT-100, IBT-142) * percentage (IBT-101, IBT-143) /100 if base amount and percentage exists</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge | cn:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge"
                 priority="1004"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge | cn:CreditNote/cac:CreditNoteLine/cac:AllowanceCharge"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cbc:MultiplierFactorNumeric) or cbc:BaseAmount"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(cbc:MultiplierFactorNumeric) or cbc:BaseAmount">
               <xsl:attribute name="id">IBR-035-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-035-OM] - Invoice line allowance/charge base amount (IBT-137, IBT-142) must be provided when Invoice line allowance/charge percentage (IBT-138, IBT-143) is provided.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-035">

            Conditional base amount requirement

            Found:
            Percentage: '<xsl:text/>
                  <xsl:value-of select="cbc:MultiplierFactorNumeric"/>
                  <xsl:text/>'

            Expected:
            Base amount must be present when a percentage is provided.

            Action:
            Provide cbc:BaseAmount when cbc:MultiplierFactorNumeric is used.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                     or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric) or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))">
               <xsl:attribute name="id">IBR-074-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-074-OM] - Either both or neither Charge base amount (IBT-142) and percentage (IBT-143) MUST be provided</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-074">

            Context: Allowance calculation parameter consistency validation (duplicate rule of IBR-073).

            Found: Incomplete or inconsistent allowance calculation parameters.

            Expected: Base amount (cbc:BaseAmount) and percentage (cbc:MultiplierFactorNumeric) must either both be present or both be absent.

            Action: Ensure consistency by either providing both base amount and percentage for allowance calculation, or removing both to indicate non-calculated allowance.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric)                     or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(cbc:BaseAmount and cbc:MultiplierFactorNumeric) or (not(cbc:BaseAmount) and not(cbc:MultiplierFactorNumeric))">
               <xsl:attribute name="id">IBR-073-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-073-OM] - Either both or neither Allowance base amount (IBT-137) and percentage (IBT-138) MUST be provided.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-073">

            Context: Allowance calculation parameter consistency validation.

            Found: Incomplete or inconsistent allowance calculation parameters.

            Expected: Base amount (cbc:BaseAmount) and percentage (cbc:MultiplierFactorNumeric) must either both be present or both be absent.

            Action: Ensure consistency by either providing both base amount and percentage for allowance calculation, or removing both to indicate non-calculated allowance.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="cbc:Percent" priority="1003" mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:Percent"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(.), '^\d+(\.\d{1,2})?$')                      and (if (. castable as xs:decimal) then (xs:decimal(.) &gt;= 0 and xs:decimal(.) &lt;= 100) else false())"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(.), '^\d+(\.\d{1,2})?$') and (if (. castable as xs:decimal) then (xs:decimal(.) &gt;= 0 and xs:decimal(.) &lt;= 100) else false())">
               <xsl:attribute name="id">IBR-046-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-046-OM] - The VAT rates (IBT-096, IBT-103, IBT-119, IBT-152, IBT-193) if exists MUST only be numeric (without percentage symbol) ranging from 0.00 to 100.00, with maximum of two decimals.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-046">

            Context: VAT rate value validation for all tax categories.

            Found: '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>' is not a valid VAT rate.

            Expected: VAT rate must be numeric between 0 and 100 with up to two decimal places.

            Action: Provide a valid numeric VAT rate within allowed range and precision constraints.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="             cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID             | cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID             | cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID             "
                 priority="1002"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="             cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID             | cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID             | cac:AccountingSupplierParty/cac:Party/cac:AgentParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID             "/>
      <xsl:variable name="cleanID" select="replace(normalize-space(.), '\s+', '')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches($cleanID, '^OM[0-9]{10}$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches($cleanID, '^OM[0-9]{10}$')">
               <xsl:attribute name="id">IBR-003-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>VAT identifier must be 12 characters, starting with 'OM' followed by 10 digits.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-003">

            VAT identifier (IBT-031)

            Found:
            '<xsl:text/>
                  <xsl:value-of select="."/>
                  <xsl:text/>'

            Expected:
            12 alphanumeric characters starting with 'OM'.

            Action:
            Provide a valid VAT identifier (e.g., OMXXXXXXXXXX).
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="cac:ClassifiedTaxCategory | cac:TaxCategory | cac:PartyTaxScheme"
                 priority="1001"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:ClassifiedTaxCategory | cac:TaxCategory | cac:PartyTaxScheme"/>
      <xsl:variable name="isSupplier"
                    select="exists(ancestor::cac:AccountingSupplierParty)"/>
      <xsl:variable name="isBuyer" select="exists(ancestor::cac:AccountingCustomerParty)"/>
      <xsl:variable name="fullXPath"
                    select="string-join(for $node in ancestor-or-self::* return local-name($node), '/')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (local-name() = 'TaxCategory')                              then (cac:TaxScheme/cbc:ID = 'VAT')                         else if ($isBuyer)                             then (count(../cac:PartyTaxScheme) = 1 and cac:TaxScheme/cbc:ID = 'VAT')                         else if ($isSupplier)                             then (                                 (cac:TaxScheme/cbc:ID = 'VAT' or ../cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = 'VAT') and                                 (if (cac:TaxScheme/cbc:ID = 'VAT') then count(../cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']) = 1 else true())                             )                         else (cac:TaxScheme/cbc:ID = 'VAT')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if (local-name() = 'TaxCategory') then (cac:TaxScheme/cbc:ID = 'VAT') else if ($isBuyer) then (count(../cac:PartyTaxScheme) = 1 and cac:TaxScheme/cbc:ID = 'VAT') else if ($isSupplier) then ( (cac:TaxScheme/cbc:ID = 'VAT' or ../cac:PartyTaxScheme/cac:TaxScheme/cbc:ID = 'VAT') and (if (cac:TaxScheme/cbc:ID = 'VAT') then count(../cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']) = 1 else true()) ) else (cac:TaxScheme/cbc:ID = 'VAT')">
               <xsl:attribute name="id">IBR-009-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-009-OM] - Tax scheme code, must provided in IBT-031-1 or BTOM-006-1 or IBT-048-1 or IBT-095-1 or IBT-102-1 or IBT-118-1 or IBT-167 and shall be 'VAT'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-009">

            Tax Scheme Validation Error.
            
            Exact Path: /<xsl:text/>
                  <xsl:value-of select="$fullXPath"/>
                  <xsl:text/>
            Scheme Found: '<xsl:text/>
                  <xsl:value-of select="cac:TaxScheme/cbc:ID"/>
                  <xsl:text/>'
            
            Context:
            - If Supplier: One VAT scheme is mandatory; duplicates are forbidden.
            - If Buyer: Exactly one scheme is allowed, and it must be VAT.
            - If Category: Must be VAT.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="cac:InvoiceLine | cac:CreditNoteLine"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:InvoiceLine | cac:CreditNoteLine"/>
      <xsl:variable name="vatCategory"
                    select="normalize-space(cac:Item/cac:ClassifiedTaxCategory/cbc:ID)"/>
      <xsl:variable name="vatRate"
                    select="if (cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/normalize-space(.) castable as xs:decimal)                          then xs:decimal(cac:Item/cac:ClassifiedTaxCategory/cbc:Percent)                          else 0"/>
      <xsl:variable name="lineTaxAmount"
                    select="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory='E')                   or not($vatRate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory='E') or not($vatRate)">
               <xsl:attribute name="id">ALIGNED-IBRP-E-05-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-E-05-OM] - In an Invoice line (IBG-25) where the Invoiced item VAT category code (IBT-151) is "E" MUST not contain an Invoice item VAT rate (IBT-152).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-E-05">

            Context: VAT category 'E' (Exempt) must not carry any VAT percentage at line level.

            Found:
            Invoice line ID: '<xsl:text/>
                  <xsl:value-of select="cbc:ID"/>
                  <xsl:text/>'
            VAT category (IBT-151): '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>
                  <xsl:text/>'
            VAT rate (IBT-152): '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>
                  <xsl:text/>'

            Expected: VAT rate must be absent for VAT category 'E'.

            Action: Remove VAT rate for VAT category 'E' or correct VAT classification if rate is required.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory='O')                   or not($vatRate)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory='O') or not($vatRate)">
               <xsl:attribute name="id">ALIGNED-IBRP-O-05-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-O-05-OM] - An Invoice line (IBG-25) where the VAT category code (IBT-151) is "O" MUST not contain an Invoiced item VAT rate (IBT-152).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-O-05">

            Context: VAT category 'O' (Out of scope) must not include a VAT percentage at line level.

            Found: VAT rate (IBT-152) = '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>
                  <xsl:text/>'.

            Expected: No VAT rate must be provided for VAT category 'O'.

            Action: Remove VAT rate for VAT category 'O' or reclassify VAT category if taxable.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory='E')                   or $lineTaxAmount = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory='E') or $lineTaxAmount = 0">
               <xsl:attribute name="id">IBR-039-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-039-OM] - In Line VAT information (IBG-30) where Invoiced item VAT category code (IBT-151) is 'Exempt', Line Item VAT Amount (BTOM-016) shall be zero.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-039">

            Exempt VAT validation

            Found:
            - VAT amount: '<xsl:text/>
                  <xsl:value-of select="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>
                  <xsl:text/>'
            - Category: '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>
                  <xsl:text/>'

            Expected:
            VAT amount must be 0 for exempt supplies.

            Action:
            Set VAT amount to 0 for exempt items.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory='O')                   or $lineTaxAmount=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory='O') or $lineTaxAmount=0">
               <xsl:attribute name="id">IBR-054-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-054-OM] - In Line VAT information (IBG-30) where Invoiced item VAT category code (IBT-151) is 'Not Subject to VAT', Line Item VAT Amount (BTOM-016) shall be zero.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-054">

            Invalid VAT amount for 'Not subject to VAT'.

            Found: 
            - VAT amount: '<xsl:text/>
                  <xsl:value-of select="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT amount must be zero for items not subject to VAT.

            Fix: Set the VAT amount to 0.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode) or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID='HS'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode) or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID='HS'">
               <xsl:attribute name="id">IBR-056-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-056-OM] - The scheme identifier (ibt-158-1) MUST be 'HS' when Item classification identifier (ibt-158) is provided</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-056">

            Context: Item classification scheme must conform to the required product classification standard.

            Found: Item classification scheme = '<xsl:text/>
                  <xsl:value-of select="cbc:ItemClassificationCode/@listID"/>
                  <xsl:text/>'.

            Expected: Item classification scheme identifier must be 'HS' (Harmonized System classification).

            Action: Update the item classification scheme to 'HS' or ensure correct mapping from product master data.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$lineTaxAmount"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$lineTaxAmount">
               <xsl:attribute name="id">IBR-068-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-068-OM] - An Invoice must contain the total amount including VAT (BTOM-017) for each invoice line.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-068">

            Context: Line-level VAT amount validation for taxable invoice lines.

            Found: Missing VAT amount at line level (cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount).

            Expected: VAT amount must be provided at line level when VAT is applicable to the invoice line.

            Action: Populate the VAT amount for the invoice line, or ensure the VAT category indicates that VAT is not applicable if no VAT amount is required.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory = 'Z') or xs:decimal($vatRate) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory = 'Z') or xs:decimal($vatRate) = 0">
               <xsl:attribute name="id">ALIGNED-IBRP-Z-05-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[ALIGNED-IBRP-Z-05-OM] - In an Invoice line (IBG-25) where the Invoiced item VAT category code (IBT-151) is "Zero rated" the Invoiced item VAT rate (IBT-152) MUST be 0 (zero).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-Z-05">

            Context: VAT category 'Z' (Zero-rated) requires strict consistency between VAT category and VAT rate.

            Found: VAT rate (IBT-152) = '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>
                  <xsl:text/>' while VAT category (IBT-151) = 'Z'.

            Expected: When VAT category is 'Z' (Zero-rated), the VAT rate must be 0.

            Action: Set VAT rate to 0 or verify whether the VAT category has been incorrectly classified as zero-rated.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="lineExtensionAmount"
                    select="if (cbc:LineExtensionAmount/normalize-space(.) castable as xs:decimal)                          then xs:decimal(cbc:LineExtensionAmount)                          else 0"/>
      <xsl:variable name="quantity"
                    select="if ((cbc:InvoicedQuantity | cbc:CreditedQuantity)/normalize-space(.) castable as xs:decimal)                          then xs:decimal((cbc:InvoicedQuantity | cbc:CreditedQuantity)[1])                          else 1"/>
      <xsl:variable name="priceAmount"
                    select="if (cac:Price/cbc:PriceAmount/normalize-space(.) castable as xs:decimal)                          then xs:decimal(cac:Price/cbc:PriceAmount)                          else 0"/>
      <xsl:variable name="baseQuantity"
                    select="                 if (cac:Price/cbc:BaseQuantity/normalize-space(.) castable as xs:decimal                      and xs:decimal(normalize-space(cac:Price/cbc:BaseQuantity)) != 0)                  then xs:decimal(normalize-space(cac:Price/cbc:BaseQuantity))                  else 1"/>
      <xsl:variable name="allowancesTotal"
                    select="if (cac:AllowanceCharge[cbc:ChargeIndicator = 'false'])                          then round(sum(                             for $amt in cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:Amount                             return if ($amt castable as xs:decimal) then xs:decimal($amt) else 0                         ) * 100) div 100                         else 0"/>
      <xsl:variable name="chargesTotal"
                    select="if (cac:AllowanceCharge[cbc:ChargeIndicator = 'true'])                          then round(sum(                             for $amt in cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:Amount                             return if ($amt castable as xs:decimal) then xs:decimal($amt) else 0                         ) * 100) div 100                         else 0"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="u:slack(                         u:to-decimal($lineExtensionAmount),                          u:to-decimal(($quantity * (u:to-decimal($priceAmount) div $baseQuantity)) + $chargesTotal - $allowancesTotal),                          0.02)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="u:slack( u:to-decimal($lineExtensionAmount), u:to-decimal(($quantity * (u:to-decimal($priceAmount) div $baseQuantity)) + $chargesTotal - $allowancesTotal), 0.02)">
               <xsl:attribute name="id">IBR-071-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-071-OM] - Invoice line net amount (IBT-131) MUST equal (Invoiced quantity (IBT-129) * (Item net price (IBT-146)/item price base quantity (IBT-149)) + Sum of invoice line charge amount (IBT-141) - sum of invoice line allowance amount (IBT-136).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-071">

            Line net amount calculation mismatch.

            Provided (IBT-131): '<xsl:text/>
                  <xsl:value-of select="$lineExtensionAmount"/>
                  <xsl:text/>'
            Calculated: '<xsl:text/>
                  <xsl:value-of select="($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal"/>
                  <xsl:text/>'

            Details:
            - Quantity (IBT-129): '<xsl:text/>
                  <xsl:value-of select="$quantity"/>
                  <xsl:text/>'
            - Price (IBT-146): '<xsl:text/>
                  <xsl:value-of select="$priceAmount"/>
                  <xsl:text/>'
            - Base quantity (IBT-149): '<xsl:text/>
                  <xsl:value-of select="$baseQuantity"/>
                  <xsl:text/>'
            - Charges total (IBT-141): '<xsl:text/>
                  <xsl:value-of select="$chargesTotal"/>
                  <xsl:text/>'
            - Allowances total (IBT-136): '<xsl:text/>
                  <xsl:value-of select="$allowancesTotal"/>
                  <xsl:text/>'

            Expected: Line net amount must equal
            (Quantity * (Price + Base quantity)) + Charges - Allowances,
            within an allowed tolerance of 0.02.

            Fix: Recalculate the line net amount (IBT-131) using the above components and ensure it matches the expected value.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="grossPrice"
                    select="if (cac:Price/cbc:BaseAmount) then xs:decimal(cac:Price/cbc:BaseAmount) else 0"/>
      <xsl:variable name="discountTotal"
                    select="                 if (cac:Price/cac:AllowanceCharge/cbc:Amount)                 then sum(cac:Price/cac:AllowanceCharge/cbc:Amount/xs:decimal(.))                 else 0"/>
      <xsl:variable name="netPrice"
                    select="if (cac:Price/cbc:PriceAmount) then xs:decimal(cac:Price/cbc:PriceAmount) else 0"/>
      <xsl:variable name="expectedNetPrice"
                    select="                 if ($grossPrice)                 then round(($grossPrice - $discountTotal) * 100) div 100                 else 0"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($grossPrice) or $netPrice = $expectedNetPrice"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($grossPrice) or $netPrice = $expectedNetPrice">
               <xsl:attribute name="id">IBR-075-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-075-OM] - Item net price (IBT-146) MUST equal (Gross price (IBT-148) - Price discount (IBT-147)) when gross price is provided.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-075">

            Item net price calculation mismatch.

            Provided net price (IBT-146): '<xsl:text/>
                  <xsl:value-of select="$netPrice"/>
                  <xsl:text/>'
            Calculated net price: '<xsl:text/>
                  <xsl:value-of select="$expectedNetPrice"/>
                  <xsl:text/>'

            Details:
            - Gross price (IBT-148): '<xsl:text/>
                  <xsl:value-of select="$grossPrice"/>
                  <xsl:text/>'
            - Price discount total (IBT-147): '<xsl:text/>
                  <xsl:value-of select="$discountTotal"/>
                  <xsl:text/>'

            Expected: Net price must equal (Gross price − Discount),
            rounded to 2 decimal places.

            Fix: Recalculate IBT-146 using:
            (IBT-148 − IBT-147), and apply rounding to 2 decimals.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$vatCategory"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$vatCategory">
               <xsl:attribute name="id">IBR-076-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-076-OM] - Each Invoice line (IBG-25) MUST be categorized with an Invoiced item tax category code (IBT-151).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-076">

            Context: VAT category classification is required for invoice line taxation determination.

            Found: Missing VAT category code at invoice line level (cac:Item/cac:ClassifiedTaxCategory/cbc:ID).

            Expected: Each invoice line must include a VAT category code unless explicitly defined as out-of-scope or non-taxable under applicable VAT rules.

            Action: Populate the VAT category code for the invoice line or correct the tax treatment classification if the line is not subject to VAT.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($vatCategory='Z')                   or $lineTaxAmount=0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatCategory='Z') or $lineTaxAmount=0">
               <xsl:attribute name="id">IBR-077-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-077-OM] - In Line VAT information (IBG-30) where Invoiced item VAT category code (IBT-151) is 'Zero Rated', Line Item VAT Amount (BTOM-016) shall be zero.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-077">

            Invalid VAT amount for zero-rated item.

            Found:
            - VAT amount: '<xsl:text/>
                  <xsl:value-of select="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>
                  <xsl:text/>'.
            - Category code: '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>
                  <xsl:text/>'.

            Expected: VAT amount must be zero for zero-rated supplies.

            Fix: Set the VAT amount to 0.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                 $isSimplified                 or                 cac:Item/cac:CommodityClassification/cbc:NatureCode                 "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$isSimplified or cac:Item/cac:CommodityClassification/cbc:NatureCode">
               <xsl:attribute name="id">IBR-078-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-078-OM] - Item Type (BTOM-019) must be provided for each item (IBT-153) except when Invoice transaction type (BTOM-001) is 'Simplified Tax Invoice' (X1XXXXXXXXXXXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-078">

            Context: Item type classification is required for proper invoice line-level product identification.

            Found: Item type is missing or not provided at invoice line level (cac:Item/cac:CommodityClassification/cbc:NatureCode).

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Item type must be provided for standard invoice types unless the document is explicitly classified as a simplified invoice under applicable billing rules.

            Action: Populate the item type (commodity classification nature code) or verify that the invoice qualifies as a simplified invoice where item-level classification is not required.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$isSimplified                   or not(cac:Item/cac:CommodityClassification/cbc:NatureCode='GS')                   or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$isSimplified or not(cac:Item/cac:CommodityClassification/cbc:NatureCode='GS') or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode">
               <xsl:attribute name="id">IBR-079-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-079-OM] - When Item type (BTOM-019) is 'Goods' then Item classification identifier (ibt-158) must be provided except when Invoice transaction type (BTOM-001) is 'Simplified Tax Invoice' (X1XXXXXXXXXXXXXXXXXX)</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-079">

            Missing classification code for goods.

            Found:
            - Item type: '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:CommodityClassification/cbc:NatureCode"/>
                  <xsl:text/>'.
            - ClassificationCode: '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode"/>
                  <xsl:text/>'.

            Expected: Goods items must include a valid classification code.

            Fix: Provide the appropriate classification code for the goods item.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode)                   or string-length(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode) &gt;= 12"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode) or string-length(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode) &gt;= 12">
               <xsl:attribute name="id">IBR-080-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-080-OM] - The minimum number of digits to be provided should be '12' in Item classification identifier (ibt-158)</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-080">

            Context: Commodity classification code must comply with minimum structural requirements.

            Found: Classification code length = '<xsl:text/>
                  <xsl:value-of select="string-length(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode)"/>
                  <xsl:text/>'

            Expected: Classification code must be at least 12 digits in length and conform to the required industrial classification standard.

            Action: Provide a valid classification code with a minimum length of 12 digits or correct the mapping from the product master data source.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$isSimplified or $isImportGoods or $isImportRCM or $isProfitMargin                   or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$isSimplified or $isImportGoods or $isImportRCM or $isProfitMargin or cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode">
               <xsl:attribute name="id">IBR-081-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-081-OM] - Industrial Classification Code must be provided for each ITEM INFORMATION (IBG-31) except when Invoice transaction type (BTOM-001) is a simplified tax invoice (X1XXXXXXXXXXXXXXXXXX) and/or import of goods (XXXXXXXXXXXX1XXXXXXX) or import of service RCM (XXXXXXXX1XXXXXXXXXXX) or profit margin self invoice (XXXXXXXXXX1XXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-081">

            Context: Industrial classification code is required for item-level product classification.

            Found: Missing industrial classification code (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode).

            Expected: Industrial classification code must be provided where applicable according to product classification rules.

            Action: Populate the industrial classification code or verify whether the item is exempt from classification requirements.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isImportGoods)                   or cac:Item/cac:OriginCountry/cbc:IdentificationCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isImportGoods) or cac:Item/cac:OriginCountry/cbc:IdentificationCode">
               <xsl:attribute name="id">IBR-084-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-084-OM] - If invoice transaction type (BTOM-001) is 'Import of Goods' (XXXXXXXXXXXX1XXXXXXX) then Item country of origin (IBT-159) is mandatory.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-084">

            Context: Country of origin is mandatory for import transactions involving goods.

            Found: Country of origin missing or empty (cac:Item/cac:OriginCountry/cbc:IdentificationCode = '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:OriginCountry/cbc:IdentificationCode"/>
                  <xsl:text/>').

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Country of origin (IBT-159) must be provided for import-related transactions.

            Action: Populate the country of origin for the goods or verify whether the transaction is correctly classified as an import.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isProfitMargin)                   or $vatCategory='O'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isProfitMargin) or $vatCategory='O'">
               <xsl:attribute name="id">IBR-086-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-086-OM] - If Invoice transaction type (BTOM-001) is 'Profit Margin Self-Invoice ' (XXXXXXXXXX1XXXXXXXXX), Invoiced item VAT category code (IBT-151) MUST be 'O' (Not subject to VAT).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-086">

            Context: VAT category validation for profit margin scheme self-invoices.

            Found: VAT category = '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>
                  <xsl:text/>'

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: VAT category must be 'O' (Outside scope) for profit margin self-invoices.

            Action: Set VAT category code to 'O' or verify whether the transaction qualifies under profit margin scheme rules.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isProfitMargin)                   or not(starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'7101') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'7102') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'7103') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'7104') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'01') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'06'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isProfitMargin) or not(starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'7101') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'7102') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'7103') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'7104') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'01') or starts-with(cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode,'06'))">
               <xsl:attribute name="id">IBR-091-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-091-OM] - When Invoice transaction type (BTOM-001) is Profit margin invoice (XXXXXXXXX1XXXXXXXXXX), Item classification identifier (IBT-158) MUST NOT start with '7101' or '7102' or '7103' or '7104' or '01' or '06'.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-091">

            Invalid item classification code for profit margin invoice.

            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'
            Classification code (IBT-158): '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode"/>
                  <xsl:text/>'

            Expected: For profit margin transactions, the classification code must NOT start with any of the following prefixes:
            '7101', '7102', '7103', '7104', '01', '06'.

            Fix: Update the classification code so that it does not begin with a prohibited prefix for profit margin invoices.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isSummary)                   or (substring(cac:InvoicePeriod/cbc:StartDate,1,7)                       = substring(cac:InvoicePeriod/cbc:EndDate,1,7))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isSummary) or (substring(cac:InvoicePeriod/cbc:StartDate,1,7) = substring(cac:InvoicePeriod/cbc:EndDate,1,7))">
               <xsl:attribute name="id">IBR-057-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-057-OM] - Invoice line period start date (ibt-134) and Invoice line period end date (ibt-135) when provided must belong to the same calendar month.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-036">

            Invoicing period validation

            Found:
            - Start: '<xsl:text/>
                  <xsl:value-of select="cac:InvoicePeriod/cbc:StartDate"/>
                  <xsl:text/>'
            - End: '<xsl:text/>
                  <xsl:value-of select="cac:InvoicePeriod/cbc:EndDate"/>
                  <xsl:text/>'

            Expected:
            Start and end dates must be within the same calendar month.

            Action:
            Adjust invoicing period to a single month.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$isSimplified or $lineTaxAmount"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$isSimplified or $lineTaxAmount">
               <xsl:attribute name="id">IBR-038-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-038-OM] - Each Invoice/CreditNote line must contain Item VAT Amount (BTOM-016) except where invoice is a simplified tax invoice (BTOM-001).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-038">

            Line-level VAT validation

            Found:
            - VAT amount missing at line level

            Expected:
            VAT amount must be present unless invoice qualifies as simplified.

            Action:
            Provide VAT amount for each invoice line.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not($isFullTax and $isSummary)                   or cac:InvoicePeriod/cbc:StartDate                      and cac:InvoicePeriod/cbc:EndDate"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($isFullTax and $isSummary) or cac:InvoicePeriod/cbc:StartDate and cac:InvoicePeriod/cbc:EndDate">
               <xsl:attribute name="id">IBR-072-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-072-OM] - Invoice line period start date (IBT-134) and Invoice line period end date (IBT-135) must be provided if where Invoice transaction type (BTOM-001) is a Full Tax Invoice AND summary invoice (XXXX1XXXXXXXXXXXXXXX).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-072">

            Context: Invoice line period (IBG-26) validation for full and summary invoices.

            Found: Missing invoice line period (IBG-26).  
            Transaction type (BTOM-001): '<xsl:text/>
                  <xsl:value-of select="cbc:InvoiceTypeCode/@name | cbc:CreditNoteTypeCode/@name"/>
                  <xsl:text/>'

            Expected: Invoice line period (IBG-26) must be provided for full and summary invoice types, including start date (IBT-134) and end date (IBT-135) for each applicable invoice line.

            Action: Populate invoice line period (start and end dates) for each invoice line where required based on invoice type.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:Price/cac:AllowanceCharge/cbc:BaseAmount)                     or (                         cac:Price/cbc:PriceAmount castable as xs:decimal and                          cac:Price/cac:AllowanceCharge/cbc:BaseAmount castable as xs:decimal and                         u:slack(                             xs:decimal(cac:Price/cbc:PriceAmount),                             xs:decimal(                                 round(                                     (                                         xs:decimal(cac:Price/cac:AllowanceCharge/cbc:BaseAmount) -                                         sum(cac:Price/cac:AllowanceCharge/cbc:Amount/xs:decimal(.))                                     ) * 100                                 ) div 100                             ),                             0.02                         )                     )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(cac:Price/cac:AllowanceCharge/cbc:BaseAmount) or ( cac:Price/cbc:PriceAmount castable as xs:decimal and cac:Price/cac:AllowanceCharge/cbc:BaseAmount castable as xs:decimal and u:slack( xs:decimal(cac:Price/cbc:PriceAmount), xs:decimal( round( ( xs:decimal(cac:Price/cac:AllowanceCharge/cbc:BaseAmount) - sum(cac:Price/cac:AllowanceCharge/cbc:Amount/xs:decimal(.)) ) * 100 ) div 100 ), 0.02 ) )">
               <xsl:attribute name="id">IBR-157-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                [IBR-157-OM] - Item net price (IBT-146) must equal (gross price (IBT-148) minus discount (IBT-147)) when gross price is provided.
            </svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-157">

            Net price calculation mismatch.

            Found:
            - Gross price (IBT-148): '<xsl:text/>
                  <xsl:value-of select="cac:Price/cac:AllowanceCharge/cbc:BaseAmount"/>
                  <xsl:text/>'
            - Discount (IBT-147): '<xsl:text/>
                  <xsl:value-of select="sum(cac:Price/cac:AllowanceCharge/cbc:Amount)"/>
                  <xsl:text/>'
            - Net price (IBT-146): '<xsl:text/>
                  <xsl:value-of select="cac:Price/cbc:PriceAmount"/>
                  <xsl:text/>'

            Expected:
            Net price = Gross price - Discount

            Fix:
            Recalculate the net price to ensure:
            IBT-146 = IBT-148 - IBT-147
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                     not($vatRate)                     or                     (                         $lineTaxAmount castable as xs:decimal                         and cbc:LineExtensionAmount castable as xs:decimal                         and $vatRate castable as xs:decimal                         and                         u:slack(                             xs:decimal($lineTaxAmount),                             round(                                 (                                     xs:decimal(cbc:LineExtensionAmount)                                     * xs:decimal($vatRate)                                     div 100                                 ) * 100                             ) div 100,                             0.02                         )                     )                 "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not($vatRate) or ( $lineTaxAmount castable as xs:decimal and cbc:LineExtensionAmount castable as xs:decimal and $vatRate castable as xs:decimal and u:slack( xs:decimal($lineTaxAmount), round( ( xs:decimal(cbc:LineExtensionAmount) * xs:decimal($vatRate) div 100 ) * 100 ) div 100, 0.02 ) )">
               <xsl:attribute name="id">IBR-168-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-168-OM] - The Line Item VAT amount (BTOM-016) must be Invoiced item VAT rate (IBT-152) multiplied by Invoice Line Net Amount (IBT-131).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-168">

            Line VAT amount calculation mismatch.

            Found:
            - Line net amount (IBT-131): '<xsl:text/>
                  <xsl:value-of select="cbc:LineExtensionAmount"/>
                  <xsl:text/>'.
            - VAT rate (IBT-152): '<xsl:text/>
                  <xsl:value-of select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>
                  <xsl:text/>'.
            - VAT amount (BTOM-016): '<xsl:text/>
                  <xsl:value-of select="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>
                  <xsl:text/>'.

            Expected:
            VAT amount = Line net amount × VAT rate ÷ 100

            Fix:
            Recalculate VAT amount to ensure:
            BTOM-016 = IBT-131 × IBT-152 ÷ 100
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$isProfitMargin                         or (                             cac:ItemPriceExtension/cbc:Amount castable as xs:decimal                             and u:slack(                                 xs:decimal(cac:ItemPriceExtension/cbc:Amount),                                 xs:decimal(xs:decimal(cbc:LineExtensionAmount) + xs:decimal($lineTaxAmount)),                                 0.02                             )                         )"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$isProfitMargin or ( cac:ItemPriceExtension/cbc:Amount castable as xs:decimal and u:slack( xs:decimal(cac:ItemPriceExtension/cbc:Amount), xs:decimal(xs:decimal(cbc:LineExtensionAmount) + xs:decimal($lineTaxAmount)), 0.02 ) )">
               <xsl:attribute name="id">IBR-158-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-158-OM] - Total amount including VAT (BTOM-017) must be the sum of Invoice line net amount (IBT-131) and Line Item VAT amount (BTOM-016) unless if Invoice transaction type (BTOM-001) is Profit margin invoice (XXXXXXXXX1XXXXXXXXXX) in which case Total amount including VAT (BTOM-017) must be the total sale value of the item.</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-158">

            Total amount including VAT mismatch.

            Found:
            - Total including VAT (BTOM-017): '<xsl:text/>
                  <xsl:value-of select="cac:ItemPriceExtension/cbc:Amount"/>
                  <xsl:text/>'
            - Line net amount (IBT-131): '<xsl:text/>
                  <xsl:value-of select="cbc:LineExtensionAmount"/>
                  <xsl:text/>'
            - VAT amount (BTOM-016): '<xsl:text/>
                  <xsl:value-of select="cac:ItemPriceExtension/cac:TaxTotal/cbc:TaxAmount"/>
                  <xsl:text/>'

            Expected:
            Total including VAT = Line net amount + VAT amount

            Exception:
            This rule does not apply for profit margin invoices.

            Fix:
            Recalculate the total to ensure:
            BTOM-017 = IBT-131 + BTOM-016
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(cac:Item/cbc:ItemClassificationCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(cac:Item/cbc:ItemClassificationCode)">
               <xsl:attribute name="id">IBR-174-OM</xsl:attribute>
               <xsl:attribute name="flag">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-174-OM] - Item classification identifier (HS Code) (IBT-158) must be provided from the Harmonized System (HS) Code list published by the Royal Oman Police (Directorate General of Customs).</svrl:text>
               <svrl:diagnostic-reference diagnostic="d-IBR-174">

            Context: Item classification must comply with customs tariff classification requirements for import/export declarations.

            Found: Item classification code = '<xsl:text/>
                  <xsl:value-of select="cac:Item/cbc:ItemClassificationCode"/>
                  <xsl:text/>'

            Expected: Item classification identifier must be a valid Harmonized System (HS) code as required under Royal Oman Police customs classification rules.

            Action: Provide a valid HS classification code compliant with Royal Oman Police customs tariff structure or correct the product mapping in the item master data.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M44"/>
   </xsl:template>
   <!--PATTERN AlignedCodelists-->
   <!--RULE -->
   <xsl:template match="cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentStatusCode"
                 priority="1009"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentStatusCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' CAN VAT VAL QTY OTH ', concat(' ', normalize-space(.), ' '))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="((not(contains(normalize-space(.), ' ')) and contains(' CAN VAT VAL QTY OTH ', concat(' ', normalize-space(.), ' '))))">
               <xsl:attribute name="id">CL-02-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-02-OM] - Credit Note or Debit Note reason code (BTOM-032) must be coded using the code list for Codelist for reasons for issuance of credit note or debit note.</svrl:text>
               <svrl:diagnostic-reference diagnostic="CL-02-OM">

            Credit/Debit Note reason code (BTOM-032)
            
            Found:
            - Value: '<xsl:text/>
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:text/>'

            Expected:
            Code must be one of the following:

            - CAN
            - VAT
            - VAL
            - QTY
            - OTH

            Action:
            Use a valid reason code from the Credit/Debit Note reason codelist.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="cbc:InvoiceTypeCode[@name] | cbc:CreditNoteTypeCode[@name]"
                 priority="1008"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cbc:InvoiceTypeCode[@name] | cbc:CreditNoteTypeCode[@name]"/>
      <xsl:variable name="t" select="normalize-space(@name)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(substring($t,1,1)='1' and substring($t,2,1)='1')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(substring($t,1,1)='1' and substring($t,2,1)='1')">
               <xsl:attribute name="id">CL-03-OM-1</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-03-OM-1] - An invoice cannot be both a Full Tax Invoice (Bit 1) and a Simplified Invoice (Bit 2).</svrl:text>
               <svrl:diagnostic-reference diagnostic="CL-03-OM">

            Invoice transaction type (BTOM-001) logic error.
            
            Found: '<xsl:text/>
                  <xsl:value-of select="normalize-space(@name)"/>
                  <xsl:text/>'
            
            Requirements:
            - Position 1 (Full Tax) and Position 2 (Simplified) cannot both be '1'.
            - One of the first two positions MUST be '1'.
            - Combinations are allowed (e.g., Full Tax + Export + Continuous).
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="substring($t,1,1)='1' or substring($t,2,1)='1'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring($t,1,1)='1' or substring($t,2,1)='1'">
               <xsl:attribute name="id">CL-03-OM-2</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>CL-03-OM-2] - Invoice transaction type (BTOM-001) must indicate either a Full Tax Invoice (bit 1) or a Simplified Invoice (bit 2).</svrl:text>
               <svrl:diagnostic-reference diagnostic="CL-03-OM">

            Invoice transaction type (BTOM-001) logic error.
            
            Found: '<xsl:text/>
                  <xsl:value-of select="normalize-space(@name)"/>
                  <xsl:text/>'
            
            Requirements:
            - Position 1 (Full Tax) and Position 2 (Simplified) cannot both be '1'.
            - One of the first two positions MUST be '1'.
            - Combinations are allowed (e.g., Full Tax + Export + Continuous).
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID"
                 priority="1007"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:TaxCategory/cbc:ID | cac:ClassifiedTaxCategory/cbc:ID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' S E O Z ', concat(' ', normalize-space(.), ' '))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="((not(contains(normalize-space(.), ' ')) and contains(' S E O Z ', concat(' ', normalize-space(.), ' '))))">
               <xsl:attribute name="id">CL-04-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-04-OM] - Document level allowance TAX category code (IBT-095), Document level charge TAX category code (IBT-102), TAX category code for tax category tax amount in accounting currency (IBT-192), TAX category code (IBT-118), Invoiced item TAX category code (IBT-151), MUST all be coded using the code list for Invoice VAT Categories.</svrl:text>
               <svrl:diagnostic-reference diagnostic="CL-04-OM">

            VAT category code

            Found:
            - Value: '<xsl:text/>
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:text/>'

            Expected:
            Code must be one of the following:

            - S
            - E
            - O
            - Z

            Action:
            Use a valid VAT category code from the Invoice VAT Categories codelist.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="cac:TaxCategory/cbc:TaxExemptionReasonCode | cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode"
                 priority="1006"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:TaxCategory/cbc:TaxExemptionReasonCode | cac:ClassifiedTaxCategory/cbc:TaxExemptionReasonCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' VATZR-OM-01 VATZR-OM-02 VATZR-OM-03 VATZR-OM-04 VATZR-OM-05 VATZR-OM-06 VATZR-OM-07 VATZR-OM-08 VATZR-OM-09 VATZR-OM-10 VATZR-OM-11 VATZR-OM-12 VATZR-OM-13 VATZR-OM-14 VATZR-OM-15 VATZR-OM-16 VATEX-OM-01 VATEX-OM-02 VATEX-OM-03 VATEX-OM-04 VATEX-OM-05 VATEX-OM-06 VATEX-OM-07 VATEX-OM-08 VATEX-OM-09 VATEX-OM-10 VATEX-OM-11 VATEX-OM-12 ', concat(' ', normalize-space(.), ' '))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="((not(contains(normalize-space(.), ' ')) and contains(' VATZR-OM-01 VATZR-OM-02 VATZR-OM-03 VATZR-OM-04 VATZR-OM-05 VATZR-OM-06 VATZR-OM-07 VATZR-OM-08 VATZR-OM-09 VATZR-OM-10 VATZR-OM-11 VATZR-OM-12 VATZR-OM-13 VATZR-OM-14 VATZR-OM-15 VATZR-OM-16 VATEX-OM-01 VATEX-OM-02 VATEX-OM-03 VATEX-OM-04 VATEX-OM-05 VATEX-OM-06 VATEX-OM-07 VATEX-OM-08 VATEX-OM-09 VATEX-OM-10 VATEX-OM-11 VATEX-OM-12 ', concat(' ', normalize-space(.), ' '))))">
               <xsl:attribute name="id">CL-05-10-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[IBR-CL-05-OM, IBR-CL-10-OM] - If Document level allowance TAX category code (IBT-095) is 'Z/E', Document level allowance TAX exemption reason code (IBT-196) MUST be coded using Zero rating/Exemption reason codelist.</svrl:text>
               <svrl:diagnostic-reference diagnostic="CL-05-10-OM">

            VAT exemption / zero rating reason code (IBT-196)

            Found:
            - Value: '<xsl:text/>
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:text/>'

            Expected:
            Code must be one of the following:

            - VATZR-OM-01
            - VATZR-OM-02
            - VATZR-OM-03
            - VATZR-OM-04
            - VATZR-OM-05
            - VATZR-OM-06
            - VATZR-OM-07
            - VATZR-OM-08
            - VATZR-OM-09
            - VATZR-OM-10
            - VATZR-OM-11
            - VATZR-OM-12
            - VATZR-OM-13
            - VATZR-OM-14
            - VATZR-OM-15
            - VATZR-OM-16
            - VATEX-OM-01
            - VATEX-OM-02
            - VATEX-OM-03
            - VATEX-OM-04
            - VATEX-OM-05
            - VATEX-OM-06
            - VATEX-OM-07
            - VATEX-OM-08
            - VATEX-OM-09
            - VATEX-OM-10
            - VATEX-OM-11
            - VATEX-OM-12

            Action:
            Provide a valid exemption or zero-rating reason code.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeName] | cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeName]"
                 priority="1005"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeName] | cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID[@schemeName]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((not(contains(normalize-space(@schemeName), ' ')) and contains(' CR TIN CID PASNUM OTHID ICID SZLN ', concat(' ', normalize-space(@schemeName), ' '))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="((not(contains(normalize-space(@schemeName), ' ')) and contains(' CR TIN CID PASNUM OTHID ICID SZLN ', concat(' ', normalize-space(@schemeName), ' '))))">
               <xsl:attribute name="id">CL-06-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-06-OM] - If provided, the value in the Buyer identifier (IBT-046) Scheme identifier (IBT-046-1) and Seller identifier (IBT-029) Scheme identifier (IBT-029-1) must be coded with Buyer/Seller Identifier codelist.</svrl:text>
               <svrl:diagnostic-reference diagnostic="CL-06-OM">

            Buyer/Seller identifier scheme (IBT-029-1 / IBT-046-1)

            Found:
            - Value: '<xsl:text/>
                  <xsl:value-of select="normalize-space(@schemeID)"/>
                  <xsl:text/>'

            Expected:
            Code must be one of the following:

            - CR
            - TIN
            - CID
            - PASNUM
            - OTHID
            - ICID
            - SZLN

            Action:
            Use a valid identifier scheme from the Buyer/Seller Identifier codelist.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="cac:CommodityClassification/cbc:NatureCode"
                 priority="1004"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:CommodityClassification/cbc:NatureCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' GS SV ', concat(' ', normalize-space(.), ' '))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="((not(contains(normalize-space(.), ' ')) and contains(' GS SV ', concat(' ', normalize-space(.), ' '))))">
               <xsl:attribute name="id">CL-07-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-07-OM] - Item Type (BTOM-019) must be provided from the codelist for Item type.</svrl:text>
               <svrl:diagnostic-reference diagnostic="CL-07-OM">

            Item type (BTOM-019)

            Found:
            - Value: '<xsl:text/>
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:text/>'

            Expected:
            Code must be one of the following:

            - GS
            - SV

            Action:
            Use a valid item type code.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="cac:Delivery/cac:DeliveryTerms/cbc:ID"
                 priority="1003"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:Delivery/cac:DeliveryTerms/cbc:ID"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' EXW FCA CPT CIP DAP DPU DDP FAS FOB CFR CIF ', concat(' ', normalize-space(.), ' '))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="((not(contains(normalize-space(.), ' ')) and contains(' EXW FCA CPT CIP DAP DPU DDP FAS FOB CFR CIF ', concat(' ', normalize-space(.), ' '))))">
               <xsl:attribute name="id">CL-09-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-09-OM] - Incoterms (BTOM-022) MUST be coded using codelist Incoterms Codelist.</svrl:text>
               <svrl:diagnostic-reference diagnostic="CL-09-OM">

            Incoterms (BTOM-022)

            Found:
            - Value: '<xsl:text/>
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:text/>'

            Expected:
            Code must be one of the following:

            - EXW
            - FCA
            - CPT
            - CIP
            - DAP
            - DPU
            - DDP
            - FAS
            - FOB
            - CFR
            - CIF

            Action:
            Use a valid Incoterms code.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="cac:AdditionalItemProperty/cbc:NameCode"
                 priority="1002"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:AdditionalItemProperty/cbc:NameCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="                 (not($isProfitMargin or $isProfitMarginSelf))                 or                 (                     normalize-space(.) != ''                     and not(contains(normalize-space(.), ' '))                     and contains(                         ' VATPM-OM-01 VATPM-OM-02 VATPM-OM-03 VATPM-OM-04 VATPM-OM-05 ',                         concat(' ', normalize-space(.), ' ')                     )                 )                 "/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(not($isProfitMargin or $isProfitMarginSelf)) or ( normalize-space(.) != '' and not(contains(normalize-space(.), ' ')) and contains( ' VATPM-OM-01 VATPM-OM-02 VATPM-OM-03 VATPM-OM-04 VATPM-OM-05 ', concat(' ', normalize-space(.), ' ') ) )">
               <xsl:attribute name="id">CL-11-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-11-OM] - If invoice transaction type (BTOM-001) is 'Profit Margin Self-Invoice' or Profit margin invoice, Profit margin item reason code (BTOM-025) MUST be present and coded using Profit Margin Items Codelist.</svrl:text>
               <svrl:diagnostic-reference diagnostic="CL-11-OM">

            Profit margin item reason code (BTOM-025)

            Found:
            - Value: '<xsl:text/>
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:text/>'

            Expected:
            Code must be one of the following:

            - VATPM-OM-01
            - VATPM-OM-02
            - VATPM-OM-03
            - VATPM-OM-04
            - VATPM-OM-05

            Action:
            Provide a valid profit margin item reason code when applicable.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='MP']"
                 priority="1001"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode[@listID='MP']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' 64000000 70000000 71000000 72000000 73000000 76000000 77000000 78000000 80000000 81000000 82000000 83000000 84000000 85000000 86000000 90000000 91000000 92000000 93000000 94000000 ', concat(' ', normalize-space(.), ' '))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="((not(contains(normalize-space(.), ' ')) and contains(' 64000000 70000000 71000000 72000000 73000000 76000000 77000000 78000000 80000000 81000000 82000000 83000000 84000000 85000000 86000000 90000000 91000000 92000000 93000000 94000000 ', concat(' ', normalize-space(.), ' '))))">
               <xsl:attribute name="id">CL-12-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-12-OM] - Service Type classification code must coded with the service type codelist.</svrl:text>
               <svrl:diagnostic-reference diagnostic="CL-12-OM">

            Service classification code

            Found:
            - Value: '<xsl:text/>
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:text/>'

            Expected:
            Code must be one of the following:

            - 64000000
            - 70000000
            - 71000000
            - 72000000
            - 73000000
            - 76000000
            - 77000000
            - 78000000
            - 80000000
            - 81000000
            - 82000000
            - 83000000
            - 84000000
            - 85000000
            - 86000000
            - 90000000
            - 91000000
            - 92000000
            - 93000000
            - 94000000

            Action:
            Use a valid service classification code.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode | cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode"
                 priority="1000"
                 mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode | cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentityCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((not(contains(normalize-space(.), ' ')) and contains(' SHRFZ SEZAD SLLFZ AFZ MO ', concat(' ', normalize-space(.), ' '))))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="((not(contains(normalize-space(.), ' ')) and contains(' SHRFZ SEZAD SLLFZ AFZ MO ', concat(' ', normalize-space(.), ' '))))">
               <xsl:attribute name="id">CL-13-OM</xsl:attribute>
               <xsl:attribute name="flag">fatal</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>[CL-13-OM] - Buyer/Supplier country subentity code must be coded using the subdivision code list.</svrl:text>
               <svrl:diagnostic-reference diagnostic="CL-13-OM">

            Country subentity code

            Found:
            - Value: '<xsl:text/>
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:text/>'

            Expected:
            Code must be one of the following:

            - SHRFZ
            - SEZAD
            - SLLFZ
            - AFZ
            - MO

            Action:
            Use a valid subdivision code.
        </svrl:diagnostic-reference>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M45"/>
   </xsl:template>
</xsl:stylesheet>
