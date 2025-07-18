<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:u="utils" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Catalogue-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
  <xsl:function as="xs:boolean" name="u:slack">
      <xsl:param as="xs:decimal" name="exp" />
      <xsl:param as="xs:decimal" name="val" />
      <xsl:param as="xs:decimal" name="slack" />
      <xsl:value-of select="xs:decimal($exp + $slack) >= $val and xs:decimal($exp - $slack) &lt;= $val" />
   </xsl:function>
  <xsl:function as="xs:boolean" name="u:mod11">
      <xsl:param name="val" />
      <xsl:variable name="length" select="string-length($val) - 1" />
      <xsl:variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)" />
      <xsl:variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))" />
      <xsl:value-of select="number($val) > 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))" />
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
      <xsl:value-of select="number($checkdigits) = number($calculated_digits)" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:abn">
      <xsl:param name="val" />
      <xsl:value-of select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 " />
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
			            <xsl:value-of select="sum(       for $pos in 1 to string-length($mainPart) return         if ($pos mod 2 = 1)         then (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) mod 10 +           (number(substring($mainPart, string-length($mainPart) - $pos + 1, 1)) * 2) idiv 10         else number(substring($mainPart, string-length($mainPart) - $pos + 1, 1))      )" />
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
    <svrl:schematron-output schemaVersion="iso" title="Rules for Peppol Catalogue transaction 3.2">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Catalogue-2" />
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
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
      <xsl:apply-templates mode="M18" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M19" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M20" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M21" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Rules for Peppol Catalogue transaction 3.2</svrl:text>

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
          <svrl:text>Document MUST not contain empty elements.</svrl:text>
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
<xsl:template match="/*" mode="M19" priority="1011">
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
          <svrl:text>Document SHOULD not contain schema location.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" mode="M19" priority="1010">
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
          <svrl:text>A date must be formatted YYYY-MM-DD.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" mode="M19" priority="1009">
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
          <svrl:text>GLN must have a valid format according to GS1 rules.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" mode="M19" priority="1008">
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
          <svrl:text>Norwegian organization number MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']" mode="M19" priority="1007">
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
          <svrl:text>Belgian enterprise number MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']" mode="M19" priority="1006">
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
          <svrl:text>IPA Code (Codice Univoco Unità Organizzativa) must be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']" mode="M19" priority="1005">
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
          <svrl:text>Tax Code (Codice Fiscale) must be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '9907']" mode="M19" priority="1004">
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
          <svrl:text>Tax Code (Codice Fiscale) must be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']" mode="M19" priority="1003">
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
          <svrl:text>Italian VAT Code (Partita Iva) must be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '9906']" mode="M19" priority="1002">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '9906']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:checkPIVAseIT(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:checkPIVAseIT(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R048</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Italian VAT Code (Partita Iva) must be stated in the correct format</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']" mode="M19" priority="1001">
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
          <svrl:text>Swedish organization number MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']" mode="M19" priority="1000">
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
          <svrl:text>Australian Business Number (ABN) MUST be stated in the correct format.</svrl:text>
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
<xsl:variable name="clUNCL7143" select="tokenize('AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EMD EN FS GB GMN GN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSQ TSR TSS TST TSU UA UP VN VP VS VX ZZZ PPI', '\s')" />
  <xsl:variable name="cleas" select="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0177 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 0218 0221 0230 0235 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959 0147 0154 0158 0170 0194 0203 0205 0217 0225 0240', '\s')" />
  <xsl:variable name="clUNCL5387" select="tokenize('AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK AAL AAM AAN AAO AAP AAQ AAR AAS AAT AAU AAV AAW AAX AAY AAZ ABA ABB ABC ABD ABE ABF ABG ABH ABI ABJ ABK ABL ABM ABN ABO ABP ABQ ABR ABS ABT ABU ABV ABW ABX ABY ABZ ACA ACB AI ALT AP BR CAT CDV CON CP CU CUP CUS DAP DIS DPR DR DSC CSC ES EUP FCR GRP INV LBL MAX MIN MNR MSR MXR NE NQT NTP NW OFR PAQ PBQ PPD PPR PRO PRP PW QTE RES RTP SHD SRP SW TB TRF TU TW WH', '\s')" />
  <xsl:variable name="clMimeCode" select="tokenize('application/pdf image/png image/jpeg image/tiff application/acad application/dwg drawing/dwg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')" />
  <xsl:variable name="clUNCL8273" select="tokenize('ADR ADS ADT ADU ADY ADZ ADV ADW ADX AEA AEB AGS ANR ARD CFR COM GVE GVS ICA IMD RGE RID UI ZZZ', '\s')" />
  <xsl:variable name="clISO4217" select="tokenize('AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLE SOS SRD SSP STN SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UYW UZS VED VES VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA YER ZAR ZMW ZWG XXX', '\s')" />
  <xsl:variable name="clICD" select="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230 0231 0232 0233 0234 0235 0236 0237 0238 0239 0240', '\s')" />
  <xsl:variable name="clNA" select="tokenize('NA', '\s')" />
  <xsl:variable name="clActionCode_header" select="tokenize('Add Replace Update Delete', '\s')" />
  <xsl:variable name="clUNCL6313" select="tokenize('ABJ AAF AAX HT LN WD GW TC AAO', '\s')" />
  <xsl:variable name="clActionCode_line" select="tokenize('Add Update Delete', '\s')" />
  <xsl:variable name="clTransactionCondition" select="tokenize('CT NON_RETURNABLE', '\s')" />
  <xsl:variable name="clISO3166" select="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')" />
  <xsl:variable name="clTrueFalse" select="tokenize('true false', '\s')" />
  <xsl:variable name="clGS17009" select="tokenize('CU DU TU HN', '\s')" />
  <xsl:variable name="clUNCL1001" select="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 1999 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 539 550 551 552 553 554 575 576 577 578 579 580 581 582 583 584 585 586 587 588 589 610 621 622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637 638 639 640 641 642 643 644 645 646 647 648 649 650 651 652 653 654 655 656 657 658 659 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 717 718 719 720 721 722 723 724 725 726 727 728 729 730 731 732 733 734 735 736 737 738 739 740 741 742 743 744 745 746 747 748 749 750 751 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998', '\s')" />
  <xsl:variable name="clImage" select="tokenize('PRODUCT_IMAGE TRADE_ITEM_DESCRIPTION', '\s')" />
  <xsl:variable name="clPackagingMarkedLabelAccreditationCode" select="tokenize('100_PERCENT_CANADIAN_MILK 100_PERCENT_VEGANSKT 3PMSF ACMI ADCCPA AFIA_PET_FOOD_FACILITY AGENCE_BIO AGRI_CONFIANCE AGRI_NATURA AGRICULTURE_BIOLOGIQUE AHAM AISE AISE_2005 AISE_2010 AISE_2020_BRAND AISE_2020_COMPANY AKC_PEACH_KOSHER ALENTEJO_SUSTAINABILITY_PROGRAMME ALIMENTATION_DU_TOUT_PETIT ALIMENTS_BIO_PREPARES_AU_QUEBEC ALIMENTS_DU_QUEBEC ALIMENTS_DU_QUEBEC_BIO ALIMENTS_PREPARES_AU_QUEBEC ALLERGYCERTIFIED ALPINAVERA ALUMINIUM_GESAMTVERBAND_DER_ALUMINIUMINDUSTRIE AMA_GENUSSREGION AMA_ORGANIC_SEAL AMA_ORGANIC_SEAL_BLACK AMA_SEAL_OF_APPROVAL AMERICAN_DENTAL_ASSOCIATION AMERICAN_HEART_ASSOCIATION_CERTIFIED ANIMAL_WELFARE_APPROVED_GRASSFED AOP APPELLATION_ORIGINE_CONTROLEE APPROVED_BY_ASTHMA_AND_ALLERGY_ASSOC AQUA_GAP AQUACULTURE_STEWARDSHIP_COUNCIL ARGE_GENTECHNIK_FREI ARGENCERT ARLA_FARMER_OWNED ASCO ASMI ASTHMA_AND_ALLERGY_FOUNDATION_OF_AMERICA ATG AUS_KAUP_ESTONIA AUSTRALIAN_CERTIFIED_ORGANIC AUSTRIA_BIO_GARANTIE AUSTRIAN_ECO_LABEL BCARA_ORGANIC BDIH_LOGO BEBAT BEDRE_DYREVELFAERD_1HEART BEDRE_DYREVELFAERD_2HEART BEDRE_DYREVELFAERD_3HEART BEE_FRIENDLY BELGAQUA BENOR BERCHTESGADENER_LAND BEST_AQUACULTURE_PRACTICES BEST_AQUACULTURE_PRACTICES_2_STARS BEST_AQUACULTURE_PRACTICES_3_STARS BEST_AQUACULTURE_PRACTICES_4_STARS BETER_LEVEN_1_STER BETER_LEVEN_2_STER BETER_LEVEN_3_STER BETTER_BUSINESS_BUREAU_ACCREDITED BETTER_COTTON_INITIATIVE BEVEG BEWUSST_TIROL BEWUSTE_KEUZE BIKO_TIROL BIO_AUSTRIA_LABEL BIO_BAYERN_WITH_CERTIFICATE_PROVENANCE BIO_BAYERN_WITHOUT_CERTIFICATE_PROVENANCE BIO_BUD_SEAL BIO_BUD_SEAL_TRANSITION BIO_CZECH_LABEL BIO_FISCH BIO_GOURMET_BUD BIO_LABEL_BADEN_WURTTENBERG BIO_LABEL_GERMAN BIO_LABEL_HESSEN BIO_PARTENAIRE BIO_RING_ALLGAEU BIO_SOLIDAIRE BIO_SUISSE_BUD_SEAL BIO_SUISSE_BUD_SEAL_TRANSITION BIOCHECKED_NON_GLYPHOSATE_CERTIFIED BIOCHECKED_NON_GMO_VERIFIED BIODEGRADABLE BIODEGRADABLE_PRODUCTS_INSTITUTE BIODYNAMIC_CERTIFICATION BIODYNAMISCH BIOGARANTIE BIOKREIS BIOLAND BIOLAND_ENNSTAL BIOPARK BIOS_KONTROLLE BIRD_FRIENDLY_COFFEE_SMITHSONIAN_CERTIFICATION BK_CHECK_VAAD_HAKASHRUS_OF_BUFFALO BLEU_BLANC_COEUR BLUE_ANGEL BLUE_RIBBON_KOSHER BLUESIGN BODEGAS_ARGENTINA_SUSTAINABILITY_PROTOCOL BONSUCRO BORD_BIA_APPROVED BORD_BIA_APPROVED_MEAT BRA_MILJOVAL_LABEL_SWEDISH BRC_GLOBAL_STANDARDS BREATHEWAY BRITISH_DENTAL_HEALTH BRITISH_RETAIL_CONSORTIUM_CERTIFICATION BSCI BUENDNERFLEISCH_GGA BULLFROG CA_BEEF CA_BOTH_DOM_IMPORT CA_BULK CA_CANNED CA_DISTILLED CA_IMPORT CA_INGREDIENT CA_MADE CA_MUSTARD_SEEDS CA_OATS CA_PREPARED CA_PROCESSED CA_PRODUCT CA_PROUD CA_REFINED CA_ROASTED_BLENDED CAC_ABSENCE_EGG_MILK CAC_ABSENCE_EGG_MILK_PEANUTS CAC_ABSENCE_OF_ALMOND CAC_ABSENCE_OF_EGG CAC_ABSENCE_OF_MILK CAC_ABSENCE_OF_PEANUT CAC_ABSENCE_PEANUT_ALMOND CAFE_PRACTICES CAN_BNQ_CERTIFIED CANADA_GAP CANADIAN_AGRICULTURAL_PRODUCTS CANADIAN_ASSOCIATION_FIRE_CHIEFS_APPROVED CANADIAN_CERTIFIED_COMPOSTABLE CANADIAN_DERMATOLOGY_ASSOCIATION_SKIN_HEALTH CANADIAN_DERMATOLOGY_ASSOCIATION_SUN_PROTECTION CARBON_FOOTPRINT_STANDARD CARBON_NEUTRAL CARBON_NEUTRAL_NCOS_CERTIFIED CARBON_NEUTRAL_PACKAGING CARBON_NEUTRAL_SGS CARIBBEAN_KOSHER CCA_GLUTEN_FREE CCC CCF_RABBIT CCOF CCSW CEBEC CEL CELIAC_SPRUE_ASSOCIATION CENTRAL_RABBINICAL_CONGRESS_KOSHER CERTIFIE_TERROIR_CHARLEVOIX CERTIFIED_ANGUS_BEEF CERTIFIED_B_CORPORATION CERTIFIED_CARBON_FREE CERTIFIED_HUMANE_ORGANISATION CERTIFIED_NATURALLY_GROWN CERTIFIED_OE_100 CERTIFIED_ORGANIC_BAYSTATE_ORGANIC_CERTIFIERS CERTIFIED_ORGANIC_BY_ORGANIC_CERTIFIERS CERTIFIED_PALEO CERTIFIED_PALEO_FRIENDLY CERTIFIED_PLANT_BASED CERTIFIED_SUSTAINABLE_WINE_CHILE CERTIFIED_WBENC CERTIFIED_WILDLIFE_FRIENDLY CFG_PROCESSED_EGG CFIA CFIA_DAIRY CFIA_FISH CFIA_GRADE_A CFIA_GRADE_C CFIA_ORGANIC CFIA_UTILITY_POULTRY_EGG CHASSEURS_DE_FRANCE CHEESE_WORLD_CHAMPION_CHEESE_CONTEST CHES_K CHICAGO_RABBINICAL_COUNCIL CINCINNATI_KOSHER CLARO_FAIR_TRADE CLIMATE_NEUTRAL CLIMATE_NEUTRAL_PARTNER CMA CNG CO2_REDUCERET_EMBALLAGE CO2LOGIC_CO2_NEUTRAL_CERTIFIED COCOA_HORIZONS COCOA_LIFE COMPOSTABLE_DIN_CERTCO COMTE_GREEN_BELL CONFIT_DE_FRANCE CONFORMITE_EUROPEENNE CONSUMER_CHOICE_AWARD COR_DETROIT COR_KOSHER CORRUGATED_RECYCLES COSMEBIO COSMEBIO_COSMOS_NATURAL COSMEBIO_COSMOS_ORGANIC COSMETICI_BIOLOGICI COSMETICI_NATURALI COSMOS_NATURAL_BDIH COSMOS_ORGANIC_BDIH COTTON_MADE_IN_AFRICA CPE_SCHARREL_EIEREN CPE_VRIJE_UITLOOP_EIEREN CRADLE_TO_CRADLE CREATEUR_JOUET_FRANCAIS CROSSED_GRAIN_SYMBOL CROWN_CHK CRUELTY_FREE_PETA CSA_INTERNATIONAL CSA_NCA_GLUTEN_FREE CSI CULINARIUM CULTIVUP_EXIGENCE CULTIVUP_RESPONSABLE CZECH_FOOD DALLAS_KOSHER DANSK_IP_KVALITET DANSK_MAELK DEBIO DELINAT DEMAIN_LA_TERRE DEMETER_GUARANTEED DEMETER_LABEL DESIGN_FOR_THE_ENVIRONMENT DESIGN_FROM_FINLAND DIAMOND_K DIAMOND_KA_KASHRUT_AUTHORITY_OF_AUSTRALIA_AND_NZ DIRECT_TRADE DK_ECO DLG_AWARD DLG_CERTIFIED_ALLERGEN_MANAGEMENT  DNV_BUSINESS_ASSURANCE DOLPHIN_SAFE DONAU_SOYA_STANDARD DRP DUURZAAM_VARKENSVLEES DVF_VEGAN DVF_VEGETARIAN DYRENES_BESKYTTELSE DZG_GLUTEN_FREE EARTHKOSHER_KOSHER EARTHSURE ECARF_SEAL ECO_KREIS ECO_LABEL_CZECH ECO_LABEL_LADYBUG ECO_LOGO ECOCERT_CERTIFICATE ECOCERT_COSMOS_NATURAL ECOCERT_COSMOS_ORGANIC ECOCERT_NATURAL_DETERGENT ECOCERT_NATURAL_DETERGENT_MADE_WITH_ORGANIC ECOCERT_ORGANIC ECOGARANTIE ECOLAND ECOLOGO_CERTIFIED ECOLOGO_CERTIFIED_2 ECOVIN ECZEMA_SOCIETY_OF_CANADA EESTI_OKOMARK EESTI_PARIM_TOIDUAINE EKO ENEC ENERGY_LABEL_A ENERGY_LABEL_A+ ENERGY_LABEL_A++ ENERGY_LABEL_A+++ ENERGY_LABEL_B ENERGY_LABEL_C ENERGY_LABEL_D ENERGY_LABEL_E ENERGY_LABEL_F ENERGY_LABEL_G ENERGY_STAR ENTREPRISE_DU_PATRIMOINE_VIVANT ENTWINE_AUSTRALIA EPA_DFE EPEAT_BRONZE EPEAT_GOLD EPEAT_SILVER EQUAL_EXCHANGE_FAIRLY_TRADED EQUALITAS_SUSTAINABLE_WINE ERDE_SAAT ERKEND_STREEK_PRODUCT ETP EU_ECO_LABEL EU_ENERGY_LABEL EU_ORGANIC_FARMING EUROPE_SOYA_STANDARD EUROPEAN_V_LABEL_VEGAN EUROPEAN_V_LABEL_VEGETARIAN EUROPEAN_VEGETARIAN_UNION EWG_VERIFIED FABRICANT_JOUET_FRANCAIS FAIR_FLOWERS_FAIR_PLANTS FAIR_FOOD_PROGRAM_LABEL FAIR_FOR_LIFE FAIR_N_GREEN FAIR_TRADE_MARK FAIR_TRADE_USA FAIR_TRADE_USA_INGREDIENTS FAIR_TSA FAIR_WILD FAIRCHOICE_GERMANY FAIRTRADE_CASHEW_NUTS FAIRTRADE_CINNAMON FAIRTRADE_COCOA FAIRTRADE_COCONUT FAIRTRADE_COFFEE FAIRTRADE_COTTON FAIRTRADE_DRIED_APRICOTS FAIRTRADE_GREEN_TEA FAIRTRADE_HONEY FAIRTRADE_LIME_JUICE FAIRTRADE_MANGO_JUICE FAIRTRADE_OLIVE_OIL FAIRTRADE_PEPPER FAIRTRADE_QUINOA FAIRTRADE_RICE FAIRTRADE_ROSES FAIRTRADE_SUGAR FAIRTRADE_TEA FAIRTRADE_VANILLA FALKEN FCC FEDERALLY_REGISTERED_INSPECTED_CANADA FIDELIO FINNISH_HEART_SYMBOL FISH_WISE_CERTIFICATION FLAMME_VERTE FLANDRIA FLEURS_DE_FRANCE FLUSTIC_PRODUCTS_FREE_FROM_MICROPLASTICS FLUSTIX_COMPLETELY_FREE_FROM_PLASTICS FLUSTIX_PLASTIC_FREE_PACKAGING FLUSTIX_PLASTIC_FREE_PRODUCT FLUSTIX_PRODUCTS_FROM_RECYCLED_PLASTICS FLUSTIX_RECYCLABLE_PACKAGING FODMAP FODMAP_FRIENDLY FOIE_GRAS_DE_FRANCE FOOD_ALLIANCE_CERTIFIED FOOD_JUSTICE_CERTIFIED FOOD_SAFETY_SYSTEM_CERTIFICATION_22000 FOODLAND_ONTARIO FOR_LIFE FOREST_PRODUCTS_Z809 FOREST_STEWARDSHIP_COUNCIL_100_PERCENT FOREST_STEWARDSHIP_COUNCIL_LABEL FOREST_STEWARDSHIP_COUNCIL_MIX FOREST_STEWARDSHIP_COUNCIL_RECYCLED FOUNDATION_ART FRAN_SVERIGE FRANCE_LIMOUSIN_MEAT FREILAND FRESHCARE FRIEND_OF_THE_SEA FRUITS_ET_LEGUMES_DE_FRANCE FUME_EN_FRANCE GAEA GANEDEN_BC30_PROBIOTIC GAP_1 GAP_2 GAP_3 GAP_4 GAP_5 GAP_5_PLUS GASKEUR GASTEC GCP GEBANA GENUSS_REGION_AUSTRIA GEPRUEFTE_SICHERHEIT GEZONDERE_KEUZE GFCO GFCP GIG_GLUTEN_FREE_FOODSERVICE GLOBAL_CARE GLOBAL_GAP GLOBAL_ORGANIC_LATEX_STANDARD GLOBAL_ORGANIC_TEXTILE_STANDARD GLOBAL_RECYCLED_STANDARD GLYCAMIC_INDEX_FOUNDATION GLYCAMIC_RESEARCH_INSTITUTE GMO_GUARD_FROM_NATURAL_FOOD_CERTIFIERS GMO_MARKED GMP_CERTIFIED GMP_ISO_22716 GOA_ORGANIC GODKAND_FOR_EKOLOGISK_ODLING_KRAV GOOD_HOUSEKEEPING GOODS_FROM_FINLAND_BLUE_SWAN GOODWEAVE GRASKEURMERK GRASP GREEN_AMERICA_CERTIFIED_BUSINESS GREEN_DOT GREEN_E_ENERGY_CERT GREEN_E_ORG GREEN_RESTAURANT_ASSOCIATION_ENDORSED GREEN_SEAL GREEN_SEAL_CERTIFIED GREEN_SHIELD_CERTIFIED GREEN_STAR_CERTIFIED GREENCHOICE GROEN_LABEL_KAS GRUYERE_FRANCE GUARANTEED_IRISH HALAL_AUSTRALIA HALAL_CERTIFICATION_SERVICES HALAL_CERTIFICATION_SERVICES_CH HALAL_CORRECT HALAL_FOOD_COUNCIL_OF_SOUTH_EAST_ASIA_THAILAND HALAL_HIC HALAL_HPDS HALAL_IIDC HALAL_INDIA HALAL_ISLAMIC_FOOD_CANADA HALAL_ISLAMIC_SOCIETY_OF_NORTH_AMERICA HALAL_PLUS HALAL_QUALITY_CONTROL HAUTE_VALEUR_ENVIRONNEMENTALE HAZARD_ANALYSIS_CRITICAL_CONTROL_POINT HEALTH_CHECK HEALTH_FOOD_BLUE_HAT_SIGN HEUMILCH HFAC_HUMANE HMCA_HALAL_MONTREAL_CERTIFICATION_AUTHORITY HOCHSTAMM_SUISSE HOW_2_RECYCLE HUMANE_HEARTLAND HYPERTENSION_CANADA_MEDICAL_DEVICE ICADA ICEA ICELAND_RESPONSIBLE_FISHERIES ICS_ORGANIC IFANCA_HALAL IFOAM IFS_HPC IGP IHTK_SEAL IKB_EIEREN IKB_KIP IKB_VARKEN INDEKLIMA_MAERKET INSTITUT_FRESENIUS INT_PROTECTION INTEGRITY_AND_SUSTAINABILITY_CERTIFIED INTERNATIONAL_ALOE_SCIENCE_COUNCIL_CERTIFICATE INTERNATIONAL_KOSHER_COUNCIL INTERNATIONAL_TASTE_QUALITY INTERTEK_CERTIFICATE INTERTEK_ETL IP_SUISSE ISCC ISCC_SUPPORTING_THE_BIOECONOMY ISEAL_ALLIANCE ISO_QUALITY IVN_NATURAL_LEATHER IVN_NATURAL_TEXTILES_BEST IVO_OMEGA3 JAS_ORGANIC JAY_KOSHER_PAREVE JODSALZ_BZGA KABELKEUR KAGFREILAND KEHILLA_KOSHER_CALIFORNIA_K KEHILLA_KOSHER_HEART_K KEMA_KEUR KIWA KLASA KOF_K_KOSHER KOMO KOSHER_AUSTRALIA KOSHER_BDMC KOSHER_CERTIFICATION_SERVICE KOSHER_CHECK KOSHER_CHICAGO_RABBINICAL_COUNCIL_DAIRY KOSHER_CHICAGO_RABBINICAL_COUNCIL_PAREVE KOSHER_COR_DAIRY KOSHER_COR_DAIRY_EQUIPMENT KOSHER_COR_FISH KOSHER_EIDAH_HACHAREIDIS KOSHER_GRAND_RABBINATE_OF_QUEBEC_PARVE KOSHER_GREECE KOSHER_INSPECTION_SERVICE_INDIA KOSHER_KW_YOUNG_ISRAEL_OF_WEST_HEMPSTEAD KOSHER_MADRID_SPAIN KOSHER_OK_DAIRY KOSHER_ORGANICS KOSHER_ORTHODOX_JEWISH_CONGREGATION_PARVE KOSHER_OTTAWA_VAAD_HAKASHRUT_CANADA KOSHER_PARVE_BKA KOSHER_PARVE_NATURAL_FOOD_CERTIFIER KOSHER_PERU KOSHER_RAV_LANDAU KOSHER_STAR_K_PARVE KOSHER_STAR_K_PARVE_PASSOVER KOSHER_STAR_S_P_KITNIYOT KOSHERMEX KOTT_FRAN_SVERIGE KRAV_MARK KSA_KOSHER KSA_KOSHER_DAIRY KVBG_APPROVED LAATUVASTUU LABEL_OF_THE_ALLERGY_AND_ASTHMA_FEDERATION LABEL_ROUGE LACON LAENDLE_QUALITAET LAIT_COLLECTE_ET_CONDITIONNE_EN_FRANCE LAIT_COLLECTE_ET_TRANSFORME_EN_FRANCE LAPIN_DE_FRANCE LE_PORC_FRANCAIS LEAPING_BUNNY LEGUMES_DE_FRANCE LETIS_ORGANIC LGA LOCALIZE LODI_RULES_CODE LONDON_BETH_DIN_KOSHER LOODUSSOBRALIK_TOODE_ESTONIA LOVE_IRISH_FOOD LVA MADE_FOR_RECYCLING_INTERSEROH MADE_GREEN_IN_ITALY MADE_IN_FINLAND_FLAG_WITH_KEY MADE_OF_PLASTIC_BEVERAGE_CUPS MADE_WITH_CANADIAN_BEEF MAGRET_DE_FRANCE MAITRE_ARTISAN MARINE_CONSERVATION_SOCIETY MARINE_STEWARDSHIP_COUNCIL_LABEL MAX_HAVELAAR MCIA_ORGANIC MEHR_WEG MIDWEST_KOSHER MILIEUKEUR MINNESOTA_KOSHER_COUNCIL MJOLK_FRAN_SVERIGE MOEBELFAKTA MOMS_CHOICE_AWARD MONTREAL_VAAD_HAIR_MK_PAREVE MORTADELLA_BOLOGNA MPS_A MUNDUSVINI_GOLD MUNDUSVINI_SILVER MUSLIM_JUDICIAL_COUNCIL_HALAAL_TRUST MY_CLIMATE NAOOA_CERTIFIED_QUALITY NAPA_GREEN_VINEYARD NAPA_GREEN_WINERY NASAA_CERTIFIED_ORGANIC NATRUE_LABEL NATURA_BEEF NATURA_VEAL NATURE_CARE_PRODUCT NATURE_ET_PROGRES NATUREPLUS NATURLAND NATURLAND_FAIR_TRADE NATURLAND_WILDFISH NC_NATURAL_COSMETICS_STANDARD NC_NATURAL_COSMETICS_STANDARD_ORGANIC_QUALITY NC_VEGAN_NATURAL_COSMETICS NC_VEGAN_NATURAL_COSMETICS_STANDARD_ORGANIC_QUALITY NCA_GLUTEN_FREE NDOA NEA NEULAND NEW_ZEALAND_SUSTAINABLE_WINEGROWING NF_MARQUE NFCA_GLUTEN_FREE NIX18 NMX NOM NON_GMO_BY_EARTHKOSHER NON_GMO_PROJECT NPA NSF NSF_CERTIFIED_FOR_SPORT NSF_GLUTEN_FREE NSF_NON_GMO_TRUE_NORTH NSF_SUSTAINABILITY_CERTIFIED NSM NYCKELHALET OCEAN_WISE OCIA OCQV_ORGANIC OECD_BIO_INGREDIENTS OEKO_CONTROL OEKO_KREISLAUF OEKO_QUALITY_GUARANTEE_BAVARIA OEKO_TEX_LABEL OEKO_TEX_MADE_IN_GREEN OEUFS_DE_FRANCE OFF_ORGANIC OFFICIAL_ECO_LABEL_SUN OFG_ORGANIC OHNE_GEN_TECHNIK OK_COMPOST_HOME OK_COMPOST_INDUSTRIAL OK_COMPOST_VINCOTTE OK_KOSHER OKOTEST ON_THE_WAY_TO_PLANETPROOF ONE_PERCENT_FOR_THE_PLANET ONTARIO_APPROVED ONTARIO_PORK ORB ORBI OREGON_KOSHER OREGON_LIVE OREGON_TILTH ORGANIC_100_CONTENT_STANDARD ORGANIC_COTTON ORGANIC_TRADE_ASSOCIATION ORIGIN_OF_EGGS ORIGINE_FRANCE_GARANTIE ORTHODOX_UNION OTCO_ORGANIC OU_KOSHER OU_KOSHER_DAIRY OU_KOSHER_FISH OU_KOSHER_MEAT OU_KOSHER_PASSOVER OZONE_FRIENDLY_GENERAL_CLAIM PACS_ORGANIC PALEO_APPROVED PALEO_BY_EARTHKOSHER PARENT_TESTED_PARENT_APPROVED PAVILLON_FRANCE PCO PEFC PEFC_CERTIFIED PEFC_RECYCLED PET_TO_PET PGI_CNIPA PGI_GAQSIQ PGI_MARA PGI_TO_SAIC PLASTIC_FREE_TRUST_MARK PLASTIC_IN_FILTER_TOBACCO PLASTIC_IN_PRODUCT_BEVERAGE_CUPS PLASTIC_IN_PRODUCT_TAMPONS PLASTIC_IN_PRODUCT_WIPES_SANITARY_PADS PLASTIC_NEUTRAL PME_PLUS POMMES_DE_TERRES_DE_FRANCE PREGNANCY_WARNING PRO_NATURE PRO_SPECIE_RARA PRO_TERRA_NON-GMO_CERTIFICATION PROCERT_ORGANIC PRODERM PRODUCT_OF_THE_YEAR_CONSUMER_SURVEY PRODUIT_DE_FRANCE PRODUIT_EN_BRETAGNE PROTECTED_DESIGNATION_OF_ORIGIN PROTECTED_GEOGRAPHICAL_INDICATION PROTECTED_HARVEST_CERTIFIED PROVEN_QUALITY_BAVARIA PUHTAASTI_KOTIMAINEN QAI QCS_ORGANIC QS QS_PRODUCTION_PERMIT QUALENVI QUALITAET_TIROL QUALITY_CONFORMANCE_MARKING_CN QUALITY_MARK_IRELAND QUALITY_RHOEN QZBW QZHE RABBINICAL_COUNCIL_OF_BRITISH_COLUMBIA RABBINICAL_COUNCIL_OF_CALIFORNIA_(RCC) RABBINICAL_COUNCIL_OF_NEW_ENGLAND RAINFOREST_ALLIANCE RAINFOREST_ALLIANCE_PEOPLE_NATURE RAL_QUALITY_CANDLES REAL_CALIFORNIA_CHEESE REAL_CALIFORNIA_MILK REAL_FOOD_SEAL RECUPEL RECYCLABLE_GENERAL_CLAIM REGIONAL_FOOD_CZECH REGIONALFENSTER REGIONALTHEKE_FRANKEN REPAIRABILITY_INDEX RETURNABLE_CAN_NL RETURNABLE_PET_BOTTLE_NL RHP ROQUEFORT_RED_EWE ROUNDTABLE_ON_RESPONSIBLE_SOY RSB RUP_GUADELOUPE RUP_GUYANE RUP_MARTINIQUE RUP_MAYOTTE RUP_REUNION RUP_SAINT_MARTIN SA8000 SAFE_FEED_SAFE_FOOD SAFE_QUALITY_FOOD SAFER_CHOICE SALMON_SAFE_CERTIFICATION SALZBURGER_LAND_HERKUNFT SCHARRELVLEES SCHLESWIG_HOLSTEIN_QUALITY SCROLL_K SCS_RECYCLED_CONTENT_CERTIFICATION SCS_SUSTAINABLY_GROWN SEACHOICE SEPARATE_COLLECTION SFC_MEMBER_SEAL SFC_MEMBER_SEAL_GOLD SFC_MEMBER_SEAL_PLATINUM SFC_MEMBER_SEAL_SILVER SGS_ORGANIC SHOPPER_ARMY SIP SKG_CERTIFICATE SKG_CERTIFICATE_1_STAR SKG_CERTIFICATE_2_STAR SKG_CERTIFICATE_3_STAR SLG_CHILD_SAFETY SLG_TYPE_TESTED SLK_BIO SMAK SOCIETY_PLASTICS_INDUSTRY SOIL_ASSOCIATION_ORGANIC_SYMBOL SOIL_COSMOS_NATURAL SOIL_ORGANIC_COSMOS SOSTAIN SPCA_BC SQNPI STAR_D_KOSHER STAR_K_KOSHER STEEL_RECYCLING STELLAR_CERTIFICATION_SERVICES STIFTUNG_WARENTEST STOP_CLIMATE_CHANGE STREEKPRODUCT_BE STRICTLY_KOSHER_NORWAY SUISSE_GARANTIE SUNSHINE_STATE_KOSHER SUOMEN_HAMMASLAAKARILIITTO_SUOSITTELEE_KSYLITOLIA SUS SUSTAINABLE_AUSTRALIA_WINEGROWING SUSTAINABLE_AUSTRIA SUSTAINABLE_FORESTRY_INITIATIVE SUSTAINABLE_PALM_OIL_RSPO SUSTAINABLE_PALM_OIL_RSPO_CREDITS SUSTAINABLE_PALM_OIL_RSPO_MIXED SUSTAINABLE_WINEGROWING_AUSTRALIA SUSTAINABLE_WINES_OF_GREAT_BRITAIN SVANEN SVENSK_FAGEL SVENSKT_KOTT SVENSKT_SIGILL_KLIMATCERTIFIERAD SVENSKT_SIGILL_NATURBETESKOTT SWEDISH_SEAL_OF_QUALITY SWISS_ALLERGY_LABEL SWISS_ALPS_PRODUCT SWISS_MOUNTAIN_PRODUCT SWISSGAP SWISSMILK_GREEN SWISSPRIMGOURMET TARNOPOL_KASHRUS_KOSHER TCO_DEVELOPMENT TCO_ORGANIC TERRA_VITIS TERRACYCLE THE_FAIR_RUBBER_ASSOCIATION THE_NATURAL_AND_ORGANIC_AWARDS THREE_LINE_KOSHER TIERSCHUTZBUND TNO_APPROVED TOOTHFRIENDLY TRADITIONAL_SPECIALTY_GUARANTEED TRIANGLE_K TRIANGLE_K_DAIRY TRIMAN TRUE_FOODS_CANADA_TRUSTMARK TRUE_SOURCE_CERTIFIED TUEV_GEPRUEFT TUNNUSTATUD_EESTI_MAITSE TUNNUSTATUD_MAITSE UDEN_GMO_FODER UEBT UK_CONFORMITY_ASSESSED UMWELTBAUM UNDERWRITERS_LABORATORY UNDERWRITERS_LABORATORY_CERTIFIED_CANADA_US UNIQUELY_FINNISH UNITED_EGG_PRODUCERS_CERTIFIED UNSER_LAND URDINKEL USDA USDA_CERTIFIED_BIOBASED USDA_GRADE_A USDA_GRADE_AA USDA_INSPECTION USDA_ORGANIC UTZ_CERTIFIED UTZ_CERTIFIED_COCOA VAAD_HOEIR_KOSHER VAELG_FULDKORN_FORST VDE VDS_CERTIFICATE VEGAN_AWARENESS_FOUNDATION VEGAN_BY_EARTHKOSHER VEGAN_NATURAL_FOOD_CERTIFIERS VEGAN_SOCIETY_VEGAN_LOGO VEGAPLAN VEGATARIAN_SOCIETY_V_LOGO VEGECERT VEILIG_WONEN_POLITIE_KEURMERK VERBUND_OEKOHOEFE VERGERS_ECORESPONSABLES VIANDE_AGNEAU_FRANCAIS VIANDE_BOVINE_FRANCAISE VIANDE_CHEVALINE_FRANCAISE VIANDE_DE_CHEVRE_FRANCAISE VIANDE_DE_CHEVREAU_FRANCAISE VIANDE_DE_VEAU_FRANCAISE VIANDE_OVINE_FRANCAISE VIANDES_DE_FRANCE VIGNERONS_EN_DEVELOPPEMENT_DURABLE VIGNERONS_ENGAGES VIM_CO_JIM VINATURA VINHO_VERDE VITICULTURE_DURABLE_EN_CHAMPAGNE VIVA VOLAILLE_FRANCAISE WARRANT_HOLDER_OF_THE_COURT_OF_BELGIUM WEIDEMELK WEIGHT_WATCHERS_ENDORSED WELFARE_QUALITY WESTERN_KOSHER WHOLE_GRAIN_100_PERCENT_STAMP WHOLE_GRAIN_BASIC_STAMP WHOLE_GRAIN_COUNCIL_STAMP WHOLE_GRAINS_50_PERCENT_STAMP WIETA WINERIES_FOR_CLIMATE_PROTECTION WISCONSIN_K WQA_TESTED_CERTIFIED_WATER WSDA WWF_PANDA_LABEL ZELDZAAM_LEKKER ZERO_RESIDU_DE_PESTICIDES ZERO_WASTE_BUSINESS_COUNCIL_CERTIFIED', '\s')" />
  <xsl:variable name="clUNECERec20" select="tokenize('10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A53 A54 A55 A56 A59 A6 A68 A69 A7 A70 A71 A73 A74 A75 A76 A8 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B4 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DBM DBW DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FNU FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAD HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMO HMQ HMT HPA HTZ HUR HWE IA IE INH INK INQ ISD IU IUG IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWN KWO KWS KWT KWY KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MKD MKM MKW MLD MLT MMK MMQ MMT MND MNJ MON MPA MQD MQH MQM MQS MQW MRD MRM MRW MSK MTK MTQ MTR MTS MTZ MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NTU NU NX OA ODE ODG ODK ODM OHM ON ONZ OPM OT OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q41 Q42 Q3 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 YDK YDQ YRD Z11 Z9 ZP ZZ X1A X1B X1D X1F X1G X1W X2C X3A X3H X43 X44 X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XO1 XO2 XO3 XO4 XO5 XO6 XO7 XO8 XO9 XOA XOB XOC XOD XOE XOF XOG XOH XOI XOK XOJ XOL XOM XON XOP XOQ XOR XOS XOV XOW XOT XOU XOX XOY XOZ XP1 XP2 XP3 XP4 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSX XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVO XVP XVQ XVN XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY XZZ', '\s')" />

	<!--RULE -->
<xsl:template match="/ubl:Catalogue" mode="M20" priority="1277">
    <svrl:fired-rule context="/ubl:Catalogue" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CustomizationID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CustomizationID">
          <xsl:attribute name="id">PEPPOL-T19-B00101</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B00102</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B00103</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B00104</xsl:attribute>
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
      <xsl:when test="cac:ValidityPeriod" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:ValidityPeriod">
          <xsl:attribute name="id">PEPPOL-T19-B00105</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:ValidityPeriod' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:ProviderParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:ProviderParty">
          <xsl:attribute name="id">PEPPOL-T19-B00106</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:ProviderParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:ReceiverParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:ReceiverParty">
          <xsl:attribute name="id">PEPPOL-T19-B00107</xsl:attribute>
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
      <xsl:when test="cac:CatalogueLine" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:CatalogueLine">
          <xsl:attribute name="id">PEPPOL-T19-B00108</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:CatalogueLine' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@*:schemaLocation)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@*:schemaLocation)">
          <xsl:attribute name="id">PEPPOL-T19-B00109</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cbc:CustomizationID" mode="M20" priority="1276">
    <svrl:fired-rule context="/ubl:Catalogue/cbc:CustomizationID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cbc:ProfileID" mode="M20" priority="1275">
    <svrl:fired-rule context="/ubl:Catalogue/cbc:ProfileID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cbc:ID" mode="M20" priority="1274">
    <svrl:fired-rule context="/ubl:Catalogue/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cbc:ActionCode" mode="M20" priority="1273">
    <svrl:fired-rule context="/ubl:Catalogue/cbc:ActionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clActionCode_header satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clActionCode_header satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B00501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Catalogue Action code, header level (OpenPeppol)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cbc:Name" mode="M20" priority="1272">
    <svrl:fired-rule context="/ubl:Catalogue/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cbc:IssueDate" mode="M20" priority="1271">
    <svrl:fired-rule context="/ubl:Catalogue/cbc:IssueDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cbc:VersionID" mode="M20" priority="1270">
    <svrl:fired-rule context="/ubl:Catalogue/cbc:VersionID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ValidityPeriod" mode="M20" priority="1269">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ValidityPeriod" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ValidityPeriod/cbc:StartDate" mode="M20" priority="1268">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ValidityPeriod/cbc:StartDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ValidityPeriod/cbc:EndDate" mode="M20" priority="1267">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ValidityPeriod/cbc:EndDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ValidityPeriod/*" mode="M20" priority="1266">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ValidityPeriod/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B00901</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReferencedContract" mode="M20" priority="1265">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReferencedContract" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B01201</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReferencedContract/cbc:ID" mode="M20" priority="1264">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReferencedContract/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReferencedContract/*" mode="M20" priority="1263">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReferencedContract/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B01202</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SourceCatalogueReference" mode="M20" priority="1262">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SourceCatalogueReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B01401</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SourceCatalogueReference/cbc:ID" mode="M20" priority="1261">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SourceCatalogueReference/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SourceCatalogueReference/*" mode="M20" priority="1260">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SourceCatalogueReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B01402</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty" mode="M20" priority="1259">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">PEPPOL-T19-B01601</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B01602</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cbc:EndpointID" mode="M20" priority="1258">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T19-B01701</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B01702</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PartyIdentification" mode="M20" priority="1257">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B01901</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PartyIdentification/cbc:ID" mode="M20" priority="1256">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T19-B02001</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress" mode="M20" priority="1255">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T19-B02201</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cbc:StreetName" mode="M20" priority="1254">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M20" priority="1253">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cbc:CityName" mode="M20" priority="1252">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cbc:PostalZone" mode="M20" priority="1251">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cbc:CountrySubentity" mode="M20" priority="1250">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cac:AddressLine" mode="M20" priority="1249">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cac:AddressLine" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M20" priority="1248">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cac:Country" mode="M20" priority="1247">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T19-B03001</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1246">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B03101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cac:Country/*" mode="M20" priority="1245">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B03002</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/*" mode="M20" priority="1244">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B02202</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity" mode="M20" priority="1243">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T19-B03201</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M20" priority="1242">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M20" priority="1241">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T19-B03401</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M20" priority="1240">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M20" priority="1239">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M20" priority="1238">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T19-B03801</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1237">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B03901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M20" priority="1236">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B03802</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M20" priority="1235">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B03601</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/*" mode="M20" priority="1234">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B03202</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ProviderParty/*" mode="M20" priority="1233">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ProviderParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B01603</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty" mode="M20" priority="1232">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">PEPPOL-T19-B04001</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B04002</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cbc:EndpointID" mode="M20" priority="1231">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T19-B04101</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B04102</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PartyIdentification" mode="M20" priority="1230">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B04301</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PartyIdentification/cbc:ID" mode="M20" priority="1229">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T19-B04401</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress" mode="M20" priority="1228">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T19-B04601</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cbc:StreetName" mode="M20" priority="1227">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M20" priority="1226">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cbc:CityName" mode="M20" priority="1225">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cbc:PostalZone" mode="M20" priority="1224">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cbc:CountrySubentity" mode="M20" priority="1223">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine" mode="M20" priority="1222">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M20" priority="1221">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cac:Country" mode="M20" priority="1220">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T19-B05401</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1219">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B05501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cac:Country/*" mode="M20" priority="1218">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B05402</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/*" mode="M20" priority="1217">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B04602</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity" mode="M20" priority="1216">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T19-B05601</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cbc:RegistrationName" mode="M20" priority="1215">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M20" priority="1214">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T19-B05801</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M20" priority="1213">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M20" priority="1212">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M20" priority="1211">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1210">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B06301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M20" priority="1209">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B06201</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M20" priority="1208">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B06001</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/*" mode="M20" priority="1207">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B05602</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ReceiverParty/*" mode="M20" priority="1206">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ReceiverParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B04003</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty" mode="M20" priority="1205">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Party" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Party">
          <xsl:attribute name="id">PEPPOL-T19-B06401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party" mode="M20" priority="1204">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cbc:EndpointID" mode="M20" priority="1203">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T19-B06601</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B06602</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification" mode="M20" priority="1202">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B06801</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M20" priority="1201">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T19-B06901</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyName" mode="M20" priority="1200">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T19-B07101</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name" mode="M20" priority="1199">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress" mode="M20" priority="1198">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T19-B07301</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M20" priority="1197">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M20" priority="1196">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M20" priority="1195">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M20" priority="1194">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M20" priority="1193">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M20" priority="1192">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M20" priority="1191">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country" mode="M20" priority="1190">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T19-B08101</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1189">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B08201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M20" priority="1188">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B08102</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*" mode="M20" priority="1187">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B07302</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:Contact" mode="M20" priority="1186">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:Contact" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Name" mode="M20" priority="1185">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Telephone" mode="M20" priority="1184">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail" mode="M20" priority="1183">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:Contact/*" mode="M20" priority="1182">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B08301</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/*" mode="M20" priority="1181">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/cac:Party/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B06501</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:SellerSupplierParty/*" mode="M20" priority="1180">
    <svrl:fired-rule context="/ubl:Catalogue/cac:SellerSupplierParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B06402</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty" mode="M20" priority="1179">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party" mode="M20" priority="1178">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cbc:EndpointID" mode="M20" priority="1177">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T19-B08901</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B08902</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyIdentification" mode="M20" priority="1176">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B09101</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M20" priority="1175">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T19-B09201</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyName" mode="M20" priority="1174">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T19-B09401</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyName/cbc:Name" mode="M20" priority="1173">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress" mode="M20" priority="1172">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T19-B09601</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M20" priority="1171">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M20" priority="1170">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M20" priority="1169">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M20" priority="1168">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M20" priority="1167">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M20" priority="1166">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M20" priority="1165">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cac:Country" mode="M20" priority="1164">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T19-B10401</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1163">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B10501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M20" priority="1162">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B10402</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/*" mode="M20" priority="1161">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B09602</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:Contact" mode="M20" priority="1160">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:Contact" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:Contact/cbc:Name" mode="M20" priority="1159">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:Contact/cbc:Telephone" mode="M20" priority="1158">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" mode="M20" priority="1157">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:Contact/*" mode="M20" priority="1156">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B10601</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/*" mode="M20" priority="1155">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/cac:Party/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B08801</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:ContractorCustomerParty/*" mode="M20" priority="1154">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ContractorCustomerParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B08701</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:TradingTerms" mode="M20" priority="1153">
    <svrl:fired-rule context="/ubl:Catalogue/cac:TradingTerms" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:TradingTerms/cbc:Information" mode="M20" priority="1152">
    <svrl:fired-rule context="/ubl:Catalogue/cac:TradingTerms/cbc:Information" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:TradingTerms/*" mode="M20" priority="1151">
    <svrl:fired-rule context="/ubl:Catalogue/cac:TradingTerms/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B11001</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine" mode="M20" priority="1150">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B11201</xsl:attribute>
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
      <xsl:when test="cac:Item" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Item">
          <xsl:attribute name="id">PEPPOL-T19-B11202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Item' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cbc:ID" mode="M20" priority="1149">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cbc:ActionCode" mode="M20" priority="1148">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cbc:ActionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clActionCode_line satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clActionCode_line satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B11401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Catalogue Action code, line level (OpenPeppol)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cbc:OrderableIndicator" mode="M20" priority="1147">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cbc:OrderableIndicator" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clTrueFalse satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clTrueFalse satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B11501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Boolean indicator (OpenPeppol)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cbc:OrderableUnit" mode="M20" priority="1146">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cbc:OrderableUnit" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNECERec20 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNECERec20 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B11601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cbc:ContentUnitQuantity" mode="M20" priority="1145">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cbc:ContentUnitQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B11701</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B11702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cbc:OrderQuantityIncrementNumeric" mode="M20" priority="1144">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cbc:OrderQuantityIncrementNumeric" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cbc:MinimumOrderQuantity" mode="M20" priority="1143">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cbc:MinimumOrderQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B12001</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B12002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cbc:MaximumOrderQuantity" mode="M20" priority="1142">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cbc:MaximumOrderQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B12201</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B12202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cbc:WarrantyInformation" mode="M20" priority="1141">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cbc:WarrantyInformation" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cbc:PackLevelCode" mode="M20" priority="1140">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cbc:PackLevelCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clGS17009 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clGS17009 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B12501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Packaging level code (GS1 7009)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:LineValidityPeriod" mode="M20" priority="1139">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:LineValidityPeriod" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:LineValidityPeriod/cbc:StartDate" mode="M20" priority="1138">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:LineValidityPeriod/cbc:StartDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:LineValidityPeriod/cbc:EndDate" mode="M20" priority="1137">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:LineValidityPeriod/cbc:EndDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:LineValidityPeriod/*" mode="M20" priority="1136">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:LineValidityPeriod/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B12601</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:ItemComparison" mode="M20" priority="1135">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:ItemComparison" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:ItemComparison/cbc:PriceAmount" mode="M20" priority="1134">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:ItemComparison/cbc:PriceAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T19-B13001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
          <xsl:attribute name="id">PEPPOL-T19-B13002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:ItemComparison/cbc:Quantity" mode="M20" priority="1133">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:ItemComparison/cbc:Quantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B13201</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B13202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:ComponentRelatedItem" mode="M20" priority="1132">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:ComponentRelatedItem" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:ComponentRelatedItem/cbc:ID" mode="M20" priority="1131">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:ComponentRelatedItem/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:ComponentRelatedItem/cbc:Quantity" mode="M20" priority="1130">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:ComponentRelatedItem/cbc:Quantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B13601</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B13602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:ComponentRelatedItem/*" mode="M20" priority="1129">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:ComponentRelatedItem/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B13401</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:AccessoryRelatedItem" mode="M20" priority="1128">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:AccessoryRelatedItem" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:AccessoryRelatedItem/cbc:ID" mode="M20" priority="1127">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:AccessoryRelatedItem/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:AccessoryRelatedItem/cbc:Quantity" mode="M20" priority="1126">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:AccessoryRelatedItem/cbc:Quantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B14001</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B14002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:AccessoryRelatedItem/*" mode="M20" priority="1125">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:AccessoryRelatedItem/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B13801</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredRelatedItem" mode="M20" priority="1124">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredRelatedItem" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredRelatedItem/cbc:ID" mode="M20" priority="1123">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredRelatedItem/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredRelatedItem/cbc:Quantity" mode="M20" priority="1122">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredRelatedItem/cbc:Quantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B14401</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B14402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredRelatedItem/*" mode="M20" priority="1121">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredRelatedItem/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B14201</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:ReplacedRelatedItem" mode="M20" priority="1120">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:ReplacedRelatedItem" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:ReplacedRelatedItem/cbc:ID" mode="M20" priority="1119">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:ReplacedRelatedItem/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:ReplacedRelatedItem/cbc:Quantity" mode="M20" priority="1118">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:ReplacedRelatedItem/cbc:Quantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B14801</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B14802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:ReplacedRelatedItem/*" mode="M20" priority="1117">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:ReplacedRelatedItem/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B14601</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity" mode="M20" priority="1116">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cbc:LeadTimeMeasure" mode="M20" priority="1115">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cbc:LeadTimeMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B15101</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B15102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cbc:MinimumQuantity" mode="M20" priority="1114">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cbc:MinimumQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B15301</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B15302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cbc:MaximumQuantity" mode="M20" priority="1113">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cbc:MaximumQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B15501</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B15502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress" mode="M20" priority="1112">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cbc:StreetName" mode="M20" priority="1111">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cbc:AdditionalStreetName" mode="M20" priority="1110">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cbc:CityName" mode="M20" priority="1109">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cbc:CityName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cbc:PostalZone" mode="M20" priority="1108">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cbc:CountrySubentity" mode="M20" priority="1107">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cac:AddressLine" mode="M20" priority="1106">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cac:AddressLine" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cac:AddressLine/cbc:Line" mode="M20" priority="1105">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cac:Country" mode="M20" priority="1104">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T19-B16501</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cac:Country/cbc:IdentificationCode" mode="M20" priority="1103">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B16601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cac:Country/*" mode="M20" priority="1102">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B16502</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/*" mode="M20" priority="1101">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B15701</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price" mode="M20" priority="1100">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:PriceAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:PriceAmount">
          <xsl:attribute name="id">PEPPOL-T19-B16701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:PriceAmount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:PriceAmount" mode="M20" priority="1099">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:PriceAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T19-B16801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'currencyID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@currencyID) or (some $code in $clISO4217 satisfies $code = @currencyID)">
          <xsl:attribute name="id">PEPPOL-T19-B16802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:BaseQuantity" mode="M20" priority="1098">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:BaseQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B17001</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B17002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:PriceType" mode="M20" priority="1097">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:PriceType" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL5387 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL5387 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B17201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Price type codes (UNCL5387)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:OrderableUnitFactorRate" mode="M20" priority="1096">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:OrderableUnitFactorRate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod" mode="M20" priority="1095">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod/cbc:StartDate" mode="M20" priority="1094">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod/cbc:StartDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod/cbc:EndDate" mode="M20" priority="1093">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod/cbc:EndDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod/*" mode="M20" priority="1092">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B17401</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/*" mode="M20" priority="1091">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B16702</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/*" mode="M20" priority="1090">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B15001</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item" mode="M20" priority="1089">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T19-B17701</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cbc:Description" mode="M20" priority="1088">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cbc:Description" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cbc:PackQuantity" mode="M20" priority="1087">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cbc:PackQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B17901</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B17902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cbc:PackSizeNumeric" mode="M20" priority="1086">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cbc:PackSizeNumeric" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cbc:Name" mode="M20" priority="1085">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cbc:Keyword" mode="M20" priority="1084">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cbc:Keyword" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cbc:BrandName" mode="M20" priority="1083">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cbc:BrandName" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:BuyersItemIdentification" mode="M20" priority="1082">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:BuyersItemIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B18501</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:BuyersItemIdentification/cbc:ID" mode="M20" priority="1081">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:BuyersItemIdentification/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:BuyersItemIdentification/*" mode="M20" priority="1080">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:BuyersItemIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B18502</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:SellersItemIdentification" mode="M20" priority="1079">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:SellersItemIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B18701</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:SellersItemIdentification/cbc:ID" mode="M20" priority="1078">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:SellersItemIdentification/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:SellersItemIdentification/*" mode="M20" priority="1077">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:SellersItemIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B18702</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturersItemIdentification" mode="M20" priority="1076">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturersItemIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B18901</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturersItemIdentification/cbc:ID" mode="M20" priority="1075">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturersItemIdentification/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturersItemIdentification/*" mode="M20" priority="1074">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturersItemIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B18902</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:StandardItemIdentification" mode="M20" priority="1073">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:StandardItemIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B19101</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:StandardItemIdentification/cbc:ID" mode="M20" priority="1072">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:StandardItemIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T19-B19201</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B19202</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:StandardItemIdentification/*" mode="M20" priority="1071">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:StandardItemIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B19102</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference" mode="M20" priority="1070">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B19401</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID" mode="M20" priority="1069">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cbc:DocumentTypeCode" mode="M20" priority="1068">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cbc:DocumentTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text())) or (some $code in $clImage satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL1001 satisfies $code = normalize-space(text())) or (some $code in $clImage satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B19601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Document name code, full list (UNCL1001)' or 'Image code (OpenPeppol)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cbc:DocumentDescription" mode="M20" priority="1067">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cbc:DocumentDescription" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment" mode="M20" priority="1066">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject" mode="M20" priority="1065">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@mimeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@mimeCode">
          <xsl:attribute name="id">PEPPOL-T19-B19901</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B19902</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B19903</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment/cac:ExternalReference" mode="M20" priority="1064">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment/cac:ExternalReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:URI" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:URI">
          <xsl:attribute name="id">PEPPOL-T19-B20201</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI" mode="M20" priority="1063">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment/cac:ExternalReference/*" mode="M20" priority="1062">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment/cac:ExternalReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B20202</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment/*" mode="M20" priority="1061">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/cac:Attachment/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B19801</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/*" mode="M20" priority="1060">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B19402</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:OriginCountry" mode="M20" priority="1059">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:OriginCountry" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T19-B20401</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:OriginCountry/cbc:IdentificationCode" mode="M20" priority="1058">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:OriginCountry/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B20501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:OriginCountry/*" mode="M20" priority="1057">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:OriginCountry/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B20402</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:CommodityClassification" mode="M20" priority="1056">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:CommodityClassification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ItemClassificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ItemClassificationCode">
          <xsl:attribute name="id">PEPPOL-T19-B20601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ItemClassificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" mode="M20" priority="1055">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="id">PEPPOL-T19-B20701</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B20702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Item type identification code (UNCL7143)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:CommodityClassification/*" mode="M20" priority="1054">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:CommodityClassification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B20602</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:TransactionConditions" mode="M20" priority="1053">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:TransactionConditions" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ActionCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ActionCode">
          <xsl:attribute name="id">PEPPOL-T19-B21101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ActionCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:TransactionConditions/cbc:ActionCode" mode="M20" priority="1052">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:TransactionConditions/cbc:ActionCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clTransactionCondition satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clTransactionCondition satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B21201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Transaction condition code (OpenPeppol)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:TransactionConditions/*" mode="M20" priority="1051">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:TransactionConditions/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B21102</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:HazardousItem" mode="M20" priority="1050">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:HazardousItem" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:HazardousItem/cbc:UNDGCode" mode="M20" priority="1049">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:HazardousItem/cbc:UNDGCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL8273 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL8273 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B21401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Dangerous goods regulations code (UNCL8273)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:HazardousItem/cbc:HazardClassID" mode="M20" priority="1048">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:HazardousItem/cbc:HazardClassID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:HazardousItem/*" mode="M20" priority="1047">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:HazardousItem/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B21301</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory" mode="M20" priority="1046">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B21601</xsl:attribute>
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
      <xsl:when test="cac:TaxScheme" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxScheme">
          <xsl:attribute name="id">PEPPOL-T19-B21602</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID" mode="M20" priority="1045">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent" mode="M20" priority="1044">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme" mode="M20" priority="1043">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B21901</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID" mode="M20" priority="1042">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/*" mode="M20" priority="1041">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B21902</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory/*" mode="M20" priority="1040">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ClassifiedTaxCategory/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B21603</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty" mode="M20" priority="1039">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T19-B22101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Value" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Value">
          <xsl:attribute name="id">PEPPOL-T19-B22102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Value' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cbc:ID" mode="M20" priority="1038">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cbc:Name" mode="M20" priority="1037">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cbc:NameCode" mode="M20" priority="1036">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cbc:NameCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="id">PEPPOL-T19-B22701</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cbc:Value" mode="M20" priority="1035">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cbc:Value" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity" mode="M20" priority="1034">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B23001</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B23002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier" mode="M20" priority="1033">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/*" mode="M20" priority="1032">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B22103</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturerParty" mode="M20" priority="1031">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName">
          <xsl:attribute name="id">PEPPOL-T19-B23301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturerParty/cac:PartyName" mode="M20" priority="1030">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturerParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T19-B23401</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturerParty/cac:PartyName/cbc:Name" mode="M20" priority="1029">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturerParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturerParty/*" mode="M20" priority="1028">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturerParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B23302</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance" mode="M20" priority="1027">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cbc:BestBeforeDate" mode="M20" priority="1026">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cbc:BestBeforeDate" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:LotIdentification" mode="M20" priority="1025">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:LotIdentification" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:LotNumberID" mode="M20" priority="1024">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:LotNumberID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:LotIdentification/*" mode="M20" priority="1023">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:LotIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B23801</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/*" mode="M20" priority="1022">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B23601</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate" mode="M20" priority="1021">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B24001</xsl:attribute>
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
      <xsl:when test="cbc:CertificateTypeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CertificateTypeCode">
          <xsl:attribute name="id">PEPPOL-T19-B24002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CertificateTypeCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CertificateType" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CertificateType">
          <xsl:attribute name="id">PEPPOL-T19-B24003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CertificateType' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:IssuerParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:IssuerParty">
          <xsl:attribute name="id">PEPPOL-T19-B24004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:IssuerParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cbc:ID" mode="M20" priority="1020">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cbc:CertificateTypeCode" mode="M20" priority="1019">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cbc:CertificateTypeCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clNA satisfies $code = normalize-space(text())) or (some $code in $clPackagingMarkedLabelAccreditationCode satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clNA satisfies $code = normalize-space(text())) or (some $code in $clPackagingMarkedLabelAccreditationCode satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B24201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'NA codes' or 'PackagingMarkedLabelAccreditationCode'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cbc:CertificateType" mode="M20" priority="1018">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cbc:CertificateType" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cbc:Remarks" mode="M20" priority="1017">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cbc:Remarks" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:IssuerParty" mode="M20" priority="1016">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:IssuerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName">
          <xsl:attribute name="id">PEPPOL-T19-B24501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:IssuerParty/cac:PartyName" mode="M20" priority="1015">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:IssuerParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T19-B24601</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:IssuerParty/cac:PartyName/cbc:Name" mode="M20" priority="1014">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:IssuerParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:IssuerParty/*" mode="M20" priority="1013">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:IssuerParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B24502</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:DocumentReference" mode="M20" priority="1012">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:DocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T19-B24801</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:DocumentReference/cbc:ID" mode="M20" priority="1011">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:DocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:DocumentReference/*" mode="M20" priority="1010">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/cac:DocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B24802</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/*" mode="M20" priority="1009">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Certificate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B24005</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Dimension" mode="M20" priority="1008">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Dimension" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:AttributeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AttributeID">
          <xsl:attribute name="id">PEPPOL-T19-B25001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:AttributeID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Dimension/cbc:AttributeID" mode="M20" priority="1007">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Dimension/cbc:AttributeID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL6313 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL6313 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T19-B25101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Measured attribute code (UNCL6313)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Dimension/cbc:Measure" mode="M20" priority="1006">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Dimension/cbc:Measure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B25201</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B25202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Dimension/cbc:Description" mode="M20" priority="1005">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Dimension/cbc:Description" />
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Dimension/cbc:MinimumMeasure" mode="M20" priority="1004">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Dimension/cbc:MinimumMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B25501</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B25502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Dimension/cbc:MaximumMeasure" mode="M20" priority="1003">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/cac:Dimension/cbc:MaximumMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T19-B25701</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T19-B25702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/cac:Item/*" mode="M20" priority="1002">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/cac:Item/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B17702</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/cac:CatalogueLine/*" mode="M20" priority="1001">
    <svrl:fired-rule context="/ubl:Catalogue/cac:CatalogueLine/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B11203</xsl:attribute>
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
<xsl:template match="/ubl:Catalogue/*" mode="M20" priority="1000">
    <svrl:fired-rule context="/ubl:Catalogue/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T19-B00110</xsl:attribute>
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
<xsl:variable name="CatalogueValidityStart" select="if(exists(/ubl:Catalogue/cac:ValidityPeriod/cbc:StartDate)) then number(translate(/ubl:Catalogue/cac:ValidityPeriod/cbc:StartDate,'-','')) else 0" />
  <xsl:variable name="CatalogueValidityEnd" select="if(exists(/ubl:Catalogue/cac:ValidityPeriod/cbc:EndDate)) then number(translate(/ubl:Catalogue/cac:ValidityPeriod/cbc:EndDate,'-','')) else 99999999" />

	<!--RULE -->
<xsl:template match="cbc:ProfileID" mode="M21" priority="1008">
    <svrl:fired-rule context="cbc:ProfileID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="some $p in tokenize('urn:fdc:peppol.eu:poacc:bis:catalogue_only:3 urn:fdc:peppol.eu:poacc:bis:catalogue_wo_response:3', '\s') satisfies $p = normalize-space(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $p in tokenize('urn:fdc:peppol.eu:poacc:bis:catalogue_only:3 urn:fdc:peppol.eu:poacc:bis:catalogue_wo_response:3', '\s') satisfies $p = normalize-space(.)">
          <xsl:attribute name="id">PEPPOL-T19-R017</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An order transaction SHALL use profile catalogue only or catalogue without response.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:CustomizationID" mode="M21" priority="1007">
    <svrl:fired-rule context="cbc:CustomizationID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:catalogue:3')" />
      <xsl:otherwise>
        <svrl:failed-assert test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:catalogue:3')">
          <xsl:attribute name="id">PEPPOL-T19-R018</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:poacc:trns:catalogue:3'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Catalogue/cac:ValidityPeriod" mode="M21" priority="1006">
    <svrl:fired-rule context="/ubl:Catalogue/cac:ValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$CatalogueValidityEnd >= $CatalogueValidityStart" />
      <xsl:otherwise>
        <svrl:failed-assert test="$CatalogueValidityEnd >= $CatalogueValidityStart">
          <xsl:attribute name="id">PEPPOL-T19-R001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>A validity period end date SHALL be later or equal to a validity period start date</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:SellerSupplierParty" mode="M21" priority="1005">
    <svrl:fired-rule context="cac:SellerSupplierParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)">
          <xsl:attribute name="id">PEPPOL-T19-R004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>A catalogue supplier SHALL contain the full name or an identifier</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:ContractorCustomerParty" mode="M21" priority="1004">
    <svrl:fired-rule context="cac:ContractorCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)">
          <xsl:attribute name="id">PEPPOL-T19-R005</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>A catalogue customer SHALL contain the full name or an identifier</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:CatalogueLine" mode="M21" priority="1003">
    <svrl:fired-rule context="cac:CatalogueLine" />
    <xsl:variable name="CatalogueLineValidityStart" select="if(exists(cac:LineValidityPeriod/cbc:StartDate)) then number(translate(cac:LineValidityPeriod/cbc:StartDate,'-','')) else $CatalogueValidityStart" />
    <xsl:variable name="CatalogueLineValidityEnd" select="if(exists(cac:LineValidityPeriod/cbc:EndDate)) then number(translate(cac:LineValidityPeriod/cbc:EndDate,'-','')) else $CatalogueValidityEnd" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:MaximumOrderQuantity) or number(cbc:MaximumOrderQuantity) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:MaximumOrderQuantity) or number(cbc:MaximumOrderQuantity) >= 0">
          <xsl:attribute name="id">PEPPOL-T19-R008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Maximum quantity SHALL be greater than zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:MinimumOrderQuantity) or number(cbc:MinimumOrderQuantity) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:MinimumOrderQuantity) or number(cbc:MinimumOrderQuantity) >= 0">
          <xsl:attribute name="id">PEPPOL-T19-R009</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Minimum quantity SHALL be greater than zero</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:MaximumOrderQuantity) or not(cbc:MinimumOrderQuantity) or number(cbc:MaximumOrderQuantity) >= number(cbc:MinimumOrderQuantity)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:MaximumOrderQuantity) or not(cbc:MinimumOrderQuantity) or number(cbc:MaximumOrderQuantity) >= number(cbc:MinimumOrderQuantity)">
          <xsl:attribute name="id">PEPPOL-T19-R010</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Maximum quantity SHALL be greater or equal to the Minimum quantity</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="($CatalogueLineValidityStart >= $CatalogueValidityStart) and ($CatalogueLineValidityStart &lt;= $CatalogueValidityEnd)              and ($CatalogueLineValidityEnd &lt;= $CatalogueValidityEnd) and ($CatalogueLineValidityEnd >= $CatalogueValidityStart)" />
      <xsl:otherwise>
        <svrl:failed-assert test="($CatalogueLineValidityStart >= $CatalogueValidityStart) and ($CatalogueLineValidityStart &lt;= $CatalogueValidityEnd) and ($CatalogueLineValidityEnd &lt;= $CatalogueValidityEnd) and ($CatalogueLineValidityEnd >= $CatalogueValidityStart)">
          <xsl:attribute name="id">PEPPOL-T19-R007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Catalogue line validity period SHALL be within the range of the whole catalogue validity period</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="($CatalogueLineValidityStart &lt;= $CatalogueLineValidityEnd)" />
      <xsl:otherwise>
        <svrl:failed-assert test="($CatalogueLineValidityStart &lt;= $CatalogueLineValidityEnd)">
          <xsl:attribute name="id">PEPPOL-T19-R013</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>A line validity period end date SHALL be later or equal to the line validity period start date
        </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:RequiredItemLocationQuantity" mode="M21" priority="1002">
    <svrl:fired-rule context="cac:RequiredItemLocationQuantity" />
    <xsl:variable name="CatalogueLineValidityStart" select="if(exists(../cac:LineValidityPeriod/cbc:StartDate)) then number(translate(../cac:LineValidityPeriod/cbc:StartDate,'-','')) else $CatalogueValidityStart" />
    <xsl:variable name="CatalogueLineValidityEnd" select="if(exists(../cac:LineValidityPeriod/cbc:EndDate)) then number(translate(../cac:LineValidityPeriod/cbc:EndDate,'-','')) else $CatalogueValidityEnd" />
    <xsl:variable name="CataloguePriceValidityStart" select="if(exists(cac:Price/cac:ValidityPeriod/cbc:StartDate)) then number(translate(cac:Price/cac:ValidityPeriod/cbc:StartDate,'-','')) else $CatalogueLineValidityStart" />
    <xsl:variable name="CataloguePriceValidityEnd" select="if(exists(cac:Price/cac:ValidityPeriod/cbc:EndDate)) then number(translate(cac:Price/cac:ValidityPeriod/cbc:EndDate,'-','')) else $CatalogueLineValidityEnd" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(cac:Price/cbc:PriceAmount) >=0" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(cac:Price/cbc:PriceAmount) >=0">
          <xsl:attribute name="id">PEPPOL-T19-R006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Prices of items SHALL not be negative</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="($CataloguePriceValidityStart >= $CatalogueLineValidityStart) and ($CataloguePriceValidityStart &lt;= $CatalogueLineValidityEnd)              and ($CataloguePriceValidityEnd &lt;= $CatalogueLineValidityEnd) and ($CataloguePriceValidityEnd >= $CatalogueLineValidityStart)" />
      <xsl:otherwise>
        <svrl:failed-assert test="($CataloguePriceValidityStart >= $CatalogueLineValidityStart) and ($CataloguePriceValidityStart &lt;= $CatalogueLineValidityEnd) and ($CataloguePriceValidityEnd &lt;= $CatalogueLineValidityEnd) and ($CataloguePriceValidityEnd >= $CatalogueLineValidityStart)">
          <xsl:attribute name="id">PEPPOL-T19-R011</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Price validity start date SHALL be within the range of the catalogue line or catalogue validity period</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="($CataloguePriceValidityStart &lt;= $CataloguePriceValidityEnd)" />
      <xsl:otherwise>
        <svrl:failed-assert test="($CataloguePriceValidityStart &lt;= $CataloguePriceValidityEnd)">
          <xsl:attribute name="id">PEPPOL-T19-R016</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>A price validity period end date SHALL be later or equal to the price validity period start date
        </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:ClassifiedTaxCategory" mode="M21" priority="1001">
    <svrl:fired-rule context="cac:ClassifiedTaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Percent or (normalize-space(cbc:ID)='O')" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Percent or (normalize-space(cbc:ID)='O')">
          <xsl:attribute name="id">PEPPOL-T19-R014</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Each Tax Category SHALL have a TAX category rate, except if the catalogue line is not subject to TAX.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(cbc:ID)='S') or (cbc:Percent) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(cbc:ID)='S') or (cbc:Percent) > 0">
          <xsl:attribute name="id">PEPPOL-T19-R015</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>When TAX category code is "Standard rated" (S) the TAX rate SHALL be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Item" mode="M21" priority="1000">
    <svrl:fired-rule context="cac:Item" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:StandardItemIdentification/cbc:ID) or (cac:SellersItemIdentification/cbc:ID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:StandardItemIdentification/cbc:ID) or (cac:SellersItemIdentification/cbc:ID)">
          <xsl:attribute name="id">PEPPOL-T19-R012</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Each item in a Catalogue line SHALL be identifiable by either "item sellers identifier" or "item standard identifier"</svrl:text>
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
