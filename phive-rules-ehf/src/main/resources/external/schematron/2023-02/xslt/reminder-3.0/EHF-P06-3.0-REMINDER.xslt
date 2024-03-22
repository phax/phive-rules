<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:u="utils" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
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
<xsl:function as="xs:boolean" name="u:abn">
    <xsl:param name="val" />
    <xsl:sequence select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 " />
</xsl:function>
  <xsl:function as="xs:integer" name="u:addPIVA">
    <xsl:param as="xs:string" name="arg" />
    <xsl:param as="xs:integer" name="pari" />
    <xsl:variable name="tappo" select="if (not($arg castable as xs:integer)) then 0 else 1" />
    <xsl:variable name="mapper" select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )" />
    <xsl:sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )" />
  </xsl:function>
  <xsl:function name="u:cat2str">
    <xsl:param name="cat" />
    <xsl:sequence select="concat(normalize-space($cat/cbc:ID), '-', round(xs:decimal($cat/cbc:Percent) * 1000000))" />
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
  <xsl:function as="xs:boolean" name="u:checkCodiceIPA">
    <xsl:param as="xs:string?" name="arg" />
    <xsl:variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</xsl:variable>
    <xsl:sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()" />
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
  <xsl:function as="xs:boolean" name="u:gln">
  <xsl:param name="val" />
  <xsl:variable name="length" select="string-length($val) - 1" />
  <xsl:variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 1, $length)) return $i -48)" />
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
  <xsl:function as="xs:boolean" name="u:mod97-0208">
    <xsl:param name="val" />
    <xsl:variable name="checkdigits" select="substring($val,9,2)" />
    <xsl:variable name="calculated_digits" select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))" />
    <xsl:sequence select="number($checkdigits) = number($calculated_digits)" />
  </xsl:function>
  <xsl:function as="xs:boolean" name="u:slack">
    <xsl:param as="xs:decimal" name="exp" />
    <xsl:param as="xs:decimal" name="val" />
    <xsl:param as="xs:decimal" name="slack" />
    <xsl:sequence select="xs:decimal($exp + $slack) >= $val and xs:decimal($exp - $slack) &lt;= $val" />
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
    <svrl:schematron-output schemaVersion="iso" title="EHF Reminder 3.0">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
      <svrl:ns-prefix-in-attribute-values prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" />
      <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
      <svrl:ns-prefix-in-attribute-values prefix="u" uri="utils" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M18" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M19" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M20" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>EHF Reminder 3.0</svrl:text>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="cbc:*" mode="M18" priority="1001">
    <svrl:fired-rule context="cbc:*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test=". != ''" />
      <xsl:otherwise>
        <svrl:failed-assert test=". != ''">
          <xsl:attribute name="id">EHF-COMMON-R001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST not contain empty elements.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cac:*" mode="M18" priority="1000">
    <svrl:fired-rule context="cac:*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(*) != 0" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(*) != 0">
          <xsl:attribute name="id">EHF-COMMON-R002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST not contain empty elements.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M18" priority="-1" />
  <xsl:template match="@*|node()" mode="M18" priority="-2">
    <xsl:apply-templates mode="M18" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->
<xsl:variable name="clICD" select="tokenize('0002 0003 0004 0005 0006 0007 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0018 0019 0020 0021 0022 0023 0024 0025 0026 0027 0028 0029 0030 0031 0032 0033 0034 0035 0036 0037 0038 0039 0040 0041 0042 0043 0044 0045 0046 0047 0048 0049 0050 0051 0052 0053 0054 0055 0056 0057 0058 0059 0060 0061 0062 0063 0064 0065 0066 0067 0068 0069 0070 0071 0072 0073 0074 0075 0076 0077 0078 0079 0080 0081 0082 0083 0084 0085 0086 0087 0088 0089 0090 0091 0093 0094 0095 0096 0097 0098 0099 0100 0101 0102 0104 0105 0106 0107 0108 0109 0110 0111 0112 0113 0114 0115 0116 0117 0118 0119 0120 0121 0122 0123 0124 0125 0126 0127 0128 0129 0130 0131 0132 0133 0134 0135 0136 0137 0138 0139 0140 0141 0142 0143 0144 0145 0146 0147 0148 0149 0150 0151 0152 0153 0154 0155 0156 0157 0158 0159 0160 0161 0162 0163 0164 0165 0166 0167 0168 0169 0170 0171 0172 0173 0174 0175 0176 0177 0178 0179 0180 0183 0184 0185 0186 0187 0188 0189 0190 0191 0192 0193 0194 0195 0196 0197 0198 0199 0200 0201 0202 0203 0204 0205 0206 0207 0208 0209 0210 0211 0212 0213 0214 0215 0216', '\s')" />
  <xsl:variable name="clUNECERec20" select="tokenize('10 11 13 14 15 20 21 22 23 24 25 27 28 33 34 35 37 38 40 41 56 57 58 59 60 61 74 77 80 81 85 87 89 91 1I 2A 2B 2C 2G 2H 2I 2J 2K 2L 2M 2N 2P 2Q 2R 2U 2X 2Y 2Z 3B 3C 4C 4G 4H 4K 4L 4M 4N 4O 4P 4Q 4R 4T 4U 4W 4X 5A 5B 5E 5J A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A2 A20 A21 A22 A23 A24 A26 A27 A28 A29 A3 A30 A31 A32 A33 A34 A35 A36 A37 A38 A39 A4 A40 A41 A42 A43 A44 A45 A47 A48 A49 A5 A53 A54 A55 A56 A59 A6 A68 A69 A7 A70 A71 A73 A74 A75 A76 A8 A84 A85 A86 A87 A88 A89 A9 A90 A91 A93 A94 A95 A96 A97 A98 A99 AA AB ACR ACT AD AE AH AI AK AL AMH AMP ANN APZ AQ AS ASM ASU ATM AWG AY AZ B1 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B3 B30 B31 B32 B33 B34 B35 B4 B41 B42 B43 B44 B45 B46 B47 B48 B49 B50 B52 B53 B54 B55 B56 B57 B58 B59 B60 B61 B62 B63 B64 B66 B67 B68 B69 B7 B70 B71 B72 B73 B74 B75 B76 B77 B78 B79 B8 B80 B81 B82 B83 B84 B85 B86 B87 B88 B89 B90 B91 B92 B93 B94 B95 B96 B97 B98 B99 BAR BB BFT BHP BIL BLD BLL BP BPM BQL BTU BUA BUI C0 C10 C11 C12 C13 C14 C15 C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C3 C30 C31 C32 C33 C34 C35 C36 C37 C38 C39 C40 C41 C42 C43 C44 C45 C46 C47 C48 C49 C50 C51 C52 C53 C54 C55 C56 C57 C58 C59 C60 C61 C62 C63 C64 C65 C66 C67 C68 C69 C7 C70 C71 C72 C73 C74 C75 C76 C78 C79 C8 C80 C81 C82 C83 C84 C85 C86 C87 C88 C89 C9 C90 C91 C92 C93 C94 C95 C96 C97 C99 CCT CDL CEL CEN CG CGM CKG CLF CLT CMK CMQ CMT CNP CNT COU CTG CTM CTN CUR CWA CWI D03 D04 D1 D10 D11 D12 D13 D15 D16 D17 D18 D19 D2 D20 D21 D22 D23 D24 D25 D26 D27 D29 D30 D31 D32 D33 D34 D36 D41 D42 D43 D44 D45 D46 D47 D48 D49 D5 D50 D51 D52 D53 D54 D55 D56 D57 D58 D59 D6 D60 D61 D62 D63 D65 D68 D69 D73 D74 D77 D78 D80 D81 D82 D83 D85 D86 D87 D88 D89 D91 D93 D94 D95 DAA DAD DAY DB DBM DBW DD DEC DG DJ DLT DMA DMK DMO DMQ DMT DN DPC DPR DPT DRA DRI DRL DT DTN DWT DZN DZP E01 E07 E08 E09 E10 E12 E14 E15 E16 E17 E18 E19 E20 E21 E22 E23 E25 E27 E28 E30 E31 E32 E33 E34 E35 E36 E37 E38 E39 E4 E40 E41 E42 E43 E44 E45 E46 E47 E48 E49 E50 E51 E52 E53 E54 E55 E56 E57 E58 E59 E60 E61 E62 E63 E64 E65 E66 E67 E68 E69 E70 E71 E72 E73 E74 E75 E76 E77 E78 E79 E80 E81 E82 E83 E84 E85 E86 E87 E88 E89 E90 E91 E92 E93 E94 E95 E96 E97 E98 E99 EA EB EQ F01 F02 F03 F04 F05 F06 F07 F08 F10 F11 F12 F13 F14 F15 F16 F17 F18 F19 F20 F21 F22 F23 F24 F25 F26 F27 F28 F29 F30 F31 F32 F33 F34 F35 F36 F37 F38 F39 F40 F41 F42 F43 F44 F45 F46 F47 F48 F49 F50 F51 F52 F53 F54 F55 F56 F57 F58 F59 F60 F61 F62 F63 F64 F65 F66 F67 F68 F69 F70 F71 F72 F73 F74 F75 F76 F77 F78 F79 F80 F81 F82 F83 F84 F85 F86 F87 F88 F89 F90 F91 F92 F93 F94 F95 F96 F97 F98 F99 FAH FAR FBM FC FF FH FIT FL FNU FOT FP FR FS FTK FTQ G01 G04 G05 G06 G08 G09 G10 G11 G12 G13 G14 G15 G16 G17 G18 G19 G2 G20 G21 G23 G24 G25 G26 G27 G28 G29 G3 G30 G31 G32 G33 G34 G35 G36 G37 G38 G39 G40 G41 G42 G43 G44 G45 G46 G47 G48 G49 G50 G51 G52 G53 G54 G55 G56 G57 G58 G59 G60 G61 G62 G63 G64 G65 G66 G67 G68 G69 G70 G71 G72 G73 G74 G75 G76 G77 G78 G79 G80 G81 G82 G83 G84 G85 G86 G87 G88 G89 G90 G91 G92 G93 G94 G95 G96 G97 G98 G99 GB GBQ GDW GE GF GFI GGR GIA GIC GII GIP GJ GL GLD GLI GLL GM GO GP GQ GRM GRN GRO GV GWH H03 H04 H05 H06 H07 H08 H09 H10 H11 H12 H13 H14 H15 H16 H18 H19 H20 H21 H22 H23 H24 H25 H26 H27 H28 H29 H30 H31 H32 H33 H34 H35 H36 H37 H38 H39 H40 H41 H42 H43 H44 H45 H46 H47 H48 H49 H50 H51 H52 H53 H54 H55 H56 H57 H58 H59 H60 H61 H62 H63 H64 H65 H66 H67 H68 H69 H70 H71 H72 H73 H74 H75 H76 H77 H79 H80 H81 H82 H83 H84 H85 H87 H88 H89 H90 H91 H92 H93 H94 H95 H96 H98 H99 HA HAD HBA HBX HC HDW HEA HGM HH HIU HKM HLT HM HMO HMQ HMT HPA HTZ HUR IA IE INH INK INQ ISD IU IUG IV J10 J12 J13 J14 J15 J16 J17 J18 J19 J2 J20 J21 J22 J23 J24 J25 J26 J27 J28 J29 J30 J31 J32 J33 J34 J35 J36 J38 J39 J40 J41 J42 J43 J44 J45 J46 J47 J48 J49 J50 J51 J52 J53 J54 J55 J56 J57 J58 J59 J60 J61 J62 J63 J64 J65 J66 J67 J68 J69 J70 J71 J72 J73 J74 J75 J76 J78 J79 J81 J82 J83 J84 J85 J87 J90 J91 J92 J93 J95 J96 J97 J98 J99 JE JK JM JNT JOU JPS JWL K1 K10 K11 K12 K13 K14 K15 K16 K17 K18 K19 K2 K20 K21 K22 K23 K26 K27 K28 K3 K30 K31 K32 K33 K34 K35 K36 K37 K38 K39 K40 K41 K42 K43 K45 K46 K47 K48 K49 K50 K51 K52 K53 K54 K55 K58 K59 K6 K60 K61 K62 K63 K64 K65 K66 K67 K68 K69 K70 K71 K73 K74 K75 K76 K77 K78 K79 K80 K81 K82 K83 K84 K85 K86 K87 K88 K89 K90 K91 K92 K93 K94 K95 K96 K97 K98 K99 KA KAT KB KBA KCC KDW KEL KGM KGS KHY KHZ KI KIC KIP KJ KJO KL KLK KLX KMA KMH KMK KMQ KMT KNI KNM KNS KNT KO KPA KPH KPO KPP KR KSD KSH KT KTN KUR KVA KVR KVT KW KWH KWN KWO KWS KWT KWY KX L10 L11 L12 L13 L14 L15 L16 L17 L18 L19 L2 L20 L21 L23 L24 L25 L26 L27 L28 L29 L30 L31 L32 L33 L34 L35 L36 L37 L38 L39 L40 L41 L42 L43 L44 L45 L46 L47 L48 L49 L50 L51 L52 L53 L54 L55 L56 L57 L58 L59 L60 L63 L64 L65 L66 L67 L68 L69 L70 L71 L72 L73 L74 L75 L76 L77 L78 L79 L80 L81 L82 L83 L84 L85 L86 L87 L88 L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 LA LAC LBR LBT LD LEF LF LH LK LM LN LO LP LPA LR LS LTN LTR LUB LUM LUX LY M1 M10 M11 M12 M13 M14 M15 M16 M17 M18 M19 M20 M21 M22 M23 M24 M25 M26 M27 M29 M30 M31 M32 M33 M34 M35 M36 M37 M38 M39 M4 M40 M41 M42 M43 M44 M45 M46 M47 M48 M49 M5 M50 M51 M52 M53 M55 M56 M57 M58 M59 M60 M61 M62 M63 M64 M65 M66 M67 M68 M69 M7 M70 M71 M72 M73 M74 M75 M76 M77 M78 M79 M80 M81 M82 M83 M84 M85 M86 M87 M88 M89 M9 M90 M91 M92 M93 M94 M95 M96 M97 M98 M99 MAH MAL MAM MAR MAW MBE MBF MBR MC MCU MD MGM MHZ MIK MIL MIN MIO MIU MKD MKM MKW MLD MLT MMK MMQ MMT MND MNJ MON MPA MQD MQH MQM MQS MQW MRD MRM MRW MSK MTK MTQ MTR MTS MTZ MVA MWH N1 N10 N11 N12 N13 N14 N15 N16 N17 N18 N19 N20 N21 N22 N23 N24 N25 N26 N27 N28 N29 N3 N30 N31 N32 N33 N34 N35 N36 N37 N38 N39 N40 N41 N42 N43 N44 N45 N46 N47 N48 N49 N50 N51 N52 N53 N54 N55 N56 N57 N58 N59 N60 N61 N62 N63 N64 N65 N66 N67 N68 N69 N70 N71 N72 N73 N74 N75 N76 N77 N78 N79 N80 N81 N82 N83 N84 N85 N86 N87 N88 N89 N90 N91 N92 N93 N94 N95 N96 N97 N98 N99 NA NAR NCL NEW NF NIL NIU NL NM3 NMI NMP NPT NT NTU NU NX OA ODE ODG ODK ODM OHM ON ONZ OPM OT OZA OZI P1 P10 P11 P12 P13 P14 P15 P16 P17 P18 P19 P2 P20 P21 P22 P23 P24 P25 P26 P27 P28 P29 P30 P31 P32 P33 P34 P35 P36 P37 P38 P39 P40 P41 P42 P43 P44 P45 P46 P47 P48 P49 P5 P50 P51 P52 P53 P54 P55 P56 P57 P58 P59 P60 P61 P62 P63 P64 P65 P66 P67 P68 P69 P70 P71 P72 P73 P74 P75 P76 P77 P78 P79 P80 P81 P82 P83 P84 P85 P86 P87 P88 P89 P90 P91 P92 P93 P94 P95 P96 P97 P98 P99 PAL PD PFL PGL PI PLA PO PQ PR PS PTD PTI PTL PTN Q10 Q11 Q12 Q13 Q14 Q15 Q16 Q17 Q18 Q19 Q20 Q21 Q22 Q23 Q24 Q25 Q26 Q27 Q28 Q29 Q30 Q31 Q32 Q33 Q34 Q35 Q36 Q37 Q38 Q39 Q40 Q41 Q42 Q3 QA QAN QB QR QTD QTI QTL QTR R1 R9 RH RM ROM RP RPM RPS RT S3 S4 SAN SCO SCR SEC SET SG SIE SM3 SMI SQ SQR SR STC STI STK STL STN STW SW SX SYR T0 T3 TAH TAN TI TIC TIP TKM TMS TNE TP TPI TPR TQD TRL TST TTS U1 U2 UB UC VA VLT VP W2 WA WB WCD WE WEB WEE WG WHR WM WSD WTT X1 YDK YDQ YRD Z11 Z9 ZP ZZ X1A X1B X1D X1F X1G X1W X2C X3A X3H X43 X44 X4A X4B X4C X4D X4F X4G X4H X5H X5L X5M X6H X6P X7A X7B X8A X8B X8C XAA XAB XAC XAD XAE XAF XAG XAH XAI XAJ XAL XAM XAP XAT XAV XB4 XBA XBB XBC XBD XBE XBF XBG XBH XBI XBJ XBK XBL XBM XBN XBO XBP XBQ XBR XBS XBT XBU XBV XBW XBX XBY XBZ XCA XCB XCC XCD XCE XCF XCG XCH XCI XCJ XCK XCL XCM XCN XCO XCP XCQ XCR XCS XCT XCU XCV XCW XCX XCY XCZ XDA XDB XDC XDG XDH XDI XDJ XDK XDL XDM XDN XDP XDR XDS XDT XDU XDV XDW XDX XDY XEC XED XEE XEF XEG XEH XEI XEN XFB XFC XFD XFE XFI XFL XFO XFP XFR XFT XFW XFX XGB XGI XGL XGR XGU XGY XGZ XHA XHB XHC XHG XHN XHR XIA XIB XIC XID XIE XIF XIG XIH XIK XIL XIN XIZ XJB XJC XJG XJR XJT XJY XKG XKI XLE XLG XLT XLU XLV XLZ XMA XMB XMC XME XMR XMS XMT XMW XMX XNA XNE XNF XNG XNS XNT XNU XNV XO1 XO2 XO3 XO4 XO5 XO6 XO7 XO8 XO9 XOA XOB XOC XOD XOE XOF XOG XOH XOI XOK XOJ XOL XOM XON XOP XOQ XOR XOS XOV XOW XOT XOU XOX XOY XOZ XP1 XP2 XP3 XP4 XPA XPB XPC XPD XPE XPF XPG XPH XPI XPJ XPK XPL XPN XPO XPP XPR XPT XPU XPV XPX XPY XPZ XQA XQB XQC XQD XQF XQG XQH XQJ XQK XQL XQM XQN XQP XQQ XQR XQS XRD XRG XRJ XRK XRL XRO XRT XRZ XSA XSB XSC XSD XSE XSH XSI XSK XSL XSM XSO XSP XSS XST XSU XSV XSW XSX XSY XSZ XT1 XTB XTC XTD XTE XTG XTI XTK XTL XTN XTO XTR XTS XTT XTU XTV XTW XTY XTZ XUC XUN XVA XVG XVI XVK XVL XVO XVP XVQ XVN XVR XVS XVY XWA XWB XWC XWD XWF XWG XWH XWJ XWK XWL XWM XWN XWP XWQ XWR XWS XWT XWU XWV XWW XWX XWY XWZ XXA XXB XXC XXD XXF XXG XXH XXJ XXK XYA XYB XYC XYD XYF XYG XYH XYJ XYK XYL XYM XYN XYP XYQ XYR XYS XYT XYV XYW XYX XYY XYZ XZA XZB XZC XZD XZF XZG XZH XZJ XZK XZL XZM XZN XZP XZQ XZR XZS XZT XZU XZV XZW XZX XZY XZZ', '\s')" />
  <xsl:variable name="clREMINDER_CHARGE" select="tokenize('REM', '\s')" />
  <xsl:variable name="clSEPA" select="tokenize('SEPA', '\s')" />
  <xsl:variable name="clUNCL5305" select="tokenize('AE E S Z G O K L M', '\s')" />
  <xsl:variable name="clUNCL5189" select="tokenize('41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 105', '\s')" />
  <xsl:variable name="cleas" select="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0147 0151 0170 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 9901 9902 9904 9905 9906 9907 9910 9913 9914 9915 9917 9918 9919 9920 9921 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9955 9956 9957 9958', '\s')" />
  <xsl:variable name="clUNCL7161" select="tokenize('AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CD CG CS CT DAB DAD DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ', '\s')" />
  <xsl:variable name="clUNECERec21" select="tokenize('1A 1B 1D 1F 1G 1W 2C 3A 3H 43 44 4A 4B 4C 4D 4F 4G 4H 5H 5L 5M 6H 6P 7A 7B 8A 8B 8C AA AB AC AD AE AF AG AH AI AJ AL AM AP AT AV B4 BA BB BC BD BE BF BG BH BI BJ BK BL BM BN BO BP BQ BR BS BT BU BV BW BX BY BZ CA CB CC CD CE CF CG CH CI CJ CK CL CM CN CO CP CQ CR CS CT CU CV CW CX CY CZ DA DB DC DG DH DI DJ DK DL DM DN DP DR DS DT DU DV DW DX DY EC ED EE EF EG EH EI EN FB FC FD FE FI FL FO FP FR FT FW FX GB GI GL GR GU GY GZ HA HB HC HG HN HR IA IB IC ID IE IF IG IH IK IL IN IZ JB JC JG JR JT JY KG KI LE LG LT LU LV LZ MA MB MC ME MR MS MT MW MX NA NE NF NG NS NT NU NV O1 O2 O3 O4 O5 O6 O7 O8 O9 OA OB OC OD OE OF OG OH OI OJ OK OL OM ON OP OQ OR OS OT OU OV OW OX OY OZ P1 P2 P3 P4 PA PB PC PD PE PF PG PH PI PJ PK PL PN PO PP PR PT PU PV PX PY PZ QA QB QC QD QF QG QH QJ QK QL QM QN QP QQ QR QS RD RG RJ RK RL RO RT RZ SA SB SC SD SE SH SI SK SL SM SO SP SS ST SU SV SW SX SY SZ T1 TB TC TD TE TG TI TK TL TN TO TR TS TT TU TV TW TY TZ UC UN VA VG VI VK VL VO VP VQ VN VR VS VY WA WB WC WD WF WG WH WJ WK WL WM WN WP WQ WR WS WT WU WV WW WX WY WZ XA XB XC XD XF XG XH XJ XK YA YB YC YD YF YG YH YJ YK YL YM YN YP YQ YR YS YT YV YW YX YY YZ ZA ZB ZC ZD ZF ZG ZH ZJ ZK ZL ZM ZN ZP ZQ ZR ZS ZT ZU ZV ZW ZX ZY ZZ', '\s')" />
  <xsl:variable name="clISO4217" select="tokenize('AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYN BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUC CUP CVE CZK DJF DKK DOP DZD EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LYD MAD MDL MGA MKD MMK MNT MOP MRU MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SLL SOS SRD SSP STN SVC SYP SZL THB TJS TMT TND TOP TRY TTD TWD TZS UAH UGX USD USN UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XOF XPD XPF XPT XSU XTS XUA YER ZAR ZMW ZWL', '\s')" />
  <xsl:variable name="clUNCL4461" select="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 70 74 75 76 77 78 91 92 93 94 95 96 97 ZZZ', '\s')" />
  <xsl:variable name="clISO3166" select="tokenize('AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW 1A XI', '\s')" />

	<!--RULE -->
<xsl:template match="/ubl:Invoice" mode="M19" priority="1343">
    <svrl:fired-rule context="/ubl:Invoice" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CustomizationID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CustomizationID">
          <xsl:attribute name="id">EHF-REMINDER-B00101</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B00102</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B00103</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B00104</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B00105</xsl:attribute>
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
      <xsl:when test="cac:BillingReference" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:BillingReference">
          <xsl:attribute name="id">EHF-REMINDER-B00106</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:BillingReference' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:AccountingSupplierParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:AccountingSupplierParty">
          <xsl:attribute name="id">EHF-REMINDER-B00107</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:AccountingSupplierParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:AccountingCustomerParty" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:AccountingCustomerParty">
          <xsl:attribute name="id">EHF-REMINDER-B00108</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:AccountingCustomerParty' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxTotal" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxTotal">
          <xsl:attribute name="id">EHF-REMINDER-B00109</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxTotal' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:LegalMonetaryTotal" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:LegalMonetaryTotal">
          <xsl:attribute name="id">EHF-REMINDER-B00110</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:LegalMonetaryTotal' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:InvoiceLine" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:InvoiceLine">
          <xsl:attribute name="id">EHF-REMINDER-B00111</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:InvoiceLine' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@*:schemaLocation)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@*:schemaLocation)">
          <xsl:attribute name="id">EHF-REMINDER-B00112</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST not contain schema location.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:CustomizationID" mode="M19" priority="1342">
    <svrl:fired-rule context="/ubl:Invoice/cbc:CustomizationID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(text()) = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:fdc:anskaffelser.no:2019:ehf:reminder:3.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(text()) = 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:fdc:anskaffelser.no:2019:ehf:reminder:3.0'">
          <xsl:attribute name="id">EHF-REMINDER-B00201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CustomizationID' MUST contain value 'urn:cen.eu:en16931:2017#compliant#urn:fdc:peppol.eu:2017:poacc:billing:3.0#conformant#urn:fdc:anskaffelser.no:2019:ehf:reminder:3.0'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:CustomizationID/*" mode="M19" priority="1341">
    <svrl:fired-rule context="/ubl:Invoice/cbc:CustomizationID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B00202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:ProfileID" mode="M19" priority="1340">
    <svrl:fired-rule context="/ubl:Invoice/cbc:ProfileID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(text()) = 'urn:fdc:anskaffelser.no:2019:ehf:postaward:g3:06:1.0'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(text()) = 'urn:fdc:anskaffelser.no:2019:ehf:postaward:g3:06:1.0'">
          <xsl:attribute name="id">EHF-REMINDER-B00301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ProfileID' MUST contain value 'urn:fdc:anskaffelser.no:2019:ehf:postaward:g3:06:1.0'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:ProfileID/*" mode="M19" priority="1339">
    <svrl:fired-rule context="/ubl:Invoice/cbc:ProfileID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B00302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:ID" mode="M19" priority="1338">
    <svrl:fired-rule context="/ubl:Invoice/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:ID/*" mode="M19" priority="1337">
    <svrl:fired-rule context="/ubl:Invoice/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B00401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:IssueDate" mode="M19" priority="1336">
    <svrl:fired-rule context="/ubl:Invoice/cbc:IssueDate" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:IssueDate/*" mode="M19" priority="1335">
    <svrl:fired-rule context="/ubl:Invoice/cbc:IssueDate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B00501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:DueDate" mode="M19" priority="1334">
    <svrl:fired-rule context="/ubl:Invoice/cbc:DueDate" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:DueDate/*" mode="M19" priority="1333">
    <svrl:fired-rule context="/ubl:Invoice/cbc:DueDate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B00601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:Note" mode="M19" priority="1332">
    <svrl:fired-rule context="/ubl:Invoice/cbc:Note" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:Note/*" mode="M19" priority="1331">
    <svrl:fired-rule context="/ubl:Invoice/cbc:Note/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B00701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:TaxPointDate" mode="M19" priority="1330">
    <svrl:fired-rule context="/ubl:Invoice/cbc:TaxPointDate" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:TaxPointDate/*" mode="M19" priority="1329">
    <svrl:fired-rule context="/ubl:Invoice/cbc:TaxPointDate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B00801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:DocumentCurrencyCode" mode="M19" priority="1328">
    <svrl:fired-rule context="/ubl:Invoice/cbc:DocumentCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO4217 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO4217 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-REMINDER-B00901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:DocumentCurrencyCode/*" mode="M19" priority="1327">
    <svrl:fired-rule context="/ubl:Invoice/cbc:DocumentCurrencyCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B00902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:TaxCurrencyCode" mode="M19" priority="1326">
    <svrl:fired-rule context="/ubl:Invoice/cbc:TaxCurrencyCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO4217 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO4217 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-REMINDER-B01001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:TaxCurrencyCode/*" mode="M19" priority="1325">
    <svrl:fired-rule context="/ubl:Invoice/cbc:TaxCurrencyCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B01002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:AccountingCost" mode="M19" priority="1324">
    <svrl:fired-rule context="/ubl:Invoice/cbc:AccountingCost" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:AccountingCost/*" mode="M19" priority="1323">
    <svrl:fired-rule context="/ubl:Invoice/cbc:AccountingCost/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B01101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:BuyerReference" mode="M19" priority="1322">
    <svrl:fired-rule context="/ubl:Invoice/cbc:BuyerReference" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cbc:BuyerReference/*" mode="M19" priority="1321">
    <svrl:fired-rule context="/ubl:Invoice/cbc:BuyerReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B01201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:BillingReference" mode="M19" priority="1320">
    <svrl:fired-rule context="/ubl:Invoice/cac:BillingReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:InvoiceDocumentReference" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:InvoiceDocumentReference">
          <xsl:attribute name="id">EHF-REMINDER-B01301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:InvoiceDocumentReference' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference" mode="M19" priority="1319">
    <svrl:fired-rule context="/ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B01401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID" mode="M19" priority="1318">
    <svrl:fired-rule context="/ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID/*" mode="M19" priority="1317">
    <svrl:fired-rule context="/ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B01501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate" mode="M19" priority="1316">
    <svrl:fired-rule context="/ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate/*" mode="M19" priority="1315">
    <svrl:fired-rule context="/ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B01601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/*" mode="M19" priority="1314">
    <svrl:fired-rule context="/ubl:Invoice/cac:BillingReference/cac:InvoiceDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B01402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:BillingReference/*" mode="M19" priority="1313">
    <svrl:fired-rule context="/ubl:Invoice/cac:BillingReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B01302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:ContractDocumentReference" mode="M19" priority="1312">
    <svrl:fired-rule context="/ubl:Invoice/cac:ContractDocumentReference" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B01701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:ContractDocumentReference/cbc:ID" mode="M19" priority="1311">
    <svrl:fired-rule context="/ubl:Invoice/cac:ContractDocumentReference/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:ContractDocumentReference/cbc:ID/*" mode="M19" priority="1310">
    <svrl:fired-rule context="/ubl:Invoice/cac:ContractDocumentReference/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B01801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:ContractDocumentReference/*" mode="M19" priority="1309">
    <svrl:fired-rule context="/ubl:Invoice/cac:ContractDocumentReference/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B01702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty" mode="M19" priority="1308">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Party" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Party">
          <xsl:attribute name="id">EHF-REMINDER-B01901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party" mode="M19" priority="1307">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">EHF-REMINDER-B02001</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B02002</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B02003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" mode="M19" priority="1306">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">EHF-REMINDER-B02101</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B02102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cbc:EndpointID/*" mode="M19" priority="1305">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cbc:EndpointID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B02103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification" mode="M19" priority="1304">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B02301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M19" priority="1303">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID) or (some $code in $clSEPA satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID) or (some $code in $clSEPA satisfies $code = @schemeID)">
          <xsl:attribute name="id">EHF-REMINDER-B02401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list' or 'SEPA indicator'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/*" mode="M19" priority="1302">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B02402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/*" mode="M19" priority="1301">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B02302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyName" mode="M19" priority="1300">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">EHF-REMINDER-B02601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name" mode="M19" priority="1299">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name/*" mode="M19" priority="1298">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B02701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyName/*" mode="M19" priority="1297">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B02602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" mode="M19" priority="1296">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">EHF-REMINDER-B02801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1295">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName/*" mode="M19" priority="1294">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:StreetName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B02901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1293">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName/*" mode="M19" priority="1292">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B03001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M19" priority="1291">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName/*" mode="M19" priority="1290">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CityName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B03101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1289">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone/*" mode="M19" priority="1288">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PostalZone/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B03201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1287">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity/*" mode="M19" priority="1286">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B03301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1285">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">EHF-REMINDER-B03401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1284">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line/*" mode="M19" priority="1283">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B03501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/*" mode="M19" priority="1282">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B03402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country" mode="M19" priority="1281">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">EHF-REMINDER-B03601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1280">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-REMINDER-B03701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode/*" mode="M19" priority="1279">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B03702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M19" priority="1278">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B03602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/*" mode="M19" priority="1277">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B02802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme" mode="M19" priority="1276">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">EHF-REMINDER-B03801</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B03802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" mode="M19" priority="1275">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID/*" mode="M19" priority="1274">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B03901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" mode="M19" priority="1273">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B04001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M19" priority="1272">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID/*" mode="M19" priority="1271">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B04101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M19" priority="1270">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B04002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/*" mode="M19" priority="1269">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B03803</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity" mode="M19" priority="1268">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">EHF-REMINDER-B04201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1267">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName/*" mode="M19" priority="1266">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B04301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1265">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">EHF-REMINDER-B04401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/*" mode="M19" priority="1264">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B04402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm" mode="M19" priority="1263">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm/*" mode="M19" priority="1262">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyLegalForm/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B04601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/*" mode="M19" priority="1261">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B04202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact" mode="M19" priority="1260">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name" mode="M19" priority="1259">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name/*" mode="M19" priority="1258">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B04801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone" mode="M19" priority="1257">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone/*" mode="M19" priority="1256">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Telephone/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B04901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1255">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail/*" mode="M19" priority="1254">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:ElectronicMail/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B05001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/*" mode="M19" priority="1253">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B04701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/*" mode="M19" priority="1252">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B02004</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/*" mode="M19" priority="1251">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingSupplierParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B01902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty" mode="M19" priority="1250">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Party" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Party">
          <xsl:attribute name="id">EHF-REMINDER-B05101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Party' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party" mode="M19" priority="1249">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:EndpointID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:EndpointID">
          <xsl:attribute name="id">EHF-REMINDER-B05201</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B05202</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B05203</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyLegalEntity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" mode="M19" priority="1248">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="id">EHF-REMINDER-B05301</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B05302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID/*" mode="M19" priority="1247">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cbc:EndpointID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B05303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" mode="M19" priority="1246">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B05501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" mode="M19" priority="1245">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">EHF-REMINDER-B05601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/*" mode="M19" priority="1244">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B05602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/*" mode="M19" priority="1243">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B05502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyName" mode="M19" priority="1242">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">EHF-REMINDER-B05801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name" mode="M19" priority="1241">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name/*" mode="M19" priority="1240">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B05901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyName/*" mode="M19" priority="1239">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B05802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" mode="M19" priority="1238">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">EHF-REMINDER-B06001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1237">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName/*" mode="M19" priority="1236">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:StreetName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B06101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1235">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName/*" mode="M19" priority="1234">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AdditionalStreetName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B06201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" mode="M19" priority="1233">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName/*" mode="M19" priority="1232">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CityName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B06301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1231">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone/*" mode="M19" priority="1230">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PostalZone/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B06401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1229">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity/*" mode="M19" priority="1228">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CountrySubentity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B06501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1227">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">EHF-REMINDER-B06601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1226">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line/*" mode="M19" priority="1225">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/cbc:Line/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B06701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/*" mode="M19" priority="1224">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B06602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country" mode="M19" priority="1223">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">EHF-REMINDER-B06801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1222">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-REMINDER-B06901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode/*" mode="M19" priority="1221">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B06902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" mode="M19" priority="1220">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B06802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/*" mode="M19" priority="1219">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B06002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" mode="M19" priority="1218">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">EHF-REMINDER-B07001</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B07002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" mode="M19" priority="1217">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID/*" mode="M19" priority="1216">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B07101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" mode="M19" priority="1215">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B07201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M19" priority="1214">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID/*" mode="M19" priority="1213">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B07301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M19" priority="1212">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B07202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/*" mode="M19" priority="1211">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B07003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity" mode="M19" priority="1210">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:RegistrationName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:RegistrationName">
          <xsl:attribute name="id">EHF-REMINDER-B07401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:RegistrationName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" mode="M19" priority="1209">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName/*" mode="M19" priority="1208">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:RegistrationName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B07501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1207">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">EHF-REMINDER-B07601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/*" mode="M19" priority="1206">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cbc:CompanyID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B07602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/*" mode="M19" priority="1205">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B07402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact" mode="M19" priority="1204">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name" mode="M19" priority="1203">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name/*" mode="M19" priority="1202">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B07901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telephone" mode="M19" priority="1201">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telephone" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telephone/*" mode="M19" priority="1200">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Telephone/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B08001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" mode="M19" priority="1199">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail/*" mode="M19" priority="1198">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:ElectronicMail/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B08101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/*" mode="M19" priority="1197">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/cac:Contact/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B07801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/*" mode="M19" priority="1196">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B05204</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/*" mode="M19" priority="1195">
    <svrl:fired-rule context="/ubl:Invoice/cac:AccountingCustomerParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B05102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty" mode="M19" priority="1194">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName">
          <xsl:attribute name="id">EHF-REMINDER-B08201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/cac:PartyIdentification" mode="M19" priority="1193">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/cac:PartyIdentification" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B08301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/cac:PartyIdentification/cbc:ID" mode="M19" priority="1192">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/cac:PartyIdentification/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID) or (some $code in $clSEPA satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID) or (some $code in $clSEPA satisfies $code = @schemeID)">
          <xsl:attribute name="id">EHF-REMINDER-B08401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list' or 'SEPA indicator'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/cac:PartyIdentification/cbc:ID/*" mode="M19" priority="1191">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/cac:PartyIdentification/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B08402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/cac:PartyIdentification/*" mode="M19" priority="1190">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/cac:PartyIdentification/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B08302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/cac:PartyName" mode="M19" priority="1189">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">EHF-REMINDER-B08601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/cac:PartyName/cbc:Name" mode="M19" priority="1188">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/cac:PartyName/cbc:Name/*" mode="M19" priority="1187">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/cac:PartyName/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B08701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/cac:PartyName/*" mode="M19" priority="1186">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/cac:PartyName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B08602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/cac:PartyLegalEntity" mode="M19" priority="1185">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/cac:PartyLegalEntity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">EHF-REMINDER-B08801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:CompanyID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID" mode="M19" priority="1184">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@schemeID) or (some $code in $clICD satisfies $code = @schemeID)">
          <xsl:attribute name="id">EHF-REMINDER-B08901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'ISO 6523 ICD list'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID/*" mode="M19" priority="1183">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/cac:PartyLegalEntity/cbc:CompanyID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B08902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/cac:PartyLegalEntity/*" mode="M19" priority="1182">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/cac:PartyLegalEntity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B08802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PayeeParty/*" mode="M19" priority="1181">
    <svrl:fired-rule context="/ubl:Invoice/cac:PayeeParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B08202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty" mode="M19" priority="1180">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PartyName" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyName">
          <xsl:attribute name="id">EHF-REMINDER-B09101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyName' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:PostalAddress" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PostalAddress">
          <xsl:attribute name="id">EHF-REMINDER-B09102</xsl:attribute>
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
      <xsl:when test="cac:PartyTaxScheme" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:PartyTaxScheme">
          <xsl:attribute name="id">EHF-REMINDER-B09103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:PartyTaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyName" mode="M19" priority="1179">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyName" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">EHF-REMINDER-B09201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Name' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyName/cbc:Name" mode="M19" priority="1178">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyName/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyName/cbc:Name/*" mode="M19" priority="1177">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyName/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B09301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyName/*" mode="M19" priority="1176">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B09202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress" mode="M19" priority="1175">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Country" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Country">
          <xsl:attribute name="id">EHF-REMINDER-B09401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Country' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:StreetName" mode="M19" priority="1174">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:StreetName" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:StreetName/*" mode="M19" priority="1173">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:StreetName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B09501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AdditionalStreetName" mode="M19" priority="1172">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AdditionalStreetName" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AdditionalStreetName/*" mode="M19" priority="1171">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:AdditionalStreetName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B09601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CityName" mode="M19" priority="1170">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CityName" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CityName/*" mode="M19" priority="1169">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CityName/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B09701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:PostalZone" mode="M19" priority="1168">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:PostalZone" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:PostalZone/*" mode="M19" priority="1167">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:PostalZone/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B09801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CountrySubentity" mode="M19" priority="1166">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CountrySubentity" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CountrySubentity/*" mode="M19" priority="1165">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cbc:CountrySubentity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B09901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine" mode="M19" priority="1164">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Line" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Line">
          <xsl:attribute name="id">EHF-REMINDER-B10001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Line' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine/cbc:Line" mode="M19" priority="1163">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine/cbc:Line" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine/cbc:Line/*" mode="M19" priority="1162">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine/cbc:Line/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B10101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine/*" mode="M19" priority="1161">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:AddressLine/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B10002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country" mode="M19" priority="1160">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:IdentificationCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:IdentificationCode">
          <xsl:attribute name="id">EHF-REMINDER-B10201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:IdentificationCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" mode="M19" priority="1159">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clISO3166 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-REMINDER-B10301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Country codes (ISO 3166-1:Alpha2)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode/*" mode="M19" priority="1158">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/cbc:IdentificationCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B10302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/*" mode="M19" priority="1157">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/cac:Country/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B10202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/*" mode="M19" priority="1156">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PostalAddress/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B09402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme" mode="M19" priority="1155">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:CompanyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:CompanyID">
          <xsl:attribute name="id">EHF-REMINDER-B10401</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B10402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID" mode="M19" priority="1154">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID/*" mode="M19" priority="1153">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cbc:CompanyID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B10501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme" mode="M19" priority="1152">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B10601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" mode="M19" priority="1151">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID/*" mode="M19" priority="1150">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B10701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/*" mode="M19" priority="1149">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B10602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/*" mode="M19" priority="1148">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/cac:PartyTaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B10403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty/*" mode="M19" priority="1147">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxRepresentativeParty/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B09104</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans" mode="M19" priority="1146">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:PaymentMeansCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:PaymentMeansCode">
          <xsl:attribute name="id">EHF-REMINDER-B10801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:PaymentMeansCode' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode" mode="M19" priority="1145">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL4461 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL4461 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-REMINDER-B10901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Payment means code (UNCL4461)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode/*" mode="M19" priority="1144">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cbc:PaymentMeansCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B10902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cbc:PaymentID" mode="M19" priority="1143">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cbc:PaymentID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cbc:PaymentID/*" mode="M19" priority="1142">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cbc:PaymentID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B11101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount" mode="M19" priority="1141">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B11201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID" mode="M19" priority="1140">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID/*" mode="M19" priority="1139">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B11301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name" mode="M19" priority="1138">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name/*" mode="M19" priority="1137">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B11401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch" mode="M19" priority="1136">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B11501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID" mode="M19" priority="1135">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/*" mode="M19" priority="1134">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B11601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/*" mode="M19" priority="1133">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B11502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/*" mode="M19" priority="1132">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B11202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentMeans/*" mode="M19" priority="1131">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentMeans/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B10802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentTerms" mode="M19" priority="1130">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentTerms" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Note" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Note">
          <xsl:attribute name="id">EHF-REMINDER-B11701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Note' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentTerms/cbc:Note" mode="M19" priority="1129">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentTerms/cbc:Note" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentTerms/cbc:Note/*" mode="M19" priority="1128">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentTerms/cbc:Note/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B11801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:PaymentTerms/*" mode="M19" priority="1127">
    <svrl:fired-rule context="/ubl:Invoice/cac:PaymentTerms/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B11702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge" mode="M19" priority="1126">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ChargeIndicator" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ChargeIndicator">
          <xsl:attribute name="id">EHF-REMINDER-B11901</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B11902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Amount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxCategory" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxCategory">
          <xsl:attribute name="id">EHF-REMINDER-B11903</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxCategory' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cbc:ChargeIndicator" mode="M19" priority="1125">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cbc:ChargeIndicator" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cbc:ChargeIndicator/*" mode="M19" priority="1124">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cbc:ChargeIndicator/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B12001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode" mode="M19" priority="1123">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL5189 satisfies $code = normalize-space(text())) or (some $code in $clUNCL7161 satisfies $code = normalize-space(text())) or (some $code in $clREMINDER_CHARGE satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL5189 satisfies $code = normalize-space(text())) or (some $code in $clUNCL7161 satisfies $code = normalize-space(text())) or (some $code in $clREMINDER_CHARGE satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-REMINDER-B12101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Allowance reason codes (UNCL5189 subset)' or 'Charge reason code (UNCL7161)' or 'Reminder charge reason code'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode/*" mode="M19" priority="1122">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B12102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReason" mode="M19" priority="1121">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReason" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReason/*" mode="M19" priority="1120">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cbc:AllowanceChargeReason/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B12201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cbc:MultiplierFactorNumeric" mode="M19" priority="1119">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cbc:MultiplierFactorNumeric" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cbc:MultiplierFactorNumeric/*" mode="M19" priority="1118">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cbc:MultiplierFactorNumeric/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B12301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cbc:Amount" mode="M19" priority="1117">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cbc:Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B12401</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B12402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cbc:Amount/*" mode="M19" priority="1116">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cbc:Amount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B12403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cbc:BaseAmount" mode="M19" priority="1115">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cbc:BaseAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B12601</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B12602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cbc:BaseAmount/*" mode="M19" priority="1114">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cbc:BaseAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B12603</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory" mode="M19" priority="1113">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B12801</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B12802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:ID" mode="M19" priority="1112">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-REMINDER-B12901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Duty or tax or fee category code (UNCL5305)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:ID/*" mode="M19" priority="1111">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B12902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent" mode="M19" priority="1110">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent/*" mode="M19" priority="1109">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B13001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" mode="M19" priority="1108">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B13101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID" mode="M19" priority="1107">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID/*" mode="M19" priority="1106">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B13201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/*" mode="M19" priority="1105">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B13102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/*" mode="M19" priority="1104">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/cac:TaxCategory/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B12803</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:AllowanceCharge/*" mode="M19" priority="1103">
    <svrl:fired-rule context="/ubl:Invoice/cac:AllowanceCharge/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B11904</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal" mode="M19" priority="1102">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TaxAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TaxAmount">
          <xsl:attribute name="id">EHF-REMINDER-B13301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TaxAmount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount" mode="M19" priority="1101">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B13401</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B13402</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount/*" mode="M19" priority="1100">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B13403</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal" mode="M19" priority="1099">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TaxableAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TaxableAmount">
          <xsl:attribute name="id">EHF-REMINDER-B13601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TaxableAmount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TaxAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TaxAmount">
          <xsl:attribute name="id">EHF-REMINDER-B13602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TaxAmount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:TaxCategory" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:TaxCategory">
          <xsl:attribute name="id">EHF-REMINDER-B13603</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxCategory' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount" mode="M19" priority="1098">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B13701</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B13702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount/*" mode="M19" priority="1097">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B13703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount" mode="M19" priority="1096">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B13901</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B13902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/*" mode="M19" priority="1095">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B13903</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory" mode="M19" priority="1094">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B14101</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B14102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID" mode="M19" priority="1093">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-REMINDER-B14201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Duty or tax or fee category code (UNCL5305)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID/*" mode="M19" priority="1092">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B14202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent" mode="M19" priority="1091">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent/*" mode="M19" priority="1090">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Percent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B14301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode" mode="M19" priority="1089">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode/*" mode="M19" priority="1088">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReasonCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B14401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReason" mode="M19" priority="1087">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReason" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReason/*" mode="M19" priority="1086">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TaxExemptionReason/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B14501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme" mode="M19" priority="1085">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B14601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID" mode="M19" priority="1084">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID/*" mode="M19" priority="1083">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B14701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/*" mode="M19" priority="1082">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B14602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/*" mode="M19" priority="1081">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B14103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/*" mode="M19" priority="1080">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B13604</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:TaxTotal/*" mode="M19" priority="1079">
    <svrl:fired-rule context="/ubl:Invoice/cac:TaxTotal/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B13302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal" mode="M19" priority="1078">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LineExtensionAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LineExtensionAmount">
          <xsl:attribute name="id">EHF-REMINDER-B14801</xsl:attribute>
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
      <xsl:when test="cbc:TaxExclusiveAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TaxExclusiveAmount">
          <xsl:attribute name="id">EHF-REMINDER-B14802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TaxExclusiveAmount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:TaxInclusiveAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:TaxInclusiveAmount">
          <xsl:attribute name="id">EHF-REMINDER-B14803</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:TaxInclusiveAmount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:PayableAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:PayableAmount">
          <xsl:attribute name="id">EHF-REMINDER-B14804</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:PayableAmount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount" mode="M19" priority="1077">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B14901</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B14902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount/*" mode="M19" priority="1076">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:LineExtensionAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B14903</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount" mode="M19" priority="1075">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B15101</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B15102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount/*" mode="M19" priority="1074">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B15103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount" mode="M19" priority="1073">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B15301</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B15302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount/*" mode="M19" priority="1072">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B15303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount" mode="M19" priority="1071">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B15501</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B15502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount/*" mode="M19" priority="1070">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B15503</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:ChargeTotalAmount" mode="M19" priority="1069">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:ChargeTotalAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B15701</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B15702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:ChargeTotalAmount/*" mode="M19" priority="1068">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:ChargeTotalAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B15703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PrepaidAmount" mode="M19" priority="1067">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PrepaidAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B15901</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B15902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PrepaidAmount/*" mode="M19" priority="1066">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PrepaidAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B15903</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount" mode="M19" priority="1065">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B16101</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B16102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount/*" mode="M19" priority="1064">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableRoundingAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B16103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount" mode="M19" priority="1063">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B16301</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B16302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount/*" mode="M19" priority="1062">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/cbc:PayableAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B16303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal/*" mode="M19" priority="1061">
    <svrl:fired-rule context="/ubl:Invoice/cac:LegalMonetaryTotal/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B14805</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine" mode="M19" priority="1060">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B16501</xsl:attribute>
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
      <xsl:when test="cbc:InvoicedQuantity" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:InvoicedQuantity">
          <xsl:attribute name="id">EHF-REMINDER-B16502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:InvoicedQuantity' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:LineExtensionAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:LineExtensionAmount">
          <xsl:attribute name="id">EHF-REMINDER-B16503</xsl:attribute>
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
      <xsl:when test="cac:Item" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Item">
          <xsl:attribute name="id">EHF-REMINDER-B16504</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Item' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cac:Price" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:Price">
          <xsl:attribute name="id">EHF-REMINDER-B16505</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:Price' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cbc:ID" mode="M19" priority="1059">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cbc:ID/*" mode="M19" priority="1058">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B16601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cbc:Note" mode="M19" priority="1057">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cbc:Note" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cbc:Note/*" mode="M19" priority="1056">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cbc:Note/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B16701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cbc:InvoicedQuantity" mode="M19" priority="1055">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cbc:InvoicedQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="id">EHF-REMINDER-B16801</xsl:attribute>
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
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode) or (some $code in $clUNECERec21 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode) or (some $code in $clUNECERec21 satisfies $code = @unitCode)">
          <xsl:attribute name="id">EHF-REMINDER-B16802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)' or 'Recommandation 21 (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cbc:InvoicedQuantity/*" mode="M19" priority="1054">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cbc:InvoicedQuantity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B16803</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cbc:LineExtensionAmount" mode="M19" priority="1053">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cbc:LineExtensionAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B17001</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B17002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cbc:LineExtensionAmount/*" mode="M19" priority="1052">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cbc:LineExtensionAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B17003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cbc:AccountingCost" mode="M19" priority="1051">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cbc:AccountingCost" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cbc:AccountingCost/*" mode="M19" priority="1050">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cbc:AccountingCost/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B17201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod" mode="M19" priority="1049">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate" mode="M19" priority="1048">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate/*" mode="M19" priority="1047">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/cbc:StartDate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B17401</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate" mode="M19" priority="1046">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate/*" mode="M19" priority="1045">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/cbc:EndDate/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B17501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/*" mode="M19" priority="1044">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:InvoicePeriod/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B17301</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge" mode="M19" priority="1043">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ChargeIndicator" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ChargeIndicator">
          <xsl:attribute name="id">EHF-REMINDER-B17601</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B17602</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Amount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:ChargeIndicator" mode="M19" priority="1042">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:ChargeIndicator" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:ChargeIndicator/*" mode="M19" priority="1041">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:ChargeIndicator/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B17701</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode" mode="M19" priority="1040">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL5189 satisfies $code = normalize-space(text())) or (some $code in $clUNCL7161 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL5189 satisfies $code = normalize-space(text())) or (some $code in $clUNCL7161 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-REMINDER-B17801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Allowance reason codes (UNCL5189 subset)' or 'Charge reason code (UNCL7161)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode/*" mode="M19" priority="1039">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B17802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReason" mode="M19" priority="1038">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReason" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReason/*" mode="M19" priority="1037">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReason/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B17901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric" mode="M19" priority="1036">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric/*" mode="M19" priority="1035">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B18001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount" mode="M19" priority="1034">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B18101</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B18102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount/*" mode="M19" priority="1033">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:Amount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B18103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount" mode="M19" priority="1032">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B18301</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B18302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount/*" mode="M19" priority="1031">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B18303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/*" mode="M19" priority="1030">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:AllowanceCharge/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B17603</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item" mode="M19" priority="1029">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:Name" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:Name">
          <xsl:attribute name="id">EHF-REMINDER-B18501</xsl:attribute>
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
      <xsl:when test="cac:ClassifiedTaxCategory" />
      <xsl:otherwise>
        <svrl:failed-assert test="cac:ClassifiedTaxCategory">
          <xsl:attribute name="id">EHF-REMINDER-B18502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:ClassifiedTaxCategory' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/cbc:Name" mode="M19" priority="1028">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cbc:Name" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/cbc:Name/*" mode="M19" priority="1027">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cbc:Name/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B18601</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory" mode="M19" priority="1026">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B18701</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B18702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cac:TaxScheme' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID" mode="M19" priority="1025">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))" />
      <xsl:otherwise>
        <svrl:failed-assert test="(some $code in $clUNCL5305 satisfies $code = normalize-space(text()))">
          <xsl:attribute name="id">EHF-REMINDER-B18801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Duty or tax or fee category code (UNCL5305)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID/*" mode="M19" priority="1024">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B18802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent" mode="M19" priority="1023">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/*" mode="M19" priority="1022">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cbc:Percent/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B18901</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme" mode="M19" priority="1021">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ID" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ID">
          <xsl:attribute name="id">EHF-REMINDER-B19001</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID" mode="M19" priority="1020">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID" />
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID/*" mode="M19" priority="1019">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/cbc:ID/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B19101</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/*" mode="M19" priority="1018">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/cac:TaxScheme/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B19002</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/*" mode="M19" priority="1017">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/cac:ClassifiedTaxCategory/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B18703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item/*" mode="M19" priority="1016">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Item/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B18503</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price" mode="M19" priority="1015">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:PriceAmount" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:PriceAmount">
          <xsl:attribute name="id">EHF-REMINDER-B19201</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:PriceAmount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/cbc:PriceAmount" mode="M19" priority="1014">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/cbc:PriceAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B19301</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B19302</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/cbc:PriceAmount/*" mode="M19" priority="1013">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/cbc:PriceAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B19303</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/cbc:BaseQuantity" mode="M19" priority="1012">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/cbc:BaseQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode) or (some $code in $clUNECERec21 satisfies $code = @unitCode)" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(@unitCode) or (some $code in $clUNECERec20 satisfies $code = @unitCode) or (some $code in $clUNECERec21 satisfies $code = @unitCode)">
          <xsl:attribute name="id">EHF-REMINDER-B19501</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Recommendation 20, including Recommendation 21 codes - prefixed with X (UN/ECE)' or 'Recommandation 21 (UN/ECE)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/cbc:BaseQuantity/*" mode="M19" priority="1011">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/cbc:BaseQuantity/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B19502</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge" mode="M19" priority="1010">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="cbc:ChargeIndicator" />
      <xsl:otherwise>
        <svrl:failed-assert test="cbc:ChargeIndicator">
          <xsl:attribute name="id">EHF-REMINDER-B19701</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B19702</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:Amount' MUST be provided.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator" mode="M19" priority="1009">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="normalize-space(text()) = 'false'" />
      <xsl:otherwise>
        <svrl:failed-assert test="normalize-space(text()) = 'false'">
          <xsl:attribute name="id">EHF-REMINDER-B19801</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Element 'cbc:ChargeIndicator' MUST contain value 'false'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator/*" mode="M19" priority="1008">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:ChargeIndicator/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B19802</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount" mode="M19" priority="1007">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B19901</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B19902</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount/*" mode="M19" priority="1006">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:Amount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B19903</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount" mode="M19" priority="1005">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="id">EHF-REMINDER-B20101</xsl:attribute>
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
          <xsl:attribute name="id">EHF-REMINDER-B20102</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Value MUST be part of code list 'Currency codes (ISO 4217)'.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount/*" mode="M19" priority="1004">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:BaseAmount/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B20103</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/*" mode="M19" priority="1003">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/cac:AllowanceCharge/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B19703</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price/*" mode="M19" priority="1002">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/cac:Price/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B19202</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/cac:InvoiceLine/*" mode="M19" priority="1001">
    <svrl:fired-rule context="/ubl:Invoice/cac:InvoiceLine/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B16506</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/ubl:Invoice/*" mode="M19" priority="1000">
    <svrl:fired-rule context="/ubl:Invoice/*" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="false()" />
      <xsl:otherwise>
        <svrl:failed-assert test="false()">
          <xsl:attribute name="id">EHF-REMINDER-B00113</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M19" priority="-1" />
  <xsl:template match="@*|node()" mode="M19" priority="-2">
    <xsl:apply-templates mode="M19" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" mode="M20" priority="1011">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())">
          <xsl:attribute name="id">EHF-COMMON-R003</xsl:attribute>
          <xsl:attribute name="flag">fatal</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>MUST be a valid Norwegian organization number. Only numerical value allowed</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="/*" mode="M20" priority="1010">
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
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" mode="M20" priority="1009">
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
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" mode="M20" priority="1008">
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
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
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
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
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
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
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
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
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
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
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
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
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
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']" mode="M20" priority="1001">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN'" />
      <xsl:otherwise>
        <svrl:failed-assert test="string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN'">
          <xsl:attribute name="id">PEPPOL-COMMON-R049</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Swedish organization number MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']" mode="M20" priority="1000">
    <svrl:fired-rule context="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="u:abn(normalize-space())" />
      <xsl:otherwise>
        <svrl:failed-assert test="u:abn(normalize-space())">
          <xsl:attribute name="id">PEPPOL-COMMON-R050</xsl:attribute>
          <xsl:attribute name="flag">warning</xsl:attribute>
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>Australian Business Number (ABN) MUST be stated in the correct format.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M20" priority="-1" />
  <xsl:template match="@*|node()" mode="M20" priority="-2">
    <xsl:apply-templates mode="M20" select="@*|*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
