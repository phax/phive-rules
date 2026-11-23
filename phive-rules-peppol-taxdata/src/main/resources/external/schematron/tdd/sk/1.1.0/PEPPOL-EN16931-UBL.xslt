<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:pxs-taxdata="urn:peppol:schema:sk-taxdata:1.0" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:u="utils" xmlns:ubl-creditnote="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" xmlns:ubl-invoice="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
<xsl:function as="xs:boolean" name="u:gln">
    <xsl:param name="val" />
    <xsl:variable name="length" select="string-length($val) - 1" />
    <xsl:variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)" />
    <xsl:variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))" />
    <xsl:sequence select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:slack">
    <xsl:param as="xs:decimal" name="exp" />
    <xsl:param as="xs:decimal" name="val" />
    <xsl:param as="xs:decimal" name="slack" />
   <xsl:sequence select="xs:decimal($exp + $slack) >= $val and xs:decimal($exp - $slack) &lt;= $val" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:mod11">
    <xsl:param name="val" />
    <xsl:variable name="length" select="string-length($val) - 1" />
    <xsl:variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)" />
    <xsl:variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))" />
    <xsl:sequence select="number($val) > 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:mod97-0208">
    <xsl:param name="val" />
    <xsl:variable name="checkdigits" select="substring($val,9,2)" />
    <xsl:variable name="calculated_digits" select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))" />
    <xsl:sequence select="number($checkdigits) = number($calculated_digits)" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:checkCodiceIPA">
    <xsl:param as="xs:string?" name="arg" />
    <xsl:variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</xsl:variable>
    <xsl:sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:checkCF">
    <xsl:param as="xs:string?" name="arg" />
    <xsl:sequence select="   if ( (string-length($arg) = 16) or (string-length($arg) = 11) )      then    (    if ((string-length($arg) = 16))     then    (     if (u:checkCF16($arg))      then     (      true()     )     else     (      false()     )    )    else    (     if(($arg castable as xs:integer)) then true() else false()       )   )   else   (    false()   )   " />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:checkCF16">
    <xsl:param as="xs:string?" name="arg" />
    <xsl:variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:sequence select="     if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and         (substring($arg,7,2) castable as xs:integer) and        (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and        (substring($arg,10,2) castable as xs:integer) and         (substring($arg,12,3) castable as xs:string) and        (substring($arg,15,1) castable as xs:integer) and         (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)      )      then true()     else false()     " />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:checkPIVAseIT">
    <xsl:param as="xs:string" name="arg" />
    <xsl:variable name="paese" select="substring($arg,1,2)" />
    <xsl:variable name="codice" select="substring($arg,3)" />
    <xsl:sequence select="     if ( $paese = 'IT' or $paese = 'it' )    then    (     if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))     then     (      true()     )     else     (      false()     )    )    else    (     true()    )      " />
  </xsl:function>
  <xsl:function as="xs:integer" name="u:checkPIVA">
    <xsl:param as="xs:string?" name="arg" />
    <xsl:sequence select="     if (not($arg castable as xs:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )" />
  </xsl:function>
  <xsl:function as="xs:integer" name="u:addPIVA">
    <xsl:param as="xs:string" name="arg" />
    <xsl:param as="xs:integer" name="pari" />
    <xsl:variable name="tappo" select="if (not($arg castable as xs:integer)) then 0 else 1" />
    <xsl:variable name="mapper" select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )" />
    <xsl:sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:abn">
    <xsl:param name="val" />
    <xsl:sequence select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 " />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:TinVerification">
    <xsl:param as="xs:string" name="val" />
    <xsl:variable name="digits" select="    for $ch in string-to-codepoints($val)    return codepoints-to-string($ch)" />
    <xsl:variable name="checksum" select="    (number($digits[8])*2) +    (number($digits[7])*4) +    (number($digits[6])*8) +    (number($digits[5])*16) +    (number($digits[4])*32) +    (number($digits[3])*64) +    (number($digits[2])*128) +    (number($digits[1])*256) " />
    <xsl:sequence select="($checksum  mod 11) mod 10 = number($digits[9])" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:checkSEOrgnr">
    <xsl:param as="xs:string" name="number" />
    <xsl:choose>
      
      <xsl:when test="not(matches($number, '^\d+$'))">
        <xsl:sequence select="false()" />
      </xsl:when>
      <xsl:otherwise>
        
        <xsl:variable name="mainPart" select="substring($number, 1, 9)" />
        <xsl:variable name="checkDigit" select="substring($number, 10, 1)" />
        <xsl:variable as="xs:integer" name="sum">
          <xsl:sequence select="xs:integer(sum(       for $pos in 1 to string-length($mainPart) return         if ($pos mod 2 = 1)         then (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) mod 10 +           (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) idiv 10         else number(substring($mainPart, string-length($mainPart) - $pos + 1, 1))      ))" />
        </xsl:variable>
        <xsl:variable name="calculatedCheckDigit" select="(10 - $sum mod 10) mod 10" />
        <xsl:sequence select="$calculatedCheckDigit = number($checkDigit)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:mod89-LU_VAT">
    <xsl:param as="xs:string" name="val" />
    <xsl:variable name="normalized" select="upper-case(normalize-space($val))" />
    <xsl:variable name="base" select="substring($normalized, 3, 6)" />
    <xsl:variable name="checkdigits" select="substring($normalized, 9, 2)" />
    <xsl:variable name="calculated" select="format-integer(xs:integer($base) mod 89, '00')" />
    <xsl:sequence select="$checkdigits = $calculated" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:check-lux-0240">
    <xsl:param as="xs:string" name="val" />
    <xsl:choose>
      <xsl:when test="not(matches($val, '^[0-9]{11}$'))">
        <xsl:sequence select="false()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="typecode" select="xs:integer(substring($val, 5, 2))" />
        <xsl:choose>
          <xsl:when test="not($typecode ge 20 and $typecode le 99)">
            <xsl:sequence select="false()" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="digits" select="for $c in string-to-codepoints($val) return $c - 48" />
            <xsl:variable name="weights" select="(5, 4, 3, 2, 7, 6, 5, 4, 3, 2)" />
            <xsl:variable name="wsum" select="sum(for $i in 1 to 10 return $digits[$i] * $weights[$i])" />
            <xsl:variable name="remainder" select="$wsum mod 11" />
            <xsl:variable name="exp11" select="if ($remainder = 0) then 0 else 11 - $remainder" />
            <xsl:variable name="exp12" select="if ($remainder = 0) then 1 else if ($remainder = 1) then 0 else 12 - $remainder" />
            <xsl:variable name="checkdigit" select="$digits[11]" />
            <xsl:variable name="valid" select="if ($typecode = 24) then ($checkdigit = $exp11 or $checkdigit = $exp12) else $checkdigit = $exp11" />
            <xsl:sequence select="$valid" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
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
    <svrl:schematron-output schemaVersion="iso" title="Rules for Peppol BIS 3.0 Billing">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl-creditnote" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl-invoice" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:ns-prefix-in-attribute-values prefix="pxs-taxdata" uri="urn:peppol:schema:sk-taxdata:1.0" />
      <svrl:ns-prefix-in-attribute-values prefix="u" uri="utils" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M31" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M32" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M33" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M34" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M35" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M36" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M41" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M42" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M43" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M44" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">german-rules</xsl:attribute>
        <xsl:attribute name="name">german-rules</xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M45" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M46" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Rules for Peppol BIS 3.0 Billing</svrl:text>
  <xsl:param name="profile" select="if (normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:ProfileID) = ('urn:fdc:peppol.eu:2017:poacc:billing:01:1.0', 'urn:peppol:france:billing:regulated', 'urn:peppol:france:billing:non-regulated')) then          '01'        else if (normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:ProfileID) = 'urn:peppol:bis:billing_with_response') then          '02'        else if (matches(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:ProfileID), 'urn:fdc:peppol.eu:2017:poacc:selfbilling:([0-9]{2}):1.0')) then          tokenize(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:ProfileID), ':')[7]        else          'Unknown'" />
  <xsl:param name="supplierCountry" select="       if ((/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2))[1]) then         upper-case(normalize-space((/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2))[1]))       else         if ((/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2))[1]) then           upper-case(normalize-space((/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2))[1]))         else           if (/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then             upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))           else             'XX'" />
  <xsl:param name="customerCountry" select="   if ((/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2))[1]) then   upper-case(normalize-space((/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2))[1]))   else   if (/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then   upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))   else   'XX'" />
  <xsl:param name="supplierCountryIsDE" select="(upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'DE')" />
  <xsl:param name="customerCountryIsDE" select="(upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'DE')" />
  <xsl:param name="supplierCountryIsSK" select="(upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'SK')" />
  <xsl:param name="customerCountryIsSK" select="(upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'SK')" />
  <xsl:param name="documentCurrencyCode" select="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:DocumentCurrencyCode" />

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//*[not(*) and not(normalize-space())]" mode="M31" priority="1000">
    <svrl:fired-rule context="//*[not(*) and not(normalize-space())]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-EN16931-R008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R008]-Document MUST not contain empty elements.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M31" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M31" priority="-1" />
  <xsl:template match="@*|node()" mode="M31" priority="-2">
    <xsl:apply-templates mode="M31" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument" mode="M32" priority="1029">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ProfileID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ProfileID">
          <xsl:attribute name="id">PEPPOL-EN16931-R001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R001]-Business process MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$profile != 'Unknown'" />
      <xsl:otherwise>
        <svrl:failed-assert test="$profile != 'Unknown'">
          <xsl:attribute name="id">PEPPOL-EN16931-R007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R007]-Business process MUST have an approved identifier.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:Note) &lt;= 1 or ($supplierCountryIsDE and $customerCountryIsDE)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:Note) &lt;= 1 or ($supplierCountryIsDE and $customerCountryIsDE)">
          <xsl:attribute name="id">PEPPOL-EN16931-R002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R002]-No more than one note is allowed on document level, unless both the buyer and seller are German organizations.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0') or starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:selfbilling:3.0')) and not(contains(normalize-space(cbc:CustomizationID/text()), '::'))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0') or starts-with(normalize-space(cbc:CustomizationID/text()), 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:selfbilling:3.0')) and not(contains(normalize-space(cbc:CustomizationID/text()), '::'))">
          <xsl:attribute name="id">PEPPOL-EN16931-R004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R004]-Specification identifier MUST begin with the value 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0' or 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:selfbilling:3.0' and follow the format rules for the identifier.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:TaxTotal[cac:TaxSubtotal]) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:TaxTotal[cac:TaxSubtotal]) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R053</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R053]-Only one tax total with tax subtotals MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:TaxTotal[not(cac:TaxSubtotal)]) = (if (cbc:TaxCurrencyCode) then 1 else 0)">
          <xsl:attribute name="id">PEPPOL-EN16931-R054</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R054]-Only one tax total without tax subtotals MUST be provided when tax currency code is provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] >= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] >= 0) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TaxCurrencyCode) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] &lt;= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] &lt;= 0) or (cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:TaxCurrencyCode)] >= 0 and cac:TaxTotal/cbc:TaxAmount[@currencyID=normalize-space(../../cbc:DocumentCurrencyCode)] >= 0)">
          <xsl:attribute name="id">PEPPOL-EN16931-R055</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R055]-Invoice total VAT amount and Invoice total VAT amount in accounting currency MUST have the same operational sign</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:TaxCurrencyCode" mode="M32" priority="1028">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:TaxCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(text()) = normalize-space(../cbc:DocumentCurrencyCode/text()))">
          <xsl:attribute name="id">PEPPOL-EN16931-R005</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R005]-VAT accounting currency code MUST be different from invoice currency code when provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | pxs-taxdata:DocumentLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]" mode="M32" priority="1027">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | pxs-taxdata:DocumentLine/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-EN16931-R041</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R041]-Allowance/charge base amount MUST be provided when allowance/charge percentage is provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | pxs-taxdata:DocumentLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]" mode="M32" priority="1026">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | pxs-taxdata:DocumentLine/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-EN16931-R042</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R042]-Allowance/charge percentage MUST be provided when allowance/charge base amount is provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge | pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine/cac:AllowanceCharge" mode="M32" priority="1025">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge | pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="           not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then             cbc:Amount           else             0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)">
          <xsl:attribute name="id">PEPPOL-EN16931-R040</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R040]-Allowance/charge amount must equal base amount * percentage/100 if base amount and percentage exists</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ChargeIndicator/text()) = 'true' or normalize-space(cbc:ChargeIndicator/text()) = 'false'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ChargeIndicator/text()) = 'true' or normalize-space(cbc:ChargeIndicator/text()) = 'false'">
          <xsl:attribute name="id">PEPPOL-EN16931-R043</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R043]-Allowance/charge ChargeIndicator value MUST equal 'true' or 'false'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[some $code in tokenize('49 59', '\s') satisfies normalize-space(cbc:PaymentMeansCode) = $code]" mode="M32" priority="1024">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[some $code in tokenize('49 59', '\s') satisfies normalize-space(cbc:PaymentMeansCode) = $code]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PaymentMandate/cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PaymentMandate/cbc:ID">
          <xsl:attribute name="id">PEPPOL-EN16931-R061</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R061]-Mandate reference MUST be provided for direct debit.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cac:TaxTotal[cac:TaxSubtotal]/cbc:TaxAmount | cac:TaxSubtotal/cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" mode="M32" priority="1023">
    <svrl:fired-rule context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cac:TaxTotal[cac:TaxSubtotal]/cbc:TaxAmount | cac:TaxSubtotal/cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID = $documentCurrencyCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID = $documentCurrencyCode">
          <xsl:attribute name="id">PEPPOL-EN16931-R051</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R051]-All currencyID attributes must have the same value as the invoice currency code (BT-5), except for the invoice total VAT amount in accounting currency (BT-111).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[cac:InvoicePeriod/cbc:StartDate]/pxs-taxdata:DocumentLine/cac:InvoicePeriod/cbc:StartDate" mode="M32" priority="1022">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[cac:InvoicePeriod/cbc:StartDate]/pxs-taxdata:DocumentLine/cac:InvoicePeriod/cbc:StartDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:date(text()) >= xs:date(../../../cac:InvoicePeriod/cbc:StartDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:date(text()) >= xs:date(../../../cac:InvoicePeriod/cbc:StartDate)">
          <xsl:attribute name="id">PEPPOL-EN16931-R110</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R110]-Start date of line period MUST be within invoice period.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[cac:InvoicePeriod/cbc:EndDate]/pxs-taxdata:DocumentLine/cac:InvoicePeriod/cbc:EndDate" mode="M32" priority="1021">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[cac:InvoicePeriod/cbc:EndDate]/pxs-taxdata:DocumentLine/cac:InvoicePeriod/cbc:EndDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:date(text()) &lt;= xs:date(../../../cac:InvoicePeriod/cbc:EndDate)">
          <xsl:attribute name="id">PEPPOL-EN16931-R111</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R111]-End date of line period MUST be within invoice period.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine" mode="M32" priority="1020">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine" />
    <xsl:variable name="lineExtensionAmount" select="           if (cbc:LineExtensionAmount) then             xs:decimal(cbc:LineExtensionAmount)           else             0" />
    <xsl:variable name="quantity" select="           if (cbc:InvoicedQuantity) then               xs:decimal(cbc:InvoicedQuantity)             else               1" />
    <xsl:variable name="priceAmount" select="           if (cac:Price/cbc:PriceAmount) then             xs:decimal(cac:Price/cbc:PriceAmount)           else             0" />
    <xsl:variable name="baseQuantity" select="           if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then             xs:decimal(cac:Price/cbc:BaseQuantity)           else             1" />
    <xsl:variable name="allowancesTotal" select="           if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then             round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100           else             0" />
    <xsl:variable name="chargesTotal" select="           if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then             round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100           else             0" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)">
          <xsl:attribute name="id">PEPPOL-EN16931-R120</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R120]-Invoice line net amount MUST equal (Invoiced quantity * (Item net price/item price base quantity) + Sum of invoice line charge amount - sum of invoice line allowance amount</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) > 0">
          <xsl:attribute name="id">PEPPOL-EN16931-R121</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R121]-Base quantity MUST be a positive number above zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" mode="M32" priority="1019">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[0-9]{13}$') and u:gln(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[0-9]{13}$') and u:gln(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R040</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R040]-GLN13 MUST have a valid format according to GS1 rules.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" mode="M32" priority="1018">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R041</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R041]-Norwegian organization number MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0184'] | cac:PartyIdentification/cbc:ID[@schemeID = '0184'] | cbc:CompanyID[@schemeID = '0184']" mode="M32" priority="1017">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0184'] | cac:PartyIdentification/cbc:ID[@schemeID = '0184'] | cbc:CompanyID[@schemeID = '0184']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string-length(string()) = 10 and substring(string(), 1, 2) = 'DK' and string-length(translate(substring(string(), 3, 8), '1234567890', '')) = 0)                or               (string-length(string()) = 8) and (string-length(translate(substring(string(), 1, 8),'1234567890', '')) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string-length(string()) = 10 and substring(string(), 1, 2) = 'DK' and string-length(translate(substring(string(), 3, 8), '1234567890', '')) = 0) or (string-length(string()) = 8) and (string-length(translate(substring(string(), 1, 8),'1234567890', '')) = 0)">
          <xsl:attribute name="id">PEPPOL-COMMON-R042</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R042]-Danish organization number (CVR) MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0096'] | cac:PartyIdentification/cbc:ID[@schemeID = '0096'] | cbc:CompanyID[@schemeID = '0096']" mode="M32" priority="1016">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0096'] | cac:PartyIdentification/cbc:ID[@schemeID = '0096'] | cbc:CompanyID[@schemeID = '0096']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string-length(string()) = 10) and (string-length(translate(substring(string(), 1, 10),'1234567890', '')) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string-length(string()) = 10) and (string-length(translate(substring(string(), 1, 10),'1234567890', '')) = 0)">
          <xsl:attribute name="id">PEPPOL-COMMON-R052</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R052]-Danish chamber of commerce number (P) MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0198'] | cac:PartyIdentification/cbc:ID[@schemeID = '0198'] | cbc:CompanyID[@schemeID = '0198']" mode="M32" priority="1015">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0198'] | cac:PartyIdentification/cbc:ID[@schemeID = '0198'] | cbc:CompanyID[@schemeID = '0198']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string-length(string()) = 10 and substring(string(), 1, 2) = 'DK' and string-length(translate(substring(string(), 3, 8), '1234567890', '')) = 0)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string-length(string()) = 10 and substring(string(), 1, 2) = 'DK' and string-length(translate(substring(string(), 3, 8), '1234567890', '')) = 0)">
          <xsl:attribute name="id">PEPPOL-COMMON-R053</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R053]-Danish ERSTORG number (SE) MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']" mode="M32" priority="1014">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[01][0-9]{9}$') and u:mod97-0208(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[01][0-9]{9}$') and u:mod97-0208(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R043</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R043]-Belgian enterprise number MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID[starts-with(upper-case(normalize-space(.)), 'BE')]" mode="M32" priority="1013">
    <svrl:fired-rule context="cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID[starts-with(upper-case(normalize-space(.)), 'BE')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(upper-case(normalize-space(.)), '^BE[01][0-9]{9}$') and u:mod97-0208(substring(upper-case(normalize-space(.)), 3))" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(upper-case(normalize-space(.)), '^BE[01][0-9]{9}$') and u:mod97-0208(substring(upper-case(normalize-space(.)), 3))">
          <xsl:attribute name="id">PEPPOL-COMMON-R062</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R062]-Belgian VAT number MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']" mode="M32" priority="1012">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:checkCodiceIPA(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:checkCodiceIPA(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R044</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R044]-IPA Code (Codice Univoco Unità Organizzativa) SHOULD be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']" mode="M32" priority="1011">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:checkCF(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:checkCF(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R045</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R045]-Tax Code (Codice Fiscale) SHOULD be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '9907']" mode="M32" priority="1010">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '9907']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:checkCF(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:checkCF(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R046</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R046]-Tax Code (Codice Fiscale) SHOULD be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']" mode="M32" priority="1009">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:checkPIVAseIT(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:checkPIVAseIT(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R047</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R047]-Italian VAT Code (Partita Iva) SHOULD be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']" mode="M32" priority="1008">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN' and u:checkSEOrgnr(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN' and u:checkSEOrgnr(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R049</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R049]-Swedish organization number MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']" mode="M32" priority="1007">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[0-9]{11}$') and u:abn(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[0-9]{11}$') and u:abn(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R050</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R050]-Australian Business Number (ABN) MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0106'] | cac:PartyIdentification/cbc:ID[@schemeID = '0106'] | cbc:CompanyID[@schemeID = '0106']" mode="M32" priority="1006">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0106'] | cac:PartyIdentification/cbc:ID[@schemeID = '0106'] | cbc:CompanyID[@schemeID = '0106']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[0-9]{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[0-9]{8}$')">
          <xsl:attribute name="id">PEPPOL-COMMON-R054</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R054]-Dutch Chamber of Commerce (KVK) numbers (0106) MUST be stated in the correct format (12345678).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0190'] | cac:PartyIdentification/cbc:ID[@schemeID = '0190'] | cbc:CompanyID[@schemeID = '0190']" mode="M32" priority="1005">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0190'] | cac:PartyIdentification/cbc:ID[@schemeID = '0190'] | cbc:CompanyID[@schemeID = '0190']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[0-9]{20}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[0-9]{20}$')">
          <xsl:attribute name="id">PEPPOL-COMMON-R055</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R055]-Dutch organization identification numbers (0190) MUST be stated in the correct format (12345678901234567890).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '9944'] | cac:PartyIdentification/cbc:ID[@schemeID = '9944'] | cbc:CompanyID[@schemeID = '9944']" mode="M32" priority="1004">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '9944'] | cac:PartyIdentification/cbc:ID[@schemeID = '9944'] | cbc:CompanyID[@schemeID = '9944']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^NL[0-9]{9}B[0-9]{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^NL[0-9]{9}B[0-9]{2}$')">
          <xsl:attribute name="id">PEPPOL-COMMON-R056-1</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R056-1]-Dutch VAT numbers (9944) MUST be stated in the correct format (NL123456789B12).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID[starts-with(normalize-space(.), 'NL')]" mode="M32" priority="1003">
    <svrl:fired-rule context="cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID[starts-with(normalize-space(.), 'NL')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(.), '^NL[0-9]{9}B[0-9]{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(.), '^NL[0-9]{9}B[0-9]{2}$')">
          <xsl:attribute name="id">PEPPOL-COMMON-R056-2</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R056-2]-Dutch VAT numbers MUST have the format (NL123456789B12).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0217'] | cac:PartyIdentification/cbc:ID[@schemeID = '0217'] | cbc:CompanyID[@schemeID = '0217']" mode="M32" priority="1002">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0217'] | cac:PartyIdentification/cbc:ID[@schemeID = '0217'] | cbc:CompanyID[@schemeID = '0217']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[0-9]{12}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[0-9]{12}$')">
          <xsl:attribute name="id">PEPPOL-COMMON-R057</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R057]-Dutch Chamber of Commerce Establishment numbers (0217) MUST be stated in the correct format (123456789012).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID[starts-with(upper-case(normalize-space(.)), 'LU')]" mode="M32" priority="1001">
    <svrl:fired-rule context="cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID[starts-with(upper-case(normalize-space(.)), 'LU')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(upper-case(normalize-space(.)), '^LU[0-9]{8}$') and u:mod89-LU_VAT(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(upper-case(normalize-space(.)), '^LU[0-9]{8}$') and u:mod89-LU_VAT(.)">
          <xsl:attribute name="id">PEPPOL-COMMON-R058</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R058]-Luxembourg VAT number MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0240'] | cac:PartyIdentification/cbc:ID[@schemeID = '0240'] | cbc:CompanyID[@schemeID = '0240']" mode="M32" priority="1000">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0240'] | cac:PartyIdentification/cbc:ID[@schemeID = '0240'] | cbc:CompanyID[@schemeID = '0240']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:check-lux-0240(normalize-space(.))" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:check-lux-0240(normalize-space(.))">
          <xsl:attribute name="id">PEPPOL-COMMON-R059</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R059]-Luxembourg Register of Legal Persons number (Matricule) MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M32" priority="-1" />
  <xsl:template match="@*|node()" mode="M32" priority="-2">
    <xsl:apply-templates mode="M32" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'NO']" mode="M33" priority="1000">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party[$supplierCountry = 'NO']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID, 1, 2)='NO' and matches(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID,3), '^[0-9]{9}MVA$')           and u:mod11(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID, 3, 9)) or not(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID, 1, 2)='NO')" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID, 1, 2)='NO' and matches(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID,3), '^[0-9]{9}MVA$') and u:mod11(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID, 3, 9)) or not(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/substring(cbc:CompanyID, 1, 2)='NO')">
          <xsl:attribute name="id">NO-R-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[NO-R-001]-For Norwegian suppliers, a VAT number MUST be the country code prefix NO followed by a valid Norwegian organization number (nine numbers) followed by the letters MVA.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M33" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M33" priority="-1" />
  <xsl:template match="@*|node()" mode="M33" priority="-2">
    <xsl:apply-templates mode="M33" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty" mode="M34" priority="1031">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Party) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Party) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R210</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R210]-pxs:ReportedDocument/cac:AccountingCustomerParty MUST contain exactly one cac:Party.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party" mode="M34" priority="1030">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyLegalEntity) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyLegalEntity) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R211</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R211]-pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party MUST contain exactly one cac:PartyLegalEntity.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity" mode="M34" priority="1029">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:RegistrationName) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:RegistrationName) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R212</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R212]-pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity MUST contain exactly one cbc:RegistrationName.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" mode="M34" priority="1028">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R213</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R213]-pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme MUST contain exactly one cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" mode="M34" priority="1027">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:CompanyID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:CompanyID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R214</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R214]-pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme MUST contain exactly one cbc:CompanyID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" mode="M34" priority="1026">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Country) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Country) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R217</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R217]-pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress MUST contain exactly one cac:Country.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country" mode="M34" priority="1025">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:IdentificationCode) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:IdentificationCode) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R218</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R218]-pxs:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country MUST contain exactly one cbc:IdentificationCode.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty" mode="M34" priority="1024">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Party) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Party) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R220</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R220]-pxs:ReportedDocument/cac:AccountingSupplierParty MUST contain exactly one cac:Party.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" mode="M34" priority="1023">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R223</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R223]-pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme MUST contain exactly one cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme" mode="M34" priority="1022">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:CompanyID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:CompanyID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R224</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R224]-pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme MUST contain exactly one cbc:CompanyID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" mode="M34" priority="1021">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Country) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Country) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R227</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R227]-pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress MUST contain exactly one cac:Country.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country" mode="M34" priority="1020">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:IdentificationCode) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:IdentificationCode) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R228</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R228]-pxs:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country MUST contain exactly one cbc:IdentificationCode.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge" mode="M34" priority="1019">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:TaxCategory) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:TaxCategory) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R231</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R231]-pxs:ReportedDocument/cac:AllowanceCharge MUST contain exactly one cac:TaxCategory.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" mode="M34" priority="1018">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R233</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R233]-pxs:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme MUST contain exactly one cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory" mode="M34" priority="1017">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R234</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R234]-pxs:ReportedDocument/cac:AllowanceCharge/cac:TaxCategory MUST contain exactly one cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine/cac:Item" mode="M34" priority="1016">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine/cac:Item" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:ClassifiedTaxCategory) &lt;= 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:ClassifiedTaxCategory) &lt;= 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R242</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R242]-pxs:ReportedDocument/pxs:DocumentLine/cac:Item MUST contain at most one cac:ClassifiedTaxCategory.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:Name) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:Name) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R248</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R248]-pxs:ReportedDocument/pxs:DocumentLine/cac:Item MUST contain exactly one cbc:Name.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme" mode="M34" priority="1015">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R244</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R244]-pxs:ReportedDocument/pxs:DocumentLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme MUST contain exactly one cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine/cac:Item/cac:ClassifiedTaxCategory" mode="M34" priority="1014">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine/cac:Item/cac:ClassifiedTaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R245</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R245]-pxs:ReportedDocument/pxs:DocumentLine/cac:Item/cac:ClassifiedTaxCategory MUST contain exactly one cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine/cac:Item/cac:CommodityClassification" mode="M34" priority="1013">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine/cac:Item/cac:CommodityClassification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ItemClassificationCode) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ItemClassificationCode) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R246</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R246]-pxs:ReportedDocument/pxs:DocumentLine/cac:Item/cac:CommodityClassification MUST contain exactly one cbc:ItemClassificationCode.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine" mode="M34" priority="1012">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Price) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Price) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R249</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R249]-pxs:ReportedDocument/pxs:DocumentLine MUST contain exactly one cac:Price.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:InvoicedQuantity) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:InvoicedQuantity) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R250</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R250]-pxs:ReportedDocument/pxs:DocumentLine MUST contain exactly one cbc:InvoicedQuantity.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:MonetaryTotal" mode="M34" priority="1011">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:MonetaryTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:LineExtensionAmount) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:LineExtensionAmount) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R252</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R252]-pxs:ReportedDocument/pxs:MonetaryTotal MUST contain exactly one cbc:LineExtensionAmount.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TaxExclusiveAmount) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TaxExclusiveAmount) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R253</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R253]-pxs:ReportedDocument/pxs:MonetaryTotal MUST contain exactly one cbc:TaxExclusiveAmount.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch" mode="M34" priority="1010">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R257</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R257]-pxs:ReportedDocument/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch MUST contain exactly one cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans/cac:PayeeFinancialAccount" mode="M34" priority="1009">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans/cac:PayeeFinancialAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R258</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R258]-pxs:ReportedDocument/cac:PaymentMeans/cac:PayeeFinancialAccount MUST contain exactly one cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount" mode="M34" priority="1008">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R259</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R259]-pxs:ReportedDocument/cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount MUST contain exactly one cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty" mode="M34" priority="1007">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyTaxScheme) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyTaxScheme) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R262</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R262]-pxs:ReportedDocument/cac:TaxRepresentativeParty MUST contain exactly one cac:PartyTaxScheme.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PostalAddress) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PostalAddress) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R265</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R265]-pxs:ReportedDocument/cac:TaxRepresentativeParty MUST contain exactly one cac:PostalAddress.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M34" priority="1006">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R263</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R263]-pxs:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme MUST contain exactly one cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme" mode="M34" priority="1005">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:CompanyID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:CompanyID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R264</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R264]-pxs:ReportedDocument/cac:TaxRepresentativeParty/cac:PartyTaxScheme MUST contain exactly one cbc:CompanyID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PostalAddress" mode="M34" priority="1004">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:Country) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:Country) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R267</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R267]-pxs:ReportedDocument/cac:TaxRepresentativeParty/cac:PostalAddress MUST contain exactly one cac:Country.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country" mode="M34" priority="1003">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:IdentificationCode) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:IdentificationCode) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R268</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R268]-pxs:ReportedDocument/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country MUST contain exactly one cbc:IdentificationCode.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme" mode="M34" priority="1002">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R270</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R270]-pxs:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme MUST contain exactly one cbc:ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal" mode="M34" priority="1001">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:TaxableAmount) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:TaxableAmount) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R272</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R272]-pxs:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal MUST contain exactly one cbc:TaxableAmount.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument" mode="M34" priority="1000">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:CustomizationID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:CustomizationID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R273</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R273]-pxs:ReportedDocument MUST contain exactly one cbc:CustomizationID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:DocumentCurrencyCode) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:DocumentCurrencyCode) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R274</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R274]-pxs:ReportedDocument MUST contain exactly one cbc:DocumentCurrencyCode.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(pxs-taxdata:DocumentTypeCode) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(pxs-taxdata:DocumentTypeCode) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R275</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R275]-pxs:ReportedDocument MUST contain exactly one pxs:DocumentTypeCode.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cbc:ProfileID) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cbc:ProfileID) = 1">
          <xsl:attribute name="id">PEPPOL-EN16931-R276</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-R276]-pxs:ReportedDocument MUST contain exactly one cbc:ProfileID.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M34" priority="-1" />
  <xsl:template match="@*|node()" mode="M34" priority="-2">
    <xsl:apply-templates mode="M34" select="@*|*" />
  </xsl:template>

<!--PATTERN -->
<xsl:variable name="DKSupplierCountry" select="//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />
  <xsl:variable name="DKCustomerCountry" select="//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']" mode="M35" priority="1004">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((pxs-taxdata:DocumentTypeCode = ('381','396','81','83','532')) and (number(pxs-taxdata:MonetaryTotal/cbc:PayableAmount/text()) &lt; 0))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((pxs-taxdata:DocumentTypeCode = ('381','396','81','83','532')) and (number(pxs-taxdata:MonetaryTotal/cbc:PayableAmount/text()) &lt; 0))">
          <xsl:attribute name="id">DK-R-016</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DK-R-016]-For Danish Suppliers, a Credit note cannot have a negative total (PayableAmount)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:PaymentMeans" mode="M35" priority="1003">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:PaymentMeans" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="contains(' 1 10 31 42 48 49 50 58 59 93 97 ', concat(' ', cbc:PaymentMeansCode, ' '))" />
      <xsl:otherwise>
        <svrl:failed-assert test="contains(' 1 10 31 42 48 49 50 58 59 93 97 ', concat(' ', cbc:PaymentMeansCode, ' '))">
          <xsl:attribute name="id">DK-R-005</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DK-R-005]-For Danish suppliers the following Payment means codes are allowed: 1, 10, 31, 42, 48, 49, 50, 58, 59, 93 and 97</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(((cbc:PaymentMeansCode = '31') or (cbc:PaymentMeansCode = '42'))       and not((normalize-space(cac:PayeeFinancialAccount/cbc:ID/text()) != '') and (normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/text()) != ''))       )" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(((cbc:PaymentMeansCode = '31') or (cbc:PaymentMeansCode = '42')) and not((normalize-space(cac:PayeeFinancialAccount/cbc:ID/text()) != '') and (normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/text()) != '')) )">
          <xsl:attribute name="id">DK-R-006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DK-R-006]-For Danish suppliers bank account and registration account is mandatory if payment means is 31 or 42</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cbc:PaymentMeansCode = '49')       and not((normalize-space(cac:PaymentMandate/cbc:ID/text()) != '')           and (normalize-space(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID/text()) != ''))       )" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cbc:PaymentMeansCode = '49') and not((normalize-space(cac:PaymentMandate/cbc:ID/text()) != '') and (normalize-space(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID/text()) != '')) )">
          <xsl:attribute name="id">DK-R-007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DK-R-007]-For Danish suppliers PaymentMandate/ID and PayerFinancialAccount/ID are mandatory when payment means is 49</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cbc:PaymentMeansCode = '50')       and not(((substring(cbc:PaymentID, 1, 3) = '01#')           or (substring(cbc:PaymentID, 1, 3) = '04#')           or (substring(cbc:PaymentID, 1, 3) = '15#'))         and matches(cac:PayeeFinancialAccount/cbc:ID, '^[0-9]{7,8}$')         )       )" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cbc:PaymentMeansCode = '50') and not(((substring(cbc:PaymentID, 1, 3) = '01#') or (substring(cbc:PaymentID, 1, 3) = '04#') or (substring(cbc:PaymentID, 1, 3) = '15#')) and matches(cac:PayeeFinancialAccount/cbc:ID, '^[0-9]{7,8}$') ) )">
          <xsl:attribute name="id">DK-R-008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DK-R-008]-For Danish Suppliers PaymentID is mandatory and MUST start with 01#, 04# or 15# (kortartkode), and PayeeFinancialAccount/ID (Giro kontonummer) is mandatory and must be 7 or 8 numerical characters long, when payment means equals 50 (Giro)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cbc:PaymentMeansCode = '50')       and ((substring(cbc:PaymentID, 1, 3) = '04#')          or (substring(cbc:PaymentID, 1, 3)  = '15#'))       and not(string-length(cbc:PaymentID) = 19)       )" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cbc:PaymentMeansCode = '50') and ((substring(cbc:PaymentID, 1, 3) = '04#') or (substring(cbc:PaymentID, 1, 3) = '15#')) and not(string-length(cbc:PaymentID) = 19) )">
          <xsl:attribute name="id">DK-R-009</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DK-R-009]-For Danish Suppliers if the PaymentID is prefixed with 04# or 15# the 16 digits instruction Id must be added to the PaymentID eg. "04#1234567890123456" when Payment means equals 50 (Giro)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cbc:PaymentMeansCode = '93')       and not(((substring(cbc:PaymentID, 1, 3) = '71#')           or (substring(cbc:PaymentID, 1, 3) = '73#')           or (substring(cbc:PaymentID, 1, 3) = '75#'))         and (string-length(cac:PayeeFinancialAccount/cbc:ID/text()) = 8)         )       )" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cbc:PaymentMeansCode = '93') and not(((substring(cbc:PaymentID, 1, 3) = '71#') or (substring(cbc:PaymentID, 1, 3) = '73#') or (substring(cbc:PaymentID, 1, 3) = '75#')) and (string-length(cac:PayeeFinancialAccount/cbc:ID/text()) = 8) ) )">
          <xsl:attribute name="id">DK-R-010</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DK-R-010]-For Danish Suppliers using PaymentMeansCode 93, PaymentID is mandatory. The first three characters of the PaymentID MUST be 71#, 73# or 75# (kortartskode), and PayeeFinancialAccount/ID MUST be exactly 8 characters long.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cbc:PaymentMeansCode = '93')       and ((substring(cbc:PaymentID, 1, 3) = '71#')          or (substring(cbc:PaymentID, 1, 3)  = '75#'))       and not((string-length(cbc:PaymentID) = 18)          or (string-length(cbc:PaymentID) = 19))       )" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cbc:PaymentMeansCode = '93') and ((substring(cbc:PaymentID, 1, 3) = '71#') or (substring(cbc:PaymentID, 1, 3) = '75#')) and not((string-length(cbc:PaymentID) = 18) or (string-length(cbc:PaymentID) = 19)) )">
          <xsl:attribute name="id">DK-R-011</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DK-R-011]-For Danish Suppliers if the PaymentID is prefixed with 71# or 75# the 15-16 digits instruction Id must be added to the PaymentID eg. "71#1234567890123456" when payment Method equals 93 (FIK)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party" mode="M35" priority="1002">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/cac:AccountingCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(((boolean(cac:PartyLegalEntity/cbc:CompanyID)) and (normalize-space(cac:PartyLegalEntity/cbc:CompanyID/@schemeID) != '0184')))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(((boolean(cac:PartyLegalEntity/cbc:CompanyID)) and (normalize-space(cac:PartyLegalEntity/cbc:CompanyID/@schemeID) != '0184')))">
          <xsl:attribute name="id">DK-R-017</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DK-R-017]-For Danish Customers it is mandatory to specify schemeID as "0184"
        (DK CVR-number) when PartyLegalEntity/CompanyID is used for AccountingCustomerParty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/pxs-taxdata:DocumentLine" mode="M35" priority="1001">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']/pxs-taxdata:DocumentLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID = 'TST')       and not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.05.01')           or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.0501')                                or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '26.08.01')                                or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '26.0801')           )       )" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listID = 'TST') and not((cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.05.01') or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '19.0501') or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '26.08.01') or (cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode/@listVersionID = '26.0801') ) )">
          <xsl:attribute name="id">DK-R-003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DK-R-003]-If ItemClassification is provided from Danish suppliers, UNSPSC version 19.05.01 or 26.08.01 MUST be used.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']" mode="M35" priority="1000">
    <svrl:fired-rule context="cac:AllowanceCharge[$DKSupplierCountry = 'DK' and $DKCustomerCountry = 'DK']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not((cbc:AllowanceChargeReasonCode = 'ZZZ')       and not(((string-length(normalize-space(cbc:AllowanceChargeReason/text())) = 4)         and (number(cbc:AllowanceChargeReason) >= 0)         and (number(cbc:AllowanceChargeReason) &lt;= 9999)) or         (((cbc:AllowanceChargeReason and contains(cbc:AllowanceChargeReason, '#')                                   and not(starts-with(cbc:AllowanceChargeReason, '#'))                                   and not(ends-with(cbc:AllowanceChargeReason, '#')))) )                                )      )" />
      <xsl:otherwise>
        <svrl:failed-assert test="not((cbc:AllowanceChargeReasonCode = 'ZZZ') and not(((string-length(normalize-space(cbc:AllowanceChargeReason/text())) = 4) and (number(cbc:AllowanceChargeReason) >= 0) and (number(cbc:AllowanceChargeReason) &lt;= 9999)) or (((cbc:AllowanceChargeReason and contains(cbc:AllowanceChargeReason, '#') and not(starts-with(cbc:AllowanceChargeReason, '#')) and not(ends-with(cbc:AllowanceChargeReason, '#')))) ) ) )">
          <xsl:attribute name="id">DK-R-004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DK-R-004]-When specifying non-VAT Taxes for Danish customers, Danish suppliers MUST use the AllowanceChargeReasonCode="ZZZ" and MUST be specified in AllowanceChargeReason; Either as the 4-digit Tax category or must include a #, but the # is not allowed as first and last character</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M35" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M35" priority="-1" />
  <xsl:template match="@*|node()" mode="M35" priority="-2">
    <xsl:apply-templates mode="M35" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE']" mode="M36" priority="1005">
    <svrl:fired-rule context="//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID)) = 14" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID)) = 14">
          <xsl:attribute name="id">SE-R-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SE-R-001]-For Swedish suppliers, Swedish VAT-numbers must consist of 14 characters.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string(number(substring(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID, 3, 12))) != 'NaN'" />
      <xsl:otherwise>
        <svrl:failed-assert test="string(number(substring(cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/cbc:CompanyID, 3, 12))) != 'NaN'">
          <xsl:attribute name="id">SE-R-002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SE-R-002]-For Swedish suppliers, the Swedish VAT-numbers must have the trailing 12 characters in numeric form</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:TaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and //cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and cbc:ID = 'S'] | //cac:ClassifiedTaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and //cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and cbc:ID = 'S']" mode="M36" priority="1004">
    <svrl:fired-rule context="//cac:TaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and //cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and cbc:ID = 'S'] | //cac:ClassifiedTaxCategory[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE' and cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2) = 'SE'] and //cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and cbc:ID = 'S']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(cbc:Percent) = 25 or number(cbc:Percent) = 12 or number(cbc:Percent) = 6" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(cbc:Percent) = 25 or number(cbc:Percent) = 12 or number(cbc:Percent) = 6">
          <xsl:attribute name="id">SE-R-006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SE-R-006]-For Swedish suppliers invoicing Swedish buyers, only standard VAT rate of 6, 12 or 25 are used</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:PLUSGIRO']/cac:PayeeFinancialAccount/cbc:ID" mode="M36" priority="1003">
    <svrl:fired-rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:PLUSGIRO']/cac:PayeeFinancialAccount/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string(number(normalize-space(.))) != 'NaN'" />
      <xsl:otherwise>
        <svrl:failed-assert test="string(number(normalize-space(.))) != 'NaN'">
          <xsl:attribute name="id">SE-R-007</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SE-R-007]-For Swedish suppliers using Plusgiro, the Account ID SHOULD be numeric </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(.)) >= 2 and string-length(normalize-space(.)) &lt;= 8" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(.)) >= 2 and string-length(normalize-space(.)) &lt;= 8">
          <xsl:attribute name="id">SE-R-010</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SE-R-010]-For Swedish suppliers using Plusgiro, the Account ID SHOULD have 2-8 characters</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:BANKGIRO']/cac:PayeeFinancialAccount/cbc:ID" mode="M36" priority="1002">
    <svrl:fired-rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and normalize-space(cbc:PaymentMeansCode) = '30' and normalize-space(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID) = 'SE:BANKGIRO']/cac:PayeeFinancialAccount/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string(number(normalize-space(.))) != 'NaN'" />
      <xsl:otherwise>
        <svrl:failed-assert test="string(number(normalize-space(.))) != 'NaN'">
          <xsl:attribute name="id">SE-R-008</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SE-R-008]-For Swedish suppliers using Bankgiro, the Account ID SHOULD be numeric </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space(.)) = 7 or string-length(normalize-space(.)) = 8" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space(.)) = 7 or string-length(normalize-space(.)) = 8">
          <xsl:attribute name="id">SE-R-009</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SE-R-009]-For Swedish suppliers using Bankgiro, the Account ID SHOULD have 7-8 characters</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('50') or cbc:PaymentMeansCode = normalize-space('56'))]" mode="M36" priority="1001">
    <svrl:fired-rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('50') or cbc:PaymentMeansCode = normalize-space('56'))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">SE-R-011</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SE-R-011]-For Swedish suppliers using Swedish Bankgiro or Plusgiro, the proper way to indicate this is to use Code 30 for PaymentMeans and FinancialInstitutionBranch ID with code SE:BANKGIRO or SE:PLUSGIRO</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE']  and //cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('31'))]" mode="M36" priority="1000">
    <svrl:fired-rule context="//cac:PaymentMeans[//cac:AccountingSupplierParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE']  and //cac:AccountingCustomerParty/cac:Party[cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'SE'] and (cbc:PaymentMeansCode = normalize-space('31'))]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">SE-R-012</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[SE-R-012]-For domestic transactions between Swedish trading partners, credit transfer SHOULD be indicated by PaymentMeansCode="30"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M36" priority="-1" />
  <xsl:template match="@*|node()" mode="M36" priority="-2">
    <xsl:apply-templates mode="M36" select="@*|*" />
  </xsl:template>
  <xsl:param name="isGreekSender" select="($supplierCountry ='GR') or ($supplierCountry ='EL')" />
  <xsl:param name="isGreekReceiver" select="($customerCountry ='GR') or ($customerCountry ='EL')" />
  <xsl:param name="isGreekSenderandReceiver" select="$isGreekSender and $isGreekReceiver" />
  <xsl:param name="accountingSupplierCountry" select="     if (/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)) then     upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 1, 2)))     else     if (/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) then     upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))     else     'XX'" />

<!--PATTERN -->
<xsl:variable name="dateRegExp" select="'^(0?[1-9]|[12][0-9]|3[01])[-\\/ ]?(0?[1-9]|1[0-2])[-\\/ ]?(19|20)[0-9]{2}'" />
  <xsl:variable name="tokenizedUblIssueDate" select="tokenize(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:IssueDate,'-')" />

	<!--RULE -->
<xsl:template match="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:ID[$isGreekSender]" mode="M41" priority="1004">
    <svrl:fired-rule context="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cbc:ID[$isGreekSender]" />
    <xsl:variable name="IdSegments" select="tokenize(.,'\|')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count($IdSegments) = 6" />
      <xsl:otherwise>
        <svrl:failed-assert test="count($IdSegments) = 6">
          <xsl:attribute name="id">GR-R-001-1</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[GR-R-001-1]-When the Supplier is Greek, the Invoice Id MUST consist of 6 segments</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space($IdSegments[1])) = 9                                   and u:TinVerification($IdSegments[1])                                  and ($IdSegments[1] = ../cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9)                                  or $IdSegments[1] = ../cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space($IdSegments[1])) = 9 and u:TinVerification($IdSegments[1]) and ($IdSegments[1] = ../cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9) or $IdSegments[1] = ../cac:TaxRepresentativeParty/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID = 'VAT']/substring(cbc:CompanyID, 3, 9) )">
          <xsl:attribute name="id">GR-R-001-2</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[GR-R-001-2]-When the Supplier is Greek, the Invoice Id first segment must be a valid TIN Number and match either the Supplier's or the Tax Representative's Tin Number</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="tokenizedIdDate" select="tokenize($IdSegments[2],'/')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space($IdSegments[2]))>0                                   and matches($IdSegments[2],$dateRegExp)                                  and ($tokenizedIdDate[1] = $tokenizedUblIssueDate[3]                                     and $tokenizedIdDate[2] = $tokenizedUblIssueDate[2]                                    and $tokenizedIdDate[3] = $tokenizedUblIssueDate[1])" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space($IdSegments[2]))>0 and matches($IdSegments[2],$dateRegExp) and ($tokenizedIdDate[1] = $tokenizedUblIssueDate[3] and $tokenizedIdDate[2] = $tokenizedUblIssueDate[2] and $tokenizedIdDate[3] = $tokenizedUblIssueDate[1])">
          <xsl:attribute name="id">GR-R-001-3</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[GR-R-001-3]-When the Supplier is Greek, the Invoice Id second segment must be a valid Date that matches the invoice Issue Date</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space($IdSegments[3]))>0 and string(number($IdSegments[3])) != 'NaN' and xs:integer($IdSegments[3]) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space($IdSegments[3]))>0 and string(number($IdSegments[3])) != 'NaN' and xs:integer($IdSegments[3]) >= 0">
          <xsl:attribute name="id">GR-R-001-4</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[GR-R-001-4]-When Supplier is Greek, the Invoice Id third segment must be a positive integer</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length($IdSegments[5]) > 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length($IdSegments[5]) > 0">
          <xsl:attribute name="id">GR-R-001-6</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[GR-R-001-6]-When Supplier is Greek, the Invoice Id fifth segment must not be empty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length($IdSegments[6]) > 0 " />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length($IdSegments[6]) > 0">
          <xsl:attribute name="id">GR-R-001-7</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[GR-R-001-7]-When Supplier is Greek, the Invoice Id sixth segment must not be empty</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M41" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty[$isGreekSender]/cac:Party" mode="M41" priority="1003">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty[$isGreekSender]/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(./cac:PartyName/cbc:Name)>0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(./cac:PartyName/cbc:Name)>0">
          <xsl:attribute name="id">GR-R-002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[GR-R-002]-Greek Suppliers must provide their full name as they are registered in the Greek Business Registry (G.E.MH.) as a legal entity or in the Tax Registry as a natural person </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and                             substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and                             u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))">
          <xsl:attribute name="id">GR-S-011</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[GR-S-011]-Greek suppliers SHOULD provide their Seller Tax Registration Number, prefixed by the country code</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M41" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty[$isGreekSender]/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID" mode="M41" priority="1002">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty[$isGreekSender]/cac:Party/cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="substring(.,1,2) = 'EL' and u:TinVerification(substring(.,3))" />
      <xsl:otherwise>
        <svrl:failed-assert test="substring(.,1,2) = 'EL' and u:TinVerification(substring(.,3))">
          <xsl:attribute name="id">GR-R-003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[GR-R-003]-For the Greek Suppliers, the VAT must start with 'EL' and must be a valid TIN number</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M41" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty[$isGreekSender]/cac:Party" mode="M41" priority="1001">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty[$isGreekSender]/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(./cac:PartyName/cbc:Name)>0" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(./cac:PartyName/cbc:Name)>0">
          <xsl:attribute name="id">GR-R-005</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[GR-R-005]-Greek Suppliers must provide the full name of the buyer</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M41" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party[$accountingSupplierCountry='GR' or $accountingSupplierCountry='EL']/cbc:EndpointID" mode="M41" priority="1000">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party[$accountingSupplierCountry='GR' or $accountingSupplierCountry='EL']/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="./@schemeID='9933' and u:TinVerification(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="./@schemeID='9933' and u:TinVerification(.)">
          <xsl:attribute name="id">GR-R-009</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[GR-R-009]-Greek suppliers that send an invoice through the PEPPOL network must use a correct TIN number as an electronic address according to PEPPOL Electronic Address Identifier scheme (schemeID 9933).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M41" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M41" priority="-1" />
  <xsl:template match="@*|node()" mode="M41" priority="-2">
    <xsl:apply-templates mode="M41" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party" mode="M42" priority="1000">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty[$isGreekSenderandReceiver]/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and                             substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and                             u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID)=1 and substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,1,2) = 'EL' and u:TinVerification(substring(cac:PartyTaxScheme[normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']/cbc:CompanyID,3))">
          <xsl:attribute name="id">GR-R-006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[GR-R-006]-Greek Suppliers must provide the VAT number of the buyer, if the buyer is Greek </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M42" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M42" priority="-1" />
  <xsl:template match="@*|node()" mode="M42" priority="-2">
    <xsl:apply-templates mode="M42" select="@*|*" />
  </xsl:template>

<!--PATTERN -->
<xsl:variable name="SupplierCountry" select="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />
  <xsl:variable name="CustomerCountry" select="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

	<!--RULE -->
<xsl:template match="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$SupplierCountry = 'IS']" mode="M43" priority="1001">
    <svrl:fired-rule context="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$SupplierCountry = 'IS']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( ( not(contains(normalize-space(pxs-taxdata:DocumentTypeCode),' ')) and contains( ' 380 381 ',concat(' ',normalize-space(pxs-taxdata:DocumentTypeCode),' ') ) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( ( not(contains(normalize-space(pxs-taxdata:DocumentTypeCode),' ')) and contains( ' 380 381 ',concat(' ',normalize-space(pxs-taxdata:DocumentTypeCode),' ') ) ) )">
          <xsl:attribute name="id">IS-R-001</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IS-R-001]-If seller is icelandic then invoice type SHOULD be 380 or 381 — Ef seljandi er íslenskur þá ætti gerð reiknings (BT-3) að vera sölureikningur (380) eða kreditreikningur (381).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID)         and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID)) = 12        or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID) and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '9']/cac:PayeeFinancialAccount/cbc:ID)) = 12 or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '9']))">
          <xsl:attribute name="id">IS-R-006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IS-R-006]-If seller is icelandic and payment means code is 9 then a 12 digit account id must exist — Ef seljandi er íslenskur og greiðslumáti (BT-81) er krafa (kóti 9) þá skal koma fram 12 stafa númer (bankanúmer, höfuðbók 66 og reikningsnúmer) (BT-84)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID)         and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID)) = 12        or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']))" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID) and string-length(normalize-space(cac:PaymentMeans[cbc:PaymentMeansCode = '42']/cac:PayeeFinancialAccount/cbc:ID)) = 12 or not(exists(cac:PaymentMeans[cbc:PaymentMeansCode = '42']))">
          <xsl:attribute name="id">IS-R-007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IS-R-007]-If seller is icelandic and payment means code is 42 then a 12 digit account id must exist — Ef seljandi er íslenskur og greiðslumáti (BT-81) er millifærsla (kóti 42) þá skal koma fram 12 stafa reikningnúmer (BT-84)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M43" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$SupplierCountry = 'IS' and $CustomerCountry = 'IS']/cac:AccountingCustomerParty" mode="M43" priority="1000">
    <svrl:fired-rule context="/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$SupplierCountry = 'IS' and $CustomerCountry = 'IS']/cac:AccountingCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID) and cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0196'" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cac:Party/cac:PartyLegalEntity/cbc:CompanyID) and cac:Party/cac:PartyLegalEntity/cbc:CompanyID/@schemeID = '0196'">
          <xsl:attribute name="id">IS-R-004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[IS-R-004]-If seller and buyer are icelandic then the invoice shall contain the
        buyers icelandic legal identifier — Ef seljandi og kaupandi eru íslenskir þá skal
        reikningurinn innihalda íslenska kennitölu kaupanda (BT-47).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M43" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M43" priority="-1" />
  <xsl:template match="@*|node()" mode="M43" priority="-2">
    <xsl:apply-templates mode="M43" select="@*|*" />
  </xsl:template>

<!--PATTERN -->
<xsl:variable name="supplierCountryIsNL" select="(upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'NL')" />
  <xsl:variable name="customerCountryIsNL" select="(upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'NL')" />
  <xsl:variable name="taxRepresentativeCountryIsNL" select="(upper-case(normalize-space(/pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) = 'NL')" />

	<!--RULE -->
<xsl:template match="pxs-taxdata:DocumentTypeCode[.='381'][$supplierCountryIsNL]" mode="M44" priority="1003">
    <svrl:fired-rule context="pxs-taxdata:DocumentTypeCode[.='381'][$supplierCountryIsNL]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="../cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="../cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID">
          <xsl:attribute name="id">NL-R-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[NL-R-001]-For suppliers in the Netherlands, if the document is a creditnote, the document MUST contain an invoice reference (cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M44" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:MonetaryTotal[$supplierCountryIsNL]" mode="M44" priority="1002">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:MonetaryTotal[$supplierCountryIsNL]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(../pxs-taxdata:DocumentTypeCode[.='71' or .='80' or .='82' or .='84' or .='102' or .='218' or .='219' or .='326' or .='331' or .='380' or .='382' or .='383' or .='384' or .='386' or .='388' or .='393' or .='395' or .='553' or .='575' or .='623' or .='780' or .='817' or .='870' or .='875' or .='876' or .='877'] and xs:decimal(cbc:PayableAmount) &lt;= 0.0) or (../pxs-taxdata:DocumentTypeCode[.='381' or .='396' or .='81' or .='83' or .='532'] and xs:decimal(cbc:PayableAmount) >= 0.0) or (../cac:PaymentMeans)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(../pxs-taxdata:DocumentTypeCode[.='71' or .='80' or .='82' or .='84' or .='102' or .='218' or .='219' or .='326' or .='331' or .='380' or .='382' or .='383' or .='384' or .='386' or .='388' or .='393' or .='395' or .='553' or .='575' or .='623' or .='780' or .='817' or .='870' or .='875' or .='876' or .='877'] and xs:decimal(cbc:PayableAmount) &lt;= 0.0) or (../pxs-taxdata:DocumentTypeCode[.='381' or .='396' or .='81' or .='83' or .='532'] and xs:decimal(cbc:PayableAmount) >= 0.0) or (../cac:PaymentMeans)">
          <xsl:attribute name="id">NL-R-007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[NL-R-007]-For suppliers in the Netherlands, the supplier MUST provide a means of payment (cac:PaymentMeans) if the payment is from customer to supplier</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M44" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[$supplierCountryIsNL and $customerCountryIsNL]" mode="M44" priority="1001">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID[$supplierCountryIsNL and $customerCountryIsNL]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0106 ') or contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0190 ')) and (normalize-space(.) != '')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0106 ') or contains(concat(' ', string-join(@schemeID, ' '), ' '), ' 0190 ')) and (normalize-space(.) != '')">
          <xsl:attribute name="id">NL-R-005</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[NL-R-005]-For suppliers in the Netherlands, if the customer is in the
        Netherlands, the customer's legal entity identifier MUST be either a KVK or OIN number
        (schemeID 0106 or 0190)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M44" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[$supplierCountryIsNL and $customerCountryIsNL]" mode="M44" priority="1000">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[$supplierCountryIsNL and $customerCountryIsNL]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:PaymentMeansCode) = '30' or         normalize-space(cbc:PaymentMeansCode) = '48' or         normalize-space(cbc:PaymentMeansCode) = '49' or         normalize-space(cbc:PaymentMeansCode) = '57' or         normalize-space(cbc:PaymentMeansCode) = '58' or         normalize-space(cbc:PaymentMeansCode) = '59'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:PaymentMeansCode) = '30' or normalize-space(cbc:PaymentMeansCode) = '48' or normalize-space(cbc:PaymentMeansCode) = '49' or normalize-space(cbc:PaymentMeansCode) = '57' or normalize-space(cbc:PaymentMeansCode) = '58' or normalize-space(cbc:PaymentMeansCode) = '59'">
          <xsl:attribute name="id">NL-R-008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[NL-R-008]-For suppliers in the Netherlands, if the customer is in the Netherlands, the payment means code (cac:PaymentMeans/cbc:PaymentMeansCode) MUST be one of 30, 48, 49, 57, 58 or 59</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M44" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M44" priority="-1" />
  <xsl:template match="@*|node()" mode="M44" priority="-2">
    <xsl:apply-templates mode="M44" select="@*|*" />
  </xsl:template>

<!--PATTERN german-rules-->
<xsl:variable name="XR-SKONTO-REGEX" select="'#(SKONTO)#TAGE=([0-9]+#PROZENT=[0-9]+\.[0-9]{2})(#BASISBETRAG=-?[0-9]+\.[0-9]{2})?#$'" />
  <xsl:variable name="XR-EMAIL-REGEX" select="'^[a-zA-Z0-9!#\$%&amp;&quot;*+/=?^_`{|}~-]+(\.[a-zA-Z0-9!#\$%&amp;&quot;*+/=?^_`{|}~-]+)*@([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$'" />
  <xsl:variable name="XR-TELEPHONE-REGEX" select="'.*([0-9].*){3,}.*'" />

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$supplierCountryIsDE and $customerCountryIsDE]" mode="M45" priority="1004">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument[$supplierCountryIsDE and $customerCountryIsDE]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PaymentMeans" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PaymentMeans">
          <xsl:attribute name="id">DE-R-001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-001]-If both supplier and customer are located in Germany, an invoice shall contain information on "PAYMENT INSTRUCTIONS" (BG-16).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="supportedVATCodes" select="('S', 'Z', 'E', 'AE', 'K', 'G', 'L', 'M')" />
    <xsl:variable name="BT-31orBT-32Path" select="cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID[boolean(normalize-space(.))]" />
    <xsl:variable name="BT-95-UBL-Inv" select="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false' and         following-sibling::cac:TaxScheme/cbc:ID = 'VAT']" />
    <xsl:variable name="BT-95-UBL-CN" select="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'false']" />
    <xsl:variable name="BT-102" select="cac:AllowanceCharge/cac:TaxCategory/cbc:ID[ancestor::cac:AllowanceCharge/cbc:ChargeIndicator = 'true']" />
    <xsl:variable name="BT-151" select="(pxs-taxdata:DocumentLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="         (not(           ($BT-95-UBL-Inv = $supportedVATCodes or $BT-95-UBL-CN = $supportedVATCodes) or           ($BT-102 = $supportedVATCodes) or           ($BT-151 = $supportedVATCodes)         ) or         (cac:TaxRepresentativeParty, $BT-31orBT-32Path))         " />
      <xsl:otherwise>
        <svrl:failed-assert test="(not( ($BT-95-UBL-Inv = $supportedVATCodes or $BT-95-UBL-CN = $supportedVATCodes) or ($BT-102 = $supportedVATCodes) or ($BT-151 = $supportedVATCodes) ) or (cac:TaxRepresentativeParty, $BT-31orBT-32Path))">
          <xsl:attribute name="id">DE-R-016</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-016]-If both supplier and customer are located in Germany, and if one of the VAT codes S, Z, E, AE, K, G, L, or M is used, an invoice shall contain at least one of the following elements: "Seller VAT identifier" (BT-31) or "Seller tax registration identifier" (BT-32) or "SELLER TAX REPRESENTATIVE PARTY" (BG-11).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="supportedInvAndCNTypeCodes" select="('326', '380', '384', '389', '381', '875', '876', '877')" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(pxs-taxdata:DocumentTypeCode) = $supportedInvAndCNTypeCodes" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(pxs-taxdata:DocumentTypeCode) = $supportedInvAndCNTypeCodes">
          <xsl:attribute name="id">DE-R-017</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-017]-If both supplier and customer are located in Germany, the element "Invoice type code" (BT-3) SHOULD only contain the following values from code list UNTDID 1001: 326 (Partial invoice), 380 (Commercial invoice), 384 (Corrected invoice), 389 (Self-billed invoice), 381 (Credit note), 875 (Partial construction invoice), 876 (Partial final construction invoice), 877 (Final construction invoice).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((not(normalize-space(pxs-taxdata:DocumentTypeCode) = '384') or                     (cac:BillingReference/cac:InvoiceDocumentReference)))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((not(normalize-space(pxs-taxdata:DocumentTypeCode) = '384') or (cac:BillingReference/cac:InvoiceDocumentReference)))">
          <xsl:attribute name="id">DE-R-026</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-026]-If both supplier and customer are located in Germany, and if "Invoice type code" (BT-3) contains the code 384 (Corrected invoice), "PRECEDING INVOICE REFERENCE" (BG-3) SHOULD be provided at least once.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PaymentMeans/cac:PaymentMandate) or (cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PaymentMeans/cac:PaymentMandate) or (cac:PaymentMeans/cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID)">
          <xsl:attribute name="id">DE-R-031</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-031]-If both supplier and customer are located in Germany, and if the group "DIRECT DEBIT" (BG-19) is delivered, the element "Debited account identifier" (BT-91) shall be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('30','58')][$supplierCountryIsDE and $customerCountryIsDE]" mode="M45" priority="1003">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('30','58')][$supplierCountryIsDE and $customerCountryIsDE]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(cbc:PaymentMeansCode) = '58') or matches(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and xs:integer(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp > 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(cbc:PaymentMeansCode) = '58') or matches(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and xs:integer(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PayeeFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return (if($cp > 64) then string($cp - 55) else string($cp - 48)),'')) mod 97 = 1">
          <xsl:attribute name="id">DE-R-019</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-019]-If both supplier and customer are located in Germany, the element "Payment account identifier" (BT-84) SHOULD contain a valid IBAN if code 58 SEPA is provided in "Payment means type code" (BT-81).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PayeeFinancialAccount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PayeeFinancialAccount">
          <xsl:attribute name="id">DE-R-023-1</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-023-1]-If both supplier and customer are German, if "Payment means type code" (BT-81) contains a code for credit transfer (30, 58), "CREDIT TRANSFER" (BG-17) shall be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:CardAccount) and                     not(cac:PaymentMandate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:CardAccount) and not(cac:PaymentMandate)">
          <xsl:attribute name="id">DE-R-023-2</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-023-2]-If both supplier and customer are located in Germany, and if "Payment means type code" (BT-81) contains a code for credit transfer (30, 58), BG-18 and BG-19 shall not be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('48','54','55')][$supplierCountryIsDE and $customerCountryIsDE]" mode="M45" priority="1002">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = ('48','54','55')][$supplierCountryIsDE and $customerCountryIsDE]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:CardAccount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:CardAccount">
          <xsl:attribute name="id">DE-R-024-1</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-024-1]-If both supplier and customer are located in Germany, and if "Payment means type code" (BT-81) contains a code for payment card (48, 54, 55), "PAYMENT CARD INFORMATION" (BG-18) shall be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PayeeFinancialAccount) and                     not(cac:PaymentMandate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PayeeFinancialAccount) and not(cac:PaymentMandate)">
          <xsl:attribute name="id">DE-R-024-2</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-024-2]-If both supplier and customer are located in Germany, and if "Payment means type code" (BT-81) contains a code for payment card (48, 54, 55), BG-17 and BG-19 shall not be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = '59'][$supplierCountryIsDE and $customerCountryIsDE]" mode="M45" priority="1001">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:PaymentMeans[normalize-space(cbc:PaymentMeansCode) = '59'][$supplierCountryIsDE and $customerCountryIsDE]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(cbc:PaymentMeansCode) = '59') or                     matches(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and                     xs:decimal(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return  (if($cp > 64) then string($cp - 55) else  string($cp - 48)),'')) mod 97 = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(cbc:PaymentMeansCode) = '59') or matches(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')), '^[A-Z]{2}[0-9]{2}[a-zA-Z0-9]{0,30}$') and xs:decimal(string-join(for $cp in string-to-codepoints(concat(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),5),upper-case(substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),1,2)),substring(normalize-space(replace(cac:PaymentMandate/cac:PayerFinancialAccount/cbc:ID, '([ \n\r\t\s])', '')),3,2))) return (if($cp > 64) then string($cp - 55) else string($cp - 48)),'')) mod 97 = 1">
          <xsl:attribute name="id">DE-R-020</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-020]-If both supplier and customer are located in Germany, the element "Debited account identifier" (BT-91) SHOULD contain a valid IBAN if code 59 SEPA is provided in "Payment means type code" (BT-81).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PaymentMandate" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PaymentMandate">
          <xsl:attribute name="id">DE-R-025-1</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-025-1]-If both supplier and customer are located in Germany, and if "Payment means type code" (BT-81) contains a code for direct debit (59), "DIRECT DEBIT" (BG-19) shall be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PayeeFinancialAccount) and                     not(cac:CardAccount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PayeeFinancialAccount) and not(cac:CardAccount)">
          <xsl:attribute name="id">DE-R-025-2</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-025-2]-If both supplier and customer are located in Germany, and if "Payment means type code" (BT-81) contains a code for direct debit (59), BG-17 and BG-18 shall not be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal[$supplierCountryIsDE and $customerCountryIsDE]" mode="M45" priority="1000">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:TaxTotal/cac:TaxSubtotal[$supplierCountryIsDE and $customerCountryIsDE]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxCategory/cbc:Percent[boolean(normalize-space(.))]" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxCategory/cbc:Percent[boolean(normalize-space(.))]">
          <xsl:attribute name="id">DE-R-014</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[DE-R-014]-If both supplier and customer are located in Germany, the element "VAT category rate" (BT-119) shall be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M45" priority="-1" />
  <xsl:template match="@*|node()" mode="M45" priority="-2">
    <xsl:apply-templates mode="M45" select="@*|*" />
  </xsl:template>

<!--PATTERN -->
<xsl:variable name="ISO3166" select="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')" />
  <xsl:variable name="ISO4217" select="tokenize('AED AFN ALL AMD AOA ARS AUD AWG AZN BAM BBD BDT BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLE SOS SRD SSP STN SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UYW UZS VED VES VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA YER ZAR ZMW ZWG XXX CNH XCG', '\s')" />
  <xsl:variable name="MIMECODE" select="tokenize('application/pdf image/png image/jpeg text/csv application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')" />
  <xsl:variable name="UNCL2005" select="tokenize('3 35 432', '\s')" />
  <xsl:variable name="UNCL5189" select="tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')" />
  <xsl:variable name="UNCL7161" select="tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAC DAD DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL PRV RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')" />
  <xsl:variable name="UNCL5305" select="tokenize('AE E S Z G O K L M B', '\s')" />
  <xsl:variable name="eaid" select="tokenize('0002 0007 0009 0060 0088 0096 0097 0106 0130 0135 0142 0151 0158 0183 0184 0188 0190 0191 0192 0195 0196 0198 0199 0200 0201 0204 0208 0209 0210 0211 0216 0218 0221 0225 0230 0235 0240 0242 0244 0245 0246 0248 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959', '\s')" />

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode" mode="M46" priority="1014">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="           some $code in $UNCL5189             satisfies normalize-space(text()) = $code" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $code in $UNCL5189 satisfies normalize-space(text()) = $code">
          <xsl:attribute name="id">PEPPOL-EN16931-CL002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-CL002]-Reason code MUST be according to subset of UNCL 5189 D.16B.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode" mode="M46" priority="1013">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="           some $code in $UNCL7161             satisfies normalize-space(text()) = $code" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $code in $UNCL7161 satisfies normalize-space(text()) = $code">
          <xsl:attribute name="id">PEPPOL-EN16931-CL003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-CL003]-Reason code MUST be according to UNCL 7161 D.16B.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:InvoicePeriod/cbc:DescriptionCode" mode="M46" priority="1012">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/cac:InvoicePeriod/cbc:DescriptionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="           some $code in $UNCL2005             satisfies normalize-space(text()) = $code" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $code in $UNCL2005 satisfies normalize-space(text()) = $code">
          <xsl:attribute name="id">PEPPOL-EN16931-CL006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-CL006]-Invoice period description code MUST be according to UNCL 2005 D.16B.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" mode="M46" priority="1011">
    <svrl:fired-rule context="cbc:Amount | cbc:BaseAmount | cbc:PriceAmount | cbc:TaxAmount | cbc:TaxableAmount | cbc:LineExtensionAmount | cbc:TaxExclusiveAmount | cbc:TaxInclusiveAmount | cbc:AllowanceTotalAmount | cbc:ChargeTotalAmount | cbc:PrepaidAmount | cbc:PayableRoundingAmount | cbc:PayableAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="           some $code in $ISO4217             satisfies @currencyID = $code" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $code in $ISO4217 satisfies @currencyID = $code">
          <xsl:attribute name="id">PEPPOL-EN16931-CL007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-CL007]-Currency code must be according to ISO 4217:2005</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentTypeCode" mode="M46" priority="1010">
    <svrl:fired-rule context="pxs-taxdata:TaxData/pxs-taxdata:ReportedTransaction/pxs-taxdata:ReportedDocument/pxs-taxdata:DocumentTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="           not($profile = ('01','02')) or (some $code in tokenize('71 80 82 84 102 218 219 261 326 331 380 382 383 384 386 388 389 393 395 553 575 623 780 817 870 875 876 877 381 396 81 83 527 532', '\s')             satisfies normalize-space(text()) = $code)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not($profile = ('01','02')) or (some $code in tokenize('71 80 82 84 102 218 219 261 326 331 380 382 383 384 386 388 389 393 395 553 575 623 780 817 870 875 876 877 381 396 81 83 527 532', '\s') satisfies normalize-space(text()) = $code)">
          <xsl:attribute name="id">PEPPOL-EN16931-P0100</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-P0100]-Invoice/Credit note type code MUST be set according to the profile.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(.) = '326' or normalize-space(.) = '384') or ($supplierCountryIsDE and $customerCountryIsDE) or (normalize-space(.) = '384' and $supplierCountryIsSK and $customerCountryIsSK)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(.) = '326' or normalize-space(.) = '384') or ($supplierCountryIsDE and $customerCountryIsDE) or (normalize-space(.) = '384' and $supplierCountryIsSK and $customerCountryIsSK)">
          <xsl:attribute name="id">PEPPOL-EN16931-P0112</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-P0112]-Invoice type code 326 is only allowed when both buyer and seller are German organizations. Invoice type code 384 is only allowed when both buyer and seller are German organizations or both are Slovak organizations.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" mode="M46" priority="1009">
    <svrl:fired-rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(text()) = 10 and (string(.) castable as xs:date)" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(text()) = 10 and (string(.) castable as xs:date)">
          <xsl:attribute name="id">PEPPOL-EN16931-F001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-F001]-A date MUST be formatted YYYY-MM-DD.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID]" mode="M46" priority="1008">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="         some $code in $eaid         satisfies @schemeID = $code" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $code in $eaid satisfies @schemeID = $code">
          <xsl:attribute name="id">PEPPOL-EN16931-CL008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-CL008]-Electronic address identifier scheme must be from the codelist "Electronic Address Identifier Scheme"</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-G']" mode="M46" priority="1007">
    <svrl:fired-rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-G']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID)='G'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID)='G'">
          <xsl:attribute name="id">PEPPOL-EN16931-P0104</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-P0104]-Tax Category G MUST be used when exemption reason code is VATEX-EU-G</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-O']" mode="M46" priority="1006">
    <svrl:fired-rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-O']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID)='O'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID)='O'">
          <xsl:attribute name="id">PEPPOL-EN16931-P0105</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-P0105]-Tax Category O MUST be used when exemption reason code is VATEX-EU-O</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-IC']" mode="M46" priority="1005">
    <svrl:fired-rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-IC']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID)='K'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID)='K'">
          <xsl:attribute name="id">PEPPOL-EN16931-P0106</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-P0106]-Tax Category K MUST be used when exemption reason code is VATEX-EU-IC</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-AE']" mode="M46" priority="1004">
    <svrl:fired-rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-AE']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID)='AE'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID)='AE'">
          <xsl:attribute name="id">PEPPOL-EN16931-P0107</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-P0107]-Tax Category AE MUST be used when exemption reason code is VATEX-EU-AE</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-D']" mode="M46" priority="1003">
    <svrl:fired-rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-D']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID)='E'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID)='E'">
          <xsl:attribute name="id">PEPPOL-EN16931-P0108</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-P0108]-Tax Category E MUST be used when exemption reason code is VATEX-EU-D</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-F']" mode="M46" priority="1002">
    <svrl:fired-rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-F']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID)='E'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID)='E'">
          <xsl:attribute name="id">PEPPOL-EN16931-P0109</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-P0109]-Tax Category E MUST be used when exemption reason code is VATEX-EU-F</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-I']" mode="M46" priority="1001">
    <svrl:fired-rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-I']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID)='E'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID)='E'">
          <xsl:attribute name="id">PEPPOL-EN16931-P0110</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-P0110]-Tax Category E MUST be used when exemption reason code is VATEX-EU-I</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-J']" mode="M46" priority="1000">
    <svrl:fired-rule context="cac:TaxCategory[upper-case(cbc:TaxExemptionReasonCode)='VATEX-EU-J']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(cbc:ID)='E'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(cbc:ID)='E'">
          <xsl:attribute name="id">PEPPOL-EN16931-P0111</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-EN16931-P0111]-Tax Category E MUST be used when exemption reason code is VATEX-EU-J</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M46" priority="-1" />
  <xsl:template match="@*|node()" mode="M46" priority="-2">
    <xsl:apply-templates mode="M46" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
