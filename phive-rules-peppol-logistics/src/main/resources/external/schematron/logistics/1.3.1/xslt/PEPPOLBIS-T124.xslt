<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:u="utils" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:TransportExecutionPlan-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
  <xsl:function as="xs:boolean" name="u:mod11">
      <xsl:param name="val" />
      <xsl:variable name="length" select="string-length($val) - 1" />
      <xsl:variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)" />
      <xsl:variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))" />
      <xsl:sequence select="number($val) > 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))" />
   </xsl:function>
  <xsl:function as="xs:boolean" name="u:checkCodiceIPA">
      <xsl:param as="xs:string?" name="arg" />
      <xsl:variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</xsl:variable>
      <xsl:sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()" />
  </xsl:function>
  <xsl:function as="xs:integer" name="u:addPIVA">
      <xsl:param as="xs:string" name="arg" />
      <xsl:param as="xs:integer" name="pari" />
      <xsl:variable name="tappo" select="if (not($arg castable as xs:integer)) then 0 else 1" />
      <xsl:variable name="mapper" select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )" />
      <xsl:sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )" />
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
  <xsl:function as="xs:integer" name="u:checkPIVA">
      <xsl:param as="xs:string?" name="arg" />
      <xsl:sequence select="     if (not($arg castable as xs:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:checkPIVAseIT">
      <xsl:param as="xs:string" name="arg" />
      <xsl:variable name="paese" select="substring($arg,1,2)" />
      <xsl:variable name="codice" select="substring($arg,3)" />
      <xsl:sequence select="       if ( $paese = 'IT' or $paese = 'it' )    then    (     if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))     then      (      true()     )     else     (      false()     )    )    else    (     true()    )      " />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:mod97-0208">
      <xsl:param name="val" />
      <xsl:variable name="checkdigits" select="substring($val,9,2)" />
      <xsl:variable name="calculated_digits" select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))" />
      <xsl:sequence select="number($checkdigits) = number($calculated_digits)" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:abn">
      <xsl:param name="val" />
      <xsl:sequence select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 " />
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
    <svrl:schematron-output schemaVersion="iso" title="Rules for Transport Execution Plan">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:TransportExecutionPlan-2" />
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:ns-prefix-in-attribute-values prefix="u" uri="utils" />
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
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Rules for Transport Execution Plan</svrl:text>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//*[not(*) and not(normalize-space())]" mode="M17" priority="1000">
    <svrl:fired-rule context="//*[not(*) and not(normalize-space())]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-COMMON-R001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R001]-Document MUST not contain empty elements.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M17" priority="-1" />
  <xsl:template match="@*|node()" mode="M17" priority="-2">
    <xsl:apply-templates mode="M17" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/*" mode="M18" priority="1018">
    <svrl:fired-rule context="/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@*:schemaLocation)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@*:schemaLocation)">
          <xsl:attribute name="id">PEPPOL-COMMON-R003</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R003]-Document SHOULD not contain schema location.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" mode="M18" priority="1017">
    <svrl:fired-rule context="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(string(.) castable as xs:date) and (string-length(.) = 10)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(string(.) castable as xs:date) and (string-length(.) = 10)">
          <xsl:attribute name="id">PEPPOL-COMMON-R030</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R030]-A date must be formatted YYYY-MM-DD.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" mode="M18" priority="1016">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R040</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R040]-GLN must have a valid format according to GS1 rules.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" mode="M18" priority="1015">
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
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0184'] | cac:PartyIdentification/cbc:ID[@schemeID = '0184'] | cbc:CompanyID[@schemeID = '0184']" mode="M18" priority="1014">
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
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0096'] | cac:PartyIdentification/cbc:ID[@schemeID = '0096'] | cbc:CompanyID[@schemeID = '0096']" mode="M18" priority="1013">
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
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0198'] | cac:PartyIdentification/cbc:ID[@schemeID = '0198'] | cbc:CompanyID[@schemeID = '0198']" mode="M18" priority="1012">
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
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']" mode="M18" priority="1011">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R043</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R043]-Belgian enterprise number MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']" mode="M18" priority="1010">
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
          <svrl:text>[PEPPOL-COMMON-R044]-IPA Code (Codice Univoco Unità Organizzativa) must be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']" mode="M18" priority="1009">
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
          <svrl:text>[PEPPOL-COMMON-R045]-Tax Code (Codice Fiscale) must be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '9907']" mode="M18" priority="1008">
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
          <svrl:text>[PEPPOL-COMMON-R046]-Tax Code (Codice Fiscale) must be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']" mode="M18" priority="1007">
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
          <svrl:text>[PEPPOL-COMMON-R047]-Italian VAT Code (Partita Iva) must be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']" mode="M18" priority="1006">
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
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']" mode="M18" priority="1005">
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
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0106'] | cac:PartyIdentification/cbc:ID[@schemeID = '0106'] | cbc:CompanyID[@schemeID = '0106']" mode="M18" priority="1004">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0106'] | cac:PartyIdentification/cbc:ID[@schemeID = '0106'] | cbc:CompanyID[@schemeID = '0106']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[0-9]{8}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[0-9]{8}$')">
          <xsl:attribute name="id">PEPPOL-COMMON-R054</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R054]-Dutch Chamber of Commerce (KVK) numbers (0106) MUST be stated in the correct format (12345678).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0190'] | cac:PartyIdentification/cbc:ID[@schemeID = '0190'] | cbc:CompanyID[@schemeID = '0190']" mode="M18" priority="1003">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0190'] | cac:PartyIdentification/cbc:ID[@schemeID = '0190'] | cbc:CompanyID[@schemeID = '0190']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[0-9]{20}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[0-9]{20}$')">
          <xsl:attribute name="id">PEPPOL-COMMON-R055</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R055]-Dutch organization identification numbers (0190) MUST be stated in the correct format (12345678901234567890).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '9944'] | cac:PartyIdentification/cbc:ID[@schemeID = '9944'] | cbc:CompanyID[@schemeID = '9944']" mode="M18" priority="1002">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '9944'] | cac:PartyIdentification/cbc:ID[@schemeID = '9944'] | cbc:CompanyID[@schemeID = '9944']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^NL[0-9]{9}B[0-9]{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^NL[0-9]{9}B[0-9]{2}$')">
          <xsl:attribute name="id">PEPPOL-COMMON-R056-1</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R056-1]-Dutch VAT numbers (9944) MUST be stated in the correct format (NL123456789B12).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PartyTaxScheme                    [normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']                    /cbc:CompanyID                    [starts-with(normalize-space(.), 'NL')]" mode="M18" priority="1001">
    <svrl:fired-rule context="cac:PartyTaxScheme                    [normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']                    /cbc:CompanyID                    [starts-with(normalize-space(.), 'NL')]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(.), '^NL[0-9]{9}B[0-9]{2}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(.), '^NL[0-9]{9}B[0-9]{2}$')">
          <xsl:attribute name="id">PEPPOL-COMMON-R056-2</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R056-2]-Dutch VAT numbers MUST have the format (NL123456789B12).</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0217'] | cac:PartyIdentification/cbc:ID[@schemeID = '0217'] | cbc:CompanyID[@schemeID = '0217']" mode="M18" priority="1000">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0217'] | cac:PartyIdentification/cbc:ID[@schemeID = '0217'] | cbc:CompanyID[@schemeID = '0217']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[0-9]{12}$')" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[0-9]{12}$')">
          <xsl:attribute name="id">PEPPOL-COMMON-R057</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-COMMON-R057]-Dutch Chamber of Commerce Establishment numbers (0217) MUST be stated in the correct format (123456789012).</svrl:text>
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
<xsl:variable name="clDocumentStatusCode" select="tokenize('1 5 9 22 55', '\s')" />
  <xsl:variable name="clMimeCode" select="tokenize('application/pdf image/png image/jpeg image/tiff application/acad application/dwg drawing/dwg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')" />
  <xsl:variable name="clISO3166" select="tokenize('1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW', '\s')" />
  <xsl:variable name="clUNCL8273" select="tokenize('ADR ADS ADT ADU ADY ADZ ADV ADW ADX AEA AEB AGS ANR ARD CFR COM GVE GVS ICA IMD RGE RID UI ZZZ', '\s')" />
  <xsl:variable name="clTRED8155" select="tokenize('1 2 6 7 9 10 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45', '\s')" />
  <xsl:variable name="clConsignmentIDType" select="tokenize('GINC', '\s')" />
  <xsl:variable name="clICD" select="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230 0231 0232 0233 0234 0235 0236 0237 0238 0239 0240 0241 0242 0243 0244 0245 0246 0247 0248', '\s')" />
  <xsl:variable name="cleas" select="tokenize('0002 0007 0009 0060 0088 0096 0097 0106 0130 0135 0142 0151 0158 0183 0184 0188 0190 0191 0192 0195 0196 0198 0199 0200 0201 0204 0208 0209 0210 0211 0216 0218 0221 0225 0230 0235 0240 0242 0244 0245 0246 0248 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959', '\s')" />
  <xsl:variable name="clUNCL6313-T120" select="tokenize('AAF AAA AAB AAW AAX ABT ACV HT LN WD TC AAO ABJ T', '\s')" />
  <xsl:variable name="clUNCL8053" select="tokenize('AA AB AD AE AG AH AI AJ AK AL AM AN AO AP AQ AT BL BPN BPO BPP BPQ BPR BPS BPT BPU BPV BPW BPX BPY BPZ BR BX CH CN DPA DPB EFP EYP FPN FPR IL LAR LU MPA PA PBP PFP PL PPA PST RF RG RGF RO RR SPP STR SW TE TP TS TSU UL', '\s')" />
  <xsl:variable name="clFreightAllowanceChargeReasonCode" select="tokenize('1 2', '\s')" />
  <xsl:variable name="clTransportServiceCode" select="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25', '\s')" />
  <xsl:variable name="clUNCL1001" select="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 1999 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 539 550 551 552 553 554 575 576 577 578 579 580 581 582 583 584 585 586 587 588 589 610 621 622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637 638 639 640 641 642 643 644 645 646 647 648 649 650 651 652 653 654 655 656 657 658 659 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 717 718 719 720 721 722 723 724 725 726 727 728 729 730 731 732 733 734 735 736 737 738 739 740 741 742 743 744 745 746 747 748 749 750 751 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998', '\s')" />
  <xsl:variable name="clUNECERec21" select="tokenize('1A 1B 1D 1F 1G 1W 2C 3A 3H 43 44 4A 4B 4C 4D 4F 4G 4H 5H 5L 5M 6H 6P 7A 7B 8A 8B 8C AA AB AC AD AE AF AG AH AI AJ AL AM AP AT AV B4 BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CA CB CC CD CE CF CG CH CI CJ CK CL CM CN CO CP CQ CR CS CT CU CV CW CX CY CZ DA DB DC DG DH DI DJ DK DL DM DN DP DR DS DT DU DV DW DX DY EC ED EE EF EG EH EI EN FB FC FD FE FI FL FO FP FR FT FW FX GB GI GL GR GU GY GZ HA HB HC HG HN HR IA IB IC ID IE IF IG IH IK IL IN IZ JB JC JG JR JT JY KG KI LE LG LT LU LV LZ MA MB MC ME MR MS MT MW MX NA NE NF NG NS NT NU NV O1 O2 O3 O4 O5 O6 O7 O8 O9 OA OB OC OD OE OF OG OH OI OJ OK OL OM ON OP OQ OR OS OT OU OV OW OX OY OZ P1 P2 P3 P4 PA PB PC PD PE PF PG PH PI PJ PK PL PN PO PP PR PT PU PV PX PY PZ QA QB QC QD QF QG QH QJ QK QL QM QN QP QQ QR QS RD RG RJ RK RL RO RT RZ SA SB SC SD SE SH SI SK SL SM SO SP SS ST SU SV SW SX SY SZ T1 TB TC TD TE TG TI TK TL TN TO TR TS TT TU TV TW TY TZ UC UN VA VG VI VK VL VO VP VQ VN VR VS VY WA WB WC WD WF WG WH WJ WK WL WM WN WP WQ WR WS WT WU WV WW WX WY WZ XA XB XC XD XF XG XH XJ XK YA YB YC YD YF YG YH YJ YK YL YM YN YP YQ YR YS YT YV YW YX YY YZ ZA ZB ZC ZD ZF ZG ZH ZJ ZK ZL ZM ZN ZP ZQ ZR ZS ZT ZU ZV ZW ZX ZY ZZ', '\s')" />
  <xsl:variable name="clUNECERec19" select="tokenize('0 1 2 3 4 5 6 7 8 9', '\s')" />
  <xsl:variable name="clTransportHandlingUnitIDType" select="tokenize('SSCC', '\s')" />
  <xsl:variable name="clUNECERec20" select="tokenize('1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J 10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 A2 A3 A4 A5 A6 A7 A8 A9 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A20 A21 A22 A23 A24 A26 A27 A28 A29 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A40 A41 A42 A43 A44 A45 A47 A48 A49 A53 A54 A55 A56 A59 A68 A69 A70 A71 A73 A74 A75 A76 A84 A85 A86 A87 A88 A89 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B3 B4 B7 B8 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B30 B31 B32 B33 B34 B35 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C3 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C70 C71 C72 C73 C74 C75 C76 C78 C79 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D1 D2 D03 D04 D5 D6 D10 D11 D12 D13 D15 D16 D17 D18 D19 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DBM DBW DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E4 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FNU FOT FP FR FS FTK FTQ G01 G2 G3 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G20 G21 G23 G24 G25 G26 G27 G28 G29 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAD HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMO HMQ HMT HPA HTZ HUR HWE IA IE INH INK INQ ISD IU IUG IV J2 J10 J12 J13 J14 J15 J16 J17 J18 J19 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K2 K3 K6 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K20 K21 K22 K23 K26 K27 K28 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWN KWO KWS KWT KWY KX L2 L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M4 M5 M7 M9 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MKD MKM MKW MLD MLT MMK MMQ MMT MND MNJ MON MPA MQD MQH MQM MQS MQW MRD MRM MRW MSK MTK MTQ MTR MTS MTZ MVA MWH N1 N3 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NTU NU NX OA ODE ODG ODK ODM OHM ON ONZ OPM OT OZA OZI P1 P2 P5 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q3 Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q41 Q42 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 X1A X1B X1D X1F X1G X1W X2C X3A X3H X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C X43 X44 XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XO1 XO2 XO3 XO4 XO5 XO6 XO7 XO8 XO9 XOA XOB XOC XOD XOE XOF XOG XOH XOI XOJ XOK XOL XOM XON XOP XOQ XOR XOS XOT XOU XOV XOW XOX XOY XOZ XP1 XP2 XP3 XP4 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSX XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVN XVO XVP XVQ XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY XZZ YDK YDQ YRD Z9 Z11 ZP ZZ', '\s')" />
  <xsl:variable name="clUNCL7143" select="tokenize('AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EMD EN FS GB GMN GN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PPI PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSQ TSR TSS TST TSU UA UP VN VP VS VX ZZZ', '\s')" />

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan" mode="M19" priority="1950">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CustomizationID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CustomizationID">
          <xsl:attribute name="id">PEPPOL-T124-B00101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CustomizationID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ProfileID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ProfileID">
          <xsl:attribute name="id">PEPPOL-T124-B00102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ProfileID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B00103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IssueDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IssueDate">
          <xsl:attribute name="id">PEPPOL-T124-B00104</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IssueDate' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IssueTime" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IssueTime">
          <xsl:attribute name="id">PEPPOL-T124-B00105</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IssueTime' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:SenderParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:SenderParty">
          <xsl:attribute name="id">PEPPOL-T124-B00106</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:SenderParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:ReceiverParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:ReceiverParty">
          <xsl:attribute name="id">PEPPOL-T124-B00107</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:ReceiverParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TransportUserParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TransportUserParty">
          <xsl:attribute name="id">PEPPOL-T124-B00108</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TransportUserParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TransportServiceProviderParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TransportServiceProviderParty">
          <xsl:attribute name="id">PEPPOL-T124-B00109</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TransportServiceProviderParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:MainTransportationService" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:MainTransportationService">
          <xsl:attribute name="id">PEPPOL-T124-B00110</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:MainTransportationService' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Consignment" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Consignment">
          <xsl:attribute name="id">PEPPOL-T124-B00111</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Consignment' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@*:schemaLocation)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@*:schemaLocation)">
          <xsl:attribute name="id">PEPPOL-T124-B00112</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST not contain schema location.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cbc:CustomizationID" mode="M19" priority="1949">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cbc:CustomizationID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cbc:ProfileID" mode="M19" priority="1948">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cbc:ProfileID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cbc:ProfileExecutionID" mode="M19" priority="1947">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cbc:ProfileExecutionID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cbc:ID" mode="M19" priority="1946">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cbc:IssueDate" mode="M19" priority="1945">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cbc:IssueDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cbc:IssueTime" mode="M19" priority="1944">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cbc:IssueTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cbc:DocumentStatusCode" mode="M19" priority="1943">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cbc:DocumentStatusCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clDocumentStatusCode satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clDocumentStatusCode satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B00801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Document status code (openPEPPOL)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cbc:Note" mode="M19" priority="1942">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cbc:Note" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cbc:TransportUserRemarks" mode="M19" priority="1941">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cbc:TransportUserRemarks" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cbc:TransportServiceProviderRemarks" mode="M19" priority="1940">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cbc:TransportServiceProviderRemarks" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty" mode="M19" priority="1939">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">PEPPOL-T124-B01201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:EndpointID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyLegalEntity" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyLegalEntity">
          <xsl:attribute name="id">PEPPOL-T124-B01202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cbc:EndpointID" mode="M19" priority="1938">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B01301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B01302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyIdentification" mode="M19" priority="1937">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B01501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1936">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B01601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyName" mode="M19" priority="1935">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T124-B01801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyName/cbc:Name" mode="M19" priority="1934">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress" mode="M19" priority="1933">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B02001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1932">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1931">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1930">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1929">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1928">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1927">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B02601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1926">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:Country" mode="M19" priority="1925">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B02801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1924">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B02901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1923">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B02802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/*" mode="M19" priority="1922">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B02002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme" mode="M19" priority="1921">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">PEPPOL-T124-B03001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CompanyID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxScheme" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxScheme">
          <xsl:attribute name="id">PEPPOL-T124-B03002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/cbc:CompanyID" mode="M19" priority="1920">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M19" priority="1919">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B03201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M19" priority="1918">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M19" priority="1917">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B03202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/*" mode="M19" priority="1916">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B03003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity" mode="M19" priority="1915">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T124-B03401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1914">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1913">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B03601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B03602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M19" priority="1912">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B03801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M19" priority="1911">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M19" priority="1910">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1909">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B04101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M19" priority="1908">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B04001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M19" priority="1907">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B03802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/*" mode="M19" priority="1906">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B03402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact" mode="M19" priority="1905">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact/cbc:Name" mode="M19" priority="1904">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact/cbc:Telephone" mode="M19" priority="1903">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1902">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact/*" mode="M19" priority="1901">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B04201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:SenderParty/*" mode="M19" priority="1900">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:SenderParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B01203</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty" mode="M19" priority="1899">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">PEPPOL-T124-B04601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:EndpointID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T124-B04602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyIdentification' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyLegalEntity" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyLegalEntity">
          <xsl:attribute name="id">PEPPOL-T124-B04603</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cbc:EndpointID" mode="M19" priority="1898">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B04701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B04702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyIdentification" mode="M19" priority="1897">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyIdentification" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1896">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B05001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyName" mode="M19" priority="1895">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T124-B05201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyName/cbc:Name" mode="M19" priority="1894">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress" mode="M19" priority="1893">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B05401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1892">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1891">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1890">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1889">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1888">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1887">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B06001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1886">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:Country" mode="M19" priority="1885">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B06201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1884">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B06301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1883">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B06202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/*" mode="M19" priority="1882">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B05402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme" mode="M19" priority="1881">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">PEPPOL-T124-B06401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CompanyID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxScheme" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxScheme">
          <xsl:attribute name="id">PEPPOL-T124-B06402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/cbc:CompanyID" mode="M19" priority="1880">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M19" priority="1879">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B06601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M19" priority="1878">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M19" priority="1877">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B06602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/*" mode="M19" priority="1876">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B06403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity" mode="M19" priority="1875">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T124-B06801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1874">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1873">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B07001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B07002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M19" priority="1872">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B07201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M19" priority="1871">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M19" priority="1870">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1869">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B07501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M19" priority="1868">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B07401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M19" priority="1867">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B07202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/*" mode="M19" priority="1866">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B06802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact" mode="M19" priority="1865">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact/cbc:Name" mode="M19" priority="1864">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact/cbc:Telephone" mode="M19" priority="1863">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1862">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact/*" mode="M19" priority="1861">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B07601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:ReceiverParty/*" mode="M19" priority="1860">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:ReceiverParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B04604</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty" mode="M19" priority="1859">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyLegalEntity" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyLegalEntity">
          <xsl:attribute name="id">PEPPOL-T124-B08001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyIdentification" mode="M19" priority="1858">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B08101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1857">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B08201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyName" mode="M19" priority="1856">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T124-B08401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyName/cbc:Name" mode="M19" priority="1855">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress" mode="M19" priority="1854">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B08601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1853">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1852">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1851">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1850">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1849">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1848">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B09201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1847">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:Country" mode="M19" priority="1846">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B09401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1845">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B09501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1844">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B09402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/*" mode="M19" priority="1843">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B08602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme" mode="M19" priority="1842">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">PEPPOL-T124-B09601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CompanyID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxScheme" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxScheme">
          <xsl:attribute name="id">PEPPOL-T124-B09602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/cbc:CompanyID" mode="M19" priority="1841">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M19" priority="1840">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B09801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M19" priority="1839">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M19" priority="1838">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B09802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/*" mode="M19" priority="1837">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B09603</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity" mode="M19" priority="1836">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T124-B10001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1835">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1834">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B10201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B10202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M19" priority="1833">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B10401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M19" priority="1832">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M19" priority="1831">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1830">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B10701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M19" priority="1829">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B10601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M19" priority="1828">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B10402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/*" mode="M19" priority="1827">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B10002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact" mode="M19" priority="1826">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact/cbc:Name" mode="M19" priority="1825">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact/cbc:Telephone" mode="M19" priority="1824">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1823">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact/*" mode="M19" priority="1822">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B10801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportUserParty/*" mode="M19" priority="1821">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportUserParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B08002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty" mode="M19" priority="1820">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyLegalEntity" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyLegalEntity">
          <xsl:attribute name="id">PEPPOL-T124-B11201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyIdentification" mode="M19" priority="1819">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B11301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1818">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B11401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyName" mode="M19" priority="1817">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T124-B11601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyName/cbc:Name" mode="M19" priority="1816">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress" mode="M19" priority="1815">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B11801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1814">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1813">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1812">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1811">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1810">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1809">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B12401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1808">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:Country" mode="M19" priority="1807">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B12601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1806">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B12701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1805">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B12602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/*" mode="M19" priority="1804">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B11802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme" mode="M19" priority="1803">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">PEPPOL-T124-B12801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CompanyID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxScheme" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxScheme">
          <xsl:attribute name="id">PEPPOL-T124-B12802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/cbc:CompanyID" mode="M19" priority="1802">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M19" priority="1801">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B13001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M19" priority="1800">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M19" priority="1799">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B13002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/*" mode="M19" priority="1798">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B12803</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity" mode="M19" priority="1797">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T124-B13201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1796">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1795">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B13401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B13402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M19" priority="1794">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B13601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M19" priority="1793">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M19" priority="1792">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B13801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1791">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B13901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M19" priority="1790">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B13802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M19" priority="1789">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B13602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/*" mode="M19" priority="1788">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B13202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact" mode="M19" priority="1787">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact/cbc:Name" mode="M19" priority="1786">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact/cbc:Telephone" mode="M19" priority="1785">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1784">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact/*" mode="M19" priority="1783">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B14001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/*" mode="M19" priority="1782">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportServiceProviderParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B11202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty" mode="M19" priority="1781">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyLegalEntity" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyLegalEntity">
          <xsl:attribute name="id">PEPPOL-T124-B14401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyIdentification" mode="M19" priority="1780">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B14501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1779">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B14601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B14602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyName" mode="M19" priority="1778">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T124-B14801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyName/cbc:Name" mode="M19" priority="1777">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress" mode="M19" priority="1776">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B15001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1775">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1774">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1773">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1772">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1771">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1770">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B15601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1769">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:Country" mode="M19" priority="1768">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B15801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1767">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B15901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1766">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B15802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/*" mode="M19" priority="1765">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B15002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme" mode="M19" priority="1764">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">PEPPOL-T124-B16001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CompanyID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxScheme" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxScheme">
          <xsl:attribute name="id">PEPPOL-T124-B16002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/cbc:CompanyID" mode="M19" priority="1763">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M19" priority="1762">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B16201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M19" priority="1761">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M19" priority="1760">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B16202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/*" mode="M19" priority="1759">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B16003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity" mode="M19" priority="1758">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T124-B16401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1757">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1756">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B16601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B16602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M19" priority="1755">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B16801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M19" priority="1754">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M19" priority="1753">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1752">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B17101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M19" priority="1751">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B17001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M19" priority="1750">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B16802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/*" mode="M19" priority="1749">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B16402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact" mode="M19" priority="1748">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact/cbc:Name" mode="M19" priority="1747">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact/cbc:Telephone" mode="M19" priority="1746">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1745">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact/*" mode="M19" priority="1744">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B17201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:BillToParty/*" mode="M19" priority="1743">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:BillToParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B14402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference" mode="M19" priority="1742">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B17601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference/cbc:ID" mode="M19" priority="1741">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference/cbc:IssueDate" mode="M19" priority="1740">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference/cbc:IssueDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference/cbc:IssueTime" mode="M19" priority="1739">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference/cbc:IssueTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference/*" mode="M19" priority="1738">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:TransportExecutionPlanRequestDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B17602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference" mode="M19" priority="1737">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B18001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cbc:ID" mode="M19" priority="1736">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cbc:DocumentTypeCode" mode="M19" priority="1735">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cbc:DocumentTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B18201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Document name code, full list (UNCL1001)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cbc:DocumentType" mode="M19" priority="1734">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cbc:DocumentType" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment" mode="M19" priority="1733">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject" mode="M19" priority="1732">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@mimeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@mimeCode">
          <xsl:attribute name="id">PEPPOL-T124-B18501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'mimeCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@mimeCode) or (some $code in $clMimeCode satisfies $code = @mimeCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@mimeCode) or (some $code in $clMimeCode satisfies $code = @mimeCode)">
          <xsl:attribute name="id">PEPPOL-T124-B18502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Mime code (IANA Subset)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@filename" />
      <xsl:otherwise>
        <svrl:failed-assert test="@filename">
          <xsl:attribute name="id">PEPPOL-T124-B18503</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'filename' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference" mode="M19" priority="1731">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:URI" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:URI">
          <xsl:attribute name="id">PEPPOL-T124-B18801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:URI' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI" mode="M19" priority="1730">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/*" mode="M19" priority="1729">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B18802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/*" mode="M19" priority="1728">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/cac:Attachment/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B18401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/*" mode="M19" priority="1727">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B18002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:MainTransportationService" mode="M19" priority="1726">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:MainTransportationService" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TransportServiceCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TransportServiceCode">
          <xsl:attribute name="id">PEPPOL-T124-B19001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TransportServiceCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:MainTransportationService/cbc:TransportServiceCode" mode="M19" priority="1725">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:MainTransportationService/cbc:TransportServiceCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clTransportServiceCode satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clTransportServiceCode satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B19101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Transport Service Code (openPEPPOL)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:MainTransportationService/cbc:TransportationServiceDescription" mode="M19" priority="1724">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:MainTransportationService/cbc:TransportationServiceDescription" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:MainTransportationService/*" mode="M19" priority="1723">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:MainTransportationService/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B19002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalTransportationService" mode="M19" priority="1722">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalTransportationService" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TransportServiceCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TransportServiceCode">
          <xsl:attribute name="id">PEPPOL-T124-B19301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TransportServiceCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalTransportationService/cbc:TransportServiceCode" mode="M19" priority="1721">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalTransportationService/cbc:TransportServiceCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clTransportServiceCode satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clTransportServiceCode satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B19401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Transport Service Code (openPEPPOL)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalTransportationService/cbc:TransportationServiceDescription" mode="M19" priority="1720">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalTransportationService/cbc:TransportationServiceDescription" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:AdditionalTransportationService/*" mode="M19" priority="1719">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:AdditionalTransportationService/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B19302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment" mode="M19" priority="1718">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B19601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:ConsigneeParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:ConsigneeParty">
          <xsl:attribute name="id">PEPPOL-T124-B19602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:ConsigneeParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:ConsignorParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:ConsignorParty">
          <xsl:attribute name="id">PEPPOL-T124-B19603</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:ConsignorParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cbc:ID" mode="M19" priority="1717">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clConsignmentIDType satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clConsignmentIDType satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B19701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Type of Consignment ID (openPEPPOL)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cbc:ConsigneeAssignedID" mode="M19" priority="1716">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:ConsigneeAssignedID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cbc:ConsignorAssignedID" mode="M19" priority="1715">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:ConsignorAssignedID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cbc:GrossWeightMeasure" mode="M19" priority="1714">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:GrossWeightMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B20101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cbc:GrossVolumeMeasure" mode="M19" priority="1713">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:GrossVolumeMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B20301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cbc:LoadingLengthMeasure" mode="M19" priority="1712">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:LoadingLengthMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B20501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cbc:HazardousRiskIndicator" mode="M19" priority="1711">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:HazardousRiskIndicator" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cbc:TotalTransportHandlingUnitQuantity" mode="M19" priority="1710">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cbc:TotalTransportHandlingUnitQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B20801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration" mode="M19" priority="1709">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B21001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cbc:ID" mode="M19" priority="1708">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cbc:FunctionCode" mode="M19" priority="1707">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cbc:FunctionCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:ValidityPeriod" mode="M19" priority="1706">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:ValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:StartDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:StartDate">
          <xsl:attribute name="id">PEPPOL-T124-B21301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:StartDate' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:ValidityPeriod/cbc:StartDate" mode="M19" priority="1705">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:ValidityPeriod/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:ValidityPeriod/*" mode="M19" priority="1704">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:ValidityPeriod/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B21302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty" mode="M19" priority="1703">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyLegalEntity" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyLegalEntity">
          <xsl:attribute name="id">PEPPOL-T124-B21501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyIdentification" mode="M19" priority="1702">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B21601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1701">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B21701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyName" mode="M19" priority="1700">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T124-B21901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyName/cbc:Name" mode="M19" priority="1699">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress" mode="M19" priority="1698">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B22101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1697">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1696">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1695">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1694">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1693">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1692">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B22701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1691">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:Country" mode="M19" priority="1690">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B22901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1689">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B23001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1688">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B22902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/*" mode="M19" priority="1687">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B22102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme" mode="M19" priority="1686">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">PEPPOL-T124-B23101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CompanyID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxScheme" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxScheme">
          <xsl:attribute name="id">PEPPOL-T124-B23102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/cbc:CompanyID" mode="M19" priority="1685">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M19" priority="1684">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B23301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M19" priority="1683">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M19" priority="1682">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B23302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/*" mode="M19" priority="1681">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B23103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity" mode="M19" priority="1680">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T124-B23501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1679">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1678">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B23701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B23702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M19" priority="1677">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B23901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M19" priority="1676">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M19" priority="1675">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B24101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1674">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B24201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M19" priority="1673">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B24102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M19" priority="1672">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B23902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/*" mode="M19" priority="1671">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B23502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact" mode="M19" priority="1670">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact/cbc:Name" mode="M19" priority="1669">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact/cbc:Telephone" mode="M19" priority="1668">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1667">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact/*" mode="M19" priority="1666">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B24301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/*" mode="M19" priority="1665">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:CustomsParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B21502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference" mode="M19" priority="1664">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B24701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference/cbc:ID" mode="M19" priority="1663">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference/cbc:DocumentTypeCode" mode="M19" priority="1662">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference/cbc:DocumentTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B24901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Document name code, full list (UNCL1001)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference/cbc:DocumentType" mode="M19" priority="1661">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference/cbc:DocumentType" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference/*" mode="M19" priority="1660">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/cac:AdditionalDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B24702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/*" mode="M19" priority="1659">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CustomsDeclaration/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B21002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent" mode="M19" priority="1658">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Location" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Location">
          <xsl:attribute name="id">PEPPOL-T124-B25101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Location' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Period" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Period">
          <xsl:attribute name="id">PEPPOL-T124-B25102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Period' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cbc:IdentificationID" mode="M19" priority="1657">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cbc:IdentificationID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location" mode="M19" priority="1656">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cbc:ID" mode="M19" priority="1655">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B25401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cbc:Name" mode="M19" priority="1654">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address" mode="M19" priority="1653">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:StreetName" mode="M19" priority="1652">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" mode="M19" priority="1651">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:CityName" mode="M19" priority="1650">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:PostalZone" mode="M19" priority="1649">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" mode="M19" priority="1648">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:AddressLine" mode="M19" priority="1647">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B26301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" mode="M19" priority="1646">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:Country" mode="M19" priority="1645">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:Country" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" mode="M19" priority="1644">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B26601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:Country/*" mode="M19" priority="1643">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B26501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" mode="M19" priority="1642">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CoordinateSystemCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CoordinateSystemCode">
          <xsl:attribute name="id">PEPPOL-T124-B26701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CoordinateSystemCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LatitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LatitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B26702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LongitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LongitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B26703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" mode="M19" priority="1641">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" mode="M19" priority="1640">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B26901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B26902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" mode="M19" priority="1639">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B27101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B27102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" mode="M19" priority="1638">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B27301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B27302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" mode="M19" priority="1637">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B26704</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/*" mode="M19" priority="1636">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B25701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/*" mode="M19" priority="1635">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Location/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B25301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period" mode="M19" priority="1634">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/cbc:StartDate" mode="M19" priority="1633">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/cbc:StartTime" mode="M19" priority="1632">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/cbc:EndDate" mode="M19" priority="1631">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/cbc:EndTime" mode="M19" priority="1630">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/*" mode="M19" priority="1629">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B27501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/*" mode="M19" priority="1628">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedPickupTransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B25103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent" mode="M19" priority="1627">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Location" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Location">
          <xsl:attribute name="id">PEPPOL-T124-B28001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Location' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Period" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Period">
          <xsl:attribute name="id">PEPPOL-T124-B28002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Period' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cbc:IdentificationID" mode="M19" priority="1626">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cbc:IdentificationID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location" mode="M19" priority="1625">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cbc:ID" mode="M19" priority="1624">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B28301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cbc:Name" mode="M19" priority="1623">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address" mode="M19" priority="1622">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:StreetName" mode="M19" priority="1621">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" mode="M19" priority="1620">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:CityName" mode="M19" priority="1619">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:PostalZone" mode="M19" priority="1618">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" mode="M19" priority="1617">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:AddressLine" mode="M19" priority="1616">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B29201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" mode="M19" priority="1615">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country" mode="M19" priority="1614">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" mode="M19" priority="1613">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B29501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country/*" mode="M19" priority="1612">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B29401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" mode="M19" priority="1611">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CoordinateSystemCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CoordinateSystemCode">
          <xsl:attribute name="id">PEPPOL-T124-B29601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CoordinateSystemCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LatitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LatitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B29602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LongitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LongitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B29603</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" mode="M19" priority="1610">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" mode="M19" priority="1609">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B29801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B29802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" mode="M19" priority="1608">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B30001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B30002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" mode="M19" priority="1607">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B30201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B30202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" mode="M19" priority="1606">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B29604</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/*" mode="M19" priority="1605">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B28601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/*" mode="M19" priority="1604">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Location/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B28201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period" mode="M19" priority="1603">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/cbc:StartDate" mode="M19" priority="1602">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/cbc:StartTime" mode="M19" priority="1601">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/cbc:EndDate" mode="M19" priority="1600">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/cbc:EndTime" mode="M19" priority="1599">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/*" mode="M19" priority="1598">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B30401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/*" mode="M19" priority="1597">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:RequestedDeliveryTransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B28003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent" mode="M19" priority="1596">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Location" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Location">
          <xsl:attribute name="id">PEPPOL-T124-B30901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Location' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Period" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Period">
          <xsl:attribute name="id">PEPPOL-T124-B30902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Period' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cbc:IdentificationID" mode="M19" priority="1595">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cbc:IdentificationID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location" mode="M19" priority="1594">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cbc:ID" mode="M19" priority="1593">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B31201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cbc:Name" mode="M19" priority="1592">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address" mode="M19" priority="1591">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:StreetName" mode="M19" priority="1590">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" mode="M19" priority="1589">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:CityName" mode="M19" priority="1588">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:PostalZone" mode="M19" priority="1587">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" mode="M19" priority="1586">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:AddressLine" mode="M19" priority="1585">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B32101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" mode="M19" priority="1584">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:Country" mode="M19" priority="1583">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:Country" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" mode="M19" priority="1582">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B32401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:Country/*" mode="M19" priority="1581">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B32301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" mode="M19" priority="1580">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CoordinateSystemCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CoordinateSystemCode">
          <xsl:attribute name="id">PEPPOL-T124-B32501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CoordinateSystemCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LatitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LatitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B32502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LongitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LongitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B32503</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" mode="M19" priority="1579">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" mode="M19" priority="1578">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B32701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B32702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" mode="M19" priority="1577">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B32901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B32902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" mode="M19" priority="1576">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B33101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B33102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" mode="M19" priority="1575">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B32504</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/*" mode="M19" priority="1574">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B31501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/*" mode="M19" priority="1573">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Location/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B31101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period" mode="M19" priority="1572">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/cbc:StartDate" mode="M19" priority="1571">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/cbc:StartTime" mode="M19" priority="1570">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/cbc:EndDate" mode="M19" priority="1569">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/cbc:EndTime" mode="M19" priority="1568">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/*" mode="M19" priority="1567">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B33301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/*" mode="M19" priority="1566">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedPickupTransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B30903</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent" mode="M19" priority="1565">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Location" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Location">
          <xsl:attribute name="id">PEPPOL-T124-B33801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Location' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Period" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Period">
          <xsl:attribute name="id">PEPPOL-T124-B33802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Period' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cbc:IdentificationID" mode="M19" priority="1564">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cbc:IdentificationID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location" mode="M19" priority="1563">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cbc:ID" mode="M19" priority="1562">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B34101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cbc:Name" mode="M19" priority="1561">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address" mode="M19" priority="1560">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:StreetName" mode="M19" priority="1559">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" mode="M19" priority="1558">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:CityName" mode="M19" priority="1557">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:PostalZone" mode="M19" priority="1556">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" mode="M19" priority="1555">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:AddressLine" mode="M19" priority="1554">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B35001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" mode="M19" priority="1553">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country" mode="M19" priority="1552">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" mode="M19" priority="1551">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B35301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country/*" mode="M19" priority="1550">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B35201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" mode="M19" priority="1549">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CoordinateSystemCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CoordinateSystemCode">
          <xsl:attribute name="id">PEPPOL-T124-B35401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CoordinateSystemCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LatitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LatitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B35402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LongitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LongitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B35403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" mode="M19" priority="1548">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" mode="M19" priority="1547">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B35601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B35602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" mode="M19" priority="1546">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B35801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B35802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" mode="M19" priority="1545">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B36001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B36002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" mode="M19" priority="1544">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B35404</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/*" mode="M19" priority="1543">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B34401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/*" mode="M19" priority="1542">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Location/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B34001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period" mode="M19" priority="1541">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/cbc:StartDate" mode="M19" priority="1540">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/cbc:StartTime" mode="M19" priority="1539">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/cbc:EndDate" mode="M19" priority="1538">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/cbc:EndTime" mode="M19" priority="1537">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/*" mode="M19" priority="1536">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B36201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/*" mode="M19" priority="1535">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PlannedDeliveryTransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B33803</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty" mode="M19" priority="1534">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyIdentification" mode="M19" priority="1533">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B36801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1532">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B36901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyName" mode="M19" priority="1531">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T124-B37101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyName/cbc:Name" mode="M19" priority="1530">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress" mode="M19" priority="1529">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B37301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1528">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1527">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1526">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1525">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1524">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1523">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B37901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1522">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:Country" mode="M19" priority="1521">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B38101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1520">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B38201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1519">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B38102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/*" mode="M19" priority="1518">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B37302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity" mode="M19" priority="1517">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T124-B38301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1516">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1515">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B38501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B38502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M19" priority="1514">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B38701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M19" priority="1513">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M19" priority="1512">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B38901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1511">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B39001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M19" priority="1510">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B38902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M19" priority="1509">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B38702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/*" mode="M19" priority="1508">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B38302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact" mode="M19" priority="1507">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact/cbc:Name" mode="M19" priority="1506">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact/cbc:Telephone" mode="M19" priority="1505">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1504">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact/*" mode="M19" priority="1503">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B39101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/*" mode="M19" priority="1502">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B36701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty" mode="M19" priority="1501">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyIdentification" mode="M19" priority="1500">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B39601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1499">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B39701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyName" mode="M19" priority="1498">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T124-B39901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyName/cbc:Name" mode="M19" priority="1497">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress" mode="M19" priority="1496">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B40101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1495">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1494">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1493">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1492">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1491">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1490">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B40701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1489">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:Country" mode="M19" priority="1488">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B40901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1487">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B41001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1486">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B40902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/*" mode="M19" priority="1485">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B40102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity" mode="M19" priority="1484">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T124-B41101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1483">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1482">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B41301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B41302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M19" priority="1481">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B41501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M19" priority="1480">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M19" priority="1479">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1478">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B41801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M19" priority="1477">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B41701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M19" priority="1476">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B41502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/*" mode="M19" priority="1475">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B41102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact" mode="M19" priority="1474">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact/cbc:Name" mode="M19" priority="1473">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact/cbc:Telephone" mode="M19" priority="1472">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1471">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact/*" mode="M19" priority="1470">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B41901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/*" mode="M19" priority="1469">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B39501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty" mode="M19" priority="1468">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyIdentification" mode="M19" priority="1467">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B42401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1466">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B42501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyName" mode="M19" priority="1465">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T124-B42701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyName/cbc:Name" mode="M19" priority="1464">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress" mode="M19" priority="1463">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B42901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1462">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1461">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1460">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1459">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1458">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1457">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B43501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1456">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country" mode="M19" priority="1455">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B43701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1454">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B43801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1453">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B43702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/*" mode="M19" priority="1452">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B42902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity" mode="M19" priority="1451">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T124-B43901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1450">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1449">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B44101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B44102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M19" priority="1448">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B44301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M19" priority="1447">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M19" priority="1446">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B44501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1445">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B44601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M19" priority="1444">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B44502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M19" priority="1443">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B44302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/*" mode="M19" priority="1442">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B43902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact" mode="M19" priority="1441">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact/cbc:Name" mode="M19" priority="1440">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact/cbc:Telephone" mode="M19" priority="1439">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1438">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact/*" mode="M19" priority="1437">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B44701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person" mode="M19" priority="1436">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:IdentityDocumentReference" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:IdentityDocumentReference">
          <xsl:attribute name="id">PEPPOL-T124-B45101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:IdentityDocumentReference' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference" mode="M19" priority="1435">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B45201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:DocumentType" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:DocumentType">
          <xsl:attribute name="id">PEPPOL-T124-B45202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:DocumentType' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID" mode="M19" priority="1434">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType" mode="M19" priority="1433">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*" mode="M19" priority="1432">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B45203</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/*" mode="M19" priority="1431">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/cac:Person/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B45102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/*" mode="M19" priority="1430">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:CarrierParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B42301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OriginalDepartureCountry" mode="M19" priority="1429">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OriginalDepartureCountry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B45501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OriginalDepartureCountry/cbc:IdentificationCode" mode="M19" priority="1428">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OriginalDepartureCountry/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B45601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OriginalDepartureCountry/*" mode="M19" priority="1427">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OriginalDepartureCountry/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B45502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:FinalDestinationCountry" mode="M19" priority="1426">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FinalDestinationCountry" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:FinalDestinationCountry/cbc:IdentificationCode" mode="M19" priority="1425">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FinalDestinationCountry/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B45801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:FinalDestinationCountry/*" mode="M19" priority="1424">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FinalDestinationCountry/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B45701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent" mode="M19" priority="1423">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Period" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Period">
          <xsl:attribute name="id">PEPPOL-T124-B45901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Period' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location" mode="M19" priority="1422">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cbc:ID" mode="M19" priority="1421">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B46101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cbc:Name" mode="M19" priority="1420">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address" mode="M19" priority="1419">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:StreetName" mode="M19" priority="1418">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" mode="M19" priority="1417">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:CityName" mode="M19" priority="1416">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:PostalZone" mode="M19" priority="1415">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" mode="M19" priority="1414">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:AddressLine" mode="M19" priority="1413">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B47001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" mode="M19" priority="1412">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:Country" mode="M19" priority="1411">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:Country" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" mode="M19" priority="1410">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B47301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:Country/*" mode="M19" priority="1409">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B47201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" mode="M19" priority="1408">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CoordinateSystemCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CoordinateSystemCode">
          <xsl:attribute name="id">PEPPOL-T124-B47401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CoordinateSystemCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LatitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LatitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B47402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LongitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LongitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B47403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" mode="M19" priority="1407">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" mode="M19" priority="1406">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B47601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B47602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" mode="M19" priority="1405">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B47801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B47802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" mode="M19" priority="1404">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B48001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B48002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" mode="M19" priority="1403">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B47404</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/*" mode="M19" priority="1402">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B46401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/*" mode="M19" priority="1401">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Location/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B46001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period" mode="M19" priority="1400">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/cbc:StartDate" mode="M19" priority="1399">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/cbc:StartTime" mode="M19" priority="1398">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/cbc:EndDate" mode="M19" priority="1397">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/cbc:EndTime" mode="M19" priority="1396">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/*" mode="M19" priority="1395">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B48201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/*" mode="M19" priority="1394">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B45902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms" mode="M19" priority="1393">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cbc:ID" mode="M19" priority="1392">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cbc:SpecialTerms" mode="M19" priority="1391">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cbc:SpecialTerms" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cac:DeliveryLocation" mode="M19" priority="1390">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cac:DeliveryLocation" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cac:DeliveryLocation/cbc:ID" mode="M19" priority="1389">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cac:DeliveryLocation/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B49101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cac:DeliveryLocation/cbc:Name" mode="M19" priority="1388">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cac:DeliveryLocation/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cac:DeliveryLocation/*" mode="M19" priority="1387">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/cac:DeliveryLocation/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B49001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/*" mode="M19" priority="1386">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DeliveryTerms/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B48701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PaymentTerms" mode="M19" priority="1385">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PaymentTerms" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PaymentTerms/cbc:ID" mode="M19" priority="1384">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PaymentTerms/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PaymentTerms/cbc:Note" mode="M19" priority="1383">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PaymentTerms/cbc:Note" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PaymentTerms/*" mode="M19" priority="1382">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PaymentTerms/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B49401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge" mode="M19" priority="1381">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ChargeIndicator" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ChargeIndicator">
          <xsl:attribute name="id">PEPPOL-T124-B49701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ChargeIndicator' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AllowanceChargeReasonCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AllowanceChargeReasonCode">
          <xsl:attribute name="id">PEPPOL-T124-B49702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:AllowanceChargeReasonCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Amount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Amount">
          <xsl:attribute name="id">PEPPOL-T124-B49703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Amount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge/cbc:ChargeIndicator" mode="M19" priority="1380">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge/cbc:ChargeIndicator" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge/cbc:AllowanceChargeReasonCode" mode="M19" priority="1379">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clFreightAllowanceChargeReasonCode satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clFreightAllowanceChargeReasonCode satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B49901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Freight Allowance-Charge Reason Code'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge/cbc:Amount" mode="M19" priority="1378">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge/cbc:Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T124-B50001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge/*" mode="M19" priority="1377">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:FreightAllowanceCharge/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B49704</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage" mode="M19" priority="1376">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TransportModeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TransportModeCode">
          <xsl:attribute name="id">PEPPOL-T124-B50201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TransportModeCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cbc:TransportModeCode" mode="M19" priority="1375">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cbc:TransportModeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNECERec19 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNECERec19 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B50301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommandation 19 (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cbc:HazardousRiskIndicator" mode="M19" priority="1374">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cbc:HazardousRiskIndicator" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty" mode="M19" priority="1373">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification" mode="M19" priority="1372">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B50601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1371">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B50701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyName" mode="M19" priority="1370">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T124-B50901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyName/cbc:Name" mode="M19" priority="1369">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress" mode="M19" priority="1368">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B51101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1367">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1366">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1365">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1364">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1363">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1362">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B51701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1361">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country" mode="M19" priority="1360">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B51901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1359">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B52001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1358">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B51902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/*" mode="M19" priority="1357">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B51102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity" mode="M19" priority="1356">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T124-B52101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1355">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1354">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B52301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B52302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M19" priority="1353">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B52501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M19" priority="1352">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M19" priority="1351">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B52701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1350">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B52801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M19" priority="1349">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B52702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M19" priority="1348">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B52502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/*" mode="M19" priority="1347">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B52102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact" mode="M19" priority="1346">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Name" mode="M19" priority="1345">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Telephone" mode="M19" priority="1344">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1343">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact/*" mode="M19" priority="1342">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B52901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person" mode="M19" priority="1341">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:IdentityDocumentReference" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:IdentityDocumentReference">
          <xsl:attribute name="id">PEPPOL-T124-B53301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:IdentityDocumentReference' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference" mode="M19" priority="1340">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B53401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:DocumentType" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:DocumentType">
          <xsl:attribute name="id">PEPPOL-T124-B53402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:DocumentType' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID" mode="M19" priority="1339">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType" mode="M19" priority="1338">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*" mode="M19" priority="1337">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B53403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/*" mode="M19" priority="1336">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/cac:Person/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B53302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/*" mode="M19" priority="1335">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:CarrierParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B50501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent" mode="M19" priority="1334">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Location" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Location">
          <xsl:attribute name="id">PEPPOL-T124-B53701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Location' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Period" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Period">
          <xsl:attribute name="id">PEPPOL-T124-B53702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Period' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cbc:IdentificationID" mode="M19" priority="1333">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cbc:IdentificationID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location" mode="M19" priority="1332">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:ID" mode="M19" priority="1331">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B54001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:Name" mode="M19" priority="1330">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address" mode="M19" priority="1329">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B54301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:StreetName" mode="M19" priority="1328">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" mode="M19" priority="1327">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CityName" mode="M19" priority="1326">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:PostalZone" mode="M19" priority="1325">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" mode="M19" priority="1324">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine" mode="M19" priority="1323">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B54901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" mode="M19" priority="1322">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country" mode="M19" priority="1321">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B55101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" mode="M19" priority="1320">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B55201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/*" mode="M19" priority="1319">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B55102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" mode="M19" priority="1318">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CoordinateSystemCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CoordinateSystemCode">
          <xsl:attribute name="id">PEPPOL-T124-B55301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CoordinateSystemCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LatitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LatitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B55302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LongitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LongitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B55303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" mode="M19" priority="1317">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" mode="M19" priority="1316">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B55501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B55502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" mode="M19" priority="1315">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B55701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B55702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" mode="M19" priority="1314">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B55901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B55902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" mode="M19" priority="1313">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B55304</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/*" mode="M19" priority="1312">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B54302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/*" mode="M19" priority="1311">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B53901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period" mode="M19" priority="1310">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartDate" mode="M19" priority="1309">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartTime" mode="M19" priority="1308">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndDate" mode="M19" priority="1307">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndTime" mode="M19" priority="1306">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/*" mode="M19" priority="1305">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B56101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/*" mode="M19" priority="1304">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedDepartureTransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B53703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent" mode="M19" priority="1303">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationID">
          <xsl:attribute name="id">PEPPOL-T124-B56601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Location" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Location">
          <xsl:attribute name="id">PEPPOL-T124-B56602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Location' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Period" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Period">
          <xsl:attribute name="id">PEPPOL-T124-B56603</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Period' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cbc:IdentificationID" mode="M19" priority="1302">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cbc:IdentificationID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location" mode="M19" priority="1301">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:ID" mode="M19" priority="1300">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B56901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:Name" mode="M19" priority="1299">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address" mode="M19" priority="1298">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B57201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:StreetName" mode="M19" priority="1297">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:CityName" mode="M19" priority="1296">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:PostalZone" mode="M19" priority="1295">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country" mode="M19" priority="1294">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B57601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" mode="M19" priority="1293">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B57701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/*" mode="M19" priority="1292">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B57602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/*" mode="M19" priority="1291">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B57202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/*" mode="M19" priority="1290">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B56801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period" mode="M19" priority="1289">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartDate" mode="M19" priority="1288">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartTime" mode="M19" priority="1287">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndDate" mode="M19" priority="1286">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndTime" mode="M19" priority="1285">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/*" mode="M19" priority="1284">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B57801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/*" mode="M19" priority="1283">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/cac:PlannedArrivalTransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B56604</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/*" mode="M19" priority="1282">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B50202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage" mode="M19" priority="1281">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TransportModeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TransportModeCode">
          <xsl:attribute name="id">PEPPOL-T124-B58301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TransportModeCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cbc:TransportModeCode" mode="M19" priority="1280">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cbc:TransportModeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNECERec19 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNECERec19 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B58401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommandation 19 (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty" mode="M19" priority="1279">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification" mode="M19" priority="1278">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B58601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1277">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B58701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyName" mode="M19" priority="1276">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T124-B58901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyName/cbc:Name" mode="M19" priority="1275">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress" mode="M19" priority="1274">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B59101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1273">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1272">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1271">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1270">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1269">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1268">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B59701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1267">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country" mode="M19" priority="1266">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B59901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1265">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B60001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1264">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B59902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/*" mode="M19" priority="1263">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B59102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity" mode="M19" priority="1262">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T124-B60101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1261">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1260">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B60301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B60302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M19" priority="1259">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B60501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M19" priority="1258">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M19" priority="1257">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B60701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1256">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B60801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M19" priority="1255">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B60702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M19" priority="1254">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B60502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/*" mode="M19" priority="1253">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B60102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact" mode="M19" priority="1252">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Name" mode="M19" priority="1251">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Telephone" mode="M19" priority="1250">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1249">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact/*" mode="M19" priority="1248">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B60901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person" mode="M19" priority="1247">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:IdentityDocumentReference" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:IdentityDocumentReference">
          <xsl:attribute name="id">PEPPOL-T124-B61301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:IdentityDocumentReference' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference" mode="M19" priority="1246">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B61401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:DocumentType" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:DocumentType">
          <xsl:attribute name="id">PEPPOL-T124-B61402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:DocumentType' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID" mode="M19" priority="1245">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType" mode="M19" priority="1244">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*" mode="M19" priority="1243">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B61403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/*" mode="M19" priority="1242">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/cac:Person/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B61302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/*" mode="M19" priority="1241">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:CarrierParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B58501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent" mode="M19" priority="1240">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Location" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Location">
          <xsl:attribute name="id">PEPPOL-T124-B61701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Location' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Period" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Period">
          <xsl:attribute name="id">PEPPOL-T124-B61702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Period' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cbc:IdentificationID" mode="M19" priority="1239">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cbc:IdentificationID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location" mode="M19" priority="1238">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:ID" mode="M19" priority="1237">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B62001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:Name" mode="M19" priority="1236">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address" mode="M19" priority="1235">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B62301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:StreetName" mode="M19" priority="1234">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" mode="M19" priority="1233">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CityName" mode="M19" priority="1232">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:PostalZone" mode="M19" priority="1231">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" mode="M19" priority="1230">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine" mode="M19" priority="1229">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B62901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" mode="M19" priority="1228">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country" mode="M19" priority="1227">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B63101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" mode="M19" priority="1226">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B63201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/*" mode="M19" priority="1225">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B63102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" mode="M19" priority="1224">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CoordinateSystemCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CoordinateSystemCode">
          <xsl:attribute name="id">PEPPOL-T124-B63301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CoordinateSystemCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LatitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LatitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B63302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LongitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LongitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B63303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" mode="M19" priority="1223">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" mode="M19" priority="1222">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B63501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B63502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" mode="M19" priority="1221">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B63701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B63702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" mode="M19" priority="1220">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B63901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B63902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" mode="M19" priority="1219">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B63304</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/*" mode="M19" priority="1218">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B62302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/*" mode="M19" priority="1217">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B61901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period" mode="M19" priority="1216">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartDate" mode="M19" priority="1215">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartTime" mode="M19" priority="1214">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndDate" mode="M19" priority="1213">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndTime" mode="M19" priority="1212">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/*" mode="M19" priority="1211">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B64101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/*" mode="M19" priority="1210">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedDepartureTransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B61703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent" mode="M19" priority="1209">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationID">
          <xsl:attribute name="id">PEPPOL-T124-B64601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Location" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Location">
          <xsl:attribute name="id">PEPPOL-T124-B64602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Location' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Period" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Period">
          <xsl:attribute name="id">PEPPOL-T124-B64603</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Period' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cbc:IdentificationID" mode="M19" priority="1208">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cbc:IdentificationID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location" mode="M19" priority="1207">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:ID" mode="M19" priority="1206">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B64901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:Name" mode="M19" priority="1205">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address" mode="M19" priority="1204">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B65201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:StreetName" mode="M19" priority="1203">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:CityName" mode="M19" priority="1202">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:PostalZone" mode="M19" priority="1201">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country" mode="M19" priority="1200">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B65601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" mode="M19" priority="1199">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B65701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/*" mode="M19" priority="1198">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B65602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/*" mode="M19" priority="1197">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B65202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/*" mode="M19" priority="1196">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B64801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period" mode="M19" priority="1195">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartDate" mode="M19" priority="1194">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartTime" mode="M19" priority="1193">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndDate" mode="M19" priority="1192">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndTime" mode="M19" priority="1191">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/*" mode="M19" priority="1190">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B65801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/*" mode="M19" priority="1189">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/cac:PlannedArrivalTransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B64604</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/*" mode="M19" priority="1188">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B58302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage" mode="M19" priority="1187">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TransportModeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TransportModeCode">
          <xsl:attribute name="id">PEPPOL-T124-B66301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TransportModeCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cbc:TransportModeCode" mode="M19" priority="1186">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cbc:TransportModeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNECERec19 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNECERec19 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B66401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommandation 19 (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cbc:HazardousRiskIndicator" mode="M19" priority="1185">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cbc:HazardousRiskIndicator" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty" mode="M19" priority="1184">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification" mode="M19" priority="1183">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B66701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1182">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B66801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyName" mode="M19" priority="1181">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T124-B67001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyName/cbc:Name" mode="M19" priority="1180">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress" mode="M19" priority="1179">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B67201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1178">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1177">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1176">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1175">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1174">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1173">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B67801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1172">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country" mode="M19" priority="1171">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B68001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1170">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B68101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1169">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B68002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/*" mode="M19" priority="1168">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B67202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity" mode="M19" priority="1167">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T124-B68201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1166">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1165">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T124-B68401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B68402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M19" priority="1164">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B68601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M19" priority="1163">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M19" priority="1162">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B68801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1161">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B68901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M19" priority="1160">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B68802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M19" priority="1159">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B68602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/*" mode="M19" priority="1158">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B68202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact" mode="M19" priority="1157">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Name" mode="M19" priority="1156">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Telephone" mode="M19" priority="1155">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1154">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact/*" mode="M19" priority="1153">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B69001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person" mode="M19" priority="1152">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:IdentityDocumentReference" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:IdentityDocumentReference">
          <xsl:attribute name="id">PEPPOL-T124-B69401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:IdentityDocumentReference' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference" mode="M19" priority="1151">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B69501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:DocumentType" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:DocumentType">
          <xsl:attribute name="id">PEPPOL-T124-B69502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:DocumentType' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID" mode="M19" priority="1150">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType" mode="M19" priority="1149">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/cbc:DocumentType" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*" mode="M19" priority="1148">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/cac:IdentityDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B69503</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/*" mode="M19" priority="1147">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/cac:Person/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B69402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/*" mode="M19" priority="1146">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:CarrierParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B66601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent" mode="M19" priority="1145">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Location" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Location">
          <xsl:attribute name="id">PEPPOL-T124-B69801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Location' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Period" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Period">
          <xsl:attribute name="id">PEPPOL-T124-B69802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Period' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cbc:IdentificationID" mode="M19" priority="1144">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cbc:IdentificationID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location" mode="M19" priority="1143">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:ID" mode="M19" priority="1142">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B70101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:Name" mode="M19" priority="1141">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address" mode="M19" priority="1140">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B70401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:StreetName" mode="M19" priority="1139">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" mode="M19" priority="1138">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CityName" mode="M19" priority="1137">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:PostalZone" mode="M19" priority="1136">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" mode="M19" priority="1135">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine" mode="M19" priority="1134">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B71001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" mode="M19" priority="1133">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country" mode="M19" priority="1132">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B71201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" mode="M19" priority="1131">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B71301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/*" mode="M19" priority="1130">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B71202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" mode="M19" priority="1129">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CoordinateSystemCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CoordinateSystemCode">
          <xsl:attribute name="id">PEPPOL-T124-B71401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CoordinateSystemCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LatitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LatitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B71402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LongitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LongitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B71403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" mode="M19" priority="1128">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" mode="M19" priority="1127">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B71601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B71602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" mode="M19" priority="1126">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B71801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B71802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" mode="M19" priority="1125">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B72001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B72002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" mode="M19" priority="1124">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/cac:LocationCoordinate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B71404</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/*" mode="M19" priority="1123">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B70402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/*" mode="M19" priority="1122">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Location/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B70001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period" mode="M19" priority="1121">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartDate" mode="M19" priority="1120">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartTime" mode="M19" priority="1119">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndDate" mode="M19" priority="1118">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndTime" mode="M19" priority="1117">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/*" mode="M19" priority="1116">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B72201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/*" mode="M19" priority="1115">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedDepartureTransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B69803</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent" mode="M19" priority="1114">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationID">
          <xsl:attribute name="id">PEPPOL-T124-B72701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Location" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Location">
          <xsl:attribute name="id">PEPPOL-T124-B72702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Location' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Period" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Period">
          <xsl:attribute name="id">PEPPOL-T124-B72703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Period' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cbc:IdentificationID" mode="M19" priority="1113">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cbc:IdentificationID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location" mode="M19" priority="1112">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:ID" mode="M19" priority="1111">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B73001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:Name" mode="M19" priority="1110">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address" mode="M19" priority="1109">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T124-B73301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:StreetName" mode="M19" priority="1108">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:CityName" mode="M19" priority="1107">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:PostalZone" mode="M19" priority="1106">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country" mode="M19" priority="1105">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B73701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" mode="M19" priority="1104">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B73801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/*" mode="M19" priority="1103">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B73702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/*" mode="M19" priority="1102">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B73302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/*" mode="M19" priority="1101">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Location/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B72901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period" mode="M19" priority="1100">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartDate" mode="M19" priority="1099">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartTime" mode="M19" priority="1098">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndDate" mode="M19" priority="1097">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndTime" mode="M19" priority="1096">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/*" mode="M19" priority="1095">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B73901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/*" mode="M19" priority="1094">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/cac:PlannedArrivalTransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B72704</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/*" mode="M19" priority="1093">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B66302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit" mode="M19" priority="1092">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B74401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TransportHandlingUnitTypeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TransportHandlingUnitTypeCode">
          <xsl:attribute name="id">PEPPOL-T124-B74402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TransportHandlingUnitTypeCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:ID" mode="M19" priority="1091">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clTransportHandlingUnitIDType satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clTransportHandlingUnitIDType satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B74501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Type of Transport Handling Unit ID (openPEPPOL)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:TransportHandlingUnitTypeCode" mode="M19" priority="1090">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:TransportHandlingUnitTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNECERec21 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNECERec21 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B74701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommandation 21 (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:HandlingCode" mode="M19" priority="1089">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:HandlingCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:HandlingInstructions" mode="M19" priority="1088">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:HandlingInstructions" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:HazardousRiskIndicator" mode="M19" priority="1087">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:HazardousRiskIndicator" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:ShippingMarks" mode="M19" priority="1086">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cbc:ShippingMarks" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment" mode="M19" priority="1085">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B75201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:ID" mode="M19" priority="1084">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:TransportEquipmentTypeCode" mode="M19" priority="1083">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:TransportEquipmentTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL8053 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL8053 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B75401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Transport equipment type code (UNCL8053) '.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:SizeTypeCode" mode="M19" priority="1082">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:SizeTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clTRED8155 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clTRED8155 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B75501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Size type code (TRED8155)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:RefrigerationOnIndicator" mode="M19" priority="1081">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:RefrigerationOnIndicator" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:Description" mode="M19" priority="1080">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:Description" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:PowerIndicator" mode="M19" priority="1079">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/cbc:PowerIndicator" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/*" mode="M19" priority="1078">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:TransportEquipment/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B75202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MeasurementDimension" mode="M19" priority="1077">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MeasurementDimension" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AttributeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AttributeID">
          <xsl:attribute name="id">PEPPOL-T124-B75901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:AttributeID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Measure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Measure">
          <xsl:attribute name="id">PEPPOL-T124-B75902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Measure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:AttributeID" mode="M19" priority="1076">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:AttributeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL6313-T120 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL6313-T120 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B76001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Measured attribute code for despatch advice (UNCL6313 Subset) T120'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:Measure" mode="M19" priority="1075">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MeasurementDimension/cbc:Measure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B76101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B76102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MeasurementDimension/*" mode="M19" priority="1074">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MeasurementDimension/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B75903</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MinimumTemperature" mode="M19" priority="1073">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MinimumTemperature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AttributeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AttributeID">
          <xsl:attribute name="id">PEPPOL-T124-B76301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:AttributeID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Measure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Measure">
          <xsl:attribute name="id">PEPPOL-T124-B76302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Measure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MinimumTemperature/cbc:AttributeID" mode="M19" priority="1072">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MinimumTemperature/cbc:AttributeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL6313-T120 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL6313-T120 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B76401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Measured attribute code for despatch advice (UNCL6313 Subset) T120'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MinimumTemperature/cbc:Measure" mode="M19" priority="1071">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MinimumTemperature/cbc:Measure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B76501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MinimumTemperature/*" mode="M19" priority="1070">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MinimumTemperature/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B76303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MaximumTemperature" mode="M19" priority="1069">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MaximumTemperature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AttributeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AttributeID">
          <xsl:attribute name="id">PEPPOL-T124-B76701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:AttributeID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Measure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Measure">
          <xsl:attribute name="id">PEPPOL-T124-B76702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Measure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MaximumTemperature/cbc:AttributeID" mode="M19" priority="1068">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MaximumTemperature/cbc:AttributeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL6313-T120 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL6313-T120 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B76801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Measured attribute code for despatch advice (UNCL6313 Subset) T120'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MaximumTemperature/cbc:Measure" mode="M19" priority="1067">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MaximumTemperature/cbc:Measure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B76901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MaximumTemperature/*" mode="M19" priority="1066">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:MaximumTemperature/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B76703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem" mode="M19" priority="1065">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:ID" mode="M19" priority="1064">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:SequenceNumberID" mode="M19" priority="1063">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:SequenceNumberID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:Description" mode="M19" priority="1062">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:Description" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:HazardousRiskIndicator" mode="M19" priority="1061">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:HazardousRiskIndicator" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:Quantity" mode="M19" priority="1060">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cbc:Quantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B77601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item" mode="M19" priority="1059">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cbc:Name" mode="M19" priority="1058">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:CommodityClassification" mode="M19" priority="1057">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:CommodityClassification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ItemClassificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ItemClassificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B78001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ItemClassificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" mode="M19" priority="1056">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="id">PEPPOL-T124-B78101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'listID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@listID) or (some $code in $clUNCL7143 satisfies $code = @listID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@listID) or (some $code in $clUNCL7143 satisfies $code = @listID)">
          <xsl:attribute name="id">PEPPOL-T124-B78102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Item type identification code (UNCL7143)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listVersionID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listVersionID">
          <xsl:attribute name="id">PEPPOL-T124-B78103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'listVersionID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@name" />
      <xsl:otherwise>
        <svrl:failed-assert test="@name">
          <xsl:attribute name="id">PEPPOL-T124-B78104</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'name' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:CommodityClassification/*" mode="M19" priority="1055">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:CommodityClassification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B78002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem" mode="M19" priority="1054">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:ID" mode="M19" priority="1053">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:AdditionalInformation" mode="M19" priority="1052">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:AdditionalInformation" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:UNDGCode" mode="M19" priority="1051">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:UNDGCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL8273 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL8273 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B78801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Dangerous goods regulations code (UNCL8273)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:TechnicalName" mode="M19" priority="1050">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:TechnicalName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:CategoryName" mode="M19" priority="1049">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:CategoryName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:HazardousCategoryCode" mode="M19" priority="1048">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:HazardousCategoryCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:HazardClassID" mode="M19" priority="1047">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:HazardClassID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:NetWeightMeasure" mode="M19" priority="1046">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:NetWeightMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B79301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B79302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:NetVolumeMeasure" mode="M19" priority="1045">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cbc:NetVolumeMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B79501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B79502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:HazardousGoodsTransit" mode="M19" priority="1044">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:HazardousGoodsTransit" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:PackingCriteriaCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:PackingCriteriaCode">
          <xsl:attribute name="id">PEPPOL-T124-B79701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:PackingCriteriaCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:HazardousGoodsTransit/cbc:PackingCriteriaCode" mode="M19" priority="1043">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:HazardousGoodsTransit/cbc:PackingCriteriaCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:HazardousGoodsTransit/*" mode="M19" priority="1042">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:HazardousGoodsTransit/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B79702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:EmergencyTemperature" mode="M19" priority="1041">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:EmergencyTemperature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AttributeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AttributeID">
          <xsl:attribute name="id">PEPPOL-T124-B79901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:AttributeID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Measure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Measure">
          <xsl:attribute name="id">PEPPOL-T124-B79902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Measure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:EmergencyTemperature/cbc:AttributeID" mode="M19" priority="1040">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:EmergencyTemperature/cbc:AttributeID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:EmergencyTemperature/cbc:Measure" mode="M19" priority="1039">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:EmergencyTemperature/cbc:Measure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B80101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B80102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:EmergencyTemperature/*" mode="M19" priority="1038">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/cac:EmergencyTemperature/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B79903</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/*" mode="M19" priority="1037">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/cac:HazardousItem/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B78501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/*" mode="M19" priority="1036">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/cac:Item/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B77801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/*" mode="M19" priority="1035">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:GoodsItem/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B77101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference" mode="M19" priority="1034">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B80301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference/cbc:ID" mode="M19" priority="1033">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference/cbc:DocumentTypeCode" mode="M19" priority="1032">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference/cbc:DocumentTypeCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference/cbc:DocumentType" mode="M19" priority="1031">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference/cbc:DocumentType" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference/*" mode="M19" priority="1030">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/cac:ShipmentDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B80302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/*" mode="M19" priority="1029">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:TransportHandlingUnit/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B74403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation" mode="M19" priority="1028">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cbc:ID" mode="M19" priority="1027">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T124-B80801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cbc:Name" mode="M19" priority="1026">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address" mode="M19" priority="1025">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:StreetName" mode="M19" priority="1024">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:AdditionalStreetName" mode="M19" priority="1023">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:CityName" mode="M19" priority="1022">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:PostalZone" mode="M19" priority="1021">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:CountrySubentity" mode="M19" priority="1020">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:AddressLine" mode="M19" priority="1019">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T124-B81701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:AddressLine/cbc:Line" mode="M19" priority="1018">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:Country" mode="M19" priority="1017">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T124-B81901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:Country/cbc:IdentificationCode" mode="M19" priority="1016">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B82001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:Country/*" mode="M19" priority="1015">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B81902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate" mode="M19" priority="1014">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CoordinateSystemCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CoordinateSystemCode">
          <xsl:attribute name="id">PEPPOL-T124-B82101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CoordinateSystemCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LatitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LatitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B82102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LatitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LongitudeDegreesMeasure" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LongitudeDegreesMeasure">
          <xsl:attribute name="id">PEPPOL-T124-B82103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LongitudeDegreesMeasure' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" mode="M19" priority="1013">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/cbc:CoordinateSystemCode" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" mode="M19" priority="1012">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/cbc:LatitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B82301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B82302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" mode="M19" priority="1011">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/cbc:LongitudeDegreesMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B82501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B82502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" mode="M19" priority="1010">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/cbc:AltitudeMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T124-B82701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'unitCode' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T124-B82702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/*" mode="M19" priority="1009">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/cac:LocationCoordinate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B82104</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/*" mode="M19" priority="1008">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B81101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/*" mode="M19" priority="1007">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:OfficeOfEntryLocation/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B80701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference" mode="M19" priority="1006">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T124-B82901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference/cbc:ID" mode="M19" priority="1005">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference/cbc:DocumentTypeCode" mode="M19" priority="1004">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference/cbc:DocumentTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T124-B83101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Document name code, full list (UNCL1001)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference/cbc:DocumentType" mode="M19" priority="1003">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference/cbc:DocumentType" />
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference/*" mode="M19" priority="1002">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/cac:DocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B82902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/cac:Consignment/*" mode="M19" priority="1001">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/cac:Consignment/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B19604</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportExecutionPlan/*" mode="M19" priority="1000">
    <svrl:fired-rule context="/ubl:TransportExecutionPlan/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T124-B00113</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
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
<xsl:template match="cbc:CustomizationID" mode="M20" priority="1014">
    <svrl:fired-rule context="cbc:CustomizationID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:transport_execution_plan:1')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:transport_execution_plan:1')">
          <xsl:attribute name="id">PEPPOL-T124-R001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>CustomizationID SHALL have the value 'urn:fdc:peppol.eu:logistics:trns:transport_execution_plan:1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:ProfileID" mode="M20" priority="1013">
    <svrl:fired-rule context="cbc:ProfileID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="some $p in tokenize('urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_w_request:1 urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_only:1 urn:fdc:peppol.eu:logistics:bis:advanced_transport_execution_plan:1', '\s') satisfies $p = normalize-space(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $p in tokenize('urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_w_request:1 urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_only:1 urn:fdc:peppol.eu:logistics:bis:advanced_transport_execution_plan:1', '\s') satisfies $p = normalize-space(.)">
          <xsl:attribute name="id">PEPPOL-T124-R002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProfileID SHALL have the value 'urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_w_request:1' or 'urn:fdc:peppol.eu:logistics:bis:transport_execution_plan_only:1' or 'urn:fdc:peppol.eu:logistics:bis:advanced_transport_execution_plan:1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Consignment" mode="M20" priority="1012">
    <svrl:fired-rule context="cac:Consignment" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TotalTransportHandlingUnitQuantity) or number(cbc:TotalTransportHandlingUnitQuantity) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TotalTransportHandlingUnitQuantity) or number(cbc:TotalTransportHandlingUnitQuantity) >= 0">
          <xsl:attribute name="id">PEPPOL-T124-R003</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R003]Total transport handling unit quantity SHALL not be negative</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:TotalTransportHandlingUnitQuantity) or not(cac:TransportHandlingUnit) or number(cbc:TotalTransportHandlingUnitQuantity) = count(cac:TransportHandlingUnit)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:TotalTransportHandlingUnitQuantity) or not(cac:TransportHandlingUnit) or number(cbc:TotalTransportHandlingUnitQuantity) = count(cac:TransportHandlingUnit)">
          <xsl:attribute name="id">PEPPOL-T124-R004</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R004] Shipment transport handling unit quantity SHALL match the number of the transport handling units specified</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="THUGrossWeight" select="round(sum(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure) * 1000)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:GrossWeightMeasure) or not(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure) or (cbc:GrossWeightMeasure/@unitCode) > (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure/@unitCode) or (cbc:GrossWeightMeasure/@unitCode) &lt; (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure/@unitCode) or ((cbc:GrossWeightMeasure)/xs:decimal(.) * 1000) = $THUGrossWeight" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:GrossWeightMeasure) or not(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure) or (cbc:GrossWeightMeasure/@unitCode) > (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure/@unitCode) or (cbc:GrossWeightMeasure/@unitCode) &lt; (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAB']/cbc:Measure/@unitCode) or ((cbc:GrossWeightMeasure)/xs:decimal(.) * 1000) = $THUGrossWeight">
          <xsl:attribute name="id">PEPPOL-T124-R005</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
			[PEPPOL-T124-R005] Gross Weight Measure value must be equal to the sum of the MeasurementDimension/Measure values with AttributeID 'AAB'.
		</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="THUGrossVolume" select="round(sum(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure) * 1000)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:GrossVolumeMeasure) or not(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure) or (cbc:GrossVolumeMeasure/@unitCode) > (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure/@unitCode) or (cbc:GrossVolumeMeasure/@unitCode) &lt; (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure/@unitCode) or ((cbc:GrossVolumeMeasure)/xs:decimal(.) * 1000) >= $THUGrossVolume" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:GrossVolumeMeasure) or not(cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure) or (cbc:GrossVolumeMeasure/@unitCode) > (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure/@unitCode) or (cbc:GrossVolumeMeasure/@unitCode) &lt; (cac:TransportHandlingUnit/cac:MeasurementDimension[normalize-space(cbc:AttributeID) = 'AAW']/cbc:Measure/@unitCode) or ((cbc:GrossVolumeMeasure)/xs:decimal(.) * 1000) >= $THUGrossVolume">
          <xsl:attribute name="id">PEPPOL-T124-R006</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
			[PEPPOL-T124-R006] Gross Volume Measure value must be greater than or equal to the sum of the MeasurementDimension/Measure values with AttributeID 'AAW'.
		</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Delivery/cac:DeliveryTerms) or ((cac:Delivery/cac:DeliveryTerms/cbc:ID) or (cac:Delivery/cac:DeliveryTerms/cbc:SpecialTerms))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Delivery/cac:DeliveryTerms) or ((cac:Delivery/cac:DeliveryTerms/cbc:ID) or (cac:Delivery/cac:DeliveryTerms/cbc:SpecialTerms))">
          <xsl:attribute name="id">PEPPOL-T124-R007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R007] Either ID or special terms need to be specified in Delivery terms</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cbc:GrossWeightMeasure) or (cbc:GrossVolumeMeasure) or (cbc:LoadingLengthMeasure)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cbc:GrossWeightMeasure) or (cbc:GrossVolumeMeasure) or (cbc:LoadingLengthMeasure)">
          <xsl:attribute name="id">PEPPOL-T124-R008</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R008] Either gross weight, gross volume or loading length must be specified</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:PaymentTerms) or cac:PaymentTerms/cbc:ID or cac:PaymentTerms/cbc:Note" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:PaymentTerms) or cac:PaymentTerms/cbc:ID or cac:PaymentTerms/cbc:Note">
          <xsl:attribute name="id">PEPPOL-T124-R010</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R010] When Payment terms is specified, either the ID or the note must be specified</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Period" mode="M20" priority="1011">
    <svrl:fired-rule context="cac:Period" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndDate or cbc:StartDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndDate or cbc:StartDate">
          <xsl:attribute name="id">PEPPOL-T124-R011</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R011] Start date or end date must be spefied in a period</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:EndDate) or translate(cbc:StartDate,'-','') &lt;= translate(cbc:EndDate,'-','')" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:EndDate) or translate(cbc:StartDate,'-','') &lt;= translate(cbc:EndDate,'-','')">
          <xsl:attribute name="id">PEPPOL-T124-R012</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R012] Start date must be earlier or equal to end date</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:EndTime) or ((cbc:EndTime) and (cbc:StartTime)) or ((cbc:EndDate) and (cbc:EndTime) and not(cbc:StartDate) and not(cbc:StartTime))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:EndTime) or ((cbc:EndTime) and (cbc:StartTime)) or ((cbc:EndDate) and (cbc:EndTime) and not(cbc:StartDate) and not(cbc:StartTime))">
          <xsl:attribute name="id">PEPPOL-T124-R013</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R013] EndTime cannot be specified without StartTime</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:EndDate)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:EndTime) or (cbc:EndTime) and (cbc:EndDate)">
          <xsl:attribute name="id">PEPPOL-T124-R014</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R014] EndTime cannot be specified without EndDate</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:StartDate) or not(cbc:StartTime) or not(cbc:EndDate) or not(cbc:EndTime) or dateTime((cbc:EndDate),(cbc:EndTime)) >= dateTime((cbc:StartDate),(cbc:StartTime)) " />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:StartDate) or not(cbc:StartTime) or not(cbc:EndDate) or not(cbc:EndTime) or dateTime((cbc:EndDate),(cbc:EndTime)) >= dateTime((cbc:StartDate),(cbc:StartTime))">
          <xsl:attribute name="id">PEPPOL-T124-R015</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R015] StartTime must be before EndTime</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:StartTime) or count(timezone-from-time(cbc:StartTime)) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:StartTime) or count(timezone-from-time(cbc:StartTime)) > 0">
          <xsl:attribute name="id">PEPPOL-T124-R016</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R016] IssueTime MUST include timezone information.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:EndTime) or count(timezone-from-time(cbc:EndTime)) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:EndTime) or count(timezone-from-time(cbc:EndTime)) > 0">
          <xsl:attribute name="id">PEPPOL-T124-R017</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R017] IssueTime MUST include timezone information.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportExecutionPlan/cbc:IssueTime" mode="M20" priority="1010">
    <svrl:fired-rule context="ubl:TransportExecutionPlan/cbc:IssueTime" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(timezone-from-time(.)) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(timezone-from-time(.)) > 0">
          <xsl:attribute name="id">PEPPOL-T124-R018</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R018] IssueTime MUST include timezone information.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportExecutionPlan/cac:SenderParty" mode="M20" priority="1009">
    <svrl:fired-rule context="ubl:TransportExecutionPlan/cac:SenderParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName or cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName or cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T124-R031</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R031] Party must include either a party name or a party identification.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportExecutionPlan/cac:ReceiverParty" mode="M20" priority="1008">
    <svrl:fired-rule context="ubl:TransportExecutionPlan/cac:ReceiverParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName or cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName or cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T124-R032</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R032] Party must include either a party name or a party identification.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportExecutionPlan/cac:TransportUserParty" mode="M20" priority="1007">
    <svrl:fired-rule context="ubl:TransportExecutionPlan/cac:TransportUserParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName or cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName or cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T124-R033</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R033] Party must include either a party name or a party identification.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportExecutionPlan/cac:TransportServiceProviderParty" mode="M20" priority="1006">
    <svrl:fired-rule context="ubl:TransportExecutionPlan/cac:TransportServiceProviderParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName or cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName or cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T124-R034</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R034] Party must include either a party name or a party identification.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportExecutionPlan" mode="M20" priority="1005">
    <svrl:fired-rule context="ubl:TransportExecutionPlan" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:BillToParty) or cac:BillToParty/cac:PartyName or cac:BillToParty/cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:BillToParty) or cac:BillToParty/cac:PartyName or cac:BillToParty/cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T124-R035</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R035] Party must include either a party name or a party identification.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:MainTransportationService/cbc:TransportServiceCode = ('4', '22', '23', '24'))      or (cac:Consignment/cac:PlannedPickupTransportEvent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:MainTransportationService/cbc:TransportServiceCode = ('4', '22', '23', '24')) or (cac:Consignment/cac:PlannedPickupTransportEvent)">
          <xsl:attribute name="id">PEPPOL-T124-R040</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R040] cac:Consignment/cac:PlannedPickupTransportEvent must be present when cac:MainTransportationService = "4", "22", "23" or "24".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:MainTransportationService/cbc:TransportServiceCode = ('4', '22', '23', '24'))      or (cac:Consignment/cac:PlannedDeliveryTransportEvent)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:MainTransportationService/cbc:TransportServiceCode = ('4', '22', '23', '24')) or (cac:Consignment/cac:PlannedDeliveryTransportEvent)">
          <xsl:attribute name="id">PEPPOL-T124-R041</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R041] cac:Consignment/cac:PlannedDeliveryTransportEvent must be present when cac:MainTransportationService = "4", "22", "23" or "24".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:MainTransportationService/cbc:TransportServiceCode = ('4', '22', '23', '24'))      or (cac:Consignment/cac:MainCarriageShipmentStage)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:MainTransportationService/cbc:TransportServiceCode = ('4', '22', '23', '24')) or (cac:Consignment/cac:MainCarriageShipmentStage)">
          <xsl:attribute name="id">PEPPOL-T124-R042</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>[PEPPOL-T124-R042] cac:Consignment/cac:MainCarriageShipmentStage must be present when cac:MainTransportationService = "4", "22", "23" or "24".</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty" mode="M20" priority="1004">
    <svrl:fired-rule context="ubl:TransportExecutionPlan/cac:Consignment/cac:ConsigneeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName or cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName or cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T124-R036</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R036] Party must include either a party name or a party identification.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty" mode="M20" priority="1003">
    <svrl:fired-rule context="ubl:TransportExecutionPlan/cac:Consignment/cac:ConsignorParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName or cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName or cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T124-R037</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R037] Party must include either a party name or a party identification.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage" mode="M20" priority="1002">
    <svrl:fired-rule context="ubl:TransportExecutionPlan/cac:Consignment/cac:MainCarriageShipmentStage" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:CarrierParty) or cac:CarrierParty/cac:PartyName or cac:CarrierParty/cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:CarrierParty) or cac:CarrierParty/cac:PartyName or cac:CarrierParty/cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T124-R030</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R030] Party must include either a party name or a party identification.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage" mode="M20" priority="1001">
    <svrl:fired-rule context="ubl:TransportExecutionPlan/cac:Consignment/cac:PreCarriageShipmentStage" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:CarrierParty) or cac:CarrierParty/cac:PartyName or cac:CarrierParty/cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:CarrierParty) or cac:CarrierParty/cac:PartyName or cac:CarrierParty/cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T124-R038</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R038] Party must include either a party name or a party identification.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage" mode="M20" priority="1000">
    <svrl:fired-rule context="ubl:TransportExecutionPlan/cac:Consignment/cac:OnCarriageShipmentStage" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:CarrierParty) or cac:CarrierParty/cac:PartyName or cac:CarrierParty/cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:CarrierParty) or cac:CarrierParty/cac:PartyName or cac:CarrierParty/cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T124-R039</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T124-R039] Party must include either a party name or a party identification.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M20" priority="-1" />
  <xsl:template match="@*|node()" mode="M20" priority="-2">
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
