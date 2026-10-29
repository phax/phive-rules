<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:u="utils" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:TransportationStatus-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
<xsl:key match="cac:LineItem" name="k_lineId" use="cbc:ID" />
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
    <svrl:schematron-output schemaVersion="iso" title="Rules for Transport Status">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:TransportationStatus-2" />
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:ns-prefix-in-attribute-values prefix="u" uri="utils" />
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
      <svrl:active-pattern>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
      </svrl:active-pattern>
      <xsl:apply-templates mode="M21" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Rules for Transport Status</svrl:text>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//*[not(*) and not(normalize-space())]" mode="M18" priority="1000">
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
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M18" priority="-1" />
  <xsl:template match="@*|node()" mode="M18" priority="-2">
    <xsl:apply-templates mode="M18" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/*" mode="M19" priority="1018">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" mode="M19" priority="1017">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" mode="M19" priority="1016">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" mode="M19" priority="1015">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0184'] | cac:PartyIdentification/cbc:ID[@schemeID = '0184'] | cbc:CompanyID[@schemeID = '0184']" mode="M19" priority="1014">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0096'] | cac:PartyIdentification/cbc:ID[@schemeID = '0096'] | cbc:CompanyID[@schemeID = '0096']" mode="M19" priority="1013">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0198'] | cac:PartyIdentification/cbc:ID[@schemeID = '0198'] | cbc:CompanyID[@schemeID = '0198']" mode="M19" priority="1012">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']" mode="M19" priority="1011">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']" mode="M19" priority="1010">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']" mode="M19" priority="1009">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '9907']" mode="M19" priority="1008">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']" mode="M19" priority="1007">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']" mode="M19" priority="1006">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']" mode="M19" priority="1005">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0106'] | cac:PartyIdentification/cbc:ID[@schemeID = '0106'] | cbc:CompanyID[@schemeID = '0106']" mode="M19" priority="1004">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0190'] | cac:PartyIdentification/cbc:ID[@schemeID = '0190'] | cbc:CompanyID[@schemeID = '0190']" mode="M19" priority="1003">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '9944'] | cac:PartyIdentification/cbc:ID[@schemeID = '9944'] | cbc:CompanyID[@schemeID = '9944']" mode="M19" priority="1002">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PartyTaxScheme                    [normalize-space(cac:TaxScheme/cbc:ID) = 'VAT']                    /cbc:CompanyID                    [starts-with(normalize-space(.), 'NL')]" mode="M19" priority="1001">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0217'] | cac:PartyIdentification/cbc:ID[@schemeID = '0217'] | cbc:CompanyID[@schemeID = '0217']" mode="M19" priority="1000">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M19" priority="-1" />
  <xsl:template match="@*|node()" mode="M19" priority="-2">
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

<!--PATTERN -->
<xsl:variable name="clMimeCode" select="tokenize('application/pdf image/png image/jpeg image/tiff application/acad application/dwg drawing/dwg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')" />
  <xsl:variable name="clISO3166" select="tokenize('1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW', '\s')" />
  <xsl:variable name="clTransportationStatusCode" select="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 44 45 46 47 48 49 50 51 53 54 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 161 162 163 164 165 166 167 168 169 170 171 172 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 218 219 220 222 224 225 227 228 229 231 232 233 234 235 236 238 239 240 241 242 243 247 248 250 251 253 254 255 256 258 260 265 266 267 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 291 292 295 297 298 299 300 301 302 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370', '\s')" />
  <xsl:variable name="clConsignmentIDType" select="tokenize('GINC', '\s')" />
  <xsl:variable name="clUNCL1001" select="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 1999 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 539 550 551 552 553 554 575 576 577 578 579 580 581 582 583 584 585 586 587 588 589 610 621 622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637 638 639 640 641 642 643 644 645 646 647 648 649 650 651 652 653 654 655 656 657 658 659 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 717 718 719 720 721 722 723 724 725 726 727 728 729 730 731 732 733 734 735 736 737 738 739 740 741 742 743 744 745 746 747 748 749 750 751 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998', '\s')" />
  <xsl:variable name="clICD" select="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230 0231 0232 0233 0234 0235 0236 0237 0238 0239 0240 0241 0242 0243 0244 0245 0246 0247 0248', '\s')" />
  <xsl:variable name="clTransportEventTypeCode" select="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 44 45 46 47 48 49 50 51 53 54 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 161 162 163 164 165 166 167 168 169 170 171 172 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 218 219 220 222 224 225 227 228 229 231 232 233 234 235 236 238 239 240 241 242 243 247 248 250 251 253 254 255 256 258 260 265 266 267 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 291 292 295 297 298 299 300 301 302 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370', '\s')" />
  <xsl:variable name="clTransportationStatusTypeCode" select="tokenize('3 4', '\s')" />
  <xsl:variable name="clTransportHandlingUnitIDType" select="tokenize('SSCC', '\s')" />
  <xsl:variable name="cleas" select="tokenize('0002 0007 0009 0060 0088 0096 0097 0106 0130 0135 0142 0151 0158 0183 0184 0188 0190 0191 0192 0195 0196 0198 0199 0200 0201 0204 0208 0209 0210 0211 0216 0218 0221 0225 0230 0235 0240 0242 0244 0245 0246 0248 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959', '\s')" />

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus" mode="M20" priority="1263">
    <svrl:fired-rule context="/ubl:TransportationStatus" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CustomizationID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CustomizationID">
          <xsl:attribute name="id">PEPPOL-T127-B00101</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B00102</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B00103</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B00104</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B00105</xsl:attribute>
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
      <xsl:when test="cbc:Description" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Description">
          <xsl:attribute name="id">PEPPOL-T127-B00106</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Description' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ShippingOrderID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ShippingOrderID">
          <xsl:attribute name="id">PEPPOL-T127-B00107</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ShippingOrderID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TransportationStatusTypeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TransportationStatusTypeCode">
          <xsl:attribute name="id">PEPPOL-T127-B00108</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TransportationStatusTypeCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TransportExecutionStatusCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TransportExecutionStatusCode">
          <xsl:attribute name="id">PEPPOL-T127-B00109</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TransportExecutionStatusCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:SenderParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:SenderParty">
          <xsl:attribute name="id">PEPPOL-T127-B00110</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B00111</xsl:attribute>
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
      <xsl:when test="not(@*:schemaLocation)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@*:schemaLocation)">
          <xsl:attribute name="id">PEPPOL-T127-B00112</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST not contain schema location.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cbc:CustomizationID" mode="M20" priority="1262">
    <svrl:fired-rule context="/ubl:TransportationStatus/cbc:CustomizationID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cbc:ProfileID" mode="M20" priority="1261">
    <svrl:fired-rule context="/ubl:TransportationStatus/cbc:ProfileID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cbc:ProfileExecutionID" mode="M20" priority="1260">
    <svrl:fired-rule context="/ubl:TransportationStatus/cbc:ProfileExecutionID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cbc:ID" mode="M20" priority="1259">
    <svrl:fired-rule context="/ubl:TransportationStatus/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cbc:IssueDate" mode="M20" priority="1258">
    <svrl:fired-rule context="/ubl:TransportationStatus/cbc:IssueDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cbc:IssueTime" mode="M20" priority="1257">
    <svrl:fired-rule context="/ubl:TransportationStatus/cbc:IssueTime" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cbc:Description" mode="M20" priority="1256">
    <svrl:fired-rule context="/ubl:TransportationStatus/cbc:Description" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cbc:ShippingOrderID" mode="M20" priority="1255">
    <svrl:fired-rule context="/ubl:TransportationStatus/cbc:ShippingOrderID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cbc:TransportationStatusTypeCode" mode="M20" priority="1254">
    <svrl:fired-rule context="/ubl:TransportationStatus/cbc:TransportationStatusTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clTransportationStatusTypeCode satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clTransportationStatusTypeCode satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T127-B01001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Transportation Status Type Code (openPEPPOL)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cbc:TransportExecutionStatusCode" mode="M20" priority="1253">
    <svrl:fired-rule context="/ubl:TransportationStatus/cbc:TransportExecutionStatusCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clTransportationStatusCode satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clTransportationStatusCode satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T127-B01201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Transportation Status Code (openPEPPOL)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment" mode="M20" priority="1252">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T127-B01301</xsl:attribute>
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
      <xsl:when test="cac:Status" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Status">
          <xsl:attribute name="id">PEPPOL-T127-B01302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Status' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cbc:ID" mode="M20" priority="1251">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clConsignmentIDType satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clConsignmentIDType satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T127-B01401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Type of Consignment ID (openPEPPOL)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:Status" mode="M20" priority="1250">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:Status" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Description" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Description">
          <xsl:attribute name="id">PEPPOL-T127-B01601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Description' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:Status/cbc:ConditionCode" mode="M20" priority="1249">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:Status/cbc:ConditionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="id">PEPPOL-T127-B01701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'listID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:Status/cbc:Description" mode="M20" priority="1248">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:Status/cbc:Description" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:Status/*" mode="M20" priority="1247">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:Status/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B01602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent" mode="M20" priority="1246">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cbc:IdentificationID" mode="M20" priority="1245">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cbc:IdentificationID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cbc:OccurrenceDate" mode="M20" priority="1244">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cbc:OccurrenceDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cbc:OccurrenceTime" mode="M20" priority="1243">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cbc:OccurrenceTime" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cbc:TransportEventTypeCode" mode="M20" priority="1242">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cbc:TransportEventTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clTransportEventTypeCode satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clTransportEventTypeCode satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T127-B02401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Transport Event Type Code (openPEPPOL)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cbc:CompletionIndicator" mode="M20" priority="1241">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cbc:CompletionIndicator" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:CurrentStatus" mode="M20" priority="1240">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:CurrentStatus" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Description" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Description">
          <xsl:attribute name="id">PEPPOL-T127-B02601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Description' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:CurrentStatus/cbc:ConditionCode" mode="M20" priority="1239">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:CurrentStatus/cbc:ConditionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="id">PEPPOL-T127-B02701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'listID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:CurrentStatus/cbc:Description" mode="M20" priority="1238">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:CurrentStatus/cbc:Description" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:CurrentStatus/cbc:StatusReasonCode" mode="M20" priority="1237">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:CurrentStatus/cbc:StatusReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="id">PEPPOL-T127-B03001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'listID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:CurrentStatus/cbc:StatusReason" mode="M20" priority="1236">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:CurrentStatus/cbc:StatusReason" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:CurrentStatus/*" mode="M20" priority="1235">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:CurrentStatus/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B02602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature" mode="M20" priority="1234">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T127-B03301</xsl:attribute>
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
      <xsl:when test="cac:SignatoryParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:SignatoryParty">
          <xsl:attribute name="id">PEPPOL-T127-B03302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:SignatoryParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cbc:ID" mode="M20" priority="1233">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cbc:ValidationDate" mode="M20" priority="1232">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cbc:ValidationDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cbc:ValidationTime" mode="M20" priority="1231">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cbc:ValidationTime" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty" mode="M20" priority="1230">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Person" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Person">
          <xsl:attribute name="id">PEPPOL-T127-B03701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Person' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PartyName" mode="M20" priority="1229">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T127-B03801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PartyName/cbc:Name" mode="M20" priority="1228">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress" mode="M20" priority="1227">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T127-B04001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:StreetName" mode="M20" priority="1226">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M20" priority="1225">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:CityName" mode="M20" priority="1224">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:PostalZone" mode="M20" priority="1223">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:CountrySubentity" mode="M20" priority="1222">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:AddressLine" mode="M20" priority="1221">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T127-B04601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M20" priority="1220">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country" mode="M20" priority="1219">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T127-B04801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1218">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T127-B04901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country/*" mode="M20" priority="1217">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B04802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/*" mode="M20" priority="1216">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B04002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person" mode="M20" priority="1215">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:FamilyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:FamilyName">
          <xsl:attribute name="id">PEPPOL-T127-B05001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:FamilyName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:ID" mode="M20" priority="1214">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:FirstName" mode="M20" priority="1213">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:FirstName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:FamilyName" mode="M20" priority="1212">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:FamilyName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:JobTitle" mode="M20" priority="1211">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:JobTitle" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/*" mode="M20" priority="1210">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B05002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/*" mode="M20" priority="1209">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:SignatoryParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B03702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment" mode="M20" priority="1208">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cbc:EmbeddedDocumentBinaryObject" mode="M20" priority="1207">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cbc:EmbeddedDocumentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@mimeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@mimeCode">
          <xsl:attribute name="id">PEPPOL-T127-B05701</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B05702</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B05703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'filename' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference" mode="M20" priority="1206">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:URI" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:URI">
          <xsl:attribute name="id">PEPPOL-T127-B06001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:URI' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference/cbc:URI" mode="M20" priority="1205">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference/cbc:URI" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference/*" mode="M20" priority="1204">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B06002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/*" mode="M20" priority="1203">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B05601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/*" mode="M20" priority="1202">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Signature/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B03303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Period" mode="M20" priority="1201">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Period" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Period/cbc:StartDate" mode="M20" priority="1200">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Period/cbc:StartTime" mode="M20" priority="1199">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Period/cbc:EndDate" mode="M20" priority="1198">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Period/cbc:EndTime" mode="M20" priority="1197">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Period/*" mode="M20" priority="1196">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B06201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/*" mode="M20" priority="1195">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B02001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit" mode="M20" priority="1194">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T127-B06701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit/cbc:ID" mode="M20" priority="1193">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clTransportHandlingUnitIDType satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clTransportHandlingUnitIDType satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T127-B06801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Type of Transport Handling Unit ID (openPEPPOL)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit/cac:Status" mode="M20" priority="1192">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit/cac:Status" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Description" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Description">
          <xsl:attribute name="id">PEPPOL-T127-B07001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Description' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit/cac:Status/cbc:ConditionCode" mode="M20" priority="1191">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit/cac:Status/cbc:ConditionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="id">PEPPOL-T127-B07101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'listID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit/cac:Status/cbc:Description" mode="M20" priority="1190">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit/cac:Status/cbc:Description" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit/cac:Status/*" mode="M20" priority="1189">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit/cac:Status/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B07002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit/*" mode="M20" priority="1188">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/cac:TransportHandlingUnit/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B06702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Consignment/*" mode="M20" priority="1187">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Consignment/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B01303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent" mode="M20" priority="1186">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationID">
          <xsl:attribute name="id">PEPPOL-T127-B07401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cbc:IdentificationID" mode="M20" priority="1185">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cbc:IdentificationID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cbc:OccurrenceDate" mode="M20" priority="1184">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cbc:OccurrenceDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cbc:OccurrenceTime" mode="M20" priority="1183">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cbc:OccurrenceTime" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cbc:TransportEventTypeCode" mode="M20" priority="1182">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cbc:TransportEventTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clTransportEventTypeCode satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clTransportEventTypeCode satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T127-B07801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Transport Event Type Code (openPEPPOL)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cbc:CompletionIndicator" mode="M20" priority="1181">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cbc:CompletionIndicator" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:CurrentStatus" mode="M20" priority="1180">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:CurrentStatus" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Description" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Description">
          <xsl:attribute name="id">PEPPOL-T127-B08001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Description' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:CurrentStatus/cbc:ConditionCode" mode="M20" priority="1179">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:CurrentStatus/cbc:ConditionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="id">PEPPOL-T127-B08101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'listID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:CurrentStatus/cbc:Description" mode="M20" priority="1178">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:CurrentStatus/cbc:Description" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:CurrentStatus/cbc:StatusReasonCode" mode="M20" priority="1177">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:CurrentStatus/cbc:StatusReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="id">PEPPOL-T127-B08401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'listID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:CurrentStatus/cbc:StatusReason" mode="M20" priority="1176">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:CurrentStatus/cbc:StatusReason" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:CurrentStatus/*" mode="M20" priority="1175">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:CurrentStatus/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B08002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature" mode="M20" priority="1174">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T127-B08701</xsl:attribute>
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
      <xsl:when test="cac:SignatoryParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:SignatoryParty">
          <xsl:attribute name="id">PEPPOL-T127-B08702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:SignatoryParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cbc:ID" mode="M20" priority="1173">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cbc:ValidationDate" mode="M20" priority="1172">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cbc:ValidationDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cbc:ValidationTime" mode="M20" priority="1171">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cbc:ValidationTime" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty" mode="M20" priority="1170">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Person" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Person">
          <xsl:attribute name="id">PEPPOL-T127-B09101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Person' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PartyName" mode="M20" priority="1169">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T127-B09201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PartyName/cbc:Name" mode="M20" priority="1168">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress" mode="M20" priority="1167">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T127-B09401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:StreetName" mode="M20" priority="1166">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M20" priority="1165">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:CityName" mode="M20" priority="1164">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:PostalZone" mode="M20" priority="1163">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:CountrySubentity" mode="M20" priority="1162">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:AddressLine" mode="M20" priority="1161">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T127-B10001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M20" priority="1160">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country" mode="M20" priority="1159">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T127-B10201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1158">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T127-B10301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country/*" mode="M20" priority="1157">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B10202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/*" mode="M20" priority="1156">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B09402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person" mode="M20" priority="1155">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:FamilyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:FamilyName">
          <xsl:attribute name="id">PEPPOL-T127-B10401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:FamilyName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:ID" mode="M20" priority="1154">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:FirstName" mode="M20" priority="1153">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:FirstName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:FamilyName" mode="M20" priority="1152">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:FamilyName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:JobTitle" mode="M20" priority="1151">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/cbc:JobTitle" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/*" mode="M20" priority="1150">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/cac:Person/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B10402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/*" mode="M20" priority="1149">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:SignatoryParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B09102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment" mode="M20" priority="1148">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cbc:EmbeddedDocumentBinaryObject" mode="M20" priority="1147">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cbc:EmbeddedDocumentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@mimeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@mimeCode">
          <xsl:attribute name="id">PEPPOL-T127-B11101</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B11102</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B11103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'filename' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference" mode="M20" priority="1146">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:URI" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:URI">
          <xsl:attribute name="id">PEPPOL-T127-B11401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:URI' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference/cbc:URI" mode="M20" priority="1145">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference/cbc:URI" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference/*" mode="M20" priority="1144">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B11402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/*" mode="M20" priority="1143">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/cac:DigitalSignatureAttachment/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B11001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/*" mode="M20" priority="1142">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Signature/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B08703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Period" mode="M20" priority="1141">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Period" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Period/cbc:StartDate" mode="M20" priority="1140">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Period/cbc:StartDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Period/cbc:StartTime" mode="M20" priority="1139">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Period/cbc:StartTime" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Period/cbc:EndDate" mode="M20" priority="1138">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Period/cbc:EndDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Period/cbc:EndTime" mode="M20" priority="1137">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Period/cbc:EndTime" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/cac:Period/*" mode="M20" priority="1136">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/cac:Period/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B11601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportEvent/*" mode="M20" priority="1135">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportEvent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B07402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:DocumentReference" mode="M20" priority="1134">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:DocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T127-B12101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:DocumentReference/cbc:ID" mode="M20" priority="1133">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:DocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:DocumentReference/cbc:DocumentTypeCode" mode="M20" priority="1132">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:DocumentReference/cbc:DocumentTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T127-B12301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Document name code, full list (UNCL1001)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:DocumentReference/cbc:DocumentType" mode="M20" priority="1131">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:DocumentReference/cbc:DocumentType" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:DocumentReference/cac:Attachment" mode="M20" priority="1130">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:DocumentReference/cac:Attachment" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:DocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject" mode="M20" priority="1129">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:DocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@mimeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@mimeCode">
          <xsl:attribute name="id">PEPPOL-T127-B12601</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B12602</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B12603</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'filename' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:DocumentReference/cac:Attachment/cac:ExternalReference" mode="M20" priority="1128">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:DocumentReference/cac:Attachment/cac:ExternalReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:URI" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:URI">
          <xsl:attribute name="id">PEPPOL-T127-B12901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:URI' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI" mode="M20" priority="1127">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:DocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:DocumentReference/cac:Attachment/cac:ExternalReference/*" mode="M20" priority="1126">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:DocumentReference/cac:Attachment/cac:ExternalReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B12902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:DocumentReference/cac:Attachment/*" mode="M20" priority="1125">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:DocumentReference/cac:Attachment/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B12501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:DocumentReference/*" mode="M20" priority="1124">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:DocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B12102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature" mode="M20" priority="1123">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T127-B13101</xsl:attribute>
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
      <xsl:when test="cac:SignatoryParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:SignatoryParty">
          <xsl:attribute name="id">PEPPOL-T127-B13102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:SignatoryParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cbc:ID" mode="M20" priority="1122">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cbc:ValidationDate" mode="M20" priority="1121">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cbc:ValidationDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cbc:ValidationTime" mode="M20" priority="1120">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cbc:ValidationTime" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty" mode="M20" priority="1119">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Person" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Person">
          <xsl:attribute name="id">PEPPOL-T127-B13501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Person' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PartyName" mode="M20" priority="1118">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T127-B13601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PartyName/cbc:Name" mode="M20" priority="1117">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress" mode="M20" priority="1116">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T127-B13801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:StreetName" mode="M20" priority="1115">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M20" priority="1114">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:CityName" mode="M20" priority="1113">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:PostalZone" mode="M20" priority="1112">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:CountrySubentity" mode="M20" priority="1111">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:AddressLine" mode="M20" priority="1110">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T127-B14401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M20" priority="1109">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country" mode="M20" priority="1108">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T127-B14601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1107">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T127-B14701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country/*" mode="M20" priority="1106">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B14602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/*" mode="M20" priority="1105">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B13802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:Person" mode="M20" priority="1104">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:Person" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:FamilyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:FamilyName">
          <xsl:attribute name="id">PEPPOL-T127-B14801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:FamilyName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:Person/cbc:ID" mode="M20" priority="1103">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:Person/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:Person/cbc:FirstName" mode="M20" priority="1102">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:Person/cbc:FirstName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:Person/cbc:FamilyName" mode="M20" priority="1101">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:Person/cbc:FamilyName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:Person/cbc:JobTitle" mode="M20" priority="1100">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:Person/cbc:JobTitle" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:Person/*" mode="M20" priority="1099">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/cac:Person/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B14802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/*" mode="M20" priority="1098">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:SignatoryParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B13502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:DigitalSignatureAttachment" mode="M20" priority="1097">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:DigitalSignatureAttachment" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:DigitalSignatureAttachment/cbc:EmbeddedDocumentBinaryObject" mode="M20" priority="1096">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:DigitalSignatureAttachment/cbc:EmbeddedDocumentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@mimeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@mimeCode">
          <xsl:attribute name="id">PEPPOL-T127-B15501</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B15502</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B15503</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'filename' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference" mode="M20" priority="1095">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:URI" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:URI">
          <xsl:attribute name="id">PEPPOL-T127-B15801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:URI' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference/cbc:URI" mode="M20" priority="1094">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference/cbc:URI" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference/*" mode="M20" priority="1093">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:DigitalSignatureAttachment/cac:ExternalReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B15802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/cac:DigitalSignatureAttachment/*" mode="M20" priority="1092">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/cac:DigitalSignatureAttachment/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B15401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:Signature/*" mode="M20" priority="1091">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:Signature/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B13103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty" mode="M20" priority="1090">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">PEPPOL-T127-B16001</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B16002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cbc:EndpointID" mode="M20" priority="1089">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T127-B16101</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B16102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyIdentification" mode="M20" priority="1088">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T127-B16301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyIdentification/cbc:ID" mode="M20" priority="1087">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T127-B16401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyName" mode="M20" priority="1086">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T127-B16601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyName/cbc:Name" mode="M20" priority="1085">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress" mode="M20" priority="1084">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T127-B16801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cbc:StreetName" mode="M20" priority="1083">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M20" priority="1082">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cbc:CityName" mode="M20" priority="1081">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cbc:PostalZone" mode="M20" priority="1080">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cbc:CountrySubentity" mode="M20" priority="1079">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cac:AddressLine" mode="M20" priority="1078">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T127-B17401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M20" priority="1077">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cac:Country" mode="M20" priority="1076">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T127-B17601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1075">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T127-B17701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cac:Country/*" mode="M20" priority="1074">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B17602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/*" mode="M20" priority="1073">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B16802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyTaxScheme" mode="M20" priority="1072">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">PEPPOL-T127-B17801</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B17802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyTaxScheme/cbc:CompanyID" mode="M20" priority="1071">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M20" priority="1070">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T127-B18001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M20" priority="1069">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M20" priority="1068">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B18002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyTaxScheme/*" mode="M20" priority="1067">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B17803</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity" mode="M20" priority="1066">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T127-B18201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M20" priority="1065">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M20" priority="1064">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T127-B18401</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B18402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M20" priority="1063">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T127-B18601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M20" priority="1062">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M20" priority="1061">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T127-B18801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1060">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T127-B18901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M20" priority="1059">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B18802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M20" priority="1058">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B18602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/*" mode="M20" priority="1057">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B18202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:Contact" mode="M20" priority="1056">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:Contact" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:Contact/cbc:Name" mode="M20" priority="1055">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:Contact/cbc:Telephone" mode="M20" priority="1054">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:Contact/cbc:ElectronicMail" mode="M20" priority="1053">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/cac:Contact/*" mode="M20" priority="1052">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B19001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:SenderParty/*" mode="M20" priority="1051">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:SenderParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B16003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty" mode="M20" priority="1050">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">PEPPOL-T127-B19401</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B19402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cbc:EndpointID" mode="M20" priority="1049">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T127-B19501</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B19502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyIdentification" mode="M20" priority="1048">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T127-B19701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyIdentification/cbc:ID" mode="M20" priority="1047">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T127-B19801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyName" mode="M20" priority="1046">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T127-B20001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyName/cbc:Name" mode="M20" priority="1045">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress" mode="M20" priority="1044">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T127-B20201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cbc:StreetName" mode="M20" priority="1043">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M20" priority="1042">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cbc:CityName" mode="M20" priority="1041">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cbc:PostalZone" mode="M20" priority="1040">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cbc:CountrySubentity" mode="M20" priority="1039">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine" mode="M20" priority="1038">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T127-B20801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M20" priority="1037">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cac:Country" mode="M20" priority="1036">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T127-B21001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1035">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T127-B21101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cac:Country/*" mode="M20" priority="1034">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B21002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/*" mode="M20" priority="1033">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B20202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyTaxScheme" mode="M20" priority="1032">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">PEPPOL-T127-B21201</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B21202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyTaxScheme/cbc:CompanyID" mode="M20" priority="1031">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M20" priority="1030">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T127-B21401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M20" priority="1029">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M20" priority="1028">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B21402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyTaxScheme/*" mode="M20" priority="1027">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B21203</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity" mode="M20" priority="1026">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T127-B21601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M20" priority="1025">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M20" priority="1024">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T127-B21801</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T127-B21802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M20" priority="1023">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T127-B22001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M20" priority="1022">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M20" priority="1021">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T127-B22201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1020">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T127-B22301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 3166-1:Alpha2 Country codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M20" priority="1019">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B22202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M20" priority="1018">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B22002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/*" mode="M20" priority="1017">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B21602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:Contact" mode="M20" priority="1016">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:Contact" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:Contact/cbc:Name" mode="M20" priority="1015">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:Contact/cbc:Telephone" mode="M20" priority="1014">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:Contact/cbc:ElectronicMail" mode="M20" priority="1013">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/cac:Contact/*" mode="M20" priority="1012">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B22401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:ReceiverParty/*" mode="M20" priority="1011">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:ReceiverParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B19403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportationStatusRequestDocumentReference" mode="M20" priority="1010">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportationStatusRequestDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T127-B22801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportationStatusRequestDocumentReference/cbc:ID" mode="M20" priority="1009">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportationStatusRequestDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportationStatusRequestDocumentReference/cbc:IssueDate" mode="M20" priority="1008">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportationStatusRequestDocumentReference/cbc:IssueDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportationStatusRequestDocumentReference/cbc:IssueTime" mode="M20" priority="1007">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportationStatusRequestDocumentReference/cbc:IssueTime" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportationStatusRequestDocumentReference/*" mode="M20" priority="1006">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportationStatusRequestDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B22802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportExecutionPlanDocumentReference" mode="M20" priority="1005">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportExecutionPlanDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T127-B23201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportExecutionPlanDocumentReference/cbc:ID" mode="M20" priority="1004">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportExecutionPlanDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportExecutionPlanDocumentReference/cbc:IssueDate" mode="M20" priority="1003">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportExecutionPlanDocumentReference/cbc:IssueDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportExecutionPlanDocumentReference/cbc:IssueTime" mode="M20" priority="1002">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportExecutionPlanDocumentReference/cbc:IssueTime" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/cac:TransportExecutionPlanDocumentReference/*" mode="M20" priority="1001">
    <svrl:fired-rule context="/ubl:TransportationStatus/cac:TransportExecutionPlanDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B23202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:TransportationStatus/*" mode="M20" priority="1000">
    <svrl:fired-rule context="/ubl:TransportationStatus/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T127-B00113</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
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
<xsl:template match="cbc:CustomizationID" mode="M21" priority="1004">
    <svrl:fired-rule context="cbc:CustomizationID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:transportation_status:1')" />
      <xsl:otherwise>
        <svrl:failed-assert test="(normalize-space(.) = 'urn:fdc:peppol.eu:logistics:trns:transportation_status:1')">
          <xsl:attribute name="id">PEPPOL-T127-R001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:logistics:trns:transportation_status:1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:ProfileID" mode="M21" priority="1003">
    <svrl:fired-rule context="cbc:ProfileID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="some $p in tokenize('urn:fdc:peppol.eu:logistics:bis:transportation_status_w_request:1 urn:fdc:peppol.eu:logistics:bis:transportation_status_only:1 urn:fdc:peppol.eu:logistics:bis:advanced_transport_execution_plan:1', '\s') satisfies $p = normalize-space(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $p in tokenize('urn:fdc:peppol.eu:logistics:bis:transportation_status_w_request:1 urn:fdc:peppol.eu:logistics:bis:transportation_status_only:1 urn:fdc:peppol.eu:logistics:bis:advanced_transport_execution_plan:1', '\s') satisfies $p = normalize-space(.)">
          <xsl:attribute name="id">PEPPOL-T127-R002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>ProfileID SHALL have the value 'urn:fdc:peppol.eu:logistics:bis:transportation_status_w_request:1' or 'urn:fdc:peppol.eu:logistics:bis:transportation_status_only:1' or 'urn:fdc:peppol.eu:logistics:bis:advanced_transport_execution_plan:1'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportationStatus/cbc:IssueTime" mode="M21" priority="1002">
    <svrl:fired-rule context="ubl:TransportationStatus/cbc:IssueTime" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(timezone-from-time(.)) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(timezone-from-time(.)) > 0">
          <xsl:attribute name="id">PEPPOL-T127-R018</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T127-R018] IssueTime MUST include timezone information.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportationStatus/cac:SenderParty" mode="M21" priority="1001">
    <svrl:fired-rule context="ubl:TransportationStatus/cac:SenderParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName or cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName or cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T127-R031</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T127-R031] Party must include either a party name or a party identification.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:TransportationStatus/cac:ReceiverParty" mode="M21" priority="1000">
    <svrl:fired-rule context="ubl:TransportationStatus/cac:ReceiverParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName or cac:PartyIdentification" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName or cac:PartyIdentification">
          <xsl:attribute name="id">PEPPOL-T127-R032</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text> [PEPPOL-T127-R032] Party must include either a party name or a party identification.</svrl:text>
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
