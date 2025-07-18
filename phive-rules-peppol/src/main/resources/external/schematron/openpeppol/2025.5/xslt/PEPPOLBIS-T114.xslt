<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:u="utils" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:OrderChange-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
<xsl:key match="cac:LineItem" name="k_lineId" use="cbc:ID" />
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
    <svrl:schematron-output schemaVersion="iso" title="Rules for Peppol Order Change transaction 3.0">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:OrderChange-2" />
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
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="documents">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M22" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Rules for Peppol Order Change transaction 3.0</svrl:text>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="//*[not(*) and not(normalize-space())]" mode="M19" priority="1000">
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
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M19" priority="-1" />
  <xsl:template match="@*|node()" mode="M19" priority="-2">
    <xsl:apply-templates mode="M19" select="@*|*" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/*" mode="M20" priority="1011">
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" mode="M20" priority="1010">
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" mode="M20" priority="1009">
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" mode="M20" priority="1008">
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']" mode="M20" priority="1007">
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']" mode="M20" priority="1006">
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']" mode="M20" priority="1005">
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '9907']" mode="M20" priority="1004">
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']" mode="M20" priority="1003">
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '9906']" mode="M20" priority="1002">
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']" mode="M20" priority="1001">
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']" mode="M20" priority="1000">
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
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M20" priority="-1" />
  <xsl:template match="@*|node()" mode="M20" priority="-2">
    <xsl:apply-templates mode="M20" select="@*|*" />
  </xsl:template>

<!--PATTERN -->
<xsl:variable name="clUNCL7143" select="tokenize('AA AB AC AD AE AF AG AH AI AJ AK AL AM AN AO AP AQ AR AS AT AU AV AW AX AY AZ BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CC CG CL CR CV DR DW EC EF EMD EN FS GB GMN GN GS HS IB IN IS IT IZ MA MF MN MP NB ON PD PL PO PV QS RC RN RU RY SA SG SK SN SRS SRT SRU SRV SRW SRX SRY SRZ SS SSA SSB SSC SSD SSE SSF SSG SSH SSI SSJ SSK SSL SSM SSN SSO SSP SSQ SSR SSS SST SSU SSV SSW SSX SSY SSZ ST STA STB STC STD STE STF STG STH STI STJ STK STL STM STN STO STP STQ STR STS STT STU STV STW STX STY STZ SUA SUB SUC SUD SUE SUF SUG SUH SUI SUJ SUK SUL SUM TG TSN TSO TSP TSQ TSR TSS TST TSU UA UP VN VP VS VX ZZZ PPI', '\s')" />
  <xsl:variable name="clUNCL1229_CHANGE" select="tokenize('1 2 3 4 74', '\s')" />
  <xsl:variable name="clTrueFalse" select="tokenize('true false', '\s')" />
  <xsl:variable name="cleas" select="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0177 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 0218 0221 0230 0235 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959 0147 0154 0158 0170 0194 0203 0205 0217 0225 0240', '\s')" />
  <xsl:variable name="clUNCL5305" select="tokenize('AE E S Z G O K L M B', '\s')" />
  <xsl:variable name="clMimeCode" select="tokenize('application/pdf image/png image/jpeg image/tiff application/acad application/dwg drawing/dwg application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.oasis.opendocument.spreadsheet', '\s')" />
  <xsl:variable name="clUNCL7161" select="tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CD CG CS CT DAB DAD DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')" />
  <xsl:variable name="clISO4217" select="tokenize('AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLE SOS SRD SSP STN SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UYW UZS VED VES VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA YER ZAR ZMW ZWG XXX', '\s')" />
  <xsl:variable name="clICD" select="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216 0217 0218 0219 0220 0221 0222 0223 0224 0225 0226 0227 0228 0229 0230 0231 0232 0233 0234 0235 0236 0237 0238 0239 0240', '\s')" />
  <xsl:variable name="clISO3166" select="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')" />
  <xsl:variable name="clUNCL5189" select="tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')" />
  <xsl:variable name="clUNECERec20" select="tokenize('10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A53 A54 A55 A56 A59 A6 A68 A69 A7 A70 A71 A73 A74 A75 A76 A8 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B4 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DBM DBW DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FNU FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAD HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMO HMQ HMT HPA HTZ HUR HWE IA IE INH INK INQ ISD IU IUG IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWN KWO KWS KWT KWY KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MKD MKM MKW MLD MLT MMK MMQ MMT MND MNJ MON MPA MQD MQH MQM MQS MQW MRD MRM MRW MSK MTK MTQ MTR MTS MTZ MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NTU NU NX OA ODE ODG ODK ODM OHM ON ONZ OPM OT OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q41 Q42 Q3 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 YDK YDQ YRD Z11 Z9 ZP ZZ X1A X1B X1D X1F X1G X1W X2C X3A X3H X43 X44 X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XO1 XO2 XO3 XO4 XO5 XO6 XO7 XO8 XO9 XOA XOB XOC XOD XOE XOF XOG XOH XOI XOK XOJ XOL XOM XON XOP XOQ XOR XOS XOV XOW XOT XOU XOX XOY XOZ XP1 XP2 XP3 XP4 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSX XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVO XVP XVQ XVN XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY XZZ', '\s')" />

	<!--RULE -->
<xsl:template match="/ubl:OrderChange" mode="M21" priority="1344">
    <svrl:fired-rule context="/ubl:OrderChange" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CustomizationID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CustomizationID">
          <xsl:attribute name="id">PEPPOL-T114-B00101</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B00102</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B00103</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B00104</xsl:attribute>
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
      <xsl:when test="cbc:DocumentCurrencyCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:DocumentCurrencyCode">
          <xsl:attribute name="id">PEPPOL-T114-B00105</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:DocumentCurrencyCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:OrderReference" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:OrderReference">
          <xsl:attribute name="id">PEPPOL-T114-B00106</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:OrderReference' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:BuyerCustomerParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:BuyerCustomerParty">
          <xsl:attribute name="id">PEPPOL-T114-B00107</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:BuyerCustomerParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:SellerSupplierParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:SellerSupplierParty">
          <xsl:attribute name="id">PEPPOL-T114-B00108</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:SellerSupplierParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:OrderLine" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:OrderLine">
          <xsl:attribute name="id">PEPPOL-T114-B00109</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:OrderLine' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@*:schemaLocation)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@*:schemaLocation)">
          <xsl:attribute name="id">PEPPOL-T114-B00110</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST not contain schema location.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cbc:CustomizationID" mode="M21" priority="1343">
    <svrl:fired-rule context="/ubl:OrderChange/cbc:CustomizationID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:trns:order_change:3'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:trns:order_change:3'">
          <xsl:attribute name="id">PEPPOL-T114-B00201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CustomizationID' MUST contain value 'urn:fdc:peppol.eu:poacc:trns:order_change:3'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cbc:ProfileID" mode="M21" priority="1342">
    <svrl:fired-rule context="/ubl:OrderChange/cbc:ProfileID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:bis:advanced_ordering:3'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:bis:advanced_ordering:3'">
          <xsl:attribute name="id">PEPPOL-T114-B00301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:poacc:bis:advanced_ordering:3'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cbc:ID" mode="M21" priority="1341">
    <svrl:fired-rule context="/ubl:OrderChange/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cbc:SalesOrderID" mode="M21" priority="1340">
    <svrl:fired-rule context="/ubl:OrderChange/cbc:SalesOrderID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cbc:IssueDate" mode="M21" priority="1339">
    <svrl:fired-rule context="/ubl:OrderChange/cbc:IssueDate" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cbc:IssueTime" mode="M21" priority="1338">
    <svrl:fired-rule context="/ubl:OrderChange/cbc:IssueTime" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cbc:SequenceNumberID" mode="M21" priority="1337">
    <svrl:fired-rule context="/ubl:OrderChange/cbc:SequenceNumberID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cbc:Note" mode="M21" priority="1336">
    <svrl:fired-rule context="/ubl:OrderChange/cbc:Note" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cbc:DocumentCurrencyCode" mode="M21" priority="1335">
    <svrl:fired-rule context="/ubl:OrderChange/cbc:DocumentCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO4217 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO4217 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B01001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cbc:CustomerReference" mode="M21" priority="1334">
    <svrl:fired-rule context="/ubl:OrderChange/cbc:CustomerReference" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cbc:AccountingCost" mode="M21" priority="1333">
    <svrl:fired-rule context="/ubl:OrderChange/cbc:AccountingCost" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:ValidityPeriod" mode="M21" priority="1332">
    <svrl:fired-rule context="/ubl:OrderChange/cac:ValidityPeriod" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndDate">
          <xsl:attribute name="id">PEPPOL-T114-B01301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:EndDate' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:ValidityPeriod/cbc:EndDate" mode="M21" priority="1331">
    <svrl:fired-rule context="/ubl:OrderChange/cac:ValidityPeriod/cbc:EndDate" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:ValidityPeriod/*" mode="M21" priority="1330">
    <svrl:fired-rule context="/ubl:OrderChange/cac:ValidityPeriod/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B01302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderReference" mode="M21" priority="1329">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B01501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderReference/cbc:ID" mode="M21" priority="1328">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderReference/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderReference/*" mode="M21" priority="1327">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B01502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:QuotationDocumentReference" mode="M21" priority="1326">
    <svrl:fired-rule context="/ubl:OrderChange/cac:QuotationDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B01701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:QuotationDocumentReference/cbc:ID" mode="M21" priority="1325">
    <svrl:fired-rule context="/ubl:OrderChange/cac:QuotationDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:QuotationDocumentReference/*" mode="M21" priority="1324">
    <svrl:fired-rule context="/ubl:OrderChange/cac:QuotationDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B01702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorDocumentReference" mode="M21" priority="1323">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B01901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorDocumentReference/cbc:ID" mode="M21" priority="1322">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorDocumentReference/*" mode="M21" priority="1321">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B01902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AdditionalDocumentReference" mode="M21" priority="1320">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AdditionalDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B02101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AdditionalDocumentReference/cbc:ID" mode="M21" priority="1319">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AdditionalDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AdditionalDocumentReference/cbc:DocumentType" mode="M21" priority="1318">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AdditionalDocumentReference/cbc:DocumentType" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AdditionalDocumentReference/cac:Attachment" mode="M21" priority="1317">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AdditionalDocumentReference/cac:Attachment" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject" mode="M21" priority="1316">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AdditionalDocumentReference/cac:Attachment/cbc:EmbeddedDocumentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@mimeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@mimeCode">
          <xsl:attribute name="id">PEPPOL-T114-B02501</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B02502</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B02503</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'filename' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference" mode="M21" priority="1315">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:URI" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:URI">
          <xsl:attribute name="id">PEPPOL-T114-B02801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:URI' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI" mode="M21" priority="1314">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:URI" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/*" mode="M21" priority="1313">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B02802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AdditionalDocumentReference/cac:Attachment/*" mode="M21" priority="1312">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AdditionalDocumentReference/cac:Attachment/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B02401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AdditionalDocumentReference/*" mode="M21" priority="1311">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AdditionalDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B02102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Contract" mode="M21" priority="1310">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Contract" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B03001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Contract/cbc:ID" mode="M21" priority="1309">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Contract/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Contract/*" mode="M21" priority="1308">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Contract/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B03002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty" mode="M21" priority="1307">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Party" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Party">
          <xsl:attribute name="id">PEPPOL-T114-B03201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party" mode="M21" priority="1306">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">PEPPOL-T114-B03301</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B03302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID" mode="M21" priority="1305">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T114-B03401</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B03402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification" mode="M21" priority="1304">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B03601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M21" priority="1303">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T114-B03701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyName" mode="M21" priority="1302">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T114-B03901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name" mode="M21" priority="1301">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress" mode="M21" priority="1300">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T114-B04101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M21" priority="1299">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M21" priority="1298">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M21" priority="1297">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M21" priority="1296">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M21" priority="1295">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M21" priority="1294">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M21" priority="1293">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country" mode="M21" priority="1292">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T114-B04901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M21" priority="1291">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B05001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M21" priority="1290">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B04902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*" mode="M21" priority="1289">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B04102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme" mode="M21" priority="1288">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">PEPPOL-T114-B05101</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B05102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" mode="M21" priority="1287">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" mode="M21" priority="1286">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B05301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M21" priority="1285">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M21" priority="1284">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B05302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/*" mode="M21" priority="1283">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B05103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity" mode="M21" priority="1282">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T114-B05501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" mode="M21" priority="1281">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" mode="M21" priority="1280">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T114-B05701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M21" priority="1279">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T114-B05901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M21" priority="1278">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M21" priority="1277">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T114-B06101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M21" priority="1276">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B06201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M21" priority="1275">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B06102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M21" priority="1274">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B05902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/*" mode="M21" priority="1273">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B05502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:Contact" mode="M21" priority="1272">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:Contact" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Name" mode="M21" priority="1271">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Telephone" mode="M21" priority="1270">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" mode="M21" priority="1269">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:Contact/*" mode="M21" priority="1268">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B06301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/*" mode="M21" priority="1267">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/cac:Party/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B03303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:BuyerCustomerParty/*" mode="M21" priority="1266">
    <svrl:fired-rule context="/ubl:OrderChange/cac:BuyerCustomerParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B03202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty" mode="M21" priority="1265">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Party" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Party">
          <xsl:attribute name="id">PEPPOL-T114-B06701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party" mode="M21" priority="1264">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">PEPPOL-T114-B06801</xsl:attribute>
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
      <xsl:when test="cac:PostalAddress" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PostalAddress">
          <xsl:attribute name="id">PEPPOL-T114-B06802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PostalAddress' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyLegalEntity" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyLegalEntity">
          <xsl:attribute name="id">PEPPOL-T114-B06803</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cbc:EndpointID" mode="M21" priority="1263">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T114-B06901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification" mode="M21" priority="1262">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B07101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M21" priority="1261">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T114-B07201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyName" mode="M21" priority="1260">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T114-B07401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name" mode="M21" priority="1259">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress" mode="M21" priority="1258">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T114-B07601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M21" priority="1257">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M21" priority="1256">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M21" priority="1255">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M21" priority="1254">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M21" priority="1253">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M21" priority="1252">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M21" priority="1251">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country" mode="M21" priority="1250">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T114-B08401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M21" priority="1249">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B08501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M21" priority="1248">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B08402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*" mode="M21" priority="1247">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B07602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity" mode="M21" priority="1246">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T114-B08601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" mode="M21" priority="1245">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" mode="M21" priority="1244">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T114-B08801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M21" priority="1243">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T114-B09001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M21" priority="1242">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M21" priority="1241">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T114-B09201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M21" priority="1240">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B09301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M21" priority="1239">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B09202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M21" priority="1238">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B09002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/*" mode="M21" priority="1237">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B08602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:Contact" mode="M21" priority="1236">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:Contact" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Name" mode="M21" priority="1235">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Telephone" mode="M21" priority="1234">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail" mode="M21" priority="1233">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:Contact/*" mode="M21" priority="1232">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B09401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/*" mode="M21" priority="1231">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/cac:Party/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B06804</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:SellerSupplierParty/*" mode="M21" priority="1230">
    <svrl:fired-rule context="/ubl:OrderChange/cac:SellerSupplierParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B06702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty" mode="M21" priority="1229">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Party" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Party">
          <xsl:attribute name="id">PEPPOL-T114-B09801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party" mode="M21" priority="1228">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification" mode="M21" priority="1227">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B10001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M21" priority="1226">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T114-B10101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:PartyName" mode="M21" priority="1225">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T114-B10301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name" mode="M21" priority="1224">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:Contact" mode="M21" priority="1223">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:Contact" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Name" mode="M21" priority="1222">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Telephone" mode="M21" priority="1221">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" mode="M21" priority="1220">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:Contact/*" mode="M21" priority="1219">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B10501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/*" mode="M21" priority="1218">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty/cac:Party/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B09901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OriginatorCustomerParty/*" mode="M21" priority="1217">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OriginatorCustomerParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B09802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty" mode="M21" priority="1216">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Party" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Party">
          <xsl:attribute name="id">PEPPOL-T114-B10901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party" mode="M21" priority="1215">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PostalAddress" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PostalAddress">
          <xsl:attribute name="id">PEPPOL-T114-B11001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PostalAddress' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyLegalEntity" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyLegalEntity">
          <xsl:attribute name="id">PEPPOL-T114-B11002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" mode="M21" priority="1214">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or @schemeID = '0088'" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or @schemeID = '0088'">
          <xsl:attribute name="id">PEPPOL-T114-B11101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST contain value '0088'</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T114-B11102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" mode="M21" priority="1213">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B11301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M21" priority="1212">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T114-B11401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyName" mode="M21" priority="1211">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T114-B11601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name" mode="M21" priority="1210">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" mode="M21" priority="1209">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T114-B11801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M21" priority="1208">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M21" priority="1207">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M21" priority="1206">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M21" priority="1205">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M21" priority="1204">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M21" priority="1203">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M21" priority="1202">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country" mode="M21" priority="1201">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T114-B12601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M21" priority="1200">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B12701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M21" priority="1199">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B12602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/*" mode="M21" priority="1198">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B11802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" mode="M21" priority="1197">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">PEPPOL-T114-B12801</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B12802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" mode="M21" priority="1196">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" mode="M21" priority="1195">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B13001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M21" priority="1194">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M21" priority="1193">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B13002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/*" mode="M21" priority="1192">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B12803</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity" mode="M21" priority="1191">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">PEPPOL-T114-B13201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" mode="M21" priority="1190">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" mode="M21" priority="1189">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T114-B13401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress" mode="M21" priority="1188">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T114-B13601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" mode="M21" priority="1187">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" mode="M21" priority="1186">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T114-B13801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" mode="M21" priority="1185">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B13901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" mode="M21" priority="1184">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B13802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*" mode="M21" priority="1183">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B13602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/*" mode="M21" priority="1182">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B13202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:Contact" mode="M21" priority="1181">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:Contact" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name" mode="M21" priority="1180">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telephone" mode="M21" priority="1179">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" mode="M21" priority="1178">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:Contact/*" mode="M21" priority="1177">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B14001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/*" mode="M21" priority="1176">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/cac:Party/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B11003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AccountingCustomerParty/*" mode="M21" priority="1175">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AccountingCustomerParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B10902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery" mode="M21" priority="1174">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation" mode="M21" priority="1173">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Address" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Address">
          <xsl:attribute name="id">PEPPOL-T114-B14501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Address' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cbc:ID" mode="M21" priority="1172">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T114-B14601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cbc:Name" mode="M21" priority="1171">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address" mode="M21" priority="1170">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T114-B14901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName" mode="M21" priority="1169">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:StreetName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName" mode="M21" priority="1168">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName" mode="M21" priority="1167">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone" mode="M21" priority="1166">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity" mode="M21" priority="1165">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine" mode="M21" priority="1164">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T114-B15501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line" mode="M21" priority="1163">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country" mode="M21" priority="1162">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T114-B15701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode" mode="M21" priority="1161">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B15801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/*" mode="M21" priority="1160">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B15702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/*" mode="M21" priority="1159">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/cac:Address/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B14902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/*" mode="M21" priority="1158">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryLocation/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B14502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:RequestedDeliveryPeriod" mode="M21" priority="1157">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:RequestedDeliveryPeriod" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartDate" mode="M21" priority="1156">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartDate" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartTime" mode="M21" priority="1155">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartTime" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndDate" mode="M21" priority="1154">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndDate" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndTime" mode="M21" priority="1153">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndTime" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:RequestedDeliveryPeriod/*" mode="M21" priority="1152">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:RequestedDeliveryPeriod/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B15901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty" mode="M21" priority="1151">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName">
          <xsl:attribute name="id">PEPPOL-T114-B16401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PartyIdentification" mode="M21" priority="1150">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B16501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PartyIdentification/cbc:ID" mode="M21" priority="1149">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T114-B16601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PartyName" mode="M21" priority="1148">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T114-B16801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PartyName/cbc:Name" mode="M21" priority="1147">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress" mode="M21" priority="1146">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">PEPPOL-T114-B17001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:StreetName" mode="M21" priority="1145">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M21" priority="1144">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:CityName" mode="M21" priority="1143">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:PostalZone" mode="M21" priority="1142">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:CountrySubentity" mode="M21" priority="1141">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:AddressLine" mode="M21" priority="1140">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">PEPPOL-T114-B17601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M21" priority="1139">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:Country" mode="M21" priority="1138">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">PEPPOL-T114-B17801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M21" priority="1137">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B17901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:Country/*" mode="M21" priority="1136">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B17802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/*" mode="M21" priority="1135">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B17002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:Contact" mode="M21" priority="1134">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:Contact" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:Contact/cbc:Name" mode="M21" priority="1133">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:Contact/cbc:Telephone" mode="M21" priority="1132">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:Contact/cbc:ElectronicMail" mode="M21" priority="1131">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:Contact/*" mode="M21" priority="1130">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B18001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/*" mode="M21" priority="1129">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:DeliveryParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B16402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:Shipment" mode="M21" priority="1128">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:Shipment" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B18401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:Shipment/cbc:ID" mode="M21" priority="1127">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:Shipment/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:Shipment/cac:TransportHandlingUnit" mode="M21" priority="1126">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:Shipment/cac:TransportHandlingUnit" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cbc:ShippingMarks" mode="M21" priority="1125">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/cbc:ShippingMarks" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/*" mode="M21" priority="1124">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:Shipment/cac:TransportHandlingUnit/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B18601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/cac:Shipment/*" mode="M21" priority="1123">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/cac:Shipment/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B18402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:Delivery/*" mode="M21" priority="1122">
    <svrl:fired-rule context="/ubl:OrderChange/cac:Delivery/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B14401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:DeliveryTerms" mode="M21" priority="1121">
    <svrl:fired-rule context="/ubl:OrderChange/cac:DeliveryTerms" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:DeliveryTerms/cbc:ID" mode="M21" priority="1120">
    <svrl:fired-rule context="/ubl:OrderChange/cac:DeliveryTerms/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:DeliveryTerms/cbc:SpecialTerms" mode="M21" priority="1119">
    <svrl:fired-rule context="/ubl:OrderChange/cac:DeliveryTerms/cbc:SpecialTerms" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:DeliveryTerms/cac:DeliveryLocation" mode="M21" priority="1118">
    <svrl:fired-rule context="/ubl:OrderChange/cac:DeliveryTerms/cac:DeliveryLocation" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B19101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:DeliveryTerms/cac:DeliveryLocation/cbc:ID" mode="M21" priority="1117">
    <svrl:fired-rule context="/ubl:OrderChange/cac:DeliveryTerms/cac:DeliveryLocation/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:DeliveryTerms/cac:DeliveryLocation/*" mode="M21" priority="1116">
    <svrl:fired-rule context="/ubl:OrderChange/cac:DeliveryTerms/cac:DeliveryLocation/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B19102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:DeliveryTerms/*" mode="M21" priority="1115">
    <svrl:fired-rule context="/ubl:OrderChange/cac:DeliveryTerms/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B18801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:PaymentTerms" mode="M21" priority="1114">
    <svrl:fired-rule context="/ubl:OrderChange/cac:PaymentTerms" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Note" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Note">
          <xsl:attribute name="id">PEPPOL-T114-B19301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Note' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:PaymentTerms/cbc:Note" mode="M21" priority="1113">
    <svrl:fired-rule context="/ubl:OrderChange/cac:PaymentTerms/cbc:Note" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:PaymentTerms/*" mode="M21" priority="1112">
    <svrl:fired-rule context="/ubl:OrderChange/cac:PaymentTerms/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B19302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge" mode="M21" priority="1111">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ChargeIndicator" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ChargeIndicator">
          <xsl:attribute name="id">PEPPOL-T114-B19501</xsl:attribute>
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
      <xsl:when test="cbc:AllowanceChargeReason" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:AllowanceChargeReason">
          <xsl:attribute name="id">PEPPOL-T114-B19502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:AllowanceChargeReason' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Amount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Amount">
          <xsl:attribute name="id">PEPPOL-T114-B19503</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Amount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cbc:ChargeIndicator" mode="M21" priority="1110">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cbc:ChargeIndicator" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clTrueFalse satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clTrueFalse satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B19601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Boolean indicator (OpenPeppol)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode" mode="M21" priority="1109">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL5189 satisfies $code = normalize-space(text())) or (some $code in $clUNCL7161 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL5189 satisfies $code = normalize-space(text())) or (some $code in $clUNCL7161 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B19701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Allowance reason codes (UNCL5189 subset)' or 'Charge reason code (UNCL7161)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cbc:AllowanceChargeReason" mode="M21" priority="1108">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cbc:AllowanceChargeReason" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cbc:MultiplierFactorNumeric" mode="M21" priority="1107">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cbc:MultiplierFactorNumeric" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cbc:Amount" mode="M21" priority="1106">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cbc:Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B20001</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B20002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cbc:BaseAmount" mode="M21" priority="1105">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cbc:BaseAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B20201</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B20202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory" mode="M21" priority="1104">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B20401</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B20402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory/cbc:ID" mode="M21" priority="1103">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B20501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Duty or tax or fee category code (Subset of UNCL5305)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent" mode="M21" priority="1102">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" mode="M21" priority="1101">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B20701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID" mode="M21" priority="1100">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/*" mode="M21" priority="1099">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B20702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory/*" mode="M21" priority="1098">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/cac:TaxCategory/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B20403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge/*" mode="M21" priority="1097">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B19504</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:TaxTotal" mode="M21" priority="1096">
    <svrl:fired-rule context="/ubl:OrderChange/cac:TaxTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TaxAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TaxAmount">
          <xsl:attribute name="id">PEPPOL-T114-B20901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TaxAmount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:TaxTotal/cbc:TaxAmount" mode="M21" priority="1095">
    <svrl:fired-rule context="/ubl:OrderChange/cac:TaxTotal/cbc:TaxAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B21001</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B21002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:TaxTotal/*" mode="M21" priority="1094">
    <svrl:fired-rule context="/ubl:OrderChange/cac:TaxTotal/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B20902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AnticipatedMonetaryTotal" mode="M21" priority="1093">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AnticipatedMonetaryTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LineExtensionAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LineExtensionAmount">
          <xsl:attribute name="id">PEPPOL-T114-B21201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LineExtensionAmount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:PayableAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:PayableAmount">
          <xsl:attribute name="id">PEPPOL-T114-B21202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:PayableAmount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:LineExtensionAmount" mode="M21" priority="1092">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:LineExtensionAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B21301</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B21302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:TaxExclusiveAmount" mode="M21" priority="1091">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:TaxExclusiveAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B21501</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B21502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:TaxInclusiveAmount" mode="M21" priority="1090">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:TaxInclusiveAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B21701</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B21702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:AllowanceTotalAmount" mode="M21" priority="1089">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:AllowanceTotalAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B21901</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B21902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:ChargeTotalAmount" mode="M21" priority="1088">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:ChargeTotalAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B22101</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B22102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:PrepaidAmount" mode="M21" priority="1087">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:PrepaidAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B22301</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B22302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:PayableRoundingAmount" mode="M21" priority="1086">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:PayableRoundingAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B22501</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B22502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:PayableAmount" mode="M21" priority="1085">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/cbc:PayableAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B22701</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B22702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/*" mode="M21" priority="1084">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AnticipatedMonetaryTotal/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B21203</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine" mode="M21" priority="1083">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:LineItem" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:LineItem">
          <xsl:attribute name="id">PEPPOL-T114-B22901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:LineItem' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cbc:Note" mode="M21" priority="1082">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cbc:Note" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem" mode="M21" priority="1081">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B23101</xsl:attribute>
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
      <xsl:when test="cbc:LineStatusCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LineStatusCode">
          <xsl:attribute name="id">PEPPOL-T114-B23102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:LineStatusCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Quantity" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Quantity">
          <xsl:attribute name="id">PEPPOL-T114-B23103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Quantity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Item" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Item">
          <xsl:attribute name="id">PEPPOL-T114-B23104</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Item' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:ID" mode="M21" priority="1080">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:LineStatusCode" mode="M21" priority="1079">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:LineStatusCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL1229_CHANGE satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL1229_CHANGE satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B23301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Action code (UNCL1229) for Order Change'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:Quantity" mode="M21" priority="1078">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:Quantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T114-B23401</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B23402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount" mode="M21" priority="1077">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B23601</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B23602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:PartialDeliveryIndicator" mode="M21" priority="1076">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:PartialDeliveryIndicator" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clTrueFalse satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clTrueFalse satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B23801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Boolean indicator (OpenPeppol)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:AccountingCost" mode="M21" priority="1075">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:AccountingCost" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery" mode="M21" priority="1074">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cbc:ID" mode="M21" priority="1073">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T114-B24101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod" mode="M21" priority="1072">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartDate" mode="M21" priority="1071">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartDate" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartTime" mode="M21" priority="1070">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:StartTime" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndDate" mode="M21" priority="1069">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndDate" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndTime" mode="M21" priority="1068">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/cbc:EndTime" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/*" mode="M21" priority="1067">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/cac:RequestedDeliveryPeriod/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B24301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/*" mode="M21" priority="1066">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Delivery/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B24001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:OriginatorParty" mode="M21" priority="1065">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:OriginatorParty" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification" mode="M21" priority="1064">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B24901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification/cbc:ID" mode="M21" priority="1063">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">PEPPOL-T114-B25001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyName" mode="M21" priority="1062">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T114-B25201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyName/cbc:Name" mode="M21" priority="1061">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:OriginatorParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:OriginatorParty/*" mode="M21" priority="1060">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:OriginatorParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B24801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge" mode="M21" priority="1059">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ChargeIndicator" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ChargeIndicator">
          <xsl:attribute name="id">PEPPOL-T114-B25401</xsl:attribute>
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
      <xsl:when test="cbc:Amount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Amount">
          <xsl:attribute name="id">PEPPOL-T114-B25402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Amount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:ChargeIndicator" mode="M21" priority="1058">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:ChargeIndicator" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode" mode="M21" priority="1057">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL5189 satisfies $code = normalize-space(text())) or (some $code in $clUNCL7161 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL5189 satisfies $code = normalize-space(text())) or (some $code in $clUNCL7161 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B25601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Allowance reason codes (UNCL5189 subset)' or 'Charge reason code (UNCL7161)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:AllowanceChargeReason" mode="M21" priority="1056">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:AllowanceChargeReason" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:MultiplierFactorNumeric" mode="M21" priority="1055">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:MultiplierFactorNumeric" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:Amount" mode="M21" priority="1054">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B25901</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B25902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:BaseAmount" mode="M21" priority="1053">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/cbc:BaseAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B26101</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B26102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/*" mode="M21" priority="1052">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B25403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price" mode="M21" priority="1051">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:PriceAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:PriceAmount">
          <xsl:attribute name="id">PEPPOL-T114-B26301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:PriceAmount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cbc:PriceAmount" mode="M21" priority="1050">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cbc:PriceAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B26401</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B26402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cbc:BaseQuantity" mode="M21" priority="1049">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cbc:BaseQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode)">
          <xsl:attribute name="id">PEPPOL-T114-B26601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge" mode="M21" priority="1048">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ChargeIndicator" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ChargeIndicator">
          <xsl:attribute name="id">PEPPOL-T114-B26801</xsl:attribute>
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
      <xsl:when test="cbc:Amount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Amount">
          <xsl:attribute name="id">PEPPOL-T114-B26802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Amount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator" mode="M21" priority="1047">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(text()) = 'false'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(text()) = 'false'">
          <xsl:attribute name="id">PEPPOL-T114-B26901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ChargeIndicator' MUST contain value 'false'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:Amount" mode="M21" priority="1046">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B27001</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B27002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:BaseAmount" mode="M21" priority="1045">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/cbc:BaseAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">PEPPOL-T114-B27201</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B27202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 4217 Currency codes'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/*" mode="M21" priority="1044">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/cac:AllowanceCharge/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B26803</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/*" mode="M21" priority="1043">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Price/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B26302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item" mode="M21" priority="1042">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T114-B27401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cbc:Description" mode="M21" priority="1041">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cbc:Description" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cbc:Name" mode="M21" priority="1040">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:BuyersItemIdentification" mode="M21" priority="1039">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:BuyersItemIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B27701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:BuyersItemIdentification/cbc:ID" mode="M21" priority="1038">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:BuyersItemIdentification/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:BuyersItemIdentification/*" mode="M21" priority="1037">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:BuyersItemIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B27702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:SellersItemIdentification" mode="M21" priority="1036">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:SellersItemIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B27901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:SellersItemIdentification/cbc:ID" mode="M21" priority="1035">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:SellersItemIdentification/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:SellersItemIdentification/*" mode="M21" priority="1034">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:SellersItemIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B27902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification" mode="M21" priority="1033">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B28101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID" mode="M21" priority="1032">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">PEPPOL-T114-B28201</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B28202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/*" mode="M21" priority="1031">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:StandardItemIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B28102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference" mode="M21" priority="1030">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B28401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID" mode="M21" priority="1029">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/*" mode="M21" priority="1028">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemSpecificationDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B28402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification" mode="M21" priority="1027">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" mode="M21" priority="1026">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="id">PEPPOL-T114-B28701</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B28702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Item type identification code (UNCL7143)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification/*" mode="M21" priority="1025">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:CommodityClassification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B28601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory" mode="M21" priority="1024">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B29101</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B29102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:ID" mode="M21" priority="1023">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">PEPPOL-T114-B29201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Duty or tax or fee category code (Subset of UNCL5305)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent" mode="M21" priority="1022">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme" mode="M21" priority="1021">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-B29401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID" mode="M21" priority="1020">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/*" mode="M21" priority="1019">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B29402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/*" mode="M21" priority="1018">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ClassifiedTaxCategory/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B29103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty" mode="M21" priority="1017">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">PEPPOL-T114-B29601</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B29602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Value' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:ID" mode="M21" priority="1016">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:ID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:Name" mode="M21" priority="1015">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:Name" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:NameCode" mode="M21" priority="1014">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:NameCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="id">PEPPOL-T114-B30201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Attribute 'listID' MUST be present.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:Value" mode="M21" priority="1013">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:Value" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity" mode="M21" priority="1012">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:ValueQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">PEPPOL-T114-B30501</xsl:attribute>
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
          <xsl:attribute name="id">PEPPOL-T114-B30502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier" mode="M21" priority="1011">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/cbc:ValueQualifier" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/*" mode="M21" priority="1010">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:AdditionalItemProperty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B29603</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance" mode="M21" priority="1009">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cbc:SerialID" mode="M21" priority="1008">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cbc:SerialID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification" mode="M21" priority="1007">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:LotNumberID" mode="M21" priority="1006">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification/cbc:LotNumberID" />
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification/*" mode="M21" priority="1005">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/cac:LotIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B31001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/*" mode="M21" priority="1004">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/cac:ItemInstance/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B30801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/*" mode="M21" priority="1003">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:Item/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B27402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/cac:LineItem/*" mode="M21" priority="1002">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/cac:LineItem/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B23105</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:OrderLine/*" mode="M21" priority="1001">
    <svrl:fired-rule context="/ubl:OrderChange/cac:OrderLine/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B22902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/*" mode="M21" priority="1000">
    <svrl:fired-rule context="/ubl:OrderChange/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-B00111</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M21" priority="-1" />
  <xsl:template match="@*|node()" mode="M21" priority="-2">
    <xsl:apply-templates mode="M21" select="@*|*" />
  </xsl:template>

<!--PATTERN -->
<xsl:variable name="documentCurrencyCode" select="/ubl:OrderChange/cbc:DocumentCurrencyCode" />
  <xsl:variable name="sumLineExtensionAmount" select="if (/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount) then round(sum(/ubl:OrderChange/cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount/xs:decimal(.)) * 10 * 10) div 100 else 0" />
  <xsl:variable name="sumAllowance" select="if (/ubl:OrderChange/cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then round(sum(/ubl:OrderChange/cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100 else 0" />
  <xsl:variable name="sumCharge" select="if (/ubl:OrderChange/cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then round(sum(/ubl:OrderChange/cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100 else 0" />
  <xsl:variable name="TAXamount" select="if(/ubl:OrderChange/cac:TaxTotal/cbc:TaxAmount) then xs:decimal(/ubl:OrderChange/cac:TaxTotal/cbc:TaxAmount) else 0" />

	<!--RULE -->
<xsl:template match="cbc:ProfileID" mode="M22" priority="1015">
    <svrl:fired-rule context="cbc:ProfileID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="some $p in tokenize('urn:fdc:peppol.eu:poacc:bis:advanced_ordering:3', '\s') satisfies $p = normalize-space(.)" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $p in tokenize('urn:fdc:peppol.eu:poacc:bis:advanced_ordering:3', '\s') satisfies $p = normalize-space(.)">
          <xsl:attribute name="id">PEPPOL-T114-R031</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An order change transaction MUST use profile advanced_ordering.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:CustomizationID" mode="M22" priority="1014">
    <svrl:fired-rule context="cbc:CustomizationID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:order_change:3')" />
      <xsl:otherwise>
        <svrl:failed-assert test="starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:order_change:3')">
          <xsl:attribute name="id">PEPPOL-T114-R034</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Specification identifier MUST start with the value 'urn:fdc:peppol.eu:poacc:trns:order_change:3'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:Amount | cbc:TaxAmount | cbc:LineExtensionAmount | cbc:PriceAmount | cbc:BaseAmount | cac:AnticipatedMonetaryTotal/cbc:*" mode="M22" priority="1013">
    <svrl:fired-rule context="cbc:Amount | cbc:TaxAmount | cbc:LineExtensionAmount | cbc:PriceAmount | cbc:BaseAmount | cac:AnticipatedMonetaryTotal/cbc:*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@currencyID) or @currencyID = $documentCurrencyCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@currencyID) or @currencyID = $documentCurrencyCode">
          <xsl:attribute name="id">PEPPOL-T114-R003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An order MUST be stated in a single currency</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="ancestor::node()/local-name() = 'Price' or string-length(substring-after(., '.')) &lt;= 2" />
      <xsl:otherwise>
        <svrl:failed-assert test="ancestor::node()/local-name() = 'Price' or string-length(substring-after(., '.')) &lt;= 2">
          <xsl:attribute name="id">PEPPOL-T114-R028</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Elements of data type amount cannot have more than 2 decimals (I.e. all amounts except unit price amounts)</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="ubl:OrderChange" mode="M22" priority="1012">
    <svrl:fired-rule context="ubl:OrderChange" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:ValidityPeriod/cbc:EndDate" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:ValidityPeriod/cbc:EndDate">
          <xsl:attribute name="id">PEPPOL-T114-R002</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An order change SHOULD provide information about its validity end date.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:OriginatorCustomerParty" mode="M22" priority="1011">
    <svrl:fired-rule context="cac:OriginatorCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Party/cac:PartyName/cbc:Name or cac:Party/cac:PartyIdentification/cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Party/cac:PartyName/cbc:Name or cac:Party/cac:PartyIdentification/cbc:ID">
          <xsl:attribute name="id">PEPPOL-T114-R014</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>An order change MUST have the originator party name or an identifier</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']" mode="M22" priority="1010">
    <svrl:fired-rule context="cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="( contains( 'AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW',substring(cbc:CompanyID,1,2) ) )" />
      <xsl:otherwise>
        <svrl:failed-assert test="( contains( 'AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW',substring(cbc:CompanyID,1,2) ) )">
          <xsl:attribute name="id">PEPPOL-T114-R026</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>When TAX is VAT then Party VAT identifiers MUST have a prefix in accordance with ISO code ISO 3166-1 alpha-2 by which the country of issue may be identified. Nevertheless, Greece may use the prefix ‘EL’.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AnticipatedMonetaryTotal" mode="M22" priority="1009">
    <svrl:fired-rule context="cac:AnticipatedMonetaryTotal" />
    <xsl:variable name="payableAmount" select="xs:decimal(cbc:PayableAmount)" />
    <xsl:variable name="lineEtensionAmount" select="xs:decimal(cbc:LineExtensionAmount)" />
    <xsl:variable name="prepaidAmount" select="if (cbc:PrepaidAmount) then xs:decimal(cbc:PrepaidAmount) else 0" />
    <xsl:variable name="roundingAmount" select="if (cbc:PayableRoundingAmount) then xs:decimal(cbc:PayableRoundingAmount) else 0" />
    <xsl:variable name="taxinclusiveAmount" select="xs:decimal(cbc:TaxInclusiveAmount)" />
    <xsl:variable name="allowanceTotalAmount" select="if (cbc:AllowanceTotalAmount) then xs:decimal(cbc:AllowanceTotalAmount) else 0" />
    <xsl:variable name="chargeTotalAmount" select="if (cbc:ChargeTotalAmount) then xs:decimal(cbc:ChargeTotalAmount) else 0" />
    <xsl:variable name="taxexclusiveAmount" select="if(cbc:TaxExclusiveAmount) then xs:decimal(cbc:TaxExclusiveAmount) else ($lineEtensionAmount - $allowanceTotalAmount + $chargeTotalAmount)" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$payableAmount >=0" />
      <xsl:otherwise>
        <svrl:failed-assert test="$payableAmount >=0">
          <xsl:attribute name="id">PEPPOL-T114-R006</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Expected total amount for payment MUST NOT be negative</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$lineEtensionAmount >=0" />
      <xsl:otherwise>
        <svrl:failed-assert test="$lineEtensionAmount >=0">
          <xsl:attribute name="id">PEPPOL-T114-R007</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Expected total sum of line amounts MUST NOT be negative</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$lineEtensionAmount = $sumLineExtensionAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="$lineEtensionAmount = $sumLineExtensionAmount">
          <xsl:attribute name="id">PEPPOL-T114-R008</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Expected total sum of line amounts MUST equal the sum of the order line amounts at order line level</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$allowanceTotalAmount = $sumAllowance" />
      <xsl:otherwise>
        <svrl:failed-assert test="$allowanceTotalAmount = $sumAllowance">
          <xsl:attribute name="id">PEPPOL-T114-R009</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Expected total sum of allowance at document level MUST be equal to the sum of allowance amounts at document level</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$chargeTotalAmount= $sumCharge" />
      <xsl:otherwise>
        <svrl:failed-assert test="$chargeTotalAmount= $sumCharge">
          <xsl:attribute name="id">PEPPOL-T114-R010</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Expected total sum of charges at document level MUST be equal to the sum of charge amounts at document level</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="$taxexclusiveAmount = $lineEtensionAmount - $allowanceTotalAmount + $chargeTotalAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="$taxexclusiveAmount = $lineEtensionAmount - $allowanceTotalAmount + $chargeTotalAmount">
          <xsl:attribute name="id">PEPPOL-T114-R011</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Expected total amount without TAX = Expected total sum of line amounts - Sum of allowances on document level + Sum of charges on document level</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="if ($taxinclusiveAmount) then ($payableAmount = $taxinclusiveAmount - $prepaidAmount + $roundingAmount) else 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="if ($taxinclusiveAmount) then ($payableAmount = $taxinclusiveAmount - $prepaidAmount + $roundingAmount) else 1">
          <xsl:attribute name="id">PEPPOL-T114-R016</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Amount due for payment = Order change total amount with TAX - Paid amount + Rounding amount.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="if($taxinclusiveAmount and /ubl:OrderChange/cac:TaxTotal) then ($taxinclusiveAmount = $taxexclusiveAmount + $TAXamount) else 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="if($taxinclusiveAmount and /ubl:OrderChange/cac:TaxTotal) then ($taxinclusiveAmount = $taxexclusiveAmount + $TAXamount) else 1">
          <xsl:attribute name="id">PEPPOL-T114-R017</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Expected total amount with TAX = Expected total amount without TAX + Order total TAX amount.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | /ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]" mode="M22" priority="1008">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)] | /ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge[cbc:MultiplierFactorNumeric and not(cbc:BaseAmount)]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-R020</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Allowance/charge base amount MUST be provided when allowance/charge percentage is provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | /ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]" mode="M22" priority="1007">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount] | /ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge[not(cbc:MultiplierFactorNumeric) and cbc:BaseAmount]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">PEPPOL-T114-R021</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Allowance/charge percentage MUST be provided when allowance/charge base amount is provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:OrderChange/cac:AllowanceCharge |/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge" mode="M22" priority="1006">
    <svrl:fired-rule context="/ubl:OrderChange/cac:AllowanceCharge |/ubl:OrderChange/cac:OrderLine/cac:LineItem/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or u:slack(if (cbc:Amount) then cbc:Amount else 0, (xs:decimal(cbc:BaseAmount) * xs:decimal(cbc:MultiplierFactorNumeric)) div 100, 0.02)">
          <xsl:attribute name="id">PEPPOL-T114-R022</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Allowance/charge amount MUST equal base amount * percentage/100 if base amount and percentage exists</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="exists(cbc:AllowanceChargeReason) or exists(cbc:AllowanceChargeReasonCode)">
          <xsl:attribute name="id">PEPPOL-T114-R023</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Each document or line level allowance MUST have an allowance reason text or an allowance reason code.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(cbc:Amount) >= 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(cbc:Amount) >= 0">
          <xsl:attribute name="id">PEPPOL-T114-R032</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Allowance or charge amounts MUST NOT be negative.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:TaxCategory | cac:ClassifiedTaxCategory" mode="M22" priority="1005">
    <svrl:fired-rule context="cac:TaxCategory | cac:ClassifiedTaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Percent or (normalize-space(cbc:ID)='O')" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Percent or (normalize-space(cbc:ID)='O')">
          <xsl:attribute name="id">PEPPOL-T114-R029</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Each Tax Category MUST have a TAX category rate, except if the order is not subject to TAX.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(normalize-space(cbc:ID)='S') or (cbc:Percent) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(normalize-space(cbc:ID)='S') or (cbc:Percent) > 0">
          <xsl:attribute name="id">PEPPOL-T114-R030</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>When TAX category code is "Standard rated" (S) the TAX rate MUST be greater than zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:OrderLine/cac:LineItem" mode="M22" priority="1004">
    <svrl:fired-rule context="cac:OrderLine/cac:LineItem" />
    <xsl:variable name="lineExtensionAmount" select="if (cbc:LineExtensionAmount) then xs:decimal(cbc:LineExtensionAmount) else 0" />
    <xsl:variable name="quantity" select="if (cbc:Quantity) then xs:decimal(cbc:Quantity) else 1" />
    <xsl:variable name="priceAmount" select="if (cac:Price/cbc:PriceAmount) then xs:decimal(cac:Price/cbc:PriceAmount) else 0" />
    <xsl:variable name="baseQuantity" select="if (cac:Price/cbc:BaseQuantity and xs:decimal(cac:Price/cbc:BaseQuantity) != 0) then xs:decimal(cac:Price/cbc:BaseQuantity) else 1" />
    <xsl:variable name="allowancesTotal" select="if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']) then round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'false']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100 else 0" />
    <xsl:variable name="chargesTotal" select="if (cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']) then round(sum(cac:AllowanceCharge[normalize-space(cbc:ChargeIndicator) = 'true']/cbc:Amount/xs:decimal(.)) * 10 * 10) div 100 else 0" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:slack($lineExtensionAmount, ($quantity * ($priceAmount div $baseQuantity)) + $chargesTotal - $allowancesTotal, 0.02)">
          <xsl:attribute name="id">PEPPOL-T114-R024</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Order line net amount MUST equal (Ordered quantity * (Item net price/item price base quantity) + Order line charge amount - Order line allowance amount</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) > 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cac:Price/cbc:BaseQuantity) or xs:decimal(cac:Price/cbc:BaseQuantity) > 0">
          <xsl:attribute name="id">PEPPOL-T114-R025</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Base quantity MUST be a positive number above zero.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(key('k_lineId',cbc:ID)) = 1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(key('k_lineId',cbc:ID)) = 1">
          <xsl:attribute name="id">PEPPOL-T114-R001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Each order line MUST have a document line identifier that is unique within the order.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(cbc:Quantity) >=0" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(cbc:Quantity) >=0">
          <xsl:attribute name="id">PEPPOL-T114-R004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Each order line ordered quantity MUST not be negative</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Quantity" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Quantity">
          <xsl:attribute name="id">PEPPOL-T114-R013</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Each order line SHOULD have an ordered quantity</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Price/cac:AllowanceCharge" mode="M22" priority="1003">
    <svrl:fired-rule context="cac:Price/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(cbc:BaseAmount) or xs:decimal(../cbc:PriceAmount) = xs:decimal(cbc:BaseAmount) - xs:decimal(cbc:Amount)">
          <xsl:attribute name="id">PEPPOL-T114-R019</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Item net price MUST equal (Gross price - Allowance amount) when gross price is provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:Price" mode="M22" priority="1002">
    <svrl:fired-rule context="cac:Price" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(cbc:PriceAmount) >=0" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(cbc:PriceAmount) >=0">
          <xsl:attribute name="id">PEPPOL-T114-R005</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Each order line item net price MUST not be negative
        </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(cac:AllowanceCharge/cbc:BaseAmount) >= 0 or not(exists(cac:AllowanceCharge/cbc:BaseAmount))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(cac:AllowanceCharge/cbc:BaseAmount) >= 0 or not(exists(cac:AllowanceCharge/cbc:BaseAmount))">
          <xsl:attribute name="id">PEPPOL-T114-R027</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>The Item gross price MUST NOT be negative.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="number(cac:AllowanceCharge/cbc:Amount) >= 0 or not(exists(cac:AllowanceCharge/cbc:Amount))" />
      <xsl:otherwise>
        <svrl:failed-assert test="number(cac:AllowanceCharge/cbc:Amount) >= 0 or not(exists(cac:AllowanceCharge/cbc:Amount))">
          <xsl:attribute name="id">PEPPOL-T114-R033</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Allowance or charge amounts MUST NOT be negative.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode" mode="M22" priority="1001">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="                         some $code in $clUNCL5189                         satisfies normalize-space(text()) = $code" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $code in $clUNCL5189 satisfies normalize-space(text()) = $code">
          <xsl:attribute name="id">PEPPOL-T114-CL001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Reason code MUST be according to subset of UNCL 5189 D.16B.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode" mode="M22" priority="1000">
    <svrl:fired-rule context="cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="                         some $code in $clUNCL7161                         satisfies normalize-space(text()) = $code" />
      <xsl:otherwise>
        <svrl:failed-assert test="some $code in $clUNCL7161 satisfies normalize-space(text()) = $code">
          <xsl:attribute name="id">PEPPOL-T114-CL002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Reason code MUST be according to UNCL 7161 D.16B.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>
  <xsl:template match="text()" mode="M22" priority="-1" />
  <xsl:template match="@*|node()" mode="M22" priority="-2">
    <xsl:apply-templates mode="M22" select="@*|*" />
  </xsl:template>
</xsl:stylesheet>
